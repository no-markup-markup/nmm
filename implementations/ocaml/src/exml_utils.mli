(**
A toolkit used by {!module:Compiler_of_doc} when compiling to XML, mostly for handling attributes and pcdata.
*)

(* string *)

val string_of_pcdata : string -> string

val pcdata_of_string : string -> string

val xml_of_string : string -> Xml.xml

(* title *)

val xml_list_of_ts_title_opt : Doc_types.ts_title option -> Xml.xml list

(* authors *)

val xml_list_of_ts_authors_opt : Doc_types.ts_authors option -> Xml.xml list

(* date *)

val xml_list_of_tu_date_opt : Common_utils.t_doc_settings -> Doc_types.tu_date option -> Xml.xml list

(* abstract_hdr *)

val xml_list_of_abstract_hdr : Common_utils.t_doc_settings -> Xml.xml list

(* refs_hdr *)

val xml_list_of_refs_hdr : Common_utils.t_doc_settings -> Xml.xml list

(* tag_or_id *)

val attr_list_of_tu_tag_or_id_opt : Common_utils.t_doc_settings -> Common_utils.t_path -> string list -> Doc_types.tu_tag_or_id option -> (string * string) list

val attr_list_of_tr_id : Common_utils.t_doc_settings -> Common_utils.t_path -> Doc_types.tr_id -> (string * string) list

val attr_list_of_tr_id_opt : Common_utils.t_doc_settings -> Common_utils.t_path -> string list -> Doc_types.tr_id option -> (string * string) list


(* blk_txt *)

val xml_list_of_ts_txt_lines : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_nte_table -> Common_utils.t_path -> Doc_types.ts_txt_lines -> Xml.xml list

val xml_of_ts_blk_txt : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_nte_table -> Common_utils.t_path -> Doc_types.ts_blk_txt -> Xml.xml


(* dsp_line *)

val xml_of_tr_dsp_line : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_nte_table -> Common_utils.t_path -> Doc_types.tr_dsp_line -> Xml.xml


(* blk_vrb *)

val xml_of_ts_blk_vrb : Doc_types.ts_blk_vrb -> Xml.xml


(* blk_qtn *)

val xml_of_ts_blk_qtn : Doc_types.ts_blk_qtn -> Xml.xml


(* par_hdr *)

val par_hdr_opt: Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_nte_table -> Common_utils.t_path -> Doc_types.tu_tag_or_id option -> Doc_types.ts_hdr option -> (Xml.xml list) option

(* normalize *)

val normalize_exml : Xml.xml -> Xml.xml

(* exml.dtd *)

val exml_schema : unit -> string
(**
[exml_schema ()] evaluates to a string-representation of {{:specs/exml.dtd.txt}exml.dtd}.
*)
