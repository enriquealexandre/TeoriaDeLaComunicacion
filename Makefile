TEX=xelatex -interaction nonstopmode -halt-on-error -file-line-error
DIRS=$$(ls -d */) 

.PHONY: clean all

%:
	cd ./Tema_$@/Boletín ; sed '1 s/\[idioma/\[es/' BoletinT$@.tex > aux.tex ; $(TEX) -jobname=BoletinT$@ "\input{aux.tex}" > BoletinT$@.log ; sed '1 s/\[idioma/\[en/' BoletinT$@.tex > aux.tex; $(TEX) -jobname=BoletinT$@_en "\input{aux.tex}" > BoletinT$@_en.log ; cd ../..

all: 2 3 4 5 6 

clean:
	@for x in $(DIRS); do cd ./$$x\Boletín; rm -f aux.tex *.out *aux *bbl *blg *log *toc *.ptb *.tod *.fls *.fdb_latexmk *.lof *.nav *.snm *.vrb *.dvi *.synctex.gz; cd ../..; done;

