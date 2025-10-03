(*
  NAMING CONVENTIONS

- A *simple type* is a type with a single non-inductive constructor taking one
  argument.

  - Names of simple types begin with ‘ts_’.

  - If ‘ts_’⌒ν is the name of a simple type then the name of its single
    constructor is ‘cs_’⌒ν.

- An *enum type* is a type with multiple constructors, each non-inductive and
  with no more than one argument.

  - Names of enum types begin with ‘te_’.

  - If ‘te_’⌒ν is the name of an enum type then the name of each of its
    constructors begins with ‘ce_’⌒ν⌒‘_’.

- A *record type* is a type with a single non-inductive constructor taking
  multiple arguments. The arguments may be accessed by pattern matching as
  usual, but also by *the field functions for the* record type.

  - Names of record types begin with ‘tr_’.

  - If ‘tr_’⌒ν is the name of a record type then:

    - The name of the constructor of the record type begins with ‘cr_’⌒ν.

    - Each field function of the record type begins with ‘fld_’⌒ν⌒‘_’.

- An *inductive type* is a type with at least one properly inductive
  constructor.

  - Names of inductive types begin with ‘ti_’.

  - If ‘ti_’⌒ν is the name of a simple type then the name of each of its
    constructors start with ‘ci_’⌒ν.
*)

(* we assume a string type *)
Parameter t_str : Type.

Inductive ts_tag  : Type := cs_tag  : t_str -> ts_tag.
Inductive ts_name : Type := cs_name : t_str -> ts_name.
Record    tr_id   : Type := cr_id {
  fld_id_tag  : ts_tag;
  fld_id_name : ts_name;
}.

Inductive te_tag_or_id : Type :=
| ce_tag_or_id_tag : ts_tag -> te_tag_or_id
| ce_tag_or_id_id  : tr_id  -> te_tag_or_id
.

Inductive te_c_ref_type :=
| ce_cref_type_lcl : te_c_ref_type
| ce_cref_type_gbl : te_c_ref_type
.

Inductive ts_c_ref : Type := cs_c_ref : tr_id -> ts_c_ref.

Inductive ts_txt_unit_wysiwyg : Type :=
  cs_txt_unit_wysiwyg : t_str    -> ts_txt_unit_wysiwyg.
Inductive ts_txt_unit_emph    : Type :=
  cs_txt_unit_emph    : t_str    -> ts_txt_unit_emph.
Inductive ts_txt_unit_c_ref   : Type :=
  cs_txt_unit_c_ref   : ts_c_ref -> ts_txt_unit_c_ref.
Inductive te_txt_unit         : Type :=
| ce_txt_unit_wysiwyg : ts_txt_unit_wysiwyg -> te_txt_unit
| ce_txt_unit_emph    : ts_txt_unit_emph    -> te_txt_unit
| ce_txt_unit_c_ref   : ts_txt_unit_c_ref   -> te_txt_unit
.
Inductive ts_txt_units : Type :=
  cs_txt_units : list te_txt_unit -> ts_txt_units.

Inductive ts_lbl_auto   : Type := cs_lbl_auto   :          ts_lbl_auto.
Inductive ts_lbl_custom : Type := cs_lbl_custom : t_str -> ts_lbl_custom.
Inductive te_lbl        : Type :=
| ce_lbl_auto   : ts_lbl_auto   -> te_lbl
| ce_lbl_custom : ts_lbl_custom -> te_lbl
.

Inductive ts_dsp_line_no_lbl : Type :=
| cs_dsp_line_no_lbl : ts_txt_units -> ts_dsp_line_no_lbl.
Record tr_dsp_line_lbld : Type := cr_dsp_line_lbld {
  fld_dsp_line_lbld_lbl   : te_lbl;
  fld_dsp_line_lbld_id    : option tr_id;
  fld_dsp_line_lbld_units : ts_txt_units;
}.
Inductive te_dsp_line : Type :=
| ce_dsp_line_no_lbl : ts_dsp_line_no_lbl -> te_dsp_line
| ce_dsp_line_lbld   : tr_dsp_line_lbld   -> te_dsp_line
.
Inductive ts_dsp_lines : Type :=
  cs_dsp_lines : list te_dsp_line -> ts_dsp_lines.

