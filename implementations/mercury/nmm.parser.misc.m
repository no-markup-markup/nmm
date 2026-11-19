:- module nmm.parser.misc.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% R_LBL, TU_LBL

:- type tu_lbl ---> (
  cu_lbl_auto(ts_lbl_auto)
  ;
  cu_lbl_custom(ts_lbl_custom)
).

:- pred r_lbl(tu_lbl::out, ts_tkns::in, ts_tkns::out) is det.


%% R_LBL_AUTO, TS_LBL_AUTO

:- type ts_lbl_auto ---> cs_lbl_auto.

:- pred r_lbl_auto(ts_lbl_auto::out, ts_tkns::in, ts_tkns::out) is det.


%% R_LBL_CUSTOM, TS_LBL_CUSTOM

:- type ts_lbl_custom ---> cs_lbl_custom(str).

:- pred r_lbl_custom(ts_lbl_custom::out, ts_tkns::in, ts_tkns::out) is semidet.


%% R_C_REF, TS_C_REF

:-type ts_c_ref ---> cs_c_ref(tr_id).

:- pred r_c_ref(
  ts_allowed_tags::in, ts_c_ref::out, ts_tkns::in, ts_tkns::out
) is semidet.


%% R_NTE_REF, TS_NTE_REF

:- type ts_nte_ref ---> cs_nte_ref(tr_id).

:- pred r_nte_ref(ts_nte_ref, ts_tkns, ts_tkns).
:- mode r_nte_ref(out,        in,      out) is semidet.


%% R_TAG_OR_ID, TU_TAG_OR_ID

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


%% R_TAG, TS_TAG

:- type ts_tag ---> cs_tag(str).

:- pred r_tag(ts_allowed_tags, tu_tag_type, ts_tag, ts_tkns, ts_tkns).
:- mode r_tag(
              in,              in,          out,    in,      out
) is semidet.


%% R_ID, TR_ID

:- type tr_id ---> cr_id(
  fld_id_tag   :: ts_tag
  ,
  fld_id_name  :: ts_name
  ,
  fld_id_scope :: maybe(tu_scope)
).

:- pred r_id(ts_allowed_tags, tu_tag_type, tr_id, ts_tkns, ts_tkns).
:- mode r_id(in,              in,          out,   in,      out) is semidet.


%% R_NAME, TS_NAME

:- type ts_name ---> cs_name(str).

:- pred r_name(ts_name::out, ts_tkns::in, ts_tkns::out) is semidet.


%% R_SCOPE, TU_SCOPE

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


%% R_LBL

r_lbl(LBL) --> (
  r_lbl_custom(LBL_) -> {LBL = cu_lbl_custom(LBL_)};
  r_lbl_auto(LBL_)   -> {LBL = cu_lbl_auto(LBL_)};
                        {false}
).


%% R_LBL_AUTO

r_lbl_auto(cs_lbl_auto) --> {true}.


%% R_LBL_CUSTOM

r_lbl_custom(cs_lbl_custom(S)) --> r(cu_r_any,["(",")","[","]"],S).


%% R_C_REF

r_c_ref(ALLOWED_TAGS,cs_c_ref(ID)) -->
  r_str("["), r_id(ALLOWED_TAGS,cu_tag_type_c_ref,ID), r_str("]").


%% R_NTE_REF

r_nte_ref(cs_nte_ref(ID)) -->
  r_str("["), r_id(cs_allowed_tags([]),cu_tag_type_nte_ref,ID), r_str("]").


%% R_TAG_OR_ID

r_tag_or_id(ALLOWED_TAGS,TAG_TYPE,TAG_OR_ID) --> (
  r_id( ALLOWED_TAGS,TAG_TYPE,ID)  -> {TAG_OR_ID = cu_tag_or_id_id(ID)};
  r_tag(ALLOWED_TAGS,TAG_TYPE,TAG) -> {TAG_OR_ID = cu_tag_or_id_tag(TAG)};
                                      {false}
).


%% R_TAG

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


%% R_ID

r_id(ALLOWED_TAGS,TAG_TYPE,cr_id(TAG,NAME,MAYBE_SCOPE)) -->
  r_tag(ALLOWED_TAGS,TAG_TYPE,TAG),
  r_str(":"),
  r_name(NAME),
  ?([r_str(":")],r_scope,MAYBE_SCOPE,[]).


%% R_NAME

r_name(cs_name(S)) --> r(cu_r_nws,k_forbidden_strs_in_tags_names,S).


%% R_SCOPE

r_scope(S) --> (
  r_str("GBL") -> {S = cu_scope_gbl};
  r_str("CH")  -> {S = cu_scope_ch};
  r_str("SEC") -> {S = cu_scope_sec};
  r_str("APP") -> {S = cu_scope_sec};
  r_str("PAR") -> {S = cu_scope_par};
                  {false}
).
