SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean

default: packages

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX

package = nmm-ocaml
release = 1
architecture = amd64
maintainer = Eric Johannesson <eric@ericjohannesson.com>
homepage = https://github.com/ericjohannesson/nmm-ocaml
description = An implementation of no-markup-markup in OCaml
depends = libc6

directory = ${package}_${version}-${release}_${architecture}

define control
Package: ${package}
Version: ${version}
Maintainer: ${maintainer}
Depends: ${depends}
Architecture: ${architecture}
Homepage: ${homepage}
Description: ${description}
endef

${directory}/DEBIAN/control:
	mkdir -p ${directory}/DEBIAN
	echo "${control}" > ${directory}/DEBIAN/control

${directory}/usr/bin/nmm-ocaml: ../../bin/nmm-ocaml
	mkdir -p ${directory}/usr/bin
	cp ../../bin/nmm-ocaml ${directory}/usr/bin/

${directory}/usr/share/bash-completion/completions/nmm-ocaml: ../../scripts/nmm-ocaml-bash-completion.sh
	mkdir -p ${directory}/usr/share/bash-completion/completions
	cp ../../scripts/nmm-ocaml-bash-completion.sh ${directory}/usr/share/bash-completion/completions/nmm-ocaml

${directory}: ${directory}/DEBIAN/control ${directory}/usr/bin/nmm-ocaml ${directory}/usr/share/bash-completion/completions/nmm-ocaml

packages: ${directory}
	dpkg-deb --root-owner-group --build ${directory}
	mkdir -p packages
	mv *.deb packages/
