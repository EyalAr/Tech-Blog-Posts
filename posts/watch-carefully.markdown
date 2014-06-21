# TL;DR

In AngularJS, shallow-watching object references (either with $watch or
$watchCollection) is cheap; but doesn't always detect changes in our data.
Deep-watching (with Angular's recursive `equals`) is expensive; but might be
the only way to detect a change. Learn when to use each kind of `$watch` and
boost your app's performance. Better yet, learn how to manage your scopes' data
such that you can always shallow-watch.
