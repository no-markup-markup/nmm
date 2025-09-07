:- module nmm.parser_2.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% TODO: SUBMODULES

 %% :- include_module parser.test.


%% MODULE IMPORTS

:- use_module
  term_to_xml
  ,
  nmm.lexer
  .


%% TYPE ABBREVIATIONS TA_TKN AND TA_TKNS

:- type ta_tkn  == nmm.lexer.t_tkn.
:- type ta_tkns == nmm.lexer.t_tkns.


%% RECORD TYPE TR_CONF (TODO: USE)

:- type tr_conf ---> cr_conf(
  fld_conf_extra_ch_tags  :: strs, % in addition to ‘CH'
  fld_conf_extra_sec_tags :: strs, % in addition to ‘SEC'
  fld_conf_extra_app_tags :: strs, % in addition to ‘APP'
  fld_conf_extra_par_tags :: strs, % in addition to ‘PAR'
  fld_conf_extra_itm_tags :: strs, % in addition to ‘ITM'
  fld_conf_extra_dsp_tags :: strs  % in addition to ‘DSP’
).


%% FUNCTION F_VALIDATE_CONF AND ENUM TYPE TE_VALIDATE_CONF_RES

:- type te_validate_conf_res --->
  ce_validate_conf_res_ok;
  ce_validate_conf_res_err(str).

:- func f_validate_conf(tr_conf) = te_validate_conf_res.


%% RECORD TYPE TR_VALID_TAGS

:- type tr_valid_tags ---> cr_valid_tags(
  fld_valid_tags_ch  :: strs,
  fld_valid_tags_sec :: strs,
  fld_valid_tags_app :: strs,
  fld_valid_tags_par :: strs,
  fld_valid_tags_itm :: strs,
  fld_valid_tags_dsp :: strs
).


%% ALIAS TYPE TS_ALL_VALID_TAGS (= STRS)

:- type ta_all_valid_tags == strs.


%% FUNCTION F_ALL_VALID_TAGS

:- func f_all_valid_tags(tr_valid_tags) = ta_all_valid_tags.


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

 %% :- pred r_doc(tr_valid_tags::in, tr_doc::out, ta_tkns::in, ta_tkns::out) is semidet.


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


%% RULE R_DOC_MAIN, ENUM TYPE TE_DOC_MAIN, INSTANCE TE_DOC_MAIN XMLABLE

:- type te_doc_main --->
  ce_doc_main_chs(ts_chs);
  ce_doc_main_secs(ts_secs);
  ce_doc_main_pars(ts_pars);
  ce_doc_main_blks(ts_blks).

:- instance term_to_xml.xmlable(te_doc_main).

:- pred r_doc_main(tr_valid_tags, te_doc_main, ta_tkns, ta_tkns).
:- mode r_doc_main(in,            out,         in,      out) is semidet.


%% RULE R_REFS (TODO), SIMPLE TYPE TS_REFS, INSTANCE TS_REFS XMLABLE

:- type ts_refs ---> cs_refs(ts_blks).

:- instance term_to_xml.xmlable(ts_refs).

 %% :- pred r_refs(ts_refs::out, ta_tkns::in, ta_tkns::out).


%% RULE R_CHS (TODO), SIMPLE TYPE TS_CHS, INSTANCE TS_CHS_XMLABLE

:- type ts_chs ---> cs_chs(list(tr_ch)).

:- instance term_to_xml.xmlable(ts_chs).

 %% :- pred r_chs(tr_valid_tags, ts_chs, ta_tkns, ta_tkns).
 %% :- mode r_chs(in,            out,    in,      out) is semidet.


%% RULE R_SECS, SIMPLE TYPE TS_SECS, INSTANCE TS_SECS_XMLABLE

:- type ts_secs ---> cs_secs(list(tr_sec)).

:- instance term_to_xml.xmlable(ts_secs).

:- pred r_secs(tr_valid_tags, ts_secs, ta_tkns, ta_tkns).
:- mode r_secs(in,            out,     in,      out) is semidet.


%% RULE R_PARS, SIMPLE TYPE TS_PARS, INSTANCE TS_PAR_XMLABLE

:- type ts_pars ---> cs_pars(list(tr_par)).

:- instance term_to_xml.xmlable(ts_pars).

:- pred r_pars(tr_valid_tags, ts_pars, ta_tkns, ta_tkns).
:- mode r_pars(in,            out,     in,      out) is semidet.


%% RULE R_BLKS, SIMPLE TYPE TS_BLKS, INSTANCE TS_BLKS_XMLABLE

:- type ts_blks ---> cs_blks(list(te_blk)).

:- instance term_to_xml.xmlable(ts_blks).

:- pred r_blks(tr_valid_tags, ta_lvl, ts_blks, ta_tkns, ta_tkns).
:- mode r_blks(in,            in,     out,     in,      out) is semidet.


%% RULE R_CH (TODO), RECORD TYPE TR_CH, INSTANCE TR_CH XMLABLE

:- type tr_ch ---> cr_ch(
  fld_ch_tag_or_id :: maybe(te_tag_or_id),
  fld_ch_hdr       :: maybe(ts_hdr),
  fld_ch_intro     :: maybe(ts_blks),
  fld_ch_main      :: te_secs_pars_or_blks
).

:- instance term_to_xml.xmlable(tr_ch).

:- pred r_ch(tr_valid_tags, tr_ch,  ta_tkns, ta_tkns).
:- mode r_ch(in,            out,    in,      out) is semidet.


%% RULE R_SEC, RECORD TYPE TR_SEC, INSTANCE TR_SEC XMLABLE

:- type tr_sec ---> cr_sec(
  fld_sec_tag_or_id :: maybe(te_tag_or_id),
  fld_sec_hdr       :: maybe(ts_hdr),
  fld_sec_intro     :: maybe(ts_blks),
  fld_sec_main      :: te_pars_or_blks
).

:- instance term_to_xml.xmlable(tr_sec).

:- pred r_sec(tr_valid_tags, tr_sec, ta_tkns, ta_tkns).
:- mode r_sec(in,            out,    in,      out) is semidet.


%% RULE R_PAR, RECORD TYPE TR_PAR, INSTANCE TR_PAR XMLABLE

:- type tr_par ---> cr_par(
  fld_par_tag_or_id :: maybe(te_tag_or_id),
  fld_par_hdr       :: maybe(ts_hdr),
  fld_par_main      :: ts_blks
).

