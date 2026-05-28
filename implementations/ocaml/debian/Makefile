SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean

default:
	make packages

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX



packages: nmm-ocaml/packages nmm-ocaml-extras/packages
	mkdir -p packages
	mv nmm-ocaml/packages/*.deb packages/
	mv nmm-ocaml-extras/packages/*.deb packages/

nmm-ocaml/packages: nmm-ocaml ../bin/nmm-ocaml ../scripts/nmm-ocaml-bash-completion.sh
	cd nmm-ocaml
	make
	cd -

nmm-ocaml-extras/packages: nmm-ocaml-extras ../bin/txt-of-nmm ../bin/html-of-nmm ../bin/pdf-of-nmm ../scripts/nmm-ocaml-bash-completion.sh
	cd nmm-ocaml-extras
	make
	cd -


