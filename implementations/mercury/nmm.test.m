:- module nmm.test.

% INTERFACE

:- interface.


%% MODULE IMPORTS

:- use_module io.


%% MAIN

:- pred main(io.io::di,io.io::uo) is det.



% IMPLEMENTATION

:- implementation.

:- use_module
  nmm.lexer, nmm.lexer.test
  ,
  nmm.parser, nmm.parser.test
  .

main(!IO) :-
  nmm.lexer.test.p_test(!IO)
  ,
  nmm.parser.test.p_test(!IO)
  .
