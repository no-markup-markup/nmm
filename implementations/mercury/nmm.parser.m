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
  term_to_xml,
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


%% TYPE T_VALID_TAGS

:- type t_valid_tags ---> c_valid_tags(
  fld_valid_tags_ch  :: strs,
  fld_valid_tags_sec :: strs,
  fld_valid_tags_app :: strs,
  fld_valid_tags_par :: strs,
  fld_valid_tags_itm :: strs,
  fld_valid_tags_dsp :: strs
).

%% FUNCTION F_ALL_VALID_TAGS

:- func f_all_valid_tags(t_valid_tags) = strs.


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


%% TYPE T_STOPS (= STRS) FOR NON-ESCAPED STRINGS BEFORE WHICH TO STOP READING

:- type t_stops == strs.


%% DCG RULES, CORRESPONDING AST TYPES, AND TERM_TO_XML INSTANCES

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

% DCG rules for reading non-empty parts of a line (excluding line breaks),
% optionally stopping right before certain strings

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

:- type t_doc ---> c_doc(
  fld_doc_preamble :: maybe(t_preamble),
  fld_doc_main     :: t_doc_main,
  fld_doc_refs     :: t_doc_refs
).

 %% :- pred r_doc(t_doc::out, t_valid_tags::in, t_tkns::in, t_tkns::out) is semidet.

%%% TODO: T_PREAMBLE AND R_PREAMBLE

:- type t_preamble == str.

 %% :- pred r_preamble(t_preamble::out, t_tkns::in, t_tkns::out) is semidet.

%%% T_DOC_MAIN, R_DOC_MAIN AND INSTANCE T_DOC_MAIN XMLABLE

:- type t_doc_main --->
  c_doc_main_pars(list(t_par));
  c_doc_main_blks(list(t_blk)).

:- instance term_to_xml.xmlable(t_doc_main).

:- pred r_doc_main(t_doc_main, t_valid_tags, t_tkns, t_tkns).
:- mode r_doc_main(out,        in,           in,     out) is semidet.

%%% TODO: T_DOC_REFS AND R_DOC_REFS

:- type t_doc_refs == list(t_blk).

 %% :- pred r_doc_refs(t_doc_refs, t_tkns::in, t_tkns::out).

%%% T_PAR, R_PAR, R_PARS AND INSTANCE T_PAR XMLABLE

:- type t_par ---> c_par(
  fld_par_tag_or_id :: maybe(t_tag_or_id),
  fld_par_hdr       :: maybe(t_hdr),
  fld_par_blks      :: list(t_blk)
).

:- instance term_to_xml.xmlable(t_par).

:- pred r_par(t_par::out, t_valid_tags::in, t_tkns::in, t_tkns::out) is semidet.

:- pred r_pars(list(t_par), t_valid_tags, t_tkns, t_tkns).
:- mode r_pars(out,         in,           in,     out) is semidet.

%%% T_BLK, T_BLKS, R_BLK AND R_BLKS AND INSTANCE T_BLK XMLABLE

:- type t_blk --->
  c_blk_txt(t_blk_txt);
  c_blk_blt(t_blk_blt).

:- type t_blks == list(t_blk).

:- instance term_to_xml.xmlable(t_blk).

:- pred r_blk(t_blk, uint, t_valid_tags, t_tkns, t_tkns).
:- mode r_blk(out,   in,   in,           in,     out) is semidet.

:- pred r_blks(t_blks, uint, t_valid_tags, t_tkns, t_tkns).
:- mode r_blks(out,    in,   in,           in,     out) is semidet.

%%% T_BLK_TXT AND R_BLK_TXT

:- type t_blk_txt == list(t_txt_unit).

:- pred r_blk_txt(t_blk_txt, uint, t_valid_tags, t_tkns, t_tkns).
:- mode r_blk_txt(out,       in,   in,           in,     out) is semidet.

%%% T_BLK_BLT AND R_BLK_BLT

:- type t_blk_blt == t_blks.

