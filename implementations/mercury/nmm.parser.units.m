:- module nmm.parser.units.

 % when new units are added:
 % make sure r_txt_unit_wysiwyg_chr and r_dsp_unit_wysiwyg_chr are updated
 % accordingly

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module nmm.


%% R_TXT_UNITS, TS_TXT_UNITS, F_TXT_UNITS_TO_XML, TS_TXT_UNITS XMLABLE

:- type ts_txt_units ---> cs_txt_units(list(tu_txt_unit)).

:- pred r_txt_units(ts_allowed_tags, ta_lvl, ts_txt_units, ts_tkns, ts_tkns).
:- mode r_txt_units(
                    in,              in,     out,          in,      out
) is semidet.

:- func (
  f_txt_units_to_xml(ts_txt_units::in) =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_txt_units).


%% R_TXT_UNIT, TU_TXT_UNIT, F_TXT_UNIT_TO_XML, TU_TXT_UNIT XMLABLE

:- type tu_txt_unit ---> (
  cu_txt_unit_c_ref(ts_txt_unit_c_ref)
  ;
  cu_txt_unit_nte_ref(ts_txt_unit_nte_ref)
  ;
  cu_txt_unit_emph(ts_txt_unit_emph)
  ;
  cu_txt_unit_wysiwyg(ts_txt_unit_wysiwyg)
).

:- pred r_txt_unit(ts_allowed_tags, ta_lvl, tu_txt_unit, ts_tkns, ts_tkns).
:- mode r_txt_unit(
                   in,              in,     out,         in,      out
) is semidet.

