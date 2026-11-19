:- module nmm.parser.units.

 % when new units are added, make sure to accordingly update:
 % - r_txt_unit_wysiwyg_chr
 % - r_dsp_unit_wysiwyg_chr
 % - r_qtn_unit_wysiwyg_chr

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- import_module nmm.parser.misc.


%% R_TXT_UNITS, TS_TXT_UNITS

:- type ts_txt_units ---> cs_txt_units(list(tu_txt_unit)).

:- pred r_txt_units(ts_allowed_tags, ta_lvl, ts_txt_units, ts_tkns, ts_tkns).
:- mode r_txt_units(
                    in,              in,     out,          in,      out
) is semidet.


%% R_QTN_UNITS, TS_QTN_UNITS

:- pred r_qtn_units(ta_lvl, ts_qtn_units, ts_tkns, ts_tkns).
:- mode r_qtn_units(in,     out,          in,      out) is semidet.

:- type ts_qtn_units ---> cs_qtn_units(list(tu_qtn_unit)).


%% R_TXT_UNIT, TU_TXT_UNIT

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


%% R_QTN_UNIT, TU_QTN_UNIT

:- type tu_qtn_unit ---> (
  cu_qtn_unit_wysiwyg(ts_qtn_unit_wysiwyg)
  ;
  cu_qtn_unit_emph(ts_qtn_unit_emph)
).

:- pred r_qtn_unit(ta_lvl, tu_qtn_unit, ts_tkns, ts_tkns).
:- mode r_qtn_unit(in,     out,         in,      out ) is semidet.


%% R_DSP_UNIT

:- pred r_dsp_unit(ts_allowed_tags, tu_txt_unit, ts_tkns, ts_tkns).
:- mode r_dsp_unit(in,              out,         in,      out) is semidet.


%% R_TXT_UNIT_WYSIWYG, TS_TXT_UNIT_WYSIWYG

:- type ts_txt_unit_wysiwyg ---> cs_txt_unit_wysiwyg(str).

:- pred r_txt_unit_wysiwyg(
  ts_allowed_tags, ta_lvl, ts_txt_unit_wysiwyg, ts_tkns, ts_tkns
).
:- mode r_txt_unit_wysiwyg(
  in,              in,     out,                 in,      out
) is semidet.


%% R_TXT_UNIT_EMPH, TS_TXT_UNIT_EMPH

:- type ts_txt_unit_emph ---> cs_txt_unit_emph(str).

:- pred r_txt_unit_emph(ta_lvl, ts_txt_unit_emph, ts_tkns, ts_tkns).
:- mode r_txt_unit_emph(in,     out,              in,      out) is semidet.


%% R_TXT_UNIT_C_REF, TS_TXT_UNIT_C_REF

:- type ts_txt_unit_c_ref ---> cs_txt_unit_c_ref(ts_c_ref).

:- pred r_txt_unit_c_ref(ts_allowed_tags, ts_txt_unit_c_ref, ts_tkns, ts_tkns).
:- mode r_txt_unit_c_ref(
                         in,              out,               in,      out
) is semidet.


%% R_TXT_UNIT_NTE_REF, TS_TXT_UNIT_NTE_REF

:- type ts_txt_unit_nte_ref ---> cs_txt_unit_nte_ref(ts_nte_ref).

:- pred r_txt_unit_nte_ref(ts_txt_unit_nte_ref, ts_tkns, ts_tkns).
:- mode r_txt_unit_nte_ref(out,                 in,      out) is semidet.


%% R_QTN_UNIT_WYSIWYG, TS_QTN_UNIT_WYSIWYG

:- type ts_qtn_unit_wysiwyg ---> cs_qtn_unit_wysiwyg(str).

:- pred r_qtn_unit_wysiwyg(ta_lvl, ts_qtn_unit_wysiwyg, ts_tkns, ts_tkns).
:- mode r_qtn_unit_wysiwyg(
                           in,             out,         in,      out
) is semidet.


%% R_QTN_UNIT_EMPH, TS_QTN_UNIT_EMPH

