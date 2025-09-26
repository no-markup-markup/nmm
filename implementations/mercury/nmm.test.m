:- module nmm.test.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module io.


%% P

:- pred p(io.io::di,io.io::uo) is det.



% IMPLEMENTATION

:- implementation.

:- use_module
  nmm.lexer, nmm.lexer.test,
  nmm.parser, nmm.parser.test
  .

p(!IO) :-
  nmm.lexer.test.p(!IO)
  ,
  nmm.parser.test.p(!IO)
  .
