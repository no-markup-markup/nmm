(** 
A toolkit used by {!module:Compiler_of_doc} for handling default and custom document settings (margins, document width, etc.), cross-references, and labels.
*)

exception Error of string

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


type t_ch_class = CH_SECS | CH_PARS | CH_BLKS

val class_of_tr_ch: Doc_types.tr_ch -> t_ch_class
(**
{[class_of_tr_ch ch]}

evaluates to
{[
match ch.fld_ch_main with
| Cu_secs_pars_or_blks_secs _ -> CH_SECS
| Cu_secs_pars_or_blks_pars _ -> CH_PARS
| Cu_secs_pars_or_blks_blks _ -> CH_BLKS
]}
*)

val string_of_t_ch_class: t_ch_class -> string
(**
{[
string_of_t_ch_class ch_class
]}

evaluates to

{[
match ch_class with
|CH_SECS -> "ch secs"
|CH_PARS -> "ch pars"
|CH_BLKS -> "ch blks"
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
  abstract_hdr : string option;
  refs_hdr : string;
  ch_prefix : string option;
  sec_prefix : string option;
  par_prefix : string option;
  expand_tag_singular: Doc_types.ts_tag -> string option;
  expand_tag_plural: Doc_types.ts_tag -> (string * string) option;
  preserve_vertical_white_space : bool;
}


(** <h3>Default settings</h3> *)


val expand_tag_singular_default : Doc_types.ts_tag -> string option
(**
{[expand_tag_singular_default tag]}

evaluates to

{[
match tag with
|Cs_tag "DEF" -> Some "DEFINITION"
|Cs_tag "PRF" -> Some "PROOF"
|Cs_tag "FCT" -> Some "FACT"
|Cs_tag "LMA" -> Some "LEMMA"
|Cs_tag "THM" -> Some "THEOREM"
|Cs_tag "RMK" -> Some "REMARK"
| _  -> None
]}
*)

val expand_tag_plural_default : Doc_types.ts_tag -> (string * string) option
(**
{[expand_tag_plural_default tag]}

evaluates to

{[
match tag with
|Cs_tag "DEFS" -> Some ("DEFINITION", "DEFINITIONS")
|Cs_tag "PRFS" -> Some ("PROOF", "PROOFS")
|Cs_tag "FCTS" -> Some ("FACT", "FACTS")
|Cs_tag "LMAS" -> Some ("LEMMA", "LEMMAS")
|Cs_tag "THMS" -> Some ("THEOREM", "THEOREMS")
|Cs_tag "RMKS" -> Some ("REMARK", "REMARKS")
| _  -> None
]}
*)


val doc_settings_default : unit -> t_doc_settings
(**
{[doc_settings_default ()]

evaluates to

{
    doc_width           = 68;
    left_margin         = 0;
    title_indent        = 0;
    author_indent       = 0;
    abstract_indent     = 0;
    refs_indent         = 0;
    tab_length          = 6;
    abstract_hdr        = Some "ABSTRACT";
    refs_hdr            = "REFERENCES";
    ch_prefix           = Some "CHAPTER";
    sec_prefix          = Some "§";
    par_prefix          = Some "¶";
    expand_tag_singular = expand_tag_singular_default;
    expand_tag_plural   = expand_tag_plural_default;
    preserve_vertical_white_space = false;
}
]}

These are the default settings.
*)

(** <h3>User-defined settings</h3> *)


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
             | 'abstract-hdr=' STRING_OPTION
             | 'refs-hdr=' STRING
             | 'ch-prefix=' STRING_OPTION
             | 'sec-prefix=' STRING_OPTION
             | 'par-prefix=' STRING_OPTION
             | 'singular-tag=' TAG '>' SINGULAR_FORM
             | 'plural-tag=' TAG '>' SINGULAR_FORM '>' PLURAL_FORM

SINGULAR_FORM := TAG

PLURAL_FORM := TAG

TAG := [! ';' '>']*

INT := ['0'-'9']+

STRING_OPTION := 'None' | 'none' | '' | '""' | STRING

STRING := [! ';']+
v}
*)


(** <h2>Cross-references and labels</h2> *)


type t_par_node = NO_TAG of (string option * int) | SINGULAR_TAG of (string * int) | PLURAL_TAG of (string * string * int)

type t_itm_node = 
	|ITM_AUTO of int
	|ITM_CUSTOM of string
	|ITM_TAG_AUTO of (string * int)
	|ITM_TAG_CUSTOM of (string * string)

type t_dsp_line_node = 
	|DSP_AUTO of int
	|DSP_CUSTOM of string
	|DSP_NONE

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

type t_doc_cref_table = {
  	mutable content : t_cref_table;
}


val doc_cref_table : t_doc_cref_table
(**
{[= {
    content = [];
}]}

Starts as an empty table.
*)