:- pred r_blk_blt(t_blk_blt, uint, t_valid_tags, t_tkns, t_tkns).
:- mode r_blk_blt(out,       in,   in,           in,     out) is semidet.

%%% T_HDR, R_HDR AND INSTANCE T_HDR XMLABLE

:- type t_hdr ---> c_hdr(list(t_txt_unit)).

:- instance term_to_xml.xmlable(t_hdr).

:- pred r_hdr(t_hdr::out, t_valid_tags::in, t_tkns::in, t_tkns::out) is semidet.

%%% T_TAG_OR_ID AND R_TAG_OR_ID

:- type t_tag_or_id --->
  c_tag_or_id_tag(t_tag);
  c_tag_or_id_id(t_id).

% doc:                           VALID_TAGS
:- pred r_tag_or_id(t_tag_or_id, strs,      t_tkns, t_tkns).
:- mode r_tag_or_id(out,         in,        in,     out) is semidet.

%%% T_TAG, R_TAG AND INSTANCE T_TAG XMLABLE

:- type t_tag ---> c_tag(str).

:- instance term_to_xml.xmlable(t_tag).

% doc:                    VALID_TAGS
:- pred r_tag(t_tag::out, strs::in,  t_tkns::in, t_tkns::out) is semidet.

%%% T_NAME, R_NAME AND INSTANCE T_TAG XMLABLE

:- type t_name ---> c_name(str).

:- instance term_to_xml.xmlable(t_name).

:- pred r_name(t_name::out, t_tkns::in, t_tkns::out) is semidet.

%%% T_ID, R_ID AND INSTANCE T_ID XMLABLE

:- type t_id ---> c_id(
  fld_id_tag  :: t_tag,
  fld_id_name :: t_name
).

:- instance term_to_xml.xmlable(t_id).

% doc:                  VALID_TAGS
:- pred r_id(t_id::out, strs::in,  t_tkns::in, t_tkns::out) is semidet.

%%% T_C_REF AND R_C_REF AND INSTANCE T_C_REF XMLABLE

:-type t_c_ref ---> c_c_ref(t_id).

:- instance term_to_xml.xmlable(t_c_ref).

% doc:                        VALID_TAGS
:- pred r_c_ref(t_c_ref::out, strs::in,  t_tkns::in, t_tkns::out) is semidet.

%%% T_TXT_UNIT, R_TXT_UNIT AND R_TXT_UNITS AND INSTANCE T_TXT_UNIT XMLABLE

:- type t_txt_unit --->
  c_txt_unit_wysiwyg(str);
  c_txt_unit_emph(str);
  c_txt_unit_c_ref(t_c_ref).

:- instance term_to_xml.xmlable(t_txt_unit).

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

%% FUNCTION F_ALL_VALID_TAGS

f_all_valid_tags(VALID_TAGS) = list.condense([
  fld_valid_tags_ch(VALID_TAGS),
  fld_valid_tags_sec(VALID_TAGS),
  fld_valid_tags_app(VALID_TAGS),
  fld_valid_tags_par(VALID_TAGS),
  fld_valid_tags_itm(VALID_TAGS),
  fld_valid_tags_dsp(VALID_TAGS)
]).

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


%% CONSTANT K_FORBIDDEN_STRS_IN_TAGS_NAMES

k_forbidden_strs_in_tags_names =
  ["\\", "[", "]", "(", ")", ":", ",", ";", "*"].


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

%%% R

%%%% THE RULE

r(R, STPS, S) --> r_rec(R,STPS,CS), {S = chrs2str(CS), S \= ""}.
r(R,       S) --> r(R,      [],S).
r(         S) --> r(c_r_any,   S).

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

%%% R_STR

r_str(S) --> if {S = ""} then {true} else r_str_rec(str2chrs(S)).

:- pred r_str_rec(chrs::in, t_tkns::in, t_tkns::out) is semidet.
r_str_rec(        [C|CS]) --> (
  r_c(c_r_nws_sps,C), r_str_rec(CS) -> [];
                                       r_c(c_r_nws_sps,C)
).

