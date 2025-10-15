# nmm-ocaml
Primarily for parsing an XML-representation of a no-markup-markup document, for validating it against an XML-schema, and for compiling it to raw text and HTML. Written in OCaml.

The XML-parser is generated with [ocamllex and ocamlyacc](https://ocaml.org/manual/5.4/lexyacc.html), and the validation relies on [Xml-light](https://github.com/ncannasse/xml-light).

It also includes an experimental LR(1) parser of no-markup-markup source code, generated with [Sedlex](https://github.com/ocaml-community/sedlex) and [Menhir](https://gallium.inria.fr/~fpottier/menhir/).
