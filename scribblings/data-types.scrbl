#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@prefix{data-types}
@title[#:tag (prefix)]{Data types}
@author{Samuel A. Rebelsky}

@summary{We further consider the role of @q{types} in Racket.}

@prereqs{@Secref{algorithms}, @secref{intro-racket}}

As you may recall from @seclink["algorithms"]{our short introduction
to algorithms}, at the heart of most algorithms are a set of basic
values provided by the language and operations you perform on those
values.  Computer scientists tend to refer to kinds of values as
@emph{types}.  What types are there? A lot Most programming languages
support one or more numeric types, such as integers or real numbers,
and some representation of text, which we tend to call “strings”.
Others may include more sophisticated types, such as images,
representations of user interface components (windows, buttons,
etc.), collections of values (such as a list of movie ratings), or even
@q{real world} objects, such as elevators.

Types serve a number of roles. Most importantly, they provide a way
to represent the kinds of data that we might want to use in our
algorithms.  Types also put limits on the uses of those kinds of
data. For example, while you can multiply two numbers together, you
would not normally multiply two pieces of text or two images together.
Similarly, while you might want to concatenate two pieces of text
in sequence (e.g., @q{Hello} and @q{World} to create @q{HelloWorld}),
you rarely want to concatenate two numbers together (e.g., 3.1415
and 42 to create 3.141542).

It is, of course, difficult to write algorithms and programs without
some basic types and even some more complicated types. Throughout
the semester, you will encounter a variety of types. Each time you
encounter a type, you should ask yourself the following questions
(or try to identify answers to those questions in the materials you
receive).

@emph{What is the type's @strong{name}}? That is, how do we refer
to the type. For example, most programming languages provide types
we call @q{integers}, @q{strings}, and @q{characters}. @emph{Integers} are
numbers that do not have a fractional component and which can be
positive, negative, or zero. @emph{Strings} are sequences of basic characters.
@emph{Characters} are the building blocks of strings.

@emph{What is the @strong{purpose} of the type?} That is, why do
we have the type in the language. We use integers to represent a
variety of numeric quantities. (In some languages, integers are the
only kind of number that are guaranteed to be precise.) We use
strings to represent text in natural language.  We use characters to
represent the components of that text.

@emph{How do you @strong{express} values of the type?} For example,
integers are usually written as sequences of digits, as in 4124. While you
may be used to including commas in larger numbers, such as 1,512,843
for @q{one million, five hundred twelve thousand, eight hundred and
forty three}, most programming languages will not allow you to
include those commas. In many languages, strings are represented
as letters you would type on the keyboard, surround by double
quotation marks (@verb{"}).

@emph{How does the computer @strong{display} values of the type?} In most
cases, the way you express values to the computer is the same as
the way it expresses them to you. But there are times that you will
find that the computer chooses a different representation. Here are
a few examples from DrRacket.

@;FIX ME - I should be able to use @examples
@codeblock|{
> 100000000000000000000.0
1e20
> 2/4
1/2
}|

@noindent{} In the first case, DrRacket uses exponential notation
(1 times 10 to the twentieth power) because it is shorter and,
arguably, clearer.  In the second, DrRacket simplifies the faction.


@emph{What @strong{operations} are available for values in the
type?} For example, you expect to be able to add, subtract, multiply,
and divide integers. You might expect to be able to concatenate
strings or to extract parts of strings. Learning what you can do
with different types is both challenging and empowering.

As we start the course, you will learn a variety of key types,
including a range of numeric types, characters and strings, images,
lists, and a strange type that Schemers refer to as @q{symbols}.

@section:self-checks{}

@self-check{Integer operations}

We've mentioned four operations that typically accompany integers:
addition, subtract, multiplication, and division.  List three others.

@self-check{Another type}

In our work in the digital humanities, we may sometimes deal with geographic
locations.  Suppose you were called upon to design that type.  How would
you answer each of those questions?

@section:acknowledgements{}

This section is taken nearly verbatim from
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/types"]{a
short reading on types} from Grinnell College's CSC 151.

