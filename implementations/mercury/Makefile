SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean nmm.cli test

default:
	@echo 'no default target'

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX

nmm.cli:
	mmc --make --warn-inconsistent-pred-order-clauses --warn-dead-preds --warn-dead-procs --inform-ite-instead-of-switch nmm.cli

test: nmm.cli
	./nmm.cli test
