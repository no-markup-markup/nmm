SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean test bin

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

test:
	cd implementations
	make test
	cd -

bin:
	cd bin
	make
	cd -
