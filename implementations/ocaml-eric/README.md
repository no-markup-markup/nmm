# nmm-ocaml

For parsing an xml-representation of an nmm-document and turning the result into a txt- or html-file. Written in OCaml.

## How to compile with nix-packages

In this folder, type

``bash nix-shell.sh``

In the created nix-shell, type

``bash compile.sh``

This will produce the folder ``compilation``, containing an exectuable ``nmm-ocaml``. 

## How to test the exectuable

In this foler, type

``bash test.sh``

This will produce a folder ``example_output`` containing the txt- and html-output of ``example_input``, plus a copy of ``css/html.css``.

It will also check that the xml-schema ``dtd/axml.dtd`` is well defined, and that every xml-file in ``example_output`` is valid with respect to it.

## How to use the exectuable

In this folder, type

``./compilation/nmm-ocaml``

This should print the following message:

```
usage:

  nmm-ocaml [

	txt-of-xml { <path-to-xml-file> | - } |

	html-of-xml <URI-of-css-file> [<language-code>] { <path-to-xml-file> | - } |

	validate-xml <path-to-dtd-file> <entry-point> { <path-to-xml-file> | - } |

	check-xml-schema <path-to-dtd-file> |

    ]
```
