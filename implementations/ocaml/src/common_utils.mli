(** 
A toolkit used by {!module:Compiler_of_doc} for handling default and custom document settings (margins, document width, etc.), cross-references, and labels.
*)

exception Error of string


(** <h2>Document settings</h2> *)

type t_doc_settings = {
  mutable doc_width : int;
  mutable left_margin : int;
  mutable title_indent : int;
  mutable author_indent : int;
  mutable abstract_indent : int;
  mutable refs_indent : int;
  mutable tab_length : int;
  mutable abstract_prefix : string option;
  mutable refs_prefix : string option;
  mutable ch_prefix : string option;
  mutable sec_prefix : string option;
  mutable par_prefix : string option;
  mutable expand_tag_singular: Doc_types.ts_tag -> string option;
  mutable expand_tag_plural: Doc_types.ts_tag -> (string * string) option;
}



val class_of_tr_doc: Doc_types.tr_doc -> string
(**
{[class_of_tr_doc doc]}

evaluates to

{[
match doc.fld_doc_main with
|Cu_doc_main_chs _ -> "doc chs"
|Cu_doc_main_secs _ -> "doc secs"
|Cu_doc_main_pars _ -> "doc pars"
|Cu_doc_main_blks _ -> "doc blks"
]}
*)

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
| _  -> None
]}
*)


val doc_settings : t_doc_settings
(**
{[ = {
    doc_width           = 80;
    left_margin         = 12;
    title_indent        = 12;
    author_indent       = 12;
    abstract_indent     = 12;
    refs_indent         = 12;
    tab_length          = 6;
    abstract_prefix     = Some "ABSTRACT";
    refs_prefix         = Some "REFERENCES";
    ch_prefix           = Some "CHAPTER";
    sec_prefix          = Some "§";
    par_prefix          = Some "¶";
    expand_tag_singular = expand_tag_singular_default;
    expand_tag_plural   = expand_tag_plural_default;
}
]}

These are the default settings.
*)

(** <h3>User-defined settings</h3> *)


val doc_settings_of_tr_doc : Doc_types.tr_doc -> unit
(**
{[doc_settings_of_tr_doc doc]} 

first checks if [doc] contains any sections or paragraphs. If not, it sets [doc_settings.left_margin] to [0]. 

Secondly, it checks if [doc] has a preamble. If so, it attempts to parse that preamble and adjusts [doc_settings] accordingly (possibly overriding the default settings). 

Prints a warning to [stderr] if parsing fails, and keeps the default value.

[Cs_preamble (preamble : string)] is valid for parsing just in case [preamble] has the following format:
{v
PREAMBLE := KEY_VALUE [';' KEY_VALUE]*

KEY_VALUE := | 'doc_width=' INT
             | 'left_margin=' INT
             | 'title_indent=' INT
             | 'author_indent=' INT
             | 'abstract_indent=' INT
             | 'refs_indent=' INT
             | 'tab_length=' INT
             | 'abstract_prefix=' STRING
             | 'refs_prefix=' STRING
             | 'ch_prefix=' STRING
             | 'sec_prefix=' STRING
             | 'par_prefix=' STRING
             | 'singular_tag=' TAG '>' SINGULAR_FORM
             | 'plural_tag=' TAG '>' SINGULAR_FORM '>' PLURAL_FORM

SINGULAR_FORM := TAG

PLURAL_FORM := TAG

TAG := [! ';' '>']*

INT := ['0'-'9']+

STRING := [! ';']*
v}
*)


(** <h2>Cross-references and labels</h2> *)


type t_par_node = NO_TAG of (string option * int) | SINGULAR_TAG of (string * int) | PLURAL_TAG of (string * string * int)

type t_itm_node = 
	|ITM_INT of int
	|ITM_STRING of string
	|ITM_TAG_INT of (string * int)
	|ITM_TAG_STRING of (string * string)

type t_dsp_line_node = 
	|DSP_INT of int
	|DSP_STRING of string
	|NONE

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


type t_cref_table = (Doc_types.tr_id * t_path) list 

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


