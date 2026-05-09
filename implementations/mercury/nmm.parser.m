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


%% MODULE IMPORTS

:- use_module term_to_xml, nmm.lexer.

:- import_module nmm.parser.main.
:- import_module nmm.parser.blks.
:- import_module nmm.parser.lines.
:- import_module nmm.parser.units.


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

:- pred r_doc(ts_allowed_tags, tr_doc, ts_tkns, ts_tkns).
:- mode r_doc(in,              out,    in,      out) is semidet.


%% R_LBL_AUTO, TS_LBL_AUTO, TS_LBL_AUTO XMLABLE

:- type ts_lbl_auto ---> cs_lbl_auto.

:- instance term_to_xml.xmlable(ts_lbl_auto).

:- pred r_lbl_auto(ts_lbl_auto::out, ts_tkns::in, ts_tkns::out) is det.


%% R_LBL_CUSTOM, TS_LBL_CUSTOM, TS_LBL_CUSTOM XMLABLE

:- type ts_lbl_custom ---> cs_lbl_custom(str).

:- instance term_to_xml.xmlable(ts_lbl_custom).

:- pred r_lbl_custom(ts_lbl_custom::out, ts_tkns::in, ts_tkns::out) is semidet.


%% R_LBL, TU_LBL, TU_LBL XMLABLE

:- type tu_lbl ---> (
  cu_lbl_auto(ts_lbl_auto)
  ;
  cu_lbl_custom(ts_lbl_custom)
).

:- instance term_to_xml.xmlable(tu_lbl).

:- pred r_lbl(tu_lbl::out, ts_tkns::in, ts_tkns::out) is det.


%% R_TAG_OR_ID, TU_TAG_OR_ID, TU_TAG_OR_ID_XMLABLE

:- type tu_tag_or_id ---> (
  cu_tag_or_id_tag(ts_tag)
  ;
  cu_tag_or_id_id(tr_id)
).

:- instance term_to_xml.xmlable(tu_tag_or_id).

:- pred r_tag_or_id(
  ts_allowed_tags, tu_tag_type, tu_tag_or_id, ts_tkns, ts_tkns
).
:- mode r_tag_or_id(
  in,              in,          out,          in,      out
) is semidet.

%% R_TAG, TS_TAG, TS_TAG XMLABLE

:- type ts_tag ---> cs_tag(str).

:- instance term_to_xml.xmlable(ts_tag).

:- pred r_tag(ts_allowed_tags, tu_tag_type, ts_tag, ts_tkns, ts_tkns).
:- mode r_tag(
              in,              in,          out,    in,      out
)is semidet.

%% R_NAME, TS_NAME, TS_NAME XMLABLE

:- type ts_name ---> cs_name(str).

:- instance term_to_xml.xmlable(ts_name).

:- pred r_name(ts_name::out, ts_tkns::in, ts_tkns::out) is semidet.

%% R_SCOPE, TU_SCOPE, TU_SCOPE XMLABLE

:- type tu_scope ---> (
  cu_scope_gbl
  ;
  cu_scope_ch
  ;
  cu_scope_sec
  ;
  cu_scope_par
).

:- instance term_to_xml.xmlable(tu_scope).

:- pred r_scope(tu_scope::out, ts_tkns::in, ts_tkns::out) is semidet.


%% R_ID, TR_ID, TR_ID XMLABLE

:- type tr_id ---> cr_id(
  fld_id_tag   :: ts_tag
  ,
  fld_id_name  :: ts_name
  ,
  fld_id_scope :: maybe(tu_scope)
).

:- instance term_to_xml.xmlable(tr_id).

:- pred r_id(ts_allowed_tags, tu_tag_type, tr_id, ts_tkns, ts_tkns).
:- mode r_id(in,              in,          out,   in,      out) is semidet.

%% R_C_REF, TS_C_REF, TS_C_REF XMLABLE

:-type ts_c_ref ---> cs_c_ref(tr_id).

:- instance term_to_xml.xmlable(ts_c_ref).

:- pred r_c_ref(
  ts_allowed_tags::in, ts_c_ref::out, ts_tkns::in, ts_tkns::out
) is semidet.


%% R_NTE_REF, TS_NTE_REF, TS_NTE_REF XMLABLE

:- type ts_nte_ref ---> cs_nte_ref(tr_id).

:- instance term_to_xml.xmlable(ts_nte_ref).

:- pred r_nte_ref(ts_nte_ref, ts_tkns, ts_tkns).
:- mode r_nte_ref(out,        in,      out) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module bool, exception, nmm.parser.operators.

:- import_module
  uint
  ,
  nmm.parser.helpers
  ,
  nmm.parser.operators.plus
  ,
  nmm.parser.operators.q_mark
  ,
  nmm.parser.operators.star
  .


