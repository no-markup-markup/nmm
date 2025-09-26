:- module nmm.parser.test.

% INTERFACE

:- interface.

:- use_module io.

:- func f_str2tkns(str) = t_tkns.

:- pred p(io.io::di, io.io::uo) is det.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module
  exception
  ,
  nmm.parser.operators, nmm.parser.operators.test
  ,
  nmm.parser.helpers, nmm.parser.helpers.test
  .


%% FUNCTION F_STR2TKNS

f_str2tkns(S) = TKNS :- (
  RES = nmm.lexer.f_tknize(str2chrs(S)),
  (
    (
      RES = nmm.lexer.c_tknize_res_err(ERR),
      exception.throw(ERR)
    );
    (
      RES = nmm.lexer.c_tknize_res_ok(TKNS_),
      (
        if list.remove_suffix(TKNS_,[nmm.lexer.c_tkn_eof],TKNS__) then
          TKNS = TKNS__
        else
          exception.throw("no eof token?")
      )
    )
  )
).


%% P

p(!IO) :-
  io.write_string("TODO: parser tests\n",!IO)
  ,
  nmm.parser.helpers.test.p(!IO)
  ,
  nmm.parser.operators.test.p(!IO)
  .
