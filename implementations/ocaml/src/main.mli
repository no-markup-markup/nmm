(** For assembling the pieces provided by the other modules. *)

exception Error of string


val doc_of_nmm : string -> Doc_types.tr_doc
(**
[doc_of_nmm "path/to/file"] evaluates to {!val:Doc_of_nmm.doc_of_nmm_file}[ false "path/to/file"].

[doc_of_nmm "-"] evaluates to {!val:Doc_of_nmm.doc_of_nmm_stdin}[ false].
*)

val txt_of_doc : Common_utils.t_txt_options -> Doc_types.tr_doc -> string
(**
[txt_of_doc doc] evaluates to {!val:Compiler_of_doc.txt_of_tr_doc}[ doc].
*)


val default_css : unit -> string
(**
[default_css ()] evaluates to {!val:Html_utils.internal_css}[ "6ch" "0"].
*)

val html_of_doc : Common_utils.t_html_options -> Doc_types.tr_doc -> string
(**
[html_of_doc options doc] evaluates to a string containing a html-document with an internal css stylesheet, specified by the value of

["<style>\n" ^ (]{!val:Html_utils.internal_css}[ default_tab_length margin_left) ^ "\n</style>"]

where [default_tab_length] is ["6ch"] and [margin_left] is a string determined by [options] and [doc].

The body of the html-document is specified by the value of

["<body>\n" ^ (]{!val:Html_utils.html_of_exml}[ (]{!val:Compiler_of_doc.exml_of_tr_doc}[ options doc)) ^ "\n</body>"].
*)

val doc_of_axml : string -> Doc_types.tr_doc
(**
[doc_of_axml "path/to/file"] evaluates to {!val:Doc_of_axml.f_tr_doc_of_axml}[ (]{!val:Xml_right.parse_file}[ false "path/to/file")].

[doc_of_axml "-"] evaluates to {!val:Doc_of_axml.f_tr_doc_of_axml}[ (]{!val:Xml_right.parse_stdin}[ false)].
*)
val axml_of_doc : Doc_types.tr_doc -> string
(**
[axml_of_doc doc] evaluates to a normalized XML-representation of [doc] that is an instance of {{:specs/axml.dtd.txt}axml.dtd}.
*)

val html_of_nmm : Common_utils.t_html_options -> string -> string
(**
[html_of_nmm options path] evaluates to [html_of_doc options (doc_of_nmm path)].
*)

val txt_of_nmm : Common_utils.t_txt_options -> string -> string
(**
[txt_of_nmm options path] evaluate to [txt_of_doc options (doc_of_nmm path)].
*)

val txt_of_axml : Common_utils.t_txt_options -> string -> string
(**
[txt_of_axml options path] evaluates to [txt_of_doc options (doc_of_axml path)].
*)

val html_of_axml : Common_utils.t_html_options -> string -> string
(**
[html_of_axml options path] evaluates to [html_of_doc options (doc_of_axml path)].
*)

val axml_of_nmm : string -> string
(**
[axml_of_nmm path] evaluates to [axml_of_doc (doc_of_nmm path)].
*)

val check_xml_schema : string -> string
(**
[check_xml_schema "path/to/xml-schema.dtd"] calls the {{:https://github.com/ncannasse/xml-light}Xml-light} function [Dtd.parse_file] for parsing path/to/xml-schema.dtd, and [Dtd.check] for checking that it is a well-defined xml-schema in the format dtd.
*)

val validate_xml : string -> string -> string
(**
[validate_xml "path/to/xml-schema.dtd" "path/to/xml-file.xml"] first calls the {{:https://github.com/ncannasse/xml-light}Xml-light} function [Dtd.parse_file] for parsing xml-schema.dtd, and [Dtd.check] for checking that it is well-defined. It then calls the function {!val:Xml_right.parse_file} for parsing xml-file.xml into an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml]. Lastly, it calls [Dtd.prove] for proving (or disproving) that xml-file.xml is an instance of xml-schema.dtd.
*)

val exml_of_nmm : Common_utils.t_exml_options -> string -> string

val exml_of_axml : Common_utils.t_exml_options -> string -> string
