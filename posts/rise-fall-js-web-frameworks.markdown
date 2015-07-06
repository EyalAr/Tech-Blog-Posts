## Introduction

Frameworks give us structure. Structure is essential for building large and
scalable applications. We need structure to manage code, create flexible
architecture, reuse functional components and enforce separation of concerns.
JS Frameworks are, partly, a result of a long stagnation in JS as a language
and as an ecosystem. The historical background for the rise of JS frameworks
has several key points:

0. The role JS played as a small language which was used to do tasks such as
   forms validation; and its quick rise in popularity (and lines of code),
   largely due to introduction of ever more powerful browsers. This created a
   big gap between the urgent need for new JS code and available tools. Quickly
   new tools and frameworks started to pop up to close that gap.
0. The rapid decline we are seeing in recent years in server-side rendering, and
   the rapid incline in single-page apps. The paradigm of rich clients and lean
   servers has been successful both because it reduces server-side costs and
   complexity; and because it creates a better user experience. JS developers,
   historically, lack the education needed for such development of complex
   apps; which makes frameworks a necessity.

There is an abundance of people who can write some JS code. A subset of them is
capable of writing a small single-page app. A subset of those can write a medium
sized single-page app. And of those, only a few can work in a team which
produces a large single-page app. Frameworks make those subsets of people
larger. But there's another subset - the subset of people who truly understand
the problems needed to be solved in order to develop a web app. With frameworks,
it's not really necessary to understand.

Structure is good. When it’s a natural part of our design process it's even
better. But it can be painful when our design is forced to fit a pre-determined
structure. There are many types of web applications. Some of them have
similarities and some of them are unique. Some share a similar structure and
some are completely new and innovative.

One of the base assumptions of frameworks is that we, developers, need
structure to be enforced externally. In all frameworks there’s a right way to
do things and all other ways are wrong. You will know when your way is wrong
because the framework will fight you back into the right way. But what if it
doesn’t suit your needs or your style?

There is no one-to-one correspondence between business logic and code structure.
There are many code designs which can achieve the same functionality. Some more
elegant than others, some more efficient than others and some more maintainable
than others. When limiting code design options we inhibit developers' ability to
implement business logic.

The recent proliferation of frameworks makes things more difficult. Each
framework introduces its own right way of building web applications; and we,
developers, need to be able to select among them the one that mostly suits our
needs and personal (or corporate) flavors.

Recently we have seen a move in the JS ecosystem towards smaller tools which do
one thing ([*dotadiw*][1]). Developers today start to move away from a complete
framework solution, towards picking the right tools for the job; essentially
creating their own ad-hoc framework. This, I suspect, stems from several
reasons:

1. An awakening of JS as a language. A lot of attention has been given lately
   into educating developers of best practices, JS programming patterns and
   standardization. Framework-created domain specific languages are becoming
   less useful.
2. A better understanding of the JS community as a whole of the main problems
   needed to be solved when developing apps. The community has educated itself
   to define and isolate challenges; and, naturally, dotadiw-style solutions
   have emerged.

With an increased awareness of how to define and isolate problems, I believe
frameworks can be detrimental.

## The Problem

The intention of frameworks is good. Especially for relatively inexperienced
developers. Frameworks solve some problems. My contention is that by
understanding what frameworks try to solve (which is something every experienced
developer should try to understand), their existence becomes redundant, and even
detrimental. Detrimental because by solving several problems all at once, they
obscure the border of where one problem starts and another ends. I.e. people
think that UI data binding is an automatic process which makes the UI update
whenever the data model changes (I'm looking at you Angular). But those are
actually two separate problems: (1) having the UI reflect some data model (data
binding), and (2) getting notified when data changes (data observation).

All those "right ways" share a few things in common. They try to tell us how to
write components, how to manage dependencies, how user interactions should be
modeled, how data synchronization with the server should be done, how
application state should be represented, how the three aspects of UIs (layout,
styles and logic) should be managed, etc.

But we don't want "how". We need "what".

## The Building Blocks

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

This more or less corresponds to the requirements of most modern web
applications:

- Loading assets and dependencies.
- Modularizing code in a maintainable way.
- Enabling ways for modules to communicate and share data.
- UI rendering, templating and data binding.
- Communication with a server (AJAX, Web Sockets, etc.).
- Building and testing the application.

[1]: https://en.wikipedia.org/wiki/Unix_philosophy#Do_One_Thing_and_Do_It_Well "Do one thing and do it well"
