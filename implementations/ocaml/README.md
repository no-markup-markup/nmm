# nmm-ocaml
Primarily for parsing an XML-representation of parsed nmm source-code, for validating it against an XML-schema, and for compiling it to raw text and HTML with resolved cross-references and labels. Written in OCaml.

The XML-parser is generated with [ocamllex and ocamlyacc](https://ocaml.org/manual/5.4/lexyacc.html), and the validation relies on [Xml-light](https://github.com/ncannasse/xml-light).

It also includes an experimental LR(1) parser of nmm source-code, generated with [Sedlex](https://github.com/ocaml-community/sedlex) and ocamlyacc.

## Command-line interface
```
USAGE:
nmm-ocaml [
  | txt-of-xml [ <txt-options> ] { <path-to-xml-file> | - }
  | html-of-xml [ <html-options> ] { <path-to-xml-file> | - }
  | xml-of-nmm { <path-to-nmm-file> | - }
  | txt-of-nmm [ <txt-options> ] { <path-to-nmm-file> | - }
  | html-of-nmm [ <html-options> ] { <path-to-nmm-file> | - }
  | check-xml-schema <path-to-dtd-file>
  | validate-xml <path-to-dtd-file> { <path-to-xml-file> | - }
  | show-default-css
  | exml-of-nmm [ <exml-options> ] { <path-to-nmm-file> | - }
  | exml-of-axml [ <exml-options> ] { <path-to-axml-file> | - }
]

In cases where '-' can be given instead of a path, the program
reads from standard input.

TXT-OPTIONS:
  --margin <numeral>
  --width <numeral>
  --quiet
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering

HTML-OPTIONS:
  --margin <numeral>
  --lang <language-code>
  --css <uri>
  --quiet
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering

EXML-OPTIONS:
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --quiet
```
