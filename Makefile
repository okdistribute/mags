.SUFFIXES: .w .tex .dvi .pdf .ps

.w.tex:
	chezweave $< 

.tex.dvi:
	tex $<
	tex $<

.dvi.ps:
	dvips -t letter -o $*.ps $<

.dvi.pdf:
	dvipdfm -p letter -o doc/$*.pdf $<

clean:
	rm -rf *.ps
	rm -rf *.dvi
	rm -rf *.log
	rm -rf *.aux
	rm -rf *.toc