(** For parsing XML-files containing parsed nmm source-code (abstract syntax trees in the format specified by {{:specs/axml.dtd.txt}axml.dtd}), and for printing compiled nmm-documents in XML- or HTML-format to file. *)

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
evaluates to a string containing an xml-document representing [xml], with elements separated by line feeds.
*)


(**
Ideally, if [xml] is an object of type [Xml.xml], all of 
{[
parse_string true (to_string xml)
parse_string false (to_string xml)
parse_string true (to_string_fmt xml)
parse_string false (to_string_fmt xml)
]}
should evaluate to [xml].
*)


(** For debugging purposes: *)

val diff_of_xmls : Xml.xml -> Xml.xml -> (Xml.xml option * Xml.xml option) list

val xml_diff : Xml.xml -> Xml.xml -> string

val xml_diff_of_files : string -> string -> string
