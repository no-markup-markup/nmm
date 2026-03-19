(**
A toolkit used by {!module:Compiler_of_doc} when compiling to XML, mostly for handling attributes and pcdata.
*)

exception Error of string

val string_of_pcdata : string -> string

val pcdata_of_string : string -> string

val xml_of_string : string -> Xml.xml

val xml_list_of_ts_title_opt : Doc_types.ts_title option -> Xml.xml list

val xml_list_of_ts_authors_opt : Doc_types.ts_authors option -> Xml.xml list

val xml_list_of_ts_date_opt : Doc_types.ts_date option -> Xml.xml list

val xml_list_of_abstract_hdr : Common_utils.t_doc_settings -> Xml.xml list

val xml_list_of_refs_hdr : Common_utils.t_doc_settings -> Xml.xml list

val xml_of_ts_blk_txt : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_path -> Doc_types.ts_blk_txt -> Xml.xml

val xml_of_ts_blk_vrb : Doc_types.ts_blk_vrb -> Xml.xml

val xml_list_of_ts_txt_units : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_path -> Doc_types.ts_txt_units -> Xml.xml list

val attr_list_of_tu_tag_or_id : Common_utils.t_doc_settings -> Common_utils.t_path -> string list -> Doc_types.tu_tag_or_id option -> (string * string) list

val attr_list_of_tr_id : Common_utils.t_doc_settings -> Common_utils.t_path -> Doc_types.tr_id option -> (string * string) list

val par_hdr_opt: Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_path -> Doc_types.tu_tag_or_id option -> Doc_types.ts_hdr option -> (Xml.xml list) option


