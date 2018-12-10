#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@prefix{hash-tables}
@title[#:tag (prefix)]{Dictionaries, Maps, and Hash Tables}
@author{Samuel A. Rebelsky}

@summary{We consider the @emph{dictionary} data type, which provides a way to associate information with words.  We then explore Racket's @emph{hash tables}, which provide one implementation of dictionaries.}

@prereqs{(to be determined)}

@section[#:tag "hash-tables:introduction"]{Introduction}

As you've seen, we often find it useful to collect data into
structures.  We've collected values in @emph{lists}, which are
useful for processing sequentially, and @emph{XML trees}, which are
useful for processing hierarchically.  Since different structures
might support different kinds of operations, the design of structured
types like lists and trees is a core part of algorithm design.
Computer scientists have defined a wide range of data types designed
to collect data.

Consider, for example, the problem of representing a simple phone
book.  A phone book associates phone numbers with names.  When you
look up a name in a phone book, you should either get the corresponding
phone number or a warning that no phone number is available for
that name.  There are many other instances in which you want to
associate information with a @q{name} or something equivalent.  For
example, a physical dictionary associates definitions with words
and each XML entity has a collection of attribute values that are
associated with attribute names.

In referring to these kinds of structures, computer scientists often
call the thing used to look up information the @emph{key} and the
associated information the @emph{value}.  In a phone book, the name
is the key and the phone number is a value.  In a traditional
dictionary, the word is the key and the definition is the value.
In an attribute list, the attribute name is the key and the attribute
value is the value.

Computer scientists use a variety of names for structures that
associate keys and values, including @emph{Dictionary}, @emph{Map},
@emph{Keyed Table}, and even @emph{Hash}.  Generally, you can think
of these structures as collections of key/value pairs that make it
easy to reference values by key.  What operations would you expect
such structures to provide?  It should be easy to @emph{create} a new
structure, to @emph{add} or @emph{update} a key/value pair, and to
@emph{look up} a value by key.   It might also be useful to 
@emph{remove} a key/value pair and to @emph{check} whether a key is
in the structure.

Over the years, computer scientists have come up with a large number
of ways to represent dictionaries, including association lists,
binary search trees, skip lists, and hash tables.  Don't worry; you
don't need to know the underlying details of any of them, at least not 
at this stage of your career.  You do, however, need to understand
how and why to use such structures.

For now, we will focus on how you use one of the most common
implementations of dictionaries, known as @emph{Hash Tables}.  In
many situations, hash tables are one of the most efficient
implementations of dictionaries.  Most modern languages include
hash tables as a basic type.  And, because hash tables are so
popular, many programmers don't distinguish hash tables from the
broader concept of dictionaries.  (That's why some people refer to the
general concept as a @q{hash}.)  But you should remember that hash
tables are just one way to implement dictionaries.

@section[#:tag "hash-tables:basics"]{Getting started with hash tables}

We're exploring a new type.  At this point, the five questions you ask about
a new type should be second nature: What is its @emph{name}?  What is
its @emph{purpose}?  How do I @emph{express} values in the type?  How
does DrRacket @emph{display} values in the type?  What @emph{procedures}
are available for working with the type?

We've already answered the first two questions: The type is named
@q{hash table} and its purpose is to store key/value pairs.  We
rarely write hash tables directly and we rarely ask DrRacket to
display them (after all, they are often fairly large), so we'll leave 
those questions to after our coverage of the procedures associated
with hash tables.

You may recall that we said that there are three basic operations
we use with hash tables: we create them, we add key/value pairs, and
we look up values by keys.

You create a new hash table with @code{(make-hash)}.  You look up
a value in a hash table with @code{(hash-ref table key)}.  You add
a key/value pair to the table with @code{(hash-set! table key value)}.
Note that @code{hash-set!} ends with an exclamation point.  That reminds
us that the procedure actually modifies the underlying hash table.

Let's explore those basic operations, creating a map of book titles
to authors.  For now, we'll assume that each book has a single author;
in a subsequent section, we'll consider how to deal with multiple
authors.

@fundhum-examples[
(define authors (make-hash))
(hash-set! authors "The Princess Bride" "William Goldman")
(hash-set! authors "Homegoing" "Yaa Gasi")
(hash-set! authors "Moo" "Jane Smiley")
(hash-set! authors "Moo, Baa, La La La!" "Sanda Boynton")
(hash-ref authors "Homegoing")
(hash-ref authors "Moo")
]

What happens when the book title is not in the table?  Let's check.

@fundhum-examples[
(eval:error (hash-ref authors "FunDHum"))
]

It appears that the hash table issues an error.  That seems like a reasonable
choice.  Racket needs to signal to the user that the value is not available.
But an error message is not something many of us want to have happen in the
middle of our program.  Hence, the Racket hash library also provides a
@code{(hash-has-key? table key)} procedure that checks whether the hash
table contains a particular key.

@fundhum-examples[
(hash-has-key? authors "Homegoing")
(hash-has-key? authors "FunDHum")
]

At times, you may realize that you want to update a key/value pair that
you have stored in the hash table.  You can use the @code{hash-set!}
operation to update the table.

@fundhum-examples[
(hash-ref authors "The Princess Bride")
(hash-set! authors "The Princess Bride" "S. Morgenstern")
(hash-ref authors "The Princess Bride")
]

You've learned four basic hash table operations: @code{make-hash},
@code{hash-set!}, @code{hash-ref}, and @code{hash-has-key?}.  While
the Racket hash table implementation provides a host of other
operations, those four basic operations should be all that you need
at this point.  In the next few sections, we'll explore some other
design issues in making and using hash tables.

@section[#:tag "hash-tables:display"]{Displaying hash tables}

As hash tables exist primarily for you to use to extract information,
You will rarely ask DrRacket to display hash tables.  Also, hash
tables are generally large enough that you won't want to see all of
the information on your screen.  But DrRacket will display a hash
table if you ask it nicely.

@fundhum-examples[
authors
]

Not very pretty, is it?  But, if we look carefully, it's fairly
straightforward.  It begins with a tick, an octothorpe, and the word
@code{hash}.  Following that is a list of key/value pairs.  And they
are @emph{literally} pairs, as indicated by the dot between the two
values.  

Can we create a hash in the same way?  Let's try.

@fundhum-examples[
(define animals '#hash(("A" . "Aaardvark")
                       ("B" . "Badger")
		       ("C" . "Chinchilla")
		       ("D" . "Dingo")
		       ("E" . "Emu")
		       ("F" . "Fennec Fox")))
animals
(hash-ref animals "B")
(hash-has-key? animals "Z")
]

It looks like this does give us a hash table, but with the key/value
pairs in a slightly different order than we started with.  That's
okay: We should not care about the ordering because our focus is
on using hash tables rather than understanding the underlying
technology.  (It turns out that the ordering is one of the things
that helps keep hash tables efficient.  You'll study how to construct
hash tables in a subsequent course.)  Let's add something to the
hash table.

@fundhum-examples[
(eval:error (hash-set! animals "Z" "Zebra"))
]

Hmmm.  That didn't work.  Why not?  When we present a hash table to
Racket using the @verb{'#hash} notation, it treats is as an
@emph{immutable} table.  You can use it, but you cannot modify it.
That makes sense for some cases.  For example, you might have assumptions
about the contents of the hash table and you would not want another part 
of the program (perhaps written by another programmer who did not
understand those expectations) to @q{mess with} the table.

But what if you want to create a hash table with a sequence of key/value
pairs @emph{and} you want it to be mutable?  In that case, you can use
a variant of the @code{make-hash} operation in which you present it with
a list of key/value pairs.

@fundhum-examples[
(define animals
  (make-hash (list (cons "A" "Anteater")
                   (cons "B" "Baboon")
		   (cons "C" "Civet")
		   (cons "D" "Dormouse")
		   (cons "E" "Echidna")
		   (cons "F" "Flamingo"))))
animals
(hash-ref animals "B")
(hash-has-key? animals "Z")
(hash-set! animals "Z" "Zebra")
animals
(hash-ref animals "Z")
]


@section[#:tag "hash-tables:connect"]{Connecting keys}

What happens if we try to use something that's close to an existing
key, but not quite the same?  Let's try and find out.

@fundhum-examples[
(hash-has-key? authors "Homegoing")
(hash-has-key? authors "Home going")
(hash-has-key? authors "homegoing")
]

As these two examples suggest, hash tables are not particularly
smart.  They expect @emph{exact} matches of the hash key.  Programmers
who want more accommodating hash tables may want to write procedures
that convert keys to a common form before hashing.  Let's consider 
how we might do that with strings.

First, let's agree on a common form.  Say, for example, that we decide
that the common form should be all lowercase and should contain only
letters and digits.  We can use @code{string-downcase} to convert the
string to lowercase and @code{regexp-replace*} to drop all the non-word
characters.

@fundhum-examples[#:no-prompt
;;; Procedure:
;;;   common-form
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   Convert str into a "common form" for using in hash tables.
;;; Produces:
;;;   newstr, a string
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   If str1 and str2 are "similar" in that they have the same sequence 
;;;   of non-word characters, ignoring case, then 
;;;     (common-form str1) = (common-form str2)
;;; Philosophy:
;;;   Allows a somewhat more general approach to hash tables.
;;; Ponderings:
;;;   Not all hash keys are strings.  common-form only converts strings.
(define common-form
  (lambda (str)
    (if (string? str)
        (regexp-replace* #px"\\W" (string-downcase str) "")
	str)))
]

@fundhum-examples[
(common-form "Homegoing")
(common-form "Home Going")
(common-form "Home going!")
(common-form "Going home?")
(common-form (list "Home" "Going"))
]

Now that we have this helper procedure, we can write our own versions
of the basic hash table operations.

@fundhum-examples[#:no-prompt
;;; Procedure:
;;;   my-make-hash
;;; Parameters:
;;;   pairs, a list of key/value pairs
;;; Purpose:
;;;   Make a hash table from the pairs
;;; Produces:
;;;   hash, a hash table
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   For each element, pair, in pairs,
;;;     (my-hash-ref hash (car pair)) = (cdr pair)
(define my-make-hash
  (lambda (pairs)
    (make-hash (map (lambda (pair)
                      (cons (common-form (car pair))
                            (cdr pair)))
                    pairs))))

;;; Procedure:
;;;   my-hash-set!
;;; Parameters:
;;;   hash, a hash table
;;;   key, a Scheme value
;;;   value, a Scheme value
;;; Purpose:
;;;   Set the value associated with key in hash.
;;; Produces:
;;;   [Nothing; called for the side effect.]
;;; Preconditions:
;;;   [No addditional]
;;; Postconditions:
;;;   (my-hash-ref hash key) = val
(define my-hash-set!
  (lambda (hash key value)
        (hash-set! hash (common-form key) value)))

;;; Procedure:
;;;   my-hash-ref
;;; Parameters:
;;;   hash, a hash table
;;;   key, a Scheme value
;;; Purpose:
;;;   Look up a value by key.
;;; Produces:
;;;   value, a value
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * If (my-hash-has-key? hash key), value is the value previously
;;;     associated with key in hash.
;;;   * Otherwise, throws an error.
(define my-hash-ref
  (lambda (hash key)
    (hash-ref hash (common-form key))))

;;; Procedure:
;;;   my-hash-has-key?
;;; Parameters:
;;;   hash, a hash table
;;;   key, a Scheme value
;;; Purpose:
;;;   Determine if the table contains a particular key
;;; Produces:
;;;   has-key?, a Boolean
;;; Preconditions:
;;;   hash was created with `my-make-hash` and has only been modified
;;;   with `my-hash-set!`.
;;; Postconditions:
;;;   * If `(my-hash-set! hash key)` has been called previously, then
;;;     `has-key?` is true.
;;;   * If key is one of the keys used in the creation of hash with
;;;     my-make-hash, then `has-key?` is true.
;;;   * Otherwise, `has-key?` is false.
(define my-hash-has-key?
  (lambda (hash key)
    (hash-has-key? hash (common-form key))))
]

@fundhum-examples[
(define authors 
  (my-make-hash 
   (list (cons "The Princess Bride" "William Goldman")
         (cons "Homegoing" "Yaa Gasi")
         (cons "Moo" "Jane Smiley")
         (cons "Moo, Baa, La La La!" "Sanda Boynton"))))
(my-hash-ref authors "Homegoing")
(my-hash-ref authors "Home Going")
(my-hash-ref authors "moo!")
(my-hash-set! authors "Friday Black" "Nana Kwame Adjei-Brenyah")
(my-hash-ref authors "fri day black")
authors
]

What happens if we fail to use our methods?  Let's see.

@fundhum-examples[
(eval:error (hash-ref authors "Homegoing"))
(hash-set! authors "The Princess Bride" "S. Morgenstern")
(my-hash-ref authors "The Princess Bride")
(hash-ref authors "The Princess Bride")
authors
]

As these examples suggest, if we decide to use our alternate procedures,
we need to be uniform in our use of those procedures.

@section{Storing compound data}

What happens if we want to store more than one value with a key?  For
example, some books have more than one author.  For example, _How to
Design Programs_ is by Matthew Felleisen, Robert Bruce Findler, Matthew
Flatt, and Shriram Krishnamurthi.  One possibility, at least in this
case, is to represent the authors not as a string, but as a list.

@fundhum-examples[
(my-hash-set! authors
              "How to Design Programs"
              (list "Matthias Felleisen" "Robert Bruce Findler"
                    "Matthew Flatt" "Shriram Krishnamurthi"))
(my-hash-ref authors "How To Design Programs")
(my-hash-ref authors "Friday Black")
]

What happens when we want to associated different kinds of
values with a single key?  For example, a college phone directory
might contain not only a phone number, but also a username and an
address.  

Consider the following table.

@tabular[#:style 'boxed #:sep (hspace 3) #:row-properties '(bottom-border '())
         (list (list @bold{name} @bold{phone} @bold{username} @bold{address})
               (list "Avery" "555-555-1212" "aviary" "54 Main Hall")
               (list "Riley" "555-555-8888" "lifeof" "12 James B. Mary")
               (list "Reese" "555-555-1234" "pbcups" "N. Dibble")
               (list "Jordan" "555-555-4321" "air" "23 Center Dorm"))]


@noindent{}
How might we represent that table?

One possibility is to set up multiple hash tables, one that maps
the name to the phone number, a second of which maps the name to
the username, the third of which maps to an address, and so on and
so forth.  

@fundhum-examples[#:no-prompt
;;; Identifier:
;;;   phones
;;; Type:
;;;   Hash table 
;;; Value:
;;;   A collection of name/phone-number pairs.
(define phones (make-hash))

;;; Identifier:
;;;   usernames
;;; Type:
;;;   Hash table
;;; Purpose:
;;;   A collection of name/username pairs.
(define usernames (make-hash))

;;; Identifier:
;;;   addresses
;;; Type:
;;;   Hash table
;;; Purpose:
;;;   A collection of name/address pairs.
(define addresses (make-hash))

;;; Procedure:
;;;   add-entry!
;;; Parameters:
;;;   name, a string
;;;   phone, a string
;;;   username, a string
;;;   address, a string
;;; Purpose:
;;;   Adds an entry to our database of students.
(define add-entry!
  (lambda (name phone username address)
    (my-hash-set! phones name phone)
    (my-hash-set! usernames name username)
    (my-hash-set! addresses name address)))

;;; Procedure:
;;;   student-exists?
;;; Parameters:
;;;   name, a string
;;; Purpose:
;;;   Determines whether the student exists in our database
;;; Produces:
;;;   exists?, a Boolean
(define student-exists?
  (lambda (name)
    (and (hash-has-key? phones name)
         (hash-has-key? usernames name)
         (hash-has-key? addresses name))))

;;; Procedure:
;;;   lookup-phone
;;; Parameters:
;;;   name, a string
;;; Purpose:
;;;   Look up a phone number in our directory of students
;;; Produces:
;;;   phone, a string (or #f)
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * If (student-exists? name), returns the phone number associated
;;;     with the student.  
;;    * Otherwise, returns #f.
(define lookup-phone
  (lambda (name)
    (and (my-hash-has-key? phones name)
         (my-hash-ref phones name))))

;;; Procedure:
;;;   lookup-username
;;; Parameters:
;;;   name, a string
;;; Purpose:
;;;   Look up a username in our directory of students
;;; Produces:
;;;   username, a string (or #f)
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * If (student-exists? name), returns the username associated
;;;     with the student.  
;;    * Otherwise, returns #f.
(define lookup-username
  (lambda (name)
    (and (my-hash-has-key? usernames name)
         (my-hash-ref usernames name))))

;;; Procedure:
;;;   lookup-address
;;; Parameters:
;;;   name, a string
;;; Purpose:
;;;   Look up an address in our directory of students
;;; Produces:
;;;   address, a string (or #f)
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * If (student-exists? name), returns the address associated
;;;     with the student.  
;;    * Otherwise, returns #f.
(define lookup-address
  (lambda (name)
    (and (my-hash-has-key? addresses name)
         (my-hash-ref addresses name))))

]

@fundhum-examples[
(add-entry! "Avery" "555-555-1212" "aviary" "54 Main Hall")
(add-entry! "Riley" "555-555-8888" "lifeof" "12 James B. Mary")
(add-entry! "Reese" "555-555-1234" "pbcups" "N. Dibble")
(add-entry! "Jordan" "555-555-4321" "air" "23 Center Dorm")
(lookup-phone "Reese")
(lookup-address "Avery")
(lookup-username "Quinn")
(add-entry! "Quinn" "555-555-5555" "eskimo" "11Q")
(lookup-username "Quinn")
]

Unfortunately, the design means that we have only one set of phones,
usernames, and addresses.  It's our custom to make the table the
parameter to a procedure like `lookup-phone`; we want to look up
someone's phone number in a particular directory, rather than in a
global directory.

An alternative is to group data together into a single structure.  At
this point, your best bet would probably be a list in which you include
the values in a fixed order: First the phone number, then the username,
then the address.

@fundhum-examples[#:no-prompt
(define add-entry!
  (lambda (dir name phone username address)
    (my-hash-set! dir name (list phone username address))))
(define lookup-phone
  (lambda (dir name)
    (and (my-hash-has-key? dir name)
         (car (my-hash-ref dir name)))))
(define lookup-username
  (lambda (dir name)
    (and (my-hash-has-key? dir name)
         (cadr (my-hash-ref dir name)))))
(define lookup-address
  (lambda (dir name)
    (and (my-hash-has-key? dir name)
         (caddr (my-hash-ref dir name)))))
]

@fundhum-examples[
(define egelloc (make-hash))
(define ytisevinu (make-hash))
(add-entry! egelloc "Avery" "555-555-1212" "aviary" "54 Main Hall")
(add-entry! ytisevinu "Riley" "555-555-8888" "lifeof" "12 James B. Mary")
(add-entry! egelloc "Reese" "555-555-1234" "pbcups" "N. Dibble")
(add-entry! ytisevinu "Jordan" "555-555-4321" "air" "23 Center Dorm")
(lookup-address egelloc "Reese")
(lookup-address ytisevinu "Reese")
(add-entry! ytisevinu "Reese" "555-555-0000" "seer" "Off campus")
(lookup-address egelloc "Reese")
(lookup-address ytisevinu "Reese")
]

@section:self-checks{}

@self-check{_TITLE_}

@section:acknowledgements{}

In writing this section, we drew upon @hyperlink["https://docs.racket-lang.org/reference/hashtables.html"]{the discussion of hash tables in the Racket language documentation} and @hyperlink["https://docs.racket-lang.org/guide/hash-tables.html"]{the discussion of hash tables in the Racket Guide}.

This section also draws upon
@hyperlink["https://www.cs.grinnell.edu/~rebelsky/Courses/CSC151/2018S/readings/association-lists"]{a
reading entitled @q{Association Lists}} from Grinnell College's CSC
151.

@;{Lab Notes
* Extent common-form for another policy?
* Extend common-form to convert *everything* to a string?
* Do we want a lead-in to structs in which they need to store more than
  one value?
}
