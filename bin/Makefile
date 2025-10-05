SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean all-binaries nmm-mercury nmm-ocaml

default: all-binaries

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX

all-binaries: nmm-mercury nmm-ocaml

nmm-mercury:
	cd ../implementations/mercury
	make nmm.cli
	cd -
	cp ../implementations/mercury/nmm.cli nmm-mercury

nmm-ocaml:
	cd ../implementations/ocaml
	make bin/nmm-ocaml
	cd -
	cp ../implementations/ocaml/bin/nmm-ocaml .
