:- module nmm.parser_helpers.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.

%% MODULE IMPORTS

:- use_module
  term_to_xml
  ,
  nmm, nmm.lexer
  .


%% TYPE ABBREVIATIONS T_TKN AND T_TKNS

:- type t_tkn  == nmm.lexer.t_tkn.
:- type t_tkns == nmm.lexer.t_tkns.


%% ENUM TYPE TE_R FOR WHAT PARTS OF A LINE TO READ

:- type te_r --->
  ce_r_nws;     % read only non-whitespace tokens
  ce_r_sps;     % read only space tokens
  ce_r_esc;     % read only escaped characters
  ce_r_nws_sps; % read only non-escaped tokens
  ce_r_any.     % read any of the above


%% ALIAS TYPE TA_STRS_TO_STOP_BEFORE (= STRS)

:- type ta_strs_to_stop_before == strs.


%% OPERATORS ?, * AND + (INCLUDING HIGER-ORDER VERSIONS)

:- pred ?(pred(T,   TKNS, TKNS),           maybe(T), TKNS,  TKNS).
:- mode ?(pred(out, in,   out) is semidet, out,      in,    out) is det.
:- pred ?(pred(     TKNS, TKNS),                     TKNS,  TKNS).
:- mode ?(pred(     in,   out) is semidet,           in,    out) is det.

:- pred *(pred(T,   TKNS, TKNS),           list(T),  TKNS,  TKNS).
:- mode *(pred(out, in,   out) is semidet, out,      in,    out) is det.
:- pred *(pred(     TKNS, TKNS),                     TKNS,  TKNS).
:- mode *(pred(     in,   out) is semidet,           in,    out) is det.

:- pred +(pred(T,   TKNS, TKNS),           list(T),  TKNS,  TKNS).
:- mode +(pred(out, in,   out) is semidet, out,      in,    out) is semidet.
:- pred +(pred(     TKNS, TKNS),                     TKNS,  TKNS).
:- mode +(pred(     in,   out) is semidet,           in,    out) is semidet.


%% RULE R_C FOR READING A SINGLE NON-TAB NON-LINE-BREAK CHARACTHER

:- pred r_c(te_r, chr, t_tkns, t_tkns).
:- mode r_c(in,   in,  in,     out) is semidet.
:- mode r_c(in,   out, in,     out) is semidet.

:- pred r_c(      chr, t_tkns, t_tkns).
:- mode r_c(      in,  in,     out) is semidet.
:- mode r_c(      out, in,     out) is semidet.


%% RULE R_STR FOR CONSUMING NON-ESCAPED STRING TERMINALS

:- pred r_str(str::in, t_tkns::in, t_tkns::out) is semidet.


%% RULE R FOR READING NON-EMPTY PARTS OF A LINE (EXCLUDING LINE BREAKS)

:- pred r(te_r, ta_strs_to_stop_before, str, t_tkns, t_tkns).
:- mode r(in,   in,                     in,  in,     out) is semidet.
:- mode r(in,   in,                     out, in,     out) is semidet.

:- pred r(te_r,                         str, t_tkns, t_tkns).
:- mode r(in,                           in,      in, out) is semidet.
:- mode r(in,                           out,     in, out) is semidet.

:- pred r(                              str, t_tkns, t_tkns).
:- mode r(                              in,      in, out) is semidet.
:- mode r(                              out,     in, out) is semidet.


%% RULE R_SP FOR CONSUMING A SINLGE SPACE CHARACTER

:- pred r_sp(t_tkns::in, t_tkns::out) is semidet.


%% RULE R_LB FOR CONSUMING A SINGLE LINE BREAK

:- pred r_lb(t_tkns::in, t_tkns::out) is semidet.


%% RULE R_TAB FOR CONSUMING A SINGLE TAB CHARACTER

:- pred r_tab(t_tkns::in, t_tkns::out) is semidet.


%% RULE R_TABS FOR CONSUMING SPECIFIED NUMBER OF TABS

% doc:         NO_OF_TABS
:- pred r_tabs(uint::in,  t_tkns::in, t_tkns::out) is semidet.


%% RULE R_EOF FOR CONSUMING THE END-OF-FILE TOKEN

:- pred r_eof(t_tkns::in, t_tkns::out) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% ?, * AND +

?(X,P) --> (
  P(X_) -> {X = maybe.yes(X_)};
           {X = maybe.no}
).
?(P) --> (
  P -> {true};
       {true}
).

*(XS,P) --> (
  P(X), *(XS_,P) -> {XS = [X|XS_]};
                    {XS = []}
).
*(P) --> (
  P, *(P) -> {true};
             {true}
).

+(XS,P) --> (
  P(X), +(XS_,P) -> {XS = [X|XS_]};
                    P(X), {XS = [X]}
).
+(P) --> (
  P, +(P) -> {true};
             P
).


%% R_C

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


%% R

%%% HELPER R_STOP

% succeeds without consuming any tokens iff possible to consume any non-escaped
% string from first argument
:- pred r_stop(ta_strs_to_stop_before, t_tkns,  t_tkns).
:- mode r_stop(in,                     in,      out) is semidet.
r_stop(        [STP|STPS_TL],          TKNS_IN, TKNS_OUT) :-
  (
    if r_str(STP,TKNS_IN,_) then
      true
    else
      r_stop(STPS_TL,TKNS_IN,TKNS_OUT)
  ),
  TKNS_OUT = TKNS_IN.

%%% THE RULE

r(R, STPS, S) --> r_rec(R,STPS,CS), {S = chrs2str(CS), S \= ""}.
r(R,       S) --> r(R,      [],S).
r(         S) --> r(c_r_any,   S).

:- pred r_rec(t_r, t_stops, chrs, t_tkns, t_tkns).
:- mode r_rec(in,  in,      out,  in,     out) is det.
r_rec(        R,   STPS,    CS) -->
  r_stop(STPS) -> [],                  {CS = []};
  r_c(R,C)     -> r_rec(R,STPS,CS_TL), {CS = [C|CS_TL]};
                  [],                  {CS = []}.


%% R_SP

r_sp --> [nmm.lexer.c_tkn_sp(_,_)].


%% R_LB

r_lb --> [nmm.lexer.c_tkn_lb(_)].


%% R_TAB

r_tab --> [nmm.lexer.c_tkn_tab(_)].


%% R_TABS

r_tabs(N) --> if {N = 0u} then [] else r_tab, r_tabs(N-1u).


%% R_EOF

r_eof --> [nmm.lexer.c_tkn_eof].
