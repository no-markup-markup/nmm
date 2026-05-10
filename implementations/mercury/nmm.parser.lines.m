:- module nmm.parser.lines.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module term_to_xml.

:- import_module nmm.parser.units.
:- import_module nmm.parser.misc.


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


%% R_QTN_LINES, TS_QTN_LINES, F_QTN_LINES_TO_XML, TS_QTN_LINES XMLABLE

:- type ts_qtn_lines ---> cs_qtn_lines(list(tu_qtn_line)).

:- pred r_qtn_lines(ta_lvl, ts_qtn_lines, ts_tkns, ts_tkns).
:- mode r_qtn_lines(in,     out,          in,      out) is semidet.

:- func (
  f_qtn_lines_to_xml(ts_qtn_lines::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_qtn_lines).


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

:- type tu_dsp_line ---> (
  cu_dsp_line_lbld(tr_dsp_line_lbld)
  ;
  cu_dsp_line_no_lbl(ts_dsp_line_no_lbl)
).

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


%% R_QTN_LINE, TU_QTN_LINE, F_QTN_LINE_TO_XML, TU_QTN_LINE XMLABLE

:- type tu_qtn_line ---> (
  cu_qtn_line_std(ts_qtn_line_std)
  ;
  cu_qtn_line_br(ts_qtn_line_br)
%%  ;
%%  cu_qtn_line_ref(ts_qtn_line_ref)
).

:- pred r_qtn_line(ta_lvl, tu_qtn_line, ts_tkns, ts_tkns).
:- mode r_qtn_line(in,     out,         in,      out) is semidet.

:- func (
  f_qtn_line_to_xml(tu_qtn_line::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_qtn_line).


%% R_DSP_LINE_LBLD, TR_DSP_LINE_LBLD, F_DSP_LINE_LBLD_TO_XML, TR_DSP_LINE_LBLD XMLABLE

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


%% TS_QTN_LINE_STD, F_QTN_LINE_STD_TO_XML, TS_QTN_LINE_STD XMLABLE

:- type ts_qtn_line_std ---> cs_qtn_line_std(ts_qtn_units).

:- func (
  f_qtn_line_std_to_xml(ts_qtn_line_std::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_qtn_line_std).


%% TS_QTN_LINE_BR, F_QTN_LINE_BR_TO_XML, TS_QTN_LINE_BR XMLABLE

:- type ts_qtn_line_br ---> cs_qtn_line_br(ts_qtn_units).

:- func (
  f_qtn_line_br_to_xml(ts_qtn_line_br::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_qtn_line_br).


%% TODO: R_QTN_LINE_REF, TS_QTN_LINE_REF, F_QTN_LINE_REF_TO_XML, TS_QTN_LINE_REF XMLABLE

 %% :- type ts_qtn_line_ref ---> cs_qtn_line_ref(ts_txt_units).
 %% 
 %% :- pred r_qtn_line_ref(
 %%   ts_allowed_tags::in, ts_qtn_line_ref::out, ts_tkns::in, ts_tkns::out
 %% ) is semidet.
 %% 
 %% :- func (
 %%   f_qtn_line_ref_to_xml(ts_qtn_line_ref::in)
 %%   =
 %%   (term_to_xml.xml::out(term_to_xml.xml_doc))
 %% ) is det.
 %% 
 %% :- instance term_to_xml.xmlable(ts_qtn_line_ref).



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- import_module uint.

:- use_module nmm.parser.operators.

:- import_module nmm.parser.helpers.
:- import_module nmm.parser.operators.plus.
:- import_module nmm.parser.operators.q_mark.


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


%% R_QTN_LINES, F_QTN_LINES_TO_XML, TS_QTN_LINES XMLABLE

%%% R_QTN_LINES

r_qtn_lines(LVL,cs_qtn_lines(LINES)) --> (
  r_qtn_line(LVL,LINE_),
  (
    r_tabs(LVL), r_qtn_lines(LVL,cs_qtn_lines(LINES_)) -> (
      {LINES = [LINE_] ++ LINES_}
    );
    {LINES = [LINE_]}
  )
).

%%% F_QTN_LINES_TO_XML

f_qtn_lines_to_xml(cs_qtn_lines(LINES)) =
  term_to_xml.elem("cs_qtn_lines",[],list.map(f_qtn_line_to_xml,LINES)).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_qtn_lines) where [
  func(to_xml/1) is f_qtn_lines_to_xml
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


%% R_QTN_LINE, F_QTN_LINE_TO_XML, TR_QTN_LINE XMLABLE

%%% R_QTN_LINE

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

%%% F_QTN_LINE_TO_XML

f_qtn_line_to_xml(cu_qtn_line_std(LINE)) =
  term_to_xml.elem("cu_qtn_line_std",[],[f_qtn_line_std_to_xml(LINE)]).
f_qtn_line_to_xml(cu_qtn_line_br(LINE)) =
  term_to_xml.elem("cu_qtn_line_br",[],[f_qtn_line_br_to_xml(LINE)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_qtn_line) where [
  func(to_xml/1) is f_qtn_line_to_xml
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


%% F_QTN_LINE_STD_TO_XML, TS_QTN_LINE_STD XMLABLE

f_qtn_line_std_to_xml(cs_qtn_line_std(QTN_UNITS)) = term_to_xml.elem(
  "cs_qtn_line_std",[],[f_qtn_units_to_xml(QTN_UNITS)]
).

:- instance term_to_xml.xmlable(ts_qtn_line_std) where [
  func(to_xml/1) is f_qtn_line_std_to_xml
].

%% F_QTN_LINE_BR_TO_XML, TS_QTN_LINE_BR XMLABLE

f_qtn_line_br_to_xml(cs_qtn_line_br(QTN_UNITS)) = term_to_xml.elem(
  "cs_qtn_line_br",[],[f_qtn_units_to_xml(QTN_UNITS)]
).

:- instance term_to_xml.xmlable(ts_qtn_line_br) where [
  func(to_xml/1) is f_qtn_line_br_to_xml
].
