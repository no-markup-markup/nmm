(** Specifies default tags and their expansions, and generates custom tag
    expansions from a tsv-file. *)

(* expander *)

val expand_tag_default : Doc_types.ts_tag -> (string * string) option
val expander_of_file : string -> Doc_types.ts_tag -> (string * string) option

(* tagger *)


val tag_blk_itm_of_path_opt :
  string option -> Doc_types.tr_blk_itm -> Doc_types.tr_blk_itm

val c_ref_or_wysiwyg_of_path_opt :
  string option -> Doc_types.tu_txt_unit -> Doc_types.tu_txt_unit
