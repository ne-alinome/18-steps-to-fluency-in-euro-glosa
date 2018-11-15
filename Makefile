# Makefile of _Plu Glosa Dokumenta_

# By Marcos Cruz (programandala.net)

# 2018-11-15: Start.

.PHONY: all
all: html

.PHONY: html
html: g18s_no_style.html g18s.html

g18s_no_style.html: g18s.adoc
	adoc \
		--attribute="stylesheet=none" \
		--quiet \
		--out-file=g18s_no_style.html \
		$<

g18s.html: g18s.adoc
	adoc $<
