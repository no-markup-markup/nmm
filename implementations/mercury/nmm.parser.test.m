:- module nmm.parser.test.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% USE MODULES

:- use_module io.


%% MAIN

:- pred main(io.io::di,io.io::uo) is det.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION 

:- implementation.


%% USE MODULES

:- use_module exception, nmm.parser, nmm.lexer.

%% FUNCTION F_STR2TKNS

:- func f_str2tkns(str) = t_tkns.
f_str2tkns(S) = TKNS :-
  RES = nmm.lexer.f_tknize(str2chrs(S)),
  (
    RES = nmm.lexer.c_tknize_res_err(ERR)  -> exception.throw(ERR);
    RES = nmm.lexer.c_tknize_res_ok(TKNS_) -> (
      if list.remove_suffix(TKNS_,[nmm.lexer.c_tkn_eof],TKNS__) then
        TKNS = TKNS__
      else
        exception.throw("no eof token?")
    );
                                              exception.throw("wtf")
  ).


%% TEST PREDICATES

%%% TEST_R_1

:- pred test_r_1 is det.
test_r_1 :-
  if (
      nmm.parser.r(S,f_str2tkns("hej hej"),[]),
      S = "hej hej"
  ) then
    true
  else
    exception.throw("test_r_1").

%%% TEST_R_2

:- pred test_r_2 is det.
test_r_2 :-
  if nmm.parser.r(c_r_nws,"hej",f_str2tkns("hej hej"),f_str2tkns(" hej")) then
    true
  else
    exception.throw("test_r_2").

%%% TEST_R_3

:- pred test_r_3 is det.
test_r_3 :-
  if (
    nmm.parser.r(
      c_r_nws_sps,
      ["xyz","STOP"],
      "ab",
      f_str2tkns("abSTOP"),
      f_str2tkns("STOP")
    )
  ) then
    true
  else
    exception.throw("test_r_3").

%%% TEST_R_3

:- pred test_r_4 is det.
test_r_4 :-
  if (
    nmm.parser.r(
      c_r_any,
      "[test\\]\\¶",
      f_str2tkns("\\[test\\]¶"),
      []
    )
  ) then
    true
  else
    exception.throw("test_r_4").

%%% TEST_R_STR_1

:- pred test_r_str_1 is det.
test_r_str_1 :-
  if nmm.parser.r_str("",f_str2tkns("ab"),f_str2tkns("ab")) then
    true
  else
    exception.throw("test_str_1").

%%% TEST_R_STR_2

:- pred test_r_str_2 is det.
test_r_str_2 :-
  if nmm.parser.r_str("ab",f_str2tkns("abcd"),f_str2tkns("cd")) then
    true
  else
    exception.throw("test_str_2").

%%% TEST_R_TAB_1

:- pred test_r_tab_1 is det.
test_r_tab_1 :-
  if nmm.parser.r_tab(f_str2tkns("\t"),[]) then
    true
  else
    exception.throw("test_tab_1").

%%% TEST_R_TAB_2

:- pred test_r_tab_2 is det.
test_r_tab_2 :-
  if nmm.parser.r_tab(f_str2tkns("\t\t"),[nmm.lexer.c_tkn_tab(1u)]) then
    true
  else
    exception.throw("test_tab_2").

%%% TEST_R_TAB_3

:- pred test_r_tab_3 is det.
test_r_tab_3 :-
  if nmm.parser.r_tab(f_str2tkns("\tHEJ"),f_str2tkns("HEJ")) then
    true
  else
    exception.throw("test_tab_3").

%%% TEST_R_TABS_1

:- pred test_r_tabs_1 is det.
test_r_tabs_1 :-
  if nmm.parser.r_tabs(1u,f_str2tkns("\t"),[]) then
    true
  else
    exception.throw("test_tabs_2").

%%% TEST_R_TABS_2

:- pred test_r_tabs_2 is det.
test_r_tabs_2 :-
  if nmm.parser.r_tabs(2u,f_str2tkns("\t\t"),[]) then
    true
  else
    exception.throw("test_tabs_2").

%%% TEST_R_TABS_3

:- pred test_r_tabs_3 is det.
test_r_tabs_3 :-
  if nmm.parser.r_tabs(2u,f_str2tkns("\t\thej"),f_str2tkns("hej")) then
    true
  else
    exception.throw("test_tabs_3").


%% MAIN

main(!IO) :-
  test_r_1,
  test_r_2,
  test_r_3,
  test_r_str_1,
  test_r_str_2,
  test_r_tab_1,
  test_r_tab_2,
  test_r_tab_3,
  test_r_tabs_1,
  test_r_tabs_2,
  test_r_tabs_3.
