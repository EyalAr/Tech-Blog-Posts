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

In this post I will show an example of a simple data-intensive application which
can be implemented in several ways; each of which has a different performance.
This will show how the structure of our data, the way we manipulate it and the
way we watch for changes can greatly affect the performance of our application.

We illustrate by example. Let's define our a basic type of datum, a box:

```Javascript
var box = {
  color: ...,
  opened: true / false,
  items: [...]
};
```

A box has a color, it can be opened or closed, and it contains some unknown
items (possible many items).

Now let's say we have many (hundreds or thousands) boxes which we want to
display to our users:

```Javascript
var boxes = [ /* an array of many boxes */ ];
```

We also want to provide a control panel to open boxes by their color.

In AngularJS we can implement this simple UI with two directives:

0. A directive to draw boxes.
0. A directive for the control panel with which we select the color of boxes to
   be opened.

We also have a simple parent controller for these two directives which enables
the communication. It serves three purposes:

0. To provide the `boxes` array to the first directive.
0. To provides a list of colors to the second directive.
0. To open and close boxes as the opened color changes. Or, in other words, to
   update the boxes in the `boxes` array.

```Javascript
// The parent controller:
function boxesCtrl($scope) {

  // get boxes from server
  $scope.boxes = [ /* boxes */ ];

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

The control panel directive is also straightforward, it should simply draw a
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

The last thing we are missing is the directive to draw the boxes. We have a few
options here. Basically we need to respond to changes in the `boxes` array and
update the DOM accordingly.

This actually depends on how we choose to update the boxes in the `boxes` array
at our parent controller. Every time the user chooses a different color to be
opened, we need to go through all the boxes and open / close them according to
their color.

The simplest way to do it would be to update the `opened` field of each box
object:

```Javascript
function boxesCtrl($scope) {

  /* ... */

  $scope.$watch('colors.opened', function(color) {
    $scope.boxes.forEach(function(box) {
      box.opened = box.color === color;
    });
  });

}
```

Now we can build our boxes rendering directive:

```Javascript
// boxes rendering directive:
function bxBoxes() {
  return {
    scope: {
      boxes: '=bxBoxes'
    },
    link: function(scope, rootEl, attrs) {
      scope.boxEls = [];
      scope.boxes.forEach(function(box) {
        var boxEl = /* build a DOM element for each box */;
        scope.boxEls.push(boxEl);
        rootEl.append(boxEl);
      });

      // update the dom when boxes are changed:
      scope.$watch('boxes', function(boxes) {
        scope.boxEls.forEach(function(boxEl, i) {
          if (boxes[i].opened) boxEl.addClass('opened');
          else boxEl.removeClass('opened');
        });
      }, true);
    },
  };
};
```

The result:

<iframe src="http://eyalar.github.io/Angular--watch-comparison/deep-watch.html" style="height:500px;"></iframe>

The response time to a button click is terrible. On my machine I got close to
350ms, which is unacceptable. Let's see why.

Our boxes rendering directive is responsible for, well, rendering boxes. But it
also needs to update rendered boxes when the underlying data changes. For this
to happen, we must watch for changes in data. Our `$watch` statement does
exactly that. Notice the `true` flag. Here we tell the `$watch` function to look
at the contents of the `boxes` array and detect for changes with
**deep-equality**. Without it the `$watch` statement would check for changes
with shallow-equality. In other words, it would only check if the **reference**
inside `scope.boxes` has changed. But since it's always the same array, no
change would be detected, and the UI would not be updated.

Doing dirty-checking with deep equality can be very expensive. We have to
compare the full structure of each `box` object, including the contents of each
of it's fields. But most of those checks are redundant in our case, since we
only care about the `opened` field. Let's see how we can be more efficient.

Since we only do basic HTML in this example, our directive can be as simple as
one `ng-repeat` statement. `ng-repeat` doesn't care about the deep structure of
our objects, but only about the two upper nested levels, which is exactly what
we need in order to detect changes in the `opened` field of each of the boxes.
Let's see it in action and then explain.

This time we can avoid manual Javascript DOM manipulations and write the
familiar `ng-repeat` markup:

```HTML
<span ng-repeat="box in boxes"
      class="box"
      style="background: {{box.color}}"
      ng-class="{'opened': box.opened}">
</span>
```

And the result:

<iframe src="http://eyalar.github.io/Angular--watch-comparison/ng-repeat.html" style="height:500px;"></iframe>

The response time is OK, but not great. On my machine I got about 80ms. We can
do a lot better. Let's take a close look at what's going on.

<iframe src="http://eyalar.github.io/Angular--watch-comparison/shallow-watch.html" style="height:500px;"></iframe>
<iframe src="http://eyalar.github.io/Angular--watch-comparison/watch-collection.html" style="height:500px;"></iframe>
