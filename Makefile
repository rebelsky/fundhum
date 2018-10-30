default:
	@echo "Please specify what to make."
	@echo "  make update - rebuild the package."
	@echo "  make read - open up the installed documentation."
	@echo "  make web - build the Web site."
	@echo "  make pdf - build the PDF version."

update:
	raco pkg update --link `pwd`

read:
	raco docs fundhum

web:
	scribble --htmls scribblings/fundhum.scrbl

pdf:
	scribble --pdf scribblings/fundhum.scrbl

install-local:
	raco pkg install
