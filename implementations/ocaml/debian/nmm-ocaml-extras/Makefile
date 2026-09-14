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

package = nmm-ocaml-extras
version = 0
release = 0
architecture = all

directory = ${package}_${version}-${release}_${architecture}

description = Some convenient wrapper scripts for nmm-ocaml \
	(txt-of-nmm, html-of-nmm, pdf-of-nmm)

depends = nmm-ocaml, bash, sed, weasyprint


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

${directory}/usr/bin: \
	../../bin/txt-of-nmm \
	../../bin/html-of-nmm \
	../../bin/pdf-of-nmm
	mkdir -p ${directory}/usr/bin
	cp ../../bin/txt-of-nmm ${directory}/usr/bin/
	cp ../../bin/html-of-nmm ${directory}/usr/bin/
	cp ../../bin/pdf-of-nmm ${directory}/usr/bin/

${directory}/usr/share: ../../share
	mkdir -p ${directory}/usr/share/bash-completion/completions
	cp ../../share/bash-completion/completions/nmm-ocaml \
		${directory}/usr/share/bash-completion/completions/txt-of-nmm
	cp ../../share/bash-completion/completions/nmm-ocaml \
		${directory}/usr/share/bash-completion/completions/html-of-nmm
	cp ../../share/bash-completion/completions/nmm-ocaml \
		${directory}/usr/share/bash-completion/completions/pdf-of-nmm


${directory}: \
	${directory}/DEBIAN/control \
	${directory}/usr/bin \
	${directory}/usr/share

packages: ${directory}
	dpkg-deb --root-owner-group --build ${directory}
	mkdir -p packages
	mv *.deb packages/
