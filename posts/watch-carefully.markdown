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
