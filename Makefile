CURRENT ?= $(shell pwd)
BASEDIR ?= $(shell basename $(CURRENT))

REMOTEDIR ?= ~/.public_html/$(BASEDIR)
REMOTE ?= cr173@gort.stat.duke.edu:$(REMOTEDIR)

POST_RMD_FILES := $(wildcard _knitr/*.Rmd)
POST_HTML_FILES  := $(patsubst _knitr/%.Rmd, _posts/%.html, $(POST_RMD_FILES))
SLIDE_HTML_FILES := $(patsubst _knitr/%.Rmd, slides/%.html, $(POST_RMD_FILES))

HW_RMD_FILES := $(wildcard _homework/*.Rmd)
HW_HTML_FILES  := $(patsubst _homework/%.Rmd, hw/%.html, $(HW_RMD_FILES))


build: $(POST_HTML_FILES) $(SLIDE_HTML_FILES) $(HW_HTML_FILES)
	Rscript util/clean_posts.R
	jekyll build

.PHONY: clean
clean:
	rm -rf _site/*
	rm -f _posts/*.html
	rm -f slides/*.html
	rm -f hw/*.html

push: build
	@echo "Syncing to $(REMOTE)"
	@rsync -az _site/* $(REMOTE)

_posts/%.html: _knitr/%.Rmd
	@echo "Rendering post: $(@F)"
	@Rscript --vanilla util/render_post.R $< $@

slides/%.html: _knitr/%.Rmd
	@echo "Rendering slides: $(@F)"
	@touch $@
	@Rscript --vanilla util/render_slides.R $< $@

hw/%.html: _homework/%.Rmd
	@echo "Rendering hw: $(@F)"
	@Rscript --vanilla util/render_hw.R $< $@

serve: $(POST_HTML_FILES) $(SLIDE_HTML_FILES) $(HW_HTML_FILES)
	@open http://localhost:4000
	@jekyll serve --baseurl ''




