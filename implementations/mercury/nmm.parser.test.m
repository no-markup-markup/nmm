:- module nmm.parser.test.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% USE MODULES

:- use_module io.


%% P_TEST

:- pred p_test(io.io::di,io.io::uo) is det.



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


%% PREDICATES P_EQ_UP_TO_LINE_NO

:- pred p_tkn_eq_up_to_line_no( t_tkn::in,  t_tkn::in) is semidet.
:- pred p_tkns_eq_up_to_line_no(t_tkns::in, t_tkns::in) is semidet.

p_tkn_eq_up_to_line_no(nmm.lexer.c_tkn_nws(_,C), nmm.lexer.c_tkn_nws(_,C)).
p_tkn_eq_up_to_line_no(nmm.lexer.c_tkn_sp( _,C), nmm.lexer.c_tkn_sp( _,C)).
p_tkn_eq_up_to_line_no(nmm.lexer.c_tkn_esc(_,C), nmm.lexer.c_tkn_esc(_,C)).
p_tkn_eq_up_to_line_no(nmm.lexer.c_tkn_nws(_,C), nmm.lexer.c_tkn_nws(_,C)).
p_tkn_eq_up_to_line_no(nmm.lexer.c_tkn_tab(_),   nmm.lexer.c_tkn_tab(_)).
p_tkn_eq_up_to_line_no(nmm.lexer.c_tkn_lb( _),   nmm.lexer.c_tkn_lb( _)).
p_tkn_eq_up_to_line_no(nmm.lexer.c_tkn_eof,      nmm.lexer.c_tkn_eof).

p_tkns_eq_up_to_line_no(TKNS_1,TKNS_2) :-
  list.same_length(TKNS_1,TKNS_2),
  list.all_true_corresponding(p_tkn_eq_up_to_line_no,TKNS_1,TKNS_2).



%% TEST PREDICATES

%%% P_TEST_R_1

:- pred p_test_r_1 is det.
p_test_r_1 :-
  if (
      nmm.parser.r(S,f_str2tkns("hej hej"),[]),
      S = "hej hej"
  ) then
    true
  else
    exception.throw("test_r_1").

%%% P_TEST_R_2

:- pred p_test_r_2 is det.
p_test_r_2 :-
  if nmm.parser.r(c_r_nws,"hej",f_str2tkns("hej hej"),f_str2tkns(" hej")) then
    true
  else
    exception.throw("p_test_r_2").

%%% P_TEST_R_3

:- pred p_test_r_3 is det.
p_test_r_3 :-
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
    exception.throw("p_test_r_3").

%%% P_TEST_R_4

:- pred p_test_r_4 is det.
p_test_r_4 :-
  if nmm.parser.r(c_r_any,"[test\\]¶",f_str2tkns("\\[test\\]\\¶"),[]) then
    true
  else
    exception.throw("p_test_r_4").

%%% P_TEST_R_STR_1

:- pred p_test_r_str_1 is det.
p_test_r_str_1 :-
  if nmm.parser.r_str("",f_str2tkns("ab"),f_str2tkns("ab")) then
    true
  else
    exception.throw("p_test_str_1").

%%% P_TEST_R_STR_2

:- pred p_test_r_str_2 is det.
p_test_r_str_2 :-
  if nmm.parser.r_str("ab",f_str2tkns("abcd"),f_str2tkns("cd")) then
    true
  else
    exception.throw("p_test_str_2").

%%% P_TEST_R_TAB_1

:- pred p_test_r_tab_1 is det.
p_test_r_tab_1 :-
  if nmm.parser.r_tab(f_str2tkns("\t"),[]) then
    true
  else
    exception.throw("p_test_tab_1").

%%% P_TEST_R_TAB_2

:- pred p_test_r_tab_2 is det.
p_test_r_tab_2 :-
  if nmm.parser.r_tab(f_str2tkns("\t\t"),[nmm.lexer.c_tkn_tab(1u)]) then
    true
  else
    exception.throw("p_test_tab_2").

%%% P_TEST_R_TAB_3

:- pred p_test_r_tab_3 is det.
p_test_r_tab_3 :-
  if nmm.parser.r_tab(f_str2tkns("\tHEJ"),f_str2tkns("HEJ")) then
    true
  else
    exception.throw("p_test_tab_3").

%%% P_TEST_R_TABS_1

:- pred p_test_r_tabs_1 is det.
p_test_r_tabs_1 :-
  if nmm.parser.r_tabs(1u,f_str2tkns("\t"),[]) then
    true
  else
    exception.throw("p_test_tabs_2").

%%% P_TEST_R_TABS_2

