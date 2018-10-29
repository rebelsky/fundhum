#lang scribble/manual
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
@include-section{drracket-reading.scrbl}
@include-section{intro-racket-reading.scrbl}
@include-section{intro-racket-lab.scrbl}

@include-section{procedures-reading.scrbl}
@include-section{scheme-eval.scrbl}
@include-section{procedures-hop-reading.scrbl}
@include-section{documentation.scrbl}
@include-section{procedures-lab.scrbl}

@;{ Lots more stuff! }
@;{@include-section{documentation-revisited.scrbl}}
@;{ Hash tables! }
@;{ Need Scheme-eval for local bindings }

@;{
@include-section{recursion-basics.scrbl}
@include-section{scheme-eval-stack.scrbl}
@include-section{recursion-basic-lab.scrbl}
}

@include-section{acknowledgements.scrbl}
