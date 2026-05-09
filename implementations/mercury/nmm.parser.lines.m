:- module nmm.parser.lines.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module nmm.


%% R_TXT_LINES, TS_TXT_LINES, F_TXT_LINES_TO_XML, TS_TXT_LINES XMLABLE

:- type ts_txt_lines ---> cs_txt_lines(list(ts_txt_line)).

:- pred r_txt_lines(ts_allowed_tags, ta_lvl, ts_txt_lines, ts_tkns, ts_tkns).
:- mode r_txt_lines(
                    in,              in,     out,          in,      out
) is semidet.

:- func (
  f_txt_lines_to_xml(ts_txt_lines::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_txt_lines).


%% R_DSP_LINES, TS_DSP_LINES, F_DSP_LINES_TO_XML, TS_DSP_LINES XMLABLE

:- type ts_dsp_lines ---> cs_dsp_lines(list(tu_dsp_line)).

:- pred r_dsp_lines(ts_allowed_tags, ta_lvl, ts_dsp_lines, ts_tkns, ts_tkns).
:- mode r_dsp_lines(
                    in,              in,     out,          in,      out
) is semidet.

:- func (
  f_dsp_lines_to_xml(ts_dsp_lines::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_dsp_lines).


%% TS_VRB_LINES, F_VRB_LINES_TO_XML, TS_VRB_LINES XMLABLE

:- type ts_vrb_lines ---> cs_vrb_lines(list(ts_vrb_line)).

:- func (
  f_vrb_lines_to_xml(ts_vrb_lines::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_vrb_lines).


%% R_TXT_LINE, TS_TXT_LINE, F_TXT_LINE_TO_XML, TS_TXT_LINE XMLABLE

:- type ts_txt_line ---> cs_txt_line(ts_txt_units).

:- pred r_txt_line(ts_allowed_tags, ta_lvl, ts_txt_line, ts_tkns, ts_tkns).
:- mode r_txt_line(
                   in,              in,     out,         in,      out
) is semidet.

:- func (
  f_txt_line_to_xml(ts_txt_line::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_txt_line).

%% R_DSP_LINE, TU_DSP_LINE, F_DSP_LINE_TO_XML, TU_DSP_LINE XMLABLE

:- type tu_dsp_line --->
  cu_dsp_line_lbld(tr_dsp_line_lbld);
  cu_dsp_line_no_lbl(ts_dsp_line_no_lbl).

:- pred r_dsp_line(ts_allowed_tags, tu_dsp_line, ts_tkns, ts_tkns).
:- mode r_dsp_line(in,              out,         in,      out) is semidet.

:- func (
  f_dsp_line_to_xml(tu_dsp_line::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_dsp_line).

%% R_VRB_LINE, TS_VRB_LINE, F_VRB_LINE_TO_XML, TS_VRB_LINE XMLABLE

:- type ts_vrb_line ---> cs_vrb_line(str).

:- pred r_vrb_line(ta_lvl, ts_vrb_line, ts_tkns, ts_tkns).
:- mode r_vrb_line(in,     out,         in,      out) is semidet.

:- func (
  f_vrb_line_to_xml(ts_vrb_line::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_vrb_line).


%% R_DSP_LINE_LBLD, TR_DSP_LINE_LBLD, F_DSP_LINE_LBLD_TO_XML, TR_DSP_LINE_LBLD XMLABLE

:- type tr_dsp_line_lbld ---> cr_dsp_line_lbld(
  fld_dsp_line_lbld_lbl   :: tu_lbl,
  fld_dsp_line_lbld_id    :: maybe(tr_id),
  fld_dsp_line_lbld_units :: ts_txt_units
).

:- pred r_dsp_line_lbld(ts_allowed_tags, tr_dsp_line_lbld, ts_tkns, ts_tkns).
:- mode r_dsp_line_lbld(
                        in,              out,              in,      out
) is semidet.

:- func (
  f_dsp_line_lbld_to_xml(tr_dsp_line_lbld::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tr_dsp_line_lbld).


%% R_DSP_LINE_NO_LBL, TS_DSP_LINE_NO_LBL, F_DSP_LINE_NO_LBL_TO_XML, TS_DSP_LINE_NO_LBL XMLABLE

:- type ts_dsp_line_no_lbl ---> cs_dsp_line_no_lbl(ts_txt_units).

:- pred r_dsp_line_no_lbl(
  ts_allowed_tags::in, ts_dsp_line_no_lbl::out, ts_tkns::in, ts_tkns::out
) is semidet.

:- func (
  f_dsp_line_no_lbl_to_xml(ts_dsp_line_no_lbl::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_dsp_line_no_lbl).



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.

%% R_TXT_LINES, F_TXT_LINES_TO_XML, TS_TXT_LINES XMLABLE

%%% R_TXT_LINES

r_txt_lines(ALLOWED_TAGS,LVL,cs_txt_lines(LINES)) --> (
  r_txt_line(ALLOWED_TAGS,LVL,LINE_),
  (
    r_tabs(LVL), r_txt_lines(ALLOWED_TAGS,LVL,cs_txt_lines(LINES_)) -> (
      {LINES = [LINE_] ++ LINES_}
    );
    {LINES = [LINE_]}
  )
).

%%% F_TXT_LINES_TO_XML

f_txt_lines_to_xml(cs_txt_lines(LINES)) =
  term_to_xml.elem("cs_txt_lines",[],list.map(f_txt_line_to_xml,LINES)).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_lines) where [
  func(to_xml/1) is f_txt_lines_to_xml
].


%% R_DSP_LINES, F_TXT_LINES_TO_XML, TS_DSP_LINES XMLABLE

%%% R_DSP_LINES

r_dsp_lines(ALLOWED_TAGS,LVL,cs_dsp_lines(LS)) --> (
  r_dsp_line(ALLOWED_TAGS,L),
  (
    r_tabs(LVL),r_dsp_lines(ALLOWED_TAGS,LVL,cs_dsp_lines(LS_)) ->
      {LS = [L]++LS_};
    {LS = [L]}
  )
).

%%% F_DSP_LINES_TO_XML

f_dsp_lines_to_xml(cs_dsp_lines(LINES)) =
  term_to_xml.elem("cs_dsp_lines",[],list.map(f_dsp_line_to_xml,LINES)).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_dsp_lines) where [
  func(to_xml/1) is f_dsp_lines_to_xml
].


%% F_VRB_LINE_TO_XML, TS_VRB_LINES XMLABLE

f_vrb_lines_to_xml(cs_vrb_lines(LINES)) =
  term_to_xml.elem("cs_vrb_lines",[],list.map(f_vrb_line_to_xml,LINES)).

:- instance term_to_xml.xmlable(ts_vrb_lines) where [
  func(to_xml/1) is f_vrb_lines_to_xml
].

%% R_TXT_LINE, F_TXT_LINE_TO_XML, TS_TXT_LINE XMLABLE

%%% R_TXT_LINE

r_txt_line(ALLOWED_TAGS,LVL,cs_txt_line(UNITS)) --> (
  r_txt_units(ALLOWED_TAGS,LVL,UNITS), r_lb
).

%%% F_TXT_LINE_TO_XML

f_txt_line_to_xml(cs_txt_line(UNITS)) =
  term_to_xml.elem("cs_txt_line",[],[f_txt_units_to_xml(UNITS)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_line) where [
  func(to_xml/1) is f_txt_line_to_xml
].


%% R_DSP_LINE, F_DSP_LINE_TO_XML, TU_DSP_LINE XMLABLE

%%% R_DSP_LINE

r_dsp_line(ALLOWED_TAGS,LINE) --> (
  r_dsp_line_no_lbl(ALLOWED_TAGS,LINE_) -> {LINE = cu_dsp_line_no_lbl(LINE_)};
  r_dsp_line_lbld(  ALLOWED_TAGS,LINE_) -> {LINE = cu_dsp_line_lbld(  LINE_)};
                                           {false}
).

%%% F_DSP_LINE_TO_XML

f_dsp_line_to_xml(cu_dsp_line_no_lbl(L)) =
  term_to_xml.elem("cu_dsp_line_no_lbl",[],[f_dsp_line_no_lbl_to_xml(L)]).
f_dsp_line_to_xml(cu_dsp_line_lbld(  L)) =
  term_to_xml.elem("cu_dsp_line_lbld",  [],[f_dsp_line_lbld_to_xml(  L)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_dsp_line) where [
  func(to_xml/1) is f_dsp_line_to_xml
].


%% R_VRB_LINE, F_VRB_LINE_TO_XML, TS_VRB_LINE XMLABLE

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

%%% F_VRB_LINE_TO_XML

f_vrb_line_to_xml(cs_vrb_line(STR)) = term_to_xml.elem(
  "cs_vrb_line",[],[term_to_xml.data(STR)]
).


%%% XMLABLE

:- instance term_to_xml.xmlable(ts_vrb_line) where [
  func(to_xml/1) is f_vrb_line_to_xml
].


%% R_DSP_LINE_LBLD, F_DSP_LINE_LBLD_TO_XML, TR_DSP_LINE_LBLD XMLABLE

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

%%% F_DSP_LINE_LBLD_TO_XML

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

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_dsp_line_lbld) where [
  func(to_xml/1) is f_dsp_line_lbld_to_xml
].

%% R_DSP_LINE_NO_LBL, F_DSP_LINE_NO_LBL_TO_XML, TS_DSP_LINE_NO_LBL XMLABLE

%%% R_DSP_LINE_NO_LBL

r_dsp_line_no_lbl(ALLOWED_TAGS,cs_dsp_line_no_lbl(cs_txt_units(US))) --> (
  r_tab,
  +([],r_dsp_unit,ALLOWED_TAGS,US,[]),
  ?([+([r_tab]),r_str("DSP")]),
  r_lb
).

%%% F_DSP_LINE_NO_LBL_TO_XML

f_dsp_line_no_lbl_to_xml(cs_dsp_line_no_lbl(TXT_UNITS)) = term_to_xml.elem(
  "cs_dsp_line_no_lbl",[],[f_txt_units_to_xml(TXT_UNITS)]
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_dsp_line_no_lbl) where [
  func(to_xml/1) is f_dsp_line_no_lbl_to_xml
].
