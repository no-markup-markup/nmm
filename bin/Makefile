SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean nmm-mercury

default: nmm-mercury

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX

nmm-mercury:
	cd ../implementations/mercury
	make nmm.cli
	cd -
	cp ../implementations/mercury/nmm.cli nmm-mercury
