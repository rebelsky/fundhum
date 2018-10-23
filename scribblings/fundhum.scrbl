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
@include-section{xml-reading.scrbl}
@include-section{html-reading.scrbl}
@include-section{html-lab-linux.scrbl}
@include-section{algorithm-building-blocks.scrbl}
@include-section{intro-racket-reading.scrbl}
@include-section{intro-racket-lab.scrbl}
@include-section{acknowledgements.scrbl}
