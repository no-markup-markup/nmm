:- module nmm.parser.blks.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- import_module nmm.parser.main.
:- import_module nmm.parser.lines.
:- import_module nmm.parser.misc.


%% R_BLKS, TS_BLKS

:- type ts_blks ---> cs_blks(list(tu_blk)).

:- pred r_blks(ts_allowed_tags, ta_lvl, ts_blks, ts_tkns, ts_tkns).
:- mode r_blks(in,              in,     out,     in,      out) is semidet.


%% R_BLK, TU_BLK

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
  ;
  cu_blk_qtn(ts_blk_qtn)
).

:- pred r_blk(ts_allowed_tags, ta_lvl, tu_blk, ts_tkns, ts_tkns).
:- mode r_blk(in,              in,     out,    in,      out) is semidet.


%% R_BLK_TXT, TS_BLK_TXT

:- type ts_blk_txt ---> cs_blk_txt(ts_txt_lines).

:- pred r_blk_txt(ts_allowed_tags, ta_lvl, ts_blk_txt, ts_tkns, ts_tkns).
:- mode r_blk_txt(in,              in,     out,        in,      out) is semidet.


%% R_BLK_BLT, TS_BLK_BLT

:- type ts_blk_blt ---> cs_blk_blt(ts_blks).

:- pred r_blk_blt(ts_allowed_tags, ta_lvl, ts_blk_blt, ts_tkns, ts_tkns).
:- mode r_blk_blt(in,              in,     out,        in,      out) is semidet.


%% R_BLK_ITM, TR_BLK_ITM

:- type tr_blk_itm ---> cr_blk_itm(
  fld_blk_itm_lbl       :: tu_lbl
  ,
  fld_blk_itm_tag_or_id :: maybe(tu_tag_or_id)
  ,
  fld_blk_itm_main      :: ts_blks
).

:- pred r_blk_itm(ts_allowed_tags, ta_lvl, tr_blk_itm, ts_tkns, ts_tkns).
:- mode r_blk_itm(in,              in,     out,        in,      out) is semidet.


%% R_BLK_DSP, TS_BLK_DSP

:- type ts_blk_dsp ---> cs_blk_dsp(ts_dsp_lines).

:- pred r_blk_dsp(ts_allowed_tags, ta_lvl, ts_blk_dsp, ts_tkns, ts_tkns).
:- mode r_blk_dsp(
                  in,              in,     out,        in,      out
) is semidet.


%% R_BLK_VRB, TS_BLK_VRB

:- type ts_blk_vrb ---> cs_blk_vrb(ts_vrb_lines).

:- pred r_blk_vrb(ta_lvl, ts_blk_vrb, ts_tkns, ts_tkns).
:- mode r_blk_vrb(in,     out,        in,      out) is semidet.


%% R_BLK_QTN, TS_BLK_QTN

:- type ts_blk_qtn ---> cs_blk_qtn(ts_qtn_lines).

:- pred r_blk_qtn(ta_lvl, ts_blk_qtn, ts_tkns, ts_tkns).
:- mode r_blk_qtn(in,     out,        in,      out) is semidet.


%% R_BLK_NTE, TR_BLK_NTE

:- type tr_blk_nte ---> cr_blk_nte(
  fld_blk_nte_id   :: tr_id
  ,
  fld_blk_nte_main :: ts_blks
).

:- pred r_blk_nte(ts_allowed_tags, ta_lvl, tr_blk_nte, ts_tkns, ts_tkns).
:- mode r_blk_nte(in,              in,     out,        in,      out) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.

%% MODULE IMPORTS

:- import_module uint.

:- use_module nmm.parser.operators.

:- import_module nmm.parser.helpers.
:- import_module nmm.parser.operators.plus.
:- import_module nmm.parser.operators.q_mark.


%% R_BLKS

r_blks(ALLOWED_TAGS,LVL,BLKS) --> (
  r_blk(ALLOWED_TAGS,LVL,BLK),
  (
    +([r_lb]),r_tabs(LVL),r_blks(ALLOWED_TAGS,LVL,cs_blks(BLKS_)) -> (
      {BLKS = cs_blks([BLK]++BLKS_)}
    );
    {BLKS = cs_blks([BLK])}
  )
).


%% R_BLK

r_blk(ALLOWED_TAGS,LVL,BLK) --> (
  r_blk_txt(ALLOWED_TAGS,LVL,BLK_TXT) -> {BLK = cu_blk_txt(BLK_TXT)};
  r_blk_blt(ALLOWED_TAGS,LVL,BLK_BLT) -> {BLK = cu_blk_blt(BLK_BLT)};
  r_blk_itm(ALLOWED_TAGS,LVL,BLK_ITM) -> {BLK = cu_blk_itm(BLK_ITM)};
  r_blk_dsp(ALLOWED_TAGS,LVL,BLK_DSP) -> {BLK = cu_blk_dsp(BLK_DSP)};
  r_blk_vrb(             LVL,BLK_VRB) -> {BLK = cu_blk_vrb(BLK_VRB)};
  r_blk_nte(ALLOWED_TAGS,LVL,BLK_NTE) -> {BLK = cu_blk_nte(BLK_NTE)};
  r_blk_qtn(             LVL,BLK_QTN) -> {BLK = cu_blk_qtn(BLK_QTN)};
                                         {false}
).


%% R_BLK_TXT

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


%% R_BLK_BLT

:- pragma memo(r_blk_blt/5,[fast_loose]).
r_blk_blt(ALLOWED_TAGS,LVL,cs_blk_blt(BLKS)) -->
  r_str("-"), r_tab, r_blks(ALLOWED_TAGS,LVL+1u,BLKS).


%% R_BLK_ITM, TR_BLK_ITM

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


%% R_BLK_DSP

:- pragma memo(r_blk_dsp/5,[fast_loose]).
r_blk_dsp(ALLOWED_TAGS,LVL,cs_blk_dsp(DSP_LINES)) -->
  r_dsp_lines(ALLOWED_TAGS,LVL,DSP_LINES).


%% R_BLK_VRB

:- pragma memo(r_blk_vrb/4,[fast_loose]).
r_blk_vrb(LVL,cs_blk_vrb(cs_vrb_lines(LINES))) --> (
  r_str("START"), r_tab, r_str("VERBATIM"), r_lb,
  +([],r_vrb_line,LVL,LINES,[]),
  r_tabs(LVL),
  r_str("END"),   r_tab, r_str("VERBATIM"), r_lb
).


%% R_BLK_QTN

:- pragma memo(r_blk_qtn/4,[fast_loose]).
r_blk_qtn(LVL,cs_blk_qtn(LINES)) --> (
  r_str("START"), r_tab, r_str("QUOTATION"), r_lb,
  r_tabs(LVL),
  r_qtn_lines(LVL,LINES),
  r_tabs(LVL),
  r_str("END"),   r_tab, r_str("QUOTATION"), r_lb
).


%% R_BLK_NTE

:- pragma memo(r_blk_nte/5,[fast_loose]).
r_blk_nte(ALLOWED_TAGS,LVL,cr_blk_nte(ID,BLKS)) -->
  r_str("*"), r_tab, r_id(cs_allowed_tags([]),cu_tag_type_nte,ID),
  +([r_lb]),
  r_tabs(LVL+1u), r_blks(ALLOWED_TAGS,LVL+1u,BLKS).
