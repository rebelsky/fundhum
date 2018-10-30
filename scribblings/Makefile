%.pdf: %.scrbl
	scribble --pdf $<

%.html: %.scrbl
	scribble --html $<

%.tex: %.scrbl
	scribble --latex $<

%: %.scrbl
	scribble --htmls $<

SECTIONS = \
	intro.scrbl \
	html.scrbl

fundhum: $(SECTIONS)
