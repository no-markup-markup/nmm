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
USAGE:
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

## Install pre-built binary on debian-based linux with apt

Pre-built binaries for amd64 and arm64 are available at the following repository: https://ericjohannesson.github.io/apt-repo/

Add the repository, and run
```bash
sudo apt install nmm-ocaml
```


## Build and install from source

Clone this repository. In the root directory of the clone, you can either proceed with opam or nix:

### with opam

To install the opam package manager, see https://opam.ocaml.org/

(On debian-based linux with apt, it is sufficient to run `sudo apt install opam`, although you probably will not get the latest version)

To install the opam-dependencies, run
```bash
opam install ocaml ocamlfind sedlex uuseg xml-light
```

To build the executable that implements the command line interface, run
```bash
make bin/nmm-ocaml
```

Alternatively, to install nmm-ocaml as a local opam package, simply run
```bash
opam install .
```
This will automatically install the opam-dependencies, and build the executable at `~/.opam/<your-opam-switch>/bin/nmm-ocaml`.

### with nix

To install the standard nix package manager, see https://nixos.org/

To open a nix-shell with the required packages, run
```bash
nix-shell
```
In that shell, to build the executable, run
```bash
make bin/nmm-ocaml
```

On standard nix (without nix-commands), to build and add the executable to your nix profile, run
```bash
nix-env --install --file default.nix
```
To do the same on experimental nix (with nix-commands), run
```bash
nix profile add --file default.nix
```

## Documentation

Documentation for the opam package can be found at https://ericjohannesson.github.io/nmm-ocaml
