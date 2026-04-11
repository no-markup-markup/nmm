(** An abstract syntax tree specification for parsed nmm source-code. *)

type tr_doc = {
  fld_doc_preamble : ts_preamble option;
  fld_doc_title : ts_title option;
  fld_doc_authors: ts_authors option;
  fld_doc_date : tu_date option;
  fld_doc_abstract : ts_abstract option;
  fld_doc_main : tu_doc_main;
  fld_doc_refs : ts_refs option;
}

and ts_preamble = Cs_preamble of string

and ts_title = Cs_title of string

and ts_authors = Cs_authors of (ts_author list)

and ts_author = Cs_author of string

and tu_date = Cu_date_auto of ts_date_auto | Cu_date_custom of ts_date_custom

and ts_date_auto = Cs_date_auto

and ts_date_custom = Cs_date_custom of string

and ts_abstract = Cs_abstract of ts_blks

and tu_doc_main =
  | Cu_doc_main_chs of ts_chs
  | Cu_doc_main_secs of ts_secs
  | Cu_doc_main_pars of ts_pars
  | Cu_doc_main_blks of ts_blks

and ts_refs = Cs_refs of ts_blks

and ts_chs = Cs_chs of tr_ch list

and ts_secs = Cs_secs of tr_sec list

and ts_pars = Cs_pars of tu_par list

and ts_blks = Cs_blks of tu_blk list

and tr_ch = {
  fld_ch_tag_or_id : tu_tag_or_id option;
  fld_ch_hdr : ts_hdr option;
  fld_ch_main : tu_secs_pars_or_blks;
}

and tr_sec = {
  fld_sec_tag_or_id : tu_tag_or_id option;
  fld_sec_hdr : ts_hdr option;
  fld_sec_main : tu_pars_or_blks;
}

and tu_par = Cu_par_std of tr_par_std | Cu_par_rpt of ts_par_rpt

and ts_par_rpt = Cs_par_rpt of tr_id

and tr_par_std = {
  fld_par_tag_or_id : tu_tag_or_id option;
  fld_par_hdr : ts_hdr option;
  fld_par_main : ts_blks;
}

and tu_blk =
  | Cu_blk_txt of ts_blk_txt
  | Cu_blk_blt of ts_blk_blt
  | Cu_blk_itm of tr_blk_itm
  | Cu_blk_dsp of ts_blk_dsp
  | Cu_blk_vrb of ts_blk_vrb
  | Cu_blk_ftn of tr_blk_ftn

and tu_secs_pars_or_blks =
  | Cu_secs_pars_or_blks_secs of ts_secs
  | Cu_secs_pars_or_blks_pars of ts_pars
  | Cu_secs_pars_or_blks_blks of ts_blks

and tu_pars_or_blks =
  | Cu_pars_or_blks_pars of ts_pars
  | Cu_pars_or_blks_blks of ts_blks

and tu_tag_or_id = Cu_tag_or_id_tag of ts_tag | Cu_tag_or_id_id of tr_id

and tr_id = {
  fld_id_tag : ts_tag;
  fld_id_name: ts_name;
  fld_id_scope : tu_scope option;
}

and ts_tag = Cs_tag of string

and ts_name = Cs_name of string


and tu_scope = Cu_scope_gbl | Cu_scope_ch | Cu_scope_sec | Cu_scope_app | Cu_scope_par

and ts_hdr = Cs_hdr of ts_txt_units

and ts_blk_txt = Cs_blk_txt of ts_txt_units

and ts_txt_units = Cs_txt_units of tu_txt_unit list

and tu_txt_unit =
  | Cu_txt_unit_wysiwyg of ts_txt_unit_wysiwyg
  | Cu_txt_unit_emph of ts_txt_unit_emph
  | Cu_txt_unit_c_ref of ts_txt_unit_c_ref
  | Cu_txt_unit_ftn_ref of ts_txt_unit_ftn_ref
  | Cu_txt_unit_ftn_inline of ts_txt_unit_ftn_inline

and ts_txt_unit_wysiwyg = Cs_txt_unit_wysiwyg of string

and ts_txt_unit_emph = Cs_txt_unit_emph of string

and ts_txt_unit_c_ref = Cs_txt_unit_c_ref of ts_c_ref

and ts_txt_unit_ftn_ref = Cs_txt_unit_ftn_ref of ts_ftn_ref

and ts_txt_unit_ftn_inline = Cs_txt_unit_ftn_inline  of ts_ftn_inline

and ts_c_ref = Cs_c_ref of tr_id

and ts_ftn_ref = Cs_ftn_ref of (tr_id * ts_int)

and ts_ftn_inline = Cs_ftn_inline of (ts_blks * ts_int)

and ts_int = Cs_int of int


and ts_blk_dsp = Cs_blk_dsp of ts_dsp_lines

and ts_dsp_lines = Cs_dsp_lines of tr_dsp_line list

and tr_dsp_line = {
  fld_dsp_line_lbl : tu_lbl option;
  fld_dsp_line_id : tr_id option;
  fld_dsp_line_units : ts_txt_units;
}

and tr_blk_itm = { 
  fld_blk_itm_lbl: tu_lbl; 
  fld_blk_itm_id : tr_id option;
  fld_blk_itm_main : ts_blks;
}

and ts_blk_blt = Cs_blk_blt of ts_blks

and ts_blk_vrb = Cs_blk_vrb of ts_vrb_lines

and tr_blk_ftn = {
  fld_blk_ftn_id : tr_id;
  fld_blk_ftn_main : ts_blks;
}


and ts_vrb_lines = Cs_vrb_lines of (ts_vrb_line list)

and ts_vrb_line = Cs_vrb_line of string

and tu_lbl = Cu_lbl_auto of ts_lbl_auto | Cu_lbl_custom of ts_lbl_custom

and ts_lbl_auto = Cs_lbl_auto

and ts_lbl_custom = Cs_lbl_custom of string


