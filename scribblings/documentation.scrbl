#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@title[#:tag "documentation"]{Documenting your procedures}
@author{Samuel A. Rebelsky}
@prefix{documentation}

@summary{We consider reasons and techniques for documenting procedures}

@prereqs{@Secref{procedures}}

@noindent{}@emph{Note:}In this reading, we consider the documentation
format we use in this course.  Although this reading introduces that
format, you will not be expected to document your procedures
until you've developed a bit more experience in writing Racket code.

@section[#:tag "documentation:introduction"]{Introduction}

When programmers write code, they also document that code; that is, they write natural language and a bit of mathematics to clarify what their code does. The computer certainly doesn’t need any such documentation (and even ignores it), so why should one take the time to write documentation? There are a host of reasons.

@itemize{

@item{The design of an algorithm may not be obvious. Documentation
can explain how the algorithm works.}

@item{Particular details of the implementation of the algorithm may
include subtleties. Documentation can explain those subtleties.}

@item{Programmers who use a procedure (a.k.a. “client programmers”)
should be able to focus more on what the procedure does, rather
than how the procedure does its job. You can certainly use @code{sqrt},
@code{above}, @code{string-split}, and a host of other procedures
without understanding how they are defined.}

}

As all three examples suggest, when we write code, we write not
just for the computer, but also for a human reader. Even the best
of code needs to be checked again on occasion, and lots of code
gets modified for new purposes. Good documentation helps those who
must support or modify the code understand it. And while humans
should be able to read code, most read code more easily if the code
has comments.

@section[#:tag "documentation:audience"]{The audience for documentation}

As you should have learned in Tutorial, every writer needs to keep
in mind not only the topic they are writing about, but also the
audience for whom they are writing. This understanding of audience
is equally important when writing documentation.

One way to think about your audience is in terms of how the reader
will be using your code. Some readers will read your code to
understand techniques that they plan to use in other situations.
Other readers will be responsible for maintaining and updating your
code. Most readers will use the procedures you write. We call the
people who use our procedures @q{clients}.  You are often your own
client. For example, you are likely to reuse procedures you wrote
early in the semester. The documentation you write for your client
programmers is the most important documentation you can write.

As we noted in the discussion of @seclink["procedures"]{procedures},
one of the main benefits of writing procedures is that procedures
provide a form of @emph{abstaction}, when you use a procedure, you
care more about @emph{what} the procedure does than @emph{how}.  Hence,
the focus of most procedure documentation is the abstract behavior
not the detailed process.  If your client cares most about @emph{what}
your procedures do, your main goals are to explain the kinds of input
the procedure expects, what the procedure computes, and what the 
results look like.

Of course, you need to think about more than how your audience will
use your code. You also need to think about what they know and don't
know. Because you are novices, you should generally plan to write
for people like you: Assume that your client programmers know very
little about Racket or the broader context in which you've written
your procedures.

@section[#:tag "documentation:sixps"]{Documenting procedures with the Six P's}

Different organizations have different styles of documentation.
After too many years documenting procedures and teaching students
to document procedures, we've developed a style that we find helps
students think carefully about their work. While it does not correspond
to the @q{standard} style of documentation, it has proven useful.

To keep it easy to remember what belongs in the documentation for
a procedure, you should focus on “the Six P’s”: Procedure, Parameters,
Purpose, Produces, Preconditions, and Postconditions.

The @emph{Procedure} section simply names the procedure. Although
the name of the procedure should be obvious from the code, by
including the name in the documentation, we make it possible for
the client programmer to learn about the procedure only through the
documentation.

The @emph{Parameters} section names the inputs to the procedure
and gives them types. For example, if a procedure operates only on
numbers or only on positive integers, the parameters section should
indicate so.

The @emph{Purpose} section presents a few sentences or sentence
fragments that describe what the procedure is supposed to do. The
sentences need not be as precise as what you’d give a computer, but
they should be clear to the “average” programmer. (As you’ve learned
in your other writing, write to your audience.)

The @emph{Produces} section provides a name and type for the result
of the procedure. Often, the result is not named in the underlying
code.  So why do we both to include such a section? Because naming
the result lets us discuss it, either in the purpose above or in
the preconditions and postconditions below.  Your client programmer
will often care more about the @emph{type} of the result: Do you
create an image, a number, a string, a procedure, something else?
Particularly as clients need to use the output of one procedure for
the input of another procedure, it's helpful to know as much as
possible about the output.  

The first four P's are a good starting point.  As you document your
procedure, they encourage you to think carefully about the inputs
to your procedure, the purpose of your computation, and the type
of your output.

However, these first four P's give only an @emph{informal} definition of
what the procedure does.  But informal definitions are often vague.  What
happens if the reader does not understand all of the terms you've used
or associates a different meaning with those terms?  The Preconditions and
Postconditions help address the informality by employing a much more
@emph{formal} definition of what the procedure does, often describing
the output in terms of a formula or a piece of code.

@section[#:tag "documentation:example"]{An example}

Let us first consider a simple procedure that squares its input
value and that restricts that value to an integer. Here is one
possible set of documentation.

@codeblock|{
;;; Procedure:
;;;   square
;;; Parameters:
;;;   val, an integer
;;; Purpose:
;;;   Computes the square of val.
;;; Produces:
;;;;  result, an integer
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   (sqrt result) is val
}|

You’ll note that we did not say that @q{@verb{result is val*val}}
or @q{@verb{results is (* val val)}}. Why not? We generally try to
focus on important characteristics of the result, rather than the
process used to compute them.

What else might we think about? In Scheme, there’s not an upper
limit to the value of integers. In other languages, such a limit
may exist. Let’s suppose there is such a limit and it is called
@code{MAXINT}. In that case, trying to square a value larger than
the square root of @code{MAXINT} will necessarily lead to an error.
We might therefore add a precondition to the documentation as
follows.

@codeblock|{
;;; Procedure:
;;;   square
;;; Parameters:
;;;   val, an integer
;;; Purpose:
;;;   Computes the square of val.
;;; Produces:
;;;;  result, an integer
;;; Preconditions:
;;;   (abs val) <= (sqrt MAXINT)
;;; Postconditions:
;;;   (sqrt result) is val
}|

You will note that the preconditions specified are those described
in the narrative section: We must ensure that val is not too large.
Here, we started with the idea of numbers (or integers) and, as we
started to think about special cases, realized that the procedure
would not work with too large numbers. In reacting to the realization,
we added a restriction to the size.

In DrRacket, the integers can take on arbitrarily large values, so
there’s no reason to add that precondition. However, we do want to
think more carefully about types. If we limit ourselves to exact
integers, we know that our computated values are both arbitrarily
large and do not lose accuracy. Hence, we can write something like
the following.

@codeblock|{
;;; Procedure:
;;;   square
;;; Parameters:
;;;   val, an exact integer
;;; Purpose:
;;;   Computes the square of val.
;;; Produces:
;;;;  result, an exact integer
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   (sqrt result) = val
}|

But that choice seems, well, limiting.  We want to be able to square
inexact integers, real numbers (both exact and inexact), and perhaps
even complex numbers.  In case you've forgotten, inexact numbers
are not represented precisely.  That means that for example, the square
root of the square of an inexact number may not be the original number,
but instead an approximation thereof.  We need to accommodate that case.
Let’s write some more general documentation.

@codeblock|{
;;; Procedure:
;;;   square
;;; Parameters:
;;;   num, a number
;;; Purpose:
;;;   Compute the square of num
;;; Produces:
;;;   result, a number
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   If num is exact, (sqrt result) = num
;;;   If num is inexact, (sqrt result) approximates num
;;;   result has the same "type" as num
;;;     If num is an integer, result is an integer
;;;     If num is real, result is real
;;;     If num is exact, result is exact
;;;     If num is inexact, result is inexact
;;;     And so on and so forth
}|

In this documentation, you'll note that we spent extra effort to
discuss the type and accuracy of the result.  When possible, we try
to give client programmers as much useful information as we can.
Many programmers care to know whether a computation produces inexact
numbers (like @code{sqrt} often does) or always keeps the exactness
the same.

It takes time and practice to get postconditions right.  It also takes
some familiarity with the langauge we use to describe values in Racket
(e.g., @q{exact} vs @q{inexact}).  For the time being, you will not need
to write preconditions and postconditions.  However, when you see them
appear along with code, you should take a moment to read through them
to reflect upon the level of detail we are using and the ways in which
we describe postconditions formally.

@section:acknowledgements{}

This section draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/documentation"]{a reading entitled @q{Documenting your procedures}} from Grinnell College's CSC 151.  @hyperlink["http://www.cs.grinnell.edu/~rebelsky/Courses/CS151/2007F/Readings/documentation-reading.html"]{The original version of that reading} appeared in Fall 2007.

