:- module nmm.parser.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% SUBMODULES

:- include_module parser.test, parser.helpers, parser.operators.


%% MODULE IMPORTS

:- use_module term_to_xml, nmm.lexer.


%% ALIAS TYPE TA_LVL (= UINT)

:- type ta_lvl == uint.


%% TYPE ABBREVIATIONS TU_TKN AND TS_TKNS

:- type tu_tkn  == nmm.lexer.tu_tkn.
:- type ts_tkns == nmm.lexer.ts_tkns.


%% SIMPLE TYPE ALLOWED_TAGS

:- type ts_allowed_tags ---> cs_allowed_tags(list(str)).


%% UNION TYPE TU_TAG_TYPE

:- type tu_tag_type --->
  cu_tag_type_ch;
  cu_tag_type_sec;
  cu_tag_type_par;
  cu_tag_type_itm;
  cu_tag_type_dsp;
  cu_tag_type_nte;
  cu_tag_type_c_ref;
  cu_tag_type_nte_ref;
  cu_tag_type_par_rpt_ref.


%% RULE R_DOC, TYPE TR_DOC, INSTANCE TR_DOC XMLABLE

:- type tr_doc ---> cr_doc(
  fld_doc_preamble :: maybe(ts_preamble),
  fld_doc_title    :: maybe(ts_title),
  fld_doc_authors  :: maybe(ts_authors),
  fld_doc_date     :: maybe(tu_date),
  fld_doc_abstract :: maybe(ts_abstract),
  fld_doc_main     :: tu_doc_main,
  fld_doc_refs     :: maybe(ts_refs)
).

:- instance term_to_xml.xmlable(tr_doc).

:- pred r_doc(ts_allowed_tags, tr_doc, ts_tkns, ts_tkns).
:- mode r_doc(in,              out,    in,      out) is semidet.


%% RULE R_PREAMBLE (TODO), SIMPLE TYPE TS_PREAMBLE, INSTANCE TS_PREAMBLE XMLABLE

:- type ts_preamble ---> cs_preamble(str).

:- instance term_to_xml.xmlable(ts_preamble).

:- pred r_preamble(ts_preamble, ts_tkns, ts_tkns).
:- mode r_preamble(out,         in,      out) is semidet.


%% RULE R_TITLE, SIMPLE TYPE TS_TITLE, INSTANCE TS_TITLE XMLABLE

:- type ts_title ---> cs_title(str).

:- instance term_to_xml.xmlable(ts_title).

:- pred r_title(ts_title, ts_tkns, ts_tkns).
:- mode r_title(out,      in,      out) is semidet.


%% RULE R_AUTHORS, SIMPLE TYPE TS_AUTHORS, INSTANCE TS_AUTHORS XMLABLE

:- type ts_authors ---> cs_authors(list(ts_author)).

:- instance term_to_xml.xmlable(ts_authors).

:- pred r_authors(ts_authors, ts_tkns, ts_tkns).
:- mode r_authors(out,        in,      out) is semidet.


%% RULE R_AUTHOR, SIMPLE TYPE TS_AUTHOR, INSTANCE TS_AUTHOR XMLABLE

:- type ts_author ---> cs_author(str).

:- instance term_to_xml.xmlable(ts_author).

:- pred r_author(ts_author, ts_tkns, ts_tkns).
:- mode r_author(out,       in,      out) is semidet.


%% SIMPLE TYPE TS_DATE_AUTO, INSTANCE TS_DATE_CUSTOM XMLABLE

:- type ts_date_auto ---> cs_date_auto.

:- instance term_to_xml.xmlable(ts_date_auto).


%% SIMPLE TYPE TS_DATE_CUSTOM, INSTANCE TS_DATE_CUSTOM XMLABLE

:- type ts_date_custom ---> cs_date_custom(str).

:- instance term_to_xml.xmlable(ts_date_custom).


%% RULE R_DATE, UNION TYPE TU_DATE, INSTANCE TU_DATE XMLABLE

:- type tu_date --->
  cu_date_auto(ts_date_auto)
  ;
  cu_date_custom(ts_date_custom)
  .

:- instance term_to_xml.xmlable(tu_date).

:- pred r_date(tu_date, ts_tkns, ts_tkns).
:- mode r_date(out,     in,      out) is semidet.


%% RULE R_ABSTRACT, SIMPLE TYPE TS_ABSTRACT, INSTANCE TS_ABSTRACT XMLABLE

:- type ts_abstract ---> cs_abstract(ts_blks).

:- instance term_to_xml.xmlable(ts_abstract).

:- pred r_abstract(ts_allowed_tags, ts_abstract, ts_tkns, ts_tkns).
:- mode r_abstract(in,              out,         in,      out) is semidet.


%% RULE R_REFS, SIMPLE TYPE TS_REFS, INSTANCE TS_REFS XMLABLE

:- type ts_refs ---> cs_refs(ts_blks).

:- instance term_to_xml.xmlable(ts_refs).

:- pred r_refs(ts_allowed_tags, ts_refs, ts_tkns, ts_tkns).
:- mode r_refs(in,              out,     in,      out) is semidet.

:- pred r_refs_start_marker(ts_tkns, ts_tkns).
:- mode r_refs_start_marker(in,      out) is semidet.


%% RULE R_DOC_MAIN, UNION TYPE TU_DOC_MAIN, INSTANCE TU_DOC_MAIN XMLABLE

:- type tu_doc_main --->
  cu_doc_main_chs(ts_chs);
  cu_doc_main_secs(ts_secs);
  cu_doc_main_pars(ts_pars);
  cu_doc_main_blks(ts_blks).

:- instance term_to_xml.xmlable(tu_doc_main).

:- pred r_doc_main(ts_allowed_tags, tu_doc_main, ts_tkns, ts_tkns).
:- mode r_doc_main(in,              out,         in,      out) is semidet.


%% RULE R_CHS, SIMPLE TYPE TS_CHS, INSTANCE TS_CHS_XMLABLE

:- type ts_chs ---> cs_chs(list(tr_ch)).

:- instance term_to_xml.xmlable(ts_chs).

:- pred r_chs(ts_allowed_tags, ts_chs, ts_tkns, ts_tkns).
:- mode r_chs(in,              out,    in,      out) is semidet.


%% RULE R_SECS, SIMPLE TYPE TS_SECS, INSTANCE TS_SECS_XMLABLE

:- type ts_secs ---> cs_secs(list(tr_sec)).

:- instance term_to_xml.xmlable(ts_secs).

:- pred r_secs(ts_allowed_tags, ts_secs, ts_tkns, ts_tkns).
:- mode r_secs(in,               out,    in,      out) is semidet.


%% RULE R_PARS, SIMPLE TYPE TS_PARS, INSTANCE TS_PAR_XMLABLE

:- type ts_pars ---> cs_pars(list(tu_par)).

:- instance term_to_xml.xmlable(ts_pars).

:- pred r_pars(ts_allowed_tags, ts_pars, ts_tkns, ts_tkns).
:- mode r_pars(in,              out,     in,      out) is semidet.


%% RULE R_BLKS, SIMPLE TYPE TS_BLKS, INSTANCE TS_BLKS_XMLABLE

:- type ts_blks ---> cs_blks(list(tu_blk)).

:- instance term_to_xml.xmlable(ts_blks).

:- pred r_blks(ts_allowed_tags, ta_lvl, ts_blks, ts_tkns, ts_tkns).
:- mode r_blks(in,              in,     out,     in,      out) is semidet.


%% RULE R_CH, RECORD TYPE TR_CH, INSTANCE TR_CH XMLABLE

:- type tr_ch ---> cr_ch(
  fld_ch_tag_or_id :: maybe(tu_tag_or_id),
  fld_ch_hdr       :: maybe(ts_hdr),
  fld_ch_main      :: tu_secs_pars_or_blks
).

:- instance term_to_xml.xmlable(tr_ch).

:- pred r_ch(ts_allowed_tags, tr_ch,  ts_tkns, ts_tkns).
:- mode r_ch(in,              out,    in,      out) is semidet.


%% RULE R_SEC, RECORD TYPE TR_SEC, INSTANCE TR_SEC XMLABLE

:- type tr_sec ---> cr_sec(
  fld_sec_tag_or_id :: maybe(tu_tag_or_id),
  fld_sec_hdr       :: maybe(ts_hdr),
  fld_sec_main      :: tu_pars_or_blks
).

:- instance term_to_xml.xmlable(tr_sec).

:- pred r_sec(ts_allowed_tags, tr_sec, ts_tkns, ts_tkns).
:- mode r_sec(in,              out,    in,      out) is semidet.


%% RULE R_PAR, UNION TYPE TU_PAR, INSTANCE TU_PAR XMLABLE

:- type tu_par --->
  cu_par_std(tr_par_std);
  cu_par_rpt(ts_par_rpt).

:- instance term_to_xml.xmlable(tu_par).

:- pred r_par(ts_allowed_tags, tu_par, ts_tkns, ts_tkns).
:- mode r_par(in,              out,    in,      out) is semidet.


%% RULE R_PAR_STD, RECORD TYPE TR_PAR_STD, INSTANCE TR_PAR_STD XMLABLE

:- type tr_par_std ---> cr_par_std(
  fld_par_tag_or_id :: maybe(tu_tag_or_id),
  fld_par_hdr       :: maybe(ts_hdr),
  fld_par_main      :: ts_blks
).

:- instance term_to_xml.xmlable(tr_par_std).

:- pred r_par_std(ts_allowed_tags, tr_par_std, ts_tkns, ts_tkns).
:- mode r_par_std(in,              out,        in,      out) is semidet.


%% RULE R_PAR_RPT, SIMPLE TYPE TS_PAR_RPT, INSTANCE TS_PAR_RPT XMLABLE

:- type ts_par_rpt ---> cs_par_rpt(tr_id).

:- instance term_to_xml.xmlable(ts_par_rpt).

:- pred r_par_rpt(ts_allowed_tags, ts_par_rpt, ts_tkns, ts_tkns).
:- mode r_par_rpt(in,              out,        in,      out) is semidet.


%% RULE R_BLK, UNION TYPE TU_BLK, INSTANCE TU_BLK XMLABLE

:- type tu_blk --->
  cu_blk_txt(ts_blk_txt)
  ;
  cu_blk_blt(ts_blk_blt)
  ;
  cu_blk_itm(tr_blk_itm)
  ;
  cu_blk_dsp(ts_blk_dsp)
  ;
  cu_blk_vrb(ts_blk_vrb)
  ;
  cu_blk_nte(tr_blk_nte)
  .

