(** Specifies default tags and their expansion *)

(* expander *)

val expand_tag_default : Doc_types.ts_tag -> (string * string) option

val expander_of_path_opt : string option -> Doc_types.ts_tag -> (string * string) option


(* tagger *)

val tag_blk_itm_default : Doc_types.tr_blk_itm -> Doc_types.tr_blk_itm

val tagger_of_path_opt : string option -> Doc_types.tr_blk_itm -> Doc_types.tr_blk_itm
