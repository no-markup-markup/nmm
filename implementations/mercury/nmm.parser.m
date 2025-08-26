:- module nmm.parser.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% SUBMODULES

:- include_module
  parser.test
  .


%% MODULE IMPORTS

:- use_module
  nmm.lexer
  .


%% TYPE ABBREVIATIONS T_TKN AND T_TKNS

:- type t_tkn  == nmm.lexer.t_tkn.
:- type t_tkns == nmm.lexer.t_tkns.


%% TYPE T_CONF (TODO: USE)

:- type t_conf ---> c_conf(
  fld_conf_extra_ch_tags  :: strs, % in addition to ‘CH'
  fld_conf_extra_sec_tags :: strs, % in addition to ‘SEC'
  fld_conf_extra_app_tags :: strs, % in addition to ‘APP'
  fld_conf_extra_par_tags :: strs, % in addition to ‘PAR'
  fld_conf_extra_itm_tags :: strs, % in addition to ‘ITM'
  fld_conf_extra_dsp_tags :: strs  % in addition to ‘DSP’
).


%% FUNCTION F_VALIDATE_CONF AND TYPE T_VALIDATE_CONF_RES

:- type t_validate_conf_res --->
  c_validate_conf_res_ok;
  c_validate_conf_res_err(str).

:- func f_validate_conf(t_conf) = t_validate_conf_res.


%% CONSTANT K_FORBIDDEN_STRS_IN_TAGS_NAMES

:- func k_forbidden_strs_in_tags_names = strs.


%% ENUM TYPE T_R FOR WHAT PARTS OF A LINE TO READ

:- type t_r --->
  c_r_nws;     % read only non-whitespace tokens
  c_r_sps;     % read only space tokens
  c_r_esc;     % read only escaped characters
  c_r_nws_sps; % read only non-escaped tokens
  c_r_any.     % read any of the above


%% (TODO: USED?) TYPE T_STOPS (= STRS) FOR NON-ESCAPED STRINGS BEFORE WHICH TO STOP READING

:- type t_stops == strs.


%% DCG RULES AND CORRESPONDING AST TYPES

%%% KLEENE STAR OPERATOR ‘*’

:- pred *(pred(TKNS, TKNS),           TKNS,  TKNS).
:- mode *(pred(in,   out) is semidet, in,    out) is det.

%%% KLEENE PLUS OPERATOR ‘+’

:- pred +(pred(TKNS, TKNS),           TKNS,  TKNS).
:- mode +(pred(in,   out) is semidet, in,    out) is semidet.

%%% QUESTION MARK OPERATOR ‘?’

:- pred ?(pred(TKNS, TKNS),           TKNS,  TKNS).
:- mode ?(pred(in,   out) is semidet, in,    out) is det.


%%% R

% DCG rules for reading non-empty parts of a line or a whole non-empty line
% (excluding line breaks), optionally stopping right before certain strings

:- pred r(t_r, t_stops, str, t_tkns, t_tkns).
:- mode r(in,  in,      in,  in,     out) is semidet.
:- mode r(in,  in,      out, in,     out) is semidet.

:- pred r(t_r,          str, t_tkns, t_tkns).
:- mode r(in,           in,      in,    out) is semidet.
:- mode r(in,           out,     in,    out) is semidet.

:- pred r(              str, t_tkns, t_tkns).
:- mode r(              in,      in,    out) is semidet.
:- mode r(              out,     in,    out) is semidet.

%%% R_STR

% DCG rule consuming non-escaped string terminals
:- pred r_str(str::in, t_tkns::in, t_tkns::out) is semidet.

%%% R_SP

% DCG rule for consuming a space character
:- pred r_sp(t_tkns::in, t_tkns::out) is semidet.

%%% R_LB

% DCG rule for consuming a line break

:- pred r_lb(t_tkns::in, t_tkns::out) is semidet.

%%% R_TAB AND R_TABS

