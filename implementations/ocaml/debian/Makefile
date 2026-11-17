SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean

default: packages

export maintainer = Eric Johannesson <eric@ericjohannesson.com>
export homepage = https://github.com/ericjohannesson/nmm-ocaml

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX

packages: nmm-ocaml/packages
	mkdir -p packages
	mv nmm-ocaml/packages/*.deb packages/

nmm-ocaml/packages: \
		 nmm-ocaml \
		../bin/nmm-ocaml \
		../share
	cd nmm-ocaml
	make
	cd -

