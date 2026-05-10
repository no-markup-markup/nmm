:- module nmm.parser.misc.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module term_to_xml.


%% R_LBL, TU_LBL, F_LBL_TO_XML, TU_LBL XMLABLE

:- type tu_lbl ---> (
  cu_lbl_auto(ts_lbl_auto)
  ;
  cu_lbl_custom(ts_lbl_custom)
).

:- pred r_lbl(tu_lbl::out, ts_tkns::in, ts_tkns::out) is det.

:- func (
  f_lbl_to_xml(tu_lbl::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_lbl).


%% R_LBL_AUTO, TS_LBL_AUTO, F_LBL_AUTO_TO_XML, TS_LBL_AUTO XMLABLE

:- type ts_lbl_auto ---> cs_lbl_auto.

:- pred r_lbl_auto(ts_lbl_auto::out, ts_tkns::in, ts_tkns::out) is det.

:- func (
  f_lbl_auto_to_xml(ts_lbl_auto::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_lbl_auto).


%% R_LBL_CUSTOM, TS_LBL_CUSTOM, F_LBL_CUSTOM_TO_XML, TS_LBL_CUSTOM XMLABLE

:- type ts_lbl_custom ---> cs_lbl_custom(str).

:- pred r_lbl_custom(ts_lbl_custom::out, ts_tkns::in, ts_tkns::out) is semidet.

:- func (
  f_lbl_custom_to_xml(ts_lbl_custom::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_lbl_custom).


%% R_C_REF, TS_C_REF, F_C_REF_TO_XML, TS_C_REF XMLABLE

:-type ts_c_ref ---> cs_c_ref(tr_id).

:- pred r_c_ref(
  ts_allowed_tags::in, ts_c_ref::out, ts_tkns::in, ts_tkns::out
) is semidet.

:- func (
  f_c_ref_to_xml(ts_c_ref::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_c_ref).


%% R_NTE_REF, TS_NTE_REF, F_NTE_REF_TO_XML, TS_NTE_REF XMLABLE

:- type ts_nte_ref ---> cs_nte_ref(tr_id).

:- pred r_nte_ref(ts_nte_ref, ts_tkns, ts_tkns).
:- mode r_nte_ref(out,        in,      out) is semidet.

:- func (
  f_nte_ref_to_xml(ts_nte_ref::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_nte_ref).


%% R_TAG_OR_ID, TU_TAG_OR_ID, F_TAG_OR_ID_TO_XML, TU_TAG_OR_ID_XMLABLE

:- type tu_tag_or_id ---> (
  cu_tag_or_id_tag(ts_tag)
  ;
  cu_tag_or_id_id(tr_id)
).

:- pred r_tag_or_id(
  ts_allowed_tags, tu_tag_type, tu_tag_or_id, ts_tkns, ts_tkns
).
:- mode r_tag_or_id(
  in,              in,          out,          in,      out
) is semidet.

:- func (
  f_tag_or_id_to_xml(tu_tag_or_id::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_tag_or_id).


%% R_TAG, TS_TAG, F_TAG_TO_XML, TS_TAG XMLABLE

:- type ts_tag ---> cs_tag(str).

:- pred r_tag(ts_allowed_tags, tu_tag_type, ts_tag, ts_tkns, ts_tkns).
:- mode r_tag(
              in,              in,          out,    in,      out
) is semidet.

:- func (
  f_tag_to_xml(ts_tag::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_tag).


%% R_ID, TR_ID, F_ID_TO_XML, TR_ID XMLABLE

:- type tr_id ---> cr_id(
  fld_id_tag   :: ts_tag
  ,
  fld_id_name  :: ts_name
  ,
  fld_id_scope :: maybe(tu_scope)
).

:- pred r_id(ts_allowed_tags, tu_tag_type, tr_id, ts_tkns, ts_tkns).
:- mode r_id(in,              in,          out,   in,      out) is semidet.

:- func (
  f_id_to_xml(tr_id::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tr_id).


%% R_NAME, TS_NAME, F_NAME_TO_XML, TS_NAME XMLABLE

:- type ts_name ---> cs_name(str).

:- pred r_name(ts_name::out, ts_tkns::in, ts_tkns::out) is semidet.

:- func (
  f_name_to_xml(ts_name::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_name).


%% R_SCOPE, TU_SCOPE, F_SCOPE_TO_XML, TU_SCOPE XMLABLE

:- type tu_scope ---> (
  cu_scope_gbl
  ;
  cu_scope_ch
  ;
  cu_scope_sec
  ;
  cu_scope_par
).

:- pred r_scope(tu_scope::out, ts_tkns::in, ts_tkns::out) is semidet.

:- func (
  f_scope_to_xml(tu_scope::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_scope).



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module bool.

:- use_module nmm.parser.operators.

:- import_module nmm.parser.helpers.
:- import_module nmm.parser.operators.q_mark.


%% CONSTANT K_FORBIDDEN_STRS_IN_TAGS_NAMES

:- func k_forbidden_strs_in_tags_names = strs.
k_forbidden_strs_in_tags_names = ["\\", "[", "]", "(", ")", ":", ",", ";", "*"].


%% R_LBL, F_LBL_TO_XML, TU_LBL XMLABLE

r_lbl(LBL) --> (
  r_lbl_custom(LBL_) -> {LBL = cu_lbl_custom(LBL_)};
  r_lbl_auto(LBL_)   -> {LBL = cu_lbl_auto(LBL_)};
                        {false}
).

f_lbl_to_xml(cu_lbl_auto(LBL))      =
  term_to_xml.elem("cu_lbl_auto",[],[f_lbl_auto_to_xml(LBL)]).
f_lbl_to_xml(cu_lbl_custom(LBL)) =
  term_to_xml.elem("cu_lbl_custom",[],[f_lbl_custom_to_xml(LBL)]).

:- instance term_to_xml.xmlable(tu_lbl) where [
  func(to_xml/1) is f_lbl_to_xml
].


%% R_LBL_AUTO, F_LBL_AUTO_TO_XML, TU_LBL XMLABLE

r_lbl_auto(cs_lbl_auto) --> {true}.

f_lbl_auto_to_xml(cs_lbl_auto)  = term_to_xml.elem("cs_lbl_auto",[],[]).

:- instance term_to_xml.xmlable(ts_lbl_auto) where [
  func(to_xml/1) is f_lbl_auto_to_xml
].

%% R_LBL_CUSTOM, F_LBL_CUSTOM_TO_XML, TS_LBL_CUSTOM XMLABLE

r_lbl_custom(cs_lbl_custom(S)) --> r(cu_r_any,["(",")","[","]"],S).

:- instance term_to_xml.xmlable(ts_lbl_custom) where [
  func(to_xml/1) is f_lbl_custom_to_xml
].

f_lbl_custom_to_xml(cs_lbl_custom(S)) =
  term_to_xml.elem("cs_lbl_custom",[],[term_to_xml.data(S)]).

%% R_C_REF, F_C_REF_TO_XML, TS_C_REF XMLABLE

r_c_ref(ALLOWED_TAGS,cs_c_ref(ID)) -->
  r_str("["), r_id(ALLOWED_TAGS,cu_tag_type_c_ref,ID), r_str("]").

f_c_ref_to_xml(cs_c_ref(ID)) =
  term_to_xml.elem("cs_c_ref",[],[f_id_to_xml(ID)]).

:- instance term_to_xml.xmlable(ts_c_ref) where [
  func(to_xml/1) is f_c_ref_to_xml
].


%% R_NTE_REF, F_NTE_REF_TO_XML, TS_NTE_REF XMLABLE

r_nte_ref(cs_nte_ref(ID)) -->
  r_str("["), r_id(cs_allowed_tags([]),cu_tag_type_nte_ref,ID), r_str("]").

f_nte_ref_to_xml(cs_nte_ref(ID)) =
  term_to_xml.elem("cs_nte_ref",[],[f_id_to_xml(ID)]).

:- instance term_to_xml.xmlable(ts_nte_ref) where [
  func(to_xml/1) is f_nte_ref_to_xml
].


%% R_TAG_OR_ID, F_TAG_OR_ID_TO_XML, TU_TAG_OR_ID XMLABLE

r_tag_or_id(ALLOWED_TAGS,TAG_TYPE,TAG_OR_ID) --> (
  r_id( ALLOWED_TAGS,TAG_TYPE,ID)  -> {TAG_OR_ID = cu_tag_or_id_id(ID)};
  r_tag(ALLOWED_TAGS,TAG_TYPE,TAG) -> {TAG_OR_ID = cu_tag_or_id_tag(TAG)};
                                      {false}
).

f_tag_or_id_to_xml(cu_tag_or_id_tag(TAG)) =
  term_to_xml.elem("cu_tag_or_id_tag",[],[f_tag_to_xml(TAG)]).
f_tag_or_id_to_xml(cu_tag_or_id_id(ID))   =
  term_to_xml.elem("cu_tag_or_id_id", [],[f_id_to_xml(ID)]).

:- instance term_to_xml.xmlable(tu_tag_or_id) where [
  func(to_xml/1) is f_tag_or_id_to_xml
].

%% R_TAG, F_TAG_TO_XML, TS_TAG XMLABLE

%%% HELPER FUNCTION F_VALID_TAG_STR

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

%%% F_TAG_TO_XML

f_tag_to_xml(cs_tag(S)) = term_to_xml.elem("cs_tag",[],[term_to_xml.data(S)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_tag) where [
  func(to_xml/1) is f_tag_to_xml
].


%% R_ID, F_ID_TO_XML, TR_ID XMLABLE

r_id(ALLOWED_TAGS,TAG_TYPE,cr_id(TAG,NAME,MAYBE_SCOPE)) -->
  r_tag(ALLOWED_TAGS,TAG_TYPE,TAG),
  r_str(":"),
  r_name(NAME),
  ?([r_str(":")],r_scope,MAYBE_SCOPE,[]).

:- instance term_to_xml.xmlable(tr_id) where [
  func(to_xml/1) is f_id_to_xml
].

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


%% R_NAME, F_NAME_TO_XML, TS_NAME XMLABLE

r_name(cs_name(S)) --> r(cu_r_nws,k_forbidden_strs_in_tags_names,S).

:- instance term_to_xml.xmlable(ts_name) where [
  func(to_xml/1) is f_name_to_xml
].

f_name_to_xml(cs_name(S)) =
  term_to_xml.elem("cs_name",[],[term_to_xml.data(S)]).


%% R_SCOPE, F_SCOPE_TO_XML, TU_SCOPE XMLABLE

%%% R_SCOPE

r_scope(S) --> (
  r_str("GBL") -> {S = cu_scope_gbl};
  r_str("CH")  -> {S = cu_scope_ch};
  r_str("SEC") -> {S = cu_scope_sec};
  r_str("APP") -> {S = cu_scope_sec};
  r_str("PAR") -> {S = cu_scope_par};
                  {false}
).

%%% F_SCOPE_TO_XML

f_scope_to_xml(cu_scope_gbl) = term_to_xml.elem("cu_scope_gbl",[],[]).
f_scope_to_xml(cu_scope_ch)  = term_to_xml.elem("cu_scope_ch", [],[]).
f_scope_to_xml(cu_scope_sec) = term_to_xml.elem("cu_scope_sec",[],[]).
f_scope_to_xml(cu_scope_par) = term_to_xml.elem("cu_scope_par",[],[]).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_scope) where [
  func(to_xml/1) is f_scope_to_xml
].
