default:
	@echo "Please specify what to make."
	@echo "  make update - rebuild the package."
	@echo "  make docs - open up the documentation."

update:
	raco pkg update --link `pwd`

docs:
	raco docs fundhum
