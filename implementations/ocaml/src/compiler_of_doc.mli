(** For compiling parsed nmm source-code (an abstract syntax tree in the format specified by {!module:Doc_types}) into raw text and XML (in the format specified by {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/dtd/exml.dtd}exml.dtd}) with resolved cross-references and labels. *)

exception Error of string

val cref_table_of_tr_doc : Common_utils.t_doc_settings -> Doc_types.tr_doc -> Common_utils.t_cref_table
(**
{[cref_table_of_tr_doc doc]}
searches [doc] for named elements and records their paths.
*)


val txt_of_tr_doc : string list -> Doc_types.tr_doc -> string
(**
Implements the raw text semantics of no-markup-markup.
*)

val exml_of_tr_doc : Common_utils.t_doc_settings -> string list -> Doc_types.tr_doc -> Xml.xml
(**
{[exml_of_tr_doc options doc]}
evaluates to an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml] that is also an instance of the xml-schema {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/dtd/exml.dtd}exml.dtd}.

{!val:Html_utils.html_of_exml} can translate that object into the body of an html-document.
*)


val margin_labels_of_tr_doc : Common_utils.t_doc_settings -> Doc_types.tr_doc -> string list
