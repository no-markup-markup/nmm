# nmm-ocaml

An implementation of [the no-markup-markup markup language](https://github.com/no-markup-markup/nmm) in OCaml. Primarily for parsing nmm source-code and compiling it to raw text and HTML. Can also parse, produce and validate an XML-representation of parsed nmm source-code (in the format specified by [axml.dtd](https://ericjohannesson.github.io/nmm-ocaml/specs/axml.dtd.txt)), and an XML-representation of a compiled nmm-document with resolved cross-references and labels (in the format specified by [exml.dtd](https://ericjohannesson.github.io/nmm-ocaml/specs/exml.dtd.txt)), respectively.

The nmm-parser is generated with [Sedlex](https://github.com/ocaml-community/sedlex) and [ocamlyacc](https://ocaml.org/manual/5.4/lexyacc.html), and the XML-validation relies on [Xml-light](https://github.com/ncannasse/xml-light).

## Command-line interface

```
USAGE:
nmm-ocaml [
  | txt-of-nmm   [ <txt-options>  ] { <path-to-nmm-file>  | - }
  | html-of-nmm  [ <html-options> ] { <path-to-nmm-file>  | - }
  | exml-of-nmm  [ <exml-options> ] { <path-to-nmm-file>  | - }

  | axml-of-nmm  [ <axml-options> ] { <path-to-nmm-file>  | - }

  | txt-of-axml  [ <txt-options>  ] { <path-to-axml-file> | - }
  | html-of-axml [ <html-options> ] { <path-to-axml-file> | - }
  | exml-of-axml [ <exml-options> ] { <path-to-axml-file> | - }

  | check-xml-schema <path-to-dtd-file>
  | validate-xml <path-to-dtd-file> { <path-to-xml-file> | - }
  | show-default-css
  | normalize-axml { <path-to-axml-file> | - }
]

In cases where '-' can be given instead of a path, the program
reads from standard input.

TXT-OPTIONS:
  --margin <numeral>
  --width <numeral>
  --quiet
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --tags <path-to-tsv-file>

HTML-OPTIONS:
  --margin <numeral>
  --lang <language-code>
  --internal-css <path-to-css-file>
  --external-css <uri>
  --quiet
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --tags <path-to-tsv-file>

EXML-OPTIONS:
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --quiet
  --tags <path-to-tsv-file>

AXML-OPTIONS:
  --tags <path-to-tsv-file>
```

## Installation

For installing the opam package manager, see https://opam.ocaml.org/

For installing nmm-ocaml as a local opam package, clone this repository and run the following command in its root directory:
```bash
opam install .
```

This will also build an executable file at `~/.opam/default/bin/nmm-ocaml` which implements the command-line interface.

For only building the executable, run
```bash
make bin/nmm-ocaml
```

## Documentation

Documentation for the opam package can be found at https://ericjohannesson.github.io/nmm-ocaml
