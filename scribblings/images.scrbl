#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@prefix{images}
@title[#:tag (prefix)]{Simple images}
@author{Samuel A. Rebelsky}

@summary{We consider some of the basic mechanisms for dealing with
images in DrRacket.}

@prereqs{@Secref{intro-racket} and @secref{data-types}}

@noindent{}@emph{Disclaimer:} This section discusses Racket procedures
for creating images.  It will likely be less accessible or inaccessible
to students with limited vision.  In addition, the Scribble doccumentation
system that we are using for this text does not provide a natural way
to provide @q{alt text} for images.  We apologize for these deficiencies
and will provide alternative exercises for those who cannot or prefer not
to do image-based work.

@section[#:tag "images:introduction"]{Introduction}

In addition to supporting @q{standard} data types, such as numbers and
strings, Racket also includes libraries that support a number of more
sophisticated data types, including a type that the designers call
@q{images}.  The image data type supports the creation, combination,
and manipulation of a variety of basic shapes.  Readers of an earlier
generation might consider Racket's picture type an extension of the
ColorForms that they played with as children.

In considering the image data stype, we should ask ourselves the
standard set of five questions: What is the @emph{name} of the type?
It's @q{image}.  What is the @emph{purpose} of the type?  To allow
people to make interesting images.  How do you @emph{express} values
in this type?  We've seen a few ways, including @code{circle} the and
@code{rectangle} procedures.  There are more.  How does DrRacket
@emph{display} values?  As the @q{expected} images.  What @emph{procedures}
are available?  We've seen that we can use @code{above} and @code{beside}.
Once again, there are more.

There's also one other question to ask for this type, since it's not
a standard type: How does one @emph{access} the type?  The answer is
straightforward: You add the following line to the top of your definitions
pane.

@codeblock|{
(require 2htdp/image)
}|

@section[#:tag "images:shapes"]{Basic shapes}

You've already seen two procedures for creating basic shapes:
@code{(circle radius mode color)} creates a circle and
@code{(rectangle width height mode color)} creates a rectangle.

@image-examples[
(circle 20 'outline "red")
(rectangle 40 25 'solid "blue")
]

There are a few other things you can do with these basic shapes.
If, instead of @code{'outline} or @code{'solid}, you use a number
between 0 and 255 for the mode, DrRacket uses that number as the
@emph{opacity} of the shape.

@image-examples[
(beside
  (rectangle 25 40 255 "blue")
  (rectangle 25 40 191 "blue")
  (rectangle 25 40 127 "blue")
  (rectangle 25 40  63 "blue"))
]

Opacity will be especially important as we start to overlay shapes.

@image-examples[
(define circles
  (beside
    (circle 10 255 "red")
    (circle 10 191 "red")
    (circle 10 127 "red")
    (circle 10  63 "red")))
(above
  (overlay circles (rectangle 60 20 255 "blue"))
  (overlay circles (rectangle 60 20 191 "blue"))
  (overlay circles (rectangle 60 20 127 "blue"))
  (overlay circles (rectangle 60 20  63 "blue")))
]

You can also use different @q{pen} values when outlining a shape.  To
create a pen, you use @code{(pen color width style cap join)} where

@itemize{
@item{@code{style} can be @code{'solid}, @code{'dot}, @code{'long-dash},
@code{'short-dash}, or @code{'dot-dash}.}
@item{@code{cap} can be @code{'round}, @code{'projecting}, or @code{'butt}.}
@item{@code{join} can be @code{'round}, @code{'bevel}, or @code{'miter}.}
}

@image-examples[
(define background (rectangle 80 80 'solid "white"))
(beside 
 (overlay (circle 30 'outline (pen "red" 4 'solid 'round 'round))
          background)
 (overlay (circle 30 'outline (pen "red" 6 'dot-dash 'round 'round))
          background)
 (overlay (circle 30 'outline (pen "red" 8 'short-dash 'butt 'round))
          background)
 (overlay (circle 30 'outline (pen "red" 8 'short-dash 'projecting 'round))
          background))
]

There are also a variety of other basic shapes.  @code{(triangle
edge mode color)} creates an equilateral triangle, @code{(ellipse
width height mode color)} creates an ellipse, and @code{(star
side mode color)} produces a five-pointed star.

@image-examples[
(beside
 (ellipse 40 20 'outline "red")
 (ellipse 20 40 'solid "blue")
 (triangle 40 'solid "black")
 (star 30 'solid "teal")
 (star 20 'outline "teal"))
]

You can find a host of others shapes, including nine different kinds 
of triangles, a more generalized star, a variety of polygons, and even
text and curves in 
@hyperlink["https://docs.racket-lang.org/teachpack/2htdpimage.html"]{The official DrRacket documentation for images}.

@section[#:tag "images:colors"]{Colors}

While we often think of colors by name (e.g., “red”, “violet”, or “burnt umber”), one of the great advantages of computational image making is that it is possible to describe colors that do not have a name. Moreover, it is often better to use a more precise definition than is possible with a name. After all, we may not agree on what precisely something like “springgreen” or “burlywood” means. (One color scheme that we’ve found has both “Seattle salmon” and “Oregon salmon”. Would you know how those two colors relate?)

In fact, it may not only be more accurate to represent colors non-textually, it may also be more @emph{fficient}, since color names may require the computer to look up the name in a table. 

The most popular scheme for representing colors for display on the computer screen is RGB. In this scheme, we build each color by combining varying amounts of the three primary colors, red, green, and blue. (What, you think that red, yellow, and blue are the primary colors? It turns out that primary works differently when you’re transmitting light, as on the computer screen, than when you’re reflecting light, as when you color with crayons on paper.)

So, for example, purple is created by combining a lot of red, a lot of blue, and essentially no green. You get different purple-like colors by using different amounts of red and blue, and even different ratios of red and blue.

When we describe the amount of red, green, and blue, we traditionally use integers between 0 and 255 to describe each component color. Why do we start with 0? Because we might not want any contribution from that color. Why do we stop with 255? Because 255 is one less than 28 (256), and it turns out that numbers between 0 and 255 are therefore easy to represent on computers. (For those who learned binary in high school or elsewhere, if you have exactly eight binary digits, and you only care to represent positive numbers, you can represent exactly the integers from 0 to 255. This is akin to being able to count up to 999 with three decimal digits.)

If there are 256 possible values for each component, then there are 16,777,216 different colors that we can represent in standard RGB. Can the eye distinguish all of them? Not necessarily. Nonetheless, it is useful to know that this variety is available, and many eyes can make very fine distinctions between nearby colors.

In DrRacket's image model, you can use the @code{make-color} procedure to
create RGB colors.  @code{(make-color 0 255 0)} makes a bright green,
@code{(make-color 0 128 128)} makes a blue-green color, and @code{(make-color
64 0 64)} makes a relatively dark purple.

@image-examples[
(beside (circle 20 'solid (make-color 0 255 0))
        (circle 20 'solid (make-color 0 128 128))
        (circle 20 'solid (make-color 64 0 64)))
]

@section[#:tag "images:combine"]{Combining images}

By themselves, the basic images (ellipses, rectangles, etc.) do not
permit us to create much.  However, as some of the examples above
suggest, we gain a great deal of power by combining existing images
into a new image.  You're already seen three basic mechanisms for
combining images.

@itemize{
@item{@code{beside} places images side-by-side.  If the images have different heights, their vertical centers are aligned.}
@item{@code{above} places images in a stack, each above the next.  If the images have different widths, their horizontal centers are aligned.}
@item{@code{overlay} places images on top of each other.  The first image is on top, then the next one, and so on and so forth.  Images are aligned according to their centers.}
}

@image-examples[
(define small-gray (circle 10 'solid "gray"))
(define medium-red (circle 15 'solid "red"))
(define large-black (circle 20 'solid "black"))
(beside small-gray medium-red large-black)
(above small-gray medium-red large-black)
(overlay small-gray medium-red large-black)
(overlay large-black medium-red small-gray)
]

What if we don't want things aligned on centers?  The Racket iamge library
provides alternatives to these three that provide a bit more control.

* @code{(beside/align alignment i1 i2 ...)} allows you to align
  side-by-side images at the top or bottom (using @code{'top} and
  @code{'bottom}).  You can also align at the center, mimicking
  @code{beside}, using @code{'center}
* @code{(above/align alignment i1 i2 ...)} allows you to align
  vertically stacked images at the left, right, or middle (using
  @code{'left}, @code{'right}, and @code{'middle}).
* @code{(overlay/align halign valign i1 i2 ...)} allows you to
  align overlaid images.

@image-examples[
(define small-gray (circle 10 'solid "gray"))
(define medium-red (circle 15 'solid "red"))
(define large-black (circle 20 'solid "black"))
(beside/align 'top small-gray medium-red large-black)
(beside/align 'bottom small-gray medium-red large-black)
(above/align 'left small-gray medium-red large-black)
(above/align 'right small-gray medium-red large-black)
(overlay/align 'left 'top small-gray medium-red large-black)
(overlay/align 'left 'center small-gray medium-red large-black)
(overlay/align 'left 'bottom small-gray medium-red large-black)
(overlay/align 'right 'top small-gray medium-red large-black)
(overlay/align 'right 'top large-black medium-red small-gray)
]

As the overlay examples suggest, the alignment is based on the
@q{bounding box} of each image, the smallest rectangle that
encloses the image.

There's also another way to overlay images: You can offset the
second one relative to the first with @code{(overlay-offset i1
xoff yoff i2)}.  In this case, the second one is offset by the
specified amount from its original position.

@image-examples[
(define medium-red (circle 15 'solid "red"))
(define medium-black (circle 15 'solid "black"))
(overlay/offset medium-red 2 6 medium-black)
(overlay/offset medium-red 6 2 medium-black)
(overlay/offset medium-red -3 -3 medium-black)
]

@section:self-checks{}

@self-check{_TITLE_}

@section:acknowledgements{}

This section draws upon
@hyperlink["https://docs.racket-lang.org/teachpack/2htdpimage.html"]{The DrRacket HtDP/2e Image Guide}.  The discussion of colors comes from @hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2017S/readings/rgb-early-reading.html"]{a reading from Grinnell's CSC 151}.

