:- module nmm.parser.helpers.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% SUBMODULES

:- include_module nmm.parser.helpers.test.

%% MODULE IMPORTS

:- use_module nmm, nmm.lexer.


%% UNION TYPE TU_R FOR WHAT PARTS OF A LINE TO READ

:- type tu_r --->
  cu_r_nws;     % read only non-whitespace tokens
  cu_r_sps;     % read only space tokens
  cu_r_esc;     % read only escaped characters
  cu_r_nws_sps; % read only non-escaped tokens
  cu_r_any.     % read any of the above


%% ALIAS TYPE TA_STRS_TO_STOP_BEFORE (= STRS)

:- type ta_strs_to_stop_before == strs.


%% RULE R_C FOR READING A SINGLE NON-TAB NON-LINE-BREAK CHARACTHER

:- pred r_c(tu_r, chr, ts_tkns, ts_tkns).
:- mode r_c(in,   in,  in,      out) is semidet.
:- mode r_c(in,   out, in,      out) is semidet.

:- pred r_c(      chr, ts_tkns, ts_tkns).
:- mode r_c(      in,  in,      out) is semidet.
:- mode r_c(      out, in,      out) is semidet.


%% RULE R_STR FOR CONSUMING NON-ESCAPED STRING TERMINALS

:- pred r_str(str::in, ts_tkns::in, ts_tkns::out) is semidet.


%% RULE R FOR READING NON-EMPTY PARTS OF A LINE (EXCLUDING LINE BREAKS)

:- pred r(tu_r, ta_strs_to_stop_before, str, ts_tkns, ts_tkns).
:- mode r(in,   in,                     in,  in,      out) is semidet.
:- mode r(in,   in,                     out, in,      out) is semidet.

:- pred r(tu_r,                         str, ts_tkns, ts_tkns).
:- mode r(in,                           in,      in,  out) is semidet.
:- mode r(in,                           out,     in,  out) is semidet.

:- pred r(                              str, ts_tkns, ts_tkns).
:- mode r(                              in,      in,  out) is semidet.
:- mode r(                              out,     in,  out) is semidet.


%% RULE R_SP FOR CONSUMING A SINLGE SPACE CHARACTER

:- pred r_sp(ts_tkns::in, ts_tkns::out) is semidet.


%% RULE R_LB FOR CONSUMING A SINGLE LINE BREAK

:- pred r_lb(ts_tkns::in, ts_tkns::out) is semidet.


%% RULE R_TAB FOR CONSUMING A SINGLE TAB CHARACTER

:- pred r_tab(ts_tkns::in, ts_tkns::out) is semidet.


%% RULE R_TABS FOR CONSUMING SPECIFIED NUMBER OF TABS

% doc:         NO_OF_TABS
:- pred r_tabs(uint::in,  ts_tkns::in, ts_tkns::out) is semidet.


%% RULE R_EOF FOR CONSUMING THE END-OF-FILE TOKEN

:- pred r_eof(ts_tkns::in, ts_tkns::out) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% R_C

r_c(cu_r_nws,     C) --> [nmm.lexer.cu_tkn_nws(_,C)].
r_c(cu_r_sps,     C) --> [nmm.lexer.cu_tkn_sp( _,C)].
r_c(cu_r_esc,     C) --> [nmm.lexer.cu_tkn_esc(_,C)].
r_c(cu_r_nws_sps, C) --> [nmm.lexer.cu_tkn_nws(_,C)].
r_c(cu_r_nws_sps, C) --> [nmm.lexer.cu_tkn_sp( _,C)].
r_c(cu_r_any,     C) --> [nmm.lexer.cu_tkn_nws(_,C)].
r_c(cu_r_any,     C) --> [nmm.lexer.cu_tkn_sp( _,C)].
r_c(cu_r_any,     C) --> [nmm.lexer.cu_tkn_esc(_,C)].

r_c(              C) --> r_c(cu_r_any,C).


%% R_STR

r_str(S) --> r_str_chrs(str2chrs(S)).

:- pred r_str_chrs(chrs::in, ts_tkns::in, ts_tkns::out) is semidet.
r_str_chrs(        [])     --> {true}.
r_str_chrs(        [C|CS]) --> r_c(cu_r_nws_sps,C), r_str_chrs(CS).


%% R

%%% HELPER R_STOP

% succeeds without consuming any tokens iff possible to consume any non-escaped
% string from first argument
:- pred r_stop(ta_strs_to_stop_before, ts_tkns,  ts_tkns).
:- mode r_stop(in,                     in,       out) is semidet.
r_stop(        [STP|STPS_TL],          TKNS_IN,  TKNS_OUT) :-
  (
    if r_str(STP,TKNS_IN,_) then
      true
    else
      r_stop(STPS_TL,TKNS_IN,TKNS_OUT)
  ),
  TKNS_OUT = TKNS_IN.

%%% THE RULE

r(R, STPS, S) --> r_rec(R,STPS,CS), {S = chrs2str(CS), S \= ""}.
r(R,       S) --> r(R,       [],S).
r(         S) --> r(cu_r_any,   S).

:- pred r_rec(tu_r, ta_strs_to_stop_before, chrs, ts_tkns, ts_tkns).
:- mode r_rec(in,   in,                     out,  in,      out) is det.
r_rec(        R,    STPS,                   CS) -->
  r_stop(STPS) -> [],                  {CS = []};
  r_c(R,C)     -> r_rec(R,STPS,CS_TL), {CS = [C|CS_TL]};
                  [],                  {CS = []}.


%% R_SP

r_sp --> [nmm.lexer.cu_tkn_sp(_,_)].


%% R_LB

r_lb --> [nmm.lexer.cu_tkn_lb(_)].


%% R_TAB

r_tab --> [nmm.lexer.cu_tkn_tab(_)].


%% R_TABS

r_tabs(N) --> if {N = 0u} then [] else r_tab, r_tabs(N-1u).


%% R_EOF

r_eof --> [nmm.lexer.cu_tkn_eof].
