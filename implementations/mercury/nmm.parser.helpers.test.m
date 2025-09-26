:- module nmm.parser.helpers.test.

% INTERFACE

:- interface.

:- use_module io.

:- pred p(io.io::di, io.io::uo) is det.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- import_module nmm.parser.test, nmm.parser.helpers.


%% P_TEST_R_1

:- pred p_test_r_1(io.io::di, io.io::uo) is det.
p_test_r_1(!IO) :- (
  if r(S,f_str2tkns("hej hej"),[]), S = "hej hej" then
    true
  else
    io.write_string("parser helpers test p_test_r_1 failed\n",!IO)
).


%% P_TEST_R_2

:- pred p_test_r_2(io.io::di, io.io::uo) is det.
p_test_r_2(!IO) :- (
  if r(ce_r_nws,"hej",f_str2tkns("hej hej"),f_str2tkns(" hej")) then
    true
  else
    io.write_string("parser helpers test p_test_r_2 failed\n",!IO)
).


%% P_TEST_R_3

:- pred p_test_r_3(io.io::di, io.io::uo) is det.
p_test_r_3(!IO) :- (
  if (
    r(ce_r_nws_sps,["xyz","STOP"],"ab",f_str2tkns("abSTOP"),f_str2tkns("STOP"))
  ) then
    true
  else
    io.write_string("parser helpers test p_test_r_3 failed\n",!IO)
).


%% P_TEST_R_4

:- pred p_test_r_4(io.io::di, io.io::uo) is det.
p_test_r_4(!IO) :- (
  if r(ce_r_any,"[test\\]¶",f_str2tkns("\\[test\\]\\¶"),[]) then
    true
  else
    io.write_string("parser helpers test p_test_r_4 failed\n",!IO)
).


%% P_TEST_R_STR_1

:- pred p_test_r_str_1(io.io::di, io.io::uo) is det.
p_test_r_str_1(!IO) :- (
  if r_str("",f_str2tkns("ab"),f_str2tkns("ab")) then
    true
  else
    io.write_string("parser helpers test p_test_r_str_1 failed\n",!IO)
).


%% P_TEST_R_STR_2

:- pred p_test_r_str_2(io.io::di, io.io::uo) is det.
p_test_r_str_2(!IO) :- (
  if r_str("ab",f_str2tkns("abcd"),f_str2tkns("cd")) then
    true
  else
    io.write_string("parser helpers test p_test_r_str_2 failed\n",!IO)
).


%% P_TEST_R_TAB_1

:- pred p_test_r_tab_1(io.io::di, io.io::uo) is det.
p_test_r_tab_1(!IO) :- (
  if r_tab(f_str2tkns("\t"),[]) then
    true
  else
    io.write_string("parser helpers test p_test_r_tab_1 failed\n",!IO)
).


%% P_TEST_R_TAB_2

:- pred p_test_r_tab_2(io.io::di, io.io::uo) is det.
p_test_r_tab_2(!IO) :- (
  if r_tab(f_str2tkns("\t\t"),[nmm.lexer.c_tkn_tab(1u)]) then
    true
  else
    io.write_string("parser helpers test p_test_r_tab_2 failed\n",!IO)
).


%% P_TEST_R_TAB_3

:- pred p_test_r_tab_3(io.io::di, io.io::uo) is det.
p_test_r_tab_3(!IO) :- (
  if r_tab(f_str2tkns("\tHEJ"),f_str2tkns("HEJ")) then
    true
  else
    io.write_string("parser helpers test p_test_r_tab_3 failed\n",!IO)
).


%% P_TEST_R_TABS_1

:- pred p_test_r_tabs_1(io.io::di, io.io::uo) is det.
p_test_r_tabs_1(!IO) :- (
  if r_tabs(1u,f_str2tkns("\t"),[]) then
    true
  else
    io.write_string("parser helpers test p_test_r_tabs_1 failed\n",!IO)
).


%% P_TEST_R_TABS_2

:- pred p_test_r_tabs_2(io.io::di, io.io::uo) is det.
p_test_r_tabs_2(!IO) :- (
  if r_tabs(2u,f_str2tkns("\t\t"),[]) then
    true
  else
    io.write_string("parser helpers test p_test_r_tabs_2 failed\n",!IO)
).


%% P_TEST_R_TABS_3

:- pred p_test_r_tabs_3(io.io::di, io.io::uo) is det.
p_test_r_tabs_3(!IO) :- (
  if r_tabs(2u,f_str2tkns("\t\thej"),f_str2tkns("hej")) then
    true
  else
    io.write_string("parser helpers test p_test_r_tabs_3 failed\n",!IO)
).


%% P_TEST_R_TABS_4

:- pred p_test_r_tabs_4(io.io::di, io.io::uo) is det.
p_test_r_tabs_4(!IO) :- (
  if r_tabs(0u,f_str2tkns("hej"),f_str2tkns("hej")) then
    true
  else
    io.write_string("parser helpers test p_test_r_tabs_4 failed\n",!IO)
).


%% P_TEST_R_TABS_5

:- pred p_test_r_tabs_5(io.io::di, io.io::uo) is det.
p_test_r_tabs_5(!IO) :- (
  if r_tabs(2u,f_str2tkns("\t\t\t"),f_str2tkns("\t")) then
    true
  else
    io.write_string("parser helpers test p_test_r_tabs_5 failed\n",!IO)
).


%% P

p(!IO) :-
  p_test_r_1(!IO),
  p_test_r_2(!IO),
  p_test_r_3(!IO),
  p_test_r_4(!IO),
  p_test_r_str_1(!IO),
  p_test_r_str_2(!IO),
  p_test_r_tab_1(!IO),
  p_test_r_tab_2(!IO),
  p_test_r_tab_3(!IO),
  p_test_r_tabs_1(!IO),
  p_test_r_tabs_2(!IO),
  p_test_r_tabs_3(!IO),
  p_test_r_tabs_4(!IO),
  p_test_r_tabs_5(!IO).
