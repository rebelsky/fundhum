#lang racket/base

;;; fundhum-scribbling.rkt
;;;   A collection of Racket utilities to help with the FunDHum
;;;   Scribble project.

; +-----------+------------------------------------------------------
; | Libraries |
; +-----------+

(require scribble/base)
(require scribble/manual)
; (require scribble/eval)
(require scribble/example)
(require racket/sandbox)
(require teachpack/2htdp/scribblings/img-eval)

; +---------+--------------------------------------------------------
; | Exports |
; +---------+

(provide book-title
         exercise
         extra
         fundhum-eval
         fundhum-examples
         image-examples
         noindent
         prefix
	 prereqs
         q
         sect
         section*
	 section:acknowledgements
         section:exercises
         section:extra
         section:preparation
         section:reference
         section:self-checks
         self-check
         summary
         text-block
         verb
         xml
         xml-block)

; +--------------------+---------------------------------------------
; | Exported variables |
; +--------------------+

;;; Variable:
;;;   fundhum-eval
;;; Type:
;;;   evaluator
;;; Content:
;;;   An evaluator that is appropriate for the fundhum exercises (or
;;;   so I hope)
(define fundhum-eval
  (let ([so (sandbox-output)]
        [seo (sandbox-error-output)])
    (sandbox-output 'string)
    (sandbox-error-output 'string)
    (let ([result (make-evaluator 'racket)])
      (sandbox-output so)
      (sandbox-error-output seo)
      result)))

; +------------------+-----------------------------------------------
; | Shared variables |
; +------------------+

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

;;; Global:
;;;   _self_check_
;;; Type:
;;;   non-negative integer
;;; Content:
;;;   The number of the current self check
(define _self_check_ 0)

; +--------+---------------------------------------------------------
; | Macros |
; +--------+

;;; Syntax:
;;;   fundhum-examples
;;; Parameters:
;;;    e ..., expressions
;;; Purpose:
;;;   Generate a standard example
(define-syntax-rule (fundhum-examples e ...)
  (examples #:eval fundhum-eval
            #:label #f
	    e ...))

;;; Syntax:
;;;   image-examples
;;; Parameters:
;;;   e ..., expressions
;;; Purpose:
;;;   Generate examples involving images
(define-syntax-rule (image-examples e ...)
  (examples #:eval (make-img-eval)
            #:label #f
	    e ...))

;;; Syntax:
;;;   prereqs
;;; Parameters:
;;;   pr ..., text describing the prerequisites
;;; Purpose:
;;;   Generate the prerequisites
(define-syntax-rule (prereqs pr ...)
  (elem (noindent) (emph "Prerequisities: ") pr ...))

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
;;; Postconditions:
;;;   sect is tagged with (prefix):tag.
(define-syntax-rule (sect tag content ...)
  (section #:tag (string-append (prefix) ":" tag) content ...))

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
    (subsection #:tag (string-append (prefix) ":exercise-" (twodig _exercise_))
                title ...)))

(define-syntax-rule (extra title ...)
  (extra-helper
    (subsection #:tag (string-append (prefix) ":extra-" (twodig _extra_))
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
;;;   self-check
;;; Parameters:
;;;   title ..., a bunch of elements
;;; Purpose:
;;;   generate the header for a self check
(define-syntax-rule (self-check title ...)
  (self-check-helper
    (subsection #:tag (string-append (prefix) ":self-check-" (twodig _self_check_))
                "Check " (number->string _self_check_) ": " title ...)))

;   (subsection #:style 'unnumbered #:tag (string-append (prefix) ":self-check-" (twodig _self_check_))
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
;;;   noindent
;;; Parameters:
;;;   [None]
;;; Purpose:
;;;   Add a "don't indent" signal for LaTeX output.
;;; Produces:
;;;   annotation, an element
;;; Props:
;;;   From Matthew Flatt's note at https://groups.google.com/forum/#!topic/racket-users/9xBZOD9lqsU
(define noindent
  (lambda ()
    (elem #:style "noindent")))
    
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
;;;   section:acknowledgements
;;; Parameters:
;;;   [None]
;;; Purpose:
;;;   Generate the section header for the acknowledgements section
;;; Produces:
;;;   sect, a scribble element.
;;; Preconditions:
;;;   The prefix has been set with `prefix`.
(define section:acknowledgements
  (lambda ()
    (section #:style 'unnumbered
             #:tag (string-append (prefix) ":acknowledgements") 
	     "Acknowledgements")))

;;; Procedure:
;;;   section:exercises
;;; Parameters:
;;;   [None]
;;; Purpose:
;;;   Generate the header for the exercises in a lab.
;;; Produces:
;;;   sect, a Scribble element
;;; Preconditions:
;;;   The prefix has been set with prefix.
;;; Postconditions:
;;;   * The exercise count is reset to zero.
;;;   * sect appropriately represents the start of a set of exercises
;;;   * sect's tag is (prefix):exercises
(define section:exercises
  (lambda ()
    (set! _exercise_ 0)
    (section #:tag (string-append (prefix) ":exercises") "Exercises")))

;;; Procedure:
;;;   section:extra
;;; Parameters:
;;;   [None]
;;; Purpose:
;;;   Generate the header for the extra problems in a lab.
;;; Produces:
;;;   sect, a Scribble element
;;; Preconditions:
;;;   The prefix has been set with prefix.
;;; Postconditions:
;;;   * The extra count is reset to zero.
;;;   * header appropriately represents the start of a set of extra exercises
;;;   * sect's tag is (prefix):extra
(define section:extra
  (lambda ()
    (set! _extra_ 0)
    (section #:tag (string-append (prefix) ":extra") "Extra")))

;;; Procedure:
;;;   section:preparation
;;; Parameters:
;;;   [None]
;;; Purpose:
;;;   Generate the appropriate header for the preparation part of a lab
;;; Produces:
;;;   sect, an element
;;; Preconditions:
;;;   The prefix has been set with prefix.
;;; Postconditions:
;;;   * sect is a section heading
;;;   * sect's tag is (prefix):prep
(define section:preparation
  (lambda ()
    (sect "prep" "Preparation")))

;;; Procedure:
;;;   section:reference
;;; Parameters:
;;;   [None]
;;; Purpose:
;;;   Generate the appropriate header for the reference part of a lab.
;;; Produces:
;;;   sect, an element
;;; Preconditions:
;;;   The prefix has been set with prefix.
;;; Postconditions:
;;;   * sect is a section heading
;;;   * sect's tag is (prefix)-reference
(define section:reference
  (lambda ()
    (sect "reference" "Reference")))

;;; Procedure:
;;;   section:self-checks
;;; Parameters:
;;;   [None]
;;; Purpose:
;;;   Generate the header for the self checks in a reading
;;; Produces:
;;;   sect, a Scribble element
;;; Preconditions:
;;;   The prefix has been set with prefix.
;;; Postconditions:
;;;   * The self-check count is reset to zero.
;;;   * header appropriately represents the start of a set of self checks
;;;   * sect's tag is (prefix):self-checks
(define section:self-checks
  (lambda ()
    (set! _self_check_ 1)
    (section #:tag (string-append (prefix) ":self-checks") "Self Checks")))

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

(define self-check-helper
  (lambda (thing)
    (set! _self_check_ (+ 1 _self_check_))
    thing))


