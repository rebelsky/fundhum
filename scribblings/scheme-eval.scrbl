#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@title[#:tag "scheme-eval"]{Evaluating Scheme expressions}
@author{Samuel A. Rebelsky}
@prefix{scheme-eval}

@summary{We consider the algorithms and structures that Scheme and
Racket interpreters use as they evaluates Scheme expressions.}

@prereqs{@Secref{intro-racket} and @Secref{procedures}}

@section[#:tag "scheme-eval:introduction"]{Introduction}

We use the terms @q{interpreter} and @q{evaluator} for the programs
that read and execute Scheme and Racket programs.  To many Scheme
and Racket programmers, the interpreter is a bit of a @q{black box}.
That is, you type an expression, the interpreter chugs along for a
few milliseconds (or, in some cases, much longer), and then produces
an answer.  

It is certainly possible to use Racket without knowing anything
about how DrRacket and other interpreters evaluate expressions.
However, knowing a bit about the interpreter helps you understand
why DrRacket does what it does.  And, when things go wrong, knowing
a bit about the interpreter can help you resolve problems.

It is neither possible nor appropriate to cover every aspect of the
Racket interpreter this early in your study of DrRacket.  You 
don't know all of the Racket language and you don't know all of the
computational and algorithmic techniques that are central to the
interpreter.  Nonetheless, you know enough to get a simplified,
high-level overview of the interpreter.  And, as we suggested,
having that overview will prove of benefit.

@section[#:tag "scheme-eval:background"]{Background: Different kinds of
Racket expressions}

@section[#:tag "scheme-eval:structures"]{Data structures used in the evaluation process}

@section[#:tag "scheme-eval:basics"]{Evaluating basic expressions}

@section[#:tag "scheme-eval:example01"]{Some examples}

@section[#:tag "scheme-eval:algorithm01"]{A preliminary algorithm}

@section[#:tag "scheme-eval:named-procedures"]{A slight complexity: Naming existing procedures}

@section[#:tag "scheme-eval:procedure-definitions"]{Interpreting procedure definitions}

@section[#:tag "scheme-eval:lambda-expressions"]{Applying lambda expressions}

@section[#:tag "scheme-eval:algorithm02"]{A revised algorithm}

@section[#:tag "scheme-eval:example02"]{Another example}

@section[#:tag "scheme-eval:scoping"]{Disclaimer: Interpreting variables}

In the discussion of applying lambda expressions to values, we
suggested that the Scheme interpreter updates the dictionary and
then evaluates the body of the expression. In point of fact, the
actual semantics of variables are a bit more complicated and, in
some cases, depend on where they appear in the program code rather
than where they are used in a running program.  Hence, the claim
that the interpreter simply updates the dictionary is a simplification,
albeit a useful one. For most of the code you write in this class
(and elsewhere), the simplification is acceptable.  However, there
are some cases in which the simplification breaks down. We’ll mention
them when they occur.

For those who like esoteric terminology, the model we’ve given you
is @emph{dynamically scoped}, with the meaning of each variable
determined by its context at the time the program is evaluated.
However, the Scheme language is actually @emph{statically scoped},
with the meaning of each variable determined. For those of you who
don’t like esoteric terminology, ignore the preceding two sentences.
(We thought about telling you to ignore the whole paragraph, but
that means you would have to ignore the instruction telling you to
ignore the paragraph, which could lead to some confusion.)

@section:self-checks{}

@self-check{Handling expressions}

@self-check{Running the evaluation algorithm}

What are the roughly eight steps that the Scheme evaluator will do as it
evaluates the following expression.

@codeblock|{
(define exp (/ (+ 7 8 9) count))
}|

@self-check{TBD}

@section:acknowledgements{}

This section draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/scheme-eval-1"]{How
Scheme evaluates expressions (take 1)} and
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/scheme-eval-2"]{How
Scheme evaluates expressions (take 2)} from Grinnell College's CSC
151.  Samuel A. Rebelsky wrote the original version.
A variety of other folks (particularly Janet Davis and Jerod Weinman)
made substantial updates.

