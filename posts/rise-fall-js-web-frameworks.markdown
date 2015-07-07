Frameworks give us structure. Structure is essential for building large and
scalable applications. We need structure to manage code, create flexible
architecture, reuse functional components and enforce separation of concerns.
JS Frameworks are, partly, a result of a long stagnation in JS as a language
and as an ecosystem. The historical background for the rise of JS frameworks
has two key points:

0. The role JS played as a small language which was used to do tasks such as
   forms-validation and date-selection; and its quick rise in popularity,
   largely due to introduction of more powerful browsers. This created a big gap
   between the urgent need for new JS code and available tools. Quickly new
   tools and frameworks started to pop up to close that gap.

0. The rapid decline we are seeing in recent years in server-side rendering, and
   the rapid incline in single-page apps. The paradigm of rich clients and lean
   servers has been successful both because it reduces server-side costs and
   complexity; and because it creates a better user experience. JS developers,
   historically, lack the education needed for such development of complex
   apps; which makes frameworks a necessity.

There is an abundance of people who can write some JS code. A subset of them is
capable of writing a small single-page app. A subset of those can write a medium
sized single-page app. And of those, even less can work in a team which produces
a large single-page app. Frameworks make those subsets of people larger. They
facilitate communication, encourage separation of concerns, and exchange the
need to holistically understand all the integral parts of a web app, with
technical knowledge of the framework itself.

There's another subset - the subset of people who truly understand the problems
needed to be solved in order to develop a web app. Here, frameworks actually
reduce the size of that subset. When using a framework, it's not as needed to
understand the underlying problems and structure, as it is without a framework.

One of the base assumptions of frameworks is that we, developers, need structure
to be enforced externally. Structure is good. When it’s a natural part of our
design process it's even better. But it can be painful when our design is forced
to fit a pre-determined structure. There are many types of web applications.
Some of them have similarities and some of them are unique. Some share a similar
structure and some are completely new and innovative.

In all frameworks there’s a right way to do things and all other ways are wrong.
You will know when your way is wrong because the framework will fight you back
into the right way. But what if it doesn’t suit your needs or your style?

There is no one-to-one correspondence between business logic and code structure.
There are many code designs which can achieve the same functionality. Some more
elegant than others, some more efficient than others and some more maintainable
than others. When limiting code design options we inhibit developers' ability to
implement business logic.

The recent proliferation of frameworks makes things more difficult. Each
framework introduces its own right way of building web applications; and we,
developers, need to be able to select among them the one that mostly suits our
needs and personal (or corporate) flavors. Often, without knowing how the
framework abstracts and solves the underlying problems. We learn the framework's
language, framework paradigms and patterns and how to solve framework problems.

Abstraction is good. Separation of concerns is great. But this kind of
abstraction has a dangerous pitfall - it reduces understanding of whatever it
abstracts and increases dependency in a specific solution. It's hard to
atomically upgrade / replace a component when your smallest atomic component
(the framework) encompasses your entire app.

Recently we have seen a move in the JS ecosystem towards smaller tools which do
one thing ([*dotadiw*][1]). Developers today start to move away from a complete
framework solution, towards picking the right tools for the job; essentially
creating their own ad-hoc framework. This, I suspect, stems from several
reasons:

1. An awakening of JS as a language. A lot of attention has been given lately
   into educating developers of best practices, JS programming patterns and
   standardization. Framework-created domain specific languages are becoming
   less useful.

2. A better understanding of the JS community, as a whole, of the main problems
   needed to be solved when developing apps. The community has educated itself
   to define and isolate challenges; and, naturally, *dotadiw*-style solutions
   have emerged.

With an increased awareness of how to define and isolate problems, I believe
frameworks can be detrimental. My contention is that by understanding what
frameworks try to solve (which is something every experienced developer should
try to understand), their existence becomes redundant, and even detrimental.
Detrimental because by solving several problems all at once, they obscure the
border of where one problem starts and another ends. I.e. people think that UI
data binding is an automatic process which makes the UI update whenever the data
model changes (I'm looking at you Angular). But those are actually two separate
problems: (1) having the UI reflect some data model (data binding), and
(2) getting notified when data changes (data observation).

All those "right ways" share a few things in common. They try to redefine the
problems of web development in their own terms; and tell us how to write
components, how to manage dependencies, how user interactions should be modeled,
how data synchronization with the server should be done, how application state
should be represented, how the three aspects of UIs (layout, styles and logic)
should be managed, etc.

So what are the essential components of every web framework? What does the
framework solve for us? It's up to your specific application really. But since
most frameworks are designed to support a broad range of applications, they
will usually need to define:

- What is the way by which modules are defined and loaded (from the markup,
  programmatically, as a mix of markup and code, as separate files, etc).
- What are the possible types of components and what kinds of functionality they
  provide (controllers, models, factories, services, providers, widgets, etc.).
- How components communicate and share data (scopes, events, pub/sub, etc.).
- What are the ways to manage UI rendering, business logic and data.
- How does data flow between the server and the components.
- How should data be accessed.
- How should the app be tested.
- How should the app be built.

This more or less corresponds to the requirements of most modern web
applications:

- Loading assets and dependencies.
- Modularizing code in a maintainable way.
- Data channels between different parts of the app.
- Communication channels between different modules.
- UI rendering, templating and data binding.
- Communication with a server (AJAX, Web Sockets, etc.).
- Building and testing the application.

Each of those points has a selection of tools available from the open source
community, which solve this point exclusively. Mixing and matching those tools
allow us to build our own ad-hoc framework. This way, the atomic dependencies
of our app are smaller (and thus easier to replace or upgrade). There is also,
in the long term, less to learn and re-learn. Learning about tools, and what
they solve, creates a broader knowledge base which is more applicable for the
future.

Unlike the early days of web development, today's JS apps are much more rich and
complex. Frameworks have helped us to manage and control this complexity. But
they have also taken us away from the real problems we were trying to solve,
obscured the borders between them, and created new problems in their own domain.
Today the ecosystem is mature enough, and provides us with specific tools to
specific problems. We, as developers need to know what it is we are trying to
solve, and adapt the philosophy of composing specific solution to specific
problems.

[1]: https://en.wikipedia.org/wiki/Unix_philosophy#Do_One_Thing_and_Do_It_Well "Do one thing and do it well"
