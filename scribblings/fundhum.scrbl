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

@include-section{xml-reading.scrbl}			; Needs work
@include-section{html-reading.scrbl}			; Needs work
@include-section{html-lab-linux.scrbl}			; TO DO

@include-section{algorithm-building-blocks.scrbl}	; Ok
@include-section{drracket-reading.scrbl}		; Ok
@include-section{intro-racket-reading.scrbl}		; Ok
@include-section{intro-racket-lab.scrbl}		; TO DO

@include-section{procedures-reading.scrbl}		; Ok
@include-section{procedures-hop-reading.scrbl}		; Ok
@include-section{documentation.scrbl}			; Ok
@include-section{procedures-lab.scrbl}			; TO DO

@include-section{data-types.scrbl}			; Ok
@;include-section{numbers.scrbl}			; TO DO / Reuse
@;include-section{pictures.scrbl}			; TO DO / New
@;include-section{strings.scrbl}			; TO DO / Reuse
@;include-section{symbols.scrbl}			; TO DO / Reuse
@include-section{simple-lists.scrbl}			; Ok
@include-section{scheme-eval.scrbl}			; Needs significant work
@include-section{scheme-eval-lab.scrbl}			; TO DO

@;include-section{text-files.scrbl}			; TO DO / New
@;include-section{text-lab.scrbl}			; TO DO / New

@;include-section{regular-expressions.scrbl}		; TO DO / New
@;include-section{regexp-lab.srbl}			; TO DO / New

@;Placeholder: Pair programming and more

@;include-section{lists.scrbl}				; TO DO / Reuse
@;include-section{lists-lab.scrbl}			; TO DO / Reuse

@;include-section{booleans.scrbl}			; TO DO / Reuse
@;include-section{conditionals.scrbl}			; TO DO / Reuse
@;include-section{conditionals-lab.scrbl}		; TO DO / Reuse + New

@;include-section{documentation-revisited.scrbl}		; TO DO / Reuse
@;include-section{preconditions.scrbl}			; TO DO / Reuse
@;include-section{doc-precond-lab.scrbl}		; TO DO / New

@;include-section{processing-xml.scrbl}			; TO DO / New + Code
@;include-section{processing-xml-lab.scrbl}		; TO DO / New

@;include-section{testing}				; TO DO / Rewrite
@;include-section{testing-lab}				; TO DO / Rewrite

@;Placeholder: Discuss Exam 1

@;include-section{visualization.scrbl}			; TO DO / New
@;include-section{maps.scrbl}				; TO DO / New + Code
@;include-section{viz-lab.scrbl}			; TO DO / New

@;include-section{local-bindings.scrbl}			; TO DO / Reuse
@;include-section{local-bindings-lab.scrbl}		; TO DO / Rewrite

@;include-section{pairs.scrbl}				; TO DO / Reuse
@;include-section{pairs-lab.scrbl}			; TO DO / Reuse

@;include-section{vectors.scrbl}			; TO DO / Reuse
@;include-section{hash-tables.scrbl}			; TO DO / New
@;include-section{vectors-tables-lab.scrbl}		; TO DO / New

@;include-section{structs.scrbl}			; TO DO / New
@;include-section{structs-lab.scrbl}			; TO DO / New

@;include-section{recursion-basics.scrbl}		; TO DO / Rewrite
@;include-section{scheme-eval-stack.scrbl}		; TO DO / New
@;include-section{recursion-lab.scrbl}			; TO DO / Rewrite

@;include-section{randomness.scrbl}			; TO DO / Rewrite
@;include-section{text-generation.scrbl}		; TO DO / New
@;include-section{randomness-lab.scrbl}			; TO DO / New

@;include-section{helper-recursion.scrbl}		; TO DO / Reuse
@;include-section{helper-recursion-lab.scrbl}		; TO DO / Reuse

@;include-section{numeric-recursion.scrbl}		; TO DO / Reuse
@;include-section{numeric-recursion-lab.scrbl}		; TO DO / Reuse

@;include-section{recursion-patterns.scrbl}		; TO DO / Reuse
@;include-section{recursion-patterns-lab.scrbl}		; TO DO / Reuse

@;Placeholder: Discuss Exam 2

@;include-section{local-procedure-bindings.scrbl}	; TO DO / Reuse
@;include-section{local-procedure-bindings-lab.scrbl}	; TO DO / Reuse

@;include-section{trees.scrbl}				; TO DO / New
@;include-section{trees-lab.scrbl}			; TO DO / New

@;include-section{project.scrbl}			; TO DO / Reuse
@;include-section{project-lab.scrbl}			; TO DO / New

@;include-section{hop-revisited.scrbl}			; TO DO / Reuse
@;include-section{hop-lab.scrbl}			; TO DO / Reuse

@;include-section{algorithm-analysis.scrbl}		; TO DO / Reuse
@;include-section{algorithm-analysis-lab.scrbl}		; TO DO / Reuse

@;include-section{searching.scrbl}			; TO DO / New
@;include-section{binary-search.scrbl}			; TO DO / Rewrite
@;include-section{binary-search-lab.scrbl}		; TO DO / Rewrite

@;include-section{sorting.scrbl}			; TO DO / Rewrite
@;include-section{sorting-lab.scrbl}			; TO DO / New
@;  The lab is probably just a list of questions with a note
@;  that the best way to approach it is through discussion.

@;include-section{insertion-sort.scrbl}			; TO DO / Reuse
@;include-section{insertion-sort-lab.scrbl}		; TO DO / Reuse

@;include-section{merge-sort.scrbl}			; TO DO / Reuse
@;include-section{merge-sort-lab.scrbl}			; TO DO / Reuse


@include-section{acknowledgements.scrbl}
