In this post I'll show you how to build a simple 10-lines Javascript library to handle asynchronous callbacks with the generators mechanism.

So, what are Javascript generators and why should you care?

## The short answer

...Because generators can make asynchronous code look attractive.

## The long answer

Anyone who's been working with Javascript / NodeJS for even a short while should be familiar with callbacks. A lot has been said about Javascript's callback mechanism; specifically about the code attractiveness (or lack thereof) when employing callbacks for serial asynchronous operations. A classic example is the one in which we use NodeJS to do a number of serial asynchronous IO calls:

```Javascript
var db = require('db');
db.get( /* some query */, function(err, result){
	/* handle error, and / or: */
	db.get( /* another query */, function(err, result){
		/* handle error, and / or: */
		db.insert( /* ... */, function(err){
			/* handle error, and / or: */
			db.update( /* ... */, function(err){
				/* ... */
			});
		});
	});
});
```

The code becomes extremely convoluted when the control flow becomes more complex and we have to handle errors in each step. To make the code more attractive we usually want two things:

1. Handling errors in one place.
2. Having a visual separation of logical blocks.

### How it was done before generators

Numerous libraries were built to provide new patterns for asynchronous code. All (most) of them provide some kind of mechanism for errors propagation and untangling of nested callbacks. Personally I have used extensively the [async](https://github.com/caolan/async) library which implements a good selection of asynchronous control flows (parallel, serial, waterfall, etc.); and an error propagation mechanism which allows handling of errors in one place (and to halt the control flow once an error occurs).

With 'async' the above example looks a bit more sane:

```Javascript
var db = require('db'),
    async = require('async');

async.waterfall([
	function(next){
		db.get( /* some query */, next);
	},

	function(result, next){
		db.get( /* another query */, next);
	},

	function(result, next){
		db.insert( /* ... */, next);
	},

	function(next){
		db.update( /* ... */, next);
	}
],
function(err){
	/* handle error */
});
```

Much better.

Other solutions use different approaches to achieve the same goals. The [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) mechanism is one of these solutions, which became very prominent recently; maybe due to extensive usage in several projects (such as AngularJS).

With promises we wrap asynchronous code in a `promise` object. We defer the result of the asynchronous operation to a later time, at which the promise is 'resolved' (or 'rejected' on error). We can bind our own callbacks to events in the promise life (such as when it is resolved or rejected).

Personally, I am less fond of this mechanism, but it's important to be aware of it.

All of these mechanisms don't introduce new functionalities to Javascript itself; but rather do sophisticated manipulations to our asynchronous functions in order to make our code more readable.

### How it's done after generators

First, let's discuss what are generators.

Generators are function-like entities which behave like iterators.

What are iterators? Iterators are entities which provide a sequential list of values. From the outside, an iterator is just an object with some methods to help us control it. For example, iterators have a `next()` method which we call to retrieve the next value. Obviously iterators have a state which is preserved between calls to `next()`.

This concept should be familiar for anyone coming from languages such as Python, Java, C++, etc. In those language iterators are implemented with classes which we use to generate these 'iterator' objects. They define the internals of the iterator (to make it stateful) and methods which the iterator must have according to the specifications of the language.

A generator is very much like an iterator, with the difference that the state is preserved in the scope of the defining function, instead of in some classed object. Much like an iterator *iterates* over some finite or infinite list of values, a generator *yields* the values. An iterator remembers its state between iterations by using some backing object; but a generator remembers its state by keeping the scope of the function suspended between *yields*. Once the generator is exhausted (which might never happen if it yields an infinite series of values) the function's scope will be cleared from the stack. In other words, the generator's function is allowed to run until it encounters a `yield` expression.

Let's illustrate. Following is a generator which generates an infinite series of even numbers, starting from some given number:

```Javascript
// the '*' indicates this is a generator
function * generateEvens(start) {
    if (start % 2 !== 0) start++;
    while (true) {
        yield start;
        start += 2;
    }
}

var evens = generateEvens(5);
evens.next().value; // 6
evens.next().value; // 8
evens.next().value; // 10
evens.next().value; // 12
```

Why is this important? I'll repeat:

> ...a generator remembers its state by keeping the scope of the function suspended between *yields*.

Imagine we could suspend the run of a function while it waits some asynchronous callback to complete. Well, with generators we can. And it's rather simple. But we'll get to that in a minute.

First we need to discuss how to transfer information to / from a generator. We already know that `next()` is used to get the next yielded value from the generator. We can also use `next( /* some value */ )` to send values back to the most recently called `yield` expression. Inside the generator function, whatever we send back with `next` will be evaluated as the result of the `yield` expression. This is very important, because it means that once the generator resumes from its suspended state in order to yield the next value, we can actually change its internal state.

OK, another example. This time we want to generate a series of even numbers, but be able to to reverse the order of iteration.

```Javascript
function * generateEvens(start) {
    var dir = 1; // up
    if (start % 2 !== 0) start++;
    while (true) {
        var tmp = yield start;
        if (tmp === 'up') dir = 1;
        if (tmp === 'down') dir = -1;
        start += dir * 2;
    }
}

var evens = generateEvens(5);
evens.next().value; // 6
evens.next().value; // 8
evens.next('down').value; // 6
evens.next().value; // 4
evens.next().value; // 2
evens.next('up').value; // 4
evens.next().value; // 6
```

So `yield start;` evaluates to whatever we send to `next()`. Pretty cool.

So what does all of this have to do with asynchronous code you ask? Good question. Many articles across the net show to how control the flow of asynchronous operations by using generators with promises; or show how to use some external libraries. But I want neither. I'm not a fan of promises, and I want to know what is actually going on behind the scenes. Apparently it's not very complicated.

Let's contrive another useless example:

```Javascript
var foo, bar;

function getFoo(callback) {
    setTimeout(function() {
        callback('hello');
    }, 200);
}

function getBar(callback) {
    setTimeout(function() {
        callback('world');
    }, 200);
}

getFoo(function(val) {
    foo = val
    getBar(function(val) {
        bar = val;
        console.log(foo, bar); // hello world
    });
});
```

As expected, after 400ms 'hello world' will be printed. Now let's use generators to make this code more readable.

We want to be able to suspend our code while we wait for the result of some asynchronous operation. We have already seen how generator functions can be suspended. Great, let's wrap our code with a generator function. Every time we need to wait for an asynchronous operation, we will call `yield`. Whenever the asynchronous operation finishes we will call `next()` with the result, thus passing the result back to our code.

We want something like this:

```Javascript
function * run (){
	var foo = yield getFoo();
	var bar = yield getBar();
	console.log(foo,bar);
};
run();
```

Running this code will do nothing, as we never actually call `next` to start and resume the generator. We need to do that from outside the generator. But timing is important. We must resume the generator only when the value from the asynchronous operation is ready. We have no choice but to delegate this responsibility to the asynchronous functions themselves. Luckily they accept a callback function which is run once the asynchronous operation is complete. Whenever they are ready with the value, they will resume our generator for us. In order to allow this, we will provide to the generator a special function `resume`. `resume` will be passed as a callback to the asynchronous functions.

```Javascript
var r = run(resume);
r.next(); // start

function resume(value) {
    r.next(value);
}

function * run(resume) {
    var foo = yield getFoo(resume);
    var bar = yield getBar(resume);
    console.log(foo, bar); // hello world
}
```

Simple. `resume` simply sends back the result (`value`) of the asynchronous operation back into the generator, in place of the last `yield` expression. Things are happening asynchronously, but instead of writing nested callbacks to react in a specific way to each asynchronous operation; we just wait for the operation to complete, send the result back to our main flow of control and continue as if things are happening synchronously.

Some may argue that imposing synchronicity on asynchronous operations defeats the purpose of asynchronicity. True. But that's not what happening here. We wait only when we must wait for an asynchronous operation to complete. Exactly as we would with classical nested callbacks.

### Make it a library

Taking the above example, we can build on it to handle any generator whatsoever. Let's build a NodeJS module to do that. We will show here only the basics, upon which we can build cool things like centralized errors handling, waiting for parallel asynchronous operations, etc. [See this repository for more](https://github.com/EyalAr/Subdue).

```Javascript
/*
 * Take a generator, provide it with a 'resume' function
 * and run it.
 *
 * assume callbacks are in standard NodeJS form:
 *
 *     function(err, result)
 *
 */
module.exports = function(generator){

    var run;

    function resume(err, result){

        // if the callback returned an error
        // make the generator throw it.
        if (err) return run.throw(err);

        // pass the result to the last 'yield'
        // expression by calling generator's
        // 'next' with the result
        run.next.call(run, result);

    }

    run = generator(resume);
    run.next(); // start the generator immediately

};
```

That's it. Of course a full fledged library has to deal with edge cases, validate arguments, etc. There are a few nice ones out there, such as [suspend](https://github.com/jmar777/suspend), [galaxy](https://github.com/bjouhier/galaxy) and [genny](https://github.com/spion/genny). Check them out.

### Where to go from here

Javascript generators are only available in engines that implement [ECMAScript 6](https://developer.mozilla.org/en/docs/Web/JavaScript/ECMAScript_6_support_in_Mozilla). You can grab the [latest version of NodeJS](http://nodejs.org/dist/) (at least 0.11) and start hacking. Remember to run node with the `--harmony` flag to have support for generators.