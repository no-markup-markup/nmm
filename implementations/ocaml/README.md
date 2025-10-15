# nmm-ocaml
Primarily for parsing an XML-representation of a no-markup-markup document, for validating it against an XML-schema, and for compiling it to raw text and HTML. Written in OCaml.

The XML-parser is generated with [ocamllex and ocamlyacc](https://ocaml.org/manual/5.4/lexyacc.html), and the validation relies on [Xml-light](https://github.com/ncannasse/xml-light).

It also includes an experimental LR(1) parser of no-markup-markup source code, generated with [Sedlex](https://github.com/ocaml-community/sedlex) and [Menhir](https://gallium.inria.fr/~fpottier/menhir/).

## Usage
```
nmm-ocaml [

 | txt-of-xml { <path-to-xml-file> | - }
 | html-of-xml { <URI-of-css-file> | none } { [ <language-code> | none } { <path-to-xml-file> | - }

 | xml-of-nmm <path-to-nmm-file>

 | txt-of-nmm <path-to-nmm-file>
 | html-of-nmm { <URI-of-css-file> | none } { <language-code> | none } <path-to-nmm-file>

 | check-xml-schema <path-to-dtd-file>
 | validate-xml <path-to-dtd-file> <entry-point> { <path-to-xml-file> | - }

 | test <path-to-nmm-file>

]

In cases where '-' can be supplied instead of a path, the program reads from stdin.
```