%% CONSTANT K_FORBIDDEN_STRS_IN_TAGS_NAMES

:- func k_forbidden_strs_in_tags_names = strs.
k_forbidden_strs_in_tags_names = ["\\", "[", "]", "(", ")", ":", ",", ";", "*"].

%% R_DOC

r_doc(ALLOWED_TAGS,DOC) --> nmm.parser.main.r_doc(ALLOWED_TAGS,DOC).


%% R_LBL_AUTO, TS_LBL_AUTO XMLABLE

r_lbl_auto(cs_lbl_auto) --> {true}.

:- instance term_to_xml.xmlable(ts_lbl_auto) where [
  func(to_xml/1) is f_lbl_auto_to_xml
].
:- func (
  f_lbl_auto_to_xml(ts_lbl_auto::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_lbl_auto_to_xml(cs_lbl_auto)  = term_to_xml.elem("cs_lbl_auto",[],[]).

%% R_LBL_CUSTOM, TS_LBL_CUSTOM XMLABLE

r_lbl_custom(cs_lbl_custom(S)) --> r(cu_r_any,["(",")","[","]"],S).

:- instance term_to_xml.xmlable(ts_lbl_custom) where [
  func(to_xml/1) is f_lbl_custom_to_xml
].
:- func (
  f_lbl_custom_to_xml(ts_lbl_custom::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_lbl_custom_to_xml(cs_lbl_custom(S)) =
  term_to_xml.elem("cs_lbl_custom",[],[term_to_xml.data(S)]).

%% R_LBL, TU_LBL XMLABLE

%%% R_LBL

r_lbl(LBL) --> (
  r_lbl_custom(LBL_) -> {LBL = cu_lbl_custom(LBL_)};
  r_lbl_auto(LBL_)   -> {LBL = cu_lbl_auto(LBL_)};
                        {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_lbl) where [
  func(to_xml/1) is f_lbl_to_xml
].
:- func (
  f_lbl_to_xml(tu_lbl::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_lbl_to_xml(cu_lbl_auto(LBL))      =
  term_to_xml.elem("cu_lbl_auto",[],[f_lbl_auto_to_xml(LBL)]).
f_lbl_to_xml(cu_lbl_custom(LBL)) =
  term_to_xml.elem("cu_lbl_custom",[],[f_lbl_custom_to_xml(LBL)]).


%% R_TAG_OR_ID, TU_TAG_OR_ID XMLABLE

%%% R_TAG_OR_ID

r_tag_or_id(ALLOWED_TAGS,TAG_TYPE,TAG_OR_ID) --> (
  r_id( ALLOWED_TAGS,TAG_TYPE,ID)  -> {TAG_OR_ID = cu_tag_or_id_id(ID)};
  r_tag(ALLOWED_TAGS,TAG_TYPE,TAG) -> {TAG_OR_ID = cu_tag_or_id_tag(TAG)};
                                      {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_tag_or_id) where [
  func(to_xml/1) is f_tag_or_id_to_xml
].
:- func (
  f_tag_or_id_to_xml(tu_tag_or_id::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_tag_or_id_to_xml(cu_tag_or_id_tag(TAG)) =
  term_to_xml.elem("cu_tag_or_id_tag",[],[f_tag_to_xml(TAG)]).
f_tag_or_id_to_xml(cu_tag_or_id_id(ID))   =
  term_to_xml.elem("cu_tag_or_id_id", [],[f_id_to_xml(ID)]).

%% R_TAG AND TS_TAG XMLABLE

%%% HELPER FUNCTION F_VALID_STR

 % the reason for this function is to make sure we do not forget to handle a
 % tu_tag_type instance when we add a new such

:- func f_valid_tag_str(str, tu_tag_type,            strs)    = bool.bool.
f_valid_tag_str(        S,   cu_tag_type_ch,         _)       = IS_VALID :- (
  if S = "CH" then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,   cu_tag_type_sec,        _)       = IS_VALID :- (
  if (S = "SEC"; S = "APP") then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,   cu_tag_type_par,        OK_TAGS) = IS_VALID :- (
  if (S = "PAR"; list.member(S,OK_TAGS)) then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,   cu_tag_type_itm,        OK_TAGS) = IS_VALID :- (
  if (S = "ITM"; list.member(S,OK_TAGS)) then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_dsp,         OK_TAGS) = IS_VALID :- (
  if (S = "DSP"; list.member(S,OK_TAGS)) then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_nte,         _)       = IS_VALID :- (
  if S = "NTE" then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_c_ref,       OK_TAGS) = IS_VALID :- (
  if (
    list.member(S,["CH","SEC","APP","PAR","ITM","DSP"])
    ;
    list.member(S,OK_TAGS)
  ) then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_nte_ref,     _)       = IS_VALID :- (
  if S = "NTE" then
    IS_VALID = bool.yes
  else
    IS_VALID = bool.no
).
f_valid_tag_str(        S,  cu_tag_type_par_rpt_ref, OK_TAGS) =
  f_valid_tag_str(      S,  cu_tag_type_par,         OK_TAGS).

%%% R_TAG

r_tag(ALLOWED_TAGS,TAG_TYPE,TAG) --> (
  r(cu_r_nws,k_forbidden_strs_in_tags_names,S),
  {S \= "REFS"},
  {ALLOWED_TAGS = cs_allowed_tags(ALLOWED_TAGS_STRS)},
  {f_valid_tag_str(S,TAG_TYPE,ALLOWED_TAGS_STRS) = bool.yes},
  {TAG = cs_tag(S)}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_tag) where [
  func(to_xml/1) is f_tag_to_xml
].
:- func (
  f_tag_to_xml(ts_tag::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_tag_to_xml(cs_tag(S)) = term_to_xml.elem("cs_tag",[],[term_to_xml.data(S)]).


%% R_NAME AND TS_NAME XMLABLE

r_name(cs_name(S)) --> r(cu_r_nws,k_forbidden_strs_in_tags_names,S).

:- instance term_to_xml.xmlable(ts_name) where [
  func(to_xml/1) is f_name_to_xml
].

:- func (
  f_name_to_xml(ts_name::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

f_name_to_xml(cs_name(S)) =
  term_to_xml.elem("cs_name",[],[term_to_xml.data(S)]).


%% R_SCOPE AND TU_SCOPE XMLABLE

%%% R_SCOPE

r_scope(S) --> (
  r_str("GBL") -> {S = cu_scope_gbl};
  r_str("CH")  -> {S = cu_scope_ch};
  r_str("SEC") -> {S = cu_scope_sec};
  r_str("APP") -> {S = cu_scope_sec};
  r_str("PAR") -> {S = cu_scope_par};
                  {false}
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_scope) where [
  func(to_xml/1) is f_scope_to_xml
].
:- func (
  f_scope_to_xml(tu_scope::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_scope_to_xml(cu_scope_gbl) = term_to_xml.elem("cu_scope_gbl",[],[]).
f_scope_to_xml(cu_scope_ch)  = term_to_xml.elem("cu_scope_ch", [],[]).
f_scope_to_xml(cu_scope_sec) = term_to_xml.elem("cu_scope_sec",[],[]).
f_scope_to_xml(cu_scope_par) = term_to_xml.elem("cu_scope_par",[],[]).


%% R_ID AND TR_ID XMLABLE

r_id(ALLOWED_TAGS,TAG_TYPE,cr_id(TAG,NAME,MAYBE_SCOPE)) -->
  r_tag(ALLOWED_TAGS,TAG_TYPE,TAG),
  r_str(":"),
  r_name(NAME),
  ?([r_str(":")],r_scope,MAYBE_SCOPE,[]).

:- instance term_to_xml.xmlable(tr_id) where [
  func(to_xml/1) is f_id_to_xml
].
:- func (
  f_id_to_xml(tr_id::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_id_to_xml(cr_id(TAG,NAME,MAYBE_SCOPE)) = XML :- (
  (
    MAYBE_SCOPE = maybe.yes(SCOPE), SCOPE_LIST = [f_scope_to_xml(SCOPE)]
    ;
    MAYBE_SCOPE = maybe.no,         SCOPE_LIST = []
  ),
  XML = term_to_xml.elem(
    "cr_id",[],[f_tag_to_xml(TAG),f_name_to_xml(NAME)]++SCOPE_LIST
  )
).


%% R_C_REF AND TS_C_REF XMLABLE

r_c_ref(ALLOWED_TAGS,cs_c_ref(ID)) -->
  r_str("["), r_id(ALLOWED_TAGS,cu_tag_type_c_ref,ID), r_str("]").

:- instance term_to_xml.xmlable(ts_c_ref) where [
  func(to_xml/1) is f_c_ref_to_xml
].
:- func (
  f_c_ref_to_xml(ts_c_ref::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_c_ref_to_xml(cs_c_ref(ID)) =
  term_to_xml.elem("cs_c_ref",[],[f_id_to_xml(ID)]).


%% R_NTE_REF AND TS_NTE_REF XMLABLE

r_nte_ref(cs_nte_ref(ID)) -->
  r_str("["), r_id(cs_allowed_tags([]),cu_tag_type_nte_ref,ID), r_str("]").

:- instance term_to_xml.xmlable(ts_nte_ref) where [
  func(to_xml/1) is f_nte_ref_to_xml
].
:- func (
  f_nte_ref_to_xml(ts_nte_ref::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.
f_nte_ref_to_xml(cs_nte_ref(ID)) =
  term_to_xml.elem("cs_nte_ref",[],[f_id_to_xml(ID)]).


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
