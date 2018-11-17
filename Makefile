# Makefile of _Plu Glosa Dokumenta_

# By Marcos Cruz (programandala.net)

# Last modified 201811171936
# See change log at the end of the file

# ==============================================================
# Requirements

# - make
# - asciidoctor
# - asciidoctor-pdf
# - pandoc

# ==============================================================

target=target

VPATH=./$(target)

.PHONY: all
all: epub html odt pdf

.PHONEY: clean
clean:
	rm -f $(target)/

.PHONY: docbook
docbook: $(target)/g18s.adoc.xml

.PHONY: epub
epub: $(target)/g18s.adoc.xml.pandoc.epub

.PHONY: html
html: $(target)/g18s.adoc.html $(target)/g18s.adoc.plain.html $(target)/g18s.adoc.xml.pandoc.html

.PHONY: odt
odt: $(target)/g18s.adoc.xml.pandoc.odt

.PHONY: pdf
pdf: $(target)/g18s.adoc.pdf

.PHONY: rtf
rtf: $(target)/g18s.adoc.xml.pandoc.rtf

# ==============================================================
# Convert to DocBook

$(target)/g18s.adoc.xml: g18s.adoc
	asciidoctor --backend=docbook5 --out-file=$@ $<

# ==============================================================
# Convert to EPUB

# NB: Pandoc does not allow alternative templates. The default templates must
# be modified or redirected instead. They are the following:
# 
# /usr/share/pandoc-1.9.4.2/templates/epub-coverimage.html
# /usr/share/pandoc-1.9.4.2/templates/epub-page.html
# /usr/share/pandoc-1.9.4.2/templates/epub-titlepage.html

$(target)/g18s.adoc.xml.pandoc.epub: $(target)/g18s.adoc.xml
	pandoc \
		--from=docbook \
		--to=epub \
		--output=$@ \
		$<

# ==============================================================
# Convert to HTML

$(target)/g18s.adoc.plain.html: g18s.adoc
	adoc \
		--attribute="stylesheet=none" \
		--quiet \
		--out-file=$@ \
		$<

$(target)/g18s.adoc.html: g18s.adoc
	adoc --out-file=$@ $<

$(target)/g18s.adoc.xml.pandoc.html: $(target)/g18s.adoc.xml
	pandoc \
		--from=docbook \
		--to=html \
		--output=$@ \
		$<

# ==============================================================
# Convert to ODT

$(target)/g18s.adoc.xml.pandoc.odt: $(target)/g18s.adoc.xml
	pandoc \
		+RTS -K15000000 -RTS \
		--from=docbook \
		--to=odt \
		--output=$@ \
		$<

# ==============================================================
# Convert to PDF

$(target)/g18s.adoc.pdf: g18s.adoc
	asciidoctor-pdf --out-file=$@ $<

# ==============================================================
# Convert to RTF

# XXX FIXME -- Both LibreOffice Writer and AbiWord don't read this RTF file
# properly. The RTF marks are exposed. It seems they don't recognize the format
# and take it as a plain file.

$(target)/g18s.adoc.xml.pandoc.rtf: $(target)/g18s.adoc.xml
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
