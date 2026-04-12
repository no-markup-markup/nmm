(**
A toolkit used by {!module:Compiler_of_doc} when compiling raw text, for handling headers, text-decoration and line breaks. Relies on 
{{:https://ocaml.org/p/uuseg/15.0.0/doc/uuseg/Uuseg/index.html}Uuseg} for utf8-segmentation.
*)


val lines_of_ts_title_opt : Common_utils.t_doc_settings -> Doc_types.ts_title option -> string list
val lines_of_ts_authors_opt : Common_utils.t_doc_settings -> Doc_types.ts_authors option -> string list
val lines_of_tu_date_opt : Common_utils.t_doc_settings -> Doc_types.tu_date option -> string list
val lines_of_abstract_hdr : Common_utils.t_doc_settings -> Common_utils.t_doc_class -> string list
val lines_of_refs_hdr : Common_utils.t_doc_settings -> Common_utils.t_doc_class -> string list
val lines_of_endnotes_hdr : Common_utils.t_doc_settings -> string list

val lines_of_ts_blk_txt : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_ftn_table -> Common_utils.t_path -> Doc_types.ts_blk_txt -> string list
val lines_of_ts_hdr_opt : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_ftn_table -> Common_utils.t_path -> Doc_types.ts_hdr option -> string list
val lines_of_ts_txt_units : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_ftn_table -> Common_utils.t_path -> Doc_types.ts_txt_units -> string list
val insert_label : Common_utils.t_doc_settings -> Common_utils.t_path -> string -> string
val lines_of_ts_blk_vrb : Common_utils.t_doc_settings -> Common_utils.t_path -> Doc_types.ts_blk_vrb -> string list

val max_length_of_margin_labels : string list -> int
val left_margin_of_margin_labels : string list -> int

val copy_hdr_to_main : Common_utils.t_doc_settings -> Doc_types.tr_par_std -> Doc_types.tr_par_std

val make_string : int -> string -> string