val string_of_ts_c_ref : t_path -> Doc_types.ts_c_ref -> string
(**
{[string_of_ts_c_ref path c_ref]}

attempts to match [c_ref] ocurring at [path] with an [id] in [doc_cref_table], and return a string representation of the path to [id] relative to the closest common ancestor of [c_ref] and [id]. 

For instance, if [c_ref] is located at path [[ITM_NODE (ITM_INT 1); PAR_NODE 1; SEC_NODE 1]], and [id] is located at path [[ITM_NODE (ITM_INT 3); PAR_NODE 2; SEC_NODE 1]], the function will return ["2(3)"] rather than ["1.2(3)"].

If [c_ref] evaluates to [Cs_c_ref id], and [id] is located at [[PAR_NODE "1"]], and if [doc_settings.expand_tag id.fld_id_tag] evaluates to [Some "DEFINITION"], then [string_of_ts_c_ref [] c_ref] evaluates to ["DEFINITION 1"] rather than ["¶ 1"]. 

Prints a warning to [stderr] if no match is found, and returns ["??"].
*)

val node_of_tr_par : int -> Doc_types.tr_par -> t_node


val node_of_blk_itm : t_node option -> int -> Doc_types.tr_blk_itm -> t_node
(**
{[node_of_blk_itm (auto_nr : int) (a : Doc_types.tr_blk_itm)]}

evaluates to

{[
let itm_node : t_itm_node =
  match a.fld_blk_itm_lbl with
  | Cu_lbl_auto Cs_lbl_auto -> ITM_INT auto_nr
  | Cu_lbl_custom (Cs_lbl_custom (s : string)) -> ITM_STRING s
in ITM_NODE itm_node
]}
*)


val node_of_dsp_line : int -> Doc_types.tr_dsp_line -> t_node
(**
{[node_of_dsp_line (auto_nr : int) (a : Doc_types.tr_dsp_line)]}

evaluates to

{[
match a.fld_dsp_line_lbl with
  | Some (Cu_lbl_auto Cs_lbl_auto)-> DSP_INT auto_nr
  | Some (Cu_lbl_custom (Cs_lbl_custom (s : string))) -> DSP_STRING s
  | None -> NONE
in DSP_LINE_NODE dsp_line_node
]}
*)


val label_of_path_opt : t_path -> string option
(**
With default [doc_settings], 

[label_of_path_opt [CH_NODE 1]] evaluates to [Some "CHAPTER 1"]

[label_of_path_opt [SEC_NODE 1]] evaluates to [Some "§ 2"]

[label_of_path_opt [SEC_NODE 1; CH_NODE 2]] evaluates to [Some "§ 2.1"]

[label_of_path_opt [PAR_NODE 1]] evaluates to [Some "¶ 1"]

[label_of_path_opt [PAR_NODE 1; SEC_NODE 2]] evaluates to [Some "¶ 2.1"]

[label_of_path_opt [PAR_NODE 1; SEC_NODE 2; CH_NODE 3]] evaluates to [Some "¶ 3.2.1"]

[label_of_path_opt [ITM_NODE (ITM_INT 1)]::tail] evaluates to [Some "(1)"]

[label_of_path_opt [ITM_NODE (ITM_STRING "a")]::tail] evaluates to [Some "(a)"]

[label_of_path_opt [DSP_LINE_NODE (DSP_INT 1)]::tail] evaluates to [Some "(1)"]

[label_of_path_opt [DSP_LINE_NODE (DSP_STRING "a")]::tail] evaluates to [Some "(a)"]

[label_of_path_opt [DSP_LINE_NODE NONE]::tail] evaluates to [None]

[label_of_path_opt [ITM_NODE (ITM_INT 1); REFS_NODE]] evaluates to [Some "[1]"]

[label_of_path_opt [ITM_NODE (ITM_INT 1); ABSTRACT_NODE]] evaluates to [Some "(1)"]

*)


val label_of_path : t_path -> string
(**
{[label_of_path path]}

evaluates to

{[match label_of_path_opt path with
| None -> ""
| Some (s : string) -> s
]}
*)

