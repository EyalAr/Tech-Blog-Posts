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

Numerous libraries out there were built to provide new patterns for async code. All (most) of them provide some kind of mechanism for errors propagation and untangling of nested callbacks. Personally I have used extensively the [async](https://github.com/caolan/async) library which implements a good selection of asynchronous control flows (parallel, serial, waterfall, etc.); and an error propagation mechanism which allows handling of errors in one place (and to halt the control flow once an error occurs).

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

Other solutions use different approaches to achieve the same goals. The [promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) mechanism is one of these solutions, which became very prominent recently due to extensive usage in several projects (such as AngularJS).

With promises we wrap asynchronous code in a `promise` object. We defer the result of the asynchronous operation to a later time, at which the promise is 'resolved' (or 'rejected' on error). We can bind our own callbacks to events in the promise life (such as when it is resolved or rejected).

I am personally less fond of this mechanism, but it's important to be aware of it.