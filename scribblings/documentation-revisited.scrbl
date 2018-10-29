#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@title[#:tag "documentation-revisited"]{Documenting procedures, revisited}
@author{Samuel A. Rebelsky}
@prefix{documentation-revisited}

@summary{As you prepare to regularly document your procedures, we revisit 
the Six-P documentation style.}

@prereqs{@Secref{Documentation}}

@section[#:tag "documentation-revisited:introduction"]{Introduction}

When @seclink["documentation"]{you first learned about documentation},
it was primarily to prepare you to @emph{read} documentation.  You now
have enough experience with Racket that you should begin to @emph{write}
your own documentation.  As you read additional details about documentation,
you will find it useful to refer back to that earlier reading.

@section[#:tag "documentation-revisited:prepost"]{Additional details about preconditions and postconditions}

As you may recall, the first four P's (Procedure, Parameters, Purpose,
and Produces) give an informal definition of what a procedure does.  The
last two P's provide a much more formal definition.

@;{Insert text from the latest version of the reading.}

@section[#:tag "documentation-revisited:example"]{An example}

@;{This probably requires a new example.}

@section:self-checks{}

@self-check{Document @code{proc}}

Write the 6P-style documentation for the @code{proc} procedure you recently
wrote.

@self-check{How many P's?}

We tend to focus on 6Ps. But there are others. How many P's are
there in total? And what are they? What other characteristics of
your procedures might be useful to document?  (You need not come up
with words that start with the letter P.)

@section:acknowledgements{}

This section draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/documentation"]{a reading entitled @q{Documenting your procedures}} from Grinnell College's CSC 151.  @hyperlink["http://www.cs.grinnell.edu/~rebelsky/Courses/CS151/2007F/Readings/documentation-reading.html"]{The original version of that reading} appeared in Fall 2007.
