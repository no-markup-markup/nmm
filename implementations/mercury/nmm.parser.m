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


%% TS_QTN_UNITS XMLABLE

 %% :- instance term_to_xml.xmlable(ts_qtn_units) where [
 %%   func(to_xml/1) is f_qtn_units_to_xml
 %% ].
 %% :- func (
 %%   f_qtn_units_to_xml(ts_qtn_units::in)
 %%   =
 %%   (term_to_xml.xml::out(term_to_xml.xml_doc))
 %% ) is det.
 %% f_qtn_units_to_xml(cs_qtn_units(UNITS)) =
 %%   term_to_xml.elem("cs_qtn_units",[],list.map(f_qtn_unit_to_xml,UNITS)).


%% R_QTN_UNIT, TU_QTN_UNIT XMLABLE

%%% R_QTN_UNIT

 %% r_qtn_unit(LVL,UNIT) --> (
 %%   r_tabs(LVL+1u),                  +([],r_qtn_unit_tkn,TKNS,[]), r_lb -> (
 %%     {UNIT = cu_qtn_unit_wysiwyg(nmm.lexer.f_detknize(TKNS))}
 %%   );
 %%   r_tabs(LVL), r_str("LB"), r_tab, +([],r_qtn_unit_tkn,TKNS,[]), r_lb -> (
 %%     {UNIT = cu_qtn_unit_lb}
 %%   );
 %%   {false}
 %% ).

 %%% :- pred r_qtn_unit_tkn(tu_tkn::out,ts_tkns::in,ts_tkns::out) is semidet.
 %%% r_qtn_unit_tkn(TKN) --> (
 %%%   [TKN],
 %%%   {
 %%%     TKN \= nmm.lexer.cu_tkn_tab(_),
 %%%     TKN \= nmm.lexer.cu_tkn_lb(_),
 %%%     TKN \= nmm.lexer.cu_tkn_eof
 %%%   }
 %%% ).
 %%% 
 %%% %%% XMLABLE
 %%% 
 %%% :- instance term_to_xml.xmlable(tu_qtn_unit) where [
 %%%   func(to_xml/1) is f_qtn_unit_to_xml
 %%% ].
 %%% :- func (
 %%%   f_qtn_unit_to_xml(tu_qtn_unit::in)
 %%%   =
 %%%   (term_to_xml.xml::out(term_to_xml.xml_doc))
 %%% ) is det.
 %%% f_qtn_unit_to_xml(cu_qtn_unit_wysiwyg(STR)) = term_to_xml.elem(
 %%%   "cu_qtn_unit_wysiwyg",[],[term_to_xml.data(STR)]
 %%% ).
 %%% f_qtn_unit_to_xml(cu_qtn_unit_lb)           = term_to_xml.elem(
 %%%   "cu_qtn_unit_lb",     [],[]
 %%% ).


%% R_QTN_UNITS, TS_QTN_UNITS, TS_QTN_UNITS XMLABLE

 %% %%% R_QTN_UNITS
 %% 
 %% r_qtn_units(ALLOWED_TAGS,LVL,cs_qtn_units(US)) -->
 %%   +([],r_qtn_unit,ALLOWED_TAGS,LVL,US,[]).
 %% 
 %% %%% XMLABLE
 %% 
 %% :- instance term_to_xml.xmlable(ts_qtn_units) where [
 %%   func(to_xml/1) is f_qtn_units_to_xml
 %% ].
 %% :- func (
 %%   f_qtn_units_to_xml(ts_qtn_units::in) =
 %%   (term_to_xml.xml::out(term_to_xml.xml_doc))
 %% ) is det.
 %% f_qtn_units_to_xml(cs_qtn_units(US)) =
 %%   term_to_xml.elem("cs_qtn_units",[],list.map(f_qtn_unit_to_xml,US)).
