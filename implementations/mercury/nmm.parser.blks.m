:- module nmm.parser.blks.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module nmm.


%% R_BLKS, TS_BLKS, F_BLKS_TO_XML, TS_BLKS_XMLABLE

:- type ts_blks ---> cs_blks(list(tu_blk)).

:- pred r_blks(ts_allowed_tags, ta_lvl, ts_blks, ts_tkns, ts_tkns).
:- mode r_blks(in,              in,     out,     in,      out) is semidet.

:- func (
  f_blks_to_xml(ts_blks::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_blks).


%% R_BLK, TU_BLK, F_BLK_TO_XML, TU_BLK XMLABLE

:- type tu_blk ---> (
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
).

:- pred r_blk(ts_allowed_tags, ta_lvl, tu_blk, ts_tkns, ts_tkns).
:- mode r_blk(in,              in,     out,    in,      out) is semidet.

:- func (
  f_blk_to_xml(tu_blk::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_blk).


%% R_BLK_TXT, TS_BLK_TXT, F_BLK_TXT_TO_XML, TS_BLK_TXT XMLABLE

:- type ts_blk_txt ---> cs_blk_txt(ts_txt_lines).

:- pred r_blk_txt(ts_allowed_tags, ta_lvl, ts_blk_txt, ts_tkns, ts_tkns).
:- mode r_blk_txt(in,              in,     out,        in,      out) is semidet.

:- func (
  f_blk_txt_to_xml(ts_blk_txt::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_blk_txt).


%% R_BLK_BLT, TS_BLK_BLT, F_BLK_BLT_TO_XML, TS_BLK_BLT XMLABLE

:- type ts_blk_blt ---> cs_blk_blt(ts_blks).

:- pred r_blk_blt(ts_allowed_tags, ta_lvl, ts_blk_blt, ts_tkns, ts_tkns).
:- mode r_blk_blt(in,              in,     out,        in,      out) is semidet.

:- func (
  f_blk_blt_to_xml(ts_blk_blt::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_blk_blt).


%% R_BLK_ITM, TR_BLK_ITM, F_BLK_ITM_TO_XML, TR_BLK_ITM XMLABLE

:- type tr_blk_itm ---> cr_blk_itm(
  fld_blk_itm_lbl       :: tu_lbl
  ,
  fld_blk_itm_tag_or_id :: maybe(tu_tag_or_id)
  ,
  fld_blk_itm_main      :: ts_blks
).

:- pred r_blk_itm(ts_allowed_tags, ta_lvl, tr_blk_itm, ts_tkns, ts_tkns).
:- mode r_blk_itm(in,              in,     out,        in,      out) is semidet.

:- func (
  f_blk_itm_to_xml(tr_blk_itm::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tr_blk_itm).


%% R_BLK_DSP, TS_BLK_DSP, F_BLK_DSP_TO_XML, TS_BLK_DSP XMLABLE

:- type ts_blk_dsp ---> cs_blk_dsp(ts_dsp_lines).

:- pred r_blk_dsp(ts_allowed_tags, ta_lvl, ts_blk_dsp, ts_tkns, ts_tkns).
:- mode r_blk_dsp(
                  in,              in,     out,        in,      out
) is semidet.

:- func (
  f_blk_dsp_to_xml(ts_blk_dsp::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_blk_dsp).


%% R_BLK_VRB, TS_BLK_VRB, F_BLK_VRB_TO_XML, TS_BLK_VRB XMLABLE

:- type ts_blk_vrb ---> cs_blk_vrb(ts_vrb_lines).

:- pred r_blk_vrb(ta_lvl, ts_blk_vrb, ts_tkns, ts_tkns).
:- mode r_blk_vrb(in,     out,        in,      out) is semidet.

:- func (
  f_blk_vrb_to_xml(ts_blk_vrb::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_blk_vrb).


%% R_BLK_NTE, F_BLK_NTE_TO_XML, TR_BLK_NTE, TR_BLK_NTE XMLABLE

:- type tr_blk_nte ---> cr_blk_nte(
  fld_blk_nte_id   :: tr_id
  ,
  fld_blk_nte_main :: ts_blks
).

:- pred r_blk_nte(ts_allowed_tags, ta_lvl, tr_blk_nte, ts_tkns, ts_tkns).
:- mode r_blk_nte(in,              in,     out,        in,      out) is semidet.

:- func (
  f_blk_nte_to_xml(tr_blk_nte::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tr_blk_nte).



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% R_BLKS, F_BLKS_TO_XML, TS_BLKS_XMLABLE

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

%%% F_BLKS_TO_XML

f_blks_to_xml(cs_blks(BLKS)) = (
  term_to_xml.elem("cs_blks",[],list.map(f_blk_to_xml,BLKS))
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_blks) where [
  func(to_xml/1) is f_blks_to_xml
].

%% R_BLK, F_BLK_TO_XML, TU_BLK XMLABLE

%%% R_BLK

r_blk(ALLOWED_TAGS,LVL,BLK) --> (
  r_blk_txt(ALLOWED_TAGS,LVL,BLK_TXT) -> {BLK = cu_blk_txt(BLK_TXT)};
  r_blk_blt(ALLOWED_TAGS,LVL,BLK_BLT) -> {BLK = cu_blk_blt(BLK_BLT)};
  r_blk_itm(ALLOWED_TAGS,LVL,BLK_ITM) -> {BLK = cu_blk_itm(BLK_ITM)};
  r_blk_dsp(ALLOWED_TAGS,LVL,BLK_DSP) -> {BLK = cu_blk_dsp(BLK_DSP)};
  r_blk_vrb(             LVL,BLK_VRB) -> {BLK = cu_blk_vrb(BLK_VRB)};
  r_blk_nte(ALLOWED_TAGS,LVL,BLK_NTE) -> {BLK = cu_blk_nte(BLK_NTE)};
                                         {false}
).

%%% F_BLK_TO_XML

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

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_blk) where [
  func(to_xml/1) is f_blk_to_xml
].


%% R_BLK_TXT, F_BLK_TXT_TO_XML, TS_BLK_TXT XMLABLE

%%% R_BLK_TXT

:- pragma memo(r_blk_txt/5,[fast_loose]).
r_blk_txt(ALLOWED_TAGS,LVL,cs_blk_txt(LINES)) --> (
  (
    if {LVL = 0u} then
      not r_ch( ALLOWED_TAGS,_),
      not r_sec(ALLOWED_TAGS,_),
      not r_par(ALLOWED_TAGS,_),
      not r_refs_start_marker
    else
      {true}
  ),
  r_txt_lines(ALLOWED_TAGS,LVL,LINES)
).

%%% F_BLK_TXT_TO_XML

f_blk_txt_to_xml(cs_blk_txt(LINES)) =
  term_to_xml.elem("cs_blk_txt",[],[f_txt_lines_to_xml(LINES)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_blk_txt) where [
  func(to_xml/1) is f_blk_txt_to_xml
].


%% R_BLK_BLT, F_BLK_BLT_TO_XML, TS_BLK_BLT XMLABLE

:- pragma memo(r_blk_blt/5,[fast_loose]).
r_blk_blt(ALLOWED_TAGS,LVL,cs_blk_blt(BLKS)) -->
  r_str("-"), r_tab, r_blks(ALLOWED_TAGS,LVL+1u,BLKS).

f_blk_blt_to_xml(cs_blk_blt(BLKS)) =
  term_to_xml.elem("cs_blk_blt",[],[f_blks_to_xml(BLKS)]).

:- instance term_to_xml.xmlable(ts_blk_blt) where [
  func(to_xml/1) is f_blk_blt_to_xml
].


%% R_BLK_ITM, TR_BLK_ITM, TR_BLK_ITM XMLABLE

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

%%% F_BLK_ITM_TO_XML

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

%%% INSTANCE XMLABLE

:- instance term_to_xml.xmlable(tr_blk_itm) where [
  func(to_xml/1) is f_blk_itm_to_xml
].


%% R_BLK_DSP, F_BLK_DSP_TO_XML, TS_BLK_DSP XMLABLE

:- pragma memo(r_blk_dsp/5,[fast_loose]).
r_blk_dsp(ALLOWED_TAGS,LVL,cs_blk_dsp(DSP_LINES)) -->
  r_dsp_lines(ALLOWED_TAGS,LVL,DSP_LINES).

f_blk_dsp_to_xml(cs_blk_dsp(DSP_LINES)) =
  term_to_xml.elem("cs_blk_dsp",[],[f_dsp_lines_to_xml(DSP_LINES)]).

:- instance term_to_xml.xmlable(ts_blk_dsp) where [
  func(to_xml/1) is f_blk_dsp_to_xml
].


%% R_BLK_VRB, F_BLK_VRB_TO_XML, TS_BLK_VRB XMLABLE

%%% R_BLK_VRB

:- pragma memo(r_blk_vrb/4,[fast_loose]).
r_blk_vrb(LVL,cs_blk_vrb(cs_vrb_lines(LINES))) --> (
  r_str("START"), r_tab, r_str("VERBATIM"), r_lb,
  +([],r_vrb_line,LVL,LINES,[]),
  r_tabs(LVL),
  r_str("END"),   r_tab, r_str("VERBATIM"), r_lb
).

%%% F_BLK_VRB_TO_XML

f_blk_vrb_to_xml(cs_blk_vrb(LINES)) =
  term_to_xml.elem("cs_blk_vrb",[],[f_vrb_lines_to_xml(LINES)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_blk_vrb) where [
  func(to_xml/1) is f_blk_vrb_to_xml
].


%% R_BLK_NTE, F_BLK_NTE_TO_XML, TR_BLK_NTE XMLABLE

:- pragma memo(r_blk_nte/5,[fast_loose]).
r_blk_nte(ALLOWED_TAGS,LVL,cr_blk_nte(ID,BLKS)) -->
  r_str("*"), r_tab, r_id(cs_allowed_tags([]),cu_tag_type_nte,ID),
  +([r_lb]),
  r_tabs(LVL+1u), r_blks(ALLOWED_TAGS,LVL+1u,BLKS).

f_blk_nte_to_xml(cr_blk_nte(ID,BLKS)) =
  term_to_xml.elem("cr_blk_nte",[],[f_id_to_xml(ID),f_blks_to_xml(BLKS)]).

:- instance term_to_xml.xmlable(tr_blk_nte) where [
  func(to_xml/1) is f_blk_nte_to_xml
].
