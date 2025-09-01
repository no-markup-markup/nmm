:- module nmm.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% SUBMODULES

:- include_module
  nmm.cli
  ,
  nmm.lexer
  ,
  nmm.parser
  ,
  nmm.test
  .


%% MODULE IMPORTS

:- use_module
  char
  ,
  maybe
  .

:- import_module
  list
  ,
  string
  .


%% TYPE ABBREVIATIONS AND FUNCTION ABBREVIATIONS

:- type chr      == char.char.
:- type chrs     == list(char.char).
:- type str      == string.
:- type strs     == list(str).
:- type maybe(T) == maybe.maybe(T).

:- func uint2int(uint)   = int.
:- func int2str(int)     = str.
:- func uint2str(uint)   = str.
:- func chr2str(chr)     = str.
:- func chrs2str(chrs)   = str.
:- func str2chrs(string) = chrs.



% IMPLEMENTATION

:- implementation.

:- use_module uint.

uint2int(N)  = uint.cast_to_int(N).
int2str(N)   = string.from_int(N).
uint2str(N)  = int2str(uint2int(N)).
chr2str(C)   = string.from_char(C).
chrs2str(CS) = string.from_char_list(CS).
str2chrs(S)  = string.to_char_list(S).
