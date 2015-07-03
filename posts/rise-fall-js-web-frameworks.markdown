## Introduction

Frameworks give us structure. Structure is essential for building large and
scalable applications. We need structure to manage code, create flexible
architecture, reuse functional components and enforce separation of concerns.
Structure is good when it’s a natural part of our design process, but not when
our design is forced to fit a pre-existing structure.  
There are many types of web applications. Some of them have similarities and
some of them are unique. Some share a similar structure and some are
completely new and innovative.

One of the base assumptions of frameworks is that we, developers, need
structure to be enforced externally. In all frameworks there’s a right way to
do things and all other ways are wrong. You will know when your way is wrong
because the framework will fight you back into the right way. But what if it
doesn’t suit your needs or your style?

There is no one-to-one correspondance between business logic and code structure.
There are many code designs which can achieve the same functionality. Some more
elegent than others, some more efficient than others and some more maintainable
than others. When limiting code design options we inhibit developers' ability to
implement business logic.

The recent proliferation of frameworks makes things more difficult. Each
framework introduces its own right way of building web applications; and we,
developers, need to be able to select among them the one that mostly suits our
needs and personal (or corporate) flavors.

The intention of frameworks is good. Especially for relatively inexperienced
developers. Frameworks solve some problem. My contention is that by
understanding what frameworks try to solve (which is something every experienced
developer should try to understand), their existance becomes redundant.

All those "right ways" share a few things in common. They try to tell us how to
write components, how to manage dependencies, how user interactions should be
modeled, how data synchronization with the server should be done, how
application state should be represented, how the three aspects of UIs (layout,
styles and logic) should be managed, etc.

But we don't want "how". We need "what".

JS web frameworks enforce structure by defining a certain way of developing
applications. But this enforced way is not always the best for any type of
application. Recently we have seen a move in the JS ecosystem towards smaller
tools which do one thing ([*dotadiw*][1]). Developers today start to move away
from a complete framework solution, towards picking the right tools for the job;
essentially creating their own ad-hoc framework.

So what are the essential components of every web framework? What do we need
the framework to do? It's up to your specific application really. But since
all frameworks are designed to support a broad range of applications, they
will usually need to define:

- What is the way by which modules are defined and loaded.
- What are the possible types of components and what kind of functionality they
  provide (controllers, models, factories, services, providers, widgets...).
- What are the ways to manage UI rendering, business logic and user data.
- How does data propagate from the server to the components.
- How should the project be tested.
- How should the project be built.

[1]: https://en.wikipedia.org/wiki/Unix_philosophy "Do one thing and do it well"