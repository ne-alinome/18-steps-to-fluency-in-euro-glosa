# Makefile of _18 Steps to Fluency in Euro-Glosa_

# By Marcos Cruz (programandala.net)

# Last modified 201902211712
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

VPATH=./src:./target

book=18_steps_to_fluency_in_euro-glosa
title="18 Steps to Fluency in Euro-Glosa"
lang="en"
editor="Marcos Cruz (programandala.net)"
publisher="ne.alinome"
description="Text book on the Glosa language"

# ==============================================================
# Interface

.PHONY: all
all: epub pdf

.PHONY: docbook
docbook: \
	images \
	target/$(book).adoc.xml

.PHONY: epub
epub: epubp

.PHONY: epubd
epubd: \
	images \
	target/$(book).adoc.xml.dbtoepub.epub

.PHONY: epubp
epubp: \
	images \
	target/$(book).adoc.xml.pandoc.epub

.PHONY: picdir
picdir:
	ln --force --symbolic --target-directory=target ../src/pic

.PHONY: html
html: \
	picdir \
	images \
	target/$(book).adoc.html \
	target/$(book).adoc.plain.html \
	target/$(book).adoc.xml.pandoc.html

.PHONY: odt
odt: \
	images \
	target/$(book).adoc.xml.pandoc.odt

.PHONY: pdf
pdf: pdfa4 pdfletter

.PHONY: pdfa4
pdfa4: \
	images \
	target/$(book).adoc.a4.pdf

.PHONY: pdfletter
pdfletter: \
	images \
	target/$(book).adoc.letter.pdf

.PHONY: rtf
rtf: \
	images \
	target/$(book).adoc.xml.pandoc.rtf

.PHONY: clean
clean:
	rm -f \
		target/*.epub \
		target/*.html \
		target/*.odt \
		target/*.pdf \
		target/*.rtf \
		target/*.xml

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
# Convert Asciidoctor to DocBook

target/$(book).adoc.xml: $(book).adoc
	adoc --backend=docbook5 --out-file=$@ $<

# ==============================================================
# Convert DocBook to EPUB

# ------------------------------------------------
# With dbtoepub

target/$(book).adoc.xml.dbtoepub.epub: \
	target/$(book).adoc.xml \
	src/$(book)-docinfo.xml \
	src/dbtoepub_stylesheet.css
	dbtoepub \
		--css src/dbtoepub_stylesheet.css \
		--output $@ $<

# ------------------------------------------------
# With pandoc

target/$(book).adoc.xml.pandoc.epub: \
	target/$(book).adoc.xml \
	src/$(book)-docinfo.xml \
	src/pandoc_epub_template.txt \
	src/pandoc_epub_stylesheet.css
	pandoc \
		--from=docbook \
		--to=epub3 \
		--template=src/pandoc_epub_template.txt \
		--css=src/pandoc_epub_stylesheet.css \
		--variable=lang:$(lang) \
		--variable=editor:$(editor) \
		--variable=publisher:$(publisher) \
		--variable=description:$(description) \
		--output=$@ \
		$<

# ==============================================================
# Convert Asciidoctor to HTML

# ------------------------------------------------
# With Asciidoctor

target/$(book).adoc.plain.html: $(book).adoc
	adoc \
		--attribute="stylesheet=none" \
		--quiet \
		--out-file=$@ \
		$<

target/$(book).adoc.html: $(book).adoc
	adoc --out-file=$@ $<

# ------------------------------------------------
# With pandoc

target/$(book).adoc.xml.pandoc.html: target/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=html \
		--output=$@ \
		$<

# ==============================================================
# Convert DocBook to ODT

# XXX WARNING -- Some images don't fit the page. They have to be resized
# manually.

target/$(book).adoc.xml.pandoc.odt: target/$(book).adoc.xml
	pandoc \
		+RTS -K15000000 -RTS \
		--from=docbook \
		--to=odt \
		--template=src/pandoc_odt_template.txt \
		--output=$@ \
		$<

# ==============================================================
# Convert Asciidoctor to PDF

# XXX REMARK --
# asciidoctor: WARNING: GIF image format not supported. Install the
# prawn-gmagick gem or convert g18s029.gif to PNG.

target/$(book).adoc.a4.pdf: $(book).adoc images
	asciidoctor-pdf \
		--out-file=$@ $<

target/$(book).adoc.letter.pdf: $(book).adoc images
	asciidoctor-pdf \
		--attribute pdf-page-size=letter \
		--out-file=$@ $<

# ==============================================================
# Convert to RTF

# XXX WARNING -- Tables are not properly converted: the contents of the row are
# displayed below their row.

target/$(book).adoc.xml.pandoc.rtf: target/$(book).adoc.xml
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
# 2019-02-21: Improve handling of images: Use the PNGs directly. Create also a
# letter size version of the PDF. Create an additional EPUB with dbtoepub.
# Update pandoc parameters to version 2.6. Improve metadata. Add templates and
# styles. Remove <pic> link from the ODT rule: somehow it's not needed anymore
# (maybe because of the updated pandoc).
