#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@title[#:tag "drracket"]{The DrRacket programming environment}
@author{Samuel A. Rebelsky}
@prefix{drracket}

@summary{We introduce program development environments and
examine DrRacket, the program-development environment we will for
most of this semester.}

@prereqs{This section has no prerequisites.  However, you will find
there is a bit of a @q{chicken and egg problem} for this reading and
the @seclink["intro-racket-reading"]{reading that introduces the
Racket programming language}.  That is, it is difficult to introduce
DrRacket, the environment in which you will develop program, without
first introducing Racket, the language in which you will express
those programs.  At the same time, it is difficult to experiment
with the language without first understanding the environment.  In
this section, we will emphasize the environment, but also introduce
a bit about the language.  In the paired reading, we'll cover more
about the language, but may also discuss a bit about the environment.
The @seclink["intro-racket-lab"]{corresponding lab} should teach you
a bit about both.}

@section[#:tag "drracket:introduction"]{Introduction: Program-development environments}

As we've noted previously, while the core of computer science is the
design of algorithms and data structures, one needs to express those
algorithms in a form understandable to the computer (and, one hopes,
to human beings).  We call this endeavor @emph{programming}.  We refer
to the algorithms so expressed as both @emph{programs} and @emph{code}.

While it is possible to create programs in almost any text editor,
more programmers develop their program in what is normally called
a program-development environment or integrated development environment
(IDE).  These environments not only permit you to write programs,
but also provide mechanisms for testing small parts of the programs,
formatting the code for easy readability, obtaining documentation,
and more.  In general, development environments support the other
activities associated with program development.

In FunDHum, you will use the @emph{DrRacket} program-development
environment.  DrRacket was designed to support the teaching of
programming, which means that it has many features that make it
particularly amenable to novice programmers.

@section[#:tag "drracket:obtaining"]{Obtaining DrRacket}

If you are working on a Linux workstation, it is likely that DrRacket
is already installed.  Ideally, your account will be configured so
that DrRacket appears in the task bar as a blue and red symbol with
a white lambda.  If you don't see such an icon, find a teacher or
class mentor.  Once you have the icon, you need only click on it
to start DrRacket.

If you are working on a computer that runs macOS or Microsoft Windows,
you will probably need to download your copy of DrRacket from
@url{https://racket-lang.org/download/}.  Follow the standard approach
to downloading and installing software.  Once again, if you encounter
difficulty, ask your teacher or class mentor.

@section[#:tag "drracket:ui"]{An overview of the DrRacket user interface}

When you start DrRacket, you will find that DrRacket is similar to
most applications.  For example, it has a @menu{File} menu that lets
you open and save files and an @menu{Edit} menu that permits you to
cut, copy, and past text.  Like many applications, DrRacket usually
starts with a window for a new, untitled, document.  Here's what 
DrRacket's primary window looks like.

@image["images/drracket.png"]{A screenshot of the DrRacket program immediately after opening, showing no commands executed and a "#lang racket" directive in the definitions pane.}

You may note that this window has two parts, which we'll call @q{panes}.
The top pane is called the @emph{Definitions Pane} or @emph{Definitions
Window} and the bottom pane is called the @emph{Interactions Pane} or
@emph{Interactions Window}.  As the names suggest, the top pane is
used for writing @q{definitions} of procedures and values and the
bottom pane lets you interact with Racket.

After a few brief detours, we will explore the interactions pane.

@section[#:tag "drracket:configuring"]{Configuring DrRacket}

DrRacket supports a variety of programming language.  We will configure
DrRacket so that it's easy for us to tell it which language to use.  
In the @menu{Language} menu, select @menu-item{Choose Language ...}.  
In the dialog box that appears, click on the radio button next to
@menu-item{The Racket Language}.  Then click @button{OK}.  Finally,
click @button{Run}.

The other important configuration step is to configure your copy of
DrRacket to use the FunDHum libraries.  From the @menu{File} menu,
select @menu-item{Install Package ...}.  In the window that appears,
enter @url{https://github.com/grinnell-cs/loudhum.git}.  Click
@button{Install}.  Eventually, a @button{Close} button should appear.
Click that button.  It will be your only notification that the
installation succeeded.

After setting the language and installing the FunDHum library, you should
be nearly ready to go.

@section[#:tag "drracket:intro-racket"]{Getting started with Racket}

Racket has a fairly simple syntax, but one that is different than most
other programming languages.  Parentheses play an important role in
DrRacket.  To tell DrRacket to apply a procedure to some arguments,
you write an open (left) parenthesis, the name of the procedure, the
arguments separated by spaces, and a close (right) parenthesis.  For
example, here's how you would add 1, 2, and 3.

@fundhum-examples[(+ 1 2 3)]

The angle bracket (greater-than sign) is the DrRacket @q{prompt}, the
way it tells you that it wants you to enter an expression.  You 
type your expression on the line and then ask DrRacket to evaluate
it.

@;{Racket provides a variety of built-in procedures for working with
numbers.  Here are examples of a few.  You should be able to figure
out what they do from the result.

@fundhum-examples[
]
}

@section[#:tag "drracket:interactions"]{The interactions pane}

As we noted, the Interactions pane is where you most frequently
interact with DrRacket, entering Scheme expressions and seeing their
values.  The DrRacket prompt tells you that DrRacket is ready for
the next expression.  Once you've entered that expression, you type
the @keycap{Enter} or @keycap{Return} key.  (If the cursor is in
the middle of the expression, DrRacket interprets that as @q{move
to a new line}; to get it to evaluate the expression, you must use
@keycap{Ctrl}-@keycap{Enter}.)  Here are a few examples, including
a few that show off a variety of Scheme numeric operations.  You may
be able to figure out the meaning from context.

@fundhum-examples[
(+ 1 2 3)
(sqrt 144)
(floor 3.5)
(ceiling 3.5)
(expt 2 3)
(expt 3 2)
(string-length "All mimsy were the borogoves")
(string-split "All mimsy were the borogoves" " ")
]

This style of interaction may feel a bit like a calculator with a
strange user interface and a log of what you've done.  And, in some
sense, that's one purpose of DrRacket's interactions pane.  However,
DrRacket also provides a variety of features that may not be easily
available in most calculators, such as support for values other than
numbers (e.g., the strings above), the ability to name values, and
the capability for you to write your own operations (aka procedures).

Here's a quick example of naming in Racket, which we do with the
@code{define} keyword.

@fundhum-examples[
(define add +)
(add 1 2 3)
(define three 3)
(sqrt three)
(add three three)
]

When you want to edit a previous expression, you can use
@keycap{Ctrl}-@keycap{Up Arrow} or @keycap{Esc}-@keycap{p} to scroll
upward through a history of expressions and you can use
@keycap{Ctrl}-@keycap{Down Arrow} or @keycap{Esc}-@keycap{n} to
scroll downward.

Note: Mac users should use the @keycap{Command} or @keycap{Cloverleaf}
key rather than the @keycap{Ctrl} key.

@section[#:tag "drracket:definitions"]{The definitions pane}

The interactions pane is intended to be ephemeral.  You do a series of
computations (or, more precisely, ask DrRacket to do a series of computations),
You examine the results.  But you should not plan for them to exist
indefinitely.  You can save them to a file, but most people do not.
You can always clear the interactions pane by clicking the @button{Run}
button or hitting @keycap{Ctrl}-@keycap{r}.

While the interactions pane is ephemeral, there are often parts of your
program or your configuration that you want to save.  Those parts belong
in the definitions pane, at the top of the screen.  You will almost
always begin that pane with the line

@codeblock{#lang racket}

After that, you will typically enter a series of definitions (hence the
name) using the @code{define} keyword.  In the near future, we will
see how to use @code{define} to name functions.  For the time being,
we will define things to add clarity; a name may tell you what something
does without you having to understand exactly how it works.

Consider the following definitions, not all of which will make sense.

@codeblock{
(define sample-text "All mimsy were the borogoves")
(define word-containing-e #px"[a-z]*e[a-z]*")
(define word-containing-s #px"[a-z]*s[a-z]*")
(define trial01 11.2)
(define trial02 13.5)
(define trial03 8.5)
(define trial04 10.6)
}

Let's see how we can use those in the interactions pane once we've
clicked the @button{Run} button.

@fundhum-examples[#:hidden
(define trial01 11.2)
(define trial02 12.5)
(define trial03 8.5)
(define trial04 10.8)
(define sample-text "All mimsy were the borogoves")
(define word-containing-e #px"[a-z]*e[a-z]*")
(define word-containing-s #px"[a-z]*s[a-z]*")
]

@fundhum-examples[
(* 1/4 (+ trial01 trial02 trial03 trial04))
(* 1/3 (- (+ trial01 trial02 trial03 trial04) 
          (min trial01 trial02 trial03 trial04)))
sample-text
(string-length sample-text)
(regexp-match* word-containing-e sample-text)
(regexp-match* word-containing-s sample-text)
]

Even if we have no idea what @code{#px"[a-z]*e[a-z]*"} represents,
we can probably interpret @code{word-containing-e}, particularly 
from the context it is used.

@section[#:tag "drracket-save"]{Saving and restoring definitions}

We noted that the definitions pane is intended for the work that you 
intend to be permanent, or at least less ephemeral than the work you
do in the interactions pane.  Hence, we will regularly save the contents
of the definitions pane to a file.  We can then restore those definitions
at a later time.

By custom, we save Racket files with a suffix of @verb{.rkt}.  If you do
not provide a suffix, or choose a bad suffix such as @verb{.jpg}, DrRacket
is happy to allow you to violate conventions.  But you will then find it
much harder to work with the file in a future.

Once you now that your definitions are safely stored in a file, you can
quit DrRacket, go off and do other work, and then restart DrRacket to
reload the definitions.  As you might expect, you can load old definitions
by using @menu-item{Open...} or @menu-item{Open Recent} from the
@menu{File} menu.

@section:self-checks{}

You have now learned enough to interact with DrRacket.  In the
@seclink["intro-racket-lab"]{forthcoming lab}, you will have the
opportunity to ground those abstract instructions in concrete
exercises.  Before you do so, you will find it useful to take a
few quick notes on some issues.

@self-check{What is DrRacket?}

In your own words, explain what DrRacket is and why we use it in this course.

@self-check{File suffixes}

What suffix should you use for your Racket files?

@section:acknowledgements{}

This section is based closely on 
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/drracket"]{a
reading entitled @q{The DrRacket Programming Environment}} from
Grinnell College's CSC 151.

