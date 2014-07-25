Building a UI which enables interaction with large amounts of data is not
trivial. Putting aside visual aspects, there is a technical challenge in
managing the rendering, monitoring and interacting with lots of datums.

People don't usually like to see a cluttered UI. And indeed, most well-designed
UIs display no more than a few tens of pieces of data. The numbers change,
however, when we need to display graphical information. In those cases, there
may be thousands of datums which need to be rendered, monitored for changes,
and interacted with.

In AngularJS we achieve responsiveness by watching for changes in data. Angular
does this by dirty checking our objects. One of the major assumptions in
Angular's architecture is that although dirty-checking is slow, it's still fast
enough. "Fast enough" just means that humans won't notice the slowness. If a
response to a user action takes
[less than 100ms](http://stackoverflow.com/a/2547903/1365324), it's good enough.

But of course the amount of dirty-checks Angular needs to do varies from one
application to another; and very much depends on the amount and structure of
the application's data. For UIs in which we have only a few tens of datums;
modern Javascript engines can do all the dirty-checks in well below 100ms.

<iframe src="http://eyalar.github.io/Angular--watch-comparison/ng-repeat.html"></iframe>
<iframe src="http://eyalar.github.io/Angular--watch-comparison/deep-watch.html"></iframe>
<iframe src="http://eyalar.github.io/Angular--watch-comparison/shallow-watch.html"></iframe>
<iframe src="http://eyalar.github.io/Angular--watch-comparison/watch-collection.html"></iframe>

In AngularJS, watching for data changes is very much dependent on how we
manage and construct the data. Shallow-watching object references (either with
`$watch` or `$watchCollection`) is cheap, but can:

0. Miss data changes, where the object reference is the same, but the content
   has changed.
0. Create false-positives, where the object reference might have changed,
   but the content is the same.

Deep-watching (with Angular's `equals`), on the other hand, can be an overkill
when:

0. A Change in data means a new object, thus it's enough to compare object
   references.
0. It's cheaper to respond to data changes than to deep-watch the data, even
   when having false-positives.

It's important to learn when to use each kind of `$watch` and boost your app's
performance. Better yet, learn how to manage your data such that you can
shallow-watch it.

Handling large amounts of data on the frontend means we need to be smart about
it; and it raises unavoidable questions.

0. Is is cheaper to watch the data for changes; or is it cheaper to update
   the DOM?
0. Is it cheaper to regenerate changed objects as a whole; or is it cheaper to
   update specific fields?
0. 
