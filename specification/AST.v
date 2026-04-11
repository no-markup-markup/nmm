(*
  NAMING CONVENTIONS

- A *simple type* is a type with a single non-inductive constructor taking one
  argument.

  - Names of simple types begin with ‘ts_’.

  - If ‘ts_’⌒ν is the name of a simple type then the name of its single
    constructor is ‘cs_’⌒ν.

- An *union type* is a type with multiple constructors, each non-inductive and
  with no more than one argument.

  - Names of union types begin with ‘tu_’.

  - If ‘tu_’⌒ν is the name of an union type then the name of each of its
    constructors begins with ‘cu_’⌒ν⌒‘_’.

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

Inductive tu_scope : Type :=
| cu_scope_GBL : tu_scope
| cu_scope_CH  : tu_scope
| cu_scope_SEC : tu_scope
| ch_scope_APP : tu_scope
| cu_scope_PAR : tu_scope
.

Inductive ts_tag  : Type := cs_tag  : t_str -> ts_tag.
Inductive ts_name : Type := cs_name : t_str -> ts_name.
Record    tr_id   : Type := cr_id {
  fld_id_tag   : ts_tag;
  fld_id_name  : ts_name;
  fld_id_scope : option tu_scope;
}.

Inductive tu_tag_or_id : Type :=
| cu_tag_or_id_tag : ts_tag -> tu_tag_or_id
| cu_tag_or_id_id  : tr_id  -> tu_tag_or_id
.

(*
Inductive tu_c_ref_type :=
| cu_cref_type_lcl : tu_c_ref_type
| cu_cref_type_gbl : tu_c_ref_type
.
*)

Inductive ts_c_ref   : Type := cs_c_ref   : tr_id -> ts_c_ref.
Inductive ts_ftn_ref : Type := cs_ftn_ref : tr_id -> ts_ftn_ref.

Inductive ts_lbl_auto   : Type := cs_lbl_auto   :          ts_lbl_auto.
Inductive ts_lbl_custom : Type := cs_lbl_custom : t_str -> ts_lbl_custom.
Inductive tu_lbl        : Type :=
| cu_lbl_auto   : ts_lbl_auto   -> tu_lbl
| cu_lbl_custom : ts_lbl_custom -> tu_lbl
.

Inductive
  ts_blks                : Type :=
  | cs_blks                : list tu_blk            -> ts_blks
with
  tu_blk                 : Type :=
  | cu_blk_txt             : ts_blk_txt             -> tu_blk
  | cu_blk_blt             : ts_blk_blt             -> tu_blk
  | cu_blk_itm             : tr_blk_itm             -> tu_blk
  | cu_blk_dsp             : ts_blk_dsp             -> tu_blk
  | cu_blk_vrb             : ts_blk_vrb             -> tu_blk
  | cu_blk_ftn             : ts_blk_ftn             -> tu_blk
with
  ts_blk_txt             : Type :=
  | cs_blk_txt             : ts_txt_units           -> ts_blk_txt
with
  ts_blk_blt             : Type :=
  | cs_blk_blt             : ts_blks                -> ts_blk_blt
with
  tr_blk_itm             : Type :=
  | cr_blk_itm             :
    tu_lbl
    ->
    option tr_id
    ->
    ts_blks
    ->
    tr_blk_itm
  (* field functions below *)
with
  ts_blk_dsp             : Type :=
  | cs_blk_dsp             : ts_dsp_lines           -> ts_blk_dsp
with
  ts_blk_vrb             : Type :=
  | cs_blk_vrb             : ts_vrb_lines           -> ts_blk_vrb
with
  ts_blk_ftn             : Type :=
  | cs_blk_ftn             : tr_id -> ts_blks       -> ts_blk_ftn
with
  ts_txt_units           : Type :=
  | cs_txt_units           : list tu_txt_unit       -> ts_txt_units
with
  tu_txt_unit            : Type :=
  | cu_txt_unit_wysiwyg    : ts_txt_unit_wysiwyg    -> tu_txt_unit
  | cu_txt_unit_emph       : ts_txt_unit_emph       -> tu_txt_unit
  | cu_txt_unit_c_ref      : ts_txt_unit_c_ref      -> tu_txt_unit
  | cu_txt_unit_ftn_ref    : ts_txt_unit_ftn_ref    -> tu_txt_unit
  | cu_txt_unit_ftn_inline : ts_txt_unit_ftn_inline -> tu_txt_unit
with
  ts_txt_unit_wysiwyg    : Type :=
  | cs_txt_unit_wysiwyg    : t_str                  -> ts_txt_unit_wysiwyg
with
  ts_txt_unit_emph       : Type :=
  | cs_txt_unit_emph       : t_str                  -> ts_txt_unit_emph
with
  ts_txt_unit_c_ref      : Type :=
  | cs_txt_unit_c_ref      : ts_c_ref               -> ts_txt_unit_c_ref
with
  ts_txt_unit_ftn_ref    : Type :=
  | cs_txt_unit_ftn_ref    : ts_ftn_ref             -> ts_txt_unit_ftn_ref
with
  ts_txt_unit_ftn_inline : Type :=
  | cs_txt_unit_ftn_inline : ts_blks                -> ts_txt_unit_ftn_inline
with ts_dsp_lines        : Type :=
  | cs_dsp_lines           : list tu_dsp_line       -> ts_dsp_lines
with
  tu_dsp_line            : Type :=
  | cu_dsp_line_no_lbl     : ts_dsp_line_no_lbl     -> tu_dsp_line
  | cu_dsp_line_lbld       : tr_dsp_line_lbld       -> tu_dsp_line
with
  ts_dsp_line_no_lbl     : Type :=
  | cs_dsp_line_no_lbl     : ts_txt_units           -> ts_dsp_line_no_lbl
with
  tr_dsp_line_lbld       : Type :=
  | cr_dsp_line_lbld       :
                          tu_lbl
                          ->
                          option tr_id
                          ->
                          ts_txt_units
                          ->
                          tr_dsp_line_lbld
  (* field functions below *)
with
  ts_vrb_lines           : Type :=
  | cs_vrb_lines           : list ts_vrb_line       -> ts_vrb_lines
with
  ts_vrb_line            : Type :=
  | cs_vrb_line            : t_str                  -> ts_vrb_line
.

(* Cannot mix inductive definitions with record definitions so we have to define
   some field functions manually *)

Definition fld_blk_itm_lbl  (blk_itm : tr_blk_itm) : tu_lbl
  := match blk_itm with cr_blk_itm lbl _  _    => lbl  end.
Definition fld_blk_itm_id   (blk_itm : tr_blk_itm) : option tr_id
  := match blk_itm with cr_blk_itm _   id _    => id   end.
Definition fld_blk_itm_main (blk_itm : tr_blk_itm) : ts_blks
  := match blk_itm with cr_blk_itm _   _  blks => blks end.

Definition fld_dsp_line_lbld_lbl   (dsp_line_lbld : tr_dsp_line_lbld)
  : tu_lbl
  := match dsp_line_lbld with cr_dsp_line_lbld id _ _   => id    end.
Definition fld_dsp_line_lbld_id    (dsp_line_lbld : tr_dsp_line_lbld)
  : option tr_id
  := match dsp_line_lbld with cr_dsp_line_lbld _ id _   => id    end.
Definition fld_dsp_line_lbld_units (dsp_line_lbld : tr_dsp_line_lbld)
  : ts_txt_units
  := match dsp_line_lbld with cr_dsp_line_lbld _ _  blks => blks end.

Inductive ts_hdr : Type := cs_hdr : ts_txt_units -> ts_hdr.

Record tr_par_std : Type := cr_par_std {
  fld_par_tag_or_id : option tu_tag_or_id;
  fld_par_hdr       : option ts_hdr;
  fld_par_main      : ts_blks;
}.
Inductive ts_par_rpt : Type := cs_par_rpt : tr_id -> ts_par_rpt.
Inductive tu_par : Type :=
| cu_par_std : tr_par_std -> tu_par
| cu_par_rpt : ts_par_rpt -> tu_par
.
Inductive ts_pars : Type := cs_pars : list tu_par -> ts_pars.

Inductive tu_pars_or_blks : Type :=
| cu_pars_or_blks_pars : ts_pars -> tu_pars_or_blks
| cu_pars_or_blks_blks : ts_blks -> tu_pars_or_blks
.

Record tr_sec : Type := cr_sec {
  fld_sec_tag_or_id : option tu_tag_or_id;
  fld_sec_hdr       : option ts_hdr;
  fld_sec_main      : tu_pars_or_blks;
}.
Inductive ts_secs : Type := cs_secs : list tr_sec -> ts_secs.

Inductive tu_secs_pars_or_blks : Type :=
| cu_secs_pars_or_blks_secs : ts_secs -> tu_secs_pars_or_blks
| cu_secs_pars_or_blks_pars : ts_pars -> tu_secs_pars_or_blks
| cu_secs_pars_or_blks_blks : ts_blks -> tu_secs_pars_or_blks
.

Record tr_ch : Type := cr_ch {
  fld_ch_tag_or_id : option tu_tag_or_id;
  fld_ch_hdr       : option ts_hdr;
  fld_ch_main      : tu_secs_pars_or_blks;
}.
Inductive ts_chs : Type := cs_chs : list tr_ch  -> ts_chs.

Inductive tu_doc_main : Type :=
| cu_doc_main_chs  : ts_chs  -> tu_doc_main
| cu_doc_main_secs : ts_secs -> tu_doc_main
| cu_doc_main_pars : ts_pars -> tu_doc_main
| cu_doc_main_blks : ts_blks -> tu_doc_main
.

Inductive ts_refs     : Type := cs_refs     : ts_blks        -> ts_refs.

Inductive ts_abstract : Type := cs_abstract : ts_blks        -> ts_abstract.

Inductive ts_title    : Type := cs_title    : t_str          -> ts_title.

Inductive ts_author   : Type := cs_author   : t_str          -> ts_author.

Inductive ts_preamble : Type := cs_preamble : t_str          -> ts_preamble.

Inductive ts_authors  : Type := cs_authors  : list ts_author -> ts_authors.

Inductive ts_date_auto   : Type := cs_date_auto   :          ts_date_auto.
Inductive ts_date_custom : Type := cs_date_custom : t_str -> ts_date_custom.
Inductive tu_date        : Type :=
| cu_date_auto   : ts_date_auto   -> tu_date
| cu_date_custom : ts_date_custom -> tu_date
.

Record tr_doc : Type := cr_doc {
  fld_doc_preamble : option ts_preamble;
  fld_doc_title    : option ts_title;
  fld_doc_authors  : option ts_authors;
  fld_doc_date     : option tu_date;
  fld_doc_abstract : option ts_abstract;
  fld_doc_main     : tu_doc_main;
  fld_doc_refs     : option ts_refs;
}.
