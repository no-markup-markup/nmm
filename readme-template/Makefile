SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: clean

README.md: template.md nmm-sources/*.nmm raw-text-semantics/*.txt ../bin/* ../implementations/mercury/*.m ../implementations/ocaml/src/*
	cd ..
	make bin
	cd -
	./generate-raw-text.sh
	./generate-readme > README.md

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX
