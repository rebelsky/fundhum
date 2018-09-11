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
  (elem (emph "Summary" content ...)))

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
