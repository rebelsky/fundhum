#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@title[#:tag "procedures-hop"]{Other ways to write procedures}
@author{Samuel A. Rebelsky}
@prefix{procedures-hop}

@summary{While lambda expressions are the most common way to write procedures,
there are also a vareity of others.  We consider how to use composition and
sectioning to build new procedures from old.}

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
values using exprssions or constants.

@codeblock|{
(define x (+ 1 5))
(define x 6)
}|

Lisp, Scheme, and Racket set themselves apart from many programming
languages by permitting you to use a variety of kinds of expressions
to define procedures.  You've already seen two: lambda expressions
and existing procedures.  We'll explore two more: composition
and sectioning.  Just as ....

@section[#:tag "procedures-hop:composition"]{Building new procedures through composition}

@;{quad = (o square square) or add2 = (o add1 add1)}

@section[#:tag "procedures-hop:sectioning"]{Building new procedures through sectioning}

@;{cube?}

@section:self-checks{}

@self-check{_TITLE_}

@section:acknowledgements{}

This section draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/_WHATEVER_"]{_DESCRIPTION_} from Grinnell College's CSC 151.