% DCG rule for consuming a tab
:- pred r_tab(t_tkns::in, t_tkns::out) is semidet.

% DCG rule for consuming specified number of tabs
:- pred r_tabs(uint::in, t_tkns::in, t_tkns::out) is semidet.

%%% R_EOF

% DCG rule for consuming EOF
:- pred r_eof(t_tkns::in, t_tkns::out) is semidet.

%%% TODO: T_DOC AND R_DOC

 %% :- type t_doc --->
 %%   c_doc_pars(list(par));
 %%   c_doc_blks(list(blk)).
 %% 
 %% :- pred r_doc(t_doc::out, t_tkns::in, t_tkns::out) is semidet.

%%% TODO: T_PAR, R_PAR AND R_PARS

 %% :- type t_par ---> c_par(
 %%   fld_par_tag_or_id :: maybe(t_tag_or_id),
 %%   fld_par_hdr       :: maybe(t_hdr),
 %%   fld_par_blks      :: list(blk)
 %% ).
 %% 
 %% :- pred r_par(t_par::out, t_tkns::in, t_tkns::out).
 %% 
 %% :- pred r_pars(list(pars)::out, t_tkns::in, t_tkns::out).

%%% T_BLK, T_BLKS, R_BLK AND R_BLKS

:- type t_blk --->
  c_blk_txt(t_blk_txt);
  c_blk_blt(t_blk_blt).

:- type t_blks == list(t_blk).

% doc:               LVL   VALID_TAGS
:- pred r_blk(t_blk, uint, strs,      t_tkns, t_tkns).
:- mode r_blk(out,   in,   in,        in,     out) is semidet.


% doc:                 LVL   VALID_TAGS
:- pred r_blks(t_blks, uint, strs,      t_tkns, t_tkns).
:- mode r_blks(out,    in,   in,        in,     out) is semidet.

%%% T_BLK_TXT AND R_BLK_TXT

:- type t_blk_txt == list(t_txt_unit).

% doc:                       LVL   VALID_TAGS
:- pred r_blk_txt(t_blk_txt, uint, strs,      t_tkns, t_tkns).
:- mode r_blk_txt(out,       in,   in,        in,     out) is semidet.

%%% T_BLK_BLT AND R_BLK_BLT

:- type t_blk_blt == t_blks.

% doc:                       LVL   VALID_TAGS
:- pred r_blk_blt(t_blk_blt, uint, strs,      t_tkns, t_tkns).
:- mode r_blk_blt(out,       in,   in,        in,     out) is semidet.

%%% TODO: T_TAG_OR_ID AND R_TAG_OR_ID

 %% :- type t_tag_or_id --->
 %%   c_tag_or_id_tag(t_tag);
 %%   c_tag_or_id_id(t_id).
 %% 
 %% :- pred r_tag_or_id(t_tag_or_id::out, t_tkns::in, t_tkns::out).

%%% T_TAG AND R_TAG

:- type t_tag == str.

% doc:                    VALID_TAGS
:- pred r_tag(t_tag::out, strs::in,  t_tkns::in, t_tkns::out) is semidet.

%%% T_NAME AND R_NAME

:- type t_name == str.

:- pred r_name(t_name::out, t_tkns::in, t_tkns::out) is semidet.

%%% T_ID AND R_ID

:- type t_id ---> c_id(
  fld_id_tag  :: t_tag,
  fld_id_name :: t_name
).

% doc:                  VALID_TAGS
:- pred r_id(t_id::out, strs::in,  t_tkns::in, t_tkns::out) is semidet.

%%% TODO: T_HDR AND R_HDR

 %% :- type t_hdr ---> c_hdr(list(t_txt_unit)).
 %% 
 %% :- pred r_hdr(t_hdr::out, t_tkns::in, t_tkns::out).

%%% T_C_REF AND R_C_REF

:-type t_c_ref ---> c_c_ref(t_id).

