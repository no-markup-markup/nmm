:- module nmm.parser.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% SUBMODULES

:- include_module parser.test, parser.helpers, parser.operators.


%% MODULE IMPORTS

:- use_module term_to_xml, nmm.lexer.


%% TYPE ABBREVIATIONS TA_TKN AND TA_TKNS

:- type ta_tkn  == nmm.lexer.t_tkn.
:- type ta_tkns == nmm.lexer.t_tkns.


%% ALIAS TYPE TA_LVL (= UINT)

:- type ta_lvl == uint.


%% RULE R_DOC (TODO), TYPE TR_DOC, INSTANCE TR_DOC XMLABLE

:- type tr_doc ---> cr_doc(
  fld_doc_preamble :: maybe(ts_preamble),
  fld_doc_title    :: maybe(ts_title),
  fld_doc_abstract :: maybe(ts_abstract),
  fld_doc_main     :: te_doc_main,
  fld_doc_refs     :: maybe(ts_refs)
).

:- instance term_to_xml.xmlable(tr_doc).

:- pred r_doc(tr_doc, ta_tkns, ta_tkns).
:- mode r_doc(out,    in,      out) is semidet.


%% RULE R_PREAMBLE (TODO), SIMPLE TYPE TS_PREAMBLE, INSTANCE TS_PREAMBLE XMLABLE

:- type ts_preamble ---> cs_preamble(str).

:- instance term_to_xml.xmlable(ts_preamble).

 %% :- pred r_preamble(ts_preamble::out, ta_tkns::in, ta_tkns::out) is semidet.


%% RULE R_TITLE (TODO), SIMPLE TYPE TS_TITLE, INSTANCE TS_TITLE XMLABLE

:- type ts_title ---> cs_title(str).

:- instance term_to_xml.xmlable(ts_title).

 %% :- pred r_title(ts_title::out, ta_tkns::in, ta_tkns::out) is semidet.


%% RULE R_ABSTRACT (TODO), SIMPLE TYPE TS_ABSTRACT, INSTANCE TS_ABSTRACT XMLABLE

:- type ts_abstract ---> cs_abstract(ts_blks).

:- instance term_to_xml.xmlable(ts_abstract).


%% RULE R_REFS (TODO), SIMPLE TYPE TS_REFS, INSTANCE TS_REFS XMLABLE

:- type ts_refs ---> cs_refs(ts_blks).

:- instance term_to_xml.xmlable(ts_refs).


%% RULE R_DOC_MAIN, ENUM TYPE TE_DOC_MAIN, INSTANCE TE_DOC_MAIN XMLABLE

:- type te_doc_main --->
  ce_doc_main_chs(ts_chs);
  ce_doc_main_secs(ts_secs);
  ce_doc_main_pars(ts_pars);
  ce_doc_main_blks(ts_blks).

:- instance term_to_xml.xmlable(te_doc_main).

:- pred r_doc_main(te_doc_main, ta_tkns, ta_tkns).
:- mode r_doc_main(out,         in,      out) is semidet.


%% RULE R_CHS, SIMPLE TYPE TS_CHS, INSTANCE TS_CHS_XMLABLE

:- type ts_chs ---> cs_chs(list(tr_ch)).

:- instance term_to_xml.xmlable(ts_chs).

:- pred r_chs(ts_chs, ta_tkns, ta_tkns).
:- mode r_chs(out,    in,      out) is semidet.


%% RULE R_SECS, SIMPLE TYPE TS_SECS, INSTANCE TS_SECS_XMLABLE

:- type ts_secs ---> cs_secs(list(tr_sec)).

:- instance term_to_xml.xmlable(ts_secs).

:- pred r_secs(ts_secs, ta_tkns, ta_tkns).
:- mode r_secs(out,     in,      out) is semidet.


%% RULE R_PARS, SIMPLE TYPE TS_PARS, INSTANCE TS_PAR_XMLABLE

:- type ts_pars ---> cs_pars(list(tr_par)).

:- instance term_to_xml.xmlable(ts_pars).

:- pred r_pars(ts_pars, ta_tkns, ta_tkns).
:- mode r_pars(out,     in,      out) is semidet.


%% RULE R_BLKS, SIMPLE TYPE TS_BLKS, INSTANCE TS_BLKS_XMLABLE

:- type ts_blks ---> cs_blks(list(te_blk)).

:- instance term_to_xml.xmlable(ts_blks).

:- pred r_blks(ta_lvl, ts_blks, ta_tkns, ta_tkns).
:- mode r_blks(in,     out,     in,      out) is semidet.


%% RULE R_CH, RECORD TYPE TR_CH, INSTANCE TR_CH XMLABLE

:- type tr_ch ---> cr_ch(
  fld_ch_tag_or_id :: maybe(te_tag_or_id),
  fld_ch_hdr       :: maybe(ts_hdr),
  fld_ch_main      :: te_secs_pars_or_blks
).

:- instance term_to_xml.xmlable(tr_ch).

:- pred r_ch(tr_ch,  ta_tkns, ta_tkns).
:- mode r_ch(out,    in,      out) is semidet.


