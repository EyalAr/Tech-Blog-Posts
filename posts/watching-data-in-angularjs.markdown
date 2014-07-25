Building a UI which enables interaction with large amounts of data is not
trivial. Putting aside visual aspects, there is a technical challenge in
managing the rendering, monitoring and interaction with lots of datums.

People don't usually like to see a cluttered UI. And indeed, most well-designed
UIs display no more than a few tens of pieces of data. The numbers change,
however, when we need to display graphical information. In those cases, there
may be thousands of datums which need to be rendered, monitored for changes,
and interacted with.

In AngularJS we achieve responsiveness by watching for changes in data. Angular
does this by dirty-checking our objects. One of the major assumptions in
Angular's architecture is that although dirty-checking is slow, it's still fast
enough. "Fast enough" just means that humans won't notice the slowness. If a
response to some user's action takes
[less than 100ms](http://stackoverflow.com/a/2547903/1365324), it's fast enough.

But of course the amount of dirty-checks Angular needs to do varies from one
application to another; and depends on:

0. The amount of data in the application.
0. The structure of the data.
0. How we implement data-watching.

For UIs in which we have only a few tens of datums, modern Javascript engines
can do all the dirty-checks in well below 100ms. In those cases we usually don't
have to pay too much attention to how we watch data (although it's never bad to
be aware to how it's done); as even the slowest methods are still fast enough.

When our data grows bigger, then we start to notice performance differences
between different methods. This is especially true when we want to enable user
interactions with the data, as is often the case with graphical data.

We illustrate by example. Let's define a box:

```Javascript
var box = {
    color: ...,
    opened: true / false,
    items: [ ... ]
};
```

A box has a color, it can be opened or closed, and it contains some unknown
items.

Now let's say we have 400 boxes which we want to display to our users:

```Javascript
var boxes = [ /* an array of 400 boxes */ ];
```

We also want to provide a control panel to open boxes by their color.

In AngularJS we can implement this simple UI with two directives:

0. A directive to draw boxes.
0. A directive for the control panel with which we select the color of boxes to
   be opened.

We also have a simple parent controller for these two directives which enables
the communication. It serves three purposes:

0. Provides the `boxes` array to the first directive.
0. Provide a list of colors to the second directive.
0. Update the `boxes` array when the opened color changes.

```Javascript
function boxesCtrl($scope) {
    
    // get boxes from server
    $scope.boxes = [ /* 400 boxes */ ];

    // track which boxes are opened by color:
    $scope.colors = {
        list: [ /* list of colors */ ],
        opened: ...
    }

    $scope.$watch('colors.opened', function(color) {
        // update $scope.boxes according to the
        // currently opened color.
    });
    
}
```

The control panel directive is also straightforward, it should simple draw a
button to each of the colors, and enable to change the color of boxes to be
opened. Almost all the functionality is in the directive's template:

```HTML
<span ng-repeat="color in colors.list"
      ng-click="colors.opened = color"
      class="color-btn"
      style="background: {{color}};">
</span>
```

This is how it looks (try to click the buttons):

<iframe src="http://eyalar.github.io/Angular--watch-comparison/cp-prev.html" style="height:60px;"></iframe>

<iframe src="http://eyalar.github.io/Angular--watch-comparison/ng-repeat.html" style="height:500px;"></iframe>
<iframe src="http://eyalar.github.io/Angular--watch-comparison/deep-watch.html" style="height:500px;"></iframe>
<iframe src="http://eyalar.github.io/Angular--watch-comparison/shallow-watch.html" style="height:500px;"></iframe>
<iframe src="http://eyalar.github.io/Angular--watch-comparison/watch-collection.html" style="height:500px;"></iframe>
