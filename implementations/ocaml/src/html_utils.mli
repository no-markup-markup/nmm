(** For translating a compiled nmm-document with resolved cross-references and labels (in the the XML-format specified by {{:specs/exml.dtd.txt}exml.dtd}) to HTML *)

exception Error of string


val html_of_exml : Common_utils.t_doc_class -> Xml.xml -> Xml.xml

val default_tab_length : unit -> string

val default_lang_code : unit -> string

val default_margin : unit -> string

val margin_left_of_tr_doc : Doc_types.tr_doc -> string

val lang_code_of_options : string list -> string option

val margin_left_of_options : string list -> string option

val external_css_of_options : string list -> string option

val internal_css : string -> string -> string
(**
[internal_css tab_length left_margin] evaluates to a string representing an internal css style-sheet.
*)