%% RULE R_SEC, RECORD TYPE TR_SEC, INSTANCE TR_SEC XMLABLE

:- type tr_sec ---> cr_sec(
  fld_sec_tag_or_id :: maybe(te_tag_or_id),
  fld_sec_hdr       :: maybe(ts_hdr),
  fld_sec_main      :: te_pars_or_blks
).

:- instance term_to_xml.xmlable(tr_sec).

:- pred r_sec(tr_sec, ta_tkns, ta_tkns).
:- mode r_sec(out,    in,      out) is semidet.


%% RULE R_PAR, RECORD TYPE TR_PAR, INSTANCE TR_PAR XMLABLE

:- type tr_par ---> cr_par(
  fld_par_tag_or_id :: maybe(te_tag_or_id),
  fld_par_hdr       :: maybe(ts_hdr),
  fld_par_main      :: ts_blks
).

:- instance term_to_xml.xmlable(tr_par).

:- pred r_par(tr_par, ta_tkns, ta_tkns).
:- mode r_par(out,    in,      out) is semidet.


%% RULE R_BLK, ENUM TYPE TE_BLK, INSTANCE TE_BLK XMLABLE

:- type te_blk --->
  ce_blk_txt(ts_blk_txt);
  ce_blk_blt(ts_blk_blt);
  ce_blk_itm(tr_blk_itm);
  ce_blk_dsp(ts_blk_dsp).

:- instance term_to_xml.xmlable(te_blk).

:- pred r_blk(ta_lvl, te_blk, ta_tkns, ta_tkns).
:- mode r_blk(in,     out,    in,      out) is semidet.


%% RULE R_HDR, SIMPLE TYPE TS_HDR, INSTANCE TS_HDR XMLABLE

:- type ts_hdr ---> cs_hdr(ts_txt_units).

:- instance term_to_xml.xmlable(ts_hdr).

:- pred r_hdr(ts_hdr, ta_tkns, ta_tkns).
:- mode r_hdr(out,    in,      out) is semidet.


%% RULE R_SECS_PARS_OR_BLKS, ENUM TYPE TE_SECS_PARS_OR_BLKS, INSTANCE TE_SECS_PARS_OR_BLKS XMLABLE

:- type te_secs_pars_or_blks ---> (
  ce_secs_pars_or_blks_secs(ts_secs);
  ce_secs_pars_or_blks_pars(ts_pars);
  ce_secs_pars_or_blks_blks(ts_blks)
).

:- instance term_to_xml.xmlable(te_secs_pars_or_blks).

:- pred r_secs_pars_or_blks(te_secs_pars_or_blks, ta_tkns, ta_tkns).
:- mode r_secs_pars_or_blks(out,                  in,      out) is semidet.


%% RULE R_PARS_OR_BLKS, ENUM TYPE TE_PARS_OR_BLKS, INSTANCE TE_PARS_OR_BLKS XMLABLE

:- type te_pars_or_blks ---> (
  ce_pars_or_blks_pars(ts_pars);
  ce_pars_or_blks_blks(ts_blks)
).

:- instance term_to_xml.xmlable(te_pars_or_blks).

:- pred r_pars_or_blks(te_pars_or_blks, ta_tkns, ta_tkns).
:- mode r_pars_or_blks(out,             in,      out) is semidet.


%% RULE R_TXT_UNIT, ENUM TYPE TE_TXT_UNIT, INSTANCE TE_TXT_UNIT XMLABLE

:- type te_txt_unit --->
  ce_txt_unit_c_ref(ts_txt_unit_c_ref);
  ce_txt_unit_emph(ts_txt_unit_emph);
  ce_txt_unit_wysiwyg(ts_txt_unit_wysiwyg).

:- instance term_to_xml.xmlable(te_txt_unit).

:- pred r_txt_unit(ta_lvl, te_txt_unit, ta_tkns, ta_tkns).
:- mode r_txt_unit(in,     out,         in,      out) is semidet.


%% RULE R_TXT_UNIT_EMPH, SIMPLE TYPE TS_TXT_UNIT_EMPH, INSTANCE TS_TXT_UNIT_EMPH XMLABLE

:- type ts_txt_unit_emph ---> cs_txt_unit_emph(str).

:- instance term_to_xml.xmlable(ts_txt_unit_emph).

:- pred r_txt_unit_emph(ta_lvl, ts_txt_unit_emph, ta_tkns, ta_tkns).
:- mode r_txt_unit_emph(in,     out,              in,      out) is semidet.

%% RULE R_TXT_UNIT_WYSIWYG, SIMPLE TYPE TS_TXT_UNIT_WYSIWYG, INSTANCE TS_TXT_UNIT_WYSIWYG XMLABLE

:- type ts_txt_unit_wysiwyg ---> cs_txt_unit_wysiwyg(str).

:- instance term_to_xml.xmlable(ts_txt_unit_wysiwyg).

:- pred r_txt_unit_wysiwyg(
  ta_lvl::in, ts_txt_unit_wysiwyg::out, ta_tkns::in, ta_tkns::out
) is semidet.


%% RULE R_TXT_UNIT_CREF, SIMPLE TYPE TS_TXT_UNIT_CREF, INSTANCE TS_TXT_UNIT_CREF XMLABLE