:- instance term_to_xml.xmlable(tr_par).

:- pred r_par(tr_valid_tags, tr_par, ta_tkns, ta_tkns).
:- mode r_par(in,            out,    in,      out) is semidet.


%% RULE R_BLK, ENUM TYPE TE_BLK, INSTANCE TE_BLK XMLABLE

:- type te_blk --->
  ce_blk_txt(ts_blk_txt);
  ce_blk_blt(ts_blk_blt);
  ce_blk_itm(tr_blk_itm);
  ce_blk_dsp(ts_blk_dsp).

:- instance term_to_xml.xmlable(te_blk).

:- pred r_blk(tr_valid_tags, ta_lvl, te_blk, ta_tkns, ta_tkns).
:- mode r_blk(in,            in,     out,    in,      out) is semidet.


%% RULE R_HDR, SIMPLE TYPE TS_HDR, INSTANCE TS_HDR XMLABLE

:- type ts_hdr ---> cs_hdr(ts_txt_units).

:- instance term_to_xml.xmlable(ts_hdr).

:- pred r_hdr(tr_valid_tags, ts_hdr, ta_tkns, ta_tkns).
:- mode r_hdr(in,            out,    in,      out) is semidet.


%% RULE R_SECS_PARS_OR_BLKS, ENUM TYPE TE_SECS_PARS_OR_BLKS, INSTANCE TE_SECS_PARS_OR_BLKS XMLABLE

:- type te_secs_pars_or_blks ---> (
  ce_secs_pars_or_blks_secs(ts_secs);
  ce_secs_pars_or_blks_pars(ts_pars);
  ce_secs_pars_or_blks_blks(ts_blks)
).

:- instance term_to_xml.xmlable(te_secs_pars_or_blks).

:- pred r_secs_pars_or_blks(
  tr_valid_tags, te_secs_pars_or_blks, ta_tkns, ta_tkns
).
:- mode r_secs_pars_or_blks(
  in,            out,                  in,      out
) is semidet.


%% RULE R_PARS_OR_BLKS, ENUM TYPE TE_PARS_OR_BLKS, INSTANCE TE_PARS_OR_BLKS XMLABLE

:- type te_pars_or_blks ---> (
  ce_pars_or_blks_pars(ts_pars);
  ce_pars_or_blks_blks(ts_blks)
).

:- instance term_to_xml.xmlable(te_pars_or_blks).

:- pred r_pars_or_blks(tr_valid_tags, te_pars_or_blks, ta_tkns, ta_tkns).
:- mode r_pars_or_blks(in,            out,             in,      out) is semidet.


%% RULE R_TXT_UNIT, ENUM TYPE TE_TXT_UNIT, INSTANCE TE_TXT_UNIT XMLABLE

:- type te_txt_unit --->
  ce_txt_unit_wysiwyg(ts_txt_unit_wysiwyg);
  ce_txt_unit_emph(ts_txt_unit_emph);
  ce_txt_unit_c_ref(ts_txt_unit_c_ref).

:- instance term_to_xml.xmlable(te_txt_unit).

% doc:             VALID_TAGS
:- pred r_txt_unit(strs,      ta_lvl, te_txt_unit, ta_tkns, ta_tkns).
:- mode r_txt_unit(in,        in,     out,         in,      out) is semidet.


%% SIMPLE TYPES TS_TXT_UNIT_WYSIWYG, TS_TXT_UNIT_EMPH, TS_TXT_UNIT_CREF AND THEIR XMLABLE INSTANCES

:- type ts_txt_unit_wysiwyg ---> cs_txt_unit_wysiwyg(str).
:- type ts_txt_unit_emph    ---> cs_txt_unit_emph(str).
:- type ts_txt_unit_c_ref   ---> cs_txt_unit_c_ref(ts_c_ref).

:- instance term_to_xml.xmlable(ts_txt_unit_wysiwyg).
:- instance term_to_xml.xmlable(ts_txt_unit_emph).
:- instance term_to_xml.xmlable(ts_txt_unit_c_ref).


%% RULE R_TXT_UNITS, SIMPLE TYPE TS_TXT_UNITS, INSTANCE TS_TXT_UNITS XMLABLE

:- type ts_txt_units ---> cs_txt_units(list(te_txt_unit)).

:- instance term_to_xml.xmlable(ts_txt_units).

% doc:              VALID_TAGS
:- pred r_txt_units(strs,      ta_lvl, ts_txt_units, ta_tkns, ta_tkns).
:- mode r_txt_units(in,        in,     out,          in,      out) is semidet.


%% RULE R_LBL, ENUM TYPE TE_LBL, INSTANCE TE_LBL XMLABLE

:- type te_lbl --->
  ce_lbl_auto;
  ce_lbl_custom(str).

:- instance term_to_xml.xmlable(te_lbl).

:- pred r_lbl(te_lbl::out, ta_tkns::in, ta_tkns::out) is det.


%% RULES ET CETERA FOR IDS, TAGS, NAMES AND CROSS-REFERENCES

%%% RULE R_TAG_OR_ID, ENUM TYPE TE_TAG_OR_ID, INSTANCE TE_TAG_OR_ID_XMLABLE

:- type te_tag_or_id --->
  ce_tag_or_id_tag(ts_tag);
  ce_tag_or_id_id(tr_id).

:- instance term_to_xml.xmlable(te_tag_or_id).

% doc:              VALID_TAGS
:- pred r_tag_or_id(strs,      te_tag_or_id, ta_tkns, ta_tkns).
:- mode r_tag_or_id(in,        out,          in,      out) is semidet.

%%% RULE R_TAG, SIMPLE TYPE TS_TAG, INSTANCE TS_TAG XMLABLE

:- type ts_tag ---> cs_tag(str).

:- instance term_to_xml.xmlable(ts_tag).

% doc:        VALID_TAGS
:- pred r_tag(strs::in,  ts_tag::out, ta_tkns::in, ta_tkns::out) is semidet.

%%% RULE R_NAME, SIMPLE TYPE TS_NAME, INSTANCE TS_NAME XMLABLE

:- type ts_name ---> cs_name(str).

:- instance term_to_xml.xmlable(ts_name).

:- pred r_name(ts_name::out, ta_tkns::in, ta_tkns::out) is semidet.

