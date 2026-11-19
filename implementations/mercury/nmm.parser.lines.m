:- module nmm.parser.lines.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- import_module nmm.parser.units.
:- import_module nmm.parser.misc.


%% R_TXT_LINES, TS_TXT_LINES

:- type ts_txt_lines ---> cs_txt_lines(list(ts_txt_line)).

:- pred r_txt_lines(ts_allowed_tags, ta_lvl, ts_txt_lines, ts_tkns, ts_tkns).
:- mode r_txt_lines(
                    in,              in,     out,          in,      out
) is semidet.


%% R_DSP_LINES, TS_DSP_LINES

:- type ts_dsp_lines ---> cs_dsp_lines(list(tu_dsp_line)).

:- pred r_dsp_lines(ts_allowed_tags, ta_lvl, ts_dsp_lines, ts_tkns, ts_tkns).
:- mode r_dsp_lines(
                    in,              in,     out,          in,      out
) is semidet.


%% R_QTN_LINES, TS_QTN_LINES

:- type ts_qtn_lines ---> cs_qtn_lines(list(tu_qtn_line)).

:- pred r_qtn_lines(ta_lvl, ts_qtn_lines, ts_tkns, ts_tkns).
:- mode r_qtn_lines(in,     out,          in,      out) is semidet.


%% TS_VRB_LINES

:- type ts_vrb_lines ---> cs_vrb_lines(list(ts_vrb_line)).


%% R_TXT_LINE, TS_TXT_LINE

:- type ts_txt_line ---> cs_txt_line(ts_txt_units).

:- pred r_txt_line(ts_allowed_tags, ta_lvl, ts_txt_line, ts_tkns, ts_tkns).
:- mode r_txt_line(
                   in,              in,     out,         in,      out
) is semidet.


%% R_DSP_LINE, TU_DSP_LINE

:- type tu_dsp_line ---> (
  cu_dsp_line_lbld(tr_dsp_line_lbld)
  ;
  cu_dsp_line_no_lbl(ts_dsp_line_no_lbl)
).

:- pred r_dsp_line(ts_allowed_tags, tu_dsp_line, ts_tkns, ts_tkns).
:- mode r_dsp_line(in,              out,         in,      out) is semidet.


%% R_VRB_LINE, TS_VRB_LINE

:- type ts_vrb_line ---> cs_vrb_line(str).

:- pred r_vrb_line(ta_lvl, ts_vrb_line, ts_tkns, ts_tkns).
:- mode r_vrb_line(in,     out,         in,      out) is semidet.


%% R_QTN_LINE, TU_QTN_LINE

:- type tu_qtn_line ---> (
  cu_qtn_line_std(ts_qtn_line_std)
  ;
  cu_qtn_line_br(ts_qtn_line_br)
%%  ;
%%  cu_qtn_line_ref(ts_qtn_line_ref)
).

:- pred r_qtn_line(ta_lvl, tu_qtn_line, ts_tkns, ts_tkns).
:- mode r_qtn_line(in,     out,         in,      out) is semidet.


%% R_DSP_LINE_LBLD, TR_DSP_LINE_LBLD

:- type tr_dsp_line_lbld ---> cr_dsp_line_lbld(
  fld_dsp_line_lbld_lbl   :: tu_lbl
  ,
  fld_dsp_line_lbld_id    :: maybe(tr_id)
  ,
  fld_dsp_line_lbld_units :: ts_txt_units
).

:- pred r_dsp_line_lbld(ts_allowed_tags, tr_dsp_line_lbld, ts_tkns, ts_tkns).
:- mode r_dsp_line_lbld(
                        in,              out,              in,      out
) is semidet.


%% R_DSP_LINE_NO_LBL, TS_DSP_LINE_NO_LBL

:- type ts_dsp_line_no_lbl ---> cs_dsp_line_no_lbl(ts_txt_units).

:- pred r_dsp_line_no_lbl(
  ts_allowed_tags::in, ts_dsp_line_no_lbl::out, ts_tkns::in, ts_tkns::out
) is semidet.


%% TS_QTN_LINE_STD

:- type ts_qtn_line_std ---> cs_qtn_line_std(ts_qtn_units).


%% TS_QTN_LINE_BR

:- type ts_qtn_line_br ---> cs_qtn_line_br(ts_qtn_units).


