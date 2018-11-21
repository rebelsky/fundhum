#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@prefix{numbers}
@title[#:tag (prefix)]{Numeric values}
@author{Samuel A. Rebelsky}

@summary{We examine a variety of issues pertaining to numeric values
in Racket, including the types of numbers that Racket supports and
some common numeric functions.}

@prereqs{@Secref{intro-racket} and @secref{data-types}}

@section[#:tag "numbers:introduction"]{Introduction}

Computer scientists write algorithms for a variety of problems.
Some types of computation, such as representation of knowledge, use
symbols and lists. Others, such as the construction of Web pages,
may involve the manipulation of strings (sequences of alphabetic
characters).  Even when working with text, a significant amount of
computation involves numbers.  And, even though numbers seem simple,
it turns out that there are some subtleties to the representation
of numbers in Racket.

As you may recall from @seclink["data-types"]{our first discussion
of data types}, when learning about data types, you should consider
the @emph{name} of teach type, its @emph{purpose}, how DrRacket
@emph{displays} values in the type, how you @emph{express} those
values, and what @emph{operations} are available for those values.

While it seems like @q{numbers} is an obvious name for this type,
Racket provides multiple kinds of numeric values.  In each case,
the purpose is the same: to support computation that involves
numbers.

@section[#:tag "numbers:categories"]{Categories of numeric values}

As you probably learned in secondary school, there are a variety
of categories of numeric values. The most common categories are
@emph{integers}, (numbers with no fractional component), @emph{rational
numbers} (numbers that can be expressed as the ratio of two integers),
and @emph{real numbers} (numbers that can be plotted on a number
line).  DrRacket also permits @emph{complex numbers} (numbers that
can include an imaginary component).

In traditional mathematics, each category is a subset of
the next category.  That is, every integer is a rational number
because it can be expressed with a denominator of zero, every rational
number is a real number because it can be plotted on the number line,
and every real number is complex because it can be expressed with a
an imaginary component of zero.

In contrast, Racket does not readily distinguish the rational and
real numbers.  There's an underlying philosophy for this choice; behind
the scenes, every real number is represented as a rational number.

However, Racket does distinguish between numbers in another way:
Some numbers it represents precisely and some numbers it approximates.
Why does it make that choice?  In part, because most programming
languages include at least one approximate representation.  In part,
because working with precise representations of very large numbers
may be both computationally expensive and misleading (e.g., we may
think that our computations are more prceise than they are).

How can you tell the difference?  When DrRacket displays a number
that may be approximated (which we will refer to as an @emph{inexact
number}), it includes a decimal point, an exponentional component
in the result, or both.

@fundhum-examples[
(code:line (sqrt 2) (code:comment "The square root of 2"))
(code:line (expt 3.0 100) (code:comment "3.0 to the 100th power"))
]

Why is the square root of 2 approximated?  Because it's impossible
to represent precisely as a finite decimal number.  That means that
DrRacket approximates it.  And, because it's approximated, our
calculations using that result will also be approximate.

@fundhum-examples[
(* (sqrt 2) (sqrt 2))
]

The decimal sign warns us that we are straying into the realm of
estimations and approximations.

In contrast, when displaying a number that it has represented exactly,
DrRacket includes no decimal point.

@fundhum-examples[
(/ 3 6)
(expt 3 100)
(sqrt -4)
]

You can express values to DrRacket using similar notation.  That is,
when you want an exact number, you do not include a decimal point or
the exponent.  When you want a constant rational number (one that does
not involve variables), you can write the numerator, a slash, and
the denominator.  When you want a complex number, you write a plus sign
between the two halves and put an @code{i} at the end.

@fundhum-examples[
1/2
0.5
1/7
(* 3+4i 0+i)
]

If you've been keeping track, you may have realized that we have
at least six different kinds of numbers in DrRacket: exact integers,
inexact integers, exact real/rational numbers (we'll call these
@q{rational numbers}), inexact real/rational numbers (we'll call
these @q{real numbers}), exact complex numbers, and inexact complex
numbers.  You will find that each has its own particular use.  When
we want to be precise, such as when dealing with financial matters,
we will use exact numbers (most likely, exact integers).  When the
computation does not permit exact representation, such as when we
start to deal with certain square roots, we will use inexact values.
What about complex numbers?  We'll generally leave those to the
physicists.

When describing the procedures that work with numbers, we should
try to describe how the type of the result depends on the type of
the input.  For example, the addition operator, @code{,+} provides
an exact result only when all of its inputs are exact. 

@fundhum-examples[
(+ 2 3 4)
(+ 2 3.0 4)
(+ 2 1/3 5)
(+ 2 3.0 -3.0)
]

As the final example suggests, Racket will give an inexact output 
even if the inexact components @q{cancel out}.  That's a sensible
approach; once you've introduced approximations into your computation,
you should accept that it's approximate.

@section[#:tag "numbers:operations"]{Numeric operations}

You've already enountered the four basic arithmetic operations of
addition (@code{+}), subtraction (@code{-}), multiplication (@code{*}),
and division (@code{/}).  But those are not the only basic arithmetic
operations available.  Racket also provides a host of other numeric
operations.  We'll introduce most as they become necessary.  For
now, we'll start with a few basics.

@subsection[#:tag "numbers:integer-division"]{Integer division}

In addition to @q{real division}, Racket also provides two procedures
that handle @q{integer division}, @code{quotient} and @code{remainder}.
Integer division is is likely the kind of division you first learned;
when you divide one integer by a number, you get an integer result
(the quotient) with, potentially, some left over (the remainder).
For example, if you have to divide eleven jelly beans among four
people, each person will get two (the quotient) and you'll have
three left over (the remainder).

@fundhum-examples[
(quotient 11 4)
(remainder 11 4)
(quotient 15 5)
(remainder 15 5)
]

You can also do integer division with inexact integers.  In that case,
you will get an inexact result.

@fundhum-examples[
(quotient 11 4.0)
(remainder 11.0 4)
]

We do not recommend that you use inexact integers.  Nonetheless, when
exploring a new procedure, it is useful to consider the different kinds
of inputs that the procedure might or might not take.  And, on that
note, let's see what happens when you try to do integer division with
non-integers.

@fundhum-examples[
(eval:error (quotient 11/2 2))
(eval:error (remainder 11 2.5))
]

As you might have expected, DrRacket issues errors for each of those
cases.

What about negative integers? When you first learned integer division,
you probably didn't think about what happened when the dividend or
divisor is negative.  But the designers of these operations needed
to decide how to handle those cases.  Let's see what happens.

@fundhum-examples[
(quotient -11 4)
(remainder -11 4)
(quotient 11 -4)
(remainder 11 -4)
(quotient -11 -4)
(remainder -11 -4)
]

The first pair makes sense because -11 = -2*4 + -3.  The second
pair makes sense because 11 = -2*-4 + 3.  The third pair makes sense
because -11 = 2*-4 + -3.  So all of the computations are consistent.
But why don't we say that -11 = -3*4 + 1, which also seems to give
a quotient and remainder?  The designers of these operations decided
that the remainder should always have the same sign as the dividend,
which therefore tells us what the quotient should be.

While that's likely more detail than you needed to know, it's important
to remember that what happens in most procedures are not because of
some universal law, but because a designer made a decision, one that
should have some underlying rationale.

@subsection[#:tag "numbers:expt"]{Roots and exponents}

As you've seen, Racket provides ways to compute the square root of
a number, using @code{(sqrt x n)} and to compute @q{x to the n}
using @code{(expt x n)}.  When given inexact inputs, both return
inexact results.  Both will provide an exact output if they are
able to compute one and an inexact output otherwise.

@fundhum-examples[
(sqrt 4)
(sqrt 4.0)
(sqrt 2)
(sqrt -16)
(sqrt -2)
(sqrt 1+i)
(expt 2 10)
(expt 2 10.0)
(expt 2.0 10)
(expt 3 -5)
(expt 4 1/2)
(expt 1/9 1/2)
(expt 2 1/2)
(expt 243 1/5)
(expt 1+i 4)
(expt 1.0+i 4)
]

@subsection[#:tag "numbers:minmax"]{Finding small and large values}

Racket provides the @code{(max val1 val2 ...)} and @code{(min val1 val2
...)} procedures to find the largest or smallest in a set of values.  Both
of these procedures will produce an exact number only when all of the
arguments are exact.  As you might expect, the value produced will be
an integer only when it meets the criterion of being largest or smallest.

@fundhum-examples[
(max 1 2 3)
(max 3 1 2)
(max 2 1 3)
(max 1 2 3 1.5)
(max 1 1/3 3 1/5)
(max 7/2 2 3)
(min 1 1/3 3)
(min 3 1 2 4 8 7 -1)
(min 3 1 2 4/3 8.0 7)
(eval:error (min 3 1 2+i))
]

As the last example suggests, @code{max} and @code{min} won't work with
complex numbers.

@subsection[#:tag "numbers:pull-apart"]{Extracting parts of compound values}

Racket also provides a way to @q{pull apart} rational and complex numbers
using the procedures @code{(numerator num)}, @code{(denominator num)},
@code{(real-part num)} and @code{(imag-part num)}.

@fundhum-examples[
(numerator 3/5)
(denominator 3/5)
(numerator -13/7)
(denominator -13/7)
(numerator 0.5)
(denominator 0.5)
(numerator 11)
(denominator 11.0)
]

@fundhum-examples[
(real-part 3+4i)
(imag-part 3+4i)
(real-part 5.0+11i)
(imag-part 5.0+11i)
(real-part 1/3)
(imag-part 1/3)
]

@subsection[#:tag "numbers:rounding"]{Rounding}

Racket provides @emph{four} different ways to round real numbers
to nearby integers.  @code{(round num)} rounds to the nearest
integer.  @code{(floor num)} rounds down.  @code{(ceiling num)}
rounds up.  @code{(truncate num)} throws away the fractional part,
effectively rounding toward zero.

@fundhum-examples[
(round 3.2)
(round 3.8)
(floor 3.8)
(ceiling 3.8)
(truncate 3.8)
(floor -3.8)
(truncate -3.8)
]

@section:self-checks{}

@self-check{Exploring exponentiation}

In the examples above, we gave a wide variety of examples of the
@code{expt} procedure in action.  Each was intended to reveal
something different about that procedure.  They were also intended
to suggest the kinds of exploration you might do when you encounter
or design a new procedure.

Suggest what we are trying to reveal for each of the following.
For example, the for the second, you might note that the first
example suggests that if the exponent is inexact, the result is
inexact, even if the base and the exponent are integers.

@codeblock|{
(expt 2 10.0)
(expt 2.0 10)
(expt 3 -5)
(expt 4 1/2)
(expt 1/9 1/2)
(expt 2 1/2)
(expt 243 1/5)
(expt 1+i 4)
(expt 1.0+i 4)
}|

@section:acknowledgements{}

This section draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/numbers"]{A reading entitled @q{Numeric values in Scheme}} from Grinnell College's CSC 151.

