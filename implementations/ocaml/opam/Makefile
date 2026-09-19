SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default update

default: package

description = An OCaml implementation of the no-markup-markup markup language
nmm_ocaml_version = $(shell ../bin/nmm-ocaml version)
opam_version = 2.0

define META
version = \"${nmm_ocaml_version}\"
description = \"${description}\"
requires = \"sedlex uuseg xml-light str unix\"
archive(byte) = \"nmm_ocaml.cma\"
archive(native) = \"nmm_ocaml.cmxa\"
plugin(byte) = \"nmm_ocaml.cma\"
plugin(native) = \"nmm_ocaml.cmxs\"
endef

define opam
opam-version: \"${opam_version}\"
name: \"nmm-ocaml\"
version: \"${nmm_ocaml_version}\"
maintainer: \"Eric Johannesson <eric@ericjohannesson.com>\"
authors: \"Eric Johannesson <eric@ericjohannesson.com>\"
synopsis: \"${description}\"
license: \"GPL-3.0-or-later\"
homepage: \"https://github.com/ericjohannesson/nmm-ocaml\"
dev-repo: \"git+https://github.com/ericjohannesson/nmm-ocaml.git\"
bug-reports: \"https://github.com/ericjohannesson/nmm-ocaml/issues\"
depends : [
    \"ocaml\" {>= \"4.14.0\"}
    \"sedlex\"
    \"uuseg\"
    \"xml-light\"
    \"ocamlfind\" { build }
]
build: [ make \"opam/package\" ]
install: [ make \"install-opam_package\" ]
endef

update: ../bin/nmm-ocaml
	echo "${opam}" > nmm-ocaml.opam

package/META:
	mkdir -p package
	echo "${META}" > package/META

package/opam: update
	mkdir -p package
	cp nmm-ocaml.opam package/opam

package: package/META package/opam ../byte ../native
	cp ../byte/nmm_ocaml.cma package/
	cp ../native/nmm_ocaml.* package/