:- instance term_to_xml.xmlable(tu_blk).

:- pred r_blk(ts_allowed_tags, ta_lvl, tu_blk, ts_tkns, ts_tkns).
:- mode r_blk(in,              in,     out,    in,      out) is semidet.


%% RULE R_HDR, SIMPLE TYPE TS_HDR, INSTANCE TS_HDR XMLABLE

:- type ts_hdr ---> cs_hdr(ts_txt_units).

:- instance term_to_xml.xmlable(ts_hdr).

:- pred r_hdr(ts_allowed_tags, ts_hdr, ts_tkns, ts_tkns).
:- mode r_hdr(in,              out,    in,      out) is semidet.


%% RULE R_SECS_PARS_OR_BLKS, UNION TYPE TU_SECS_PARS_OR_BLKS, INSTANCE TU_SECS_PARS_OR_BLKS XMLABLE

:- type tu_secs_pars_or_blks ---> (
  cu_secs_pars_or_blks_secs(ts_secs);
  cu_secs_pars_or_blks_pars(ts_pars);
  cu_secs_pars_or_blks_blks(ts_blks)
).

:- instance term_to_xml.xmlable(tu_secs_pars_or_blks).

:- pred r_secs_pars_or_blks(
  ts_allowed_tags, tu_secs_pars_or_blks, ts_tkns, ts_tkns
).
:- mode r_secs_pars_or_blks(
  in,              out,                  in,      out
) is semidet.


%% RULE R_PARS_OR_BLKS, UNION TYPE TU_PARS_OR_BLKS, INSTANCE TU_PARS_OR_BLKS XMLABLE

:- type tu_pars_or_blks ---> (
  cu_pars_or_blks_pars(ts_pars);
  cu_pars_or_blks_blks(ts_blks)
).

:- instance term_to_xml.xmlable(tu_pars_or_blks).

:- pred r_pars_or_blks(ts_allowed_tags, tu_pars_or_blks, ts_tkns, ts_tkns).
:- mode r_pars_or_blks(
                       in,              out,             in,      out
) is semidet.


%% RULE R_TXT_UNIT, UNION TYPE TU_TXT_UNIT, INSTANCE TU_TXT_UNIT XMLABLE

:- type tu_txt_unit --->
  cu_txt_unit_c_ref(ts_txt_unit_c_ref);
  cu_txt_unit_nte_ref(ts_txt_unit_nte_ref);
  cu_txt_unit_emph(ts_txt_unit_emph);
  cu_txt_unit_wysiwyg(ts_txt_unit_wysiwyg).

:- instance term_to_xml.xmlable(tu_txt_unit).

:- pred r_txt_unit(ts_allowed_tags, ta_lvl, tu_txt_unit, ts_tkns, ts_tkns).
:- mode r_txt_unit(
                   in,              in,     out,         in,      out
) is semidet.


%% RULE R_TXT_UNIT_EMPH, SIMPLE TYPE TS_TXT_UNIT_EMPH, INSTANCE TS_TXT_UNIT_EMPH XMLABLE

:- type ts_txt_unit_emph ---> cs_txt_unit_emph(str).

:- instance term_to_xml.xmlable(ts_txt_unit_emph).

:- pred r_txt_unit_emph(ta_lvl, ts_txt_unit_emph, ts_tkns, ts_tkns).
:- mode r_txt_unit_emph(in,     out,              in,      out) is semidet.

%% RULE R_TXT_UNIT_WYSIWYG, SIMPLE TYPE TS_TXT_UNIT_WYSIWYG, INSTANCE TS_TXT_UNIT_WYSIWYG XMLABLE

:- type ts_txt_unit_wysiwyg ---> cs_txt_unit_wysiwyg(str).

:- instance term_to_xml.xmlable(ts_txt_unit_wysiwyg).

:- pred r_txt_unit_wysiwyg(
  ts_allowed_tags, ta_lvl, ts_txt_unit_wysiwyg, ts_tkns, ts_tkns
).
:- mode r_txt_unit_wysiwyg(
  in,              in,     out,                 in,      out
) is semidet.


%% RULE R_TXT_UNIT_C_REF, SIMPLE TYPE TS_TXT_UNIT_C_REF, INSTANCE TS_TXT_UNIT_C_REF XMLABLE

:- pred r_txt_unit_c_ref(ts_allowed_tags, ts_txt_unit_c_ref, ts_tkns, ts_tkns).
:- mode r_txt_unit_c_ref(
                         in,              out,               in,      out
) is semidet.

:- type ts_txt_unit_c_ref ---> cs_txt_unit_c_ref(ts_c_ref).

:- instance term_to_xml.xmlable(ts_txt_unit_c_ref).


%% RULE R_TXT_UNIT_NTE_REF, SIMPLE TYPE TS_TXT_UNIT_NTE_REF, INSTANCE TS_TXT_UNIT_NTE_REF XMLABLE

:- pred r_txt_unit_nte_ref(ts_txt_unit_nte_ref, ts_tkns, ts_tkns).
:- mode r_txt_unit_nte_ref(out,                 in,      out) is semidet.

:- type ts_txt_unit_nte_ref ---> cs_txt_unit_nte_ref(ts_nte_ref).

:- instance term_to_xml.xmlable(ts_txt_unit_nte_ref).


%% RULE R_TXT_UNITS, SIMPLE TYPE TS_TXT_UNITS, INSTANCE TS_TXT_UNITS XMLABLE

:- type ts_txt_units ---> cs_txt_units(list(tu_txt_unit)).

:- instance term_to_xml.xmlable(ts_txt_units).

:- pred r_txt_units(ts_allowed_tags, ta_lvl, ts_txt_units, ts_tkns, ts_tkns).
:- mode r_txt_units(
                    in,              in,     out,          in,      out
) is semidet.


%% RULE R_LBL_AUTO, SIMPLE TYPE TS_LBL_AUTO, INSTANCE TS_LBL_AUTO XMLABLE

:- type ts_lbl_auto ---> cs_lbl_auto.

:- instance term_to_xml.xmlable(ts_lbl_auto).

:- pred r_lbl_auto(ts_lbl_auto::out, ts_tkns::in, ts_tkns::out) is det.


%% RULE R_LBL_CUSTOM, SIMPLE TYPE TS_LBL_CUSTOM, INSTANCE TS_LBL_CUSTOM XMLABLE

:- type ts_lbl_custom ---> cs_lbl_custom(str).

:- instance term_to_xml.xmlable(ts_lbl_custom).

:- pred r_lbl_custom(ts_lbl_custom::out, ts_tkns::in, ts_tkns::out) is semidet.


%% RULE R_LBL, UNION TYPE TU_LBL, INSTANCE TU_LBL XMLABLE

:- type tu_lbl --->
  cu_lbl_auto(ts_lbl_auto);
  cu_lbl_custom(ts_lbl_custom).

:- instance term_to_xml.xmlable(tu_lbl).

:- pred r_lbl(tu_lbl::out, ts_tkns::in, ts_tkns::out) is det.


%% RULE R_TAG_OR_ID, UNION TYPE TU_TAG_OR_ID, INSTANCE TU_TAG_OR_ID_XMLABLE

:- type tu_tag_or_id --->
  cu_tag_or_id_tag(ts_tag);
  cu_tag_or_id_id(tr_id).

:- instance term_to_xml.xmlable(tu_tag_or_id).

:- pred r_tag_or_id(
  ts_allowed_tags, tu_tag_type, tu_tag_or_id, ts_tkns, ts_tkns
).
:- mode r_tag_or_id(
  in,              in,          out,          in,      out
) is semidet.

%% RULE R_TAG, SIMPLE TYPE TS_TAG, INSTANCE TS_TAG XMLABLE

:- type ts_tag ---> cs_tag(str).

:- instance term_to_xml.xmlable(ts_tag).

:- pred r_tag(ts_allowed_tags, tu_tag_type, ts_tag, ts_tkns, ts_tkns).
:- mode r_tag(
              in,              in,          out,    in,      out
)is semidet.

%% RULE R_NAME, SIMPLE TYPE TS_NAME, INSTANCE TS_NAME XMLABLE

:- type ts_name ---> cs_name(str).

:- instance term_to_xml.xmlable(ts_name).

:- pred r_name(ts_name::out, ts_tkns::in, ts_tkns::out) is semidet.

%% RULE R_SCOPE, UNION TYPE TU_SCOPE, INSTANCE TU_SCOPE XMLABLE

:- type tu_scope --->
  cu_scope_gbl;
  cu_scope_ch;
  cu_scope_sec;
  cu_scope_par.

:- instance term_to_xml.xmlable(tu_scope).

:- pred r_scope(tu_scope::out, ts_tkns::in, ts_tkns::out) is semidet.


%% RULE R_ID, RECORD TYPE TR_ID, INSTANCE TR_ID XMLABLE

:- type tr_id ---> cr_id(
  fld_id_tag   :: ts_tag,
  fld_id_name  :: ts_name,
  fld_id_scope :: maybe(tu_scope)
).

:- instance term_to_xml.xmlable(tr_id).

:- pred r_id(ts_allowed_tags, tu_tag_type, tr_id, ts_tkns, ts_tkns).
:- mode r_id(in,              in,          out,   in,      out) is semidet.

%% RULE R_C_REF, SIMPLE TYPE TS_C_REF, INSTANCE TS_C_REF XMLABLE

:-type ts_c_ref ---> cs_c_ref(tr_id).

:- instance term_to_xml.xmlable(ts_c_ref).

:- pred r_c_ref(
  ts_allowed_tags::in, ts_c_ref::out, ts_tkns::in, ts_tkns::out
) is semidet.


%% RULE R_NTE_REF, SIMPLE TYPE TS_NTE_REF, INSTANCE TS_NTE_REF XMLABLE

:- type ts_nte_ref ---> cs_nte_ref(tr_id).

:- instance term_to_xml.xmlable(ts_nte_ref).

:- pred r_nte_ref(ts_nte_ref, ts_tkns, ts_tkns).
:- mode r_nte_ref(out,        in,      out) is semidet.


%% RULE R_BLK_TXT, SIMPLE TYPE TS_BLK_TXT, INSTANCE TS_BLK_TXT XMLABLE

:- type ts_blk_txt ---> cs_blk_txt(ts_txt_units).

:- instance term_to_xml.xmlable(ts_blk_txt).

:- pred r_blk_txt(ts_allowed_tags, ta_lvl, ts_blk_txt, ts_tkns, ts_tkns).
:- mode r_blk_txt(in,              in,     out,        in,      out) is semidet.

