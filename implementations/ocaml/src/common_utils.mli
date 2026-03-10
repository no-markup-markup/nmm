(** 
A toolkit used by {!module:Compiler_of_doc} for handling default and custom document settings (margins, document width, etc.), cross-references, and labels.
*)

exception Error of string


(** <h2>Document classes</h2> *)


type t_doc_class = DOC_CHS | DOC_SECS | DOC_PARS | DOC_BLKS


val class_of_tr_doc: Doc_types.tr_doc -> t_doc_class
(**
{[class_of_tr_doc doc]}

evaluates to

{[
match doc.fld_doc_main with
|Cu_doc_main_chs _ -> DOC_CHS
|Cu_doc_main_secs _ -> DOC_SECS
|Cu_doc_main_pars _ -> DOC_PARS
|Cu_doc_main_blks _ -> DOC_BLKS
]}
*)

val string_of_t_doc_class: t_doc_class -> string
(**
{[
string_of_t_doc_class doc_class
]}

evaluates to

{[
match doc_class with
|DOC_CHS -> "doc chs"
|DOC_SECS -> "doc secs"
|DOC_PARS -> "doc pars"
|DOC_BLKS -> "doc blks"
]}
*)



(** <h2>Document settings</h2> *)

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
  ch_prefix : (string * string) option;
  sec_prefix : (string * string) option;
  app_prefix : (string * string) option;
  par_prefix : (string * string) option;
  expand_tag: Doc_types.ts_tag -> (string * string) option;
  auto_numbering : int -> int -> string;
  allow_custom_numbering : bool;

}


(** <h3>Default settings</h3> *)


val expand_tag_default : Doc_types.ts_tag -> (string * string) option
(**
{[expand_tag_default tag]}

evaluates to

{[
	match tag with
	|Cs_tag "DEF" -> Some ("DEFINITION", "Definition")
	|Cs_tag "PRF" -> Some ("PROOF", "Proof")
	|Cs_tag "FCT" -> Some ("FACT", "Fact")
	|Cs_tag "LMA" -> Some ("LEMMA", "Lemma")
	|Cs_tag "THM" -> Some ("THEOREM", "Theorem")
	|Cs_tag "RMK" -> Some ("REMARK", "Remark")
	|Cs_tag "DEFS" -> Some ("DEFINITIONS", "Definitions")
	|Cs_tag "PRFS" -> Some ("PROOFS", "Proofs")
	|Cs_tag "FCTS" -> Some ("FACTS", "Facts")
	|Cs_tag "LMAS" -> Some ("LEMMAS", "Lemmas")
	|Cs_tag "THMS" -> Some ("THEOREMS", "Theorems")
	|Cs_tag "RMKS" -> Some ("REMARKS", "Remarks")
	| _  -> None

]}
*)


val doc_settings_default : unit -> t_doc_settings
(**
{[doc_settings_default ()]

evaluates to

{
	doc_width = 68;
	left_margin = 0;
	title_indent = 0;
	author_indent = 0;
	abstract_indent = 0;
	refs_indent = 0;
	tab_length = 6;
	abstract_hdr = Some ("ABSTRACT", "Abstract");
	refs_hdr = Some ("REFERENCES", "References");
	ch_prefix = Some ("CHAPTER", "Chapter");
	sec_prefix = Some ("§","§");
	app_prefix = Some ("§","Appendix");
	par_prefix = Some ("¶","¶");
	expand_tag = expand_tag_default;
	auto_numbering = auto_numbering_default;
	allow_custom_numbering = false;
}
]}

These are the default settings.
*)

(** <h3>User-defined settings</h3> *)

val auto_numbering_of_options : string list -> int -> int -> string

val allow_custom_numbering_of_options : string list -> bool

val doc_settings_of_ts_blks : t_doc_settings -> int -> Doc_types.ts_blks -> t_doc_settings

val doc_settings_of_tr_doc : Doc_types.tr_doc -> t_doc_settings
(**
{[doc_settings_of_tr_doc doc]} 

Checks if [doc] has a preamble. If so, it attempts to parse that preamble and adjusts [doc_settings_default] accordingly (possibly overriding the default settings). 

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


(** <h2>Cross-references and labels</h2> *)


type t_par_node = PAR_AUTO of int | PAR_TAG of (string * string * int)

type t_itm_node = 
	|ITM_AUTO of string
	|ITM_CUSTOM of string
	|ITM_TAG_AUTO of (string * string)
	|ITM_TAG_CUSTOM of (string * string)

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

type t_path = t_node list 

type t_cref_element = 
	|Cref_element_ch of Doc_types.tr_ch
	|Cref_element_sec of Doc_types.tr_sec
	|Cref_element_par of Doc_types.tr_par_std
	|Cref_element_blk_itm of Doc_types.tr_blk_itm
	|Cref_element_dsp_line of Doc_types.tr_dsp_line


type t_cref_table = (Doc_types.tr_id * t_path * t_cref_element) list 

val lvl_of_path : t_path -> int

val string_of_ts_c_ref : t_doc_settings -> t_cref_table -> t_path -> Doc_types.ts_c_ref -> string
(**
{[string_of_ts_c_ref doc_settings path c_ref]}

attempts to match [c_ref] ocurring at [path] with an [id] in [doc_cref_table], and return a string representation of the path to [id] relative to the closest common ancestor of [c_ref] and [id]. 

Prints a warning to [stderr] if no match is found, and returns ["??"].
*)


val node_of_tu_par : t_doc_settings -> int -> Doc_types.tu_par -> t_node


val node_of_blk_itm : t_doc_settings -> t_path -> int -> Doc_types.tr_blk_itm -> t_node


val node_of_dsp_line : t_doc_settings -> t_path -> int -> Doc_types.tr_dsp_line -> t_node


val label_of_path_opt : t_doc_settings -> t_path -> string option

val string_of_path : t_doc_settings -> t_path -> string

val label_of_path : t_doc_settings -> t_path -> string


val par_restated_of_tr_id : t_doc_settings -> t_cref_table -> t_path -> Doc_types.tr_id -> (Doc_types.tr_par_std * t_path) option

val string_of_tu_scope : Doc_types.tu_scope -> string

val path_to_ch_node : t_path -> t_path
val path_to_sec_node : t_path -> t_path
val path_to_app_node : t_path -> t_path
val path_to_par_node : t_path -> t_path

val check_cref_table : t_doc_settings -> t_cref_table -> t_cref_table
val string_of_tr_id : Doc_types.tr_id -> string