%% TODO: R_QTN_LINE_REF, TS_QTN_LINE_REF

 %% :- type ts_qtn_line_ref ---> cs_qtn_line_ref(ts_txt_units).
 %% 
 %% :- pred r_qtn_line_ref(
 %%   ts_allowed_tags::in, ts_qtn_line_ref::out, ts_tkns::in, ts_tkns::out
 %% ) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- import_module uint.

:- use_module nmm.parser.operators.

:- import_module nmm.parser.helpers.
:- import_module nmm.parser.operators.plus.
:- import_module nmm.parser.operators.q_mark.


%% R_TXT_LINES

r_txt_lines(ALLOWED_TAGS,LVL,cs_txt_lines(LINES)) --> (
  r_txt_line(ALLOWED_TAGS,LVL,LINE_),
  (
    r_tabs(LVL), r_txt_lines(ALLOWED_TAGS,LVL,cs_txt_lines(LINES_)) -> (
      {LINES = [LINE_] ++ LINES_}
    );
    {LINES = [LINE_]}
  )
).


%% R_DSP_LINES

r_dsp_lines(ALLOWED_TAGS,LVL,cs_dsp_lines(LS)) --> (
  r_dsp_line(ALLOWED_TAGS,L),
  (
    r_tabs(LVL),r_dsp_lines(ALLOWED_TAGS,LVL,cs_dsp_lines(LS_)) ->
      {LS = [L]++LS_};
    {LS = [L]}
  )
).


%% R_QTN_LINES

r_qtn_lines(LVL,cs_qtn_lines(LINES)) --> (
  r_qtn_line(LVL,LINE_),
  (
    r_tabs(LVL), r_qtn_lines(LVL,cs_qtn_lines(LINES_)) -> (
      {LINES = [LINE_] ++ LINES_}
    );
    {LINES = [LINE_]}
  )
).


%% R_TXT_LINE

r_txt_line(ALLOWED_TAGS,LVL,cs_txt_line(UNITS)) --> (
  r_txt_units(ALLOWED_TAGS,LVL,UNITS), r_lb
).


%% R_DSP_LINE

r_dsp_line(ALLOWED_TAGS,LINE) --> (
  r_dsp_line_no_lbl(ALLOWED_TAGS,LINE_) -> {LINE = cu_dsp_line_no_lbl(LINE_)};
  r_dsp_line_lbld(  ALLOWED_TAGS,LINE_) -> {LINE = cu_dsp_line_lbld(  LINE_)};
                                           {false}
).


%% R_VRB_LINE

%%% R_VRB_LINE

r_vrb_line(LVL,LINE) --> (
  r_tabs(LVL), +([],r_vrb_line_tkn,TKNS,[]), r_lb -> (
    {LINE = cs_vrb_line(nmm.lexer.f_detknize(TKNS))}
  );
  r_lb                                            -> (
    {LINE = cs_vrb_line("")}
  );
  {false}
).

%%% HELPER R_VRB_LINE_TKN

:- pred r_vrb_line_tkn(tu_tkn::out,ts_tkns::in,ts_tkns::out) is semidet.
r_vrb_line_tkn(TKN) --> (
  [TKN],
  {
    TKN \= nmm.lexer.cu_tkn_tab(_),
    TKN \= nmm.lexer.cu_tkn_lb(_),
    TKN \= nmm.lexer.cu_tkn_eof
  }
).


%% R_QTN_LINE

r_qtn_line(LVL,LINE) --> (
  r_str("BR"), r_tab,                            r_lb -> (
    {LINE = cu_qtn_line_br(cs_qtn_line_br(cs_qtn_units([])))}
  );
  r_str("BR"), r_tab, r_qtn_units(LVL+1u,UNITS), r_lb -> (
    {LINE = cu_qtn_line_br(cs_qtn_line_br(UNITS))}
  );
  r_tab,              r_qtn_units(LVL+1u,UNITS), r_lb -> (
    {LINE = cu_qtn_line_std(cs_qtn_line_std(UNITS))}
  );
  {false}
).


%% R_DSP_LINE_LBLD

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


%% R_DSP_LINE_NO_LBL

r_dsp_line_no_lbl(ALLOWED_TAGS,cs_dsp_line_no_lbl(cs_txt_units(US))) --> (
  r_tab,
  +([],r_dsp_unit,ALLOWED_TAGS,US,[]),
  ?([+([r_tab]),r_str("DSP")]),
  r_lb
).