%% RULE R_BLK_BLT, SIMPLE TYPE TS_BLK_BLT, INSTANCE TS_BLK_BLT XMLABLE

:- type ts_blk_blt ---> cs_blk_blt(ts_blks).

:- instance term_to_xml.xmlable(ts_blk_blt).

:- pred r_blk_blt(ts_allowed_tags, ta_lvl, ts_blk_blt, ts_tkns, ts_tkns).
:- mode r_blk_blt(in,              in,     out,        in,      out) is semidet.


%% RULE R_BLK_ITM, RECORD TYPE TR_BLK_ITM, INSTANCE TR_BLK_ITM XMLABLE

:- type tr_blk_itm ---> cr_blk_itm(
  fld_blk_itm_lbl       :: tu_lbl,
  fld_blk_itm_tag_or_id :: maybe(tu_tag_or_id),
  fld_blk_itm_main      :: ts_blks
).

:- instance term_to_xml.xmlable(tr_blk_itm).

:- pred r_blk_itm(ts_allowed_tags, ta_lvl, tr_blk_itm, ts_tkns, ts_tkns).
:- mode r_blk_itm(in,              in,     out,        in,      out) is semidet.

%% RULE R_BLK_DSP, SIMPLE TYPE TS_BLK_DSP, INSTANCE TS_BLK_DSP XMLABLE

:- type ts_blk_dsp ---> cs_blk_dsp(ts_dsp_lines).

:- instance term_to_xml.xmlable(ts_blk_dsp).

:- pred r_blk_dsp(ts_allowed_tags, ta_lvl, ts_blk_dsp, ts_tkns, ts_tkns).
:- mode r_blk_dsp(
                  in,              in,     out,        in,      out
) is semidet.


%% RULE R_BLK_VRB, SIMPLE TYPE TS_BLK_VRB, INSTANCE TS_BLK_VRB XMLABLE

:- type ts_blk_vrb ---> cs_blk_vrb(ts_vrb_lines).

:- instance term_to_xml.xmlable(ts_blk_vrb).

:- pred r_blk_vrb(ta_lvl, ts_blk_vrb, ts_tkns, ts_tkns).
:- mode r_blk_vrb(in,     out,        in,      out) is semidet.


%% RULE R_BLK_NTE, RECORD TYPE TR_BLK_NTE, INSTANCE TR_BLK_NTE XMLABLE

:- type tr_blk_nte ---> cr_blk_nte(
  fld_blk_nte_id   :: tr_id,
  fld_blk_nte_main :: ts_blks
).

:- instance term_to_xml.xmlable(tr_blk_nte).

:- pred r_blk_nte(ts_allowed_tags, ta_lvl, tr_blk_nte, ts_tkns, ts_tkns).
:- mode r_blk_nte(in,              in,     out,        in,      out) is semidet.


%% RULE R_DSP_LINES, SIMPLE TYPE TS_DSP_LINES, INSTANCE TS_DSP_LINES XMLABLE

:- type ts_dsp_lines ---> cs_dsp_lines(list(tu_dsp_line)).

:- instance term_to_xml.xmlable(ts_dsp_lines).

:- pred r_dsp_lines(ts_allowed_tags, ta_lvl, ts_dsp_lines, ts_tkns, ts_tkns).
:- mode r_dsp_lines(
                    in,              in,     out,          in,      out
) is semidet.


%% RULE R_DSP_LINE, UNION TYPE TU_DSP_LINE, INSTANCE TU_DSP_LINE XMLABLE

:- type tu_dsp_line --->
  cu_dsp_line_lbld(tr_dsp_line_lbld);
  cu_dsp_line_no_lbl(ts_dsp_line_no_lbl).

:- instance term_to_xml.xmlable(tu_dsp_line).

:- pred r_dsp_line(ts_allowed_tags, tu_dsp_line, ts_tkns, ts_tkns).
:- mode r_dsp_line(in,              out,         in,      out) is semidet.

%% RULE R_DSP_LINE_LBLD, RECORD TYPE TR_DSP_LINE_LBLD, INSTANCE TR_DSP_LINE_LBLD XMLABLE

:- type tr_dsp_line_lbld ---> cr_dsp_line_lbld(
  fld_dsp_line_lbld_lbl   :: tu_lbl,
  fld_dsp_line_lbld_id    :: maybe(tr_id),
  fld_dsp_line_lbld_units :: ts_txt_units
).

:- instance term_to_xml.xmlable(tr_dsp_line_lbld).

:- pred r_dsp_line_lbld(ts_allowed_tags, tr_dsp_line_lbld, ts_tkns, ts_tkns).
:- mode r_dsp_line_lbld(
                        in,              out,              in,      out
) is semidet.


%% RULE R_DSP_LINE_NO_LBL, SIMPLE TYPE TS_DSP_LINE_NO_LBL, INSTANCE TS_DSP_LINE_NO_LBL XMLABLE

:- type ts_dsp_line_no_lbl ---> cs_dsp_line_no_lbl(ts_txt_units).

:- instance term_to_xml.xmlable(ts_dsp_line_no_lbl).

:- pred r_dsp_line_no_lbl(
  ts_allowed_tags, ts_dsp_line_no_lbl, ts_tkns, ts_tkns
).
:- mode r_dsp_line_no_lbl(
  in,              out,                in,      out
) is semidet.


%% RULE R_DSP_UNIT

:- pred r_dsp_unit(ts_allowed_tags, tu_txt_unit, ts_tkns, ts_tkns).
:- mode r_dsp_unit(in,              out,         in,      out) is semidet.


%% SIMPLE TYPE TS_VRB_LINES, INSTANCE TS_VRB_LINES XMLABLE

:- type ts_vrb_lines ---> cs_vrb_lines(list(ts_vrb_line)).

:- instance term_to_xml.xmlable(ts_vrb_lines).


%% RULE R_VRB_LINE, SIMPLE TYPE TS_VRB_LINE, INSTANCE TS_VRB_LINE XMLABLE

:- type ts_vrb_line ---> cs_vrb_line(str).

:- instance term_to_xml.xmlable(ts_vrb_line).

:- pred r_vrb_line(ta_lvl, ts_vrb_line, ts_tkns, ts_tkns).
:- mode r_vrb_line(in,     out,         in,      out) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module bool, exception, nmm.parser.operators.

:- import_module
  uint
  ,
  nmm.parser.helpers
  ,
  nmm.parser.operators.plus
  ,
  nmm.parser.operators.q_mark
  ,
  nmm.parser.operators.star
  .


%% CONSTANT K_FORBIDDEN_STRS_IN_TAGS_NAMES

:- func k_forbidden_strs_in_tags_names = strs.
k_forbidden_strs_in_tags_names = ["\\", "[", "]", "(", ")", ":", ",", ";", "*"].

%% R_DOC, INSTANCE TR_DOC XMLABLE

%%% R_DOC

