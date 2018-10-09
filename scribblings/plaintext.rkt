#lang br/quicklang

;;; File:
;;;   textlang.rkt
;;; Summary:
;;;   A stupid little language intended to allow me to put plain
;;;   text in a Racket file and have it work appropriately.  Intended
;;;   primarily for use in Scribble.
;;; Author:
;;;   Samuel A. Rebelsky

; +---------+--------------------------------------------------------
; | Exports |
; +---------+

(provide (rename-out [plaintext-read-syntax read-syntax]))
(provide (rename-out [plaintext-module-begin #%module-begin]))

; +-------------+----------------------------------------------------
; | read-syntax |
; +-------------+

;;; Procedure:
;;;   plaintext-read-syntax
;;; Parameters:
;;;   source-name, the name of the source (typically a path)
;;;   port, an input port
;;; Purpose:
;;;   Read text from the given port and produce a syntax object.
;;; Produces:
;;;   syntax, a syntax object (or EOF)
;;; Ponderings:
;;;   Further info on the form of read-syntax is in the Racket
;;;   documentation at https://docs.racket-lang.org/reference/Reading.html
(define plaintext-read-syntax
  (lambda (source-name port)
    (let* ([source-lines (port->lines port)]
           [source-expressions (void)])
      ; (write source-expressions) (newline)
      (datum->syntax #f
                     `(module plaintext "plaintext.rkt")))))

; +--------------+---------------------------------------------------
; | module-begin |
; +--------------+
 
; Original version from the book, more or less verbatim
(define-macro (plaintext-module-begin EXPR ...)
  #'(#%module-begin
     EXPR ...))

; +-----------------+------------------------------------------------
; | Other utilities |
; +-----------------+

;;; Procedure:
;;;   string->value
;;; Parameters:
;;;   str, a string
;;; Purpose:
;;;   Convert a string to the corresponding Scheme value
;;; Produces:
;;;   val, a Scheme value
;;; Preconditions:
;;;   str must represent a single, valid, Scheme value
;;; Postconditions:
;;;   (value->string val) = str (perhaps with a change in spacing).
;;; Problems:
;;;   Error messages are not perfect.
(define string->value
  (lambda (str)
    (when (not (string? str))
      (error "string->val: Expects a string, received " str))
    (let* ([port (open-input-string str)]
           [val (read port)]
           [next (read port)])
      (close-input-port port)
      (if (not (eof-object? next))
          (error "string->val: Read multiple values, including " val "and" next)
          val))))

;;; Procedure:
;;;   value->string
;;; Parameters:
;;;   val, a Scheme value
;;; Purpose:
;;;   convert val to a string.
;;; Produces:
;;;   str, a string
;;; Preconditions:
;;;   [No additional]
;;; Postconditions:
;;;   (value->string str) = val
(define value->string
  (lambda (val)
    (let ([port (open-output-string)])
      (write val port)
      (close-output-port port)
      (get-output-string port))))

; +-------+----------------------------------------------------------
; | Notes |
; +-------+
