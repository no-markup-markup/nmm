(** 
A toolkit used by {!module:Compiler_of_doc} for handling default and custom document settings (margins, document width, etc.), cross-references, and labels.
*)

exception Error of string


(** {2 Document classes} *)


type t_doc_class = DOC_CHS | DOC_SECS | DOC_PARS | DOC_BLKS


val class_of_tr_doc: Doc_types.tr_doc -> t_doc_class

val string_of_t_doc_class: t_doc_class -> string



(** {2 Document settings} *)

type t_doc_settings = {
  doc_width : int;
  left_margin : int;
  title_indent : int;
  author_indent : int;
  abstract_indent : int;
  refs_indent : int;
  tab_length : int;
  abstract_hdr : (string * string) option;
  refs_hdr : (string * string) option;
  endnotes_hdr : (string * string) option;
  ch_prefix : (string * string) option;
  sec_prefix : (string * string) option;
  app_prefix : (string * string) option;
  par_prefix : (string * string) option;
  expand_tag: Doc_types.ts_tag -> (string * string) option;
  auto_numbering : int -> int -> string;
  allow_custom_numbering : bool;

}


(** {3 Default settings} *)


val expand_tag_default : Doc_types.ts_tag -> (string * string) option


val doc_settings_default : unit -> t_doc_settings

(** {3 User-defined settings} *)

val auto_numbering_of_string : string -> int -> int -> string

val doc_settings_of_ts_blks : t_doc_settings -> int -> Doc_types.ts_blks -> t_doc_settings

val doc_settings_of_tr_doc : Doc_types.tr_doc -> t_doc_settings
(**
[doc_settings_of_tr_doc doc] checks if [doc] has a preamble. If so, it attempts to parse that preamble and adjusts [doc_settings_default] accordingly (possibly overriding the default settings). 

Prints a warning to [stderr] if parsing fails, and keeps the default value.

[Cs_preamble (preamble : string)] is valid for parsing just in case [preamble] has the following format:

{v
PREAMBLE := KEY_VALUE [';' KEY_VALUE]*

KEY_VALUE := | 'doc-width=' INT
             | 'left-margin=' INT
             | 'title-indent=' INT
             | 'author-indent=' INT
             | 'abstract-indent=' INT
             | 'refs-indent=' INT
             | 'tab-length=' INT
             | 'abstract-hdr=' LABEL_FORM ',' CREF_FORM
             | 'refs-hdr=' LABEL_FORM ',' CREF_FORM
             | 'ch-prefix=' LABEL_FORM ',' CREF_FORM
             | 'sec-prefix=' LABEL_FORM ',' CREF_FORM
             | 'par-prefix=' LABEL_FORM ',' CREF_FORM
             | 'tag=' TAG '>' LABEL_FORM ',' CREF_FORM

LABEL_FORM := TAG

CREF_FORM := TAG

TAG := [! ';' ',']*

INT := ['0'-'9']+

v}
*)


(** {2 Cross-references} *)


type t_par_node = PAR_AUTO of int | PAR_TAG of (string * string * int)

and t_itm_node =
	|ITM_AUTO of string
	|ITM_CUSTOM of string
	|ITM_TAG_AUTO of (string * string)
	|ITM_TAG_CUSTOM of (string * string)
	|ITM_BIB_AUTO of string
	|ITM_BIB_CUSTOM of string

type t_dsp_line_node = 
        |DSP_AUTO of string
        |DSP_CUSTOM of string
        |DSP_NONE
        |DSP_TAG_AUTO of (string * string)
        |DSP_TAG_CUSTOM of (string * string)

type t_node = 
        |ABSTRACT_NODE
        |CH_NODE of int
        |SEC_NODE of int
        |APP_NODE of int
        |PAR_NODE of t_par_node
        |ITM_NODE of t_itm_node
        |DSP_NODE
        |BLT_NODE
        |DSP_LINE_NODE of t_dsp_line_node
        |REFS_NODE
        |NTE_NODE of int

type t_path = t_node list 

