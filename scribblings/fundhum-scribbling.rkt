#lang racket/base

;;; fundhum-scribbling.rkt
;;;   A collection of Racket utilities to help with the FunDHum
;;;   Scribble project.

; +-----------+------------------------------------------------------
; | Libraries |
; +-----------+

(require scribble/base)
(require scribble/manual)

; +---------+--------------------------------------------------------
; | Exports |
; +---------+

(provide book-title)
(provide exercise)
(provide extra)
(provide prefix)
(provide q)
(provide sect)
(provide section*)
(provide section:exercises)
(provide section:extra)
(provide section:preparation)
(provide section:reference)
(provide summary)
(provide text-block)
(provide verb)
(provide xml)
(provide xml-block)

; +---------+--------------------------------------------------------
; | Globals |
; +---------+

;;; Global:
;;;   _exercise_
;;; Type:
;;;   non-negative integer
;;; Content:
;;;   The number of the current exercise
(define _exercise_ 0)

;;; Global:
;;;   _extra
;;; Type:
;;;   non-negative integer
;;; Content:
;;;   The number of the current extra exercise
(define _extra_ 0)

; +--------+---------------------------------------------------------
; | Macros |
; +--------+

;;; Syntax:
;;;   summary
;;; Parameters:
;;;   content ..., a collection of Scribble expressions
;;; Purpose:
;;;   Generate a summary
;;; Produces:
;;;   summary, a Scribble expression
(define-syntax-rule (summary content ...)
  (elem (emph "Summary: ") content ...))

