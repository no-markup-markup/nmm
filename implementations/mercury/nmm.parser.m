:- module nmm.parser.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% SUBMODULES

:- include_module parser.test.
:- include_module parser.helpers.
:- include_module parser.operators.
:- include_module parser.main.
:- include_module parser.blks.
:- include_module parser.lines.
:- include_module parser.units.
:- include_module parser.misc.


%% MODULE IMPORTS

:- use_module nmm.lexer.
:- use_module nmm.parser.main.


%% TA_LVL (= UINT)

:- type ta_lvl == uint.


%% TYPE ABBREVIATIONS TU_TKN AND TS_TKNS

:- type tu_tkn  == nmm.lexer.tu_tkn.
:- type ts_tkns == nmm.lexer.ts_tkns.


%% TS_ALLOWED_TAGS

:- type ts_allowed_tags ---> cs_allowed_tags(list(str)).


%% TU_TAG_TYPE

:- type tu_tag_type ---> (
  cu_tag_type_ch
  ;
  cu_tag_type_sec
  ;
  cu_tag_type_par
  ;
  cu_tag_type_itm
  ;
  cu_tag_type_dsp
  ;
  cu_tag_type_nte
  ;
  cu_tag_type_c_ref
  ;
  cu_tag_type_nte_ref
  ;
  cu_tag_type_par_rpt_ref
).


%% R_DOC

:- pred r_doc(ts_allowed_tags, nmm.parser.main.tr_doc, ts_tkns, ts_tkns).
:- mode r_doc(in,              out,                    in,      out) is semidet.


% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% R_DOC

r_doc(ALLOWED_TAGS,DOC) --> nmm.parser.main.r_doc(ALLOWED_TAGS,DOC).
