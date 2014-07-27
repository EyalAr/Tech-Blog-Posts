Building a UI which enables interaction with large amounts of data is not
trivial. Putting aside visual aspects, there is a technical challenge in
managing the rendering, monitoring and interaction with lots of datums.

People don't usually like to see a cluttered UI. And indeed, most well-designed
UIs display no more than a few tens of pieces of data. The numbers change,
however, when we need to display graphical information. In those cases, there
may be thousands of datums which need to be rendered, monitored for changes,
and interacted with.

In AngularJS we achieve responsiveness by continuously watching for changes in
data. Angular does this by dirty-checking our objects in each and every
iteration of the
[digest cycle](https://docs.angularjs.org/api/ng/type/$rootScope.Scope#$digest).
One of the major assumptions in Angular's architecture is that although
dirty-checking is slow, it's still fast enough. "Fast enough" just means that
people won't notice the slowness. If a response to some user's action takes
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

We illustrate by example. Let's define our basic type of datum, a box:

```Javascript
var box = {
  color: /* color */,
  opened: /* true or false */,
  items: [ /* some arbitrary data */]
};
```

A box has a color, it can be opened or closed, and it contains some unknown
items (possible many items).

Now let's say we have many (hundreds or thousands) boxes which we want to
display to our users:

```Javascript
var boxes = [ /* an array of many boxes */ ];
```

Each box will be drawn on the screen according to its color; unless the box is
'open', in which case it will be black.

We want to provide a control panel to open boxes by their color.

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
    opened: /* color */
  }
  $scope.$watch('colors.opened', function(color) {
    // update $scope.boxes according to the
    // currently opened color.
  });

}
```

The control panel directive is also straightforward, it should simply draw a
button for each of the colors, and enable to select a color of boxes to be
opened. Almost all the functionality is in the directive's template:

```HTML
<span ng-repeat="color in colors.list"
      ng-click="colors.opened = color"
      class="color-btn"
      style="background: {{color}};">
</span>
```

This is how it looks (try to click the buttons):

<iframe src="http://eyalar.github.io/Angular--watch-comparison/cp-prev.html"
        style="height:60px;"></iframe>

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
      boxes: /* binding from the parent controller */
    },
    link: function(scope, rootEl, attrs) {
      scope.boxes.forEach(function(box) {
        var boxEl = /* build a DOM element for each box */ ;
        rootEl.append(boxEl);
      });

      // update the DOM when boxes are changed:
      scope.$watch('boxes', function(boxes) {
        rootEl.find( /* box DOM elements */ )
          .each(function(i) {
            if (boxes[i].opened) this.addClass('opened');
            else this.removeClass('opened');
          });
      }, true);
    },
  };
}
```

The result:

<iframe src="http://eyalar.github.io/Angular--watch-comparison/deep-watch.html"
        style="height:500px;"></iframe>

The response time to a button click is **terrible**. On my machine I got close
to 350ms, which is unacceptable. Let's see why.

Our boxes rendering directive is responsible for, well, rendering boxes. But it
also needs to update rendered boxes when the underlying data changes. For this
to happen, we must watch for changes in data. Our `$watch` statement does
exactly that. Notice the `true` flag. Here we tell the `$watch` statement to
look at the contents of the `boxes` array and detect for changes with
**deep-equality**. Without it, the `$watch` statement would check for changes
with shallow-equality. In other words, it would only check if the **reference**
inside `scope.boxes` has changed. But since it's always the same array, no
change would be detected, and the UI would not be updated.

Doing dirty-checking with deep equality on every digest cycle can be very
expensive. We have to compare the full structure of each `box` object, including
the contents of each of it's fields. This explains the slowness we observed. But
most of those checks are redundant in our case, since we only care about the
`box.opened` field. Let's see how we can be more efficient.

We want to get rid of the `true` flag in the `$watch` statement, so we can avoid
those deep object comparisons; and still be able to detect when our data has
changed. but we can't do it as long as our objects remain the same (we only
change `box.opened`, but it's still the same box). In order to do that, we have
two options:

0. Make sure that every time one of the boxes changes, the `scope.boxes`
   array-reference also changes. This means we need to construct a new array
   each time one of the boxes changes. Since we need to check each of the boxes
   anyway, creating a new replacement array is not much overhead. With this
   option, checking if our data has changed is easy; we just check if this one
   `scope.boxes` array-reference has changed.
0. Make sure that every time a box changes, only that specific box is replaced
   inside the `scope.boxes` array. In other words, we replace a box object with
   an equivalent updated object, thus effectively changing this box's reference
   inside the boxes array. With this option, to detect changes in data it's not
   enough to check only one array-reference, but we need to check each of the
   object references inside the array. Still, it's not nearly as expensive as
   deep-comparing each of those objects.

Let's start with the first option. We change the relevant part in our parent
controller to construct a new array when the opened color changes:

```Javascript
function boxesCtrl($scope) {
  /* ... */
  $scope.$watch('colors.opened', function(color) {
    // construct a new 'boxes' array:
    // (notice the 'map' function returns a new array)
    $scope.boxes = $scope.boxes.map(function(box) {
      box.opened = box.color === color;
      return box;
    });
  });
}
```

Now we can avoid deep-equality dirty-checking in our directive:

```Javascript
// update the DOM when boxes are changed:
scope.$watch('boxes', function(boxes) {
  // DOM updates as before
  // notice the removed 'true' flag
});
```

And the result:

<iframe src="http://eyalar.github.io/Angular--watch-comparison/shallow-watch.html"
        style="height:500px;"></iframe>

The response time is noticeably much better. On my machine I got around 3ms.

Let's Look at our parent controller again. In order to achieve shallow-watching
in the directive, the controller must replace the entire `boxes` array with a
new array.

Changing the array reference may not always be possible in every application.
Let's discuss the second option. We change the relevant part in our parent
controller to keep the reference to the 'boxes' array, but change references to
'box' objects inside the array.

```Javascript
function boxesCtrl($scope) {
  /* ... */
  $scope.$watch('colors.opened', function(color) {
    for (var i = 0; i < $scope.boxes.length; i++) {
      var box = $scope.boxes[i];
      // delete the old box and insert a new one in-place:
      $scope.boxes.splice(i, 1, {
        color: box.color, // keep color
        opened: box.color === color, // update opened state
        items: box.items // keep items
      });
    }
  });
}
```

Now, in our directive, we need a way to detect when one of the box-object
references changes. We can't use the `$watch` statement as before since it will
only detect changes to the array-reference; which now always remains the same.
Instead, we need to shallow-watch one level down. Angular provides us with the
`$watchCollection` statement which does what we need. It watches with
shallow-equality one level down inside a collection. If we have an array, it
will shallow-compare the items in the array, and will not do any
deep-comparisons if the items are objects.

```Javascript
// update the DOM when boxes are changed:
scope.$watchCollection('boxes', function(boxes) {
  // DOM updates as before
});
```

The result:

<iframe src="http://eyalar.github.io/Angular--watch-comparison/watch-collection.html"
        style="height:500px;"></iframe>

And here as well the response time is excellent, and almost identical to the
first option (again 3ms on my machine). Apparently the overhead of more
shallow-comparisons is not significant.

Let's conclude.

Designing fast data-intensive UIs requires being aware of the structure of data,
and how we respond to changes in data. When our data is large and complicated
we can't afford any inefficiency. In this post we saw how easy it is to misuse
familiar data-watching methods, and inadvertently causing the UI to be slow.
By understanding how data is watched, we can construct it, and update it, in
ways which will allow us to employ more efficient UI updates. Making the UI
faster.