val string_of_ts_c_ref : t_doc_settings -> t_path -> Doc_types.ts_c_ref -> string
(**
{[string_of_ts_c_ref doc_settings path c_ref]}

attempts to match [c_ref] ocurring at [path] with an [id] in [doc_cref_table], and return a string representation of the path to [id] relative to the closest common ancestor of [c_ref] and [id]. 

For instance, if [c_ref] is located at path [[ITM_NODE (ITM_AUTO 1); ITM_NODE (ITM_AUTO 1); ITM_NODE (ITM_AUTO 1)]], and [id] is located at path [[ITM_NODE (ITM_AUTO 3); ITM_NODE (ITM_AUTO 2); ITM_NODE (ITM_AUTO 1)]], the function will return ["(b)(iii)"] rather than ["(1)(b)(iii)"], since their closes common ancestor is the node with label ["(1)"].

If [c_ref] evaluates to [Cs_c_ref id], and [id] is located at [[PAR_NODE "1"]], and if [doc_settings.expand_tag id.fld_id_tag] evaluates to [Some "DEFINITION"], then [string_of_ts_c_ref [] c_ref] evaluates to ["DEFINITION 1"] rather than ["¶ 1"]. 

Prints a warning to [stderr] if no match is found, and returns ["??"].
*)


val node_of_tu_par : t_doc_settings -> int -> Doc_types.tu_par -> t_node


val node_of_blk_itm : t_node option -> int -> Doc_types.tr_blk_itm -> t_node
(**
{[node_of_blk_itm (auto_nr : int) (a : Doc_types.tr_blk_itm)]}

evaluates to

{[
let itm_node : t_itm_node =
  match a.fld_blk_itm_lbl with
  | Cu_lbl_auto Cs_lbl_auto -> ITM_AUTO auto_nr
  | Cu_lbl_custom (Cs_lbl_custom (s : string)) -> ITM_CUSTOM s
in ITM_NODE itm_node
]}
*)


val node_of_dsp_line : int -> Doc_types.tr_dsp_line -> t_node
(**
{[node_of_dsp_line (auto_nr : int) (a : Doc_types.tr_dsp_line)]}

evaluates to

{[
match a.fld_dsp_line_lbl with
  | Some (Cu_lbl_auto Cs_lbl_auto)-> DSP_AUTO auto_nr
  | Some (Cu_lbl_custom (Cs_lbl_custom (s : string))) -> DSP_CUSTOM s
  | None -> DSP_NONE
in DSP_LINE_NODE dsp_line_node
]}
*)


val label_of_path_opt : t_doc_settings -> t_path -> string option
(** 
[label_of_path_opt doc_settings_default [CH_NODE 1]] evaluates to [Some "CHAPTER 1"]

[label_of_path_opt doc_settings_default [SEC_NODE 1]] evaluates to [Some "§ 2"]

[label_of_path_opt doc_settings_default [SEC_NODE 1; CH_NODE 2]] evaluates to [Some "§ 2.1"]

[label_of_path_opt doc_settings_default [PAR_NODE 1]] evaluates to [Some "¶ 1"]

[label_of_path_opt doc_settings_default [PAR_NODE 1; SEC_NODE 2]] evaluates to [Some "¶ 2.1"]

[label_of_path_opt doc_settings_default [PAR_NODE 1; SEC_NODE 2; CH_NODE 3]] evaluates to [Some "¶ 3.2.1"]

[label_of_path_opt doc_settings_default [ITM_NODE (ITM_AUTO 1)]::tail] evaluates to [Some "(1)"]

[label_of_path_opt doc_settings_default [ITM_NODE (ITM_CUSTOM "a")]::tail] evaluates to [Some "(a)"]

[label_of_path_opt doc_settings_default [DSP_LINE_NODE (DSP_AUTO 1)]::tail] evaluates to [Some "(1)"]

[label_of_path_opt doc_settings_default [DSP_LINE_NODE (DSP_CUSTOM "a")]::tail] evaluates to [Some "(a)"]

[label_of_path_opt doc_settings_default [DSP_LINE_NODE DSP_NONE]::tail] evaluates to [None]

[label_of_path_opt doc_settings_default [ITM_NODE (ITM_AUTO 1); REFS_NODE]] evaluates to [Some "(1)"]

[label_of_path_opt doc_settings_default [ITM_NODE (ITM_AUTO 1); ABSTRACT_NODE]] evaluates to [Some "(1)"]

*)

val string_of_path : t_doc_settings -> t_path -> string

val label_of_path : t_doc_settings -> t_path -> string
(**
{[label_of_path doc_settings path]}

evaluates to

{[match label_of_path_opt doc_settings path with
| None -> ""
| Some (s : string) -> s
]}
*)


val par_restated_of_tr_id : Doc_types.tr_id -> Doc_types.tr_par_std option

val string_of_tu_scope : Doc_types.tu_scope -> string

val string_of_tu_lcl : Doc_types.tu_lcl -> string

val path_to_ch_node : t_path -> t_path
val path_to_sec_node : t_path -> t_path
val path_to_par_node : t_path -> t_path

val check_cref_table : t_doc_settings -> t_cref_table -> t_cref_table
