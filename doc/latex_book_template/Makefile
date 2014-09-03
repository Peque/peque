
default_target: pdf

dvi:
	latex main.tex
	bibtex main
	makeglossaries main

pdf:
	pdflatex main.tex
	bibtex main
	makeglossaries main

clean:
	rm -f *.aux *.lof *.log *.lol *.lot *.out *.toc
	rm -f *.acn *.acr *.alg *.glg *.glo *.gls *.ist
	rm -f *.bbl *.blg

clean-all:
	make clean
	rm -f main.pdf main.dvi

help:
	@echo "The following targets are valid for this Makefile:"
	@echo "... dvi"
	@echo "... pdf         (the default if no target is provided)"
	@echo "... clean       (remove building files)"
	@echo "... clean-all   (remove all generated files)"

