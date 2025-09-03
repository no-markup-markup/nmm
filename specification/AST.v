(*
  NAMING CONVENTIONS

- *A simple type is* an inductive type with a single non-inductive constructor
  taking one argument.

  - Names of simple types begin with ‘ts_’.

  - If ‘ts_’⌒ν is the name of a simple type then the name of its single
    constructor is ‘cs_’⌒ν.

- *An enum type is* an inductive type with multiple constructors, each
  non-inductive and with no more than one argument.

  - Names of enum types begin with ‘te_’.

  - If ‘te_’⌒ν is the name of an enum type then the name of each of its
    constructors begins with ‘ce_’⌒ν⌒‘_’.

- *A record type is* an inductive type with a single non-inductive constructor
  taking multiple arguments. The arguments may be accessed by pattern matching
  as usual, but also by *the field functions for the* record type.

  - Names of record types begin with ‘tr_’.

  - If ‘tr_’⌒ν is the name of a record type then:

    - The name of the constructor of the record type begins with ‘cr_’⌒ν.

    - Each field function of the record type begins with ‘fld_’⌒ν⌒‘_’.

- *An inductive type is* an inductive type with at least one properly inductive
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

Record tr_c_ref : Type := cr_c_ref {
  fld_c_ref_tag  : ts_tag;
  fld_c_ref_name : ts_name;
}.

Inductive ts_txt_unit_wysiwyg : Type :=
  cs_txt_unit_wysiwyg : t_str    -> ts_txt_unit_wysiwyg.
Inductive ts_txt_unit_emph    : Type :=
  cs_txt_unit_emph    : t_str    -> ts_txt_unit_emph.
Inductive ts_txt_unit_c_ref   : Type :=
  cs_txt_unit_c_ref   : tr_c_ref -> ts_txt_unit_c_ref.
Inductive te_txt_unit :=
| ce_txt_unit_wysiwyg : ts_txt_unit_wysiwyg -> te_txt_unit
| ce_txt_unit_emph    : ts_txt_unit_emph    -> te_txt_unit
| ce_txt_unit_c_ref   : ts_txt_unit_c_ref   -> te_txt_unit
.

Inductive te_lbl : Type :=
| ce_lbl_auto   :          te_lbl
| ce_lbl_custom : t_str -> te_lbl
.

Record tr_dsp_line : Type := cr_dsp_line {
  fld_dsp_line_lbl       : option te_lbl;
  fld_dsp_line_tag_or_id : option te_tag_or_id;
  fld_dsp_line_units     : list te_txt_unit;
}.

(*  constructors cr_blk_itm and cr_blk_dsp does not pass positivity checking,
    but for our purposes they are safe *)
Unset Positivity Checking.
Inductive
te_blk : Type :=
| ce_blk_txt : ts_blk_txt -> te_blk
| ce_blk_blt : ts_blk_blt -> te_blk
| ce_blk_itm : tr_blk_itm -> te_blk
| ce_blk_dsp : ts_blk_dsp -> te_blk
with
ts_blk_txt : Type :=
| cs_txt_blk : list te_txt_unit -> ts_blk_txt
with
ts_blk_blt : Type :=
| cs_blt_blk : list te_blk -> ts_blk_blt
with
tr_blk_itm : Type :=
| cr_blk_itm : te_lbl -> option te_tag_or_id -> list te_blk -> tr_blk_itm
with
ts_blk_dsp : Type :=
| cs_blk_dsp : list tr_dsp_line -> ts_blk_dsp
.
Set Positivity Checking.

(* Cannot mix inductive definitions with record definitions so we have to define
   the fld functions manually for tr_blk_itm *)

Definition fld_blk_itm_lbl       (blk_itm : tr_blk_itm) : te_lbl
  := match blk_itm with cr_blk_itm lbl _        _    => lbl       end.
Definition fld_blk_itm_tag_or_id (blk_itm : tr_blk_itm) : option te_tag_or_id
  := match blk_itm with cr_blk_itm _  tag_or_id _    => tag_or_id end.
Definition fld_blk_itm_blks      (blk_itm : tr_blk_itm) : list te_blk
  := match blk_itm with cr_blk_itm _  _         blks => blks      end.

Inductive ts_hdr : Type := cs_hdr : list te_txt_unit -> ts_hdr.

Record tr_par : Type := cr_par {
  fld_par_tag_or_id : option te_tag_or_id;
  fld_par_hdr       : option ts_hdr;
  fld_par_blks      : list te_blk;
}.

Record tr_sec_pars : Type := cr_sec_pars {
  fld_sec_pars_tag_or_id : option te_tag_or_id;
  fld_sec_pars_hdr       : option ts_hdr;
  fld_sec_pars_intro     : option (list ts_blk_txt); (* option unnecessary? *)
  fld_sec_pars_main      : list tr_par
}.

Record tr_sec_blks : Type := cr_sec_blks {
  fld_sec_blks_tag_or_id : option te_tag_or_id;
  fld_sec_blks_hdr       : option ts_hdr;
  fld_sec_blks_main      : list te_blk
}.

Inductive te_sec :=
| ce_sec_pars : tr_sec_pars -> te_sec
| ce_sec_blks : tr_sec_blks -> te_sec
.

Record tr_ch_secs : Type := cr_ch_secs {
  fld_ch_secs_tag_or_id : option te_tag_or_id;
  fld_ch_secs_hdr       : option ts_hdr;
  fld_ch_secs_intro     : option (list ts_blk_txt); (* option unnecessary? *)
  fld_ch_secs_main      : list te_sec;
}.

Record tr_ch_pars : Type := cr_ch_pars {
  fld_ch_pars_tag_or_id : option te_tag_or_id;
  fld_ch_pars_hdr       : option ts_hdr;
  fld_ch_pars_intro     : option (list ts_blk_txt); (* option unnecessary? *)
  fld_ch_pars_main      : list tr_par;
}.

Record tr_ch_blks : Type := cr_ch_blks {
  fld_ch_blks_tag_or_id : option te_tag_or_id;
  fld_ch_blks_hdr       : option ts_hdr;
  fld_ch_blks_main      : list te_blk;
}.

Inductive te_ch : Type :=
| ce_ch_secs : tr_ch_secs -> te_ch
| ce_ch_pars : tr_ch_pars -> te_ch
| ce_ch_blks : tr_ch_pars -> te_ch
.

Inductive ts_preamble : Type :=
| cs_preamble : t_str -> ts_preamble.

Inductive ts_doc_title : Type :=
| cs_doc_title : list te_txt_unit -> ts_doc_title.

Inductive ts_doc_abstract : Type :=
| cs_doc_abstract : list ts_blk_txt -> ts_doc_abstract.

Inductive te_doc_main : Type :=
| ce_doc_main_chs  : list te_ch  -> te_doc_main
| ce_doc_main_secs : list te_sec -> te_doc_main
| ce_doc_main_pars : list tr_par -> te_doc_main
| ce_doc_main_blks : list te_blk -> te_doc_main
.

Inductive ts_refs : Type := cs_refs : list te_blk -> ts_refs.

Record te_doc : Type := c_doc {
  fld_doc_preamble : option ts_preamble;
  fld_doc_title    : option ts_doc_title;
  fld_doc_abstract : option ts_doc_abstract;
  fld_doc_main     : te_doc_main;
  fld_doc_refs     : option ts_refs;
}.