:- type ts_qtn_unit_emph ---> cs_qtn_unit_emph(str).

:- pred r_qtn_unit_emph(ta_lvl, ts_qtn_unit_emph, ts_tkns, ts_tkns).
:- mode r_qtn_unit_emph(in,     out,              in,      out) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module nmm.parser.operators.

:- import_module nmm.parser.helpers.
:- import_module nmm.parser.operators.plus.


%% R_TXT_UNITS

r_txt_units(ALLOWED_TAGS,LVL,cs_txt_units(US)) --> (
  +([],r_txt_unit,ALLOWED_TAGS,LVL,US,[])
).


%% R_QTN_UNITS

r_qtn_units(LVL,cs_qtn_units(US)) --> +([],r_qtn_unit,LVL,US,[]).


%% R_TXT_UNIT

r_txt_unit(ALLOWED_TAGS,LVL,U) --> (
  r_txt_unit_emph(                LVL,U_) -> {U = cu_txt_unit_emph(   U_)};
  r_txt_unit_c_ref(  ALLOWED_TAGS,    U_) -> {U = cu_txt_unit_c_ref(  U_)};
  r_txt_unit_nte_ref(                 U_) -> {U = cu_txt_unit_nte_ref(U_)};
  r_txt_unit_wysiwyg(ALLOWED_TAGS,LVL,U_) -> {U = cu_txt_unit_wysiwyg(U_)};
                                             {false}
).


%% R_QTN_UNIT

r_qtn_unit(LVL,U) --> (
  r_qtn_unit_emph(   LVL,U_) -> {U = cu_qtn_unit_emph(   U_)};
  r_qtn_unit_wysiwyg(LVL,U_) -> {U = cu_qtn_unit_wysiwyg(U_)};
                                {false}
).


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


%% R_TXT_UNIT_WYSIWYG

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


%% R_TXT_UNIT_EMPH

r_txt_unit_emph(LVL,cs_txt_unit_emph(STR)) --> (
  r_str("*"), r_unit_emph_str(LVL,STR), r_str("*")
).


%% R_TXT_UNIT_C_REF

r_txt_unit_c_ref(ALLOWED_TAGS,cs_txt_unit_c_ref(C_REF)) -->
  r_c_ref(ALLOWED_TAGS,C_REF).


%% R_TXT_UNIT_NTE_REF

r_txt_unit_nte_ref(cs_txt_unit_nte_ref(NTE_REF)) --> r_nte_ref(NTE_REF).


%% R_QTN_UNIT_WYSIWYG

%%% R_QTN_UNIT_WYSIWYG

r_qtn_unit_wysiwyg(LVL,cs_qtn_unit_wysiwyg(STR)) -->
  +([],r_qtn_unit_wysiwyg_chr,LVL,CHRS,[]),{STR = chrs2str(CHRS)}.

%%% HELPER R_QTN_UNIT_WYSIWYG_CHR

:- pred r_qtn_unit_wysiwyg_chr(ta_lvl, chr, ts_tkns, ts_tkns).
:- mode r_qtn_unit_wysiwyg_chr(in,     out, in,      out) is semidet.
r_qtn_unit_wysiwyg_chr(        LVL,    C) --> (
  not r_tab,
  not r_lb,
  not r_qtn_unit_emph(LVL,_),
  r_c(cu_r_any,C)
).


%% R_QTN_UNIT_EMPH

r_qtn_unit_emph(LVL,cs_qtn_unit_emph(STR)) --> (
  r_str("*"), r_unit_emph_str(LVL,STR), r_str("*")
).


%% HELPER R_UNIT_EMPH_STR

:- pred r_unit_emph_str(ta_lvl, str, ts_tkns, ts_tkns).
:- mode r_unit_emph_str(in,     out, in,      out) is semidet.
r_unit_emph_str(        LVL,    S) --> (
  r(cu_r_any,["*"],S_),
  (
    r_lb, r_tabs(LVL) -> (
      r_unit_emph_str(LVL,S__),
      {S = S_++" "++S__}
    );
    {S = S_}
  )
).