% doc:                        VALID_TAGS
:- pred r_c_ref(t_c_ref::out, strs::in,  t_tkns::in, t_tkns::out) is semidet.

%%% T_TXT_UNIT, R_TXT_UNIT AND R_TXT_UNITS

:- type t_txt_unit --->
  c_txt_unit_wysiwyg(str);
  c_txt_unit_emph(str);
  c_txt_unit_c_ref(t_c_ref).

% doc:                         VALID_TAGS
:- pred r_txt_unit(t_txt_unit, strs,      t_tkns, t_tkns).
:- mode r_txt_unit(out,        in,        in,     out) is semidet.

% doc:                                VALID_TAGS
:- pred r_txt_units(list(t_txt_unit), strs,      t_tkns, t_tkns).
:- mode r_txt_units(out,              in,        in,     out) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- import_module uint.


%% CONSTANT K_FORBIDDEN_STRS_IN_TAGS_NAMES

k_forbidden_strs_in_tags_names =
  ["\\", "[", "]", "(", ")", ":", ",", ";", "*"].


%% FUNCTION F_VALIDATE_CONF

%%% THE FUNCTION

f_validate_conf(CONF) = RES :-
  (
    if not      p_valid_tags(fld_conf_extra_ch_tags( CONF)) then
      RES = c_validate_conf_res_err("invalid chapter tags")
    else if not p_valid_tags(fld_conf_extra_sec_tags(CONF)) then
      RES = c_validate_conf_res_err("invalid section tags")
    else if not p_valid_tags(fld_conf_extra_app_tags(CONF)) then
      RES = c_validate_conf_res_err("invalid appendix tags")
    else if not p_valid_tags(fld_conf_extra_par_tags(CONF)) then
      RES = c_validate_conf_res_err("invalid paragraph tags")
    else if not p_valid_tags(fld_conf_extra_itm_tags(CONF)) then
      RES = c_validate_conf_res_err("invalid item tags")
    else if not p_valid_tags(fld_conf_extra_dsp_tags(CONF)) then
      RES = c_validate_conf_res_err("invalid displayed tags")
    else
      RES = c_validate_conf_res_ok
  ).

%%% HELPER P_VALID_TAGS

:- pred p_valid_tags(strs::in) is semidet.
p_valid_tags([]).
p_valid_tags([TAG|TAGS]) :- p_valid_tag(TAG), p_valid_tags(TAGS).


%%% HELPER P_VALID_TAG

:- pred p_valid_tag(str::in) is semidet.
p_valid_tag(TAG) :- list.all_false(
  (pred(S::in) is semidet :- string.sub_string_search(TAG,S,_)),
  k_forbidden_strs_in_tags_names
).


%% DCG RULES

%%% STAR OPERATOR ‘*’

*(P) --> (P, *(P)) -> []; [].

%%% PLUS OPERATOR ‘+’

+(P) --> (P, +(P)) -> []; P.

%%% QUESTION MARK OPERATOR ‘?’

?(P) --> P -> []; [].

%%% HELPER R_C (READ NON-TAB NON-LINE-BREAK CHARACTER)

:- pred r_c(t_r, chr, t_tkns, t_tkns).
:- mode r_c(in,  in,  in,     out) is semidet.
:- mode r_c(in,  out, in,     out) is semidet.

:- pred r_c(     chr, t_tkns, t_tkns).
:- mode r_c(     in,  in,     out) is semidet.
:- mode r_c(     out, in,     out) is semidet.

r_c(c_r_nws,     C) --> [nmm.lexer.c_tkn_nws(_,C)].
r_c(c_r_sps,     C) --> [nmm.lexer.c_tkn_sp( _,C)].
r_c(c_r_esc,     C) --> [nmm.lexer.c_tkn_esc(_,C)].
r_c(c_r_nws_sps, C) --> [nmm.lexer.c_tkn_nws(_,C)].
r_c(c_r_nws_sps, C) --> [nmm.lexer.c_tkn_sp( _,C)].
r_c(c_r_any,     C) --> [nmm.lexer.c_tkn_nws(_,C)].
r_c(c_r_any,     C) --> [nmm.lexer.c_tkn_sp( _,C)].
r_c(c_r_any,     C) --> [nmm.lexer.c_tkn_esc(_,C)].

