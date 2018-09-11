%.pdf: %.scrbl
	scribble --pdf $<

%.html: %.scrbl
	scribble --html $<

%: %.scrbl
	scribble --htmls $<

SECTIONS = \
	intro.scrbl \
	html.scrbl

fundhum: $(SECTIONS)