:- pred r_txt_unit_c_ref(ts_txt_unit_c_ref, ta_tkns, ta_tkns).
:- mode r_txt_unit_c_ref(out,               in,      out) is semidet.

:- type ts_txt_unit_c_ref ---> cs_txt_unit_c_ref(ts_c_ref).

:- instance term_to_xml.xmlable(ts_txt_unit_c_ref).


%% RULE R_TXT_UNITS, SIMPLE TYPE TS_TXT_UNITS, INSTANCE TS_TXT_UNITS XMLABLE

:- type ts_txt_units ---> cs_txt_units(list(te_txt_unit)).

:- instance term_to_xml.xmlable(ts_txt_units).

:- pred r_txt_units(ta_lvl, ts_txt_units, ta_tkns, ta_tkns).
:- mode r_txt_units(in,     out,          in,      out) is semidet.


%% RULE R_LBL, ENUM TYPE TE_LBL, INSTANCE TE_LBL XMLABLE

:- type te_lbl --->
  ce_lbl_auto;
  ce_lbl_custom(str).

:- instance term_to_xml.xmlable(te_lbl).

:- pred r_lbl(te_lbl::out, ta_tkns::in, ta_tkns::out) is det.



%% RULE R_TAG_OR_ID, ENUM TYPE TE_TAG_OR_ID, INSTANCE TE_TAG_OR_ID_XMLABLE

:- type te_tag_or_id --->
  ce_tag_or_id_tag(ts_tag);
  ce_tag_or_id_id(tr_id).

:- instance term_to_xml.xmlable(te_tag_or_id).

:- pred r_tag_or_id(te_tag_or_id, ta_tkns, ta_tkns).
:- mode r_tag_or_id(out,          in,      out) is semidet.

%% RULE R_TAG, SIMPLE TYPE TS_TAG, INSTANCE TS_TAG XMLABLE

:- type ts_tag ---> cs_tag(str).

:- instance term_to_xml.xmlable(ts_tag).

:- pred r_tag(ts_tag::out, ta_tkns::in, ta_tkns::out) is semidet.

%% RULE R_NAME, SIMPLE TYPE TS_NAME, INSTANCE TS_NAME XMLABLE

:- type ts_name ---> cs_name(str).

:- instance term_to_xml.xmlable(ts_name).

:- pred r_name(ts_name::out, ta_tkns::in, ta_tkns::out) is semidet.

%% RULE R_ID, RECORD TYPE TR_ID, INSTANCE TR_ID XMLABLE

:- type tr_id ---> cr_id(
  fld_id_tag  :: ts_tag,
  fld_id_name :: ts_name
).

:- instance term_to_xml.xmlable(tr_id).

:- pred r_id(tr_id::out, ta_tkns::in, ta_tkns::out) is semidet.

%% RULE R_C_REF, SIMPLE TYPE TS_C_REF, INSTANCE TS_C_REF XMLABLE

:-type ts_c_ref ---> cs_c_ref(tr_id).

:- instance term_to_xml.xmlable(ts_c_ref).

:- pred r_c_ref(ts_c_ref::out, ta_tkns::in, ta_tkns::out) is semidet.


%% RULE R_BLK_TXT, SIMPLE TYPE TS_BLK_TXT, INSTANCE TS_BLK_TXT XMLABLE

:- type ts_blk_txt ---> cs_blk_txt(ts_txt_units).

:- instance term_to_xml.xmlable(ts_blk_txt).

:- pred r_blk_txt(ta_lvl, ts_blk_txt, ta_tkns, ta_tkns).
:- mode r_blk_txt(in,     out,        in,      out) is semidet.

%% RULE R_BLK_BLT, SIMPLE TYPE TS_BLK_BLT, INSTANCE TS_BLK_BLT XMLABLE

:- type ts_blk_blt ---> cs_blk_blt(ts_blks).

:- instance term_to_xml.xmlable(ts_blk_blt).

:- pred r_blk_blt(ta_lvl, ts_blk_blt, ta_tkns, ta_tkns).
:- mode r_blk_blt(in,     out,        in,      out) is semidet.


%% RULE R_BLK_ITM, RECORD TYPE TR_BLK_ITM, INSTANCE TR_BLK_ITM XMLABLE

:- type tr_blk_itm ---> cr_blk_itm(
  fld_blk_itm_lbl       :: te_lbl,
  fld_blk_itm_tag_or_id :: maybe(te_tag_or_id),
  fld_blk_itm_main      :: ts_blks
).

:- instance term_to_xml.xmlable(tr_blk_itm).

:- pred r_blk_itm(ta_lvl, tr_blk_itm, ta_tkns, ta_tkns).
:- mode r_blk_itm(in,     out,        in,      out) is semidet.

%% RULE R_BLK_DSP, SIMPLE TYPE TS_BLK_DSP, INSTANCE TS_BLK_DSP XMLABLE

:- type ts_blk_dsp ---> cs_blk_dsp(ts_dsp_lines).

:- instance term_to_xml.xmlable(ts_blk_dsp).

