(** For compiling parsed nmm source-code (an abstract syntax tree in the format specified by {!module:Doc_types}) into raw text and XML (in the format specified by {{:specs/exml.dtd.txt}exml.dtd}) with resolved cross-references and labels. *)

exception Error of string


val txt_of_tr_doc : Common_utils.t_txt_options -> Doc_types.tr_doc -> string
(**
Implements the raw text semantics for no-markup-markup.
*)

val exml_of_tr_doc : Common_utils.t_exml_options -> Doc_types.tr_doc -> Xml.xml
(**
[exml_of_tr_doc options doc] evaluates to an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml] that is also an instance of the xml-schema {{:specs/exml.dtd.txt}exml.dtd}.

{!val:Html_utils.html_of_exml} can translate that object into the body of an html-document.
*)


val margin_labels_of_tr_doc : Common_utils.t_doc_settings -> Doc_types.tr_doc -> string list
(**
For determining the size of the left margin.
*)


(* for debugging *)

val cref_table_of_tr_doc : Common_utils.t_doc_settings -> Doc_types.tr_doc -> Common_utils.t_cref_table

val nte_table_of_tr_doc : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Doc_types.tr_doc -> Common_utils.t_nte_table