Inductive
  te_blk : Type :=
  | ce_blk_txt : ts_blk_txt -> te_blk
  | ce_blk_blt : ts_blk_blt -> te_blk
  | ce_blk_itm : tr_blk_itm -> te_blk
  | ce_blk_dsp : ts_blk_dsp -> te_blk
with
  ts_blk_txt : Type :=
  | cs_blk_txt : ts_txt_units ->                      ts_blk_txt
with
  ts_blk_blt : Type :=
  | cs_blk_blt : ts_blks ->                           ts_blk_blt
with
  tr_blk_itm : Type :=
  | cr_blk_itm : te_lbl -> option tr_id -> ts_blks -> tr_blk_itm
with
  ts_blk_dsp : Type :=
  | cs_blk_dsp : ts_dsp_lines ->                      ts_blk_dsp
with
  ts_blks    : Type :=
  | cs_blks    : list te_blk  ->                      ts_blks
.
(* Cannot mix inductive definitions with record definitions so we have to define
   the fld functions manually for tr_blk_itm *)
Definition fld_blk_itm_lbl  (blk_itm : tr_blk_itm) : te_lbl
  := match blk_itm with cr_blk_itm lbl _  _    => lbl  end.
Definition fld_blk_itm_id   (blk_itm : tr_blk_itm) : option tr_id
  := match blk_itm with cr_blk_itm _   id _    => id   end.
Definition fld_blk_itm_main (blk_itm : tr_blk_itm) : ts_blks
  := match blk_itm with cr_blk_itm _   _  blks => blks end.

Inductive ts_hdr : Type := cs_hdr : ts_txt_units -> ts_hdr.

Record tr_par : Type := cr_par {
  fld_par_tag_or_id : option te_tag_or_id;
  fld_par_hdr       : option ts_hdr;
  fld_par_main      : ts_blks;
}.
Inductive ts_pars : Type := cs_pars : list tr_par -> ts_pars.

Inductive te_pars_or_blks : Type :=
| ce_pars_or_blks_pars : ts_pars -> te_pars_or_blks
| ce_pars_or_blks_blks : ts_blks -> te_pars_or_blks
.

Record tr_sec : Type := cr_sec {
  fld_sec_tag_or_id : option te_tag_or_id;
  fld_sec_hdr       : option ts_hdr;
  fld_sec_main      : te_pars_or_blks;
}.
Inductive ts_secs : Type := cs_secs : list tr_sec -> ts_secs.

Inductive te_secs_pars_or_blks : Type :=
| ce_secs_pars_or_blks_secs : ts_secs -> te_secs_pars_or_blks
| ce_secs_pars_or_blks_pars : ts_pars -> te_secs_pars_or_blks
| ce_secs_pars_or_blks_blks : ts_blks -> te_secs_pars_or_blks
.

Record tr_ch : Type := cr_ch {
  fld_ch_tag_or_id : option te_tag_or_id;
  fld_ch_hdr       : option ts_hdr;
  fld_ch_main      : te_secs_pars_or_blks;
}.
Inductive ts_chs : Type := cs_chs : list tr_ch  -> ts_chs.

Inductive te_doc_main : Type :=
| ce_doc_main_chs  : ts_chs  -> te_doc_main
| ce_doc_main_secs : ts_secs -> te_doc_main
| ce_doc_main_pars : ts_pars -> te_doc_main
| ce_doc_main_blks : ts_blks -> te_doc_main
.

Inductive ts_refs     : Type := cs_refs     : ts_blks -> ts_refs.

Inductive ts_abstract : Type := cs_abstract : ts_blks -> ts_abstract.

Inductive ts_title    : Type := cs_title    : t_str   -> ts_title.

Inductive ts_author   : Type := cs_author   : t_str   -> ts_author.

Inductive ts_preamble : Type := cs_preamble : t_str   -> ts_preamble.

Record tr_doc : Type := cr_doc {
  fld_doc_preamble : option ts_preamble;
  fld_doc_title    : option ts_title;
  fld_doc_author   : option ts_author;
  fld_doc_abstract : option ts_abstract;
  fld_doc_main     : te_doc_main;
  fld_doc_refs     : option ts_refs;
}.