;;; Syntax:
;;;   section*
;;; Parameters:
;;;   contents ..., a collection of Scribble expressions
;;; Purpose:
;;;   Generate an unnumbered section.
;;; Produces:
;;;   section, a Scribble expression
(define-syntax-rule (section* content ...)
  (section #:style 'unnumbered content ...))

;;; Macro:
;;;   sect
;;; Parameters:
;;;   tag, a string
;;;   contents ... lots of elements
;;; Purpose:
;;;   An alternative to @section that tags in a way I find
;;;   convenient
;;; Produces:
;;;   sect, an element
(define-syntax-rule (sect tag content ...)
  (section #:tag (string-append (prefix) "-" tag) content ...))

;;; Macro:
;;;   exercise
;;; Parameters:
;;;   title ..., a sequence of elements that represent the title
;;; Purpose:
;;;   Create an exercise heading
;;; Produces:
;;;   exercise, an element heading
(define-syntax-rule (exercise title ...)
  (exercise-helper
    (subsection #:tag (string-append (prefix) "-" (twodig _exercise_))
                title ...)))

(define-syntax-rule (extra title ...)
  (extra-helper
    (subsection #:tag (string-append (prefix) "-extra-" (twodig _extra_))
                title ...)))

;;; Macro:
;;;   q
;;; Parameters:
;;;   text, a Scribble element or sequence of Scribble elements
;;; Purpose:
;;;   Put quotation marks around the text.
;;; Produces:
;;;   textplus ..., a sequence of Scribble elements
;;; Problems:
;;;   Likely needs some real testing.
(define-syntax-rule (q text ...)
  (begin 
    (inc-quote-level!)
    (let ([result (q-core text ...)])
      (dec-quote-level!)
      result)))

(define QUOTE-LEVEL 0)

(define inc-quote-level!
  (lambda ()
    (set! QUOTE-LEVEL (+ QUOTE-LEVEL 1))))

(define dec-quote-level!
  (lambda ()
    (set! QUOTE-LEVEL (- QUOTE-LEVEL 1))))

(define q-core
  (lambda stuff
    (define OPEN (if (odd? QUOTE-LEVEL) "``" "`"))
    (define CLOSE (if (odd? QUOTE-LEVEL) "''" "'"))
    (cond
      [(null? stuff)
       (string-append OPEN CLOSE)]
      [(and (null? (cdr stuff)) (string? (car stuff)))
       (string-append OPEN (car stuff) CLOSE)]
      [else
       (append (list OPEN)
               stuff
	       (list CLOSE))])))

;;; Macro:
;;;   text-block
;;; Parameters:
;;;   elements ...
;;; Purpose:
;;;   Render XML code as a text block
;;; Produces:
;;;   elt, a Scribble element (or something like that)
(define-syntax-rule (text-block elements ...)
  (codeblock #:keep-lang-line? #f 
	     "#lang reader \"plaintext.rkt\"\n" 
	     elements ...))

;;; Macro:
;;;   xml-block
;;; Parameters:
;;;   elements ..., zero or more Scribble elements
;;; Purpose:
;;;   Render XML code as a text block
;;; Produces:
;;;   elt, a Scribble element (or something like that)
;;; Ponderings:
;;;   Eventually, I may produce/include a parser for XML.  For now, this
;;;   just renders things verbatim.
(define-syntax-rule (xml-block elements ...)
  (codeblock #:keep-lang-line? #f 
             #:line-numbers 0
	     "#lang reader \"plaintext.rkt\"\n" 
	     elements ...))

; (nested #:style 'code-inset (verbatim str ...)))
; (codeblock #:line-numbers 1 str ...))
; (codeblock #:line-numbers #t "#lang xml" "\n" str ...))

; +---------------------+--------------------------------------------
; | Exported Procedures |
; +---------------------+

;;; Procedure:
;;;   book-title
;;; Parameters:
;;;   title, a string
;;; Purpose:
;;;   Generate the title of a book
;;; Produces:
;;;   Code for the title of a book
(define book-title emph)

;;; Procedure:
;;;   prefix
;;; Parameters:
;;;   val [optional], a string
;;; Purpose:
;;;   Get or set the current tag prefix.
;;; Produces:
;;;   prefix, a string or nothing
(define prefix
  (let [(val "prefix")]
    (lambda params
      (if (null? params)
          val
	  (set! val (car params))))))

;;; Procedure:
;;;   section:preparation
;;; Parameters:
;;;   [None]
;;; Purpose:
;;;   Generate the appropriate header for the preparation part of a lab
;;; Produces:
;;;   sect, an element
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   * sect is a section heading
;;;   * sect's tag is (prefix)-prep
(define section:preparation
  (lambda ()
    (sect "prep" "Preparation")))

(define section:exercises
  (lambda ()
    (set! _exercise_ 0)
    (section #:tag (string-append (prefix) "-exercises") "Exercises")))

(define section:extra
  (lambda ()
    (set! _extra_ 0)
    (section #:tag (string-append (prefix) "-extra") "Extra")))

(define section:reference
  (lambda ()
    ; Reset exercise count?
    (section #:tag (string-append (prefix) "-reference") "Reference")))

;;; Procedure:
;;;   verb
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   Render something verbatim
;;; Produces:
;;;   elt, a Scribble element
;;; Ponderings:
;;;   Like tt or literal, but handles quotations right (I think).
(define verb
  (lambda (code)
    (elem #:style 'tt (literal code))))

;;; Procedure:
;;;   xml
;;; Parameters:
;;;   code, a string
;;; Purpose:
;;;   Render XML code
;;; Produces:
;;;   elt, a Scribble element
;;; Ponderings:
;;;   Eventually, I may produce a parser for XML.  For now, this
;;;   just renders things verbatim.
(define xml
  (lambda (code)
    (elem #:style 'tt (literal code))))

; +-----------------+------------------------------------------------
; | Local Utilities |
; +-----------------+

;;; Procedure:
;;;   twodig
;;; Parameters:
;;;   val, an integer
;;; Purpose:
;;;   Convert val into a two-digit string
;;; Produces:
;;;   str, a string
;;; Preconditions:
;;;   0 <= val < 100
;;; Postconditions:
;;;   * (string-length str) is 2
;;;   * (string->number str) is val
;;; Practica:
;;;   > (twodig 3)
;;;   "03"
;;;   > (twodig 42)
;;;   "42"
(define twodig
  (lambda (val)
    (if (< val 10)
        (string-append "0" (number->string val))
	(number->string val))))

(define exercise-helper
  (lambda (thing)
    (set! _exercise_ (+ 1 _exercise_))
    thing))

(define extra-helper
  (lambda (thing)
    (set! _extra_ (+ 1 _extra_))
    thing))
