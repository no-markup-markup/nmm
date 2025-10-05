SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -O globstar -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: default clean test

default:
	@echo 'no default target'

clean:
	# remove anything in .gitignore, including directories
	git clean -fdX

test:
	@echo 'TODO'

bin/nmm-ocaml: src/*
	mkdir -p compilation-artifacts
	cp -f src/* compilation-artifacts/
	cd compilation-artifacts
	# generate xml_right_lexer.ml
	ocamllex xml_right_lexer.mll
	# generate xml_right_parser.ml xml_right_parser.mli
	ocamlyacc -v xml_right_parser.mly
	# generates xml_right_parser.cmi
	ocamlfind ocamlc -c -package xml-light xml_right_parser.mli
	# generate executable nmm-ocaml
	ocamlfind ocamlopt -o nmm-ocaml -linkpkg -package uuseg -package xml-light xml_right_lexer.ml xml_right_parser.ml xml_right.ml doc_types.ml cref_utils.ml txt_utils.ml exml_utils.ml compiler_of_doc.ml axml_of_doc.ml doc_of_axml.ml html_of_exml.ml main.ml
	mv nmm-ocaml ../bin/
	cd -