:- func (
  f_txt_unit_to_xml(tu_txt_unit::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_txt_unit).


%% R_DSP_UNIT

:- pred r_dsp_unit(ts_allowed_tags, tu_txt_unit, ts_tkns, ts_tkns).
:- mode r_dsp_unit(in,              out,         in,      out) is semidet.


%% R_TXT_UNIT_WYSIWYG, TS_TXT_UNIT_WYSIWYG, F_TXT_UNIT_WYSIWYG_TO_XML, TS_TXT_UNIT_WYSIWYG XMLABLE

:- type ts_txt_unit_wysiwyg ---> cs_txt_unit_wysiwyg(str).

:- pred r_txt_unit_wysiwyg(
  ts_allowed_tags, ta_lvl, ts_txt_unit_wysiwyg, ts_tkns, ts_tkns
).
:- mode r_txt_unit_wysiwyg(
  in,              in,     out,                 in,      out
) is semidet.

:- func (
  f_txt_unit_wysiwyg_to_xml(ts_txt_unit_wysiwyg::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_txt_unit_wysiwyg).


%% R_TXT_UNIT_EMPH, TS_TXT_UNIT_EMPH, F_TXT_UNIT_EMPH_TO_XML, TS_TXT_UNIT_EMPH XMLABLE

:- type ts_txt_unit_emph ---> cs_txt_unit_emph(str).

:- pred r_txt_unit_emph(ta_lvl, ts_txt_unit_emph, ts_tkns, ts_tkns).
:- mode r_txt_unit_emph(in,     out,              in,      out) is semidet.

:- func (
  f_txt_unit_emph_to_xml(ts_txt_unit_emph::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_txt_unit_emph).


%% R_TXT_UNIT_C_REF, TS_TXT_UNIT_C_REF, F_TXT_UNIT_C_REF_TO_XML, TS_TXT_UNIT_C_REF XMLABLE

:- type ts_txt_unit_c_ref ---> cs_txt_unit_c_ref(ts_c_ref).

:- pred r_txt_unit_c_ref(ts_allowed_tags, ts_txt_unit_c_ref, ts_tkns, ts_tkns).
:- mode r_txt_unit_c_ref(
                         in,              out,               in,      out
) is semidet.

:- func (
  f_txt_unit_c_ref_to_xml(ts_txt_unit_c_ref::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_txt_unit_c_ref).


%% R_TXT_UNIT_NTE_REF, TS_TXT_UNIT_NTE_REF, F_TXT_UNIT_NTE_REF_TO_XML, TS_TXT_UNIT_NTE_REF XMLABLE

:- type ts_txt_unit_nte_ref ---> cs_txt_unit_nte_ref(ts_nte_ref).

:- pred r_txt_unit_nte_ref(ts_txt_unit_nte_ref, ts_tkns, ts_tkns).
:- mode r_txt_unit_nte_ref(out,                 in,      out) is semidet.

:- func (
  f_txt_unit_nte_ref_to_xml(ts_txt_unit_nte_ref::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_txt_unit_nte_ref).



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.

%% R_TXT_UNITS, TS_TXT_UNITS, F_TXT_UNITS_TO_XML, TS_TXT_UNITS XMLABLE

%%% R_TXT_UNITS

r_txt_units(ALLOWED_TAGS,LVL,cs_txt_units(US)) --> (
  +([],r_txt_unit,ALLOWED_TAGS,LVL,US,[])
).

%%% F_TXT_UNITS_TO_XML

f_txt_units_to_xml(cs_txt_units(US)) =
  term_to_xml.elem("cs_txt_units",[],list.map(f_txt_unit_to_xml,US)).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_units) where [
  func(to_xml/1) is f_txt_units_to_xml
].


%% R_TXT_UNIT, F_TXT_UNIT_TO_XML, TU_TXT_UNIT XMLABLE

%%% R_TXT_UNIT

r_txt_unit(ALLOWED_TAGS,LVL,U) --> (
  r_txt_unit_emph(                LVL,U_) -> {U = cu_txt_unit_emph(   U_)};
  r_txt_unit_c_ref(  ALLOWED_TAGS,    U_) -> {U = cu_txt_unit_c_ref(  U_)};
  r_txt_unit_nte_ref(                 U_) -> {U = cu_txt_unit_nte_ref(U_)};
  r_txt_unit_wysiwyg(ALLOWED_TAGS,LVL,U_) -> {U = cu_txt_unit_wysiwyg(U_)};
                                             {false}
).

%%% F_TXT_UNIT_TO_XML

f_txt_unit_to_xml(cu_txt_unit_c_ref(REF))   =
  term_to_xml.elem("cu_txt_unit_c_ref",  [],[f_txt_unit_c_ref_to_xml(REF)]).
f_txt_unit_to_xml(cu_txt_unit_nte_ref(REF)) =
  term_to_xml.elem("cu_txt_unit_nte_ref",[],[f_txt_unit_nte_ref_to_xml(REF)]).
f_txt_unit_to_xml(cu_txt_unit_wysiwyg(U))   =
  term_to_xml.elem("cu_txt_unit_wysiwyg",[],[f_txt_unit_wysiwyg_to_xml(U)]).
f_txt_unit_to_xml(cu_txt_unit_emph(U))      =
  term_to_xml.elem("cu_txt_unit_emph",   [],[f_txt_unit_emph_to_xml(U)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_txt_unit) where [
  func(to_xml/1) is f_txt_unit_to_xml
].


%% R_DSP_UNIT

%%% R_DSP_UNIT

r_dsp_unit(ALLOWED_TAGS,U) --> (
  r_dsp_unit_emph(                U_) -> {U = cu_txt_unit_emph(   U_)};
  r_txt_unit_c_ref(  ALLOWED_TAGS,U_) -> {U = cu_txt_unit_c_ref(  U_)};
  r_txt_unit_nte_ref(             U_) -> {U = cu_txt_unit_nte_ref(U_)};
  r_dsp_unit_wysiwyg(ALLOWED_TAGS,U_) -> {U = cu_txt_unit_wysiwyg(U_)};
                                         {false}
).

%%% HELPER R_DSP_UNIT_EMPH

:- pred r_dsp_unit_emph(ts_txt_unit_emph, ts_tkns, ts_tkns).
:- mode r_dsp_unit_emph(out,              in,      out) is semidet.
r_dsp_unit_emph(        cs_txt_unit_emph(STR)) --> (
  r_str("*"), r(cu_r_any,["*"],STR), r_str("*")
).

%%% HELPER R_DSP_UNIT_WYSIWYG

:- pred r_dsp_unit_wysiwyg(
  ts_allowed_tags::in, ts_txt_unit_wysiwyg::out, ts_tkns::in, ts_tkns::out
) is semidet.
r_dsp_unit_wysiwyg(
  ALLOWED_TAGS,        cs_txt_unit_wysiwyg(STR)
) --> (
  +([],r_dsp_unit_wysiwyg_chr,ALLOWED_TAGS,CHRS,[]),
  {STR = chrs2str(CHRS)}
).

%%% HELPER R_DSP_UNIT_WYSIWYG_CHR

:- pred r_dsp_unit_wysiwyg_chr(ts_allowed_tags, chr, ts_tkns, ts_tkns).
:- mode r_dsp_unit_wysiwyg_chr(in,              out, in,      out) is semidet.
r_dsp_unit_wysiwyg_chr(        ALLOWED_TAGS,    C) --> (
  not r_tab,
  not r_lb,
  not r_c_ref(ALLOWED_TAGS,_),
  not r_nte_ref(_),
  not r_dsp_unit_emph(_),
  r_c(cu_r_any,C)
).


%% R_TXT_UNIT_WYSIWYG, F_TXT_UNIT_WYSIWYG_TO_XML, TS_TXT_UNIT_WYSIWYG XMLABLE

%%% R_TXT_UNIT_WYSIWYG

r_txt_unit_wysiwyg(ALLOWED_TAGS,LVL,cs_txt_unit_wysiwyg(STR)) -->
  +([],r_txt_unit_wysiwyg_chr,ALLOWED_TAGS,LVL,CHRS,[]),{STR = chrs2str(CHRS)}.

%%% HELPER R_TXT_UNIT_WYSIWYG_CHR

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

%%% F_TXT_UNIT_WYSIWYG_TO_XML

f_txt_unit_wysiwyg_to_xml(cs_txt_unit_wysiwyg(STR)) =
  term_to_xml.elem("cs_txt_unit_wysiwyg",[],[term_to_xml.data(STR)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_unit_wysiwyg) where [
  func(to_xml/1) is f_txt_unit_wysiwyg_to_xml
].


%% R_TXT_UNIT_EMPH, F_TXT_UNIT_EMPH_TO_XML, TS_TXT_UNIT_EMPH XMLABLE

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

%%% F_TXT_UNIT_EMPH_TO_XML

f_txt_unit_emph_to_xml(cs_txt_unit_emph(STR)) =
  term_to_xml.elem("cs_txt_unit_emph",[],[term_to_xml.data(STR)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_unit_emph) where [
  func(to_xml/1) is f_txt_unit_emph_to_xml
].


%% R_TXT_UNIT_C_REF, F_TXT_UNIT_C_REF_TO_XML, TS_TXT_UNIT_C_REF XMLABLE

%%% R_TXT_UNIT_C_REF

r_txt_unit_c_ref(ALLOWED_TAGS,cs_txt_unit_c_ref(C_REF)) -->
  r_c_ref(ALLOWED_TAGS,C_REF).

%%% F_TXT_UNIT_C_REF_TO_XML

f_txt_unit_c_ref_to_xml(cs_txt_unit_c_ref(C_REF)) =
  term_to_xml.elem("cs_txt_unit_c_ref",[],[f_c_ref_to_xml(C_REF)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_unit_c_ref) where [
  func(to_xml/1) is f_txt_unit_c_ref_to_xml
].


%% R_TXT_UNIT_NTE_REF, F_TXT_UNIT_NTE_REF_TO_XML, TS_TXT_UNIT_NTE_REF XMLABLE

%%% R_TXT_UNIT_NTE_REF

r_txt_unit_nte_ref(cs_txt_unit_nte_ref(NTE_REF)) --> r_nte_ref(NTE_REF).

%%% F_TXT_UNIT_NTE_REF_TO_XML

f_txt_unit_nte_ref_to_xml(cs_txt_unit_nte_ref(NTE_REF)) =
  term_to_xml.elem("cs_txt_unit_nte_ref",[],[f_nte_ref_to_xml(NTE_REF)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_txt_unit_nte_ref) where [
  func(to_xml/1) is f_txt_unit_nte_ref_to_xml
].
