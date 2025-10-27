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
	cd testing
	make
	cd -

bin/nmm-ocaml: src/*
	mkdir -p compilation-artifacts
	cp -f src/* compilation-artifacts/
	cd compilation-artifacts
	# generate doc_types.cmo, doc_types.cmi:
	ocamlc -c doc_types.ml
	# generate nmm_parser.ml, nmm_parser.mli:
	menhir --infer --explain --dump nmm_parser.mly
	# generate nmm_parser.cmo, nmm_parser.cmi:
	ocamlc -c doc_types.cmo nmm_parser.mli
	# generate xml_right_lexer.ml
	ocamllex xml_right_lexer.mll
	# generate xml_right_parser.ml xml_right_parser.mli
	ocamlyacc xml_right_parser.mly
	# generates xml_right_parser.cmo xml_right_parser.cmi:
	ocamlfind ocamlc -c -package xml-light xml_right_parser.mli
	# generate executable nmm-ocaml
	ocamlfind ocamlopt -o nmm-ocaml -linkpkg -package menhirLib -package sedlex.ppx -package uuseg -package xml-light -package str debug_utils.ml xml_right_parser.ml xml_right_lexer.ml xml_right.mli xml_right.ml nmm_lexer.ml nmm_parser.ml doc_of_nmm.mli doc_of_nmm.ml common_utils.mli common_utils.ml txt_utils.mli txt_utils.ml exml_utils.mli exml_utils.ml par_hdr_mod.ml compiler_of_doc.mli compiler_of_doc.ml axml_of_doc.mli axml_of_doc.ml doc_of_axml.mli doc_of_axml.ml html_utils.mli html_utils.ml test.ml main.mli main.ml
	mv nmm-ocaml ../bin/
	cd -

documentation: src/*
	make bin/nmm-ocaml
	cd compilation-artifacts
	mkdir -p documentation
	ocamlfind ocamldoc -colorize-code -d documentation -package menhirLib -package sedlex.ppx -package uuseg -package xml-light -package str -html doc_types.ml xml_right.mli xml_right.ml doc_of_nmm.mli doc_of_nmm.ml common_utils.mli common_utils.ml txt_utils.mli txt_utils.ml exml_utils.mli exml_utils.ml compiler_of_doc.mli compiler_of_doc.ml axml_of_doc.mli axml_of_doc.ml doc_of_axml.mli doc_of_axml.ml html_utils.mli html_utils.ml main.mli main.ml
	cd -
	if [ -d documentation ]
	then
		rm -r documentation
	fi
	mv compilation-artifacts/documentation documentation


utop: compilation_for_utop
	cd compilation_for_utop
	utop -require menhirLib -require sedlex.ppx -require uuseg -require xml-light -require str debug_utils.cmo xml_right_lexer.cmo xml_right_parser.cmo xml_right.cmo doc_types.cmo nmm_lexer.cmo nmm_parser.cmo doc_of_nmm.cmo common_utils.cmo txt_utils.cmo exml_utils.cmo par_hdr_mod.cmo compiler_of_doc.cmo axml_of_doc.cmo html_utils.cmo doc_of_axml.cmo test.cmo main.cmo

compilation_for_utop: src/*
	mkdir -p compilation_for_utop
	cp -f src/* compilation_for_utop/
	cd compilation_for_utop
	ocamlc -c doc_types.ml
	menhir --infer --dump --explain nmm_parser.mly
	ocamlc -c doc_types.cmo nmm_parser.mli
	ocamllex xml_right_lexer.mll
	ocamlyacc xml_right_parser.mly
	ocamlfind ocamlc -c -package xml-light xml_right_parser.mli
	ocamlfind ocamlc -linkpkg -package menhirLib -package sedlex.ppx -package uuseg -package xml-light -package str debug_utils.ml xml_right_parser.ml xml_right_lexer.ml xml_right.mli xml_right.ml  nmm_parser.ml nmm_lexer.ml doc_of_nmm.mli doc_of_nmm.ml common_utils.mli common_utils.ml txt_utils.mli txt_utils.ml exml_utils.mli exml_utils.ml par_hdr_mod.ml compiler_of_doc.mli compiler_of_doc.ml axml_of_doc.mli axml_of_doc.ml doc_of_axml.mli doc_of_axml.ml html_utils.mli html_utils.ml test.ml main.mli main.ml
	cd -