:- pred r_blk_dsp(ta_lvl, ts_blk_dsp, ta_tkns, ta_tkns).
:- mode r_blk_dsp(in,     out,        in,      out) is semidet.

%% RULE R_DSP_LINES, SIMPLE TYPE TS_DSP_LINES, INSTANCE TS_DSP_LINES XMLABLE

:- type ts_dsp_lines ---> cs_dsp_lines(list(te_dsp_line)).

:- instance term_to_xml.xmlable(ts_dsp_lines).

:- pred r_dsp_lines(ta_lvl, ts_dsp_lines, ta_tkns, ta_tkns).
:- mode r_dsp_lines(in,     out,          in,      out) is semidet.


%% RULE R_DSP_LINE, ENUM TYPE TE_DSP_LINE, INSTANCE TE_DSP_LINE XMLABLE

:- type te_dsp_line --->
  ce_dsp_line_lbld(tr_dsp_line_lbld);
  ce_dsp_line_no_lbl(ts_dsp_line_no_lbl).

:- instance term_to_xml.xmlable(te_dsp_line).

:- pred r_dsp_line(te_dsp_line, ta_tkns, ta_tkns).
:- mode r_dsp_line(out,         in,      out) is semidet.

%% RULE R_DSP_LINE_LBLD, RECORD TYPE TR_DSP_LINE_LBLD, INSTANCE TR_DSP_LINE_LBLD XMLABLE

:- type tr_dsp_line_lbld ---> cr_dsp_line_lbld(
  fld_dsp_line_lbld_lbl   :: te_lbl,
  fld_dsp_line_lbld_id    :: maybe(tr_id),
  fld_dsp_line_lbld_units :: ts_txt_units
).

:- instance term_to_xml.xmlable(tr_dsp_line_lbld).

:- pred r_dsp_line_lbld(tr_dsp_line_lbld, ta_tkns, ta_tkns).
:- mode r_dsp_line_lbld(out,              in,      out) is semidet.


%% RULE R_DSP_LINE_NO_LBL, SIMPLE TYPE TS_DSP_LINE_NO_LBL, INSTANCE TS_DSP_LINE_NO_LBL XMLABLE

:- type ts_dsp_line_no_lbl ---> cs_dsp_line_no_lbl(ts_txt_units).

:- instance term_to_xml.xmlable(ts_dsp_line_no_lbl).

:- pred r_dsp_line_no_lbl(ts_dsp_line_no_lbl, ta_tkns, ta_tkns).
:- mode r_dsp_line_no_lbl(out,                in,      out) is semidet.


%% RULE R_DSP_UNIT

:- pred r_dsp_unit(te_txt_unit, ta_tkns, ta_tkns).
:- mode r_dsp_unit(out,         in,      out) is semidet.



% TODO: IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module nmm.parser.operators.

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

%% R_DOC (TODO), INSTANCE TR_DOC XMLABLE

%%% R_DOC (TODO)

r_doc(cr_doc(maybe.no,maybe.no,maybe.no,MAIN,maybe.no)) --> r_doc_main(MAIN).

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


%% R_TITLE (TODO), TS_TITLE XMLABLE