%%% RULE R_ID, RECORD TYPE TR_ID, INSTANCE TR_ID XMLABLE

:- type tr_id ---> cr_id(
  fld_id_tag  :: ts_tag,
  fld_id_name :: ts_name
).

:- instance term_to_xml.xmlable(tr_id).

% doc:       VALID_TAGS
:- pred r_id(strs::in,  tr_id::out, ta_tkns::in, ta_tkns::out) is semidet.

%%% RULE R_C_REF, SIMPLE TYPE TS_C_REF, INSTANCE TS_C_REF XMLABLE

:-type ts_c_ref ---> cs_c_ref(tr_id).

:- instance term_to_xml.xmlable(ts_c_ref).

% doc:          VALID_TAGS
:- pred r_c_ref(strs::in,  ts_c_ref::out, ta_tkns::in, ta_tkns::out) is semidet.


%% RULES ET CETERA FOR THE DIFFERENT BLOCK TYPES

%%% RULE R_BLK_TXT, SIMPLE TYPE TS_BLK_TXT, INSTANCE TS_BLK_TXT XMLABLE

:- type ts_blk_txt ---> cs_blk_txt(ts_txt_units).

:- instance term_to_xml.xmlable(ts_blk_txt).

:- pred r_blk_txt(tr_valid_tags, ta_lvl, ts_blk_txt, ta_tkns, ta_tkns).
:- mode r_blk_txt(in,            in,     out,        in,      out) is semidet.

%%% RULE R_BLK_BLT, SIMPLE TYPE TS_BLK_BLT, INSTANCE TS_BLK_BLT XMLABLE

:- type ts_blk_blt ---> cs_blk_blt(ts_blks).

:- instance term_to_xml.xmlable(ts_blk_blt).

:- pred r_blk_blt(tr_valid_tags, ta_lvl, ts_blk_blt, ta_tkns, ta_tkns).
:- mode r_blk_blt(in,            in,     out,        in,      out) is semidet.

%%% RULE R_BLK_ITM, RECORD TYPE TR_BLK_ITM, INSTANCE TR_BLK_ITM XMLABLE

:- type tr_blk_itm ---> cr_blk_itm(
  fld_blk_itm_lbl       :: te_lbl,
  fld_blk_itm_tag_or_id :: maybe(te_tag_or_id),
  fld_blk_itm_main      :: ts_blks
).

:- instance term_to_xml.xmlable(tr_blk_itm).

:- pred r_blk_itm(tr_valid_tags, ta_lvl, tr_blk_itm, ta_tkns, ta_tkns).
:- mode r_blk_itm(in,            in,     out,        in,      out) is semidet.

%%% RULE R_BLK_DSP, SIMPLE TYPE TS_BLK_DSP, INSTANCE TS_BLK_DSP XMLABLE

:- type ts_blk_dsp ---> cs_blk_dsp(ts_dsp_lines).

:- instance term_to_xml.xmlable(ts_blk_dsp).

:- pred r_blk_dsp(ts_blk_dsp, ta_lvl, tr_valid_tags, ta_tkns, ta_tkns).
:- mode r_blk_dsp(out,        in,     in,            in,      out) is semidet.

%%% RULE R_DSP_LINE, RECORD TYPE TR_DSP_LINE, INSTANCE TR_DSP_LINE XMLABLE

:- type tr_dsp_line ---> cr_dsp_line(
  fld_dsp_line_lbl       :: maybe(te_lbl),
  fld_dsp_line_tag_or_id :: maybe(te_tag_or_id),
  fld_dsp_line_units     :: ts_txt_units
).

:- instance term_to_xml.xmlable(tr_dsp_line).

:- pred r_dsp_line(tr_valid_tags, tr_dsp_line, ta_tkns, ta_tkns).
:- mode r_dsp_line(in,            out,         in,      out) is semidet.

%%% RULE R_DSP_LINES, SIMPLE TYPE TS_DSP_LINES, INSTANCE TS_DSP_LINES XMLABLE

:- type ts_dsp_lines ---> cs_dsp_lines(list(tr_dsp_line)).

:- instance term_to_xml.xmlable(ts_dsp_lines).

:- pred r_dsp_lines(tr_valid_tags, ta_lvl, ts_dsp_lines, ta_tkns, ta_tkns).
:- mode r_dsp_lines(
                    in,            in,     out,          in,      out
) is semidet.

%%% RULE R_DSP_UNIT (TODO: needed?)

% doc:             VALID_TAGS
:- pred r_dsp_unit(strs,      ta_lvl, te_txt_unit, ta_tkns, ta_tkns).
:- mode r_dsp_unit(in,        in,     out,         in,      out) is semidet.

%%% RULE R_DSP_UNITS

% doc:              VALID_TAGS
:- pred r_dsp_units(strs,      ta_lvl, ts_txt_units, ta_tkns, ta_tkns).
:- mode r_dsp_units(in,        in,     out,          in,      out) is semidet.



% TODO: IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- import_module
  uint
  ,
  nmm.parser_helpers
  .

%% FUNCTION F_ALL_VALID_TAGS

f_all_valid_tags(VALID_TAGS) = list.condense([
  fld_valid_tags_ch(VALID_TAGS),
  fld_valid_tags_sec(VALID_TAGS),
  fld_valid_tags_app(VALID_TAGS),
  fld_valid_tags_par(VALID_TAGS),
  fld_valid_tags_itm(VALID_TAGS),
  fld_valid_tags_dsp(VALID_TAGS)
]).

%% FUNCTION F_VALIDATE_CONF

%%% THE FUNCTION

f_validate_conf(CONF) = RES :-
  (
    if (
      SEC_TAGS = ["SEC"] ++ fld_conf_extra_sec_tags(CONF),
      APP_TAGS = ["APP"] ++ fld_conf_extra_app_tags(CONF),
      list.any_true(
        (pred(TAG::in) is semidet :- list.member(TAG,APP_TAGS)),
        SEC_TAGS
      )
    ) then (
      RES = c_validate_conf_res_err("chapter and appendix tags intersect")
    ) else if not p_valid_tags(fld_conf_extra_ch_tags( CONF)) then (
      RES = c_validate_conf_res_err("invalid chapter tags")
    ) else if not p_valid_tags(fld_conf_extra_sec_tags(CONF)) then (
      RES = c_validate_conf_res_err("invalid section tags")
    ) else if not p_valid_tags(fld_conf_extra_app_tags(CONF)) then (
      RES = c_validate_conf_res_err("invalid appendix tags")
    ) else if not p_valid_tags(fld_conf_extra_par_tags(CONF)) then (
      RES = c_validate_conf_res_err("invalid paragraph tags")
    ) else if not p_valid_tags(fld_conf_extra_itm_tags(CONF)) then (
      RES = c_validate_conf_res_err("invalid item tags")
    ) else if not p_valid_tags(fld_conf_extra_dsp_tags(CONF)) then (
      RES = c_validate_conf_res_err("invalid displayed tags")
    ) else (
      RES = c_validate_conf_res_ok
    )
  ).

