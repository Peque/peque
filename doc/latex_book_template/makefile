default_target: dvi

dvi: 
	latex main.tex

pdf:
	pdflatex main.tex

clean: 
	rm -f *.aux *.toc *.log *.lof *.lot

clean-all:
	make clean
	rm -f main.pdf main.dvi

help:
	@echo "The following targets are valid for this Makefile:"
	@echo "... dvi (the default if no target is provided)"
	@echo "... pdf"
	@echo "... clean"
	@echo "... clean-all"

