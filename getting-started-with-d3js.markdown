[D3.js](http://d3js.org/) stands for Data Driven Documents. It's a very comprehensive library which provides many tools for data-based calculations and document manipulations. It also handles (and that's one of its strong points) many of the math needed for the visualization of data. D3 has a steep learning curve, but once you experiment with it and manage to do simple visualization of some kind of data; the learning process will become much more compelling and interesting. That's the purpose of this post.

D3 handles any kind of document, be it HTML or SVG, and it's not exclusively used to create graphics. That being said, D3 lends itself very well for manipulation of shapes and graphical objects based on static and dynamic data. As such, D3 makes it possible to create very appealing documents.

SVG is one type of document which is often being used with D3. With SVG one can create graphical entities much like creating and styling HTML elements. In this article we will use SVG to visualize our data.

Data, naturally, has structure. And indeed the way with which D3 handles our dana is highly dependent on its structure. Before approaching the task of visualizing our data, we first have to decide on its structure. In D3 our data is no more than a collection of elements with some arbitrary properties which we decide upon. In order to make our code concise and elegant our data needs to be formatted in an efficient way.

For example, think of a collection of circles we want to draw on the screen. Let's say each circle is defined by it's center point coordinates. Each circle also has a radius and a color. How would we represent these circles as datums?

For the sake of this article, lets first describe a tedious way to do it. We will have four arrays - for the x coordinate, y coordinate, radius and color. To represent 3 circles we need the following data:

```Javascript
x = [1, 2, 3]; // x coordinates
y = [1, 3, 2]; // y coordinates
r = [5, 5, 5]; // radius
c = ['red', 'green', 'blue']; // colors
```

Of course a more concise way would be to define a 'circle' object, and have one array of such objects to represent our data. The corresponding array according to this format is:

```Javascript
data = [{
	x: 1,
	y: 1,
	r: 5,
	c: 'red'
}, {
	x: 2,
	y: 3,
	r: 5,
	c: 'green'
}, {
	x: 3,
	y: 2,
	r: 5,
	c: 'blue'
}];
```

Sometimes it's arguable which is the best way to represent our data. But as long as the data has a structure which encapsulates related fields in the same object, we should be OK. After working with D3 for a while you will be able to determine intuitively which structures to avoid and which structures will be better suited to some specific task.

Let's continue with the circles example. Now that we have our data, we would like to present it. D3 does not work on individual datums, but rather on data sets. This makes the task of keeping track of changes in data much simpler for us. In the lifespan of our data, there are three types of events:

1. Creation (or 'entering') of data.
2. Changing (or 'updating') existing data.
3. Removing (or 'exiting') existing data.

In order to keep track of our data, we need to provide D3 with some way of uniquely identifying our datums. We will discuss that later. First, we will show how to bind data to DOM elements.

As mentioned before, in this post we will use SVG. So let's start from the top. Let's say our HTML page contains an SVG element which we will use as our canvas:

```HTML
<svg id="canvas"></svg>
```

D3, like many other DOM manipulation libraries, provides us with methods to select DOM elements. Let's select our canvas so we can later add shapes to it:

```Javascript
var canvas = d3.select('#canvas');
```

The next step is to bind our circles data to DOM elements (or SVG shapes in our case).

```Javascript
var circles = canvas
	.selectAll('circle')
	.data(data);
```

Notice that we haven't actually created any new `circle` shapes yet. In the above statement all we do is tell D3 to bind our data array to `circle` SVG elements, **but not actually to create them**. This might be confusing, but the `selectAll` method acts as a selector, **not** as an actual object. And as with all selectors, it will not select anything that does not yet exist. Currently we have only prepared D3 for the possibility of selecting `circle` elements based on our data. We might consider it a virtual selection, as no `circle` elements actually exist yet.

Indeed, in order to have actual `circle` elements, we have to append them to our canvas. Let's do that:

```Javascript
circles
    .enter()
    .append('circle')
    .attr('cx', function(d) {
        return d.x;
    })
    .attr('cy', function(d) {
        return d.y;
    })
    .attr('fill', function(d){
        return d.c;
    })
    .attr('r', function(d) {
        return d.r;
    });
```

Remember the first type of event in a datum's lifespan - its creation. The creation of new data is referred to 'entering' in D3. In the above statement we tell D3 that upon `enter`ing of new data do the following:

1. Append a new `circle` element.
2. Set some of its attributes.

What the `enter` method does, in effect, is taking the selections (virtual or not) and filtering them such that only selections for new elements remain.

Notice that setting the attributes is done by the return value of a callback function. This function receives an argument `d` (which stands for *datum*). This allows us to set attributes which depend upon properties of the specific datum which is bound to the element.

The result (check out the [full code](https://github.com/EyalAr/D3.js-Example/blob/master/1.js)):

<iframe src="http://eyalar.github.io/D3.js-Example/index.html?1!0"></iframe>

Let's say we already have data and the corresponding circles drawn on our canvas; but now some of the data changed:

```Javascript
// change coordinates of the first circle:
data[0].x = 3;
data[0].y = 3;

// add a new circle:
data.push({
	x: 4,
	y: 2,
	r: 5,
	c: 'magenta'
});
```

 We want to reflect those changes in data in our canvas. First, we need to tell D3 about these changes. We saw before how to bind our data with `circle` elements. Let's do that again:

```Javascript
var circles = canvas
	.selectAll('circle')
	.data(data);
```

Unlike the previous time, this time not all of the datums in `data` are new. `data[1]` and `data[2]` represent the same circles as before. `data[0]` is also not new, just changed. `data[3]` is new. This time `selectAll` creates only one virtual selection for the last circle, but three actual selections for the already existing circles. Since only the last circle is new, if we run again `circles.enter()`, only one selection, for the new circle, will remain. So running again the following code will create only one new circle, which is exactly what we want:

```Javascript
circles
    .enter()
    .append('circle')
    // set attributes as before...
```

In order to update the existing circles we simply need to omit the `enter` filter:

```Javascript
// update (x,y) coordinates:
circles
    .attr('cx', function(d) {
        return d.x;
    })
    .attr('cy', function(d) {
        return d.y;
    });
```

The result ([full code](https://github.com/EyalAr/D3.js-Example/blob/master/2.js)):

<iframe src="http://eyalar.github.io/D3.js-Example/index.html?2!1"></iframe>

Similarly to the `enter` filter, we also have an `exit` filter; which filters the selection only to select elements which are bound to datums that no longer exist. This allows us to handle these 'orphan' elements. We can, for example, remove them from our canvas (and from the document altogether):

```Javascript
circles
    .exit()
    .remove();
```

In the above examples we used the `attr` method to set attributes of selected elements. For better visualization and user experience, we sometime want to gradually change attributes in a smooth animated way. We can create this experience by gradually setting the attributes from some initial value to a final value. Doing it manually would be tedious; which is why D3 provides us with the `transition` method. Any attribute that is set after we invoke `transition()` on the selection, will be set gradually instead of all at once.

We can use `transition` on our selections as before, and set different transitions for different selections. We might want different effects when new elements are created, than the effects when coordinates are changed.

Rewriting the above examples with transitions:

```Javascript
var circles = canvas
    .selectAll('circle')
    .data(data);

// update (x,y) coordinates of existing elements:
circles
    .transition()
    .attr('cx', function(d) {
        return d.x;
    })
    .attr('cy', function(d) {
        return d.y;
    });

// create new elements:
circles
    .enter()
    .append('circle')
    // set initial (pre-transition) attributes:
    .attr('cx', function(d) {
        return d.x;
    })
    .attr('cy', function(d) {
        return d.y;
    })
    .attr('fill', function(d){
        return d.c;
    })
    .attr('r', 0)
    // start transition:
    .transition()
    // set final (post transition) attributes:
    .attr('r', function(d) {
        return d.r;
    });
```

It's important to notice ... update / enter order.

Notice that up until now we gave D3 data, but didn't provide it with any method to uniquely identifying datums.