%%% HELPER P_VALID_TAGS

:- pred p_valid_tags(strs::in) is semidet.
p_valid_tags([]).
p_valid_tags([TAG|TAGS]) :- p_valid_tag(TAG), p_valid_tags(TAGS).


%%% HELPER P_VALID_TAG

:- pred p_valid_tag(str::in) is semidet.
p_valid_tag(TAG) :- list.all_false(
  (pred(S::in) is semidet :- string.sub_string_search(TAG,S,_)),
  k_forbidden_strs_in_tags_names
).


%% CONSTANT K_FORBIDDEN_STRS_IN_TAGS_NAMES

:- func k_forbidden_strs_in_tags_names = strs.
k_forbidden_strs_in_tags_names = ["\\", "[", "]", "(", ")", ":", ",", ";", "*"].

%% R_DOC_MAIN, INSTANCE TE_DOC_MAIN XMLABLE

%%% R_DOC_MAIN

r_doc_main(VALID_TAGS,DOC_MAIN) --> (
  r_secs(SECS,   VALID_TAGS), re_eof -> {DOC_MAIN = ce_doc_main_secs(SECS)};
  r_pars(PARS,   VALID_TAGS), re_eof -> {DOC_MAIN = ce_doc_main_pars(PARS)};
  r_blks(BLKS,0u,VALID_TAGS), re_eof -> {DOC_MAIN = ce_doc_main_blks(BLKS)};
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
f_doc_main_to_xml(ce_doc_main_secs(SECS)) =
  term_to_xml.elem("ce_doc_main_secs",[],list.map(f_sec_to_xml,SECS)).
f_doc_main_to_xml(ce_doc_main_pars(PARS)) =
  term_to_xml.elem("ce_doc_main_pars",[],list.map(f_par_to_xml,PARS)).
f_doc_main_to_xml(ce_doc_main_blks(BLKS)) =
  term_to_xml.elem("ce_doc_main_blks",[],list.map(f_blk_to_xml,BLKS)).


%% R_SECS, INSTANCE TS_SECS_XMLABLE

%%% R_SECS

r_secs(VALID_TAGS,SECS) --> (
  r_sec(VALID_TAGS,SEC),
  (
    +(r_lb), r_secs(VALID_TAGS,SECS_) -> {SECS = [SEC]++SECS_};
                                         {SECS = [SEC]}
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

r_pars(VALID_TAGS,PARS) --> (
  r_par(VALID_TAGS,PAR),
  (
    +(r_lb), r_pars(VALID_TAGS,PARS_) -> {PARS = [PAR]++PARS_};
                                         {PARS = [PAR]}
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

r_blks(VALID_TAGS,LVL,BLKS) --> (
  r_blk(VALID_TAGS,LVL,BLK),
  (
    +(r_lb), r_tabs(LVL), r_blks(VALID_TAGS,LVL,BLKS_) -> {BLKS = [BLK]++BLKS_};
                                                          {BLKS = [BLK]}
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


%% R_SEC, INSTANCE TR_SEC XMLABLE

%%% R_SEC

r_sec(cr_sec(MAYBE_TAG_OR_ID,MAYBE_HDR,MAIN),VALID_TAGS) --> (
  {
    VALID_SEC_TAGS =
      fld_valid_tags_sec(VALID_TAGS)++fld_valid_tags_app(VALID_TAGS)
  },
  r_c('§'),
  *(r_sp),
  ?(MAYBE_TAG_OR_ID,r_tag_or_id(VALID_SEC_TAGS)),
  r_lb,
  ?(MAYBE_HDR,r_hdr(VALID_TAGS)),
  +(r_lb),
  r_pars_or_blks(MAIN)
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_sec) where [
  func(to_xml/1) is f_sec_to_xml
].

:- func (
  f_sec_to_xml(tr_sec::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_sec_to_xml(SEC) = XML :- (
  (
    (
      fld_sec_tag_or_id(maybe.no),
      TAG_OR_ID_XML_LIST = []
    );
    (
      fld_sec_tag_or_id(maybe.yes(ce_tag_or_id_tag(TAG))),
      TAG_OR_ID_XML_LIST = [f_tag_to_xml(TAG)]
    );
    (
      fld_sec_tag_or_id(maybe.yes(ce_tag_or_id_id(ID))),
      TAG_OR_ID_XML_LIST = [f_id_to_xml(ID)]
    )
  ),
  (
    (
      fld_sec_hdr(maybe.no),
      HDR_XML_LIST = []
    );
    (
      fld_sec_hdr(maybe.yes(HDR)),
      HDR_XML_LIST = [f_hdr_to_xml(HDR)]
    )
  ),
  MAIN = fld_sec_main(SEC),
  XML  = term_to_xml.elem(
    "cr_sec",
    [],
    TAG_OR_ID_XML_LIST++HDR_XML_LIST++f_blk_or_pars_to_xml(MAIN)
  )
).

%% R_PAR, INSTANCE TR_PAR XMLABLE

%%% R_PAR

r_par(cr_par(MAYBE_TAG_OR_ID,MAYBE_HDR,BLKS),VALID_TAGS) -->
  {VALID_PAR_TAGS = fld_valid_tags_par(VALID_TAGS)},
  r_c('¶'),
  *(r_sp),
  ?(MAYBE_TAG_OR_ID,r_tag_or_id(VALID_PAR_TAGS)),
  r_lb,
  ?(MAYBE_HDR,r_hdr(VALID_TAGS)),
  +(r_lb),
  r_blks(VALID_TAGS,0u,BLKS).

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
      fld_par_tag_or_id(maybe.no),
      TAG_OR_ID_XML_LIST = []
    );
    (
      fld_par_tag_or_id(maybe.yes(ce_tag_or_id_tag(TAG))),
      TAG_OR_ID_XML_LIST = [f_tag_to_xml(TAG)]
    );
    (
      fld_par_tag_or_id(maybe.yes(ce_tag_or_id_id(ID))),
      TAG_OR_ID_XML_LIST = [f_id_to_xml(ID)]
    )
  ),
  (
    (
      fld_par_hdr(maybe.no),
      HDR_XML_LIST = []
    );
    (
      fld_par_hdr(maybe.yes(HDR)),
      HDR_XML_LIST = [f_hdr_to_xml(HDR)]
    )
  ),
  BLKS = fld_par_main(PAR),
  XML  = term_to_xml.elem(
    "cr_par",
    [],
    TAG_OR_ID_XML_LIST++HDR_XML_LIST++list.map(f_blk_to_xml,BLKS)
  )
).


%% R_BLK, INSTANCE TE_BLK XMLABLE

%%% R_BLK

r_blk(VALID_TAGS,LVL,BLK) -->
  r_blk_txt(VALID_TAGS,LVL,BLK_TXT) -> {BLK = ce_blk_txt(BLK_TXT)};
  r_blk_blt(VALID_TAGS,LVL,BLK_BLT) -> {BLK = ce_blk_blt(BLK_BLT)};
  r_blk_itm(VALID_TAGS,LVL,BLK_ITM) -> {BLK = ce_blk_itm(BLK_ITM)};
  r_blk_dsp(VALID_TAGS,LVL,BLK_DSP) -> {BLK = ce_blk_dsp(BLK_DSP)};
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

r_hdr(VALID_TAGS,cs_hdr(UNITS)) --> r_blk_txt(VALID_TAGS,0u,UNITS).

:- instance term_to_xml.xmlable(ts_hdr) where [
  func(to_xml/1) is f_hdr_to_xml
].

%%% XMLABLE

:- func (
  f_hdr_to_xml(ts_hdr::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

f_hdr_to_xml(cs_hdr(UNITS)) = term_to_xml.elem(
  "cs_hdr",[],list.map(f_txt_units_to_xml,UNITS)
).


%% R_PARS_OR_BLKS AND TE_PARS_OR_BLKS_XMLABLE

%%% R_PARS_OR_BLKS

r_pars_or_blks(VALID_TAGS,PARS_OR_BLKS) --> (
  r_pars(VALID_TAGS,PARS) -> {PARS_OR_BLKS = ce_pars_or_blks_pars(PARS)};
  r_blks(VALID_TAGS,BLKS) -> {PARS_OR_BLKS = ce_pars_or_blks_blks(BLKS)};
                             {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_pars_or_blks) where [
  func(to_xml/1) is f_to_xml
].

:- func (
  f_pars_or_blks_to_xml(tr_sec::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_pars_or_blks_to_xml(PARS_OR_BLKS) = XML :- (
  (
    PARS_OR_BLKS = ce_pars_or_blks_pars(PARS),
    XML          = term_to_xml.elem(
      "ce_pars_or_blks_pars",
      [],
      list.map(f_par_to_xml,PARS)
    )
  );
  (
    PARS_OR_BLKS = ce_pars_or_blks_blks(BLKS),
    XML          =
      term_to_xml.elem("ce_pars_or_blks_blks",[],list.map(f_blk_to_xml,BLKS))
  )
).


%% R_TXT_UNIT, INSTANCE T_TXT_UNIT XMLABLE

%%% R_TXT_UNIT

r_txt_unit(UNIT,LVL,VALID_TAGS) -->
  r_c_ref(CR,VALID_TAGS)           -> {UNIT = c_txt_unit_c_ref(CR)};
  r_txt_unit_emph(S,LVL)           -> {UNIT = c_txt_unit_emph(S)};
  r_txt_unit_wysiwyg(S,VALID_TAGS) -> {UNIT = c_txt_unit_wysiwyg(S)};
                                      {false}.

%%% XMLABLE

:- instance term_to_xml.xmlable(te_txt_unit) where [
  func(to_xml/1) is f_txt_unit_to_xml
].

:- func (
  f_txt_unit_to_xml(te_txt_unit::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_unit_to_xml(c_txt_unit_c_ref(C_REF)) =
  term_to_xml.elem("c_txt_unit_c_ref",[],[f_c_ref_to_xml(C_REF)]).
f_txt_unit_to_xml(c_txt_unit_wysiwyg(STR)) =
  term_to_xml.elem("c_txt_unit_wysiwyg",[],[term_to_xml.data(STR)]).
f_txt_unit_to_xml(c_txt_unit_emph(STR)) =
  term_to_xml.elem("c_txt_unit_emph",[],[term_to_xml.data(STR)]).


%% RULE R_TXT_UNITS, SIMPLE TYPE TS_TXT_UNITS, INSTANCE TS_TXT_UNITS XMLABLE

%%% R_TXT_UNITS

r_txt_units(VALID_TAGS,LVL,US) --> +(US,r_txt_unit(VALID_TAGS,LVL)).
 %%  r_txt_unit(VALID_TAGS,LVL,U),
 %%  (
 %%    r_txt_units(VALID_TAGS,LVL,U) -> {US = [U]++US_};
 %%                                     {US = [U]}
 %%  ).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_units) where [
  func(to_xml/1) is f_to_xml
].

:- func (
  f_txt_units_to_xml(tr_sec::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_txt_units_to_xml(cs_txt_units(US)) =
  term_to_xml.elem("cs_txt_units",[],list.map(f_txt_unit_to_xml,US)).

%% R_LBL, TE_LBL XMLABLE

%%% R_LBL

r_lbl(LBL) --> (
  r(c_r_any,["(",")","[","]"],S) -> {LBL = c_lbl_custom(S)};
                                    {LBL = c_lbl_auto}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(te_lbl) where [
  func(to_xml/1) is f_lbl_to_xml
].

:- func (
  f_lbl_to_xml(te_lbl::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_lbl_to_xml(c_lbl_auto)      = term_to_xml.elem("ce_lbl_auto",[],[]).
f_lbl_to_xml(c_lbl_custom(S)) =
  term_to_xml.elem("ce_lbl_custom",[],[term_to_xml.data(S)]).



%% OLD

%%% R_TXT_UNIT_EMPH

:- pred r_txt_unit_emph(str::out, uint::in, ta_tkns::in, ta_tkns::out) is semidet.
r_txt_unit_emph(        S,        LVL) -->
  r_str("*"), r_txt_unit_emph_content(S, LVL), r_str("*").

:- pred r_txt_unit_emph_content(str, uint, ta_tkns, ta_tkns).
:- mode r_txt_unit_emph_content(out, in,   in,     out) is semidet.
r_txt_unit_emph_content(        S,   LVL) -->
  r(c_r_any,["*"],S_),
  (
    r_lb, r_tabs(LVL) -> r_txt_unit_emph_content(S__,LVL), {S = S_++" "++S__};
    {S = S_}
  ).

%%% R_TXT_UNIT_WYSIWYG

:- pred r_txt_unit_wysiwyg(str, strs, ta_tkns, ta_tkns).
:- mode r_txt_unit_wysiwyg(out, in,   in,     out) is semidet.
r_txt_unit_wysiwyg(        S,   VALID_TAGS) -->
  not r_tab,
  not r_lb,
  not r_c_ref(_,VALID_TAGS),
  r_c(c_r_any,CHR),
  (
    r_txt_unit_wysiwyg(S_,VALID_TAGS) -> {S = string.append(chr2str(CHR),S_)};
                                         {S = chr2str(CHR)}
  ).

%% OLD
 %% %%% R_BLK_TXT
 %% 
 %% r_blk_txt(US,LVL,VALID_TAGS) -->
 %%   (
 %%     if {LVL = 0u} then
 %%       not r_str("CH"),
 %%       not r_str("§"),
 %%       not r_str("¶")
 %%     else
 %%       {true}
 %%   ),
 %%   r_blk_txt_lines(US,LVL,f_all_valid_tags(VALID_TAGS)).
 %% 
 %% :- pred r_blk_txt_line(list(te_txt_unit), uint, strs, ta_tkns, ta_tkns).
 %% :- mode r_blk_txt_line(out,              in,   in,   in,     out) is semidet.
 %% r_blk_txt_line(        UNITS,            LVL,  VALID_TAGS) -->
 %%   r_txt_units(UNITS,LVL,VALID_TAGS), r_lb.
 %% 
 %% :- pred r_blk_txt_lines(list(te_txt_unit), uint, strs, ta_tkns, ta_tkns).
 %% :- mode r_blk_txt_lines(out,                in, in,   in,     out) is semidet.
 %% r_blk_txt_lines(        UNITS,            LVL,  VALID_TAGS) -->
 %%   r_blk_txt_line(UNITS_,LVL,VALID_TAGS),
 %%   (
 %%     r_tabs(LVL), r_blk_txt_lines(UNITS__,LVL,VALID_TAGS)
 %%       -> {UNITS = UNITS_ ++ UNITS__};
 %%          {UNITS = UNITS_}
 %%   ).
 %% 
 %% %%% R_BLK_BLT
 %% 
 %% r_blk_blt(BLKS,LVL,VALID_TAGS) -->
 %%   r_str("-"), r_tab, r_blks(BLKS,LVL+1u,VALID_TAGS).
 %% 
 %% %%% R_BLK_ITM AND INSTANCE TR_BLK_ITM XMLABLE
 %% 
 %% %%%% R_BLK_ITM
 %% 
 %% r_blk_itm(c_blk_itm(LBL,MAYBE_TAG_OR_ID,BLKS),LVL,VALID_TAGS) -->
 %%   {VALID_ITM_TAGS = fld_valid_tags_itm(VALID_TAGS)},
 %%   r_str("["), r_lbl(LBL), r_str("]"), r_tab,
 %%   (
 %%     if r_tag_or_id(TAG_OR_ID,VALID_ITM_TAGS), r_lb, r_tabs(LVL+1u) then
 %%       {MAYBE_TAG_OR_ID = maybe.yes(TAG_OR_ID)}
 %%     else
 %%       {MAYBE_TAG_OR_ID = maybe.no}
 %%   ),
 %%   r_blks(BLKS,LVL+1u,VALID_TAGS).
 %% 
 %% %%%% INSTANCE XMLABLE
 %% 
 %% :- instance term_to_xml.xmlable(tr_blk_itm) where [
 %%   func(to_xml/1) is f_blk_itm_to_xml
 %% ].
 %% 
 %% :- func
 %%   f_blk_itm_to_xml(tr_blk_itm::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
 %%   is det.
 %% f_blk_itm_to_xml(c_blk_itm(LBL,maybe.yes(c_tag_or_id_tag(TAG)),BLKS)) =
 %%   term_to_xml.elem(
 %%     "c_blk_itm",
 %%     [],
 %%     [f_lbl_to_xml(LBL),f_tag_to_xml(TAG)] ++ list.map(f_blk_to_xml,BLKS)
 %%   ).
 %% f_blk_itm_to_xml(c_blk_itm(LBL,maybe.yes(c_tag_or_id_id(ID)),BLKS)) =
 %%   term_to_xml.elem(
 %%     "c_blk_itm",
 %%     [],
 %%     [f_lbl_to_xml(LBL),f_id_to_xml(ID)] ++ list.map(f_blk_to_xml,BLKS)
 %%   ).
 %% f_blk_itm_to_xml(c_blk_itm(LBL,maybe.no,BLKS)) = term_to_xml.elem(
 %%   "c_blk_itm",
 %%   [],
 %%   [f_lbl_to_xml(LBL)]++list.map(f_blk_to_xml,BLKS)
 %% ).
 %% 
 %% %%% R_BLK_DSP
 %% 
 %% r_blk_dsp(BLK,LVL,VALID_TAGS) --> r_dsp_lines(BLK,LVL,VALID_TAGS).
 %% 
 %% %%% R_DSP_LINE, R_DSP_LINES AND TR_DSP_LINE XMLABLE
 %% 
 %% %%%% XMLABLE
 %% 
 %% :- instance term_to_xml.xmlable(tr_dsp_line) where [
 %%   func(to_xml/1) is f_dsp_line_to_xml
 %% ].
 %% 
 %% :- func
 %%   f_dsp_line_to_xml(tr_dsp_line::in)
 %%   =
 %%   (term_to_xml.xml::out(term_to_xml.xml_doc))
 %%   is det.
 %% f_dsp_line_to_xml(
 %%   c_dsp_line(maybe.yes(LBL),maybe.yes(c_tag_or_id_tag(TAG)),UNITS)
 %% ) =
 %%   term_to_xml.elem(
 %%     "c_dsp_line",
 %%     [],
 %%     [f_lbl_to_xml(LBL),f_tag_to_xml(TAG)]++list.map(f_dsp_unit_to_xml,UNITS)
 %%   ).
 %% f_dsp_line_to_xml(
 %%   c_dsp_line(maybe.yes(LBL),maybe.yes(c_tag_or_id_id(ID)),UNITS)) =
 %%   term_to_xml.elem(
 %%     "c_dsp_line",
 %%     [],
 %%     [f_lbl_to_xml(LBL),f_id_to_xml(ID)]++list.map(f_dsp_unit_to_xml,UNITS)
 %%   ).
 %% f_dsp_line_to_xml(c_dsp_line(maybe.yes(LBL),maybe.no,UNITS)) =
 %%   term_to_xml.elem(
 %%     "c_dsp_line",
 %%     [],
 %%     [f_lbl_to_xml(LBL)]++list.map(f_dsp_unit_to_xml,UNITS)
 %%   ).
 %% f_dsp_line_to_xml(c_dsp_line(maybe.no,maybe.yes(c_tag_or_id_tag(TAG)),UNITS)) =
 %%   term_to_xml.elem(
 %%     "c_dsp_line",
 %%     [],
 %%     [f_tag_to_xml(TAG)]++list.map(f_dsp_unit_to_xml,UNITS)
 %%   ).
 %% f_dsp_line_to_xml(c_dsp_line(maybe.no,maybe.yes(c_tag_or_id_id(ID)),UNITS)) =
 %%   term_to_xml.elem(
 %%     "c_dsp_line",
 %%     [],
 %%     [f_id_to_xml(ID)]++list.map(f_dsp_unit_to_xml,UNITS)
 %%   ).
 %% f_dsp_line_to_xml(c_dsp_line(maybe.no,maybe.no,UNITS)) =
 %%   term_to_xml.elem(
 %%     "c_dsp_line",
 %%     [],
 %%     list.map(f_dsp_unit_to_xml,UNITS)
 %%   ).
 %% 
 %% %%%% R_DSP_LINE
 %% 
 %% :- pred r_dsp_line_type_1(tr_dsp_line, tr_valid_tags, ta_tkns, ta_tkns).
 %% :- mode r_dsp_line_type_1(out,        in,           in,     out) is semidet.
 %% r_dsp_line_type_1(c_dsp_line(maybe.no,maybe.no,UNITS),VALID_TAGS) -->
 %%   {ALL_VALID_TAGS = f_all_valid_tags(VALID_TAGS)},
 %%   r_tab, r_dsp_units(UNITS,ALL_VALID_TAGS),
 %%   (
 %%     +r_tab, r_str("DSP") -> {true};
 %%                             []
 %%   ),
 %%   r_lb.
 %% 
 %% :- pred r_dsp_line_type_2(tr_dsp_line, tr_valid_tags, ta_tkns, ta_tkns).
 %% :- mode r_dsp_line_type_2(out,        in,           in,     out) is semidet.
 %% r_dsp_line_type_2(
 %%   c_dsp_line(maybe.yes(LBL),MAYBE_TAG_OR_ID,UNITS),VALID_TAGS
 %% ) -->
 %%   {ALL_VALID_TAGS = f_all_valid_tags(VALID_TAGS)},
 %%   {VALID_DSP_TAGS = fld_valid_tags_dsp(VALID_TAGS)},
 %%   r_str("("),
 %%   r_lbl(LBL),
 %%   r_str(")"),
 %%   r_tab,
 %%   r_dsp_units(UNITS,ALL_VALID_TAGS),
 %%   (
 %%     if +r_tab, r_tag_or_id(TAG_OR_ID,VALID_DSP_TAGS) then
 %%       {MAYBE_TAG_OR_ID = maybe.yes(TAG_OR_ID)}
 %%     else
 %%       {MAYBE_TAG_OR_ID = maybe.no}
 %%   ),
 %%   r_lb.
 %% 
 %% r_dsp_line(DSP_LINE,VALID_TAGS) --> (
 %%   r_dsp_line_type_1(DSP_LINE_,VALID_TAGS) -> {DSP_LINE = DSP_LINE_};
 %%   r_dsp_line_type_2(DSP_LINE_,VALID_TAGS) -> {DSP_LINE = DSP_LINE_};
 %%                                              {false}
 %% ).
 %% 
 %% %%%% R_DSP_LINES
 %% 
 %% r_dsp_lines(LINES,LVL,VALID_TAGS) -->
 %%   r_dsp_line(LINE,VALID_TAGS),
 %%   (
 %%     r_tabs(LVL), r_dsp_lines(LINES_,LVL,VALID_TAGS) -> {LINES = [LINE]++LINES_};
 %%                                                        {LINES = [LINE]}
 %%   ).
 %% 
 %% %%% HELPER R_MAYBE_HDR
 %% 
 %% :- pred r_maybe_hdr(maybe(ts_hdr), tr_valid_tags, ta_tkns, ta_tkns).
 %% :- mode r_maybe_hdr(out,          in,           in,     out) is det.
 %% r_maybe_hdr(        RES,          VALID_TAGS) --> (
 %%   r_hdr(HDR,VALID_TAGS)  -> {RES = maybe.yes(HDR)};
 %%                             {RES = maybe.no}
 %% ).
 %% 
 %% %%% R_TAG_OR_ID
 %% 
 %% r_tag_or_id(TAG_OR_ID,VALID_TAGS) --> (
 %%   r_id(ID,VALID_TAGS)   -> {TAG_OR_ID = c_tag_or_id_id(ID)};
 %%   r_tag(TAG,VALID_TAGS) -> {TAG_OR_ID = c_tag_or_id_tag(TAG)};
 %%                            {false}
 %% ).
 %% 
 %% %%% HELPER R_MAYBE_TAG_OR_ID
 %% 
 %% % doc:                                        VALID_TAGS
 %% :- pred r_maybe_tag_or_id(maybe(te_tag_or_id), strs,      ta_tkns, ta_tkns).
 %% :- mode r_maybe_tag_or_id(out,                in,        in,     out) is det.
 %% r_maybe_tag_or_id(        RES,                VALID_TAGS) --> (
 %%   r_tag_or_id(TAG_OR_ID,VALID_TAGS) -> {RES = maybe.yes(TAG_OR_ID)};
 %%                                        {RES = maybe.no}
 %% ).
 %% 
 %% %%% R_TAG AND INSTANCE TS_TAG XMLABLE
 %% 
 %% r_tag(c_tag(S),VALID_TAGS) -->
 %%   r(c_r_nws,k_forbidden_strs_in_tags_names,S),
 %%   {list.member(S,VALID_TAGS)}.
 %% 
 %% :- instance term_to_xml.xmlable(ts_tag) where [
 %%   func(to_xml/1) is f_tag_to_xml
 %% ].
 %% 
 %% :- func
 %%   f_tag_to_xml(ts_tag::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
 %%   is det.
 %% 
 %% f_tag_to_xml(c_tag(S)) = term_to_xml.elem("c_tag",[],[term_to_xml.data(S)]).
 %% 
 %% %%% R_NAME AND INSTANCE T_NAME XMLABLE
 %% 
 %% r_name(c_name(S)) --> r(c_r_nws,k_forbidden_strs_in_tags_names,S).
 %% 
 %% :- instance term_to_xml.xmlable(t_name) where [
 %%   func(to_xml/1) is f_name_to_xml
 %% ].
 %% 
 %% :- func
 %%   f_name_to_xml(t_name::in)
 %%   =
 %%   (term_to_xml.xml::out(term_to_xml.xml_doc))
 %%   is det.
 %% 
 %% f_name_to_xml(c_name(S)) = term_to_xml.elem("c_name",[],[term_to_xml.data(S)]).
 %% 
 %% %%% R_ID AND INSTANCE TR_ID XMLABLE
 %% 
 %% r_id(c_id(TAG,NAME),VALID_TAGS) -->
 %%   r_tag(TAG,VALID_TAGS), r_c(':'), r_name(NAME).
 %% 
 %% :- instance term_to_xml.xmlable(tr_id) where [
 %%   func(to_xml/1) is f_id_to_xml
 %% ].
 %% 
 %% :- func
 %%   f_id_to_xml(tr_id::in) = (term_to_xml.xml::out(term_to_xml.xml_doc)) is det.
 %% f_id_to_xml(c_id(TAG,NAME)) = term_to_xml.elem(
 %%   "c_id",
 %%   [],
 %%   [
 %%     f_tag_to_xml(TAG),
 %%     f_name_to_xml(NAME)
 %%   ]
 %% ).
 %% 
 %% 
 %% 
 %% %%% R_C_REF AND INSTANCE T_C_REF XMLABLE
 %% 
 %% r_c_ref(c_c_ref(ID),VALID_TAGS) -->
 %%   r_str("["),
 %%   r_id(ID,VALID_TAGS),
 %%   r_str("]").
 %% 
 %% :- instance term_to_xml.xmlable(t_c_ref) where [
 %%   func(to_xml/1) is f_c_ref_to_xml
 %% ].
 %% 
 %% :- func
 %%   f_c_ref_to_xml(t_c_ref::in)
 %%   =
 %%   (term_to_xml.xml::out(term_to_xml.xml_doc))
 %%   is det.
 %% f_c_ref_to_xml(c_c_ref(ID)) = term_to_xml.elem("c_c_ref",[],[f_id_to_xml(ID)]).
 %% 
 %% 
 %% %%% R_DSP_UNIT AND R_DSP_UNITS AND INSTANCE T_DSP_UNIT XMLABLE
 %% 
 %% %%%% INSTANCE T_DSP_UNIT XMLABLE
 %% 
 %% :- instance term_to_xml.xmlable(t_dsp_unit) where [
 %%   func(to_xml/1) is f_dsp_unit_to_xml
 %% ].
 %% 
 %% :- func
 %%   f_dsp_unit_to_xml(t_dsp_unit::in)
 %%   =
 %%   (term_to_xml.xml::out(term_to_xml.xml_doc))
 %%   is det.
 %% f_dsp_unit_to_xml(c_dsp_unit_c_ref(C_REF)) =
 %%   term_to_xml.elem("c_dsp_unit_c_ref",[],[f_c_ref_to_xml(C_REF)]).
 %% f_dsp_unit_to_xml(c_dsp_unit_wysiwyg(STR)) =
 %%   term_to_xml.elem("c_dsp_unit_wysiwyg",[],[term_to_xml.data(STR)]).
 %% f_dsp_unit_to_xml(c_dsp_unit_emph(STR)) =
 %%   term_to_xml.elem("c_dsp_unit_emph",[],[term_to_xml.data(STR)]).
 %% 
 %% %%%% R_DSP_UNIT
 %% 
 %% r_dsp_unit(UNIT,VALID_TAGS) -->
 %%   r_c_ref(CR,VALID_TAGS)           -> {UNIT = c_dsp_unit_c_ref(CR)};
 %%   r_dsp_unit_emph(S)               -> {UNIT = c_dsp_unit_emph(S)};
 %%   r_dsp_unit_wysiwyg(S,VALID_TAGS) -> {UNIT = c_dsp_unit_wysiwyg(S)};
 %%                                       {false}.
 %% 
 %% %%%% R_DSP_UNITS
 %% 
 %% r_dsp_units(US,VALID_TAGS) -->
 %%   r_dsp_unit(U,VALID_TAGS),
 %%   (
 %%     r_dsp_units(US_,VALID_TAGS) -> {US = [U]++US_};
 %%                                    {US = [U]}
 %%   ).
 %% 
 %% %%%% R_DSP_UNIT_EMPH
 %% 
 %% :- pred r_dsp_unit_emph(str::out, ta_tkns::in, ta_tkns::out) is semidet.
 %% r_dsp_unit_emph(        S) -->
 %%   r_str("*"), r(c_r_any,["*"],S), r_str("*").
 %% 
 %% %%%% R_DSP_UNIT_WYSIWYG
 %% 
 %% :- pred r_dsp_unit_wysiwyg(str, strs, ta_tkns, ta_tkns).
 %% :- mode r_dsp_unit_wysiwyg(out, in,   in,     out) is semidet.
 %% r_dsp_unit_wysiwyg(        S,   VALID_TAGS) -->
 %%   r_txt_unit_wysiwyg(S,VALID_TAGS).
