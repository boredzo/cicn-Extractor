# `'cicn'` Extractor
## Get color icon resource images out of old Mac applications and into PNG files

Classic Mac applications held icon images in a variety of formats. Several of them are collectively known as the IconFamily formats, and software already exists to work with those—but what of the lowly `'cicn'` (color icon) resources, often used for such things as dialog-box icons? These have been left to continue rotting!

No more. `'cicn'` Extractor is a document-based application that will list all of the `'cicn'` resources in a file and provide the option to export any of them as PNG files.

## Requirements

A Mac running OS X 10.8 or later, capable of running i386 applications.

(This app uses NSQuickDrawView and certain 32-bit-only Icon Services APIs, so it can never be ported to 64-bit without a complete third-party rewrite of QuickDraw's PixMap code.)

## Example

Netscape Navigator 4 had an animated version of its logo that played whenever a page was loading. This was stored in the Mac version as a series of `'cicn'` resources, numbered 701 to 738.

Extracted using the `'cicn'` Extractor, then assembled into a GIF using [GIF Animator](https://itunes.apple.com/us/app/gif-animator/id512165265?mt=12), that animation looks like this:

![A giant white letter N on a planet's surface, as comets and an eclipsing moon go by.](https://i.imgur.com/GC6VmzA.gif)
