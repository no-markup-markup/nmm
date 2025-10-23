(** For parsing XML-files containing parsed nmm source-code (abstract syntax trees in the format specified by {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/dtd/axml.dtd}axml.dtd}), and for printing compiled nmm-documents in XML- or HTML-format to file. *)

exception Error of string

val parse_file : bool -> string -> Xml.xml
(** 
{[parse_file true "path/to/file"]} reads from path/to/file (if such a file exists), prints read tokens to [stderr], and returns (if succesful) an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml].

Raises ["cannot read from path/to/file: No such file"] if no file exists, and ["parsing failed"] on parsing failure. 

---

{[parse_file false "path/to/file"]} reads from path/to/file (if such a file exists), and returns (if succesful) an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml]. 

Raises ["cannot read from path/to/file: No such file"] if no file exists, and evaluates to [parse_file true "path/to/file"] on parsing failure.
*)

val parse_string : bool -> string -> Xml.xml
(**
Same as [parse_file], except that it reads from the provided string.
*)

val parse_stdin : bool -> Xml.xml
(**
Same as [parse_file], except that it reads from [stdin].
*)

val to_string : Xml.xml -> string
(**
{[to_string xml]}
evaluates to a string containing an xml-document representing [xml], with no white-space between elements.
*)

val to_string_fmt : Xml.xml -> string
(**
{[to_string_fmt xml]}
evaluates to a string containing an xml-document representing [xml], with elements separated by newlines.
*)


(**
Ideally, if [xml] is an object of type [Xml.xml], both 
{[parse_string (to_string xml)]}
and
{[parse_string (to_string_fmt xml)]}
should evaluate to [xml].
*)
