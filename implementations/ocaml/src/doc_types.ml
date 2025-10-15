type tr_doc = {
  fld_doc_preamble : ts_preamble option;
  fld_doc_title	: ts_title option;
  fld_doc_author: ts_author option;
  fld_doc_abstract : ts_abstract option;
  fld_doc_main : te_doc_main;
  fld_doc_refs : ts_refs option;
}

and ts_preamble = Cs_preamble of string

and ts_title = Cs_title of string

and ts_author = Cs_author of string

and ts_abstract = Cs_abstract of ts_blks_txt

and ts_blks_txt = Cs_blks_txt of ts_blk_txt list

and te_doc_main =
  | Ce_doc_main_chs of ts_chs
  | Ce_doc_main_secs of ts_secs
  | Ce_doc_main_pars of ts_pars
  | Ce_doc_main_blks of ts_blks

and ts_refs = Cs_refs of ts_blks

and ts_chs = Cs_chs of tr_ch list

and ts_secs = Cs_secs of tr_sec list

and ts_pars = Cs_pars of tr_par list

and ts_blks = Cs_blks of te_blk list

and tr_ch = {
  fld_ch_tag_or_id : te_tag_or_id option;
  fld_ch_hdr : ts_hdr option;
  fld_ch_main : te_secs_pars_or_blks;
}

and tr_sec = {
  fld_sec_tag_or_id : te_tag_or_id option;
  fld_sec_hdr : ts_hdr option;
  fld_sec_main : te_pars_or_blks;
}

and tr_par = {
  fld_par_tag_or_id : te_tag_or_id option;
  fld_par_hdr : ts_hdr option;
  fld_par_main : ts_blks;
}

and te_blk =
  | Ce_blk_txt of ts_blk_txt
  | Ce_blk_blt of ts_blk_blt
  | Ce_blk_itm of tr_blk_itm
  | Ce_blk_dsp of ts_blk_dsp

and te_secs_pars_or_blks =
  | Ce_secs_pars_or_blks_secs of ts_secs
  | Ce_secs_pars_or_blks_pars of ts_pars
  | Ce_secs_pars_or_blks_blks of ts_blks

and te_pars_or_blks =
  | Ce_pars_or_blks_pars of ts_pars
  | Ce_pars_or_blks_blks of ts_blks

and te_tag_or_id = Ce_tag_or_id_tag of ts_tag | Ce_tag_or_id_id of tr_id

and tr_id = {
  fld_id_tag : ts_tag;
  fld_id_name: ts_name;
}

and ts_tag = Cs_tag of string

and ts_name = Cs_name of string

and ts_hdr = Cs_hdr of ts_txt_units

and ts_blk_txt = Cs_blk_txt of ts_txt_units

and ts_txt_units = Cs_txt_units of te_txt_unit list

and te_txt_unit =
  | Ce_txt_unit_wysiwyg of ts_txt_unit_wysiwyg
  | Ce_txt_unit_emph of ts_txt_unit_emph
  | Ce_txt_unit_c_ref of ts_txt_unit_c_ref

and ts_txt_unit_wysiwyg = Cs_txt_unit_wysiwyg of string

and ts_txt_unit_emph = Cs_txt_unit_emph of string

and ts_txt_unit_c_ref = Cs_txt_unit_c_ref of ts_c_ref

and ts_c_ref = Cs_c_ref of tr_id

and ts_blk_dsp = Cs_blk_dsp of ts_dsp_lines

and ts_dsp_lines = Cs_dsp_lines of tr_dsp_line list

and tr_dsp_line = {
  fld_dsp_line_lbl : te_lbl option;
  fld_dsp_line_id : tr_id option;
  fld_dsp_line_units : ts_txt_units;
}

and tr_blk_itm = { 
  fld_blk_itm_lbl: te_lbl; 
  fld_blk_itm_id : tr_id option;
  fld_blk_itm_main : ts_blks;
}

and ts_blk_blt = Cs_blk_blt of ts_blks

and te_lbl = Ce_lbl_auto of ts_lbl_auto | Ce_lbl_custom of ts_lbl_custom

and ts_lbl_auto = Cs_lbl_auto

and ts_lbl_custom = Cs_lbl_custom of string

and te_c_ref_type = Ce_c_ref_type_lcl | Ce_c_ref_type_gbl


