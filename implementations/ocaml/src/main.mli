(** For assembling the pieces provided by the other modules *)

exception Error of string


val doc_of_nmm : string -> Doc_types.tr_doc
(**
{[doc_of_nmm "path/to/file"]}
evaluates to

{!val:Doc_of_nmm.doc_of_nmm_file}[ false "path/to/file"]

*)

val txt_of_doc : Doc_types.tr_doc -> string
(**
{[txt_of_doc doc]}
evaluates to

{!val:Compiler_of_doc.txt_of_tr_doc}[ doc]
*)

val html_of_doc : string option -> string option -> Doc_types.tr_doc -> string
(**
{[html_of_doc None None doc]} evaluates to a string containing a html-document with an internal css stylesheet, specified by the value of

["<style>" ^ (]{!val:Html_utils.internal_css} [ ] {!val:Common_utils.doc_settings}[) ^ "</style>"]

The body of the html-document is specified by the value of

["<body>" ^ (]{!val:Html_utils.html_of_exml} [ (] {!val:Compiler_of_doc.exml_of_tr_doc} [ doc)) ^ "</body>"]

---

{[html_of_doc (Some "uri/of/syle.css") (Some "en") doc]}
does the same, except that the html-document also contains

{v <html lang="en"> v}

and 

{v <link rel="stylesheet" href="uri/of/style.css"> v}

Since the latter is placed after the internal stylesheet, it will override it.
*)

val doc_of_axml : string -> Doc_types.tr_doc
(**
{[doc_of_axml "path/to/file"]}
evaluates to

{!val:Doc_of_axml.f_tr_doc_of_axml} [ (] {!val:Xml_right.parse_file}  [false "path/to/file")]

---

{[doc_of_axml "-"]}
evaluates to

{!val:Doc_of_axml.f_tr_doc_of_axml} [ (] {!val:Xml_right.parse_stdin} [ false)]
*)
val axml_of_doc : Doc_types.tr_doc -> string
(**
{[axml_of_doc doc]} 
evaluates to

["<?xml version=\"1.0\"?>\n" ^ (] {!val:Xml_right.to_string_fmt} [ (] {!val:Axml_of_doc.axml_of_tr_doc} [ doc))]
*)

val html_of_nmm : string option -> string option -> string -> string
(**
{[html_of_nmm uri_opt lang_opt path]}
evaluates to
{[html_of_doc uri_opt lang_opt (doc_of_nmm path)]}
*)

val txt_of_nmm : string -> string
(**
{[txt_of_nmm path]}
evaluate to
{[txt_of_doc (doc_of_nmm path)]}
*)

val txt_of_axml : string -> string
(**
{[txt_of_axml path]}
evaluates to
{[txt_of_doc (doc_of_axml path)]}
*)

val html_of_axml : string option -> string option -> string -> string
(**
{[html_of_axml uri_opt lang_opt path]}
evaluates to
{[html_of_doc uri_opt lang_opt (doc_of_axml path)]}
*)

val axml_of_nmm : string -> string
(**
{[axml_of_nmm path]}
evaluates to
{[axml_of_doc (doc_of_nmm path)]}
*)

val check_xml_schema : string -> string
(**
{[check_xml_schema "path/to/xml-schema.dtd"]} 
calls the {{:https://github.com/ncannasse/xml-light}Xml-light} function [Dtd.parse_file] for parsing path/to/xml-schema.dtd, and [Dtd.check] for checking that it is a well-defined xml-schema in the format dtd.
*)

val validate_xml : string -> string -> string
(**
{[validate_xml "path/to/xml-schema.dtd" "path/to/xml-file.xml"]}
first calls the {{:https://github.com/ncannasse/xml-light}Xml-light} function [Dtd.parse_file] for parsing xml-schema.dtd, and [Dtd.check] for checking that it is well-defined. It then calls the function {!val:Xml_right.parse_file} for parsing xml-file.xml into an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml]. Lastly, it calls [Dtd.prove] for proving (or disproving) that xml-file.xml is an instance of xml-schema.dtd.
*)

val default_css : string
