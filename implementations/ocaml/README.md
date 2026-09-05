# nmm-ocaml

An implementation of [the no-markup-markup markup language](https://github.com/no-markup-markup/nmm) in OCaml.
Primarily for parsing nmm source-code and compiling it to raw text and HTML.
Can also parse, produce and validate an XML-representation of parsed nmm source-code
(in the format specified by [axml.dtd](https://ericjohannesson.github.io/nmm-ocaml/specs/axml.dtd.txt)),
and an XML-representation of a compiled nmm-document with resolved cross-references and labels
(in the format specified by [exml.dtd](https://ericjohannesson.github.io/nmm-ocaml/specs/exml.dtd.txt)),
respectively.

The nmm-parser is generated with [Sedlex](https://github.com/ocaml-community/sedlex)
and [ocamlyacc](https://ocaml.org/manual/5.4/lexyacc.html),
and the XML-validation relies on [Xml-light](https://github.com/ncannasse/xml-light).

## Command-line interface

```
nmm-ocaml [
  | txt-of-nmm   [ TXT-OPTIONS  ] { PATH-TO-NMM-FILE  | - }
  | html-of-nmm  [ HTML-OPTIONS ] { PATH-TO-NMM-FILE  | - }
  | exml-of-nmm  [ EXML-OPTIONS ] { PATH-TO-NMM-FILE  | - }
  | axml-of-nmm  [ AXML-OPTIONS ] { PATH-TO-NMM-FILE  | - }
  | txt-of-axml  [ TXT-OPTIONS  ] { PATH-TO-AXML-FILE | - }
  | html-of-axml [ HTML-OPTIONS ] { PATH-TO-AXML-FILE | - }
  | exml-of-axml [ EXML-OPTIONS ] { PATH-TO-AXML-FILE | - }
  | check-xml-schema PATH-TO-DTD-FILE
  | validate-xml PATH-TO-DTD-FILE { PATH-TO-XML-FILE | - }
  | normalize-axml { PATH-TO-AXML-FILE | - }
  | show-axml-schema
  | show-exml-schema
  | version
  | help
]

In cases where '-' may be provided instead of a path, the program
reads from standard input.

TXT-OPTIONS:
  --tags PATH-TO-TSV-FILE
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --quiet
  --margin NON-NEGATIVE-INTEGER
  --indent NON-NEGATIVE-INTEGER
  --width NON-NEGATIVE-INTEGER

HTML-OPTIONS:
  --tags PATH-TO-TSV-FILE
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --quiet
  --margin NON-NEGATIVE-INTEGER
  --indent NON-NEGATIVE-INTEGER
  --lang ISO-LANGUAGE-CODE
  --internal-css PATH-TO-CSS-FILE
  --external-css URI

EXML-OPTIONS:
  --tags PATH-TO-TSV-FILE
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --quiet

AXML-OPTIONS:
  --tags PATH-TO-TSV-FILE
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
