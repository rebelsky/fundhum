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
and have provided some alternate exercises for those who cannot or prefer
not to do image-based work.

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

You will have the opportunity to explore some other options in the lab.

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
@hyperlink["https://docs.racket-lang.org/teachpack/2htdpimage.html"]{The official DrRacket documentation}.

@section[#:tag "images:colors"]{Colors}

@section[#:tag "images:combine"]{Combining images}

@code{beside}

@code{(beside/align alignment i1 i2)}  Main ones: top middle bottom.

@code{above}

@code{(above/align alignment i1 i2)} Main ones: left, middle, right

@code{overlay}

@code{overlay/align}

@code{overlay/offset}

@section:self-checks{}

@self-check{_TITLE_}

@section:acknowledgements{}

This section draws upon
@hyperlink["https://docs.racket-lang.org/teachpack/2htdpimage.html"]{The DrRacket HtDP/2e Image Guide} 

