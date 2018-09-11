#lang info
(define collection "fundhum")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/fundhum.scrbl" (multi-page))))
(define pkg-desc "The FunDHum project project")
(define version "0.0.1")
(define pkg-authors '("Samuel A. Rebelsky"))
