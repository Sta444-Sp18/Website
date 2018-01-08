CURRENT ?= $(shell pwd)
BASEDIR ?= $(shell basename $(CURRENT))

REMOTEDIR ?= ~/.public_html/$(BASEDIR)
REMOTE ?= cr173@gort.stat.duke.edu:$(REMOTEDIR)

SLIDE_RMD_FILES := $(wildcard static/slides/*.Rmd)
SLIDE_HTML_FILES  := $(subst Rmd,html,$(SLIDE_RMD_FILES))

HW_RMD_FILES := $(wildcard static/homework/*.Rmd)
HW_HTML_FILES  := $(subst Rmd,html, $(HW_RMD_FILES))

.PHONY: clean push

build: $(SLIDE_HTML_FILES) $(HW_HTML_FILES)
	hugo

clean:
	rm -rf _site/*
	rm -f _posts/*.html
	rm -f slides/*.html
	rm -f hw/*.html

push: build
	@echo "Syncing to $(REMOTE)"
	@rsync -az public/* $(REMOTE)

static/slides/%.html: static/slides/%.Rmd
	@echo "Rendering post: $(@F)"
	@Rscript -e "rmarkdown::render('$<')"

static/homework/%.html: static/homework/%.Rmd
	@echo "Rendering hw: $(@F)"
	@Rscript -e "rmarkdown::render('$<')"