%%% R_TITLE

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_title) where [
  func(to_xml/1) is f_title_to_xml
].
:- func (
  f_title_to_xml(ts_title::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_title_to_xml(cs_title(STR)) =
  term_to_xml.elem("cs_title",[],[term_to_xml.data(STR)]).


%% R_ABSTRACT (TODO), TS_ABSTRACT XMLABLE

%%% R_ABSTRACT

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


%% R_REFS (TODO), TS_REFS XMLABLE

%%% R_REFS

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_refs) where [
  func(to_xml/1) is f_refs_to_xml
].
:- func (
  f_refs_to_xml(ts_refs::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_refs_to_xml(cs_refs(BLKS)) =
  term_to_xml.elem("cs_refs",[],[f_blks_to_xml(BLKS)]).


%% R_DOC_MAIN, INSTANCE TE_DOC_MAIN XMLABLE

%%% R_DOC_MAIN

r_doc_main(DOC_MAIN) --> (
  r_secs(   SECS), *([r_lb]), r_eof -> {DOC_MAIN = ce_doc_main_secs(SECS)};
  r_pars(   PARS), *([r_lb]), r_eof -> {DOC_MAIN = ce_doc_main_pars(PARS)};
  r_blks(0u,BLKS), *([r_lb]), r_eof -> {DOC_MAIN = ce_doc_main_blks(BLKS)};
                                       {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_doc_main) where [
  func(to_xml/1) is f_doc_main_to_xml
].
:- func (
  f_doc_main_to_xml(te_doc_main::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_doc_main_to_xml(ce_doc_main_chs(CHS))   =
  term_to_xml.elem("ce_doc_main_chs", [],[f_chs_to_xml(CHS)]).
f_doc_main_to_xml(ce_doc_main_secs(SECS)) =
  term_to_xml.elem("ce_doc_main_secs",[],[f_secs_to_xml(SECS)]).
f_doc_main_to_xml(ce_doc_main_pars(PARS)) =
  term_to_xml.elem("ce_doc_main_pars",[],[f_pars_to_xml(PARS)]).
f_doc_main_to_xml(ce_doc_main_blks(BLKS)) =
  term_to_xml.elem("ce_doc_main_blks",[],[f_blks_to_xml(BLKS)]).


%% R_CHS, INSTANCE TS_CHS_XMLABLE

%%% R_CHS

r_chs(CHS) --> (
  r_ch(CH),
  (
    +([r_lb]), r_chs(cs_chs(CHS_)) -> {CHS = cs_chs([CH]++CHS_)};
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

r_secs(SECS) --> (
  r_sec(SEC),
  (
    +([r_lb]), r_secs(cs_secs(SECS_)) -> {SECS = cs_secs([SEC]++SECS_)};
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

r_pars(PARS) --> (
  r_par(PAR),
  (
    +([r_lb]), r_pars(cs_pars(PARS_)) -> {PARS = cs_pars([PAR]++PARS_)};
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

r_blks(LVL,BLKS) --> (
  r_blk(LVL,BLK),
  (
    +([r_lb]), r_tabs(LVL), r_blks(LVL,cs_blks(BLKS_)) -> (
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

r_ch(cr_ch(MAYBE_TAG_OR_ID,MAYBE_HDR,MAIN)) --> (
  r_str("CH"),
  *([r_sp]),
  ?([],r_tag_or_id,MAYBE_TAG_OR_ID,[]),
  r_lb,
  ?([],r_hdr,MAYBE_HDR,[]),
  +([r_lb]),
  r_secs_pars_or_blks(MAIN)
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

r_sec(cr_sec(MAYBE_TAG_OR_ID,MAYBE_HDR,MAIN)) --> (
  r_str("§"),
  *([r_sp]),
  ?([],r_tag_or_id,MAYBE_TAG_OR_ID,[]),
  r_lb,
  ?([],r_hdr,MAYBE_HDR,[]),
  +([r_lb]),
  r_pars_or_blks(MAIN)
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


%% R_PAR, INSTANCE TR_PAR XMLABLE

%%% R_PAR

r_par(cr_par(MAYBE_TAG_OR_ID,MAYBE_HDR,BLKS)) -->
  r_str("¶"),
  *([r_sp]),
  ?([],r_tag_or_id,MAYBE_TAG_OR_ID,[]),
  r_lb,
  ?([],r_hdr,MAYBE_HDR,[]),
  +([r_lb]),
  r_blks(0u,BLKS).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_par) where [
  func(to_xml/1) is f_par_to_xml
].
:- func (
  f_par_to_xml(tr_par::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_par_to_xml(PAR) = XML :- (
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
    "cr_par",
    [],
    TAG_OR_ID_XML_LIST++HDR_XML_LIST++[f_blks_to_xml(BLKS)]
  )
).


%% R_BLK, INSTANCE TE_BLK XMLABLE

%%% R_BLK

r_blk(LVL,BLK) -->
  r_blk_txt(LVL,BLK_TXT) -> {BLK = ce_blk_txt(BLK_TXT)};
  r_blk_blt(LVL,BLK_BLT) -> {BLK = ce_blk_blt(BLK_BLT)};
  r_blk_itm(LVL,BLK_ITM) -> {BLK = ce_blk_itm(BLK_ITM)};
  r_blk_dsp(LVL,BLK_DSP) -> {BLK = ce_blk_dsp(BLK_DSP)};
                            {false}.

%%% INSTANCE XMLABLE

:- instance term_to_xml.xmlable(te_blk) where [
  func(to_xml/1) is f_blk_to_xml
].
:- func (
  f_blk_to_xml(te_blk::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_to_xml(ce_blk_txt(BLK)) =
  term_to_xml.elem("ce_blk_txt",[],[f_blk_txt_to_xml(BLK)]).
f_blk_to_xml(ce_blk_blt(BLK)) =
  term_to_xml.elem("ce_blk_blt",[],[f_blk_blt_to_xml(BLK)]).
f_blk_to_xml(ce_blk_itm(BLK)) =
  term_to_xml.elem("ce_blk_itm",[],[f_blk_itm_to_xml(BLK)]).
f_blk_to_xml(ce_blk_dsp(BLK)) =
  term_to_xml.elem("ce_blk_dsp",[],[f_blk_dsp_to_xml(BLK)]).


%% R_HDR, INSTANCE TS_HDR XMLABLE

%%% R_HDR

r_hdr(cs_hdr(UNITS)) --> r_blk_txt(0u,cs_blk_txt(UNITS)).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_hdr) where [
  func(to_xml/1) is f_hdr_to_xml
].
:- func (
  f_hdr_to_xml(ts_hdr::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_hdr_to_xml(cs_hdr(UNITS)) =
  term_to_xml.elem("cs_hdr",[],[f_txt_units_to_xml(UNITS)]).


%% R_SECS_PARS_OR_BLKS AND TE_SECS_PARS_OR_BLKS_XMLABLE

%%% R_SECS_PARS_OR_BLKS

r_secs_pars_or_blks(SECS_PARS_OR_BLKS) --> (
  r_secs(   SECS) -> {SECS_PARS_OR_BLKS = ce_secs_pars_or_blks_secs(SECS)};
  r_pars(   PARS) -> {SECS_PARS_OR_BLKS = ce_secs_pars_or_blks_pars(PARS)};
  r_blks(0u,BLKS) -> {SECS_PARS_OR_BLKS = ce_secs_pars_or_blks_blks(BLKS)};
  {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_secs_pars_or_blks) where [
  func(to_xml/1) is f_secs_pars_or_blks_to_xml
].
:- func (
  f_secs_pars_or_blks_to_xml(te_secs_pars_or_blks::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_secs_pars_or_blks_to_xml(SECS_PARS_OR_BLKS) = XML :- (
  (
    SECS_PARS_OR_BLKS = ce_secs_pars_or_blks_secs(SECS),
    XML               =
      term_to_xml.elem("ce_secs_pars_or_blks_secs",[],[f_secs_to_xml(SECS)])
  );
  (
    SECS_PARS_OR_BLKS = ce_secs_pars_or_blks_pars(PARS),
    XML               =
      term_to_xml.elem("ce_secs_pars_or_blks_pars",[],[f_pars_to_xml(PARS)])
  );
  (
    SECS_PARS_OR_BLKS = ce_secs_pars_or_blks_blks(BLKS),
    XML               =
      term_to_xml.elem("ce_secs_pars_or_blks_blks",[],[f_blks_to_xml(BLKS)])
  )
).


%% R_PARS_OR_BLKS AND TE_PARS_OR_BLKS_XMLABLE

%%% R_PARS_OR_BLKS

r_pars_or_blks(PARS_OR_BLKS) --> (
  r_pars(   PARS) -> {PARS_OR_BLKS = ce_pars_or_blks_pars(PARS)};
  r_blks(0u,BLKS) -> {PARS_OR_BLKS = ce_pars_or_blks_blks(BLKS)};
                     {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_pars_or_blks) where [
  func(to_xml/1) is f_pars_or_blks_to_xml
].

:- func (
  f_pars_or_blks_to_xml(te_pars_or_blks::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_pars_or_blks_to_xml(PARS_OR_BLKS) = XML :- (
  (
    PARS_OR_BLKS = ce_pars_or_blks_pars(PARS),
    XML          =
      term_to_xml.elem("ce_pars_or_blks_pars",[],[f_pars_to_xml(PARS)])
  );
  (
    PARS_OR_BLKS = ce_pars_or_blks_blks(BLKS),
    XML          =
      term_to_xml.elem("ce_pars_or_blks_blks",[],[f_blks_to_xml(BLKS)])
  )
).




%% R_TXT_UNIT, T_TXT_UNIT XMLABLE

%%% R_TXT_UNIT

r_txt_unit(LVL,U) --> (
  r_c_ref(CR)                ->
    {U = ce_txt_unit_c_ref(cs_txt_unit_c_ref(CR))};
  r_txt_unit_emph(LVL,U_)    ->
    {U = ce_txt_unit_emph(U_)};
  r_txt_unit_wysiwyg(LVL,U_) ->
    {U = ce_txt_unit_wysiwyg(U_)};
  {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_txt_unit) where [
  func(to_xml/1) is f_txt_unit_to_xml
].
:- func (
  f_txt_unit_to_xml(te_txt_unit::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_unit_to_xml(ce_txt_unit_c_ref(C_REF))  =
  term_to_xml.elem("ce_txt_unit_c_ref",  [],[f_txt_unit_c_ref_to_xml(C_REF)]).
f_txt_unit_to_xml(ce_txt_unit_wysiwyg(U)) =
  term_to_xml.elem("ce_txt_unit_wysiwyg",[],[f_txt_unit_wysiwyg_to_xml(U)]).
f_txt_unit_to_xml(ce_txt_unit_emph(U))    =
  term_to_xml.elem("ce_txt_unit_emph",   [],[f_txt_unit_emph_to_xml(U)]).


%% R_TXT_UNIT_EMPH, INSTANCE TS_TXT_UNIT_EMPH XMLABLE

%%% R_TXT_UNIT_EMPH

r_txt_unit_emph(LVL,cs_txt_unit_emph(STR)) -->
  r_str("*"), r_txt_unit_emph_str(LVL,STR), r_str("*").

:- pred r_txt_unit_emph_str(uint, str, ta_tkns, ta_tkns).
:- mode r_txt_unit_emph_str(in,   out, in,     out) is semidet.
r_txt_unit_emph_str(        LVL,  S) --> (
  r(ce_r_any,["*"],S_),
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

r_txt_unit_wysiwyg(LVL,cs_txt_unit_wysiwyg(STR)) -->
  +([],r_txt_unit_wysiwyg_chr,LVL,CHRS,[]), {STR = chrs2str(CHRS)}.

:- pred r_txt_unit_wysiwyg_chr(ta_lvl, chr, ta_tkns, ta_tkns).
:- mode r_txt_unit_wysiwyg_chr(in,     out, in,      out) is semidet.
r_txt_unit_wysiwyg_chr(        LVL,    C) -->
  not r_tab,
  not r_lb,
  not r_c_ref(_),
  not r_txt_unit_emph(LVL,_),
  r_c(ce_r_any,C).


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


%% R_TXT_UNIT_CREF, INSTANCE TS_TXT_UNIT_CREF XMLABLE

%%% R_TXT_UNIT_CREF

r_txt_unit_c_ref(cs_txt_unit_c_ref(C_REF)) --> r_c_ref(C_REF).

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


%% R_TXT_UNITS, TS_TXT_UNITS, TS_TXT_UNITS XMLABLE

%%% R_TXT_UNITS

r_txt_units(LVL,cs_txt_units(US)) --> +([],r_txt_unit,LVL,US,[]).

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


%% R_LBL, TE_LBL XMLABLE

%%% R_LBL

r_lbl(LBL) --> (
  r(ce_r_any,["(",")","[","]"],S) -> {LBL = ce_lbl_custom(S)};
                                     {LBL = ce_lbl_auto}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_lbl) where [
  func(to_xml/1) is f_lbl_to_xml
].
:- func (
  f_lbl_to_xml(te_lbl::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_lbl_to_xml(ce_lbl_auto)      = term_to_xml.elem("ce_lbl_auto",[],[]).
f_lbl_to_xml(ce_lbl_custom(S)) =
  term_to_xml.elem("ce_lbl_custom",[],[term_to_xml.data(S)]).


%% R_TAG_OR_ID, INSTANCE TE_TAG_OR_ID XMLABLE

%%% R_TAG_OR_ID

r_tag_or_id(TAG_OR_ID) --> (
  r_id(ID)   -> {TAG_OR_ID = ce_tag_or_id_id(ID)};
  r_tag(TAG) -> {TAG_OR_ID = ce_tag_or_id_tag(TAG)};
                {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_tag_or_id) where [
  func(to_xml/1) is f_tag_or_id_to_xml
].
:- func (
  f_tag_or_id_to_xml(te_tag_or_id::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_tag_or_id_to_xml(ce_tag_or_id_tag(TAG)) =
  term_to_xml.elem("ce_tag_or_id_tag",[],[f_tag_to_xml(TAG)]).
f_tag_or_id_to_xml(ce_tag_or_id_id(ID))   =
  term_to_xml.elem("ce_tag_or_id_id", [],[f_id_to_xml(ID)]).

%% R_TAG AND INSTANCE TS_TAG XMLABLE

r_tag(cs_tag(S)) --> r(ce_r_nws,k_forbidden_strs_in_tags_names,S).

:- instance term_to_xml.xmlable(ts_tag) where [
  func(to_xml/1) is f_tag_to_xml
].
:- func (
  f_tag_to_xml(ts_tag::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_tag_to_xml(cs_tag(S)) = term_to_xml.elem("cs_tag",[],[term_to_xml.data(S)]).


%% R_NAME AND INSTANCE TS_NAME XMLABLE

r_name(cs_name(S)) --> r(ce_r_nws,k_forbidden_strs_in_tags_names,S).

:- instance term_to_xml.xmlable(ts_name) where [
  func(to_xml/1) is f_name_to_xml
].

:- func (
  f_name_to_xml(ts_name::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

f_name_to_xml(cs_name(S)) =
  term_to_xml.elem("cs_name",[],[term_to_xml.data(S)]).


%% R_ID AND INSTANCE TR_ID XMLABLE

r_id(cr_id(TAG,NAME)) -->
  r_tag(TAG), r_str(":"), r_name(NAME).

:- instance term_to_xml.xmlable(tr_id) where [
  func(to_xml/1) is f_id_to_xml
].
:- func (
  f_id_to_xml(tr_id::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_id_to_xml(cr_id(TAG,NAME)) =
  term_to_xml.elem("cr_id",[],[f_tag_to_xml(TAG),f_name_to_xml(NAME)]).


%% R_C_REF AND INSTANCE T_C_REF XMLABLE

r_c_ref(cs_c_ref(ID)) --> r_str("["), r_id(ID), r_str("]").


:- instance term_to_xml.xmlable(ts_c_ref) where [
  func(to_xml/1) is f_c_ref_to_xml
].
:- func (
  f_c_ref_to_xml(ts_c_ref::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_c_ref_to_xml(cs_c_ref(ID)) =
  term_to_xml.elem("cs_c_ref",[],[f_id_to_xml(ID)]).


%% R_BLK_TXT, INSTANCE TS_BLK_TXT XMLABLE

%%% R_BLK_TXT

r_blk_txt(LVL,cs_blk_txt(UNITS)) --> (
  (
    if {LVL = 0u} then
      not r_str("CH"),
      not r_str("§"),
      not r_str("¶")
    else
      {true}
  ),
  r_blk_txt_lines(LVL,UNITS)
).

:- pred r_blk_txt_lines(ta_lvl, ts_txt_units, ta_tkns, ta_tkns).
:- mode r_blk_txt_lines(in,     out,          in,      out) is semidet.
r_blk_txt_lines(        LVL,    cs_txt_units(US)) --> (
  r_blk_txt_line(LVL,cs_txt_units(US_)),
  (
    r_tabs(LVL), r_blk_txt_lines(LVL,cs_txt_units(US__)) ->
      {US = US_ ++ [ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" "))] ++ US__};
    {US = US_}
  )
).

:- pred r_blk_txt_line(ta_lvl, ts_txt_units, ta_tkns, ta_tkns).
:- mode r_blk_txt_line(in,     out,          in,      out) is semidet.
r_blk_txt_line(        LVL,    US) --> r_txt_units(LVL,US), r_lb.

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

r_blk_blt(LVL,cs_blk_blt(BLKS)) --> r_str("-"), r_tab, r_blks(LVL+1u,BLKS).

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

r_blk_itm(LVL,cr_blk_itm(LBL,MAYBE_TAG_OR_ID,BLKS)) --> (
  r_str("["), r_lbl(LBL), r_str("]"), r_tab,
  (
    if r_tag_or_id(TAG_OR_ID), r_lb, r_tabs(LVL+1u) then
      {MAYBE_TAG_OR_ID = maybe.yes(TAG_OR_ID)}
    else
      {MAYBE_TAG_OR_ID = maybe.no}
  ),
  r_blks(LVL+1u,BLKS)
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

r_blk_dsp(LVL,cs_blk_dsp(DSP_LINES)) --> r_dsp_lines(LVL,DSP_LINES).

:- instance term_to_xml.xmlable(ts_blk_dsp) where [
  func(to_xml/1) is f_blk_dsp_to_xml
].
:- func (
  f_blk_dsp_to_xml(ts_blk_dsp::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_blk_dsp_to_xml(cs_blk_dsp(DSP_LINES)) =
  term_to_xml.elem("cs_blk_dsp",[],[f_dsp_lines_to_xml(DSP_LINES)]).


%% R_DSP_LINES, INSTANCE TS_DSP_LINES XMLABLE

%%% R_DSP_LINES

r_dsp_lines(LVL,cs_dsp_lines(LS)) --> (
  r_dsp_line(L),
  (
    r_tabs(LVL),r_dsp_lines(LVL,cs_dsp_lines(LS_)) -> {LS = [L]++LS_};
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

r_dsp_line(LINE) --> (
  r_dsp_line_no_lbl(LINE_) -> {LINE = ce_dsp_line_no_lbl(LINE_)};
  r_dsp_line_lbld(  LINE_) -> {LINE = ce_dsp_line_lbld(  LINE_)};
                              {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_dsp_line) where [
  func(to_xml/1) is f_dsp_line_to_xml
].
:- func (
  f_dsp_line_to_xml(te_dsp_line::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_dsp_line_to_xml(ce_dsp_line_no_lbl(L)) =
  term_to_xml.elem("ce_dsp_line_no_lbl",[],[f_dsp_line_no_lbl_to_xml(L)]).
f_dsp_line_to_xml(ce_dsp_line_lbld(  L)) =
  term_to_xml.elem("ce_dsp_line_lbld",  [],[f_dsp_line_lbld_to_xml(  L)]).


%% R_DSP_LINE_LBLD, TR_DSP_LINE_LBLD XMLABLE

%%% R_DSP_LINE_LBLD

r_dsp_line_lbld(cr_dsp_line_lbld(LBL,MAYBE_ID,cs_txt_units(US))) --> (
  r_str("("),
  r_lbl(LBL),
  r_str(")"),
  r_tab,
  +([],r_dsp_unit,US,[]),
  ?([+([r_tab])],r_id,MAYBE_ID,[]),
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
    "cr_dsp_line",
    [],
    [f_lbl_to_xml(LBL)]++ID_XML_LIST++[f_txt_units_to_xml(UNITS)]
  )
).


%% R_DSP_LINE_NO_LBL, TS_DSP_LINE_NO_LBL XMLABLE

%%% R_DSP_LINE_NO_LBL

r_dsp_line_no_lbl(cs_dsp_line_no_lbl(cs_txt_units(US))) --> (
  r_tab,
  +([],r_dsp_unit,US,[]),
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


%% R_DSP_UNIT, INSTANCE XMLABLE

%%% R_DSP_UNIT

r_dsp_unit(U) --> (
  r_c_ref(CR)            -> {U = ce_txt_unit_c_ref(cs_txt_unit_c_ref(CR))};
  r_dsp_unit_emph(U_)    -> {U = U_};
  r_dsp_unit_wysiwyg(U_) -> {U = U_};
  {false}
).

%%% R_DSP_UNIT_EMPH

:- pred r_dsp_unit_emph(te_txt_unit::out, ta_tkns::in, ta_tkns::out) is semidet.
r_dsp_unit_emph(        ce_txt_unit_emph(U)) -->
  r_str("*"), r(ce_r_any,["*"],S), r_str("*"), {U = cs_txt_unit_emph(S)}.

%%% R_DSP_UNIT_WYSIWYG

:- pred r_dsp_unit_wysiwyg(te_txt_unit, ta_tkns, ta_tkns).
:- mode r_dsp_unit_wysiwyg(out,         in,      out) is semidet.
r_dsp_unit_wysiwyg(ce_txt_unit_wysiwyg(U)) --> r_txt_unit_wysiwyg(0u,U).
