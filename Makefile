%.pdf: %.typ
	typst compile --root . $<

%.pdfpc: %.typ
	typst query --root . $< --field value --one "<pdfpc-file>" > $@

FILE ?= demo.typ
watch:
	typst watch --root . $(FILE)