:- pred p_test_r_tabs_2 is det.
p_test_r_tabs_2 :-
  if nmm.parser.r_tabs(2u,f_str2tkns("\t\t"),[]) then
    true
  else
    exception.throw("p_test_tabs_2").

%%% P_TEST_R_TABS_3

:- pred p_test_r_tabs_3 is det.
p_test_r_tabs_3 :-
  if nmm.parser.r_tabs(2u,f_str2tkns("\t\thej"),f_str2tkns("hej")) then
    true
  else
    exception.throw("p_test_tabs_3").

%%% P_TEST_STAR_1

:- pred p_test_r_star_1 is det.
p_test_r_star_1 :-
  if *(nmm.parser.r_tab)(f_str2tkns("\t\thej"),f_str2tkns("hej")) then
    true
  else
    exception.throw("p_test_star_1").

%%% P_TEST_STAR_2

:- pred p_test_r_star_2 is det.
p_test_r_star_2 :-
  if (
    *(nmm.parser.r_lb)(f_str2tkns("\n\nhej"),TKNS),
    p_tkns_eq_up_to_line_no(TKNS,f_str2tkns("hej"))
  ) then
    true
  else
    exception.throw("p_test_star_2").

%%% P_TEST_PLUS_1

:- pred p_test_r_plus_1 is det.
p_test_r_plus_1 :-
  if +(nmm.parser.r_tab)(f_str2tkns("\t\thej"),f_str2tkns("hej")) then
    true
  else
    exception.throw("p_test_plus_1").

%%% P_TEST_PLUS_2

:- pred p_test_r_plus_2 is det.
p_test_r_plus_2 :-
  if (
    +(nmm.parser.r_lb)(f_str2tkns("\n\nhej"),TKNS),
    p_tkns_eq_up_to_line_no(TKNS,f_str2tkns("hej"))
  ) then
    true
  else
    exception.throw("p_test_r_plus_2").

%%% P_TEST_PLUS_3

:- pred p_test_r_plus_3 is det.
p_test_r_plus_3 :-
  if +(nmm.parser.r_lb)(f_str2tkns("hej"),_) then
    exception.throw("p_test_r_plus_2")
  else
    true.

%%% P_TEST_QUESTION_MARK_1

:- pred p_test_r_question_mark_1 is det.
p_test_r_question_mark_1 :-
  if (
    ?(nmm.parser.r_lb)(f_str2tkns("\n\nhej"),TKNS),
    p_tkns_eq_up_to_line_no(TKNS,f_str2tkns("\nhej"))
  ) then
    true
  else
    exception.throw("p_test_r_question_mark_1").

%%% P_TEST_QUESTION_MARK_2

:- pred p_test_r_question_mark_2 is det.
p_test_r_question_mark_2 :-
  if ?(nmm.parser.r_tab)(f_str2tkns("hej"),f_str2tkns("hej")) then
    true
  else
    exception.throw("p_test_r_question_mark_2").

%%% P_TEST_R_TAG_1

:- pred p_test_r_tag_1 is det.
p_test_r_tag_1 :-
  if r_tag("DSP",["DSP","DEF"],f_str2tkns("DSP"),[]) then
    true
  else
    exception.throw("p_test_r_tag_1").

%%% P_TEST_R_TAG_2

:- pred p_test_r_tag_2 is det.
p_test_r_tag_2 :-
  if r_tag("DEF",["DSP","DEF"],f_str2tkns("DEF"),[]) then
    true
  else
    exception.throw("p_test_r_tag_2").

%%% P_TEST_R_TAG_3

:- pred p_test_r_tag_3 is det.
p_test_r_tag_3 :-
  if r_tag("DEF",["DSP","DEF"],f_str2tkns("DEFS"),_) then
    exception.throw("p_test_r_tag_3")
  else
    true.

%%% P_TEST_R_TAG_4

:- pred p_test_r_tag_4 is det.
p_test_r_tag_4 :-
  if r_tag("DEF",["DSP","DEF"],f_str2tkns("DEF:"),f_str2tkns(":")) then
    true
  else
    exception.throw("p_test_r_tag_4").

%%% P_TEST_R_NAME_1

:- pred p_test_r_name_1 is det.
p_test_r_name_1 :-
  if r_name("a_name",f_str2tkns("a_name:"),f_str2tkns(":")) then
    true
  else
    exception.throw("p_test_r_name_1").

%%% P_TEST_R_NAME_2

:- pred p_test_r_name_2 is det.
p_test_r_name_2 :-
  if r_name("a_name",f_str2tkns("a_name"),[]) then
    true
  else
    exception.throw("p_test_r_name_2").

%%% P_TEST_R_NAME_3

:- pred p_test_r_name_3 is det.
p_test_r_name_3 :-
  if r_name("a_name",f_str2tkns("a_name]"),f_str2tkns("]")) then
    true
  else
    exception.throw("p_test_r_name_3").

%%% P_TEST_R_NAME_4

:- pred p_test_r_name_4 is det.
p_test_r_name_4 :-
  if r_name("a_name",f_str2tkns("a_name["),f_str2tkns("[")) then
    true
  else
    exception.throw("p_test_r_name_4").

%%% P_TEST_R_NAME_5

:- pred p_test_r_name_5 is det.
p_test_r_name_5 :-
  if r_name(";a_name",f_str2tkns(";a_name"),_) then
    exception.throw("p_test_r_name_5")
  else
    true.

%%% P_TEST_R_ID_1

:- pred p_test_r_id_1 is det.
p_test_r_id_1 :-
  if r_id(
    c_id("PAR","a_name"),
    ["DSP","PAR"],
    f_str2tkns("PAR:a_name"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_id_1").

%%% P_TEST_R_ID_2

:- pred p_test_r_id_2 is det.
p_test_r_id_2 :-
  if (
    r_id(ID,["DSP","PAR"],f_str2tkns("PAR:a_name"),[]),
    fld_id_tag(ID)  = "PAR",
    fld_id_name(ID) = "a_name"
  )
  then
    true
  else
    exception.throw("p_test_r_id_2").

%%% P_TEST_R_ID_3

:- pred p_test_r_id_3 is det.
p_test_r_id_3 :-
  if (
    r_id(
      c_id("PAR","a_name"),
      ["DSP","PAR"],
      f_str2tkns("PAR:a_name]"),
      f_str2tkns("]")
    )
  ) then
    true
  else
    exception.throw("p_test_r_id_3").

%%% P_TEST_R_ID_4

:- pred p_test_r_id_4 is det.
p_test_r_id_4 :-
  if r_id(
      c_id("PAR","a_"),
      ["DSP","PAR"],
      f_str2tkns("PAR:a_,name]"),
      f_str2tkns(",name]")
  ) then
    true
  else
    exception.throw("p_test_r_id_4").

%%% P_TEST_R_C_REF_1

:- pred p_test_r_c_ref_1 is det.
p_test_r_c_ref_1 :-
  if r_c_ref(
      c_c_ref(c_id("PAR","a_name")),
      ["DSP","PAR"],
      f_str2tkns("[PAR:a_name]"),
      []
  ) then
    true
  else
    exception.throw("p_test_r_c_ref_1").

%%% P_TEST_R_C_REF_2

:- pred p_test_r_c_ref_2 is det.
p_test_r_c_ref_2 :-
  if r_c_ref(
      c_c_ref(c_id("PAR","a_name")),
      ["DSP","PAR"],
      f_str2tkns("[PAR:a_name], gives"),
      f_str2tkns(", gives")
  ) then
    true
  else
    exception.throw("p_test_r_c_ref_2").

%%% P_TEST_R_C_REF_3

:- pred p_test_r_c_ref_3 is det.
p_test_r_c_ref_3 :-
  if r_c_ref(
      _,
      ["DSP","PAR"],
      f_str2tkns("[PAR::a_name]"),
      _
  ) then
    exception.throw("p_test_r_c_ref_3")
  else
    true.


%% P_TEST

p_test(!IO) :-
  p_test_r_1,
  p_test_r_2,
  p_test_r_3,
  p_test_r_4,
  p_test_r_str_1,
  p_test_r_str_2,
  p_test_r_tab_1,
  p_test_r_tab_2,
  p_test_r_tab_3,
  p_test_r_tabs_1,
  p_test_r_tabs_2,
  p_test_r_tabs_3,
  p_test_r_star_1,
  p_test_r_star_2,
  p_test_r_plus_1,
  p_test_r_plus_2,
  p_test_r_plus_3,
  p_test_r_question_mark_1,
  p_test_r_question_mark_2,
  p_test_r_tag_1,
  p_test_r_tag_2,
  p_test_r_tag_3,
  p_test_r_tag_4,
  p_test_r_name_1,
  p_test_r_name_2,
  p_test_r_name_3,
  p_test_r_name_4,
  p_test_r_name_5,
  p_test_r_id_1,
  p_test_r_id_2,
  p_test_r_id_3,
  p_test_r_id_4,
  p_test_r_c_ref_1,
  p_test_r_c_ref_2,
  p_test_r_c_ref_3.
