(**
A toolkit used by {!module:Compiler_of_doc} when compiling raw text, for handling headers, text-decoration and line breaks. Relies on 
{{:https://ocaml.org/p/uuseg/15.0.0/doc/uuseg/Uuseg/index.html}Uuseg} for utf8-segmentation.
*)

(* indentation *)

val indent_of_path : Common_utils.t_doc_settings -> Common_utils.t_path -> int

val insert_label : Common_utils.t_doc_settings -> Common_utils.t_path -> string -> string

(* title *)

val make_string : int -> string -> string

val lines_of_ts_title_opt : Common_utils.t_doc_settings -> Doc_types.ts_title option -> string list

(* authors *)

val lines_of_ts_authors_opt : Common_utils.t_doc_settings -> Doc_types.ts_authors option -> string list

(* date *)

val lines_of_tu_date_opt : Common_utils.t_doc_settings -> Doc_types.tu_date option -> string list

(* abstract *)

val lines_of_abstract_hdr : Common_utils.t_doc_settings -> Common_utils.t_doc_class -> string list

(* hdr *)

val lines_of_ts_hdr_opt : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_nte_table -> Common_utils.t_path -> Doc_types.ts_hdr option -> string list

(* par_hdr *)

val copy_hdr_to_main : Common_utils.t_doc_settings -> Doc_types.tr_par_std -> Doc_types.tr_par_std

(* refs_hdr *)

val lines_of_refs_hdr : Common_utils.t_doc_settings -> Common_utils.t_doc_class -> string list

(* endnotes_hdr *)

val lines_of_endnotes_hdr : Common_utils.t_doc_settings -> Common_utils.t_path -> string list

(* blk_txt *)

val lines_of_ts_blk_txt : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_nte_table -> Common_utils.t_path -> Doc_types.ts_blk_txt -> string list

(* dsp_line *)

val lines_of_tr_dsp_line : Common_utils.t_doc_settings -> Common_utils.t_cref_table -> Common_utils.t_nte_table -> Common_utils.t_path -> Doc_types.tr_dsp_line -> string list

(* blk_qtn *)

val lines_of_ts_blk_qtn : Common_utils.t_doc_settings -> Common_utils.t_path -> Doc_types.ts_blk_qtn -> string list

(* blk_vrb *)

val lines_of_ts_blk_vrb : Common_utils.t_doc_settings -> Common_utils.t_path -> Doc_types.ts_blk_vrb -> string list

(* margin labels *)

val max_length_of_margin_labels : string list -> int

val left_margin_of_margin_labels : string list -> int


