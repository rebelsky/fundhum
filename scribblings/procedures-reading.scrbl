#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)
@(require scribble/example)

@prefix{procedures}
@title[#:tag (prefix)]{Writing your own procedures}
@author{Samuel A. Rebelsky}

@summary{We explore why and how to define your own procedures in Racket}

@prereqs{@Secref{intro-algorithms} and @secref{intro-racket}}

@section[#:tag "procedures:introduction"]{Introduction}

As you may recall from @seclink["intro-algorithms"]{the introduction
to algorithms}, the ability to write subroutines is one of the key
components of algorithm design.  Subroutines have a @emph{name} that
we use to refer to the subroutine and zero or more @emph{parameters}
that provide the input to the subroutine.

For example, we might want to define a procedure, @code{square}, that
takes as input a number and computes the square of that number.

@(define square-eval (make-base-eval))
@extend-evaluator![square-eval
  (define square (lambda (x) (* x x)))
]
@examples2[square-eval
  (square 5)
  (square 1.5)
  (square 1/3)
  (+ (square 1/2) (square 1/3))
  (square (square 2))
]

Of course, @code{square} can have multiple meanings.  If we're making drawings,
it could also mean @q{make a square}.  Let's consider an example.

@(define color-square-eval (make-img-eval))
@extend-evaluator![color-square-eval
  (define color-square 
    (lambda (side color)
      (rectangle side side 'solid color)))
]
@examples2[color-square-eval
  (color-square 10 "red")
  (color-square 5 "blue")
  (above (color-square 12 "red")
         (beside (color-square 8 "blue")
                 (color-square 8 "purple")))
]

The square is a relatively simple example.  Consider, for example, the
following definition of a simple drawing of a house.

@image-examples[
(overlay/align "center" "bottom"
               (overlay/align "left" "center"
                              (circle 3 "solid" "yellow")
                              (rectangle 15 25 "solid" "brown"))
               (above (triangle 50 "solid" "red")
                      (rectangle 40 50 "solid" "black")))
]

What if we want to make different size or different color houses?
We could copy and paste the code.  But we'd be better off writing
a proedure that takes the size and color as parameters.  house as
a parameter.

@(define house-eval (make-img-eval))
@extend-evaluator![house-eval
(define house
  (lambda (size color)
    (overlay/align 
     "center" "bottom"
     (overlay/align 
      "left" "center"
      (circle (* size 3/50) "solid" "yellow")
      (rectangle (* size 15/50) (* size 25/50) "solid" "brown"))
     (above 
      (triangle size "solid" "red")
      (rectangle (* 4/5 size) size "solid" color)))))
]
@examples2[house-eval
(house 50 "black")
(house 30 "blue")
(beside (house 30 "blue") (house 30 "green") (house 30 "yellow"))
]

@section[#:tag "defining-procedures:basics"]{Defining procedures with @code{lambda}}

Racket provides a variety of mechanisms for defining procedures.  We will
start with the most general.  This mechanism is relatively straightforward.

Typically, we think of a procedure as having three main aspects: The
@emph{name} we use to refer to the procedure, the names of the
@emph{parameters} (inputs) to the procedure, and the @emph{instructions}
the procedure executes.

Here is the general form of procedure definitions in Racket, at least as
we will use them in this class.  The indentation is optional, but recommended.

@codeblock|{
(define procedure-name
  (lambda (formal-parameters)
    instructions))
}|

You've already seen the @code{define}; we use @code{define} to name things.
Inthis case, we're naming a procedure, rather than a value.  The
@emph{procedure-name} part is straightforward; it's the name we will use
to refer to the procedure.  The @q{@code{lambda}} is a special keyword
in Racket to indicate that @q{@emph{Hey! This is a procedure!}}.  (Lambda
has a special place in the history of mathematical logic and programming
language design.  It's special enough that the designers of DrRacket chose
it for the icon.  The @emph{formal-parameters} are the names that we
give to the inputs.  For example, we might call our input to the 
@code{color-square} procedure @code{side-length} and @code{color}.
Finally, the @emph{instructions} are a series of Racket expressions
that explain how to do the associated work.

Let's look at a simple example, that of squaring a number.

@codeblock|{
(define my-square
  (lambda (x)
    (* x x)))
}|

Mentally, most Racket programmers read this as something like
@q{
@code{my-square} names a procedure that takes one input, @code{x}, and
computes its result by multiplying @code{x} by itself.
}

While you will normally define procedures in the definitions pane,
you can also create them in the interactions pane.  Let's see how
this procedure works.

@fundhum-examples[
(define my-square
  (lambda (x)
    (* x x)))
(my-square 5)
(my-square 1/2)
(my-square (my-square 2))
my-square
]

You may note in the last line that when we asked DrRacket for the
@q{value} of @code{my-square}, it told us that it's a procedure
named @code{my-square}.  Compare that for other values we might
define.

@image-examples[
(define x 5)
x
(define phrase "All mimsy were the borogoves")
phrase
(define red-square (rectangle 15 15 "solid" "red"))
red-square
(define multiply *)
multiply
]

In every case, DrRacket is showing us the @emph{value} associated
with the name.  In some cases, it's a number.  In some cases, it's a
string.  In some cases, it's an image.  And in some cases, it's a
procedure.

How does the procedure we've just defined work?  Here's the easiest
way to think about it: When you call a procedure you've defined
with @code{lambda}, DrRacket substitutes in the arguments in the
procedure call for the corresponding parameters within the instructions.
Next, it evaluates the updated instructions.

For example, when you call @code{(my-square 5)}, DrRacket substitutes
@code{5} for @code{x} in @code{(* x x)}, given @code{(* 5 5)}.  It
then evaluates the @code{(* 5 5)}, computing 25.

What about a nested call, such as @code{(my-square (my-square 2))}?  As
you may recall, Racket evaluates nested expressions from the inside
out.  So, it first computes @code{(my-square 2)}.  Substituting 
@code{2} in for @code{x}, it arrives at @code{(* 2 2)}.  The multiplication
gives a value of @code{4}.  It is then left to evaluate
@code{(my-square 4)}.  This time, it substitutes @code{4} in for the
@code{x}, giving it @code{(* 4 4)}.  It does the multiplication to
arrive at a result of @code{16}.

We might show the steps as follows, with the @verb{=>} symbol representing
the conversion that happens at each step.

@text-block|{
(my-square (my-square 2))
=> (my-square (* 2 2))
=> (my-square 4)
=> (* 4 4)
=> 16
}|

@section{Additional examples}

You may recall that our second example involved writing a procedure
that makes squares of a specified side length and color.  A square
is just a rectangle with both sides the same size.  So, if we want
a procedure to make squares, we'll just call the @code{rectangle}
procedure, using the same value for the width and height.

@codeblock|{
(define color-square
  (lambda (side color)
    (rectangle side side "solid" color)))
}|

What happens if we call @code{color-square} on inputs of @code{15} and
@code{"red"}.  It substitutes @code{15} for @code{side} and @code{"red"}
for color, giving us @code{(rectangle 15 15 "solid" "red")}.  And, as
we saw in the examples above, that's a red square of side-length 15.

What about the house example?  Let's look at a simpler version, one
that does not include the door.  If we did not care about resizing
the house, we might just write an expression like

@text-block|{
(above (triangle 50 "solid" "red")
       (rectangle 40 50 "solid" "black"))
}|

But we'd like to @q{parameterize} the code to take the size as an
input.  Let's say that the size corresponds to the side-length of
the triangle (or the size of the main body of the house).  We will
replace each @code{50} by @code{size} and replace @code{40} by
@code{(* 4/5 size)}.  Let's see how that works.

@(define new-house-eval (make-img-eval))
@examples2[new-house-eval
(define simple-house
  (lambda (size)
    (above (triangle size "solid" "red")
           (rectangle (* 4/5 size) size "solid" "black"))))
(simple-house 20)
(simple-house 30)
]

@section[#:tag "procedures-zero-param"]{Zero-parameter procedures}

We've written procedures so that they take an input.  However, there
are also advantages to writing procedures that take no inputs.  In
those cases, a procedure just tells us how to compute a value.  Is
that different than naming just naming the value?  A bit.  Let's
explore those differences.

Consider the following two definitions, each of which creates a series of
houses.

@examples2[new-house-eval
(define house-grid 
  (above (beside (simple-house 20) (simple-house 20))
         (beside (simple-house 20) (simple-house 20))))
(define house-seq
  (lambda ()
    (beside/align "bottom"
                   (simple-house 10) (simple-house 15) 
                   (simple-house 20) (simple-house 25))))
]

The first definition, for @code{house-grid} defines a value.  (It's a value
which is an image, but it's still a value.)  In contrast, the definition
for @code{house-seq} defines a procedure.  We refer to values and procedures
differently.

@examples2[new-house-eval
house-grid
house-seq
(house-seq)
(eval:error (house-grid))
]

But the differences go beyond the particular syntax in which we use
them.  When you define a named value, DrRacket evaluates the
instructions immediately and then stores the result.  When you ask
for a named value, DrRacket looks up the value and uses it.  When
you ask DrRacket to evaluate a zero-parameter procedure, it runs
the instructions again.  You can see the effects when we change
the definition of @code{simple-house}

@examples2[new-house-eval
(define simple-house
  (lambda (size)
    (above (triangle size "solid" "darkred")
           (rectangle (* 4/5 size) size "solid" "gray"))))
house-grid
(house-seq)
]

That is, because we'd created @code{house-grid} while the old
version of @code{simple-house} was in effect, the image associated
with @code{house-grid} does not change.
However, since the new definition of @code{simple-house} is in
effect when we @emph{call} @code{house-seq}, it uses the new
definition and we get a sequence of houses that use the new
definition.

@section[#:tag "procedures:benefits"]{Some benefits of procedures}

As you may have figured out by now, there are many benefits to
defining your own procedures.  One of the most important is
@emph{clarity} or @emph{readability}.  Another programmer will
likely spend less effort understanding @code{(simple-house 20)}
than they will trying to understand the more complex @code{above}
expression involving triangles and rectangles.  The first is clearly
intended to be a house.  The second could be anything, at least
until you see it.  The other programmer may also find it easier to
@emph{write} programs using @code{simple-house} than the much longer
series of expressions.

By using a name for a set of code, we are employing the concept of
@emph{abstraction}.  That is, because the person calling the procedure
knows @emph{what} the procedure does rather than @emph{how} it achieves
that result, we have abstracted away some of the details.

There are benefits to abstraction and the use of procedures other
than readability.  For example, it may be that you discover a more
efficient way to do a computation.  If you've written the same code
for the computation throughout your program, you'll have a lot of
code to update.  But if you've created a procedure, you need only
update one place in your code, the place you've defined the procedure.

The @code{house-seq} example above illustrates a similar point.
When we decide to change the color of the house and the roof, we only
had to make the change in one place, in the definition of 
@code{simple-house}.  If we had, instead, created each house within
@code{house-seq}, we would have multiple places to update.

As these examples suggest, using procedures to parameterize and
name sections of code provide us with a variety of advantages.
First, we can more easily @emph{reuse} code in different places.
Rather than copying, pasting, and changing, we can simply call the
procedure with new parameters.  Second, others can more easily
@emph{read} the code we have written.  Third, we can more easily
@emph{update} the procedures we've written, either to make them
more efficient or to change behavior universally.

@section:self-checks{}

@self-check{A simple procedure}

Write a procedure, @code{(subtract2 val)} that takes a number as input
and subtracts 2 from that number.

@(define proc-self-check-1-eval (make-fundhum-eval))
@examples2[proc-self-check-1-eval
  #:hidden
  (define subtract2 (lambda (x) (- x 2)))
]
@examples2[proc-self-check-1-eval
  (subtract2 5)
  (subtract2 3.25)
  (eval:error (subtract2 "hello"))
]

@self-check{Exploring steps}

Show the steps involved in computing @code{(square (subtract2 5))}
and @code{(subtract2 (square 5))}.

@section:acknowledgements{}

This section draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/procedures"]{a
reading entitled @q{Defining your own procedures}} and
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2017S/readings/procedures-rgb-reading.html"]{an earlier reading entitled @q{Writing your own procedures}} from Grinnell College's CSC 151.

The house drawing was inspired by a more 
sophisticated house drawing from 
the @hyperlink["https://docs.racket-lang.org/teachpack/2htdpimage-guide.html"]{Racket Image Guide}.

