Binaries should not live in the same place as your code. In compiled languages
this separation is trivial. We never see Java, C++ or Go repositories which
contain compiled executables. Projects in those languages either:

0. Provide a build script à la `make install`, and let users build the binaries
   locally.
0. Provide downloadable binaries which reside outside of the repo.
0. Distribute builds through some package management system.

Anyone cloning the repo, most probably, wants to hack the code base; and not
simply use it. Thus, it doesn't make much sense to include compiled binaries
in source code repositories (even if the binaries are platform independent, such
as with Java bytecode).

Additionally, binaries pollute the repository and make version control more
complicated.

With scripting languages, however, the separation between source and binaries
is gone. Often, projects written in a scripting language have no build step,
and the code is run as-is.

But this is not always the case. Consider the following cases in which a build
step is necessary even in a scripting language project:

0. Removal of debugging statements from the code before distributing the
   project.
0. Frontend Javascript projects in which the distributed builds should be
   minified.
0. Javascript projects which are distributed both as AMD and CommonJS modules.
0. Projects in which the source is spread over a large number of files, which
   should be unified in the distributed build.
0. Projects which rely on some automatic code generation.

