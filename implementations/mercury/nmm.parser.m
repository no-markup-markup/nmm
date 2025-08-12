:- module nmm.parser.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% SUBMODULES

 %% :- include_module
 %%   parser.test
 %%   ,
 %%   parser.blk
 %%   ,
 %%   parser.cr
 %%   ,
 %%   parser.name
 %%   ,
 %%   parser.tag
 %%   .


%% MODULE IMPORTS

:- use_module
  nmm.lexer
  .


%% TYPE ABBREVIATIONS T_TKN AND T_TKNS

:- type t_tkn  == nmm.lexer.t_tkn.
:- type t_tkns == nmm.lexer.t_tkns.


%% TYPE T_CONF

:- type t_conf ---> c_conf(
  t_xtra_ch_tags,
  t_xtra_sec_tags,
  t_xtra_app_tags,
  t_xtra_par_tags,
  t_xtra_itm_tags,
  t_xtra_dsp_tags
).

:- type t_xtra_ch_tags  ---> c_xtra_ch_tags( strings). % in addition to ‘CH’
:- type t_xtra_sec_tags ---> c_xtra_sec_tags(strings). % in addition to ‘SEC’
:- type t_xtra_app_tags ---> c_xtra_app_tags(strings). % in addition to ‘APP’
:- type t_xtra_par_tags ---> c_xtra_par_tags(strings). % in addition to ‘PAR’
:- type t_xtra_itm_tags ---> c_xtra_itm_tags(strings). % in addition to ‘ITM’
:- type t_xtra_dsp_tags ---> c_xtra_dsp_tags(strings). % in addition to ‘DSP’


%% FUNCTION F_VALIDATE_CONF AND TYPE T_VALIDATE_CONF_RES

:- func f_validate_conf(t_conf) = t_validate_conf_res.

:- type t_validate_conf_res --->
  c_validate_conf_res_ok;
  c_validate_conf_res_err(str).


%% CONSTANT K_FORBIDDEN_STRS_IN_TAGS_AND_NAMES

:- func k_forbidden_strs_in_tags_and_names = strings.


%% ENUM TYPE T_R FOR WHAT PARTS OF A LINE TO READ

:- type t_r --->
  c_r_nws;     % read only non-whitspace tokens
  c_r_sps;     % read only non-tab space tokens
  c_r_esc;     % read only escaped characters
  c_r_nws_sps; % read only non-escaped tokens
  c_r_any.     % read any token


%% TYPE T_STOPS (= STRINGS) FOR NON-ESCAPED STRINGS BEFORE WHICH TO STOP READING

:- type t_stops == strings.


%% DCG RULES AND CORRESPONDING AST TYPES

%%% R

% DCG rules for reading non-empty parts of a line or a whole non-empty line
% (excluding line breaks), optionally stopping right before certain strings

:- pred r(t_r,t_stops,str,t_tkns,t_tkns).
:- mode r(in, in,     in,     in,   out) is semidet.
:- mode r(in, in,     out,    in,   out) is semidet.

:- pred r(t_r,        str,t_tkns,t_tkns).
:- mode r(in,         in,     in,   out) is semidet.
:- mode r(in,         out,    in,   out) is semidet.

:- pred r(            str,t_tkns,t_tkns).
:- mode r(            in,     in,   out) is semidet.
:- mode r(            out,    in,   out) is semidet.

%%% R_STR

% DCG rule consuming non-escaped string terminals
:- pred r_str(str,t_tkns,t_tkns).
:- mode r_str(in,     in,   out) is semidet.

%%% R_SP AND R_SPS

% DCG rules for reading space characters

:- pred r_sp( t_tkns::in,t_tkns::out) is semidet.

:- pred r_sps(t_tkns::in,t_tkns::out) is semidet.

%%% R_LB AND R_LBS

% DCG rules for reading line breaks

:- pred r_lb( t_tkns::in,t_tkns::out) is semidet.

:- pred r_lbs(t_tkns::in,t_tkns::out) is semidet.

%%% R_TAB AND R_TABS

% DCG rules for reading tabs

:- pred r_tab(          t_tkns::in,t_tkns::out) is semidet.

:- pred r_tabs(uint::in,t_tkns::in,t_tkns::out) is semidet.

