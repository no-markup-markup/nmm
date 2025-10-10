.ONESHELL:

bin/nmm-ocaml: src
	mkdir -p compilation-artifacts
	cp -f src/* compilation-artifacts/
	cd compilation-artifacts
	# generate doc_types.cmo, doc_types.cmi:
	ocamlc -c doc_types.ml
	# generate nmm_parser.ml, nmm_parser.mli:
	menhir --infer --explain --dump nmm_parser.mly
	# generate nmm_parser.cmo, nmm_parser.cmi:
	ocamlc -c doc_types.cmo nmm_parser.mli
	# generate xml_right_lexer.ml:
	ocamllex xml_right_lexer.mll
	# generate xml_right_parser.ml, xml_right_parser.mli:
	ocamlyacc xml_right_parser.mly
	# generates xml_right_parser.cmo, xml_right_parser.cmi:
	ocamlfind ocamlc -c -package xml-light xml_right_parser.mli
	# generate executable nmm-ocaml:
	ocamlfind ocamlopt -o nmm-ocaml -linkpkg -package menhirLib -package sedlex.ppx -package uuseg -package xml-light -package str debug_utils.ml xml_right_parser.ml xml_right_lexer.ml xml_right.ml nmm_lexer.ml nmm_parser.ml doc_of_nmm.ml cref_utils.ml txt_utils.ml exml_utils.ml par_hdr_mod.ml compiler_of_doc.ml axml_of_doc.ml doc_of_axml.ml html_utils.ml test.ml main.ml
	mv nmm-ocaml ../bin/
	cd -

clean:
	rm -r compilation*
	rm bin/nmm-ocaml
	rm -r testing/output

test:
	cd testing
	make
	cd -

nix-shell:
	nix-shell --pure -p ocaml ocamlPackages.findlib ocamlPackages.menhir ocamlPackages.menhirLib ocamlPackages.sedlex ocamlPackages.uuseg ocamlPackages.xml-light