r_c(             C) --> r_c(c_r_any,C).

%%% R_STR

r_str(S) --> if {S = ""} then {true} else r_str_rec(str2chrs(S)).

:- pred r_str_rec(chrs::in, t_tkns::in, t_tkns::out) is semidet.
r_str_rec(        [C|CS]) --> (
  r_c(c_r_nws_sps,C), r_str_rec(CS) -> [];
                                       r_c(c_r_nws_sps,C)
).

%%% R

%%%% THE RULE

r(         S) --> r(c_r_any,   S).
r(R,       S) --> r(R,      [],S).
r(R, STPS, S) --> r_rec(R,STPS,CS), {S = chrs2str(CS), S \= ""}.

:- pred r_rec(t_r, t_stops, chrs, t_tkns, t_tkns).
:- mode r_rec(in,  in,      out,  in,     out) is det.
r_rec(        R,   STPS,    CS) -->
  r_stop(STPS) -> [],                  {CS = []};
  r_c(R,C)     -> r_rec(R,STPS,CS_TL), {CS = [C|CS_TL]};
                  [],                  {CS = []}.

%%%% HELPER R_STOP

% succeeds without consuming any tokens iff possible to consume any non-escaped
% string from first argument
:- pred r_stop(t_stops,       t_tkns,  t_tkns).
:- mode r_stop(     in,       in,      out) is semidet.
r_stop(        [STP|STPS_TL], TKNS_IN, TKNS_OUT) :-
  (
    if r_str(STP,TKNS_IN,_) then
      true
    else
      r_stop(STPS_TL,TKNS_IN,TKNS_OUT)
  ),
  TKNS_OUT = TKNS_IN.

%%% R_LB

r_lb --> [nmm.lexer.c_tkn_lb(_)].

%%% R_SP

r_sp --> [nmm.lexer.c_tkn_sp(_,_)].

%%% R_TAB AND R_TABS

r_tab --> [nmm.lexer.c_tkn_tab(_)].

r_tabs(N) -->
  if {N = 0u} then [] else r_tab, r_tabs(N-1u).

%%% R_EOF

r_eof --> [nmm.lexer.c_tkn_eof].

%%% R_DOC

 %% r_doc(c_doc_pars(PARS)) --> r_pars(  PARS), r_eof.
 %% r_doc(c_doc_blks(BLKS)) --> r_blks(0,BLKS), r_eof.

%%% R_PAR AND R_PARS

 %% r_par(c_par(MAYBE_TAG_OR_ID,MAYBE_HDR,BLKS)) -->
 %%   r_c('¶'),
 %%   r_sp*,
 %%   r_maybe_tag_or_id(MAYBE_TAG_OR_ID,["PAR"]),
 %%   r_lb,
 %%   r_maybe_header(MAYBE_HDR),
 %%   r_lb+,
 %%   r_blks(BLKS).
 %% 
 %% r_pars([PAR|PARS]) ---> (
 %%   r_par(PAR), r_pars(PARS) -> [];
 %%                               r_par(PAR), {PARS = []}
 %% ).

%%% HELPER R_MAYBE_TAG_OR_ID

 %% :- pred
 %%   r_maybe_tag_or_id(maybe(t_tag_or_id)::out, strs::in, t_tkns::in, t_tkns::out).
 %% r_maybe_tag_or_id(  RES,                     VALID_TAGS) --> (
 %%   r_id( ID, VALID_TAGS) -> {RES = maybe.yes(ID)};
 %%   r_tag(TAG,VALID_TAGS) -> {RES = maybe.yes(TAG)};
 %%   []                    -> {RES = maybe.no}
 %% ).

