Title: Getting started with D3.js  
Date: 2014-04-15  
Category: Technical  
Tags:   
Slug: getting-started-with-d3js  
Author: Eyal Arubas  
Status: draft  

[D3.js][http://d3js.org/] stands for Data Driven Documents. It's a very comprehensive library which provides many tools for data-based calculations and document manipulations. It also handles (and that's one of its strong points) many of the math needed for the visualization of data. D3 has a steep learning curve, but once you experiment with it and manage to do simple visualization of some kind of data; the learning process will become much more compelling and interesting. That's the purpose of this post.

D3 handles any kind of document, be it HTML or SVG, and it's not exclusively used to create graphics. That being said, D3 lends itself very well for manipulation of shapes and graphical objects based on static and dynamic data. As such, D3 makes it possible to create very appealing documents.

SVG is one type of document which is often being used with D3. With SVG one can create graphical entities much like creating and styling HTML elements. In this article we will use SVG to visualize our data.

Data, naturally, has structure. And indeed the way with which D3 handles our dana is highly dependent on its structure. Before approaching the task of visualizing our data, we first have to decide on its structure. In D3 our data is no more than a collection of elements with some arbitrary properties which we decide upon. In order to make our code concise and elegant our data needs to be formatted in an efficient way.

For example, think of a collection of circles we want to draw on the screen. Let's say each circle is defined by it's center point coordinates. Each circle also has a radius and a color. How would we represent these circles as datums?

For the sake of this article, lets first describe a tedious way to do it. We will have four arrays - for the x coordinate, y coordinate, radius and color. To represent 3 circles we need the following data:

	#!javascript
	x = [1, 2, 3]; // x coordinates
	y = [1, 3, 2]; // y coordinates
	r = [5, 5, 5]; // radius
	c = ['red', 'green', 'blue']; // colors

Of course a more conceise way would be to define a 'circle' object, and have one array of such objects. The corresponding array according to this format is:

	#!javascript
	circles = [{
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
