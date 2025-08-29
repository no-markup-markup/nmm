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

:- use_module exception, term_to_xml, nmm.parser, nmm.lexer.


%% CONSTANTS K_VALID_TAGS AND K_ALL_VALID_TAGS

:- func k_valid_tags = t_valid_tags.
k_valid_tags = VALID_TAGS :-
  fld_valid_tags_ch(VALID_TAGS)  = ["CH"],
  fld_valid_tags_sec(VALID_TAGS) = ["SEC"],
  fld_valid_tags_app(VALID_TAGS) = ["APP"],
  fld_valid_tags_par(VALID_TAGS) = ["PAR","DEF"],
  fld_valid_tags_itm(VALID_TAGS) = ["ITM","DEF"],
  fld_valid_tags_dsp(VALID_TAGS) = ["DSP","DEF"].

:- func k_all_valid_tags = strs.
k_all_valid_tags = f_all_valid_tags(k_valid_tags).

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
    exception.throw("p_test_tabs_1").

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

%%% P_TEST_R_TABS_4

:- pred p_test_r_tabs_4 is det.
p_test_r_tabs_4 :-
  if nmm.parser.r_tabs(0u,f_str2tkns("hej"),f_str2tkns("hej")) then
    true
  else
    exception.throw("p_test_tabs_4").

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
  if r_tag(c_tag("DSP"),k_all_valid_tags,f_str2tkns("DSP"),[]) then
    true
  else
    exception.throw("p_test_r_tag_1").

%%% P_TEST_R_TAG_2

:- pred p_test_r_tag_2 is det.
p_test_r_tag_2 :-
  if r_tag(c_tag("DEF"),k_all_valid_tags,f_str2tkns("DEF"),[]) then
    true
  else
    exception.throw("p_test_r_tag_2").

%%% P_TEST_R_TAG_3

:- pred p_test_r_tag_3 is det.
p_test_r_tag_3 :-
  if r_tag(c_tag("DEF"),k_all_valid_tags,f_str2tkns("DEFS"),_) then
    exception.throw("p_test_r_tag_3")
  else
    true.

%%% P_TEST_R_TAG_4

:- pred p_test_r_tag_4 is det.
p_test_r_tag_4 :-
  if (
    r_tag(c_tag("DEF"),k_all_valid_tags,f_str2tkns("DEF:"),f_str2tkns(":"))
  ) then
    true
  else
    exception.throw("p_test_r_tag_4").

%%% P_TEST_R_NAME_1

:- pred p_test_r_name_1 is det.
p_test_r_name_1 :-
  if r_name(c_name("a_name"),f_str2tkns("a_name:"),f_str2tkns(":")) then
    true
  else
    exception.throw("p_test_r_name_1").

%%% P_TEST_R_NAME_2

:- pred p_test_r_name_2 is det.
p_test_r_name_2 :-
  if r_name(c_name("a_name"),f_str2tkns("a_name"),[]) then
    true
  else
    exception.throw("p_test_r_name_2").

%%% P_TEST_R_NAME_3

:- pred p_test_r_name_3 is det.
p_test_r_name_3 :-
  if r_name(c_name("a_name"),f_str2tkns("a_name]"),f_str2tkns("]")) then
    true
  else
    exception.throw("p_test_r_name_3").

%%% P_TEST_R_NAME_4

:- pred p_test_r_name_4 is det.
p_test_r_name_4 :-
  if r_name(c_name("a_name"),f_str2tkns("a_name["),f_str2tkns("[")) then
    true
  else
    exception.throw("p_test_r_name_4").

%%% P_TEST_R_NAME_5

:- pred p_test_r_name_5 is det.
p_test_r_name_5 :-
  if r_name(c_name(";a_name"),f_str2tkns(";a_name"),_) then
    exception.throw("p_test_r_name_5")
  else
    true.

%%% P_TEST_R_ID_1

:- pred p_test_r_id_1 is det.
p_test_r_id_1 :-
  if r_id(
    c_id(c_tag("PAR"),c_name("a_name")),
    k_all_valid_tags,
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
    r_id(ID,k_all_valid_tags,f_str2tkns("PAR:a_name"),[]),
    fld_id_tag(ID)  = c_tag("PAR"),
    fld_id_name(ID) = c_name("a_name")
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
      c_id(c_tag("PAR"),c_name("a_name")),
      k_all_valid_tags,
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
      c_id(c_tag("PAR"),c_name("a_")),
      k_all_valid_tags,
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
      c_c_ref(c_id(c_tag("PAR"),c_name("a_name"))),
      k_all_valid_tags,
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
      c_c_ref(c_id(c_tag("PAR"),c_name("a_name"))),
      k_all_valid_tags,
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
      k_all_valid_tags,
      f_str2tkns("[PAR::a_name]"),
      _
  ) then
    exception.throw("p_test_r_c_ref_3")
  else
    true.

