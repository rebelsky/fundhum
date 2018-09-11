#lang racket/base

;;; fundhum-scribbling.rkt
;;;   A collection of Racket utilities to help with the FunDHum
;;;   Scribble project.

; +-----------+------------------------------------------------------
; | Libraries |
; +-----------+

(require scribble/base)

; +---------+--------------------------------------------------------
; | Exports |
; +---------+

(provide summary)
(provide section*)
(provide prefix)
(provide sect)
(provide section:preparation)
(provide section:exercises)
(provide section:extra)
(provide section:reference)
(provide exercise)
(provide extra)

; +---------+--------------------------------------------------------
; | Globals |
; +---------+

(define _exercise_ 0)
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

; +---------------------+--------------------------------------------
; | Exported Procedures |
; +---------------------+

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