%%% R_SP

r_sp --> [nmm.lexer.c_tkn_sp(_,_)].

%%% R_LB

r_lb --> [nmm.lexer.c_tkn_lb(_)].

%%% R_TAB AND R_TABS

r_tab --> [nmm.lexer.c_tkn_tab(_)].

r_tabs(N) -->
  if {N = 0u} then [] else r_tab, r_tabs(N-1u).

%%% R_EOF

r_eof --> [nmm.lexer.c_tkn_eof].

%%% R_DOC_MAIN

r_doc_main(DOC_MAIN,VALID_TAGS) --> (
  r_blks(BLKS,0u,VALID_TAGS), r_eof -> {DOC_MAIN = c_doc_main_blks(BLKS)};
                                       {false}
).

:- instance term_to_xml.xmlable(t_doc_main) where [
  func(to_xml/1) is f_doc_main_to_xml
].

:- func
  f_doc_main_to_xml(t_doc_main::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
  is det.
f_doc_main_to_xml(c_doc_main_pars(PARS)) =
  term_to_xml.elem("c_doc_main_pars",[],list.map(f_par_to_xml,PARS)).
f_doc_main_to_xml(c_doc_main_blks(BLKS)) =
  term_to_xml.elem("c_doc_main_blks",[],list.map(f_blk_to_xml,BLKS)).


%%% R_PAR AND R_PARS AND T_PAR XMLABLE

r_par(c_par(MAYBE_TAG_OR_ID,MAYBE_HDR,BLKS),VALID_TAGS) -->
  {VALID_PAR_TAGS = fld_valid_tags_par(VALID_TAGS)},
  r_c('¶'),
  *(r_sp),
  r_maybe_tag_or_id(MAYBE_TAG_OR_ID,VALID_PAR_TAGS),
  r_lb,
  r_maybe_hdr(MAYBE_HDR,VALID_TAGS),
  +(r_lb),
  r_blks(BLKS,0u,VALID_TAGS).

r_pars(PARS,VALID_TAGS) -->
  r_par(PAR,VALID_TAGS),
  (
    +r_lb, r_pars(PARS_,VALID_TAGS) -> {PARS = [PAR]++PARS_};
                                       {PARS = [PAR]}
  ).

:- instance term_to_xml.xmlable(t_par) where [
  func(to_xml/1) is f_par_to_xml
].

:- func
  f_par_to_xml(t_par::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
  is det.
f_par_to_xml(c_par(maybe.yes(c_tag_or_id_tag(TAG)),maybe.yes(HDR),BLKS)) =
  term_to_xml.elem(
    "c_par",
    [],
    [f_tag_to_xml(TAG),f_hdr_to_xml(HDR)]++list.map(f_blk_to_xml,BLKS)
  ).
f_par_to_xml(c_par(maybe.yes(c_tag_or_id_tag(TAG)),maybe.no,BLKS)) =
  term_to_xml.elem(
    "c_par",
    [],
    [f_tag_to_xml(TAG)]++list.map(f_blk_to_xml,BLKS)
  ).
f_par_to_xml(c_par(maybe.yes(c_tag_or_id_id(ID)),maybe.yes(HDR),BLKS)) =
  term_to_xml.elem(
    "c_par",
    [],
    [f_id_to_xml(ID),f_hdr_to_xml(HDR)]++list.map(f_blk_to_xml,BLKS)
  ).
f_par_to_xml(c_par(maybe.yes(c_tag_or_id_id(ID)),maybe.no,BLKS)) =
  term_to_xml.elem(
    "c_par",
    [],
    [f_id_to_xml(ID)]++list.map(f_blk_to_xml,BLKS)
  ).
f_par_to_xml(c_par(maybe.no,maybe.yes(HDR),BLKS)) =
  term_to_xml.elem(
    "c_par",
    [],
    [f_hdr_to_xml(HDR)]++list.map(f_blk_to_xml,BLKS)
  ).
f_par_to_xml(c_par(maybe.no,maybe.no,BLKS)) =
  term_to_xml.elem(
    "c_par",
    [],
    list.map(f_blk_to_xml,BLKS)
  ).

%%% R_BLK AND R_BLKS AND INSTANCE T_BLK XMLABLE

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

:- instance term_to_xml.xmlable(t_blk) where [
  func(to_xml/1) is f_blk_to_xml
].

:- func
  f_blk_to_xml(t_blk::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
  is det.
f_blk_to_xml(c_blk_txt(UNITS)) =
  term_to_xml.elem(
    "c_blk_txt",
    [],
    list.map(f_txt_unit_to_xml,UNITS)
  ).
f_blk_to_xml(c_blk_blt(BLKS)) =
  term_to_xml.elem(
    "c_blk_blt",
    [],
    list.map(f_blk_to_xml,BLKS)
  ).

%%% R_BLK_TXT

r_blk_txt(US,LVL,VALID_TAGS) -->
  (
    if {LVL = 0u} then
      not r_str("CH"),
      not r_str("§"),
      not r_str("¶")
    else
      {true}
  ),
  r_blk_txt_lines(US,LVL,f_all_valid_tags(VALID_TAGS)).

:- pred r_blk_txt_line(list(t_txt_unit), strs, t_tkns, t_tkns).
:- mode r_blk_txt_line(out,              in,   in,     out) is semidet.
r_blk_txt_line(        UNITS,            VALID_TAGS) -->
  r_txt_units(UNITS,VALID_TAGS), r_lb.

:- pred r_blk_txt_lines(list(t_txt_unit), uint, strs, t_tkns, t_tkns).
:- mode r_blk_txt_lines(out,                in, in,   in,     out) is semidet.
r_blk_txt_lines(        UNITS,            LVL,  VALID_TAGS) -->
  r_blk_txt_line(UNITS_,VALID_TAGS),
  (
    r_tabs(LVL), r_blk_txt_lines(UNITS__,LVL,VALID_TAGS)
      -> {UNITS = UNITS_ ++ UNITS__};
         {UNITS = UNITS_}
  ).

%%% R_BLK_BLT

r_blk_blt(BLKS,LVL,VALID_TAGS) -->
  r_str("-"), r_tab, r_blks(BLKS,LVL+1u,VALID_TAGS).

%%% R_HDR

r_hdr(c_hdr(UNITS),VALID_TAGS) --> r_blk_txt(UNITS,0u,VALID_TAGS).

:- instance term_to_xml.xmlable(t_hdr) where [
  func(to_xml/1) is f_hdr_to_xml
].

:- func
  f_hdr_to_xml(t_hdr::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
  is det.

f_hdr_to_xml(c_hdr(UNITS)) = term_to_xml.elem(
  "c_hdr",
  [],
  list.map(f_txt_unit_to_xml,UNITS)
).

%%% HELPER R_MAYBE_HDR

:- pred r_maybe_hdr(maybe(t_hdr), t_valid_tags, t_tkns, t_tkns).
:- mode r_maybe_hdr(out,          in,           in,     out) is det.
r_maybe_hdr(        RES,          VALID_TAGS) --> (
  r_hdr(HDR,VALID_TAGS)  -> {RES = maybe.yes(HDR)};
                            {RES = maybe.no}
).

%%% R_TAG_OR_ID

r_tag_or_id(TAG_OR_ID,VALID_TAGS) --> (
  r_id(ID,VALID_TAGS)   -> {TAG_OR_ID = c_tag_or_id_id(ID)};
  r_tag(TAG,VALID_TAGS) -> {TAG_OR_ID = c_tag_or_id_tag(TAG)};
                           {false}
).

%%% HELPER R_MAYBE_TAG_OR_ID

% doc:                                        VALID_TAGS
:- pred r_maybe_tag_or_id(maybe(t_tag_or_id), strs,      t_tkns, t_tkns).
:- mode r_maybe_tag_or_id(out,                in,        in,     out) is det.
r_maybe_tag_or_id(        RES,                VALID_TAGS) --> (
  r_tag_or_id(TAG_OR_ID,VALID_TAGS) -> {RES = maybe.yes(TAG_OR_ID)};
                                       {RES = maybe.no}
).

%%% R_TAG AND INSTANCE T_TAG XMLABLE

r_tag(c_tag(S),VALID_TAGS) -->
  r(c_r_nws,k_forbidden_strs_in_tags_names,S),
  {list.member(S,VALID_TAGS)}.

:- instance term_to_xml.xmlable(t_tag) where [
  func(to_xml/1) is f_tag_to_xml
].

:- func
  f_tag_to_xml(t_tag::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
  is det.

f_tag_to_xml(c_tag(S)) = term_to_xml.elem("c_tag",[],[term_to_xml.data(S)]).

%%% R_NAME AND INSTANCE T_NAME XMLABLE

r_name(c_name(S)) --> r(c_r_nws,k_forbidden_strs_in_tags_names,S).

:- instance term_to_xml.xmlable(t_name) where [
  func(to_xml/1) is f_name_to_xml
].

:- func
  f_name_to_xml(t_name::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
  is det.

f_name_to_xml(c_name(S)) = term_to_xml.elem("c_name",[],[term_to_xml.data(S)]).

%%% R_ID AND INSTANCE T_ID XMLABLE

r_id(c_id(TAG,NAME),VALID_TAGS) -->
  r_tag(TAG,VALID_TAGS), r_c(':'), r_name(NAME).

:- instance term_to_xml.xmlable(t_id) where [
  func(to_xml/1) is f_id_to_xml
].

:- func
  f_id_to_xml(t_id::in) = (term_to_xml.xml::out(term_to_xml.xml_doc)) is det.
f_id_to_xml(c_id(TAG,NAME)) = term_to_xml.elem(
  "c_id",
  [],
  [
    f_tag_to_xml(TAG),
    f_name_to_xml(NAME)
  ]
).

%%% R_C_REF AND INSTANCE T_C_REF XMLABLE

r_c_ref(c_c_ref(ID),VALID_TAGS) -->
  r_str("["),
  r_id(ID,VALID_TAGS),
  r_str("]").

:- instance term_to_xml.xmlable(t_c_ref) where [
  func(to_xml/1) is f_c_ref_to_xml
].

:- func
  f_c_ref_to_xml(t_c_ref::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
  is det.
f_c_ref_to_xml(c_c_ref(ID)) = term_to_xml.elem("c_c_ref",[],[f_id_to_xml(ID)]).

%%% R_TXT_UNIT AND R_TXT_UNITS AND INSTANCE T_TXT_UNIT XMLABLE

r_txt_unit(U,VALID_TAGS) -->
  r_c_ref(CR,VALID_TAGS)            -> {U = c_txt_unit_c_ref(CR)};
  r_txt_unit_wysiwyg(S,VALID_TAGS)  -> {U = c_txt_unit_wysiwyg(S)};
                                       {false}.

:- pred r_txt_unit_wysiwyg(str, strs, t_tkns, t_tkns).
:- mode r_txt_unit_wysiwyg(out, in,   in,     out) is semidet.
r_txt_unit_wysiwyg(        S,   VALID_TAGS) -->
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

:- instance term_to_xml.xmlable(t_txt_unit) where [
  func(to_xml/1) is f_txt_unit_to_xml
].

:- func
  f_txt_unit_to_xml(t_txt_unit::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
  is det.
f_txt_unit_to_xml(c_txt_unit_c_ref(C_REF)) =
  term_to_xml.elem("c_txt_unit_c_ref",[],[f_c_ref_to_xml(C_REF)]).
f_txt_unit_to_xml(c_txt_unit_wysiwyg(STR)) =
  term_to_xml.elem("c_txt_unit_wysiwyg",[],[term_to_xml.data(STR)]).
f_txt_unit_to_xml(c_txt_unit_emph(STR)) =
  term_to_xml.elem("c_txt_unit_emph",[],[term_to_xml.data(STR)]).