:- pred r_tabs(         t_tkns::in,t_tkns::out) is semidet.

%%% R_EOF

% DCG rule for reading EOF
:- pred r_eof(t_tkns::in,t_tkns::out) is semidet.

%%% T_DOC AND R_DOC

:- type t_doc --->
  c_doc_pars(t_pars);
  c_doc_blks(t_blks).

:- pred r_doc(t_doc::out,t_tkns::in,t_tkns::out) is semidet.

%%% T_PAR, T_PARS, R_PAR AND R_PARS

:- type t_par ---> c_par(maybe(t_tag_or_id),maybe(t_hdr),t_blks).

:- pred r_par(t_par::out,t_tkns::in,t_tkns::out).

:- type t_pars = list(t_par).

:- pred r_pars(t_pars::out,t_tkns::in,t_tkns::out).

%%% T_BLK, T_BLKS, R_BLK AND R_BLKS

:- type t_blk --->
  c_blk_txt(t_txt_units);
  c_blk_blt(t_blks).

:- pred r_blk(t_blk::out,uint::in,t_tkns::in,t_tkns::out).

:- type t_blks = list(t_blk).

:- pred r_blks(t_blks::out,uint::in,t_tkns::in,t_tkns::out).

%%% T_TAG_OR_ID AND R_TAG_OR_ID

type t_tag_or_id --->
  c_tag_or_id_tag(t_tag);
  c_tag_or_id_id(t_id).

:- pred r_tag_or_id(t_tag_or_id::out,t_tkns::in,t_tkns::out).

%%% T_TAG AND R_TAG

type t_tag = str.

:- pred r_tag(t_tag::out,t_tkns::in,t_tkns::out).


%%% T_NAME AND R_NAME

t_name = str.

:- pred r_name(t_name::out,t_tkns::in,t_tkns::out).

%%% T_ID AND R_ID

type t_id ---> c_id(t_tag,t_name).

:- pred r_id(t_id::out,t_tkns::in,t_tkns::out).

%%% T_HDR AND R_HDR

type t_hdr = t_txt_units

:- pred r_hdr(t_hdr::out,t_tkns::in,t_tkns::out).

%%% T_TXT_UNIT, T_TXT_UNITS, R_TXT_UNIT AND R_TXT_UNITS

t_txt_unit --->
  c_txt_unit_wysiwyg(str).
  % TODO: c_txt_unit_emph
  % TODO: c_txt_unit_c_ref

t_txt_units = list(t_txt_unit).

:- pred r_txt_unit(t_txt_unit::out,t_tkns::in,t_tkns::out).

:- pred r_txt_units(t_txt_units::out,t_tkns::in,t_tkns::out).



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- import_module uint.


%% CONSTANT K_FORBIDDEN_STRINGS_IN_TAGS_NAMES

k_forbidden_strs_in_tags_and_names =
  ["\\", "[", "]", "(", ")", ":", ",", ";", "*"].


%% FUNCTION F_VALIDATE_CONF

%%% THE FUNCTION

f_validate_conf(CONF) = RES :-
  CONF = c_conf(
    c_xtra_ch_tags(  CH_TAGS),
    c_xtra_sec_tags(SEC_TAGS),
    c_xtra_app_tags(APP_TAGS),
    c_xtra_par_tags(PAR_TAGS),
    c_xtra_itm_tags(ITM_TAGS),
    c_xtra_dsp_tags(DSP_TAGS)
  ),
  (
    if not p_valid_tags(CH_TAGS) then
      RES = c_validate_conf_res_err("invalid chapter tags")
    else if not p_valid_tags(SEC_TAGS) then
      RES = c_validate_conf_res_err("invalid section tags")
    else if not p_valid_tags(APP_TAGS) then
      RES = c_validate_conf_res_err("invalid appendix tags")
    else if not p_valid_tags(PAR_TAGS) then
      RES = c_validate_conf_res_err("invalid paragraph tags")
    else if not p_valid_tags(ITM_TAGS) then
      RES = c_validate_conf_res_err("invalid item tags")
    else if not p_valid_tags(DSP_TAGS) then
      RES = c_validate_conf_res_err("invalid displayed tags")
    else
      RES = c_validate_conf_res_ok
  ).

