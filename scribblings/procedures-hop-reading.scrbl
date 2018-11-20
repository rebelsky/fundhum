#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@title[#:tag "procedures-hop"]{Other ways to write procedures}
@author{Samuel A. Rebelsky}
@prefix{procedures-hop}

@summary{While lambda expressions are the most common way to write procedures,
there are also a variety of others.  We consider how to use composition and
partial expressions to build new procedures from old.}

@prereqs{@Secref{procedures}}

@section[#:tag "procedures-hop:introduction"]{Introduction}

You've learned the most common approach we will use to defining procedures.
To define a procedure, you use a form like the following.

@codeblock|{
(define procedure-name
  (lambda (formal-parameters)
    body))
}|

If we wanted to define a procedure, @code{add}, that adds two values, we
might write something like the following.

@codeblock|{
(define add
  (lambda (x y)
    (+ x y)))
}|

However, you've already seen another way to define a procedure.  Instead
of the @code{lambda} expression, you can use a procedure that already
exists.  For example,

@codeblock|{
(define add +)
}|

How are these two definitions similar?  Both use the @code{define} keyword
to associate a name (@code{add}) with something that defines a procedure.
In the first case, it's a lambda expression.  In the second, it's an existing
procedure.  Perhaps that's not surprising.  We can also define numeric
values using expressions or constants.

@codeblock|{
(define x (+ 1 5))
(define x 6)
}|

Lisp, Scheme, and Racket set themselves apart from many programming
languages by permitting you to use a variety of kinds of expressions
to define procedures.  You've already seen two: lambda expressions
and existing procedures.  We'll explore two more: composition and
partial expressions.  Just as an arithmetic operation, like @verb{+},
creates a numerical value, the composition and partial-expression
operations create a procedural value.

@section[#:tag "procedures-hop:composition"]{Building new procedures through composition}

You may have already seen composition in your study of mathematics.
The composition of two functions, @emph{f} and @emph{g}, is written
@emph{f}∘@emph{g} and represents a function that first applies
@emph{g} and then @emph{f}.  That is, (@emph{f}∘@emph{g})(@emph{x})
= @emph{f}(@emph{g}(@emph{x})).

In the Racket library for FunDHum, we use @code{o} to represent
function composition.  Let's start by composing a few procedures
with themselves.

@fundhum-examples[
(square 3)
(define quad (o square square))
quad
(quad 3)
(add1 3)
(define add2 (o add1 add1))
add2
(add2 3)
]

As these examples suggest, both @code{quad} and @code{add2} are
procedures.  We've created these procedures in a new way, without
a @code{lambda} or just renaming an existing procedure.  The
@code{quad} procedure squares its parameter and then squares it
again (3*3 is 9, 9*9 is 81).  The @code{add2} procedure adds one
to its parameter and then adds another one.

What happens if we compose two different procedures?  Let's check.

@fundhum-examples[
(define f1 (o square add1))
(f1 4)
(define f2 (o add1 square))
(f2 4)
]

As these examples suggest, the composed procedure applies the other
procedures from right to left.  That is, @code{f1} adds one to its
parameter and then squares its result, and @code{f2} squares is
parameter and then adds 1.  If we wanted to make it perfectly
clear what we want each procedure to do, we could name them as follows.

@fundhum-examples[
(define add1-then-square (o square add1))
(add1-then-square 4)
(define square-then-add1 (o add1 square))
(square-then-add1 4)
]

Some programmers find this right-to-left behavior perfectly natural
since it mimics both mathematics and the way we write things in
Scheme.  That is, if we want to add1 and then square, we write
@code{(square (add1 5))}, with the first operation on the right.
Others find the right-to-left behavior backwards, since we speak
of the operations from left to write (@q{add then square}).  For
now, we'll stick with the right-to-left behavior.  Later in the
semester, we will explore some variants of the composition operation.

You can also compose more than two procedures.  For example, we might
write the following silly procedure.

@fundhum-examples[
(define fun (o add1 square add1))
]

@section[#:tag "procedures-hop:sectioning"]{Building new procedures through partial expressions}

As you may have noted, although procedure composition is useful,
it is limited.  You can only compose unary (one-parameter) procedures.
There are certainly a host of other kinds of procedures we'd like to
write.  For example, we might want to write a procedure that computes
one half of its parameter.  We can certainly use @code{lambda}

@codeblock|{
(define half
  (lambda (x)
    (/ x 2)))
}|

But that may seem like a lot to write when all we're really doing
is saying @q{divide <the parameter> by two}.  Fortunately, the
@code{loudhum} library provides a keyword, @code{Px}, that allows you to
build a procedure from a @q{partial expression}, one in which some
parts may have the special value @code{_}, which we call @q{underscore},
that indicates @q{make this a parameter to the function}.  Here's
how we'd define @q{half} using @q{P}.

@fundhum-examples[
(define half (Px (/ _ 2)))
half
(half 4)
(half 5)
]

Note that the location of the underscore is important.  Since the first
parameter to the division operation is the dividend and the second 
is the divisor, the diamond in @code{half} suggests that the input
will be the dividend.  Let's look at the opposite definition.

@fundhum-examples[
(define flah (Px (/ 2 _)))
flah
(flah 4)
(flah 5)
]

You can also specify more than one parameter in a procedure that you
build from a partial expression.  In that case, the parameters are taken
from left-to-right in the expression.

@fundhum-examples[
(define story (Px (string-append _ " and " _ " went up the hill.")))
(story "Jack" "Jill")
(story "Bob" "Bill")
(story "Joni" "Chuck")
]

What happens when you want to use the same parameter multiple times
in a partial expression?  That's not possible.  Once your procedures
reach those levels of complexity, you should use @code{lambda}
expressions.

@section[#:tag "procedures-hop:combining"]{Combining composition and partial functions}

Composition and partial functions provide a concise syntax for defining
certain kinds of procedures.  Composition works only for one-parameter
procedures.  Partial functions only work when you're filling in some
parameters of a multi-parameter procedure.  What if you want to do both?
For example, consider the problem of counting the number of words in a
string.  While we haven't explored all the component parts in close detail,
we have seen all of them.

You may recall from early examples that @code{string-split} converts a
string into a list by dividing the string at a particular character.

@fundhum-examples[
(string-split "Jack and Jill went up the hill" " ")
(string-split "Beware the Jabberwock, my son!" " ")
]

The @code{length} procedure tells us how many characters there are in
a list.

@fundhum-examples[
(length (list 4 8 11))
]

So, to count the number of words in a string, we might split the string
into a list and then count the number of elements in that list.  We can
write that with @code{lambda} as follows.

@fundhum-examples[
(define numwords
  (lambda (str)
    (length (string-split str " "))))
(numwords "Jack and Jill went up the hill")
]

But we can also define it slightly more concisely with

@fundhum-examples[
(define numwords 
  (o length (Px (string-split _ " "))))
(numwords "Beware the Jabberwock, my son!")
]

Does a savings of ten or so characters make a huge difference?  In most
cases, probably not.  But there are some situations in which it can help.
Some programmers also find the procedures written with @code{o} and
@code{P} easier to read.  And, in any case, it's useful to think about
writing procedures that return new procedures.  We call such things
@q{higher-order procedures}.  You will use and read composition and
partial functions regularly.  Later in the semester, you will learn how
to write your own higher-order procedures.

@section:self-checks{}

@self-check{Subtracting two}

Give three ways to define a procedure, @code{subtract3}, that takes
a number as input and subtracts 3 from that number.

@itemize{
@item{Using the composition operation, @code{o}. Note that you can use @code{sub1}, which subtracts 
  one from its parameter.}
@item{Using partial expressions and @code{P}.}
@item{Using @code{lambda}.}
}

@noindent{}
Which of the three do you prefer?  Why?

@section:acknowledgements{}

Most of this reading is new.  However, some examples are taken from
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/procedures"]{a
reading entitled @q{Defining your own procedures}} from Grinnell
College's CSC 151.