%%% HELPER R_MAYBE_HDR

 %% :- pred r_maybe_hdr(maybe(t_hdr)::out, t_tkns::in, t_tkns::out).
 %% r_maybe_hdr(        RES) --> (
 %%   r_blk_txt(TXT_UNITS,0) -> {RES = maybe.yes(c_hdr(TXT_UNITS))};
 %%   []                     -> {RES = maybe.no}
 %% ).

%%% R_ID

r_id(c_id(TAG,NAME),VALID_TAGS) -->
  r_tag(TAG,VALID_TAGS), r_c(':'), r_name(NAME).

%%% R_TAG

r_tag(TAG,VALID_TAGS) -->
  r(c_r_nws,k_forbidden_strs_in_tags_names,TAG),
  {list.member(TAG,VALID_TAGS)}.

%%% R_NAME

r_name(NAME) --> r(c_r_nws,k_forbidden_strs_in_tags_names,NAME).

%%% R_C_REF

r_c_ref(c_c_ref(ID),VALID_TAGS) -->
  r_str("["),
  r_id(ID,VALID_TAGS),
  r_str("]").

%%% R_TXT_UNIT AND R_TXT_UNITS

r_txt_unit(U,VALID_TAGS) -->
  r_c_ref(CR,VALID_TAGS)            -> {U = c_txt_unit_c_ref(CR)};
  r_txt_unit_wysiwyg(S,VALID_TAGS)  -> {U = c_txt_unit_wysiwyg(S)};
                                       {false}.

% doc:                          VALID_TAGS
:- pred r_txt_unit_wysiwyg(str, strs,      t_tkns, t_tkns).
:- mode r_txt_unit_wysiwyg(out, in,        in,     out) is semidet.
r_txt_unit_wysiwyg(S,VALID_TAGS) -->
  not r_tab,
  not r_lb,
  not r_c_ref(_,VALID_TAGS),
  r_c(CHR),
  (
    r_txt_unit_wysiwyg(S_,VALID_TAGS) -> {S = string.append(chr2str(CHR),S_)};
                                         {S = chr2str(CHR)}
  ).

r_txt_units(US,VALID_TAGS) -->
  r_txt_unit(U,VALID_TAGS),
  (
    r_txt_units(US_,VALID_TAGS) -> {US = [U]++US_};
                                   {US = [U]}
  ).

%%% R_BLK AND R_BLKS

r_blk(BLK,LVL,VALID_TAGS) -->
  r_blk_txt(BLK_TXT,LVL,VALID_TAGS) -> {BLK = c_blk_txt(BLK_TXT)};
  r_blk_blt(BLK_BLT,LVL,VALID_TAGS) -> {BLK = c_blk_blt(BLK_BLT)};
                                       {false}.

r_blks(BLKS,LVL,VALID_TAGS) -->
  r_blk(BLK,LVL,VALID_TAGS),
  (
    +r_lb, r_tabs(LVL), r_blks(BLKS_,LVL,VALID_TAGS) -> {BLKS = [BLK]++BLKS_};
                                                        {BLKS = [BLK]}
  ).

%%% R_BLK_TXT

r_blk_txt(US,LVL,VALID_TAGS) -->
  r_blk_txt_line(US_,VALID_TAGS),
  (
    r_tabs(LVL), r_blk_txt_line(US__,VALID_TAGS) -> {US = US_ ++ US__};
                                                    {US = US_}
  ).

:- pred r_blk_txt_line(list(t_txt_unit), strs, t_tkns, t_tkns).
:- mode r_blk_txt_line(out,              in,   in,     out) is semidet.
r_blk_txt_line(UNITS,VALID_TAGS) --> r_txt_units(UNITS,VALID_TAGS), r_lb.

%%% R_BLK_BLT

r_blk_blt(BLKS,LVL,VALID_TAGS) -->
  r_str("-"), r_tab, r_blks(BLKS,LVL+1u,VALID_TAGS).
