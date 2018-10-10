#lang scribble/base

@(require "./fundhum-scribbling.rkt")
@(require scribble/manual)

@title[#:tag "html-reading"]{Writing Web pages}
@author{Samuel A. Rebelsky}

@summary{We introduce basic mechanisms for creating and linking pages
on the World-Wide Web.  We also explore the roles of markup and style
sheets.}

@italic{Prerequisites:} @secref["xml-reading"]

@section[#:tag "html-introduction"]{Introduction}

What is ``the Web''?  At this point in time, it seems to be many
different things to people.  However, at the core, the World Wide
Web is a *hypertext* document, a collection of ``pages'' of information
that are connected together by links.  In the early days of the
Web, those pages consisted mostly of text.  These days, images and
animations often seem more common than text.  Still, we can think
of the Web as a collection of interlinked things that we'll still refer
to as ``pages''.

@; NOTE: Do I want to be careful about the page/document terminology?

What do you need to support a system like the World Wide Web?
Certainly, it requires an underlying communication infrastructure
(the Internet) that lets computers talk to each other.  But that's
not enough.  We need at many additional components.

You've just finished reading about structural markup with XML.
Hence, it should not surprise you that the Web needs an agreed-upon
@emph{representation} for documents.  We've already realized that
XML-like notation is relatively dense to read.  Hence, we benefit
from a @emph{browser}, like Mozilla Firefox, that renders those
documents in a form appropriate for human readers and that makes
it easy to follow links to new documents.  Where do the documents
reside?  On @emph{servers}, which store or construct documents and
which respond to requests for those documents.  Of course, if the
servers are to receive requests and respond appropriately, we need
an agreed-upon @emph{communications protocol} that specifies, among
other things, how a browser specifies a request for a particular
page and how the server can respond.  For example, how should the
server describe the type of content or indicate that the particular
content requested is no longer available?

That sounds like a lot, doesn't it?  For the time being, we will focus
on how one writes that pages that compose the Web.  Later on, we'll
explore how one builds or extends Web servers and, along the way, we'll
consider issues of the communication protocols involved.

But let's start with how to build a simple Web page.

@section{HTML, the HyperText Markup Language}

When Tim Berners-Lee first developed the World-Wide Web, he designed a
simple language for marking up content that he called HTML, for
HyperText Markup Language.  Although the Web has grown significantly since
its origins as a communications systems for Physicists, HTML remains a
core Web technology.  The HTML of today still looks much like the
HTML that Berners-Lee first designed.  And, even though HTML predates
XML, HTML is now an XML dialect.  You should find the structure familiar:
an HTML document contains a variety of content along with tags that
describe the structure of the content.

@subsection[#:tag "html-example"]{An example}

@; NOTE: Update to something more digital-humanities oriented?

@xml-block|{
<!DOCTYPE html>
<html lang="en">
<head>
  <title>ThingymabobCoInc</title>
  <meta charset="utf-8">
</head>
<body>
  <p id="introduction">
    Welcome to the Web site of 
    <em class="company">ThingymabobCoInc</em>.  Here you will
    find not only thingys, but also mabobs.
  </p>

  <p>
    Here at <em class="company">ThingymabobCoInc</em>, we say
    <q id="slogan">If you can't find it here, you probably don't need it.</q>
  </p>

  <p>
    <em class="company">ThingymabobCoInc</em> is a proud sponsor of
    the Digital Humanities program at <a href="https://www.cs.grin.edu">The
    College of Smiles</a>.
  </p>
</body>
</html>
}|

You may have noticed that we've used somewhat different tags in this
document than we used in our XML documents.  HTML uses a @xml{p} tag
for paragraphs and an @xml{em} tag for emphasized text.  The @xml{a}
tag is used for links.  (Why is it @xml{a} and not @xml{link}?  I believe
Berners-Lee thought of a link as an ``anchor'' and wanted a concise
notation.)  We've also used @xml{head} tags to separate the metadata
from the content, which appears within a pair of @xml{body} tags.  In
this case, we've specified only two pieces of metadata: the character
set and the title of the document.  As we progress through our study
of HTML, you will see a few more.

You will also find that HTML tends to make comparatively limited use
of attributes.  Every tag can have a @xml{class} attribute, which
indicates the role or roles the annotated text serves.  Tags can also
have a @xml{style} attribute, which describes appearance.  Since there
are other ways to describe appearance, many pundits discourage the use
of the @xml{style} attribute.  Every tag can have an @xml{id} attribute,
which lets us refer specifically to that element.  

There are also some tag specific attributes, such as the @xml{href}
attribute of the @xml{a} tag. 

@subsection{Additional tags}

As you might expect, HTML specifies a wide array of tags.  You can
learn about them by reading the official specification or less formal
documentation, by looking at the underlying source of any Web pages,
and by asking people.  For now, we'll start with a few simple tags.
You'll discover more in the @seclink["html-lab"]{associated lab}.

@itemize{
@item{The @xml{p} tag marks paragraphs.}
@item{The @xml{emph} tag marks emphasized text, which usually appears in italics.}
@item{The @xml{strong} tag marks strongly emphasized text, which usually appears in boldface.}
@item{The @xml{q} tag marks a short quotation.}
@item{The @xml{blockquote} tag marks a block quotation.}
@item{The @xml{ul} tag marks an unnumbered list of things.}
@item{The @xml{ol} tag marks a numbered or lettered list of things.}
@item{The @xml{li} tag marks an item in a list.}
@item{The @xml{span} tag marks a short section of text, typically within a paragraph or something similar.  We often use @xml{span} along with a @xml{class} attribute to indicate a special role for a piece of text.}
@item{The @xml{div} tag marks a longer section of text, typically a paragraph or more.  We often use @xml{div} along with a xml{class} attribute to indicate a special role for a longer piece of text.}
}

@section{Formatting text with cascading style sheets}

You may have noted that, in most cases, we did not discuss the appearance
of the marked-up text .  Even when we did, such as when we noted that
emphasized text usually appears in italics ....

