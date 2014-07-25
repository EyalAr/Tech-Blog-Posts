I want to do simple image manipulations in NodeJS. All modules out there, which
claim to provide image processing capabilities, wrap an external program which
is actually manipulating the image. Usually in the form of spawning a child
process and running a contrived external command in it. All these modules
require this external program to be already installed on the system.

I have 3 problems with this approach:

0. The module's users need to pre-install external binaries on their system.
   This makes the installation of the module more cumbersome and less portable.
   It also means other modules can't depend on this module without also making
   sure their users install this binary dependency.
0. The module needs to spawn a child process for every image it manipulates.
   Probably more than once (at least once for every batch of operations).
   This is arguable. Maybe it's not that bad. But it feels inefficient (The OS
   needs to create a new process, etc.).
0. You can't really manipulate images in-memory. Sure, some of the modules give
   you streams (which pipe to the external program's stdio, which again involves
   the OS); and from streams you can make buffers. But what if you want to
   manipulate an image, get a buffer, manipulate it some more, and get another
   buffer? You can't, because you don't really have the image in-memory. You
   have to call the external program with all the manipulations again, just to
   get the second buffer. You need to wait for the child process to give you
   the data, and then the process dies. You can't incrementally manipulate an
   image efficiently like this. You can't encode one image in different formats
   and different qualities from the same memory buffer.

All those problems led me into rolling [my own](https://github.com/EyalAr/lwip)
native NodeJS image processor.

I wanted to avoid any binary dependencies; a quick `npm install` is all that
should be needed to use the module. Obviously it means writing the image
processing parts of the module as a
[native NodeJS addon](http://nodejs.org/api/addons.html) in C++.

It's a good opportunity to create a functionality which I felt is missing, and
to learn some V8 and NodeJS internals on the way. It's quite interesting
actually, and a separate post about writing native NodeJS module is on it's way.

I'm still working on the module (called *lwip*, Light-Weight Image Processor),
but all the basics are pretty much ready. The starting point is obtaining an
`image` object, on which all the manipulations are made, and from which encoded
image data can be obtained.

```Javascript
require('lwip').open('path/to/image.jpg', function(err, image){
    // manipulate image
});
```

Working on an image, on the C++ side of things, is a 3-stage process:

0. Decode the image. Images, in the broad sense, are just a collection of
   pixels. JPEG, PNG, GIF, etc. are not images. They are codecs. A JPEG file
   contains **encoded** image data. In order to do manipulations on the image,
   the data first needs to be decoded. Different codecs use different image
   compression techniques. Luckily, for the most popular codecs there are open
   source libraries which provide decoding and encoding functionalities (see,
   for example, [libjpeg](http://www.ijg.org/) and
   [libpng](http://www.libpng.org/)). So the first stage is reading encoded
   image data and decoding it, in-memory, to raw, uncompressed, pixels data.
0. Manipulate the pixels. Now that we have the pixels data, we can manipulate
   the image. There are many things we can do, some are mathematically complex,
   some are simple. For my module I decided to use the open source
   [CImg](http://cimg.sourceforge.net/) library, which provides a very
   comprehensive set of functionalities to manipulate raw pixels date.
0. Encode the manipulated image. Most users out there have nothing to do with
   raw pixels data. We need to encode it back to JPEG, or PNG or whichever
   format our users will be able to display. This is basically the reverse
   process of encoding. Now we take the raw pixel data and compress it.

So far, nothing of this has anything to do with NodeJS or V8. But what we
actually want is to do all those things in Javascript land. The technical
process of creating this bridge between Javascript and C++ will be explained
in a separate post.

So let's say we opened an image, decoded it and have it in memory; and that we
have all the Javascript-C++ bindings to manipulate the image. Now, in our
Javascript code we can do things like:

```Javascript
image.scale(0.5, function(err, image){
    // 'image' is now scaled to 50%
});
```

 And like:

 ```Javascript
image.rotate(33, function(err, image){
    // 'image' is now rotated 33 degrees
});
```

And finally we can encode the image to, let's say, JPEG; and get it as a NodeJS
Buffer:

```Javascript
image.toBuffer('jpg', {quality: 90}, function(err, buffer){
    // Send buffer over the network, save to disk, etc.
});
```

We can, for example, open a PNG image, resize it, obtain a JPEG buffer, convert
it to a base64 string, send it to our user's browser; where we display it. All
this done in-memory, without ever needing to keep copies of the image in
different sizes and formats.

Check out the full `lwip` module at
[the Github repo](https://github.com/EyalAr/lwip)

To conclude, enjoy this puppy which was rotate with my module:

![Rotated puppy][puppyImg]


[puppyImg]:images/image-processing-nodejs/puppy_rot.jpg