%%% P_TEST_R_TXT_UNIT_1

:- pred p_test_r_txt_unit_1 is det.
p_test_r_txt_unit_1 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ!"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ!"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_1").

%%% P_TEST_R_TXT_UNIT_2

:- pred p_test_r_txt_unit_2 is det.
p_test_r_txt_unit_2 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ!"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ!\t"),
    f_str2tkns("\t")
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_2").

%%% P_TEST_R_TXT_UNIT_3

:- pred p_test_r_txt_unit_3 is det.
p_test_r_txt_unit_3 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ!["),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ!["),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_3").

%%% P_TEST_R_TXT_UNIT_4

:- pred p_test_r_txt_unit_4 is det.
p_test_r_txt_unit_4 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ![¶§]"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ![¶§]"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_4").

%%% P_TEST_R_TXT_UNIT_5

:- pred p_test_r_txt_unit_5 is det.
p_test_r_txt_unit_5 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ![¶§]"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ!\\[\\¶\\§]"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_5").

%%% P_TEST_R_TXT_UNIT_6

:- pred p_test_r_txt_unit_6 is det.
p_test_r_txt_unit_6 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ![PAR:]"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ![PAR:]"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_6").

%%% P_TEST_R_TXT_UNIT_7

:- pred p_test_r_txt_unit_7 is det.
p_test_r_txt_unit_7 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ!"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ![PAR:name]"),
    f_str2tkns("[PAR:name]")
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_7").

%%% P_TEST_R_TXT_UNIT_8

:- pred p_test_r_txt_unit_8 is det.
p_test_r_txt_unit_8 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ![PAR:name]"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ!\\[PAR:name]"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_8").

%%% P_TEST_R_TXT_UNIT_9

:- pred p_test_r_txt_unit_9 is det.
p_test_r_txt_unit_9 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ![INVALID_TAG:name]"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ![INVALID_TAG:name]"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_9").

%%% P_TEST_R_TXT_UNIT_10

:- pred p_test_r_txt_unit_10 is det.
p_test_r_txt_unit_10 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("HEJ!"),
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ!\n"),
    f_str2tkns("\n")
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_10").

%%% P_TEST_R_TXT_UNIT_11

:- pred p_test_r_txt_unit_11 is det.
p_test_r_txt_unit_11 :-
  if r_txt_unit(
    c_txt_unit_wysiwyg("[PAR:name]HEJ!"),
    0u,
    k_all_valid_tags,
    f_str2tkns("[PAR:name]HEJ!"),
    _
  ) then
    exception.throw("p_test_r_txt_unit_11")
  else
    true.

%%% P_TEST_R_TXT_UNIT_12