%%% HELPER P_VALID_TAGS

:- pred p_valid_tags(strings::in) is semidet.
p_valid_tags([]).
p_valid_tags([TAG|TAGS]) :- p_valid_tag(TAG),p_valid_tags(TAGS).


%%% HELPER P_VALID_TAG

:- pred p_valid_tag(str::in) is semidet.
p_valid_tag(TAG) :- list.all_false(
  (pred(S::in) is semidet :- string.sub_string_search(TAG,S,_)),
  k_forbidden_strings_in_tags_names
).


%% DCG RULES

%%% HELPER R_C (READ NON-TAB NON-LINE-BREAK CHARACTER)

:- pred r_c(t_r,char,t_tkns,t_tkns).
:- mode r_c(in, in,  in,    out) is semidet.
:- mode r_c(in, out, in,    out) is semidet.

:- pred r_c(    char,t_tkns,t_tkns).
:- mode r_c(    in,  in,    out) is semidet.
:- mode r_c(    out, in,    out) is semidet.

r_c(c_r_nws,    C) --> [nmm.lexer.c_tkn_nws(_,C)].
r_c(c_r_sps,    C) --> [nmm.lexer.c_tkn_sp( _,C)].
r_c(c_r_esc,    C) --> [nmm.lexer.c_tkn_esc(_,C)].
r_c(c_r_nws_sps,C) --> [nmm.lexer.c_tkn_nws(_,C)].
r_c(c_r_nws_sps,C) --> [nmm.lexer.c_tkn_sp( _,C)].
r_c(c_r_any,    C) --> [nmm.lexer.c_tkn_nws(_,C)].
r_c(c_r_any,    C) --> [nmm.lexer.c_tkn_sp( _,C)].
r_c(c_r_any,    C) --> [nmm.lexer.c_tkn_esc(_,C)].

r_c(            C) --> r_c(c_r_any,C).

%%% R_STR

r_str(S) --> r_str_rec(str2chrs(S)).

:- pred r_str_rec(chars::in,t_tkns::in,t_tkns::out) is semidet.
r_str_rec([])       --> [].
r_str_rec([C | CS]) --> r_c(c_r_nws_sps,C),r_str_rec(CS).

%%% R

%%%% THE RULE

r(       S) --> r(c_r_any,   S).
r(R,     S) --> r(R,      [],S).
r(R,STPS,S) --> r_rec(R,STPS,CS), {S = chrs2str(CS), S \= ""}.

:- pred r_rec(t_r,t_stops,chars,t_tkns,t_tkns).
:- mode r_rec(in, in,     out,  in,    out) is det.
r_rec(        R,  STPS,   CS) -->
  r_stop(STPS) -> [],                  {CS = []};
  r_c(R,C)     -> r_rec(R,STPS,CS_TL), {CS = [C|CS_TL]};
                  [],                  {CS = []}.

%%%% HELPER R_STOP

% succeeds without consuming any tokens iff possible to consume any non-escaped
% string from first argument
:- pred r_stop(t_stops,      t_tkns, t_tkns).
:- mode r_stop(     in,      in,     out) is semidet.
r_stop(        [STP|STPS_TL],TKNS_IN,TKNS_OUT) :-
  (
    if r_str(STP,TKNS_IN,_) then
      true
    else
      r_stop(STPS_TL,TKNS_IN,TKNS_OUT)
  ),
  {TKNS_OUT = TKNS_IN}.

%%% R_LB AND R_LBS

r_lb --> [nmm.lexer.c_tkn_lb(_)].

r_lbs --> r_lb, (if r_lbs then [] else []).

%%% R_SP AND R_SPS

r_sp --> [nmm.lexer.c_tkn_sp(_,_)].

r_sps --> r_sp, (if r_sps then [] else []).

%%% R_TAB AND R_TABS

r_tab --> [nmm.lexer.c_tkn_tab(_)].

r_tabs --> r_tab, (if r_tabs then [] else []).

r_tabs(N) -->
  if {N = 0u} then [] else r_tab, r_tabs(N-1u).

%%% R_EOF

r_eof --> [nmm.lexer.c_tkn_eof].
