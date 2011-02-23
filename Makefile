.SUFFIXES: .w .tex .dvi .pdf .ps

.w.tex:
	chezweave $< 

.tex.dvi:
	tex $<
	tex $<

.dvi.ps:
	dvips -t letter -o $*.ps $<

.dvi.pdf:
	dvipdfm -p letter -o $*.pdf $<

