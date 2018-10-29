#lang scribble/book
@require[@for-label[fundhum
                    racket/base]]
@(require scribble/manual)

@title{FunDHum: A Functional Approach to the Digital Humanities}
@author{Samuel A. Rebelsky}

@defmodule[fundhum]

FunDHum provides an introduction to algorithmic thinking using 
examples drawn from the digital humanities.  It employs the Racket
programming language for most of those examples.  See the 
@secref["Introduction"] for more information.  

@table-of-contents[]

@include-section{intro.scrbl}
@include-section{day-intro-markup.scrbl}
@include-section{day-intro-racket.scrbl}
@include-section{day-procedures.scrbl}
@include-section{acknowledgements.scrbl}
