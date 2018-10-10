#lang scribble/base

@(require "./fundhum-scribbling.rkt")

@prefix{html-lab-linux}

@title{Laboratory: Writing Web pages on Linux Systems}
@author{Samuel A. Rebelsky}
@summary{We explore basic techniques for building Web pages in HTML and CSS.  We also explore how to deploy them on a standard Linux Web server.}

@section:preparation{}

To prepare for this laboratory, you will need to enter a number of
@q{magic incantations}, commands that will not mean much to you but
that will accomplish important tasks.  If you'd like more of an
explanation, there are @seclink["html-linux-magic-commands-explained"]{some notes at the end of
this lab}.  Of course, one the problems with unexplained incantations 
is that they can go wrong; if you find that the incantations do not
behave as expected, or do not lead to the situations described further
in the lab, ask for help.

First, open a terminal Window.

Then, type the following commands.  (The tilde symbol, \verb{~},
which appears in many of those commands, is typically found at the
top-left of standard U.S. keyboards.)

@text-block|{
chmod a+x ~
mkdir -p ~/public_html
chmod a+x ~/public_html
cd ~/public_html
git clone https://github.com/grinnell-cs/fundhum-html-lab 
}|

Your instructor should have provided you with a name for the Web
server your account is associated with.  (For example, at Grinnell
College, it's @url{https://www.cs.grinnell.edu}.)  Navigate to
@url{https://SERVER.edu/~USERNAME/fundhum-html-lab/}, substituting
your server name and user name.  You should see ...

@section:exercises{}

@exercise{An exercise}

@exercise{Another exercise}

@section:extra{}

@extra{Something extra}

@section:reference{}

@section[#:tag "html-linux-magic-commands-explained"]{Explanations of the @q{magic commands}}