:- pred p_test_r_txt_unit_12 is det.
p_test_r_txt_unit_12 :-
  if r_txt_unit(
    c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
    0u,
    k_all_valid_tags,
    f_str2tkns("[PAR:name]"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_12").

%%% P_TEST_R_TXT_UNIT_13

:- pred p_test_r_txt_unit_13 is det.
p_test_r_txt_unit_13 :-
  if r_txt_unit(
    c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
    0u,
    k_all_valid_tags,
    f_str2tkns("[PAR:name], and more"),
    f_str2tkns(", and more")
  ) then
    true
  else
    exception.throw("p_test_r_txt_unit_13").

%%% P_TEST_R_TXT_UNITS_1

:- pred p_test_r_txt_units_1 is det.
p_test_r_txt_units_1 :-
  if r_txt_units(
    [c_txt_unit_wysiwyg("HEJ!")],
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ!"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_units_1").

%%% P_TEST_R_TXT_UNITS_2

:- pred p_test_r_txt_units_2 is det.
p_test_r_txt_units_2 :-
  if r_txt_units(
    [
      c_txt_unit_wysiwyg("HEJ!"),
      c_txt_unit_c_ref(c_c_ref(c_id(c_tag("DSP"),c_name("name"))))
    ],
    0u,
    k_all_valid_tags,
    f_str2tkns("HEJ![DSP:name]"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_txt_units_2").

%%% P_TEST_R_TXT_UNITS_3

:- pred p_test_r_txt_units_3 is det.
p_test_r_txt_units_3 :-
  if (
    r_txt_units(
      [
        c_txt_unit_emph("HEJ! HAJ!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("DSP"),c_name("name")))),
        c_txt_unit_wysiwyg("HAJ!")
      ],
      0u,
      k_all_valid_tags,
      f_str2tkns("*HEJ!\nHAJ!*[DSP:name]HAJ!\n"),
      TKNS_OUT
    ),
    p_tkns_eq_up_to_line_no(TKNS_OUT,f_str2tkns("\n"))
  ) then
    true
  else
    exception.throw("p_test_r_txt_units_3").

%%% P_TEST_R_TXT_UNITS_4

:- pred p_test_r_txt_units_4 is det.
p_test_r_txt_units_4 :-
  if r_txt_units(
    _,
    0u,
    k_all_valid_tags,
    f_str2tkns("\tHEJ![DSP:name]HAJ!\n"),
    _
  ) then
    exception.throw("p_test_r_txt_units_4")
  else
    true.

%%% P_TEST_R_TXT_UNITS_5

:- pred p_test_r_txt_units_5 is det.
p_test_r_txt_units_5 :-
  if (
    r_txt_units(
      [
        c_txt_unit_emph("HEJ! HAJ!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("DSP"),c_name("name")))),
        c_txt_unit_wysiwyg("HAJ!")
      ],
      1u,
      k_all_valid_tags,
      f_str2tkns("*HEJ!\n\tHAJ!*[DSP:name]HAJ!\n"),
      TKNS_OUT
    ),
    p_tkns_eq_up_to_line_no(TKNS_OUT,f_str2tkns("\n"))
  ) then
    true
  else
    exception.throw("p_test_r_txt_units_5").

%%% P_TEST_R_BLK_TXT_1

:- pred p_test_r_blk_txt_1 is det.
p_test_r_blk_txt_1 :-
  if r_blk_txt(
    [c_txt_unit_wysiwyg("HEJ!")],
    0u,
    k_valid_tags,
    f_str2tkns("HEJ!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_txt_1").

%%% P_TEST_R_BLK_TXT_2

:- pred p_test_r_blk_txt_2 is det.
p_test_r_blk_txt_2 :-
  if r_blk_txt(
    [c_txt_unit_wysiwyg("HEJ!")],
    100u,
    k_valid_tags,
    f_str2tkns("HEJ!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_txt_2").

%%% P_TEST_R_BLK_TXT_3

:- pred p_test_r_blk_txt_3 is det.
p_test_r_blk_txt_3 :-
  if r_blk_txt(
    [c_txt_unit_wysiwyg("HEJ!"),c_txt_unit_wysiwyg("OCH HEJ IGEN!")],
    2u,
    k_valid_tags,
    f_str2tkns("HEJ!\n\t\tOCH HEJ IGEN!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_txt_3").

%%% P_TEST_R_BLK_TXT_4

:- pred p_test_r_blk_txt_4 is det.
p_test_r_blk_txt_4 :-
  if r_blk_txt(
    [
      c_txt_unit_wysiwyg("HEJ "),
      c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
      c_txt_unit_wysiwyg("!")
    ],
    100u,
    k_valid_tags,
    f_str2tkns("HEJ [PAR:name]!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_txt_4").

%%% P_TEST_R_BLK_TXT_5

:- pred p_test_r_blk_txt_5 is det.
p_test_r_blk_txt_5 :-
  if (
    r_blk_txt(
      [
        c_txt_unit_wysiwyg("HEJ "),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
        c_txt_unit_wysiwyg("!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("DSP"),c_name("name"))))
      ],
      1u,
      k_valid_tags,
      f_str2tkns("HEJ [PAR:name]!\n\t[DSP:name]\n\n"),
      TKNS_OUT
    ),
    p_tkns_eq_up_to_line_no(TKNS_OUT,f_str2tkns("\n"))
  ) then
    true
  else
    exception.throw("p_test_r_blk_txt_5").

%%% P_TEST_R_BLK_TXT_6

:- pred p_test_r_blk_txt_6 is det.
p_test_r_blk_txt_6 :-
  if r_blk_txt(
    [c_txt_unit_wysiwyg("HEJ!"),c_txt_unit_wysiwyg("OCH HEJ IGEN!")],
    2u,
    k_valid_tags,
    f_str2tkns("HEJ!\n\tOCH HEJ IGEN!\n"),
    _
  ) then
    exception.throw("p_test_r_blk_txt_6")
  else
    true.

%%% P_TEST_R_BLK_TXT_7

:- pred p_test_r_blk_txt_7 is det.
p_test_r_blk_txt_7 :-
  if (
    r_blk_txt(
      [
        c_txt_unit_wysiwyg("HEJ"),
        c_txt_unit_wysiwyg("HAJ "),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
        c_txt_unit_wysiwyg("!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("DSP"),c_name("name")))),
        c_txt_unit_wysiwyg("HOJ")
      ],
      0u,
      k_valid_tags,
      f_str2tkns("HEJ\nHAJ [PAR:name]!\n[DSP:name]\nHOJ\n"),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_blk_txt_7").

%%% P_TEST_R_BLK_1

:- pred p_test_r_blk_1 is det.
p_test_r_blk_1 :-
  if r_blk(
    c_blk_txt([
      c_txt_unit_wysiwyg("HEJ!"),
      c_txt_unit_wysiwyg("HEJ!")
    ]),
    0u,
    k_valid_tags,
    f_str2tkns("HEJ!\nHEJ!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_1").

%%% P_TEST_R_BLKS_1

:- pred p_test_r_blks_1 is det.
p_test_r_blks_1 :-
  if r_blks(
    [c_blk_txt([c_txt_unit_wysiwyg("HEJ!")])],
    0u,
    k_valid_tags,
    f_str2tkns("HEJ!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blks_1").

%%% P_TEST_R_BLKS_2

:- pred p_test_r_blks_2 is det.
p_test_r_blks_2 :-
  if r_blks(
    [
      c_blk_txt([
        c_txt_unit_wysiwyg("HEJ!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name"))))
      ]),
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")])
    ],
    0u,
    k_valid_tags,
    f_str2tkns("HEJ![PAR:name]\n\nHEJ!\n"),
    []
  )
  then
    true
  else
    exception.throw("p_test_r_blks_2").

%%% P_TEST_R_BLKS_3

:- pred p_test_r_blks_3 is det.
p_test_r_blks_3 :-
  if r_blks(
    [
      c_blk_txt([
        c_txt_unit_wysiwyg("HEJ!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name"))))
      ]),
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")])
    ],
    2u,
    k_valid_tags,
    f_str2tkns("HEJ![PAR:name]\n\n\t\tHEJ!\n"),
    []
  )
  then
    true
  else
    exception.throw("p_test_r_blks_3").

%%% P_TEST_R_BLKS_4

:- pred p_test_r_blks_4 is det.
p_test_r_blks_4 :-
  if r_blks(
    [
      c_blk_txt([
        c_txt_unit_wysiwyg("HEJ!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name"))))
      ]),
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")])
    ],
    2u,
    k_valid_tags,
    f_str2tkns("HEJ![PAR:name]\n\n\n\n\t\tHEJ!\n"),
    []
  )
  then
    true
  else
    exception.throw("p_test_r_blks_4").

%%% P_TEST_R_BLKS_5

:- pred p_test_r_blks_5 is det.
p_test_r_blks_5 :-
  if r_blks(
    [
      c_blk_txt([
        c_txt_unit_wysiwyg("HEJ!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name"))))
      ]),
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")])
    ],
    0u,
    k_valid_tags,
    f_str2tkns("HEJ![PAR:name]\n\n\tHEJ!\n"),
    _
  )
  then
    exception.throw("p_test_r_blks_5")
  else
    true.

%%% P_TEST_R_BLK_BLT_1

:- pred p_test_r_blk_blt_1 is det.
p_test_r_blk_blt_1 :-
  if r_blk_blt(
    [c_blk_txt([c_txt_unit_wysiwyg("HEJ!")])],
    0u,
    k_valid_tags,
    f_str2tkns("-\tHEJ!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_blt_1").

%%% P_TEST_R_BLK_BLT_2

:- pred p_test_r_blk_blt_2 is det.
p_test_r_blk_blt_2 :-
  if r_blk_blt(
    [
      c_blk_txt([
        c_txt_unit_wysiwyg("HEJ!"),
        c_txt_unit_wysiwyg("HAJ!")
      ])
    ],
    1u,
    k_valid_tags,
    f_str2tkns("-\tHEJ!\n\t\tHAJ!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_blt_2").

%%% P_TEST_R_BLK_BLT_3

:- pred p_test_r_blk_blt_3 is det.
p_test_r_blk_blt_3 :-
  if r_blk_blt(
    [
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")]),
      c_blk_txt([c_txt_unit_wysiwyg("HAJ!")])
    ],
    1u,
    k_valid_tags,
    f_str2tkns("-\tHEJ!\n\n\t\tHAJ!\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_blt_3").

%%% P_TEST_R_BLK_BLT_4

:- pred p_test_r_blk_blt_4 is det.
p_test_r_blk_blt_4 :-
  if r_blk_blt(
    [
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")]),
      c_blk_txt([
        c_txt_unit_wysiwyg("HAJ"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
        c_txt_unit_wysiwyg("HOJ")
      ])
    ],
    1u,
    k_valid_tags,
    f_str2tkns("-\tHEJ!\n\n\n\n\n\t\tHAJ[PAR:name]\n\t\tHOJ\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_blt_4").

%%% P_TEST_R_BLK_BLT_5

:- pred p_test_r_blk_blt_5 is det.
p_test_r_blk_blt_5 :-
  if r_blk_blt(
    [
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")]),
      c_blk_txt([
        c_txt_unit_wysiwyg("HAJ"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
        c_txt_unit_wysiwyg("HOJ")
      ]),
      c_blk_txt([c_txt_unit_wysiwyg("HOJHOJ")])
    ],
    0u,
    k_valid_tags,
    f_str2tkns("-\tHEJ!\n\n\tHAJ[PAR:name]\n\tHOJ\n\n\tHOJHOJ\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_blt_5").

%%% P_TEST_R_BLK_BLT_6

:- pred p_test_r_blk_blt_6 is det.
p_test_r_blk_blt_6 :-
  if r_blk_blt(
    [
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")]),
      c_blk_txt([
        c_txt_unit_wysiwyg("HAJ"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name"))))
      ]),
      c_blk_txt([c_txt_unit_wysiwyg("HOJ")]),
      c_blk_blt([c_blk_txt([c_txt_unit_wysiwyg("HEJ")])])
    ],
    1u,
    k_valid_tags,
    f_str2tkns("-\tHEJ!\n\n\t\tHAJ[PAR:name]\n\n\t\tHOJ\n\n\t\t-\tHEJ\n"),
    []
  ) then
    true
  else
    exception.throw("p_test_r_blk_blt_6").

%%% P_TEST_R_DOC_MAIN_1

:- pred p_test_r_doc_main_1 is det.
p_test_r_doc_main_1 :-
  if r_doc_main(
    c_doc_main_blks([
      c_blk_txt([c_txt_unit_wysiwyg("HOJ!"),c_txt_unit_wysiwyg("HAJ!")]),
      c_blk_blt([c_blk_txt([c_txt_unit_emph("TJO TJO")])])
    ]),
    k_valid_tags,
    f_str2tkns("HOJ!\nHAJ!\n\n-\t*TJO\n\tTJO*\n") ++ [nmm.lexer.c_tkn_eof],
    _
  ) then
    true
  else
    exception.throw("p_test_r_doc_main_1").

%%% P_TEST_R_DOC_MAIN_2

:- pred p_test_r_doc_main_2(io.io::di,io.io::uo) is det.
p_test_r_doc_main_2(!IO) :-
  io.read_named_file_as_string(
    "../../example_sources/blks_nested_blts_w_escs.nmm",
    RES,
    !IO
  ),
  (
    (
      RES = io.error(ERR_CODE),
      io.write_string(io.error_message(ERR_CODE),!IO)
    );
    (
      RES          = io.ok(FILE_AS_STR),
      TKNS_OR_ERRS = nmm.lexer.f_tknize(str2chrs(FILE_AS_STR)),
      (
        (
          TKNS_OR_ERRS = nmm.lexer.c_tknize_res_err(ERR_MSG),
          io.write_string(ERR_MSG,!IO)
        );
        (
          TKNS_OR_ERRS = nmm.lexer.c_tknize_res_ok(TKNS),
          (
            if r_doc_main(DOC_MAIN,k_valid_tags,TKNS,[]) then
              io.write(DOC_MAIN,!IO),
              io.write_string("\n",!IO)
            else
              exception.throw("p_test_r_doc_main_2")
          )
        )
      )
    )
  ).


%%% P_TEST_R_HDR_1

:- pred p_test_r_hdr_1 is det.
p_test_r_hdr_1 :-
  if (
    r_hdr(
      c_hdr([
        c_txt_unit_wysiwyg("HEJ"),
        c_txt_unit_wysiwyg("HAJ "),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
        c_txt_unit_wysiwyg("!"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("DSP"),c_name("name")))),
        c_txt_unit_wysiwyg("HOJ")
      ]),
      k_valid_tags,
      f_str2tkns("HEJ\nHAJ [PAR:name]!\n[DSP:name]\nHOJ\n"),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_hdr_1").

%%% P_TEST_R_TAG_OR_ID_1

:- pred p_test_r_tag_or_id_1 is det.
p_test_r_tag_or_id_1 :-
  if (
    r_tag_or_id(
      c_tag_or_id_id(c_id(c_tag("PAR"),c_name("name"))),
      k_all_valid_tags,
      f_str2tkns("PAR:name !"),
      f_str2tkns(" !")
    )
  ) then
    true
  else
    exception.throw("p_test_r_tag_or_id_1").

%%% P_TEST_R_TAG_OR_ID_2

:- pred p_test_r_tag_or_id_2 is det.
p_test_r_tag_or_id_2 :-
  if (
    r_tag_or_id(
      c_tag_or_id_tag(c_tag("PAR")),
      k_all_valid_tags,
      f_str2tkns("PAR :name"),
      f_str2tkns(" :name")
    )
  ) then
    true
  else
    exception.throw("p_test_r_tag_or_id_2").

%%% P_TEST_R_PAR_1

:- pred p_test_r_par_1 is det.
p_test_r_par_1 :-
  if (
    r_par(
      c_par(
        maybe.no,
        maybe.no,
        [
          c_blk_txt(
            [
              c_txt_unit_wysiwyg("HEJ!"),
              c_txt_unit_wysiwyg("HAJ!")
            ]
          )
        ]
      ),
      k_valid_tags,
      f_str2tkns("¶\n\nHEJ!\nHAJ!\n"),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_par_1").

%%% P_TEST_R_PAR_2

:- pred p_test_r_par_2 is det.
p_test_r_par_2 :-
  if (
    r_par(
      c_par(
        maybe.no,
        maybe.no,
        [
          c_blk_txt([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ]),
          c_blk_blt([c_blk_txt([
            c_txt_unit_wysiwyg("HOJ!"),
            c_txt_unit_wysiwyg("HÖJ!")
          ])])
        ]
      ),
      k_valid_tags,
      f_str2tkns("¶\n\nHEJ!\nHAJ!\n\n-\tHOJ!\n\tHÖJ!\n"),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_par_2").

%%% P_TEST_R_PAR_3

:- pred p_test_r_par_3 is det.
p_test_r_par_3 :-
  if (
    r_par(
      c_par(
        maybe.yes(c_tag_or_id_tag(c_tag("PAR"))),
        maybe.no,
        [
          c_blk_txt([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ]),
          c_blk_blt([c_blk_txt([
            c_txt_unit_wysiwyg("HOJ!"),
            c_txt_unit_wysiwyg("HÖJ!")
          ])])
        ]
      ),
      k_valid_tags,
      f_str2tkns("¶ PAR\n\nHEJ!\nHAJ!\n\n-\tHOJ!\n\tHÖJ!\n"),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_par_3").

%%% P_TEST_R_PAR_4

:- pred p_test_r_par_4 is det.
p_test_r_par_4 :-
  if (
    r_par(
      c_par(
        maybe.yes(c_tag_or_id_id(c_id(c_tag("PAR"),c_name("name")))),
        maybe.no,
        [
          c_blk_txt([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ]),
          c_blk_blt([c_blk_txt([
            c_txt_unit_wysiwyg("HOJ!"),
            c_txt_unit_wysiwyg("HÖJ!")
          ])])
        ]
      ),
      k_valid_tags,
      f_str2tkns("¶ PAR:name\n\nHEJ!\nHAJ!\n\n-\tHOJ!\n\tHÖJ!\n"),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_par_4").


%%% P_TEST_R_PAR_5

:- pred p_test_r_par_5 is det.
p_test_r_par_5 :-
  if (
    r_par(
      c_par(
        maybe.yes(c_tag_or_id_id(c_id(c_tag("PAR"),c_name("name")))),
        maybe.yes(c_hdr([
          c_txt_unit_wysiwyg("HEJ!"),
          c_txt_unit_wysiwyg("HAJ!")
        ])),
        [
          c_blk_txt([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ]),
          c_blk_blt([c_blk_txt([
            c_txt_unit_wysiwyg("HOJ!"),
            c_txt_unit_wysiwyg("HÖJ!")
          ])])
        ]
      ),
      k_valid_tags,
      f_str2tkns("¶ PAR:name\nHEJ!\nHAJ!\n\nHEJ!\nHAJ!\n\n-\tHOJ!\n\tHÖJ!\n"),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_par_5").

%%% P_TEST_R_PAR_6

:- pred p_test_r_par_6 is det.
p_test_r_par_6 :-
  if (
    r_par(
      c_par(
        maybe.yes(c_tag_or_id_tag(c_tag("PARR"))),
        maybe.no,
        [
          c_blk_txt(
            [
              c_txt_unit_wysiwyg("HEJ!"),
              c_txt_unit_wysiwyg("HAJ!")
            ]
          )
        ]
      ),
      k_valid_tags,
      f_str2tkns("¶ PARR\n\nHEJ!\nHAJ!\n"),
      []
    )
  ) then
    exception.throw("p_test_r_par_6")
  else
    true.

%%% P_TEST_R_PARS_1

:- pred p_test_r_pars_1 is det.
p_test_r_pars_1 :-
  if (
    r_pars(
      [
        c_par(
          maybe.yes(c_tag_or_id_id(c_id(c_tag("PAR"),c_name("name")))),
          maybe.yes(c_hdr([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ])),
          [
            c_blk_txt([
              c_txt_unit_wysiwyg("HEJ!"),
              c_txt_unit_wysiwyg("HAJ!")
            ]),
            c_blk_blt([c_blk_txt([
              c_txt_unit_wysiwyg("HOJ!"),
              c_txt_unit_wysiwyg("HÖJ!")
            ])])
          ]
        )
      ],
      k_valid_tags,
      f_str2tkns("¶ PAR:name\nHEJ!\nHAJ!\n\nHEJ!\nHAJ!\n\n-\tHOJ!\n\tHÖJ!\n"),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_pars_1").

%%% P_TEST_R_PARS_2

:- pred p_test_r_pars_2 is det.
p_test_r_pars_2 :-
  if (
    r_pars(
      [
        c_par(
          maybe.yes(c_tag_or_id_id(c_id(c_tag("PAR"),c_name("name")))),
          maybe.yes(c_hdr([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ])),
          [
            c_blk_txt([
              c_txt_unit_wysiwyg("HEJ!"),
              c_txt_unit_wysiwyg("HAJ!")
            ]),
            c_blk_blt([c_blk_txt([
              c_txt_unit_wysiwyg("HOJ!"),
              c_txt_unit_wysiwyg("HÖJ!")
            ])])
          ]
        ),
        c_par(
          maybe.yes(c_tag_or_id_id(c_id(c_tag("PAR"),c_name("name")))),
          maybe.yes(c_hdr([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ])),
          [
            c_blk_txt([
              c_txt_unit_wysiwyg("HEJ!"),
              c_txt_unit_wysiwyg("HAJ!")
            ]),
            c_blk_blt([c_blk_txt([
              c_txt_unit_wysiwyg("HOJ!"),
              c_txt_unit_wysiwyg("HÖJ!")
            ])])
          ]
        )
      ],
      k_valid_tags,
      f_str2tkns(
        "¶ PAR:name\nHEJ!\nHAJ!\n\nHEJ!\nHAJ!\n\n-\tHOJ!\n\tHÖJ!\n"
        ++
        "\n"
        ++
        "¶ PAR:name\nHEJ!\nHAJ!\n\nHEJ!\nHAJ!\n\n-\tHOJ!\n\tHÖJ!\n"
      ),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_pars_2").

%%% P_TEST_R_PARS_3

:- pred p_test_r_pars_3 is det.
p_test_r_pars_3 :-
  if (
    r_pars(
      [
        c_par(
          maybe.yes(c_tag_or_id_id(c_id(c_tag("PAR"),c_name("name")))),
          maybe.yes(c_hdr([c_txt_unit_wysiwyg("¶ PAR:name")])),
          [
            c_blk_txt([c_txt_unit_wysiwyg("¶")]),
            c_blk_txt([c_txt_unit_wysiwyg("§")]),
            c_blk_txt([c_txt_unit_wysiwyg("CH")])
          ]
        )
      ],
      k_valid_tags,
      f_str2tkns(
        "¶ PAR:name\n"
        ++
        "\\¶ PAR:name\n" % header with initial escaped pilcrow
        ++
        "\n\n"
        ++
        "\\¶\n" % text block with initial escaped pilcrow
        ++
        "\n\n"
        ++
        "\\§\n" % text block with initial escaped section sign
        ++
        "\n\n"
        ++
        "\\CH\n" % text block with initial escaped ‘CH’
      ),
      []
    )
  ) then
    true
  else
    exception.throw("p_test_r_pars_3").


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
  p_test_r_tabs_4,
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
  p_test_r_c_ref_3,
  p_test_r_txt_unit_1,
  p_test_r_txt_unit_2,
  p_test_r_txt_unit_3,
  p_test_r_txt_unit_4,
  p_test_r_txt_unit_5,
  p_test_r_txt_unit_6,
  p_test_r_txt_unit_7,
  p_test_r_txt_unit_8,
  p_test_r_txt_unit_9,
  p_test_r_txt_unit_10,
  p_test_r_txt_unit_11,
  p_test_r_txt_unit_12,
  p_test_r_txt_unit_13,
  p_test_r_txt_units_1,
  p_test_r_txt_units_2,
  p_test_r_txt_units_3,
  p_test_r_txt_units_4,
  p_test_r_txt_units_5,
  p_test_r_blk_txt_1,
  p_test_r_blk_txt_2,
  p_test_r_blk_txt_3,
  p_test_r_blk_txt_4,
  p_test_r_blk_txt_5,
  p_test_r_blk_txt_6,
  p_test_r_blk_txt_7,
  p_test_r_blk_1,
  p_test_r_blks_1,
  p_test_r_blks_2,
  p_test_r_blks_3,
  p_test_r_blks_4,
  p_test_r_blks_5,
  p_test_r_blk_blt_1,
  p_test_r_blk_blt_2,
  p_test_r_blk_blt_3,
  p_test_r_blk_blt_4,
  p_test_r_blk_blt_5,
  p_test_r_blk_blt_6,
  p_test_r_hdr_1,
  p_test_r_tag_or_id_1,
  p_test_r_tag_or_id_2,
  p_test_r_par_1,
  p_test_r_par_2,
  p_test_r_par_3,
  p_test_r_par_4,
  p_test_r_par_5,
  p_test_r_par_6,
  p_test_r_pars_1,
  p_test_r_pars_2,
  p_test_r_pars_3,
  p_test_r_doc_main_1,
  p_test_r_doc_main_2(!IO),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_c_ref(c_id(c_tag("DSP"),c_name("name"))),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_id(c_tag("DSP"),c_name("name")),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_txt_unit_wysiwyg("HEJ"),
    !IO
  ),
  io.write_string("\n",!IO),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_txt_unit_emph("HAJ"),
    !IO
  ),
  io.write_string("\n",!IO),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_blk_txt([
      c_txt_unit_wysiwyg("HEJ"),
      c_txt_unit_wysiwyg("HAJ "),
      c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
      c_txt_unit_wysiwyg("!"),
      c_txt_unit_c_ref(c_c_ref(c_id(c_tag("DSP"),c_name("name")))),
      c_txt_unit_wysiwyg("HOJ")
    ]),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_blk_blt([
      c_blk_txt([c_txt_unit_wysiwyg("HEJ!")]),
      c_blk_txt([
        c_txt_unit_wysiwyg("HAJ"),
        c_txt_unit_c_ref(c_c_ref(c_id(c_tag("PAR"),c_name("name")))),
        c_txt_unit_wysiwyg("HOJ")
      ]),
      c_blk_txt([c_txt_unit_wysiwyg("HOJHOJ")])
    ]),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_par(
      maybe.yes(c_tag_or_id_tag(c_tag("PAR"))),
      maybe.yes(c_hdr([c_txt_unit_wysiwyg("a header")])),
      [
        c_blk_txt([
          c_txt_unit_wysiwyg("HEJ!"),
          c_txt_unit_wysiwyg("HAJ!")
        ]),
        c_blk_blt([c_blk_txt([
          c_txt_unit_wysiwyg("HOJ!"),
          c_txt_unit_wysiwyg("HÖJ!")
        ])])
      ]
    ),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_par(
      maybe.yes(c_tag_or_id_id(c_id(c_tag("PAR"),c_name("name")))),
      maybe.yes(c_hdr([c_txt_unit_wysiwyg("a header")])),
      [
        c_blk_txt([
          c_txt_unit_wysiwyg("HEJ!"),
          c_txt_unit_wysiwyg("HAJ!")
        ]),
        c_blk_blt([c_blk_txt([
          c_txt_unit_wysiwyg("HOJ!"),
          c_txt_unit_wysiwyg("HÖJ!")
        ])])
      ]
    ),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_par(
      maybe.no,
      maybe.yes(c_hdr([c_txt_unit_wysiwyg("a header")])),
      [
        c_blk_txt([
          c_txt_unit_wysiwyg("HEJ!"),
          c_txt_unit_wysiwyg("HAJ!")
        ]),
        c_blk_blt([c_blk_txt([
          c_txt_unit_wysiwyg("HOJ!"),
          c_txt_unit_wysiwyg("HÖJ!")
        ])])
      ]
    ),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_par(
      maybe.no,
      maybe.no,
      [
        c_blk_txt([
          c_txt_unit_wysiwyg("HEJ!"),
          c_txt_unit_wysiwyg("HAJ!")
        ]),
        c_blk_blt([c_blk_txt([
          c_txt_unit_wysiwyg("HOJ!"),
          c_txt_unit_wysiwyg("HÖJ!")
        ])])
      ]
    ),
    !IO
  ),
  term_to_xml.write_xml_doc(
    io.stdout_stream,
    c_doc_main_pars([
      c_par(
        maybe.no,
        maybe.yes(c_hdr([c_txt_unit_wysiwyg("a header")])),
        [
          c_blk_txt([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ]),
          c_blk_blt([c_blk_txt([
            c_txt_unit_wysiwyg("HOJ!"),
            c_txt_unit_wysiwyg("HÖJ!")
          ])])
        ]
      ),
      c_par(
        maybe.no,
        maybe.no,
        [
          c_blk_txt([
            c_txt_unit_wysiwyg("HEJ!"),
            c_txt_unit_wysiwyg("HAJ!")
          ]),
          c_blk_blt([c_blk_txt([
            c_txt_unit_wysiwyg("HOJ!"),
            c_txt_unit_wysiwyg("HÖJ!")
          ])])
        ]
      )
    ]),
    !IO
  ).
