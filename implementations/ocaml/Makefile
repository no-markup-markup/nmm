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
	ocamlfind ocamlopt -o nmm-ocaml -linkpkg -package menhirLib -package sedlex.ppx -package uuseg -package xml-light -package str debug_utils.ml xml_right_parser.ml xml_right_lexer.ml xml_right.ml nmm_lexer.ml nmm_parser.ml doc_of_nmm.ml cref_utils.ml txt_utils.ml exml_utils.ml special_par_tags.ml par_hdr_mod.ml compiler_of_doc.ml axml_of_doc.ml doc_of_axml.ml html_of_exml.ml test.ml css_utils.ml main.ml
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

utop: compilation_for_utop
	cd compilation_for_utop
	utop -require menhirLib -require sedlex.ppx -require uuseg -require xml-light -require str debug_utils.cmo xml_right_lexer.cmo xml_right_parser.cmo xml_right.cmo doc_types.cmo nmm_lexer.cmo nmm_parser.cmo doc_of_nmm.cmo cref_utils.cmo txt_utils.cmo exml_utils.cmo special_par_tags.cmo par_hdr_mod.cmo compiler_of_doc.cmo axml_of_doc.cmo html_of_exml.cmo doc_of_axml.cmo test.cmo css_utils.cmo main.cmo

compilation_for_utop: src
	mkdir -p compilation_for_utop
	cp -f src/* compilation_for_utop/
	cd compilation_for_utop
	ocamlc -c doc_types.ml
	menhir --infer --dump --explain nmm_parser.mly
	ocamlc -c doc_types.cmo nmm_parser.mli
	ocamllex xml_right_lexer.mll
	ocamlyacc xml_right_parser.mly
	ocamlfind ocamlc -c -package xml-light xml_right_parser.mli
	ocamlfind ocamlc -c -package menhirLib -package sedlex.ppx -package uuseg -package xml-light -package str debug_utils.ml xml_right_parser.ml xml_right_lexer.ml xml_right.ml  nmm_parser.ml nmm_lexer.ml doc_of_nmm.ml cref_utils.ml txt_utils.ml exml_utils.ml special_par_tags.ml par_hdr_mod.ml compiler_of_doc.ml axml_of_doc.ml doc_of_axml.ml html_of_exml.ml test.ml css_utils.ml main.ml
	cd -


