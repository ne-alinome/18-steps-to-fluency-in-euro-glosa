# Makefile of _18 Steps to Fluency in Euro-Glosa_

# By Marcos Cruz (programandala.net)

# Last modified 201902211545
# See change log at the end of the file

# ==============================================================
# Requirements

# - make
# - asciidoctor
# - asciidoctor-pdf
# - pandoc
# - ImageMagick

# ==============================================================
# Config

VPATH=./src:./$(target)

book=18_steps_to_fluency_in_euro-glosa

target=target

# ==============================================================
# Interface

.PHONY: all
all: epub

.PHONY: docbook
docbook: \
	images \
	$(target)/$(book).adoc.xml

.PHONY: epub
epub: \
	images \
	$(target)/$(book).adoc.xml.pandoc.epub

.PHONY: picdir
picdir:
	ln --force --symbolic --target-directory=$(target) ../src/pic

.PHONY: html
html: \
	picdir \
	images \
	$(target)/$(book).adoc.html \
	$(target)/$(book).adoc.plain.html \
	$(target)/$(book).adoc.xml.pandoc.html

.PHONY: odt
odt: \
	images \
	$(target)/$(book).adoc.xml.pandoc.odt

.PHONY: pdf
pdf: \
	images \
	$(target)/$(book).adoc.pdf

.PHONY: rtf
rtf: \
	images \
	$(target)/$(book).adoc.xml.pandoc.rtf

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
# Images 

# XXX REMARK -- Not used
target/pic/%.png: src/pic/%.gif
	convert $< $@

# XXX REMARK -- Not used
.PHONY: PNGs
PNGs:
	@for image in $(notdir $(basename $(wildcard src/pic/*.gif))); do \
		make target/pic/$$image.png; \
	done;

# XXX TODO --

src/pic/1.png: src/1.txt
	gm convert \
		-page 80x180 \
		-background white -fill black \
		-border 0 \
		-pointsize 170 \
		-font Courier \
		text:$< \
		$@

.PHONY: digits
digits: src/pic/1.png

.PHONY: images
images: digits

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

# XXX FIXME -- The images can not be found, unless the <pic> directory is in
# the root of the project. A symbolic link is created by the recipe and deleted
# at the end.

# XXX WARNING -- Some images don't fit the page. They have to be resized
# manually.

$(target)/$(book).adoc.xml.pandoc.odt: $(target)/$(book).adoc.xml
	ln -sf target/pic pic
	pandoc \
		+RTS -K15000000 -RTS \
		--from=docbook \
		--to=odt \
		--output=$@ \
		$<
	rm -f pic

# ==============================================================
# Convert to PDF

# XXX REMARK --
#
# asciidoctor: WARNING: GIF image format not supported. Install the
# prawn-gmagick gem or convert g18s029.gif to PNG.

$(target)/$(book).adoc.pdf: $(book).adoc images
	asciidoctor-pdf --out-file=$@ $<

# ==============================================================
# Convert to RTF

# XXX WARNING -- Tables are not properly converted: the contents of the row are
# displayed below their row.

$(target)/$(book).adoc.xml.pandoc.rtf: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=rtf \
		--standalone \
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
#
# 2018-12-05: Add conversion of the original GIF images, which asciidoctor-pdf
# does not support, into PNGs. Fix RTF output (`--standalone` was missing).
#
# 2019-02-21: Improve handling of images: Use the PNGs directly.
