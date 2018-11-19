# Makefile of _Plu Glosa Dokumenta_

# By Marcos Cruz (programandala.net)

# Last modified 201811191457
# See change log at the end of the file

# ==============================================================
# Requirements

# - make
# - asciidoctor
# - asciidoctor-pdf
# - pandoc

# ==============================================================
# Config

target=target

VPATH=./src:./$(target)

# ==============================================================
# Book shortcuts

_18s=18_steps_to_fluency_in_euro-glosa

# ==============================================================
# Interface

.PHONY: all
all: epub html odt pdf

.PHONY: docbook
docbook: $(target)/$(_18s).adoc.xml

.PHONY: epub
epub: $(target)/$(_18s).adoc.xml.pandoc.epub

.PHONY: html
html: $(target)/$(_18s).adoc.html $(target)/$(_18s).adoc.plain.html $(target)/$(_18s).adoc.xml.pandoc.html

.PHONY: odt
odt: $(target)/$(_18s).adoc.xml.pandoc.odt

.PHONY: pdf
pdf: $(target)/$(_18s).adoc.pdf

.PHONY: rtf
rtf: $(target)/$(_18s).adoc.xml.pandoc.rtf

.PHONY: clean
clean:
	rm -f $(target)/*

# ==============================================================
# Convert to DocBook

$(target)/$(_18s).adoc.xml: $(_18s).adoc
	asciidoctor --backend=docbook5 --out-file=$@ $<

# ==============================================================
# Convert to EPUB

# NB: Pandoc does not allow alternative templates. The default templates must
# be modified or redirected instead. They are the following:
# 
# /usr/share/pandoc-1.9.4.2/templates/epub-coverimage.html
# /usr/share/pandoc-1.9.4.2/templates/epub-page.html
# /usr/share/pandoc-1.9.4.2/templates/epub-titlepage.html

$(target)/$(_18s).adoc.xml.pandoc.epub: $(target)/$(_18s).adoc.xml
	pandoc \
		--from=docbook \
		--to=epub \
		--output=$@ \
		$<

# ==============================================================
# Convert to HTML

$(target)/$(_18s).adoc.plain.html: $(_18s).adoc
	adoc \
		--attribute="stylesheet=none" \
		--quiet \
		--out-file=$@ \
		$<

$(target)/$(_18s).adoc.html: $(_18s).adoc
	adoc --out-file=$@ $<

$(target)/$(_18s).adoc.xml.pandoc.html: $(target)/$(_18s).adoc.xml
	pandoc \
		--from=docbook \
		--to=html \
		--output=$@ \
		$<

# ==============================================================
# Convert to ODT

$(target)/$(_18s).adoc.xml.pandoc.odt: $(target)/$(_18s).adoc.xml
	pandoc \
		+RTS -K15000000 -RTS \
		--from=docbook \
		--to=odt \
		--output=$@ \
		$<

# ==============================================================
# Convert to PDF

$(target)/$(_18s).adoc.pdf: $(_18s).adoc
	asciidoctor-pdf --out-file=$@ $<

# ==============================================================
# Convert to RTF

# XXX FIXME -- Both LibreOffice Writer and AbiWord don't read this RTF file
# properly. The RTF marks are exposed. It seems they don't recognize the format
# and take it as a plain file.

$(target)/$(_18s).adoc.xml.pandoc.rtf: $(target)/$(_18s).adoc.xml
	pandoc \
		--from=docbook \
		--to=rtf \
		--output=$@ \
		$<

# ==============================================================
# Change log

# 2018-11-15: Start. Convert _18 Steps to Fluency in Euro-Glosa_ into HTML.
#
# 2018-11-17: Create also EPUB, ODT, RTF (with problems) and PDF. Also create
# an additional HTML by Pandoc.
#
# 2018-11-19: Adapt to long file names specified by variables and the new
# directory used for the Asciidoctor sources. These changes are needed in order
# to add more documents to the project.
