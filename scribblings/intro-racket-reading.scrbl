#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)
@(require scribble/example)
@(require racket/string)

@title[#:tag "intro-racket"]{An abbreviated introduction to Racket}
@author{Samuel A. Rebelsky}
@prefix{intro-racket}

@summary{We begin to explore the Racket programming language and
some of the capabilities of that language.  We consider some basic
issues of the the structure of expressions in Racket, the @emph{syntax}
of the language.}

@prereqs{@Secref{algorithms}, Algorithm building blocks}

@section[#:tag "intro-racket:intro"]{Introduction: Algorithms and programming languages}

While our main goals in this course are for you to develop your
skills in @q{algorithmic thinking} and apply algorithmic techniques
to problems in the digital humanities, you will find it equally
useful to learn how to direct computers to perform these algorithms.
@emph{Programming languages} provide a formal notation for expressing
algorithms that can be read by both humans and computers.  We will
use the Racket programming language, a dialect of the Scheme
programming language, itself a dialect of the Lisp programming
language, one of the first important programming languages.

One thing that sets these languages apart from most other languages
is a simple, but non-traditional, syntax.  To tell the computer to
apply a procedure (subroutine, function) to some arguments, you
write an open parenthesis, the name of the procedure, the arguments
separated by spaces, and a close parenthesis.  For example, here's
how you add 2 and 3.

@fundhum-examples[(+ 2 3)]

One advantage of this parenthesized notation is that it eliminates
the need for the reader or the computer to know a set of precedence
rules for operations.  Consider, for example, the expression
@verb{2+3x5}. Do you add first or multiply first?  Different
programming languages may interpret it differently.  On the other
hand, we have to explicitly state the order, writing either @code{(+
2 (* 3 5))} or @code{(* (+ 2 3) 5)}, using @verb{*} as the
multiplication symbol.

@fundhum-examples[
(+ 2 (* 3 5))
(* (+ 2 3) 5)
]

As this example suggests, we have already started to explore both basic
operations (addition and multiplication) and sequencing (through nesting)
in Racket.

@section{Beyond numeric expressions}

Of course, you can use Racket for more than arithmetic computations.
Here are some examples working with text.  

We can find the length of a string.

@fundhum-examples[(string-length "Jabberwocky")]

We can break a string apart into a list of string.

@fundhum-examples[(string-split "Twas brillig and the slithy toves" " ")]

We can find out how many words there are once we've split it apart.

@fundhum-examples[(length (string-split "Twas brillig and the slithy toves" " "))]

This operation returned a @emph{list}, an ordered collection of values.
Note that lists are also surrounded by parentheses.  Racket distinguishes
lists, which should not be evaluated, from expressions, which should be
evaluated, by including a tick mark, @verb{'}, before the parenthesis
in most lists.

Once we have a list of words, we can find out how long each word is.

@fundhum-examples[(map string-length 
                       (string-split "Twas brillig and the slithy toves" " "))]

We can even split in strange ways, such as at the vowels.  (We'll explain
the strange @code{#px"[aeiou]"} in a subsequent reading.)

@fundhum-examples[(string-split "Twas brillig and the slithy toves" #px"[aeiou]")]

@section{Computing with images}

You've already seen a few of Racket's basic types. Racket supports
numbers, strings (text), and lists of values.  Of course, these are
not the only types it supports.  Some additional types are available
through separate libraries.  For example, it is comparatively
straightforward to get Racket to draw simple shapes.

@image-examples[
(circle 15 'outline "blue")
(circle 10 'solid "red")
]

@;{That is, the command @code{(circle 15 'outline "blue")} produced
a blue circle of radius 15 that is visible primarily through an
outline of the circle and the command @code{(circle 10 'solid "red")}
produced a red circle of 10 which is a solid disc.}

We can also combine shapes by putting them above or beside each other.

@image-examples[
(above (circle 10 'outline "blue")
       (circle 15 'outline "red"))
(beside (circle 10 'solid "blue")
        (circle 10 'outline "blue"))
(above (rectangle 15 10 'solid "red")
       (beside (rectangle 15 10 'solid "blue")
               (rectangle 15 10 'solid "black")))
]

As you may have discovered in your youth, there are a wide variety of
interesting images we can make by just combining simple colored shapes.
You'll have an opportunity to do so in the corresponding lab.

@section:self-checks{}

@self-check{Try the examples}

Try the numeric and string examples from the reading.  (The image 
examples require you to load a library, so we will leave that until
the laboratory.)

@self-check{Precedence}

Consider the expression @verb{3-4x5-6}.  

If we did not have rules for order of evaluation, one possible way
to evaluate the expression would be to subtract six from five (giving
us negative one), then subtract four from three (giving us negative
one), and then multiply those two numbers together (giving us one).
We'd express that in Racket as @code{(* (- 5 6) (- 3 4))}.

a. What is the @q{official} way to evaluate that expression?

b. How would you express that in Racket?

c. Come up with at least two other orders in which to evaluate that 
expression.

d. Express those other two orders in Racket.

@section:acknowledgements{}

This section draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/Beginning
scheme"]{a reading entitled "Beginning Scheme"} from Grinnell
College's CSC 151.

Portions of this section are inspired by Christopher Lemmer Webber's
@q{Building a snowman with Racket}, available at
@url{https://dustycloud.org/misc/digital-humanities/Snowman.html} and
@url{https://github.com/mlemmer/DigitalHumanities/blob/master/Snowman.scrbl}.

