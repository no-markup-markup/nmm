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

test: bin/nmm-ocaml
	cd tests
	bash test.sh
	cd -

bin/nmm-ocaml: native
	cd native
	ocamlfind ocamlopt -o nmm-ocaml -linkpkg -package sedlex.ppx -package uuseg -package xml-light -package str -package unix nmm_ocaml.cmxa cli.ml
	cd -
	mv native/nmm-ocaml bin/


docs: byte
	cp docs/specs/axml.dtd docs/specs/axml.dtd.txt
	cp docs/specs/exml.dtd docs/specs/exml.dtd.txt
	cp src/xml_right_lexer.mll docs/specs/xml_right_lexer.mll.txt
	cp src/xml_right_parser.mly docs/specs/xml_right_parser.mly.txt
	cp src/nmm_parser.mly docs/specs/nmm_parser.mly.txt
	cd byte
	ocamlfind ocamldoc -t 'Nmm_ocaml' -keep-code -colorize-code -d ../docs -package sedlex.ppx -package uuseg -package xml-light -package str -package unix -html doc_types.ml xml_right_parser.mli xml_right_lexer.mli xml_right.mli xml_right.ml nmm_parser.mli nmm_lexer.mli nmm_lexer.ml doc_of_nmm.mli doc_of_nmm.ml common_utils.mli tags.mli tags.ml common_utils.ml txt_utils.mli txt_utils.ml exml_utils.mli exml_utils.ml compiler_of_doc.mli compiler_of_doc.ml axml_of_doc.mli axml_of_doc.ml doc_of_axml.mli doc_of_axml.ml html_utils.mli html_utils.ml main.mli main.ml
	cd -

