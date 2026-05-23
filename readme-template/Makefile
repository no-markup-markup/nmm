SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: clean

README.md:                       \
  ../bin/nmm-mercury             \
  ../bin/nmm-ocaml               \
  ../bin/*                       \
  template.md                    \
  nmm-sources/*.nmm              \
  raw-text-semantics/*.txt       \
  ../implementations/mercury/*.m \
  ../implementations/ocaml/src/*
	#
	./generate-raw-text.sh
	./generate-readme > README.md

../bin/nmm-mercury:
	cd ..
	make bin
	cd -

../bin/nmm-ocaml:
	cd ..
	make bin
	cd -


clean:
	# remove anything in .gitignore, including directories
	git clean -fdX