r_doc(
  ALLOWED_TAGS,
  cr_doc(
    MAYBE_PREAMBLE,
    MAYBE_TITLE,
    MAYBE_AUTHORS,
    MAYBE_DATE,
    MAYBE_ABSTRACT,
    MAIN,
    MAYBE_REFS
  )
) --> (
  ?([],         r_preamble,             MAYBE_PREAMBLE,[*([r_lb])]),
  ?([],         r_title,                MAYBE_TITLE,   [*([r_lb])]),
  ?([],         r_authors,              MAYBE_AUTHORS, [*([r_lb])]),
  ?([],         r_date,                 MAYBE_DATE,    [*([r_lb])]),
  ?([],         r_abstract,ALLOWED_TAGS,MAYBE_ABSTRACT,[*([r_lb])]),
  r_doc_main(ALLOWED_TAGS,MAIN),
  ?([+([r_lb])],r_refs,    ALLOWED_TAGS,MAYBE_REFS,    []),
  *([r_lb]),
  r_eof
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_doc) where [
  func(to_xml/1) is f_doc_to_xml
].
:- func (
  f_doc_to_xml(tr_doc::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_doc_to_xml(DOC) = XML :- (
  (
    (
      fld_doc_preamble(DOC) = maybe.no,
      PREAMBLE_XML_LIST     = []
    );
    (
      fld_doc_preamble(DOC) = maybe.yes(PREAMBLE),
      PREAMBLE_XML_LIST     = [f_preamble_to_xml(PREAMBLE)]
    )
  ),
  (
    (
      fld_doc_title(DOC) = maybe.no,
      TITLE_XML_LIST     = []
    );
    (
      fld_doc_title(DOC) = maybe.yes(TITLE),
      TITLE_XML_LIST     = [f_title_to_xml(TITLE)]
    )
  ),
  (
    (
      fld_doc_authors(DOC) = maybe.no,
      AUTHORS_XML_LIST      = []
    );
    (
      fld_doc_authors(DOC) = maybe.yes(AUTHOR),
      AUTHORS_XML_LIST     = [f_authors_to_xml(AUTHOR)]
    )
  ),
  (
    (
      fld_doc_date(DOC) = maybe.no,
      DATE_XML_LIST     = []
    );
    (
      fld_doc_date(DOC) = maybe.yes(DATE),
      DATE_XML_LIST     = [f_date_to_xml(DATE)]
    )
  ),
  (
    (
      fld_doc_abstract(DOC) = maybe.no,
      ABSTRACT_XML_LIST     = []
    );
    (
      fld_doc_abstract(DOC) = maybe.yes(ABSTRACT),
      ABSTRACT_XML_LIST     = [f_abstract_to_xml(ABSTRACT)]
    )
  ),
  (
    (
      fld_doc_refs(DOC) = maybe.no,
      REFS_XML_LIST     = []
    );
    (
      fld_doc_refs(DOC) = maybe.yes(REFS),
      REFS_XML_LIST     = [f_refs_to_xml(REFS)]
    )
  ),
  XML = term_to_xml.elem(
    "cr_doc",
    [],
    (
      PREAMBLE_XML_LIST
      ++
      TITLE_XML_LIST
      ++
      AUTHORS_XML_LIST
      ++
      DATE_XML_LIST
      ++
      ABSTRACT_XML_LIST
      ++
      [f_doc_main_to_xml(fld_doc_main(DOC))]
      ++
      REFS_XML_LIST
    )
  )
).


%% R_PREAMBLE (TODO), TS_PREAMBLE XMLABLE

%%% R_PREAMBLE

:- pragma no_determinism_warning(r_preamble/3).
r_preamble(_) --> {false}.

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_preamble) where [
  func(to_xml/1) is f_preamble_to_xml
].
:- func (
  f_preamble_to_xml(ts_preamble::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_preamble_to_xml(cs_preamble(STR)) =
  term_to_xml.elem("cs_preamble",[],[term_to_xml.data(STR)]).


%% R_TITLE, TS_TITLE XMLABLE

%%% R_TITLE

r_title(cs_title(STR)) --> (
  r_str("TITLE:"),
  +([r_lb]),
  +([r_tab],r_title_line,LINES,[]),
  {STR = string.join_list(" ",LINES)}
).

:- pred r_title_line(str::out, ts_tkns::in, ts_tkns::out) is semidet.
r_title_line(        LINE) -->
  +([],r_title_line_chr,CS,[]), r_lb, {LINE = chrs2str(CS)}.

% needed because some mode error otherwise
:- pred r_title_line_chr(chr::out, ts_tkns::in, ts_tkns::out) is semidet.
r_title_line_chr(        C) --> r_c(C).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_title) where [
  func(to_xml/1) is f_title_to_xml
].
:- func (
  f_title_to_xml(ts_title::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_title_to_xml(cs_title(STR)) =
  term_to_xml.elem("cs_title",[],[term_to_xml.data(STR)]).


%% R_AUTHORS, TS_AUTHORS XMLABLE

%%% R_AUTHOR

r_authors(cs_authors(AUTHORS)) --> (
  +([],r_author,AUTHORS,[?([r_lb])])
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_authors) where [
  func(to_xml/1) is f_authors_to_xml
].
:- func (
  f_authors_to_xml(ts_authors::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_authors_to_xml(cs_authors(AUTHORS)) =
  term_to_xml.elem("cs_authors",[],list.map(f_author_to_xml,AUTHORS)).


%% R_AUTHOR, TS_AUTHOR XMLABLE

%%% R_AUTHOR

r_author(cs_author(STR)) --> (
  r_str("AUTHOR:"),
  +([r_lb]),
  +([r_tab],r_author_line,LINES,[]),
  {STR = string.join_list(" ",LINES)}
).

:- pred r_author_line(str::out, ts_tkns::in, ts_tkns::out) is semidet.
r_author_line(        LINE) -->
  +([],r_author_line_chr,CS,[]), r_lb, {LINE = chrs2str(CS)}.

% needed because some mode error otherwise
:- pred r_author_line_chr(chr::out, ts_tkns::in, ts_tkns::out) is semidet.
r_author_line_chr(        C) --> r_c(C).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_author) where [
  func(to_xml/1) is f_author_to_xml
].
:- func (
  f_author_to_xml(ts_author::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_author_to_xml(cs_author(STR)) =
  term_to_xml.elem("cs_author",[],[term_to_xml.data(STR)]).


%% TS_DATE_AUTO XMLABLE

:- instance term_to_xml.xmlable(ts_date_auto) where [
  func(to_xml/1) is f_date_auto_to_xml
].
:- func (
  f_date_auto_to_xml(ts_date_auto::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_date_auto_to_xml(cs_date_auto) = term_to_xml.elem("cs_date_auto",[],[]).


%% TS_DATE_CUSTOM XMLABLE

:- instance term_to_xml.xmlable(ts_date_custom) where [
  func(to_xml/1) is f_date_custom_to_xml
].
:- func (
  f_date_custom_to_xml(ts_date_custom::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_date_custom_to_xml(cs_date_custom(STR)) =
  term_to_xml.elem("cs_date_custom",[],[term_to_xml.data(STR)]).


%% R_DATE, TU_DATE XMLABLE

%%% R_DATE

r_date(DATE) --> (
  r_str("DATE:"),
  +([r_lb]),
  r_tab,
  (
    r_str("auto")  -> {DATE = cu_date_auto(cs_date_auto)};
    r(STR)         -> {DATE = cu_date_custom(cs_date_custom(STR))};
                      {false}
  ),
  r_lb
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_date) where [
  func(to_xml/1) is f_date_to_xml
].
:- func (
  f_date_to_xml(tu_date::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_date_to_xml(cu_date_auto(DATE_AUTO))     =
  term_to_xml.elem("cu_date_auto",  [],[f_date_auto_to_xml(DATE_AUTO)]).
f_date_to_xml(cu_date_custom(DATE_CUSTOM)) =
  term_to_xml.elem("cu_date_custom",[],[f_date_custom_to_xml(DATE_CUSTOM)]).


%% R_ABSTRACT, TS_ABSTRACT XMLABLE

%%% R_ABSTRACT

r_abstract(ALLOWED_TAGS,cs_abstract(BLKS)) --> (
  r_str("ABSTRACT:"),
  +([r_lb]),
  r_tab,
  r_blks(ALLOWED_TAGS,1u,BLKS)
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_abstract) where [
  func(to_xml/1) is f_abstract_to_xml
].
:- func (
  f_abstract_to_xml(ts_abstract::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_abstract_to_xml(cs_abstract(BLKS)) =
  term_to_xml.elem("cs_abstract",[],[f_blks_to_xml(BLKS)]).


%% R_REFS, TS_REFS XMLABLE

%%% R_REFS

r_refs(ALLOWED_TAGS,cs_refs(BLKS)) -->
  r_refs_start_marker, +([r_lb]), r_blks(ALLOWED_TAGS,0u,BLKS).

r_refs_start_marker --> (
  r_str("CH"), +([r_sp]), r_str("REFS"), r_lb -> {true};
  r_str("§"),  +([r_sp]), r_str("REFS"), r_lb -> {true};
  r_str("¶"),  +([r_sp]), r_str("REFS"), r_lb -> {true};
                                                 {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_refs) where [
  func(to_xml/1) is f_refs_to_xml
].
:- func (
  f_refs_to_xml(ts_refs::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_refs_to_xml(cs_refs(BLKS)) =
  term_to_xml.elem("cs_refs",[],[f_blks_to_xml(BLKS)]).


%% R_DOC_MAIN, INSTANCE TU_DOC_MAIN XMLABLE

%%% R_DOC_MAIN

r_doc_main(ALLOWED_TAGS,DOC_MAIN) --> (
  r_chs( ALLOWED_TAGS,   CHS)  -> {DOC_MAIN = cu_doc_main_chs( CHS)};
  r_secs(ALLOWED_TAGS,   SECS) -> {DOC_MAIN = cu_doc_main_secs(SECS)};
  r_pars(ALLOWED_TAGS,   PARS) -> {DOC_MAIN = cu_doc_main_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) -> {DOC_MAIN = cu_doc_main_blks(BLKS)};
                                  {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_doc_main) where [
  func(to_xml/1) is f_doc_main_to_xml
].
:- func (
  f_doc_main_to_xml(tu_doc_main::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_doc_main_to_xml(cu_doc_main_chs(CHS))   =
  term_to_xml.elem("cu_doc_main_chs", [],[f_chs_to_xml(CHS)]).
f_doc_main_to_xml(cu_doc_main_secs(SECS)) =
  term_to_xml.elem("cu_doc_main_secs",[],[f_secs_to_xml(SECS)]).
f_doc_main_to_xml(cu_doc_main_pars(PARS)) =
  term_to_xml.elem("cu_doc_main_pars",[],[f_pars_to_xml(PARS)]).
f_doc_main_to_xml(cu_doc_main_blks(BLKS)) =
  term_to_xml.elem("cu_doc_main_blks",[],[f_blks_to_xml(BLKS)]).


%% R_CHS, INSTANCE TS_CHS_XMLABLE

%%% R_CHS

r_chs(ALLOWED_TAGS,CHS) --> (
  r_ch(ALLOWED_TAGS,CH),
  (
    +([r_lb]), r_chs(ALLOWED_TAGS,cs_chs(CHS_)) -> {CHS = cs_chs([CH]++CHS_)};
                                                   {CHS = cs_chs([CH])}
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_chs) where [
  func(to_xml/1) is f_chs_to_xml
].
:- func (
  f_chs_to_xml(ts_chs::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_chs_to_xml(cs_chs(CHS)) = (
  term_to_xml.elem("cs_chs",[],list.map(f_ch_to_xml,CHS))
).


%% R_SECS, INSTANCE TS_SECS_XMLABLE

%%% R_SECS

r_secs(ALLOWED_TAGS,SECS) --> (
  r_sec(ALLOWED_TAGS,SEC),
  (
    +([r_lb]), r_secs(ALLOWED_TAGS,cs_secs(SECS_)) ->
      {SECS = cs_secs([SEC]++SECS_)};
    {SECS = cs_secs([SEC])}
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_secs) where [
  func(to_xml/1) is f_secs_to_xml
].
:- func (
  f_secs_to_xml(ts_secs::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_secs_to_xml(cs_secs(SECS)) = (
  term_to_xml.elem("cs_secs",[],list.map(f_sec_to_xml,SECS))
).


%% R_PARS, INSTANCE TS_PARS_XMLABLE

%%% R_PARS

r_pars(ALLOWED_TAGS,PARS) --> (
  r_par(ALLOWED_TAGS,PAR),
  (
    +([r_lb]), r_pars(ALLOWED_TAGS,cs_pars(PARS_)) ->
      {PARS = cs_pars([PAR]++PARS_)};
    {PARS = cs_pars([PAR])}
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_pars) where [
  func(to_xml/1) is f_pars_to_xml
].
:- func (
  f_pars_to_xml(ts_pars::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_pars_to_xml(cs_pars(PARS)) = (
  term_to_xml.elem("cs_pars",[],list.map(f_par_to_xml,PARS))
).


%% R_BLKS, INSTANCE TS_BLKS_XMLABLE

%%% R_BLKS

r_blks(ALLOWED_TAGS,LVL,BLKS) --> (
  r_blk(ALLOWED_TAGS,LVL,BLK),
  (
    +([r_lb]),r_tabs(LVL),r_blks(ALLOWED_TAGS,LVL,cs_blks(BLKS_)) -> (
      {BLKS = cs_blks([BLK]++BLKS_)}
    );
    {BLKS = cs_blks([BLK])}
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_blks) where [
  func(to_xml/1) is f_blks_to_xml
].
:- func (
  f_blks_to_xml(ts_blks::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blks_to_xml(cs_blks(BLKS)) = (
  term_to_xml.elem("cs_blks",[],list.map(f_blk_to_xml,BLKS))
).


%% R_CH, INSTANCE TR_CH XMLABLE

%%% R_CH

r_ch(ALLOWED_TAGS,cr_ch(MAYBE_TAG_OR_ID,MAYBE_HDR,MAIN)) --> (
  (
    if r_tag_or_id(ALLOWED_TAGS,cu_tag_type_ch,TAG_OR_ID) then
      {MAYBE_TAG_OR_ID = maybe.yes(TAG_OR_ID)}
    else
      r_str("CH"),
      {MAYBE_TAG_OR_ID = maybe.no}
  ),
  r_lb,
  ?([],r_hdr,ALLOWED_TAGS,MAYBE_HDR,[]),
  +([r_lb]),
  r_secs_pars_or_blks(ALLOWED_TAGS,MAIN)
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_ch) where [
  func(to_xml/1) is f_ch_to_xml
].
:- func (
  f_ch_to_xml(tr_ch::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_ch_to_xml(CH) = XML :- (
  (
    (
      fld_ch_tag_or_id(CH) = maybe.no,
      TAG_OR_ID_XML_LIST   = []
    );
    (
      fld_ch_tag_or_id(CH) = maybe.yes(TAG_OR_ID),
      TAG_OR_ID_XML_LIST   = [f_tag_or_id_to_xml(TAG_OR_ID)]
    )
  ),
  (
    (
      fld_ch_hdr(CH) = maybe.no,
      HDR_XML_LIST   = []
    );
    (
      fld_ch_hdr(CH) = maybe.yes(HDR),
      HDR_XML_LIST   = [f_hdr_to_xml(HDR)]
    )
  ),
  SECS_PARS_OR_BLKS = fld_ch_main(CH),
  XML  = term_to_xml.elem(
    "cr_ch",
    [],
    (
      TAG_OR_ID_XML_LIST
      ++
      HDR_XML_LIST
      ++
      [f_secs_pars_or_blks_to_xml(SECS_PARS_OR_BLKS)]
    )
  )
).


%% R_SEC, INSTANCE TR_SEC XMLABLE

%%% R_SEC

r_sec(ALLOWED_TAGS,cr_sec(MAYBE_TAG_OR_ID,MAYBE_HDR,MAIN)) --> (
  r_str("§"),
  ?(
    [*([r_sp])],
    r_tag_or_id,cs_allowed_tags(["SEC","APP"]),cu_tag_type_sec,MAYBE_TAG_OR_ID,
    []
  ),
  r_lb,
  ?([],r_hdr,ALLOWED_TAGS,MAYBE_HDR,[]),
  +([r_lb]),
  r_pars_or_blks(ALLOWED_TAGS,MAIN)
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_sec) where [
  func(to_xml/1) is f_sec_to_xml
].
:- func (
  f_sec_to_xml(tr_sec::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_sec_to_xml(SEC) = XML :- (
  (
    (
      fld_sec_tag_or_id(SEC) = maybe.no,
      TAG_OR_ID_XML_LIST     = []
    );
    (
      fld_sec_tag_or_id(SEC) = maybe.yes(TAG_OR_ID),
      TAG_OR_ID_XML_LIST     = [f_tag_or_id_to_xml(TAG_OR_ID)]
    )
  ),
  (
    (
      fld_sec_hdr(SEC) = maybe.no,
      HDR_XML_LIST     = []
    );
    (
      fld_sec_hdr(SEC) = maybe.yes(HDR),
      HDR_XML_LIST     = [f_hdr_to_xml(HDR)]
    )
  ),
  MAIN = fld_sec_main(SEC),
  XML  = term_to_xml.elem(
    "cr_sec",
    [],
    (
      TAG_OR_ID_XML_LIST
      ++
      HDR_XML_LIST
      ++
      [f_pars_or_blks_to_xml(MAIN)]
    )
  )
).


%% R_PAR, TU_PAR XMLABLE

%%% R_PAR

r_par(ALLOWED_TAGS,PAR) --> (
  r_par_std(ALLOWED_TAGS,PAR_) -> {PAR = cu_par_std(PAR_)};
  r_par_rpt(ALLOWED_TAGS,PAR_) -> {PAR = cu_par_rpt(PAR_)};
                                  {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_par) where [
  func(to_xml/1) is f_par_to_xml
].
:- func (
  f_par_to_xml(tu_par::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_par_to_xml(cu_par_std(PAR)) =
  term_to_xml.elem("cu_par_std",[],[f_par_std_to_xml(PAR)]).
f_par_to_xml(cu_par_rpt(PAR)) =
  term_to_xml.elem("cu_par_rpt",[],[f_par_rpt_to_xml(PAR)]).


%% R_PAR_STD, TR_PAR_STD XMLABLE

%%% R_PAR_STD

r_par_std(ALLOWED_TAGS,cr_par_std(MAYBE_TAG_OR_ID,MAYBE_HDR,BLKS)) -->
  r_str("¶"),
  ?([*([r_sp])],r_tag_or_id,ALLOWED_TAGS,cu_tag_type_par,MAYBE_TAG_OR_ID,[]),
  r_lb,
  ?([],r_hdr,ALLOWED_TAGS,MAYBE_HDR,[]),
  +([r_lb]),
  r_blks(ALLOWED_TAGS,0u,BLKS).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_par_std) where [
  func(to_xml/1) is f_par_std_to_xml
].
:- func (
  f_par_std_to_xml(tr_par_std::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_par_std_to_xml(PAR) = XML :- (
  (
    (
      fld_par_tag_or_id(PAR) = maybe.no,
      TAG_OR_ID_XML_LIST     = []
    );
    (
      fld_par_tag_or_id(PAR) = maybe.yes(TAG_OR_ID),
      TAG_OR_ID_XML_LIST     = [f_tag_or_id_to_xml(TAG_OR_ID)]
    )
  ),
  (
    (
      fld_par_hdr(PAR) = maybe.no,
      HDR_XML_LIST     = []
    );
    (
      fld_par_hdr(PAR) = maybe.yes(HDR),
      HDR_XML_LIST     = [f_hdr_to_xml(HDR)]
    )
  ),
  BLKS = fld_par_main(PAR),
  XML  = term_to_xml.elem(
    "cr_par_std",
    [],
    TAG_OR_ID_XML_LIST++HDR_XML_LIST++[f_blks_to_xml(BLKS)]
  )
).


%% R_PAR_RPT, TS_PAR_RPT XMLABLE

%%% R_PAR_RPT

r_par_rpt(ALLOWED_TAGS,cs_par_rpt(ID)) --> (
  r_str("¶"),
  *([r_sp]),
  r_str("rpt"),
  *([r_sp]),
  r_id(ALLOWED_TAGS,cu_tag_type_par_rpt_ref,ID),
  r_lb
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_par_rpt) where [
  func(to_xml/1) is f_par_rpt_to_xml
].
:- func (
  f_par_rpt_to_xml(ts_par_rpt::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_par_rpt_to_xml(cs_par_rpt(ID)) =
  term_to_xml.elem("cs_par_rpt",[],[f_id_to_xml(ID)]).


%% R_BLK, INSTANCE TU_BLK XMLABLE

%%% R_BLK

r_blk(ALLOWED_TAGS,LVL,BLK) -->
  r_blk_txt(ALLOWED_TAGS,LVL,BLK_TXT) -> {BLK = cu_blk_txt(BLK_TXT)};
  r_blk_blt(ALLOWED_TAGS,LVL,BLK_BLT) -> {BLK = cu_blk_blt(BLK_BLT)};
  r_blk_itm(ALLOWED_TAGS,LVL,BLK_ITM) -> {BLK = cu_blk_itm(BLK_ITM)};
  r_blk_dsp(ALLOWED_TAGS,LVL,BLK_DSP) -> {BLK = cu_blk_dsp(BLK_DSP)};
  r_blk_vrb(             LVL,BLK_VRB) -> {BLK = cu_blk_vrb(BLK_VRB)};
  r_blk_nte(ALLOWED_TAGS,LVL,BLK_NTE) -> {BLK = cu_blk_nte(BLK_NTE)};
                                         {false}.

%%% INSTANCE XMLABLE

:- instance term_to_xml.xmlable(tu_blk) where [
  func(to_xml/1) is f_blk_to_xml
].
:- func (
  f_blk_to_xml(tu_blk::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_to_xml(cu_blk_txt(BLK)) =
  term_to_xml.elem("cu_blk_txt",[],[f_blk_txt_to_xml(BLK)]).
f_blk_to_xml(cu_blk_blt(BLK)) =
  term_to_xml.elem("cu_blk_blt",[],[f_blk_blt_to_xml(BLK)]).
f_blk_to_xml(cu_blk_itm(BLK)) =
  term_to_xml.elem("cu_blk_itm",[],[f_blk_itm_to_xml(BLK)]).
f_blk_to_xml(cu_blk_dsp(BLK)) =
  term_to_xml.elem("cu_blk_dsp",[],[f_blk_dsp_to_xml(BLK)]).
f_blk_to_xml(cu_blk_vrb(BLK)) =
  term_to_xml.elem("cu_blk_vrb",[],[f_blk_vrb_to_xml(BLK)]).
f_blk_to_xml(cu_blk_nte(BLK)) =
  term_to_xml.elem("cu_blk_nte",[],[f_blk_nte_to_xml(BLK)]).


%% R_HDR, INSTANCE TS_HDR XMLABLE

%%% R_HDR

r_hdr(ALLOWED_TAGS,cs_hdr(UNITS)) -->
  r_blk_txt(ALLOWED_TAGS,0u,cs_blk_txt(UNITS)).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_hdr) where [
  func(to_xml/1) is f_hdr_to_xml
].
:- func (
  f_hdr_to_xml(ts_hdr::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_hdr_to_xml(cs_hdr(UNITS)) =
  term_to_xml.elem("cs_hdr",[],[f_txt_units_to_xml(UNITS)]).


%% R_SECS_PARS_OR_BLKS AND TU_SECS_PARS_OR_BLKS_XMLABLE

%%% R_SECS_PARS_OR_BLKS

r_secs_pars_or_blks(ALLOWED_TAGS,SECS_PARS_OR_BLKS) --> (
  r_secs(ALLOWED_TAGS,   SECS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_secs(SECS)};
  r_pars(ALLOWED_TAGS,   PARS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_blks(BLKS)};
  {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_secs_pars_or_blks) where [
  func(to_xml/1) is f_secs_pars_or_blks_to_xml
].
:- func (
  f_secs_pars_or_blks_to_xml(tu_secs_pars_or_blks::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_secs_pars_or_blks_to_xml(SECS_PARS_OR_BLKS) = XML :- (
  (
    SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_secs(SECS),
    XML               =
      term_to_xml.elem("cu_secs_pars_or_blks_secs",[],[f_secs_to_xml(SECS)])
  );
  (
    SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_pars(PARS),
    XML               =
      term_to_xml.elem("cu_secs_pars_or_blks_pars",[],[f_pars_to_xml(PARS)])
  );
  (
    SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_blks(BLKS),
    XML               =
      term_to_xml.elem("cu_secs_pars_or_blks_blks",[],[f_blks_to_xml(BLKS)])
  )
).


%% R_PARS_OR_BLKS AND TU_PARS_OR_BLKS_XMLABLE

%%% R_PARS_OR_BLKS

r_pars_or_blks(ALLOWED_TAGS,PARS_OR_BLKS) --> (
  r_pars(ALLOWED_TAGS,   PARS) -> {PARS_OR_BLKS = cu_pars_or_blks_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) -> {PARS_OR_BLKS = cu_pars_or_blks_blks(BLKS)};
                                  {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_pars_or_blks) where [
  func(to_xml/1) is f_pars_or_blks_to_xml
].

:- func (
  f_pars_or_blks_to_xml(tu_pars_or_blks::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_pars_or_blks_to_xml(PARS_OR_BLKS) = XML :- (
  (
    PARS_OR_BLKS = cu_pars_or_blks_pars(PARS),
    XML          =
      term_to_xml.elem("cu_pars_or_blks_pars",[],[f_pars_to_xml(PARS)])
  );
  (
    PARS_OR_BLKS = cu_pars_or_blks_blks(BLKS),
    XML          =
      term_to_xml.elem("cu_pars_or_blks_blks",[],[f_blks_to_xml(BLKS)])
  )
).




%% R_TXT_UNIT, TU_TXT_UNIT XMLABLE

%%% R_TXT_UNIT

r_txt_unit(ALLOWED_TAGS,LVL,U) --> (
  r_txt_unit_c_ref(  ALLOWED_TAGS,    U_) -> {U = cu_txt_unit_c_ref(U_)};
  r_txt_unit_nte_ref(                 U_) -> {U = cu_txt_unit_nte_ref(U_)};
  r_txt_unit_emph(                LVL,U_) -> {U = cu_txt_unit_emph(U_)};
  r_txt_unit_wysiwyg(ALLOWED_TAGS,LVL,U_) -> {U = cu_txt_unit_wysiwyg(U_)};
                                             {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_txt_unit) where [
  func(to_xml/1) is f_txt_unit_to_xml
].
:- func (
  f_txt_unit_to_xml(tu_txt_unit::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_unit_to_xml(cu_txt_unit_c_ref(REF))   =
  term_to_xml.elem("cu_txt_unit_c_ref",  [],[f_txt_unit_c_ref_to_xml(REF)]).
f_txt_unit_to_xml(cu_txt_unit_nte_ref(REF)) =
  term_to_xml.elem("cu_txt_unit_nte_ref",[],[f_txt_unit_nte_ref_to_xml(REF)]).
f_txt_unit_to_xml(cu_txt_unit_wysiwyg(U))   =
  term_to_xml.elem("cu_txt_unit_wysiwyg",[],[f_txt_unit_wysiwyg_to_xml(U)]).
f_txt_unit_to_xml(cu_txt_unit_emph(U))      =
  term_to_xml.elem("cu_txt_unit_emph",   [],[f_txt_unit_emph_to_xml(U)]).


%% R_TXT_UNIT_EMPH, INSTANCE TS_TXT_UNIT_EMPH XMLABLE

%%% R_TXT_UNIT_EMPH

r_txt_unit_emph(LVL,cs_txt_unit_emph(STR)) -->
  r_str("*"), r_txt_unit_emph_str(LVL,STR), r_str("*").

:- pred r_txt_unit_emph_str(uint, str, ts_tkns, ts_tkns).
:- mode r_txt_unit_emph_str(in,   out, in,      out) is semidet.
r_txt_unit_emph_str(        LVL,  S) --> (
  r(cu_r_any,["*"],S_),
  (
    r_lb, r_tabs(LVL) -> r_txt_unit_emph_str(LVL,S__), {S = S_++" "++S__};
                         {S = S_}
  )
).

%%% INSTANCE XMLABLE

:- instance term_to_xml.xmlable(ts_txt_unit_emph) where [
  func(to_xml/1) is f_txt_unit_emph_to_xml
].
:- func (
  f_txt_unit_emph_to_xml(ts_txt_unit_emph::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_unit_emph_to_xml(cs_txt_unit_emph(STR)) =
  term_to_xml.elem("cs_txt_unit_emph",[],[term_to_xml.data(STR)]).


%% R_TXT_UNIT_WYSIWYG, INSTANCE TS_TXT_UNIT_WYSIWYG XMLABLE

%%% R_TXT_UNIT_WYSIWYG

r_txt_unit_wysiwyg(ALLOWED_TAGS,LVL,cs_txt_unit_wysiwyg(STR)) -->
  +([],r_txt_unit_wysiwyg_chr,ALLOWED_TAGS,LVL,CHRS,[]),{STR = chrs2str(CHRS)}.

:- pred r_txt_unit_wysiwyg_chr(ts_allowed_tags, ta_lvl, chr, ts_tkns, ts_tkns).
:- mode r_txt_unit_wysiwyg_chr(
                               in,              in,     out, in,      out
) is semidet.
r_txt_unit_wysiwyg_chr(        ALLOWED_TAGS,    LVL,    C) --> (
  not r_tab,
  not r_lb,
  not r_c_ref(ALLOWED_TAGS,_),
  not r_nte_ref(_),
  not r_txt_unit_emph(LVL,_),
  r_c(cu_r_any,C)
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_unit_wysiwyg) where [
  func(to_xml/1) is f_txt_unit_wysiwyg_to_xml
].
:- func (
  f_txt_unit_wysiwyg_to_xml(ts_txt_unit_wysiwyg::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_unit_wysiwyg_to_xml(cs_txt_unit_wysiwyg(STR)) =
  term_to_xml.elem("cs_txt_unit_wysiwyg",[],[term_to_xml.data(STR)]).


%% R_TXT_UNIT_C_REF, INSTANCE TS_TXT_UNIT_C_REF XMLABLE

%%% R_TXT_UNIT_C_REF

r_txt_unit_c_ref(ALLOWED_TAGS,cs_txt_unit_c_ref(C_REF)) -->
  r_c_ref(ALLOWED_TAGS,C_REF).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_unit_c_ref) where [
  func(to_xml/1) is f_txt_unit_c_ref_to_xml
].
:- func (
  f_txt_unit_c_ref_to_xml(ts_txt_unit_c_ref::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_unit_c_ref_to_xml(cs_txt_unit_c_ref(C_REF)) =
  term_to_xml.elem("cs_txt_unit_c_ref",[],[f_c_ref_to_xml(C_REF)]).


%% R_TXT_UNIT_NTE_REF, INSTANCE TS_TXT_UNIT_NTE_REF XMLABLE

%%% R_TXT_UNIT_NTE_REF

r_txt_unit_nte_ref(cs_txt_unit_nte_ref(NTE_REF)) --> r_nte_ref(NTE_REF).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_unit_nte_ref) where [
  func(to_xml/1) is f_txt_unit_nte_ref_to_xml
].
:- func (
  f_txt_unit_nte_ref_to_xml(ts_txt_unit_nte_ref::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_unit_nte_ref_to_xml(cs_txt_unit_nte_ref(NTE_REF)) =
  term_to_xml.elem("cs_txt_unit_nte_ref",[],[f_nte_ref_to_xml(NTE_REF)]).


%% R_TXT_UNITS, TS_TXT_UNITS, TS_TXT_UNITS XMLABLE

%%% R_TXT_UNITS

r_txt_units(ALLOWED_TAGS,LVL,cs_txt_units(US)) -->
  +([],r_txt_unit,ALLOWED_TAGS,LVL,US,[]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_units) where [
  func(to_xml/1) is f_txt_units_to_xml
].
:- func (
  f_txt_units_to_xml(ts_txt_units::in) =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_units_to_xml(cs_txt_units(US)) =
  term_to_xml.elem("cs_txt_units",[],list.map(f_txt_unit_to_xml,US)).


%% R_LBL_AUTO, TS_LBL_AUTO XMLABLE

r_lbl_auto(cs_lbl_auto) --> {true}.

:- instance term_to_xml.xmlable(ts_lbl_auto) where [
  func(to_xml/1) is f_lbl_auto_to_xml
].
:- func (
  f_lbl_auto_to_xml(ts_lbl_auto::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_lbl_auto_to_xml(cs_lbl_auto)  = term_to_xml.elem("cs_lbl_auto",[],[]).

%% R_LBL_CUSTOM, TS_LBL_CUSTOM XMLABLE

r_lbl_custom(cs_lbl_custom(S)) --> r(cu_r_any,["(",")","[","]"],S).

:- instance term_to_xml.xmlable(ts_lbl_custom) where [
  func(to_xml/1) is f_lbl_custom_to_xml
].
:- func (
  f_lbl_custom_to_xml(ts_lbl_custom::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_lbl_custom_to_xml(cs_lbl_custom(S)) =
  term_to_xml.elem("cs_lbl_custom",[],[term_to_xml.data(S)]).

%% R_LBL, TU_LBL XMLABLE

%%% R_LBL

r_lbl(LBL) --> (
  r_lbl_custom(LBL_) -> {LBL = cu_lbl_custom(LBL_)};
  r_lbl_auto(LBL_)   -> {LBL = cu_lbl_auto(LBL_)};
                        {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_lbl) where [
  func(to_xml/1) is f_lbl_to_xml
].
:- func (
  f_lbl_to_xml(tu_lbl::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_lbl_to_xml(cu_lbl_auto(LBL))      =
  term_to_xml.elem("cu_lbl_auto",[],[f_lbl_auto_to_xml(LBL)]).
f_lbl_to_xml(cu_lbl_custom(LBL)) =
  term_to_xml.elem("cu_lbl_custom",[],[f_lbl_custom_to_xml(LBL)]).


%% R_TAG_OR_ID, INSTANCE TU_TAG_OR_ID XMLABLE

%%% R_TAG_OR_ID

r_tag_or_id(ALLOWED_TAGS,TAG_TYPE,TAG_OR_ID) --> (
  r_id( ALLOWED_TAGS,TAG_TYPE,ID)  -> {TAG_OR_ID = cu_tag_or_id_id(ID)};
  r_tag(ALLOWED_TAGS,TAG_TYPE,TAG) -> {TAG_OR_ID = cu_tag_or_id_tag(TAG)};
                                      {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_tag_or_id) where [
  func(to_xml/1) is f_tag_or_id_to_xml
].
:- func (
  f_tag_or_id_to_xml(tu_tag_or_id::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_tag_or_id_to_xml(cu_tag_or_id_tag(TAG)) =
  term_to_xml.elem("cu_tag_or_id_tag",[],[f_tag_to_xml(TAG)]).
f_tag_or_id_to_xml(cu_tag_or_id_id(ID))   =
  term_to_xml.elem("cu_tag_or_id_id", [],[f_id_to_xml(ID)]).

%% R_TAG AND INSTANCE TS_TAG XMLABLE

%%% HELPER FUNCTION F_VALID_STR

 % the reason for this function is to make sure we do not forget to handle a
 % tu_tag_type instance when we add a new such

:- func f_valid_tag_str(str, tu_tag_type,            strs)    = bool.bool.
f_valid_tag_str(        S,   cu_tag_type_ch,         _)       = IS_VALID :- (
  if S = "CH" then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,   cu_tag_type_sec,        _)       = IS_VALID :- (
  if (S = "SEC"; S = "APP") then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,   cu_tag_type_par,        OK_TAGS) = IS_VALID :- (
  if (S = "PAR"; list.member(S,OK_TAGS)) then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,   cu_tag_type_itm,        OK_TAGS) = IS_VALID :- (
  if (S = "ITM"; list.member(S,OK_TAGS)) then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_dsp,         OK_TAGS) = IS_VALID :- (
  if (S = "DSP"; list.member(S,OK_TAGS)) then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_nte,         _)       = IS_VALID :- (
  if S = "NTE" then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_c_ref,       OK_TAGS) = IS_VALID :- (
  if (
    list.member(S,["CH","SEC","APP","PAR","ITM","DSP"])
    ;
    list.member(S,OK_TAGS)
  ) then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_nte_ref,     _)       = IS_VALID :- (
  if S = "NTE" then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_par_rpt_ref, OK_TAGS) =
  f_valid_tag_str(      S,  cu_tag_type_par,         OK_TAGS).

%%% R_TAG

r_tag(ALLOWED_TAGS,TAG_TYPE,TAG) --> (
  r(cu_r_nws,k_forbidden_strs_in_tags_names,S),
  {S \= "REFS"},
  {ALLOWED_TAGS = cs_allowed_tags(ALLOWED_TAGS_STRS)},
  {f_valid_tag_str(S,TAG_TYPE,ALLOWED_TAGS_STRS) = bool.yes},
  {TAG = cs_tag(S)}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_tag) where [
  func(to_xml/1) is f_tag_to_xml
].
:- func (
  f_tag_to_xml(ts_tag::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_tag_to_xml(cs_tag(S)) = term_to_xml.elem("cs_tag",[],[term_to_xml.data(S)]).


%% R_NAME AND INSTANCE TS_NAME XMLABLE

r_name(cs_name(S)) --> r(cu_r_nws,k_forbidden_strs_in_tags_names,S).

:- instance term_to_xml.xmlable(ts_name) where [
  func(to_xml/1) is f_name_to_xml
].

:- func (
  f_name_to_xml(ts_name::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

f_name_to_xml(cs_name(S)) =
  term_to_xml.elem("cs_name",[],[term_to_xml.data(S)]).


%% R_SCOPE AND INSTANCE TU_SCOPE XMLABLE

%%% R_SCOPE

r_scope(S) --> (
  r_str("GBL") -> {S = cu_scope_gbl};
  r_str("CH")  -> {S = cu_scope_ch};
  r_str("SEC") -> {S = cu_scope_sec};
  r_str("APP") -> {S = cu_scope_sec};
  r_str("PAR") -> {S = cu_scope_par};
                  {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_scope) where [
  func(to_xml/1) is f_scope_to_xml
].
:- func (
  f_scope_to_xml(tu_scope::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_scope_to_xml(cu_scope_gbl) = term_to_xml.elem("cu_scope_gbl",[],[]).
f_scope_to_xml(cu_scope_ch)  = term_to_xml.elem("cu_scope_ch", [],[]).
f_scope_to_xml(cu_scope_sec) = term_to_xml.elem("cu_scope_sec",[],[]).
f_scope_to_xml(cu_scope_par) = term_to_xml.elem("cu_scope_par",[],[]).


%% R_ID AND INSTANCE TR_ID XMLABLE

r_id(ALLOWED_TAGS,TAG_TYPE,cr_id(TAG,NAME,MAYBE_SCOPE)) -->
  r_tag(ALLOWED_TAGS,TAG_TYPE,TAG),
  r_str(":"),
  r_name(NAME),
  ?([r_str(":")],r_scope,MAYBE_SCOPE,[]).

:- instance term_to_xml.xmlable(tr_id) where [
  func(to_xml/1) is f_id_to_xml
].
:- func (
  f_id_to_xml(tr_id::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_id_to_xml(cr_id(TAG,NAME,MAYBE_SCOPE)) = XML :- (
  (
    MAYBE_SCOPE = maybe.yes(SCOPE), SCOPE_LIST = [f_scope_to_xml(SCOPE)]
    ;
    MAYBE_SCOPE = maybe.no,         SCOPE_LIST = []
  ),
  XML = term_to_xml.elem(
    "cr_id",[],[f_tag_to_xml(TAG),f_name_to_xml(NAME)]++SCOPE_LIST
  )
).


%% R_C_REF AND INSTANCE TS_C_REF XMLABLE

r_c_ref(ALLOWED_TAGS,cs_c_ref(ID)) -->
  r_str("["), r_id(ALLOWED_TAGS,cu_tag_type_c_ref,ID), r_str("]").

:- instance term_to_xml.xmlable(ts_c_ref) where [
  func(to_xml/1) is f_c_ref_to_xml
].
:- func (
  f_c_ref_to_xml(ts_c_ref::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_c_ref_to_xml(cs_c_ref(ID)) =
  term_to_xml.elem("cs_c_ref",[],[f_id_to_xml(ID)]).


%% R_NTE_REF AND INSTANCE TS_NTE_REF XMLABLE

r_nte_ref(cs_nte_ref(ID)) -->
  r_str("["), r_id(cs_allowed_tags([]),cu_tag_type_nte_ref,ID), r_str("]").

:- instance term_to_xml.xmlable(ts_nte_ref) where [
  func(to_xml/1) is f_nte_ref_to_xml
].
:- func (
  f_nte_ref_to_xml(ts_nte_ref::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_nte_ref_to_xml(cs_nte_ref(ID)) =
  term_to_xml.elem("cs_nte_ref",[],[f_id_to_xml(ID)]).


%% R_BLK_TXT, INSTANCE TS_BLK_TXT XMLABLE

%%% R_BLK_TXT

:- pragma memo(r_blk_txt/5,[fast_loose]).
r_blk_txt(ALLOWED_TAGS,LVL,cs_blk_txt(UNITS)) --> (
  (
    if {LVL = 0u} then
      not r_ch( ALLOWED_TAGS,_),
      not r_sec(ALLOWED_TAGS,_),
      not r_par(ALLOWED_TAGS,_),
      not r_refs_start_marker
    else
      {true}
  ),
  r_blk_txt_lines(ALLOWED_TAGS,LVL,UNITS)
).

:- pred r_blk_txt_lines(
   ts_allowed_tags, ta_lvl, ts_txt_units, ts_tkns, ts_tkns
).
:- mode r_blk_txt_lines(
  in,               in,     out,          in,      out
) is semidet.
r_blk_txt_lines(
  ALLOWED_TAGS,     LVL,    cs_txt_units(US)
) --> (
  r_blk_txt_line(ALLOWED_TAGS,LVL,cs_txt_units(US_)),
  (
    r_tabs(LVL), r_blk_txt_lines(ALLOWED_TAGS,LVL,cs_txt_units(US__)) ->
      {US = US_ ++ [cu_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" "))] ++ US__};
    {US = US_}
  )
).

:- pred r_blk_txt_line(
   ts_allowed_tags, ta_lvl, ts_txt_units, ts_tkns, ts_tkns
).
:- mode r_blk_txt_line(
  in,               in,     out,          in,      out
) is semidet.
r_blk_txt_line(
  ALLOWED_TAGS,     LVL,    US
) --> r_txt_units(ALLOWED_TAGS, LVL,US), r_lb.

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_blk_txt) where [
  func(to_xml/1) is f_blk_txt_to_xml
].
:- func (
  f_blk_txt_to_xml(ts_blk_txt::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_txt_to_xml(cs_blk_txt(UNITS)) =
  term_to_xml.elem("cs_blk_txt",[],[f_txt_units_to_xml(UNITS)]).


%% R_BLK_BLT AND INSTANCE TS_BLK_BLT XMLABLE

:- pragma memo(r_blk_blt/5,[fast_loose]).
r_blk_blt(ALLOWED_TAGS,LVL,cs_blk_blt(BLKS)) -->
  r_str("-"), r_tab, r_blks(ALLOWED_TAGS,LVL+1u,BLKS).

:- instance term_to_xml.xmlable(ts_blk_blt) where [
  func(to_xml/1) is f_blk_blt_to_xml
].
:- func (
  f_blk_blt_to_xml(ts_blk_blt::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_blt_to_xml(cs_blk_blt(BLKS)) =
  term_to_xml.elem("cs_blk_blt",[],[f_blks_to_xml(BLKS)]).


%% R_BLK_ITM, INSTANCE TR_BLK_ITM XMLABLE

%%% R_BLK_ITM

:- pragma memo(r_blk_itm/5,[fast_loose]).
r_blk_itm(ALLOWED_TAGS,LVL,cr_blk_itm(LBL,MAYBE_TAG_OR_ID,BLKS)) --> (
  r_str("["), r_lbl(LBL), r_str("]"),
  r_tab,
  ?(
    [],
    r_tag_or_id,ALLOWED_TAGS,cu_tag_type_itm,MAYBE_TAG_OR_ID,
    [r_lb,r_tabs(LVL+1u)]
  ),
  r_blks(ALLOWED_TAGS,LVL+1u,BLKS)
).

%%% INSTANCE XMLABLE

:- instance term_to_xml.xmlable(tr_blk_itm) where [
  func(to_xml/1) is f_blk_itm_to_xml
].

:- func (
  f_blk_itm_to_xml(tr_blk_itm::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_itm_to_xml(BLK_ITM) = XML :- (
  (
    (
      fld_blk_itm_tag_or_id(BLK_ITM) = maybe.no,
      TAG_OR_ID_XML_LIST             = []
    );
    (
      fld_blk_itm_tag_or_id(BLK_ITM) = maybe.yes(TAG_OR_ID),
      TAG_OR_ID_XML_LIST             = [f_tag_or_id_to_xml(TAG_OR_ID)]
    )
  ),
  LBL  = fld_blk_itm_lbl(BLK_ITM),
  BLKS = fld_blk_itm_main(BLK_ITM),
  XML  = term_to_xml.elem(
    "cr_blk_itm",
    [],
    [f_lbl_to_xml(LBL)]++TAG_OR_ID_XML_LIST++[f_blks_to_xml(BLKS)]
  )
).


%% R_BLK_DSP, INSTANCE TS_BLK_DSP XMLABLE

:- pragma memo(r_blk_dsp/5,[fast_loose]).
r_blk_dsp(ALLOWED_TAGS,LVL,cs_blk_dsp(DSP_LINES)) -->
  r_dsp_lines(ALLOWED_TAGS,LVL,DSP_LINES).

:- instance term_to_xml.xmlable(ts_blk_dsp) where [
  func(to_xml/1) is f_blk_dsp_to_xml
].
:- func (
  f_blk_dsp_to_xml(ts_blk_dsp::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_dsp_to_xml(cs_blk_dsp(DSP_LINES)) =
  term_to_xml.elem("cs_blk_dsp",[],[f_dsp_lines_to_xml(DSP_LINES)]).


%% R_BLK_VRB, INSTANCE TS_BLK_VRB XMLABLE

%%% R_BLK_VRB

:- pragma memo(r_blk_vrb/4,[fast_loose]).
r_blk_vrb(LVL,cs_blk_vrb(cs_vrb_lines(LINES))) --> (
  r_str("START"), r_tab, r_str("VERBATIM"), r_lb,
  +([],r_vrb_line,LVL,LINES,[]),
  r_tabs(LVL),
  r_str("END"),   r_tab, r_str("VERBATIM"), r_lb
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_blk_vrb) where [
  func(to_xml/1) is f_blk_vrb_to_xml
].
:- func (
  f_blk_vrb_to_xml(ts_blk_vrb::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_vrb_to_xml(cs_blk_vrb(LINES)) =
  term_to_xml.elem("cs_blk_vrb",[],[f_vrb_lines_to_xml(LINES)]).


%% R_BLK_NTE AND INSTANCE TR_BLK_NTE XMLABLE

:- pragma memo(r_blk_nte/5,[fast_loose]).
r_blk_nte(ALLOWED_TAGS,LVL,cr_blk_nte(ID,BLKS)) -->
  r_str("*"), r_tab, r_id(cs_allowed_tags([]),cu_tag_type_nte,ID),
  +([r_lb]),
  r_tabs(LVL+1u), r_blks(ALLOWED_TAGS,LVL+1u,BLKS).

:- instance term_to_xml.xmlable(tr_blk_nte) where [
  func(to_xml/1) is f_blk_nte_to_xml
].
:- func (
  f_blk_nte_to_xml(tr_blk_nte::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_nte_to_xml(cr_blk_nte(ID,BLKS)) =
  term_to_xml.elem("cr_blk_nte",[],[f_id_to_xml(ID),f_blks_to_xml(BLKS)]).


%% R_DSP_LINES, INSTANCE TS_DSP_LINES XMLABLE

%%% R_DSP_LINES

r_dsp_lines(ALLOWED_TAGS,LVL,cs_dsp_lines(LS)) --> (
  r_dsp_line(ALLOWED_TAGS,L),
  (
    r_tabs(LVL),r_dsp_lines(ALLOWED_TAGS,LVL,cs_dsp_lines(LS_)) ->
      {LS = [L]++LS_};
    {LS = [L]}
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_dsp_lines) where [
  func(to_xml/1) is f_dsp_lines_to_xml
].
:- func (
  f_dsp_lines_to_xml(ts_dsp_lines::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_dsp_lines_to_xml(cs_dsp_lines(LINES)) =
  term_to_xml.elem("cs_dsp_lines",[],list.map(f_dsp_line_to_xml,LINES)).


%% R_DSP_LINE, TR_DSP_LINE XMLABLE

%%% R_DSP_LINE

r_dsp_line(ALLOWED_TAGS,LINE) --> (
  r_dsp_line_no_lbl(ALLOWED_TAGS,LINE_) -> {LINE = cu_dsp_line_no_lbl(LINE_)};
  r_dsp_line_lbld(  ALLOWED_TAGS,LINE_) -> {LINE = cu_dsp_line_lbld(  LINE_)};
                                           {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_dsp_line) where [
  func(to_xml/1) is f_dsp_line_to_xml
].
:- func (
  f_dsp_line_to_xml(tu_dsp_line::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_dsp_line_to_xml(cu_dsp_line_no_lbl(L)) =
  term_to_xml.elem("cu_dsp_line_no_lbl",[],[f_dsp_line_no_lbl_to_xml(L)]).
f_dsp_line_to_xml(cu_dsp_line_lbld(  L)) =
  term_to_xml.elem("cu_dsp_line_lbld",  [],[f_dsp_line_lbld_to_xml(  L)]).


%% R_DSP_LINE_LBLD, TR_DSP_LINE_LBLD XMLABLE

%%% R_DSP_LINE_LBLD

r_dsp_line_lbld(
  ALLOWED_TAGS,cr_dsp_line_lbld(LBL,MAYBE_ID,cs_txt_units(US))
) --> (
  r_str("("),
  r_lbl(LBL),
  r_str(")"),
  r_tab,
  +([],r_dsp_unit,ALLOWED_TAGS,US,[]),
  ?([+([r_tab])],r_id,ALLOWED_TAGS,cu_tag_type_dsp,MAYBE_ID,[]),
  r_lb
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_dsp_line_lbld) where [
  func(to_xml/1) is f_dsp_line_lbld_to_xml
].
:- func (
  f_dsp_line_lbld_to_xml(tr_dsp_line_lbld::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_dsp_line_lbld_to_xml(LINE) = XML :- (
  (
    (
      fld_dsp_line_lbld_id(LINE) = maybe.yes(ID),
      ID_XML_LIST                = [f_id_to_xml(ID)]
    );
    (
      fld_dsp_line_lbld_id(LINE) = maybe.no,
      ID_XML_LIST                = []
    )
  ),
  LBL   = fld_dsp_line_lbld_lbl(  LINE),
  UNITS = fld_dsp_line_lbld_units(LINE),
  XML = term_to_xml.elem(
    "cr_dsp_line_lbld",
    [],
    [f_lbl_to_xml(LBL)]++ID_XML_LIST++[f_txt_units_to_xml(UNITS)]
  )
).


%% R_DSP_LINE_NO_LBL, TS_DSP_LINE_NO_LBL XMLABLE

%%% R_DSP_LINE_NO_LBL

r_dsp_line_no_lbl(ALLOWED_TAGS,cs_dsp_line_no_lbl(cs_txt_units(US))) --> (
  r_tab,
  +([],r_dsp_unit,ALLOWED_TAGS,US,[]),
  ?([+([r_tab]),r_str("DSP")]),
  r_lb
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_dsp_line_no_lbl) where [
  func(to_xml/1) is f_dsp_line_no_lbl_to_xml
].
:- func (
  f_dsp_line_no_lbl_to_xml(ts_dsp_line_no_lbl::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_dsp_line_no_lbl_to_xml(cs_dsp_line_no_lbl(TXT_UNITS)) = term_to_xml.elem(
  "cs_dsp_line_no_lbl",[],[f_txt_units_to_xml(TXT_UNITS)]
).


%% R_DSP_UNIT

%%% R_DSP_UNIT

r_dsp_unit(ALLOWED_TAGS,U) --> (
  r_c_ref(           ALLOWED_TAGS,CR) ->
    {U = cu_txt_unit_c_ref(cs_txt_unit_c_ref(CR))};
  r_dsp_unit_emph(                U_) ->
    {U = U_};
  r_dsp_unit_wysiwyg(ALLOWED_TAGS,U_) ->
    {U = U_};
  {false}
).

%%% R_DSP_UNIT_EMPH

:- pred r_dsp_unit_emph(tu_txt_unit::out, ts_tkns::in, ts_tkns::out) is semidet.
r_dsp_unit_emph(        cu_txt_unit_emph(U)) -->
  r_str("*"), r(cu_r_any,["*"],S), r_str("*"), {U = cs_txt_unit_emph(S)}.

%%% R_DSP_UNIT_WYSIWYG

:- pred r_dsp_unit_wysiwyg(ts_allowed_tags, tu_txt_unit, ts_tkns, ts_tkns).
:- mode r_dsp_unit_wysiwyg(
                           in,              out,         in,      out
) is semidet.
r_dsp_unit_wysiwyg(        ALLOWED_TAGS,    cu_txt_unit_wysiwyg(U)) -->
  r_txt_unit_wysiwyg(ALLOWED_TAGS,0u,U).


%% TS_VRB_LINES XMLABLE

:- instance term_to_xml.xmlable(ts_vrb_lines) where [
  func(to_xml/1) is f_vrb_lines_to_xml
].
:- func (
  f_vrb_lines_to_xml(ts_vrb_lines::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_vrb_lines_to_xml(cs_vrb_lines(LINES)) =
  term_to_xml.elem("cs_vrb_lines",[],list.map(f_vrb_line_to_xml,LINES)).


%% R_VRB_LINE, TS_VRB_LINE XMLABLE

%%% R_VRB_LINE

r_vrb_line(LVL,LINE) --> (
  (
    r_tabs(LVL), +([],r_vrb_line_tkn,TKNS,[]), r_lb -> (
      {LINE = cs_vrb_line(nmm.lexer.f_detknize(TKNS))}
    );
    r_lb                                      -> (
      {LINE = cs_vrb_line("")}
    );
    {false}
  )
).

:- pred r_vrb_line_tkn(tu_tkn::out,ts_tkns::in,ts_tkns::out) is semidet.
r_vrb_line_tkn(TKN) --> (
  [TKN],
  {
    TKN \= nmm.lexer.cu_tkn_tab(_),
    TKN \= nmm.lexer.cu_tkn_lb(_),
    TKN \= nmm.lexer.cu_tkn_eof
  }
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_vrb_line) where [
  func(to_xml/1) is f_vrb_line_to_xml
].
:- func (
  f_vrb_line_to_xml(ts_vrb_line::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_vrb_line_to_xml(cs_vrb_line(STR)) = term_to_xml.elem(
  "cs_vrb_line",[],[term_to_xml.data(STR)]
).
