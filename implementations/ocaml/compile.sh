# requires (at least) the following opam-packages: uuseg, xml-light

src=src
dest=compilation

if [ -d $dest ]
then 
	rm -r $dest
fi
mkdir $dest

cp $src/* $dest
cd $dest

ocamllex xml_right_lexer.mll						# generates xml_right_lexer.ml
ocamlyacc -v xml_right_parser.mly					# generates xml_right_parser.ml xml_right_parser.mli
ocamlfind ocamlc -c -package xml-light xml_right_parser.mli		# generates xml_right_parser.cmi

ocamlfind ocamlopt -o nmm-ocaml -linkpkg -package uuseg -package xml-light xml_right_lexer.ml xml_right_parser.ml xml_right.ml doc_types.ml cref_utils.ml txt_utils.ml exml_utils.ml compiler_of_doc.ml axml_of_doc.ml doc_of_axml.ml html_of_exml.ml main.ml		# generates executable nmm-ocaml

