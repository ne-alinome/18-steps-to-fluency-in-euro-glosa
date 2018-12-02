# Makefile of _18 Steps to Fluency in Euro-Glosa_

# By Marcos Cruz (programandala.net)

# Last modified 201812022338
# See change log at the end of the file

# ==============================================================
# Requirements

# - make
# - asciidoctor
# - asciidoctor-pdf
# - pandoc

# ==============================================================
# Config

VPATH=./src:./$(target)

book=18_steps_to_fluency_in_euro-glosa

target=target

# ==============================================================
# Interface

.PHONY: all
all: epub html

.PHONY: docbook
docbook: $(target)/$(book).adoc.xml

.PHONY: epub
epub: $(target)/$(book).adoc.xml.pandoc.epub

.PHONY: picdir
picdir:
	ln --force --symbolic --target-directory=$(target) ../src/pic

.PHONY: html
html: picdir $(target)/$(book).adoc.html $(target)/$(book).adoc.plain.html $(target)/$(book).adoc.xml.pandoc.html

.PHONY: odt
odt: $(target)/$(book).adoc.xml.pandoc.odt

.PHONY: pdf
pdf: $(target)/$(book).adoc.pdf

.PHONY: rtf
rtf: $(target)/$(book).adoc.xml.pandoc.rtf

.PHONY: clean
clean:
	rm -f \
		$(target)/*.epub \
		$(target)/*.html \
		$(target)/*.odt \
		$(target)/*.pdf \
		$(target)/*.rtf \
		$(target)/*.xml

# ==============================================================
# Convert to DocBook

$(target)/$(book).adoc.xml: $(book).adoc
	adoc --backend=docbook5 --out-file=$@ $<

# ==============================================================
# Convert to EPUB

# NB: Pandoc does not allow alternative templates. The default templates must
# be modified or redirected instead. They are the following:
# 
# /usr/share/pandoc-1.9.4.2/templates/epub-coverimage.html
# /usr/share/pandoc-1.9.4.2/templates/epub-page.html
# /usr/share/pandoc-1.9.4.2/templates/epub-titlepage.html

$(target)/$(book).adoc.xml.pandoc.epub: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=epub \
		--output=$@ \
		$<

# ==============================================================
# Convert to HTML

$(target)/$(book).adoc.plain.html: $(book).adoc
	adoc \
		--attribute="stylesheet=none" \
		--quiet \
		--out-file=$@ \
		$<

$(target)/$(book).adoc.html: $(book).adoc
	adoc --out-file=$@ $<

$(target)/$(book).adoc.xml.pandoc.html: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=html \
		--output=$@ \
		$<

# ==============================================================
# Convert to ODT

# XXX FIXME -- The images can not be found, unless the <pic> directory is the
# root of the project.

$(target)/$(book).adoc.xml.pandoc.odt: $(target)/$(book).adoc.xml
	pandoc \
		+RTS -K15000000 -RTS \
		--from=docbook \
		--to=odt \
		--output=$@ \
		$<

# ==============================================================
# Convert to PDF

# XXX FIXME -- Problem:
#
# asciidoctor: WARNING: GIF image format not supported. Install the
# prawn-gmagick gem or convert g18s029.gif to PNG.

$(target)/$(book).adoc.pdf: $(book).adoc
	asciidoctor-pdf --out-file=$@ $<

# ==============================================================
# Convert to RTF

# XXX FIXME -- Both LibreOffice Writer and AbiWord don't read this RTF file
# properly. The RTF marks are exposed. It seems they don't recognize the format
# and take it as a plain file.

$(target)/$(book).adoc.xml.pandoc.rtf: $(target)/$(book).adoc.xml
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
# directory used for the Asciidoctor sources. Make the book name configurable.
# These changes are needed in order to add more documents to the project. Also,
# adapt in order to include images in the documents.
#
# 2018-11-22: Adapt to the new name of the project.