type t_cref_element = 
        |Cref_element_ch of Doc_types.tr_ch
        |Cref_element_sec of Doc_types.tr_sec
        |Cref_element_par of Doc_types.tr_par_std
        |Cref_element_blk_itm of Doc_types.tr_blk_itm
        |Cref_element_dsp_line of Doc_types.tr_dsp_line
        |Cref_element_blk_nte of Doc_types.tr_blk_nte


type t_cref_table = (Doc_types.tr_id * t_path * t_cref_element) list 


val path_to_ch_node : t_path -> t_path
val path_to_sec_node : t_path -> t_path
val path_to_app_node : t_path -> t_path
val path_to_par_node : t_path -> t_path

val lvl_of_path : t_path -> int

val string_of_tr_id : Doc_types.tr_id -> string

val string_of_path : t_doc_settings -> t_path -> string

val string_of_ts_c_ref : t_doc_settings -> t_cref_table -> t_path -> Doc_types.ts_c_ref -> string
(**
[string_of_ts_c_ref doc_settings cref_table path c_ref] attempts to match [c_ref] ocurring at [path] with an [id] in [cref_table], and return a string representation of the path to [id] relative to the closest common ancestor of [c_ref] and [id]. 

Prints a warning to [stderr] if no match is found, and returns ["??"].
*)

val check_cref_table : t_doc_settings -> t_cref_table -> t_cref_table


(** {2 Labels} *)

val label_of_path_opt : t_doc_settings -> t_path -> string option


val label_of_path : t_doc_settings -> t_path -> string


(** {2 Nodes} *)

val node_of_tu_par : t_doc_settings -> int -> Doc_types.tu_par -> t_node


val node_of_blk_itm : t_doc_settings -> t_path -> int -> Doc_types.tr_blk_itm -> t_node


val node_of_dsp_line : t_doc_settings -> t_path -> int -> Doc_types.tr_dsp_line -> t_node




(** {2 Repeat} *)

val par_restated_of_tr_id : t_doc_settings -> t_cref_table -> t_path -> Doc_types.tr_id -> (Doc_types.tr_par_std * t_path) option


(** {2 Date} *)

type t_time = {
        year : int;
        month : int;
        day : int;
        hour : int;
        minute : int;
        second : int;
        timezone : string * int * int;
}

val utc_timezone : (string * int * int) -> string

val time_of_ts_date_auto : t_doc_settings -> Doc_types.ts_date_auto -> t_time option


(** {2 Footnotes} *)

type t_nte_entry = Ftn_entry_ref of (Doc_types.ts_nte_ref * t_path * int * Doc_types.tr_blk_nte) | Ftn_entry_inline of (Doc_types.ts_nte_inline * t_path * int)

type t_nte_table = t_nte_entry list

val nte_table_of_ts_blk_txt : t_doc_settings -> t_cref_table -> t_path -> t_nte_table  -> Doc_types.ts_blk_txt -> t_nte_table

val nte_table_of_tr_dsp_line : t_doc_settings -> t_cref_table -> t_path -> t_nte_table  -> Doc_types.tr_dsp_line -> t_nte_table

val string_of_ts_nte_ref : t_doc_settings -> t_nte_table -> t_path -> Doc_types.ts_nte_ref -> string

val string_of_ts_nte_inline : t_doc_settings -> t_nte_table -> t_path -> Doc_types.ts_nte_inline -> string

val nte_table_of_ts_hdr_opt : t_doc_settings -> t_cref_table -> t_path -> Doc_types.ts_hdr option -> t_nte_table

val reference_of_ts_nte_ref : t_doc_settings -> t_cref_table -> t_path -> Doc_types.ts_nte_ref -> Doc_types.tr_blk_nte option

(** {2 Options} *)

type t_txt_options = {
        margin : int option;
        width : int option;
        quiet : bool;
        numbering : string;
        allow_custom_numbering : bool;
}

type t_html_options = {
        margin : int option;
        lang : string;
        css : string list;
        quiet : bool;
        numbering : string;
        allow_custom_numbering : bool;
}

type t_exml_options = {
        quiet : bool;
        numbering : string;
        allow_custom_numbering : bool;
}

val exml_options_of_html_options : t_html_options -> t_exml_options

(* for debugging *)

val txt_options_default : unit -> t_txt_options
val html_options_default : unit -> t_html_options
val exml_options_default : unit -> t_exml_options

