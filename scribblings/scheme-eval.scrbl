#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)
@(require scribble/example)
@(require scribble/core)
@(require scribble/html-properties)
@(require scribble/latex-properties)

@(define (renewenvironment name pre post)
    (make-multiarg-element (make-style "renewenvironment"
                                       `(exact-chars 
                                         ,(make-css-addition "fundhum.css")))
                           (list name pre post)))

@(renewenvironment "bigtabular"
                   "\\begin{center}\\vspace*{2ex}\\begin{tabular}"
                   "\\end{tabular}\\vspace*{2ex}\\end{center}")

@;{\newenvironment{bigtabular}{\vspace*{2ex}\begin{pltstabular}}{\end{pltstabular}\vspace*{2ex}}}

@title[#:tag "scheme-eval"]{Evaluating Scheme expressions}
@author{Samuel A. Rebelsky}
@prefix{scheme-eval}

@summary{We consider the algorithms and structures that Scheme and
Racket interpreters use as they evaluates Scheme expressions.}

@prereqs{@Secref{intro-racket} and @secref{procedures}}

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

@section[#:tag "scheme-eval:background"]{Background: Some kinds of
Racket expressions}

At this point, you've encountered five different kinds of expressions
in Racket.

@itemize{
@item{@emph{Simple values}: The basic building blocks of more complex
  expressions, values like 2.4 and "hello".}
@item{@emph{Procedure calls}: Expressions that involve applying 
  some procedure, such as @code{+}, to some values, such as
  @code{2.4} and @code{5}.  Procedure calls are surrounded by
  parentheses, which is how the Racket interpreter knows that they
  are procedure calls.}
@item{@emph{Simple definitions}: Definitions, which use the keyword
  @code{define}, associate an identifier, such as @code{homework1}, with
  a corresponding value, such as @code{90} or @code{"A-"}.}
@item{@emph{Procedure definitions}: As you've recently scene, one form
  of procedure definitions uses both the keyword @code{define} and the 
  keyword @code{lambda}.}
@item{@emph{Identifiers}: Identifiers
  are the words that we have given meaning to with @code{define}.
  Parameters are the words that represent inputs to a procedure.
  We usually consider parameters a form of identifier.}
@item{@emph{Lists}: You've generally seen lists as output, such as
  from the @code{string-split} operation.  Since you will not study
  lists in depth until later in the semester, this reading will provide
  only a bit about lists.}
}

As you might expect, the Racket interpreter uses a slightly different
process to evaluate each kind of expression.  We will consider each
in turn, exploring examples and related issues along the way.

@section[#:tag "scheme-eval:structures"]{Data structures used during evaluation}

You may recall that computer science is the study of algorithms
@emph{and} data structures.  That is, we describe not only processes,
but ways of organizing information.  The Racket interpreter uses a
variety of data structures.  

One important structure is a @emph{dictionary} it uses to look up
each identifier it encounters.  The interpreter must update the
dictionary when it encounters a definition or a procedure call.  We
will represent the dictionary as a table.  For example, we would
use something like the following table to represent the definition
@code{(define homework1 90)}.

@scheme-dict{
  @scheme-dict-entry["homework1" "90" "exact integer"]
}

Evaluation is traditionally at least a two-step process.  First,
the interpreter @q{parses} the textual input, turning it into an
internal representation of the input.  Next, the interpreter evaluates
that internal representation.  Let's consider a few expressions.

@itemize{

@item{
The parser inteprets the expression @q{@verb{2}} as the exact integer 
@emph{value} @code{2}.
}

@item{
The parser interprets the expression @q{@verb{x}} as the @emph{identifier}
@code{x}.  The parser does not check whether or not @code{x} has
been defined.
}

@item{
The parser interprets the expression 
@q{@verb{'x}} as the @emph{symbol} @code{x}.  Names and symbols look
quite similar.  However, Racket treats them differently.
}

@item{
The parser interprets the expression @q{@verb{(define x 5)}} as a
@emph{compound expression} with three elements.  Element 0 is the 
@emph{keyword}
@code{define}. Element 1 is the identifier @code{x}. Element 2 is the
exact integer value @code{5}.  (You'll note we number starting at zero.
For reasons you'll discover later in this semester, computer
scientists tend to count elements starting with the value zero
rather than the value one.)
}

@item{
The parser interprets the expression
@q{@verb{1/3}} as the exact rational @code{1/3}.
}

@item{
The parser interprets the expression
@q{@verb{"Hello"}} as the string value @code{"Hello"}.
}

@item{
The parser interprets the expression
@q{@verb{*}} as the identifier @code{*}.  You'll note that we've said that
@code{*} is a identifier, rather than either a keyword or the multiplication
procedure.  Racket has a somewhat limited set of keywords, and, as
you may have noted, expressions that involve keywords behave somewhat
differently.  You can't, for example, redefine a keyword.  You can,
however, redefine a identifier (including @code{*}).  Different parsers
may have different approaches to parsing keywords.  Some may identify
keywords early, as we have done.  Others may wait until evaluation
to determine whether a identifier is a keyword.
}

@item{
The parser interprets the expression
@q{@verb{(* 7 x 11)}} as a compound expression with four elements.
Element 0 is the identifier @code{*}.  Element 1 is the exact integer
value @code{7}.  Element 2 is the identifier @code{x}.  Element 3 is the exact
integer value @code{11}.
}

@item{
The parser interprets the expression
@q{@verb{'(8 "aitch" h)}} as a @emph{list} with three elements.
Element 0 is the exact integer value @code{8}.  Element 1 is the string
value @code{"aitch"}.  Element 2 is the symbol @code{h}.  That last 
part may be a bit surprising.  Why is it the symbol @code{h} rather
than the identifier @code{h}?  Because the outer tick mark signifies that
any words that follow represent symbols.
}

@item{
The parser interprets the expression
@q{@code{(* x (+ 8 1/2 x))}} as a compound expression with three elements.
Element 0 is the identifier @code{*}.  Element 1 is the identifier @code{x}.
Element 2 is another compound expression, one of four elements.
Element 0 is the identifier @code{+}.  Element 1 is the exact integer value
@code{8}.  Element 2 is the exact rational value @code{1/2}.  Element
3 is the identifier @code{x}.
}
}

You may note that there is some potential confusion in that last
compound expression, since we have two element 0's, two element
1's, and two element 2's.  Hence, we often display parsed expressions
using a format in which indentation helps indicate which expression
each value belongs to.  For example, we might represent 
@code{(define y (* 2 (+ x 1/2) x))} as follows.

@text-block|{
compound-expression/3:
  0: keyword:define
  1: id:y
  2: compound-expression/4:
      0: id:*
      1: value:2 (exact integer)
      2: compound-expression/3:
          0: id:+
          1: id:x
          2: value:1/2 (exact rational)
      3: id: x
}|

Most experienced Racket and Scheme programmers subconsciously
translate the code they type into this kind of representation.  That
is, they know what things they've entered are compound expressions,
keywords, identifiers, and values. They also often keep track of
the type of each value.

Note that Racket has its own internal representation of most of the
basic types of values.  Conceptually, every computer ends up
representing most values as a sequence of 0's and 1's and has a set
of rules for how those are interpreted.  You need not understand
that internal representation to know that @code{5} is the exact
integer 5, that @code{1.2} is the inexact real 1.2, or that @code{3/5}
is the exact rational number 3/5.

@section[#:tag "scheme-eval:parsing"]{Parsing expressions}

So, how does the parser translate the text of a Racket expression into
an internal structure?  The algorithm is, or should be, relatively
straightforward.

@text-block|{
To read the next expression
---------------------------

Skip over any whitespace (space, tab, newline, etc.) and comments.
Look at the next character.
  If the next character is an open parenthesis, we have a compound expression
    Skip over the open parenthesis
    Read each subexpression, one by one, until you reach the end
    Skip over the close parenthesis
    Combine the portions into a compound expression
  Otherwise, if the next character is a tick mark
    Look at the following character
    If it is an open parenthesis
      Follow the instructions for reading a compound expression,
      except that you treat all non-numeric words as symbols, 
      rather than identifiers or keywords.  Return that compound
      expression as a list value.
    Otherwise,
      Read the next word and treat it as a symbol
  Otherwise, if the next character is a double-quotation mark, "
    Read until you find the matching double-quotation mark
    Combine all the characters you've read into a string value.
  Otherwise (that is, for any other character)
    Read the next word
    If the word is one of the keywords (define, lambda, etc.)
      Convert the word to a keyword
    Otherwise, if the word has the form of an exact integer 
      Convert the word to an exact integer, using the appropriate
      internal representation for integers
    Otherwise, if the word has the form of a rational number 
      Convert the word to a rational number
    Otherwise, if the word has the form of an inexact real number 
      Convert the word to an inexact number
    Otherwise
      Convert the word to an identifier
}|

Of course, some aspects of these instructions are a bit vague.  What
is @q{the form of an exact integer} or @q{the form of a rational
number}?  Here are some approximate definitions.

@itemize{
@item{An @emph{exact integer} is a sequence of digits with an optional
  leading @code{+} or @code{-}.  So @code{11} is an exact integer,
  as are @code{-11} and @code{+11}.  However, @code{++11} is not an
  exact integer because it has more than one leading @code{+},
  @code{11.0} is not an exact integer because it has a decimal point,
  @code{11x} is not an exact integer because it has a non-digit
  character, and so on and so forth.  What is @code{11x}?  It's
  not an exact rational, an inexact real, or a complex number, so it
  must be an identifier.}
@item{An @emph{exact rational} is a sequence of digits with an optional
  leading @code{+} or @code{-}, a slash, and another sequence of digits.
  Hence, @code{7/11}, @code{+7/11}, and @code{-7/11} are all exact
  rational numbers.  However, @code{7.0/11} is not because it contains
  a decimal point and @code{7/+11} is not because because it contains a
  @code{+} in a position other than the front.  What are these two
  words?  They are both identifiers.}
@item{An @emph{inexact real number} is a sequence of digits with 
  an optional leading @code{+} or @code{-} as well as a decimal
  point or an exponential portion or both.  An exponential portion
  is the letter e, an optional @code{+} or @code{-}, and a sequence
  of digits.  For example, @code{11.7}, @code{+11.7} @code{-11.7},
  @code{11e7}, @code{11e-7} and @code{-11e+7} are all inexact
  numbers.  @code{11.} is also an inexact number.  For the time being,
  we will not distinguish inexact real numbers from inexact integers.}
@item{A @emph{complex number} is a number (one of the three kinds
  we've just listed), a @code{+} or @code{-}, an unsigned number,
  and the letter @code{i}.  If both numbers are exact, the complex
  number is also exact.  If either number is inexact, the complex
  number is inexact.  @code{7+11i} is an exact complex number, as are
  @code{-7+11i}, @code{-7-11i}, and @code{7-11i}.  However,
  @code{7+-11} is not a complex number.}
}

But what about the @q{word} that we are supposed to read.  Racket
and Scheme are fairly generous about the words and identifiers they
permit.  In most situations, a word is a sequence of standard
characters that does not include whitespace, parentheses, square
brackets, curly braces, a tick mark, a backtick, a semicolon, an
octothorpe (hash, pound sign), or a double quotation mark.  So, as
strange as it may seem, @code{3+-4} is a valid identifier, as are
@code{x/3}, @code{x++}, @code{+---+}, and many other things it would
be hard to conceive of.

@fundhum-examples[
(define 3++ 11)
3++
(define 3/-4 -2)
3/-4
(define +----+ *)
(+----+ 3++ 3/-4)
]

Note that just because things are possible does not mean that they are
a good idea.  Defining @code{3/-4} as @code{2} is likely to confuse
the reader.  Racket gives you great power.  Use it wisely.

Let's consider a simple parsing example.  The vertical bar, @verb{|} shows
where we are in the input.

@(tabular #:style 'boxed
          #:sep (hspace 3)
          #:row-properties '(bottom-border '())
          (list (list @bold{remaining input} @bold{action} @bold{notes})
                (list @verb{|(define x (+ 3 y))} "Skip whitespace" "None")
                (list @verb{|(define x (+ 3 y))} "Look at next char" "next:@verb{(}")
                (list @verb{|(define x (+ 3 y))} "If open paren" "Yes")
                (list @verb{(|define x (+ 3 y))} "Read subexp" "In compound")
                (list @verb{(|define x (+ 3 y))} "Skip whitespace" "None; In compound")
                (list @verb{(|define x (+ 3 y))} "Look at next char" "next:@verb{d}; In compound")
                (list @verb{(|define x (+ 3 y))} "If open paren" "No; In compound")
                (list @verb{(|define x (+ 3 y))} "If tick mark" "No; In compound")
                (list @verb{(|define x (+ 3 y))} "If double quote" "No; In compound")
                (list @verb{(|define x (+ 3 y))} "Otherwise ..." "In compound")
                (list @verb{(|define x (+ 3 y))} "Read the next word" "In compound")
                (list @verb{(define| x (+ 3 y))} "" @elem{word:@verb{define}; In compound"})
                (list @verb{(define| x (+ 3 y))} "If keyword" @elem{Yes; word:@verb{define}; In compound"})
                (list @verb{(define| x (+ 3 y))} "Convert to keyword" @elem{In compound [0:@verb{keyword:define}]"})
                (list @verb{(define| x (+ 3 y))} "Read subexp" @elem{In compound [0:@verb{keyword:define}]"})
                (list @verb{(define| x (+ 3 y))} "Skip whitespace" @elem{Yes; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define |x (+ 3 y))} "Look at next char" @elem{char:@verb{x}; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define |x (+ 3 y))} "If open paren" @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define |x (+ 3 y))} "If tick mark" @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define |x (+ 3 y))} "If double quote" @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define |x (+ 3 y))} "Otherwise ..." @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define |x (+ 3 y))} "Read the next word" @elem{In compound [0:@verb{keyword:define}]"})
                (list @verb{(define x| (+ 3 y))} "" @elem{word:@verb{x}; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define x| (+ 3 y))} "If keyword" @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define x| (+ 3 y))} "If exact int" @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define x| (+ 3 y))} "If rational" @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define x| (+ 3 y))} "If inexact" @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define x| (+ 3 y))} "If complex" @elem{No; In compound [0:@verb{keyword:define}]"})
                (list @verb{(define x| (+ 3 y))} "Otherwise ..." @elem{In compound [0:@verb{keyword:define}]"})
                (list @verb{(define x| (+ 3 y))} "Convert to id" @elem{In compound [0:@code{k:d},1:@verb{id:x}]"})
                (list @verb{(define x| (+ 3 y))} "Read subexp" @elem{In compound [0:@code{k:d},1:@verb{id:x}]"})
                (list @verb{(define x (+ 3 y)|)} @emph{magic} @elem{In compound [0:@code{k:d},1:@verb{id:x},2:@verb{compound[...]}]})
                (list @verb{(define x (+ 3 y)|)} "Until you reach the end" @elem{Yes; In compound [0:@code{k:d},1:@verb{id:x},2:@verb{compound[...]}]})
                (list @verb{(define x (+ 3 y)|)} "Skip over" @elem{In compound [0:@code{k:d},1:@verb{id:x},2:@verb{compound[...]}]})
                (list @verb{(define x (+ 3 y))|} "Skip over" @elem{In compound [0:@code{k:d},1:@verb{id:x},2:@verb{compound[...]}]})
                (list @verb{(define x (+ 3 y))|} "Combine the portions" @elem{In compound [0:@code{k:d},1:@verb{id:x},2:@verb{compound[...]}]})
           ))

After all those steps, including the elided parsing of @verb{(+ 3 y)}, we
end up with the following.

@text-block|{
compound-expression/3
  0: keyword:define
  1: id:x
  2: compound-expression/3
      0: id:+
      1: value:3 (exact integer)
      2: id:y
}|

@emph{Note}: This parsing algorithm may seem a bit complex.  However,
the real parsing algorithm is even more complex.  For example, the
parameter list and body in a @code{lambda} expression are parsed in
a different way than other parenthesized expressions.  We'll leave those
complexities as an issue for future consideration.

@section[#:tag "scheme-eval:basics"]{Evaluating expressions}

Now that we've parsed the expression (or, more accurately, now that
the interpreter has parsed the expression), it's time to evaluate
the expression.  As you may recall, in @secref["scheme-eval:background"],
we considered six different kinds of expressions: simple values,
procedure calls, simple definitions, procedure definitions with
@code{lambda}, identifiers, and lists.  Now that we know how the
interpreter parses each expression into an internal representation,
we can consider how to evaluate the different kinds of expressions.

Note that we've only used three structures to represent expressions:
compound expressions, identifiers, and values.  Procedure calls,
simple definitions, and procedure definitions all get represented
as compound expressions.  Simple values and lists both get represented
as values.  However, we can distinguish definitions from calls by
checking whether element 0 is the keyword @code{define} or not.  And
we can distinguish simple values and lists by checking their type.
(However, we need not do so at the moment.)

Let's consider how to evaluate each kind of structure.

@itemize{
@item{To evaluate an @emph{identifier}, look the identifier up in
  the dictionary.  For example, if our identifier is @code{x} and
  the dictionary associates the exact integer @code{11} with @code{x},
  we return the exact integer @code{11}.  If the dictionary does
  not associate any value with @code{x}, issue an error.}
@item{To evaluate a @emph{value}, use the value the parser constructed.
  For example, if the original text contained @verb{7/11}, the
  parser identified and stored that as the exact rational number
  @code{7/11}, so we return that.}
@item{To evaluate a @emph{compound expression that starts with
  @code{define}}, evaluate element 2 of the compound expression and
  then put the combination of element 1 and that result into the
  dictionary.  For example, given the structure that corresponds
  to @verb{(define x 11)}, we would update the dictionary to associate
  @code{x} with the exact integer @code{11}.}
@item{To evaluate a @emph{compound expression that represents a
  procedure call}, evaluate all the elements of the expression and
  then apply the procedure.  For example, to evaluate the structure
  corresponding to @verb{(+ 1 2)}, the interpreter first evaluates
  the @code{+}, the @code{1}, and the @code{2}.  It can evaluate
  them in any order; on some machines, it may even evaluates them
  simultaneously.  The @code{+} is an identifier, so it looks it
  up in the dictionary and discovers that it's the built-in
  mulitplication operation.  The @code{1} is an exact integer.  The
  @code{2} is also an exact integer.  So the interpreter passes
  @code{1} and @code{2} to the built-in multiplication operation.}
}

Are those all the kinds of expressions?  Not quite.  We haven't
really explained how to evaluate a @code{lambda} expression.  That's
a complex enough issue that we'll leave it for a bit later.

@section[#:tag "scheme-eval:example01"]{An example}

Let's consider what the interpreter might do upon encountering the
following series of expressions.  (More precisely, we will
consider what the interpreter will do given the parsed versions 
of those expressions.)

@codeblock|{
(define multiply *)
(define divide /)
(define diameter 17)
(define radius (divide diameter 2))
(multiply pi (expt radius 2))
}|

What does the dictionary look like before we've run any code?  The
basic dictionary associates most of the built-in identifiers with
their associated values.  For example, it associates @code{*} with
the built-in multiplication procedure and @code{pi} with a reasonable
approximation thereof.

@fundhum-examples[
*
pi
]

We begin with @code{(define multiply *)}, which the parser has likely
represented as follows.

@text-block|{
compound-expession/3:
  0: keyword:define
  1: id:multiply
  2: id:*
}|

That's a definition, which we can tell because it's a
compound expression whose element 0 is the keyword @code{define}.
So we evaluate element 2, the identifier @code{*}.  We evaluate
identifiers by looking them up in the table.  The basic dictionary
maps @code{*} to the built-in multiplication operation that
it shows to us as @verb{#<procedure:*>}.  Next, we update the
dictionary to associate that value with @code{multiply}.

@scheme-dict{
  @scheme-dict-entry["multiply" "#<procedure:*>" "procedure"]
}

Note that there is a difference between the identifier @code{*} and
the procedure value represented by @verb{#<procedure:*>}.  The first
is just an identifier.  The latter is a procedure provided to us
by the Scheme or Racket interpreter.  For convenience, we can refer
to it as @code{*}.  However, it is possible to change meanings, as
the following example suggests.

@examples2[(make-base-eval)
*
(define * -)
*
(* 2 7)
]

Of course, no one in their right mind would use such a definition,
except to frustrate others.  We include it only to remind you of
the difference between the identifier and the underlying procedure.

Returning to our sequence of expressions, our next expression to
evaluate is @code{(define divide /)}.  That's similar enough to the
first definition that we won't go through the details.  Our dictionary
now contains the following.

@scheme-dict[
  @scheme-dict-entry["multiply" "#<procedure:*>" "procedure"]
  @scheme-dict-entry["divide" "#<procedure:/>" "procedure"]
]

The next expression, @code{(define diameter 17)} is similar.  However,
in this case, @code{17} is a value rather than a name, so the
interpreter need not look it up in the dictionary before associating
it with @code{diameter}.

@scheme-dict[
  @scheme-dict-entry["multiply" "#<procedure:*>" "procedure"]
  @scheme-dict-entry["divide" "#<procedure:/>" "procedure"]
  @scheme-dict-entry["diameter" "17" "exact integer"]
]

@section[#:tag "scheme-eval:lambda-expressions"]{Evaluating and applying lambda expressions}

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

