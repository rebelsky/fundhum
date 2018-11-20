#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@prefix{simple-lists}
@title[#:tag (prefix)]{List basics}
@author{Samuel A. Rebelsky}

@summary{We consider some basic issues of Racket's @emph{list} data
type, which is used to collect multiple values.  We explore the ways
to create lists and a few operations used to manipulate lists.}

@prereqs{@Secref{data-types} and @secref{intro-racket}}

@section[#:tag "simple-lists:introduction"]{Introduction}

In your initial explorations with Racket you have investigated a
variety of basic types of data, including numbers, strings, and
images. You can work on many kinds of problems with just these
types. However, when you want to address more complex problems,
particularly problems from data science, you will need to work with
collections of data - not just the rating of a movie from one
newspaper, but the rating of that movie from many newspapers (or
even the ratings of many movies from many newspapers); not just one
word, but a sequence of words.

In Scheme, the simplest mechanism for dealing with collections of
data is the @emph{list} data type. Lists are collections of values
that you can process one-by-one or en masse.  In this reading, we
will consider Scheme’s list data type as well as a few procedures to 
build and manipulate lists.  We will return to lists in a near future.

You may recall that there are five basic issues we should consider
when we encounter a new type: its @emph{name}, its @emph{purpose}, how one 
@emph{expresses values} in the type, how the computer @emph{displays} values 
in the type, and what @emph{operations} are available to you.  (It may
seem that we are repeating this list of issues; that's because we want
you to accustom yourself to asking about those five issues each time you
encounter or design a new type.)

We've already covered the first two: The name of the type is @q{list} and 
its primary purpose is to group or collect values.  Let's explore the rest.

@section[#:tag "simple-lists:display"]{Displaying lists}

Because of some early decisions in the design of Lisp, the precursor
to Scheme, the precursor to Racket, lists in Racket look a lot like
procedure calls.  That is, they have an open parenthesis, a bunch
of values separated by spaces, and a close parenthesis.  The
individual values can also themselves be lists.  However, Racket
distinguishes lists from expressions with a tick mark (a single-quotation
mark).  For example, while @code{(+ 2 3)} is an expression that
indicates that the computer should add the numbers 2 and 3, @code{'(+
2 3)} is a list with three values, the symbol @code{+} and the
numbers @code{2} and @code{3}.  You will always see this tick mark
on lists that Racket displays.

@fundhum-examples[
(+ 2 3)
'(+ 2 3)
(string-split "the jaws that bite the claws that catch" " ")
(list 1 2 3)
]

@section[#:tag "simple-lists:create"]{Creating lists}

Because lists play a central role in Racket, there a wide variety
of ways to create lists.  One common way to create lists is with
the @code{(list exp0 exp1 ...)} procedure, which evaluates all of its parameters
and creates a list from those parameters.

@fundhum-examples[
(list 2 3 5 7)
(list "two" "three" "five" "seven")
(list 1 (+ 2 3) 4)
(list 1 (list + 2 3) 4)
(list 1 (list '+ 2 3) 4)
(list)
]

If you need a list of identical values for some reason, you can
use the @code{(make-list n val)} procedure, which takes two parameters:
the number of copies of a value to make in the list and the
particular value to copy.

@fundhum-examples[
(make-list 5 "hello")
(make-list 2 4)
(make-list 4 2)
]

Because we often find that we need a sequence of numbers, Racket
includes a procedure called @code{(range lower upper)} that takes two integers
as parameters and produces a list of all the numbers greater than
or equal to the first and less than the second.

@fundhum-examples[
(range 7 11)
(range 2 9)
(range -2 3)
]

There's also a one-parameter version of @code{range} that produces
all the natural numbers less than the parameter.

@fundhum-examples[
(range 7)
(range 4)
]

While we do not recommend it, you can write @quote{list literals}
using the same syntax as the Racket interpreter; that is, if you
write a tick mark before an open parentheses, the Racket interpreter
will treat everything inside as a list, including any nested lists.

@fundhum-examples[
'(7 11 doubles)
'()
]

A bit later in the course, we'll learn how to build lists piece by piece.

@section[#:tag "simple-lists:operations"]{Some list operations}

Perhaps the simplest list operation is @code{(length lst)}, which gives you
the number of elements in the list.

@fundhum-examples[
(length (list))
(length (list 3 4 5))
(length (string-split "he took his vorpal sword in hand" " "))
]

You can also extract an element of a list using the @code{(list-ref
list index)} operation.  In Racket, the position of an element is
the number of values that appear before that element; hence, the
initial element of a list is element 0, not element 1.

@fundhum-examples[
(define observation (list "Computers" "are" "sentient" "and" "Malicious"))
observation
(list-ref observation 0)
(list-ref observation 2)
(length observation)
(list-ref observation 4)
(eval:error (list-ref observation 5))
]

The @code{(index-of lst val)} procedure serves as something like
the opposite of @code{list-ref}: Given a list and an element, it
returns the position (index) of the first instance of that element.

@fundhum-examples[
(define lead-in (list "a" "one" "and" "a" "two" "and" "a" "..."))
(index-of lead-in "one")
(index-of lead-in "and")
(list-ref lead-in (index-of lead-in "and"))
]

The similar @code{(indexes-of lst val)} (we would have named it
@code{indices-of}) returns a list of all the indices of a value in
a list.

@fundhum-examples[
(indexes-of lead-in "a")
(indexes-of lead-in "and")
]

The @code{(reverse lst)} procedure creates a new list that consists of
the same elements as @code{lst}, but in the opposite order.

@fundhum-examples[
(reverse (range 10))
(reverse (list 'a 'b 'c 'd 'e))
]

The @code{(append lst1 lst2)} procedure creates a new list that consists
of all the elements of the first list followed by the elements of the
second list.

@fundhum-examples[
(append (range 5) (range 5))
(append (make-list 3 'hello) (make-list 4 'echo))
]

The @code{(take lst n)} builds a new list that consists of the first
@code{n} elements of @code{lst} and the @code{(drop lst n)} builds a
list by removing the first @code{n} elements of @code{lst}.

@fundhum-examples[
(define some-ia-counties 
  (list "Adair" "Adams" "Alamakee" "Appanoose" "Audobon"))
(take some-ia-counties 3)
(drop some-ia-counties 3)
(take (reverse some-ia-counties) 2)
]

@section:self-checks{}

@self-check{Checking list procedures}

Predict the resutls of evaluating each of the following expressions.

@codeblock|{
(list 2 1)
(make-list 1 2)
(make-list -1 2)
(append (list 2 1) (list 2 1))
(index-of 1 (list 1 2))
(index-of 3 (list 1 2))
(range -3 0)
(range 3)
(range 0)
}|

@self-check{Ranges, revisited}

Suppose we only had the one-parameter version of @code{range}.  How
could you make the list @code{'(6 5 4 3)}?

@section:acknowledgements{}

This section draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/simple-lists"]{a reading entitled @q{Making and manipulating simple lists}} from Grinnell College's CSC 151.

