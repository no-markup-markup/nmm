SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: clean test

test: test.sh
	cd ..
	make bin/nmm-ocaml
	cd -
	./test.sh

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX
