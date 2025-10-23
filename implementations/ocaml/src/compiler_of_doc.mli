(** For compiling parsed nmm source-code (an abstract syntax tree in the format specified by {!module:Doc_types}) into raw text and XML (in the format specified by {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/dtd/exml.dtd}exml.dtd}) with resolved cross-references and labels. *)

exception Error of string

val cref_table_of_tr_doc : Doc_types.tr_doc -> Common_utils.t_cref_table
(**
{[cref_table_of_tr_doc doc]}
searches [doc] for id:s, and adds them and their path to {!val:Common_utils.doc_cref_table}.
*)


val txt_of_tr_doc : Doc_types.tr_doc -> string
(**
Implements the raw text semantics of no-markup-markup.
*)

val exml_of_tr_doc : Doc_types.tr_doc -> Xml.xml
(**
{[exml_of_tr_doc doc]}
evaluates to an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml] that is also an instance of the xml-schema {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/dtd/exml.dtd}exml.dtd}.

{!val:Html_utils.html_of_exml} can translate that object into the body of an html-document.
*)

(**
Both [txt_of_tr_doc doc] and [exml_of_tr_doc doc] first evaluates [cref_table_of_tr_doc doc] and {!val:Common_utils.doc_settings_of_tr_doc} [ doc].

*)
