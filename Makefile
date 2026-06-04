SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean test test-nmm2xml test-nmm2txt bin

default:
	@echo 'no default target'

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX
	cd implementations
	make clean
	cd -
	cd bin
	make clean
	cd -

readme:
	cd readme-template
	make
	cd -

test: test-nmm2xml test-nmm2txt
	cd implementations
	make test
	cd -

bin:
	cd bin
	make
	cd -

test-nmm2xml: bin test-data-nmm2xml
	./test-nmm2xml.sh

test-nmm2txt: bin test-data-nmm2txt
	./test-nmm2txt.sh

share: share/bash-completion/completions/nmm-ocaml

share/bash-completion/completions/nmm-ocaml: implementations/ocaml/bin/nmm-ocaml-bash-completion.sh
	mkdir -p share/bash-completion/completions
	cp implementations/ocaml/bin/nmm-ocaml-bash-completion.sh share/bash-completion/completions/nmm-ocaml