clean-docs:
	rm -f docs/*.html
	rm -f docs/specs/*.txt

install-bin: bin/nmm-ocaml
	cp bin/nmm-ocaml ~/bin/
	cp bin/txt-of-nmm.sh ~/bin/txt-of-nmm
	chmod +x ~/bin/txt-of-nmm
	cp bin/html-of-nmm.sh ~/bin/html-of-nmm
	chmod +x ~/bin/html-of-nmm
	cp bin/pdf-of-nmm.sh ~/bin/pdf-of-nmm
	chmod +x ~/bin/pdf-of-nmm

install-opam_package: opam_package src/cli.ml
	ocamlfind install nmm-ocaml opam_package/*
	ocamlfind ocamlopt -o ~/.opam/default/bin/nmm-ocaml -linkpkg -package sedlex.ppx -package uuseg -package xml-light -package str -package unix -package nmm-ocaml src/cli.ml

opam_package: native opam byte
	mkdir -p opam_package
	cp byte/nmm_ocaml.cma opam_package/
	cp native/nmm_ocaml.* opam_package/
	cp opam/nmm-ocaml.opam opam_package/opam
	cp opam/META opam_package/

native: src
	mkdir -p native
	cp -f src/* native/
	cd native
	ocamlopt -c -for-pack Nmm_ocaml doc_types.ml IO.ml
	# generate nmm_parser.ml, nmm_parser.mli:
	ocamlyacc --strict nmm_parser.mly
	# replace generated mli-file:
	cp ../src/nmm_parser.mli nmm_parser.mli
	# generate nmm_parser.cmx, nmm_parser.cmxi:
	ocamlopt -c -for-pack Nmm_ocaml nmm_parser.mli
	# generate xml_right_lexer.ml, xml_right_lexer.mli
	ocamllex xml_right_lexer.mll
	# replace generated mli-file:
	cp ../src/xml_right_lexer.mli xml_right_lexer.mli
	# generate xml_right_parser.ml, xml_right_parser.mli
	ocamlyacc --strict xml_right_parser.mly
	# replace generated mli-file:
	cp ../src/xml_right_parser.mli xml_right_parser.mli
	# generate xml_right_parser.cmx, xml_right_parser.cmxi:
	ocamlfind ocamlopt -c -for-pack Nmm_ocaml -package xml-light xml_right_parser.mli
	# generate cmx-files: 
	ocamlfind ocamlopt -c -for-pack Nmm_ocaml -linkpkg -package sedlex.ppx -package uuseg -package xml-light -package str -package unix xml_right_parser.mli xml_right_parser.ml xml_right_lexer.mli xml_right_lexer.ml xml_right.mli xml_right.ml nmm_parser.mli nmm_parser.ml nmm_lexer.mli nmm_lexer.ml doc_of_nmm.mli doc_of_nmm.ml tags.mli tags.ml common_utils.mli common_utils.ml txt_utils.mli txt_utils.ml exml_utils.mli exml_utils.ml compiler_of_doc.mli compiler_of_doc.ml axml_of_doc.mli axml_of_doc.ml doc_of_axml.mli doc_of_axml.ml html_utils.mli html_utils.ml main.mli main.ml test.mli test.ml
	ocamlfind ocamlopt -pack -o nmm_ocaml.cmx -package sedlex.ppx -package uuseg -package xml-light -package str doc_types.cmx IO.cmx xml_right_parser.cmx xml_right_lexer.cmx xml_right.cmx nmm_parser.cmx nmm_lexer.cmx doc_of_nmm.cmx tags.cmx common_utils.cmx txt_utils.cmx exml_utils.cmx compiler_of_doc.cmx axml_of_doc.cmx doc_of_axml.cmx html_utils.cmx main.cmx test.cmx
	ocamlfind ocamlopt -a -o nmm_ocaml.cmxa nmm_ocaml.cmx
	ocamlopt -shared -o nmm_ocaml.cmxs nmm_ocaml.cmxa

byte: src
	mkdir -p byte
	cp -f src/* byte/
	cd byte
	# generate doc_types.cmo, doc_types.cmi:
	ocamlc -c -for-pack Nmm_ocaml doc_types.ml IO.ml
	# generate nmm_parser.ml, nmm_parser.mli:
	ocamlyacc --strict nmm_parser.mly
	# replace generated mli-file:
	cp ../src/nmm_parser.mli nmm_parser.mli
	# generate nmm_parser.cmo, nmm_parser.cmi:
	ocamlc -c -for-pack Nmm_ocaml nmm_parser.mli
	# generate xml_right_lexer.ml, xml_right_lexer.mli
	ocamllex xml_right_lexer.mll
	# replace generated mli-file:
	cp ../src/xml_right_lexer.mli xml_right_lexer.mli
	# generate xml_right_parser.ml, xml_right_parser.mli
	ocamlyacc --strict xml_right_parser.mly
	# replace generated mli-file:
	cp ../src/xml_right_parser.mli xml_right_parser.mli
	# generate xml_right_parser.cmo, xml_right_parser.cmi:
	ocamlfind ocamlc -c -for-pack Nmm_ocaml -package xml-light xml_right_parser.mli
	# generate cmo-files: 
	ocamlfind ocamlc -c -for-pack Nmm_ocaml -linkpkg -package sedlex.ppx -package uuseg -package xml-light -package str -package unix xml_right_parser.mli xml_right_parser.ml xml_right_lexer.mli xml_right_lexer.ml xml_right.mli xml_right.ml nmm_parser.mli nmm_parser.ml nmm_lexer.mli nmm_lexer.ml doc_of_nmm.mli doc_of_nmm.ml tags.mli tags.ml common_utils.mli common_utils.ml txt_utils.mli txt_utils.ml exml_utils.mli exml_utils.ml compiler_of_doc.mli compiler_of_doc.ml axml_of_doc.mli axml_of_doc.ml doc_of_axml.mli doc_of_axml.ml html_utils.mli html_utils.ml main.mli main.ml test.mli test.ml
	ocamlfind ocamlc -pack -o nmm_ocaml.cmo -package sedlex.ppx -package uuseg -package xml-light -package str doc_types.cmo IO.cmo xml_right_parser.cmo xml_right_lexer.cmo xml_right.cmo nmm_parser.cmo nmm_lexer.cmo doc_of_nmm.cmo tags.cmo common_utils.cmo txt_utils.cmo exml_utils.cmo compiler_of_doc.cmo axml_of_doc.cmo doc_of_axml.cmo html_utils.cmo main.cmo test.cmo
	ocamlc -a -o nmm_ocaml.cma nmm_ocaml.cmo
	cd -

utop: opam_package
	utop -require sedlex -require uuseg -require xml-light -require str -I $(realpath opam_package) $(realpath opam_package/nmm_ocaml.cma)

