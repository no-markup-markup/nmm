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


%% PREDICATE P_TEST

%%% HELPER TEST PREDICATE P_EQ_UP_TO_LINE_NO

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

%%% P_TEST_R_TAG_1

:- pred p_test_r_tag_1 is semidet.
p_test_r_tag_1 :- r_tag(cs_tag("DSP"),f_str2tkns("DSP"),[]).

%%% P_TEST_R_TAG_2

:- pred p_test_r_tag_2 is semidet.
p_test_r_tag_2 :- r_tag(cs_tag("DEF"),f_str2tkns("DEF"),[]).

%%% P_TEST_R_TAG_3

:- pred p_test_r_tag_3 is semidet.
p_test_r_tag_3 :- not r_tag(cs_tag("DEF"),f_str2tkns("DEFS"),_).

%%% P_TEST_R_TAG_4

:- pred p_test_r_tag_4 is semidet.
p_test_r_tag_4 :- r_tag(cs_tag("DEF"),f_str2tkns("DEF:"),f_str2tkns(":")).

%%% P_TEST_R_NAME_1

:- pred p_test_r_name_1 is semidet.
p_test_r_name_1 :-
  r_name(cs_name("a_name"),f_str2tkns("a_name:"),f_str2tkns(":")).

%%% P_TEST_R_NAME_2

:- pred p_test_r_name_2 is semidet.
p_test_r_name_2 :- r_name(cs_name("a_name"),f_str2tkns("a_name"),[]).

%%% P_TEST_R_NAME_3

:- pred p_test_r_name_3 is semidet.
p_test_r_name_3 :-
  r_name(cs_name("a_name"),f_str2tkns("a_name]"),f_str2tkns("]")).

%%% P_TEST_R_NAME_4

:- pred p_test_r_name_4 is semidet.
p_test_r_name_4 :-
  r_name(cs_name("a_name"),f_str2tkns("a_name["),f_str2tkns("[")).

%%% P_TEST_R_NAME_5

:- pred p_test_r_name_5 is semidet.
p_test_r_name_5 :-
  not r_name(cs_name(";a_name"),f_str2tkns(";a_name"),_).

%%% P_TEST_R_ID_1

:- pred p_test_r_id_1 is semidet.
p_test_r_id_1 :-
  r_id(cr_id(cs_tag("PAR"),cs_name("a_name")),f_str2tkns("PAR:a_name"),[]).

%%% P_TEST_R_ID_2

:- pred p_test_r_id_2 is semidet.
p_test_r_id_2 :-
  r_id(ID,f_str2tkns("PAR:a_name"),[]),
  fld_id_tag(ID)  = cs_tag("PAR"),
  fld_id_name(ID) = cs_name("a_name").

%%% P_TEST_R_ID_3

:- pred p_test_r_id_3 is semidet.
p_test_r_id_3 :- r_id(
  cr_id(cs_tag("PAR"),cs_name("a_name")),
  f_str2tkns("PAR:a_name]"),
  f_str2tkns("]")
).

%%% P_TEST_R_ID_4

:- pred p_test_r_id_4 is semidet.
p_test_r_id_4 :- r_id(
  cr_id(cs_tag("PAR"),cs_name("a_")),
  f_str2tkns("PAR:a_,name]"),
  f_str2tkns(",name]")
).

%%% P_TEST_R_C_REF_1

:- pred p_test_r_c_ref_1 is semidet.
p_test_r_c_ref_1 :- r_c_ref(
  cs_c_ref(cr_id(cs_tag("PAR"),cs_name("a_name"))),
  f_str2tkns("[PAR:a_name]"),
  []
).

%%% P_TEST_R_C_REF_2

:- pred p_test_r_c_ref_2 is semidet.
p_test_r_c_ref_2 :- r_c_ref(
  cs_c_ref(cr_id(cs_tag("PAR"),cs_name("a_name"))),
  f_str2tkns("[PAR:a_name], gives"),
  f_str2tkns(", gives")
).

%%% P_TEST_R_C_REF_3

:- pred p_test_r_c_ref_3 is semidet.
p_test_r_c_ref_3 :- not r_c_ref(_,f_str2tkns("[PAR::a_name]"),_).

%%% P_TEST_R_TXT_UNIT_1

:- pred p_test_r_txt_unit_1 is semidet.
p_test_r_txt_unit_1 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
  f_str2tkns("HEJ!"),
  []
).

%%% P_TEST_R_TXT_UNIT_2

:- pred p_test_r_txt_unit_2 is semidet.
p_test_r_txt_unit_2 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
  f_str2tkns("HEJ!\t"),
  f_str2tkns("\t")
).

%%% P_TEST_R_TXT_UNIT_3

:- pred p_test_r_txt_unit_3 is semidet.
p_test_r_txt_unit_3 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ![")),
  f_str2tkns("HEJ!["),
  []
).

%%% P_TEST_R_TXT_UNIT_4

:- pred p_test_r_txt_unit_4 is semidet.
p_test_r_txt_unit_4 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ![¶§]")),
  f_str2tkns("HEJ![¶§]"),
  []
).

%%% P_TEST_R_TXT_UNIT_5

:- pred p_test_r_txt_unit_5 is semidet.
p_test_r_txt_unit_5 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ![¶§]")),
  f_str2tkns("HEJ!\\[\\¶\\§]"),
  []
).

%%% P_TEST_R_TXT_UNIT_6

:- pred p_test_r_txt_unit_6 is semidet.
p_test_r_txt_unit_6 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ![PAR:]")),
  f_str2tkns("HEJ![PAR:]"),
  []
).

%%% P_TEST_R_TXT_UNIT_7

:- pred p_test_r_txt_unit_7 is semidet.
p_test_r_txt_unit_7 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
  f_str2tkns("HEJ![PAR:name]"),
  f_str2tkns("[PAR:name]")
).

%%% P_TEST_R_TXT_UNIT_8

:- pred p_test_r_txt_unit_8 is semidet.
p_test_r_txt_unit_8 :-r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ![PAR:name]")),
  f_str2tkns("HEJ!\\[PAR:name]"),
  []
).

%%% P_TEST_R_TXT_UNIT_9

:- pred p_test_r_txt_unit_9 is semidet.
p_test_r_txt_unit_9 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ![INVALID:TAG:name]")),
  f_str2tkns("HEJ![INVALID:TAG:name]"),
  []
).

%%% P_TEST_R_TXT_UNIT_10

:- pred p_test_r_txt_unit_10 is semidet.
p_test_r_txt_unit_10 :- r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
  f_str2tkns("HEJ!\n"),
  f_str2tkns("\n")
).

%%% P_TEST_R_TXT_UNIT_11

:- pred p_test_r_txt_unit_11 is semidet.
p_test_r_txt_unit_11 :- not r_txt_unit(
  0u,
  ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("[PAR:name]HEJ!")),
  f_str2tkns("[PAR:name]HEJ!"),
  _
).

%%% P_TEST_R_TXT_UNIT_12

:- pred p_test_r_txt_unit_12 is semidet.
p_test_r_txt_unit_12 :- r_txt_unit(
  0u,
  ce_txt_unit_c_ref(cs_txt_unit_c_ref(
    cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
  )),
  f_str2tkns("[PAR:name]"),
  []
).

%%% P_TEST_R_TXT_UNIT_13

:- pred p_test_r_txt_unit_13 is semidet.
p_test_r_txt_unit_13 :- r_txt_unit(
  0u,
  ce_txt_unit_c_ref(cs_txt_unit_c_ref(
    cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
  )),
  f_str2tkns("[PAR:name], and more"),
  f_str2tkns(", and more")
).

%%% P_TEST_R_TXT_UNIT_14

:- pred p_test_r_txt_unit_14 is semidet.
p_test_r_txt_unit_14 :- r_txt_unit(
  0u,
  ce_txt_unit_emph(cs_txt_unit_emph("emphasized text")),
  f_str2tkns("*emphasized text*, and more"),
  f_str2tkns(", and more")
).

%%% P_TEST_R_TXT_UNIT_15

:- pred p_test_r_txt_unit_15 is semidet.
p_test_r_txt_unit_15 :- (
  r_txt_unit(
    0u,
    ce_txt_unit_emph(cs_txt_unit_emph("emphasized text")),
    f_str2tkns("*emphasized\ntext*, and more"),
    TKNS
  ),
  p_tkns_eq_up_to_line_no(TKNS,f_str2tkns(", and more"))
).

%%% P_TEST_R_TXT_UNITS_1

:- pred p_test_r_txt_units_1 is semidet.
p_test_r_txt_units_1 :- r_txt_units(
  0u,
  cs_txt_units([ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))]),
  f_str2tkns("HEJ!"),
  []
).

%%% P_TEST_R_TXT_UNITS_2

:- pred p_test_r_txt_units_2 is semidet.
p_test_r_txt_units_2 :- r_txt_units(
  0u,
  cs_txt_units([
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
    ce_txt_unit_c_ref(cs_txt_unit_c_ref(
      cs_c_ref(cr_id(cs_tag("DSP"),cs_name("name")))
    ))
  ]),
  f_str2tkns("HEJ![DSP:name]"),
  []
).

%%% P_TEST_R_TXT_UNITS_3

:- pred p_test_r_txt_units_3 is semidet.
p_test_r_txt_units_3 :- (
  r_txt_units(
    0u,
    cs_txt_units([
      ce_txt_unit_emph(cs_txt_unit_emph("HEJ! HAJ!")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("DSP"),cs_name("name")))
      )),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ!"))
    ]),
    f_str2tkns("*HEJ!\nHAJ!*[DSP:name]HAJ!\n"),
    TKNS_OUT
  ),
  p_tkns_eq_up_to_line_no(TKNS_OUT,f_str2tkns("\n"))
).

%%% P_TEST_R_TXT_UNITS_4

:- pred p_test_r_txt_units_4 is semidet.
p_test_r_txt_units_4 :-
  not r_txt_units(0u,_,f_str2tkns("\tHEJ![DSP:name]HAJ!\n"),_).

%%% P_TEST_R_TXT_UNITS_5

:- pred p_test_r_txt_units_5 is semidet.
p_test_r_txt_units_5 :- (
  r_txt_units(
    1u,
    cs_txt_units([
      ce_txt_unit_emph(cs_txt_unit_emph("HEJ!* HAJ!")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("DSP"),cs_name("name")))
      )),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ!"))
    ]),
    f_str2tkns("*HEJ!\\*\n\tHAJ!*[DSP:name]HAJ!\n"),
    TKNS_OUT
  ),
  p_tkns_eq_up_to_line_no(TKNS_OUT,f_str2tkns("\n"))
).

%%% P_TEST_R_TXT_UNITS_6

:- pred p_test_r_txt_units_6 is semidet.
p_test_r_txt_units_6 :- r_txt_units(
  0u,
  cs_txt_units([
    ce_txt_unit_emph(cs_txt_unit_emph("one")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_emph(cs_txt_unit_emph("two"))
  ]),
  f_str2tkns("*one* *two*"),
  []
).

%%% P_TEST_R_TXT_UNITS_7

:- pred p_test_r_txt_units_7 is semidet.
p_test_r_txt_units_7 :- r_txt_units(
  3u,
  cs_txt_units([
    ce_txt_unit_emph(cs_txt_unit_emph("one")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_emph(cs_txt_unit_emph("two"))
  ]),
  f_str2tkns("*one* *two*"),
  []
).

%%% P_TEST_R_BLK_TXT_1

:- pred p_test_r_blk_txt_1 is semidet.
p_test_r_blk_txt_1 :- r_blk_txt(
    0u,
    cs_blk_txt(cs_txt_units([ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ"))])),
    f_str2tkns("HEJ\n"),
    []
).

%%% P_TEST_R_BLK_TXT_2

:- pred p_test_r_blk_txt_2 is semidet.
p_test_r_blk_txt_2 :- r_blk_txt(
  100u,
  cs_blk_txt(cs_txt_units([ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))])),
  f_str2tkns("HEJ!\n"),
  []
).

%%% P_TEST_R_BLK_TXT_3

:- pred p_test_r_blk_txt_3 is semidet.
p_test_r_blk_txt_3 :- r_blk_txt(
  2u,
  cs_blk_txt(cs_txt_units([
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("OCH HEJ IGEN!"))
  ])),
  f_str2tkns("HEJ!\n\t\tOCH HEJ IGEN!\n"),
  []
).

%%% P_TEST_R_BLK_TXT_4

:- pred p_test_r_blk_txt_4 is semidet.
p_test_r_blk_txt_4 :- r_blk_txt(
  100u,
  cs_blk_txt(cs_txt_units([
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ ")),
    ce_txt_unit_c_ref(cs_txt_unit_c_ref(
      cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name"))))
    ),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("!"))
  ])),
  f_str2tkns("HEJ [PAR:name]!\n"),
  []
).

%%% P_TEST_R_BLK_TXT_5

:- pred p_test_r_blk_txt_5 is semidet.
p_test_r_blk_txt_5 :- (
  r_blk_txt(
    1u,
    cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ ")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      )),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("!")),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("DSP"),cs_name("name")))
      ))
    ])),
    f_str2tkns("HEJ [PAR:name]!\n\t[DSP:name]\n\n"),
    TKNS_OUT
  ),
  p_tkns_eq_up_to_line_no(TKNS_OUT,f_str2tkns("\n"))
).

%%% P_TEST_R_BLK_TXT_6

:- pred p_test_r_blk_txt_6 is semidet.
p_test_r_blk_txt_6 :- r_blk_txt(
  2u,
  cs_blk_txt(cs_txt_units([
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("OCH HEJ IGEN"))
  ])),
  f_str2tkns("HEJ!\n\t\tOCH HEJ IGEN\n"),
  []
).

%%% P_TEST_R_BLK_TXT_7

:- pred p_test_r_blk_txt_7 is semidet.
p_test_r_blk_txt_7 :- r_blk_txt(
  0u,
  cs_blk_txt(cs_txt_units([
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ ")),
    ce_txt_unit_c_ref(cs_txt_unit_c_ref(
      cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
    )),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("!")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_c_ref(cs_txt_unit_c_ref(
      cs_c_ref(cr_id(cs_tag("DSP"),cs_name("name")))
    )),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HOJ"))
  ])),
  f_str2tkns("HEJ\nHAJ [PAR:name]!\n[DSP:name]\nHOJ\n"),
  []
).

%%% P_TEST_R_BLK_1

:- pred p_test_r_blk_1 is semidet.
p_test_r_blk_1 :- r_blk(
  0u,
  ce_blk_txt(cs_blk_txt(cs_txt_units([
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
  ]))),
  f_str2tkns("HEJ!\nHEJ!\n"),
  []
).

%%% P_TEST_R_BLKS_1

:- pred p_test_r_blks_1 is semidet.
p_test_r_blks_1 :- r_blks(
  0u,
  cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ])))
  ]),
  f_str2tkns("HEJ!\n"),
  []
).

%%% P_TEST_R_BLKS_2

:- pred p_test_r_blks_2 is semidet.
p_test_r_blks_2 :- r_blks(
  0u,
  cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      ))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ])))
  ]),
  f_str2tkns("HEJ![PAR:name]\n\nHEJ!\n"),
  []
).

%%% P_TEST_R_BLKS_3

:- pred p_test_r_blks_3 is semidet.
p_test_r_blks_3 :- r_blks(
  2u,
  cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      ))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ])))
  ]),
  f_str2tkns("HEJ![PAR:name]\n\n\t\tHEJ!\n"),
  []
).

%%% P_TEST_R_BLKS_4

:- pred p_test_r_blks_4 is semidet.
p_test_r_blks_4 :- r_blks(
  2u,
  cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      ))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ])))
  ]),
  f_str2tkns("HEJ![PAR:name]\n\n\n\n\t\tHEJ!\n"),
  []
).

%%% P_TEST_R_BLKS_5

:- pred p_test_r_blks_5 is semidet.
p_test_r_blks_5 :- r_blks(
  1u,
  cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      ))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ])))
  ]),
  f_str2tkns("HEJ![PAR:name]\n\n\tHEJ!\n"),
  []
).

%%% P_TEST_R_BLKS_6

:- pred p_test_r_blks_6 is semidet.
p_test_r_blks_6 :- r_blks(
  1u,
  cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      ))
    ]))),
    ce_blk_itm(cr_blk_itm(
      ce_lbl_auto,
      maybe.no,
      cs_blks([
        ce_blk_dsp(cs_blk_dsp(cs_dsp_lines([
          ce_dsp_line_lbld(cr_dsp_line_lbld(
            ce_lbl_auto,
            maybe.no,
            cs_txt_units([
              ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("a²+b²=c²"))
            ])
          ))
        ])))
      ])
    ))
  ]),
  (
    f_str2tkns("HEJ![PAR:name]\n")
    ++
    f_str2tkns("\n")
    ++
    f_str2tkns("\t[]\t()\ta²+b²=c²\n")
  ),
  []
).

%%% P_TEST_R_BLK_BLT_1

:- pred p_test_r_blk_blt_1 is semidet.
p_test_r_blk_blt_1 :- r_blk_blt(
  0u,
  cs_blk_blt(cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ])))
  ])),
  f_str2tkns("-\tHEJ!\n"),
  []
).

%%% P_TEST_R_BLK_BLT_2

:- pred p_test_r_blk_blt_2 is semidet.
p_test_r_blk_blt_2 :- r_blk_blt(
  1u,
  cs_blk_blt(cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ!"))
    ])))
  ])),
  f_str2tkns("-\tHEJ!\n\t\tHAJ!\n"),
  []
).

%%% P_TEST_R_BLK_BLT_3

:- pred p_test_r_blk_blt_3 is semidet.
p_test_r_blk_blt_3 :- r_blk_blt(
  2u,
  cs_blk_blt(cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!")),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ!"))
    ])))
  ])),
  f_str2tkns("-\tHEJ!\n\t\t\tHAJ!\n"),
  []
).

%%% P_TEST_R_BLK_BLT_4

:- pred p_test_r_blk_blt_4 is semidet.
p_test_r_blk_blt_4 :- r_blk_blt(
  1u,
  cs_blk_blt(cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      )),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HOJ"))
    ])))
  ])),
  f_str2tkns("-\tHEJ!\n\n\n\n\n\t\tHAJ[PAR:name]\n\t\tHOJ\n"),
  []
).

%%% P_TEST_R_BLK_BLT_5

:- pred p_test_r_blk_blt_5 is semidet.
p_test_r_blk_blt_5 :- r_blk_blt(
  0u,
  cs_blk_blt(cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      )),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HOJ"))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HOJHOJ"))
    ])))
  ])),
  f_str2tkns("-\tHEJ!\n\n\tHAJ[PAR:name]\n\tHOJ\n\n\tHOJHOJ\n"),
  []
).

%%% P_TEST_R_BLK_BLT_6

:- pred p_test_r_blk_blt_6 is semidet.
p_test_r_blk_blt_6 :- r_blk_blt(
  1u,
  cs_blk_blt(cs_blks([
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ!"))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ")),
      ce_txt_unit_c_ref(cs_txt_unit_c_ref(
        cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name")))
      ))
    ]))),
    ce_blk_txt(cs_blk_txt(cs_txt_units([
      ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HOJ"))
    ]))),
    ce_blk_blt(cs_blk_blt(cs_blks([
      ce_blk_txt(cs_blk_txt(cs_txt_units([
        ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ"))
      ])))
    ])))
  ])),
  f_str2tkns("-\tHEJ!\n\n\t\tHAJ[PAR:name]\n\n\t\tHOJ\n\n\t\t-\tHEJ\n"),
  []
).

%%% P_TEST_R_DOC_MAIN_1

:- pred p_test_r_doc_main_1 is semidet.
p_test_r_doc_main_1 :- r_doc_main(
    ce_doc_main_blks(cs_blks([
      ce_blk_txt(cs_blk_txt(cs_txt_units([
        ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HOJ!")),
        ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
        ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ!"))
      ]))),
      ce_blk_blt(cs_blk_blt(cs_blks([
        ce_blk_txt(cs_blk_txt(cs_txt_units([
          ce_txt_unit_emph(cs_txt_unit_emph("TJO TJO"))
        ])))
      ])))
    ])),
    f_str2tkns("HOJ!\nHAJ!\n\n-\t*TJO\n\tTJO*\n") ++ [nmm.lexer.c_tkn_eof],
    []
).

%%% P_TEST_R_HDR_1

:- pred p_test_r_hdr_1 is semidet.
p_test_r_hdr_1 :- r_hdr(
  cs_hdr(cs_txt_units([
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HEJ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HAJ ")),
    ce_txt_unit_c_ref(
      cs_txt_unit_c_ref(cs_c_ref(cr_id(cs_tag("PAR"),cs_name("name"))))
    ),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("!")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_c_ref(
      cs_txt_unit_c_ref(cs_c_ref(cr_id(cs_tag("DSP"),cs_name("name"))))
    ),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg(" ")),
    ce_txt_unit_wysiwyg(cs_txt_unit_wysiwyg("HOJ"))
  ])),
  f_str2tkns("HEJ\nHAJ [PAR:name]!\n[DSP:name]\nHOJ\n"),
  []
).



%%% THE PREDICATE

:- pred p_test(io.io::di, io.io::uo) is det.
p_test(!IO) :- (
  (
    if not p_test_r_tag_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_tag_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_tag_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_tag_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_tag_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_tag_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_tag_4 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_tag_4 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_name_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_name_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_name_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_name_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_name_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_name_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_name_4 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_name_4 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_name_5 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_name_5 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_id_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_id_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_id_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_id_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_id_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_id_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_id_4 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_id_4 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_c_ref_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_c_ref_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_c_ref_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_c_ref_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_c_ref_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_c_ref_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_4 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_4 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_5 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_5 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_6 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_6 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_7 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_7 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_8 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_8 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_9 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_9 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_10 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_10 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_11 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_11 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_12 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_12 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_13 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_13 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_14 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_14 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_unit_15 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_unit_15 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_units_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_units_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_units_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_units_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_units_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_units_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_units_4 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_units_4 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_units_5 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_units_5 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_units_6 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_units_6 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_txt_units_7 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_txt_units_7 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_txt_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_txt_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_txt_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_txt_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_txt_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_txt_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_txt_4 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_txt_4 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_txt_5 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_txt_5 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_txt_6 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_txt_6 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_txt_7 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_txt_7 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blks_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blks_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blks_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blks_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blks_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blks_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blks_4 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blks_4 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blks_5 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blks_5 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blks_6 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blks_6 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_blt_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_blt_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_blt_2 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_blt_2 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_blt_3 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_blt_3 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_blt_4 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_blt_4 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_blt_5 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_blt_5 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_blk_blt_6 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_blk_blt_6 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_doc_main_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_doc_main_1 failed\n",!IO)
    else
      true
  ),
  (
    if not p_test_r_hdr_1 then
      io.set_exit_status(1,!IO),
      io.write_string("p_test_r_hdr_1 failed\n",!IO)
    else
      true
  )
).

%% P

p(!IO) :-
  io.write_string("TODO: parser tests\n",!IO)
  ,
  nmm.parser.helpers.test.p(!IO)
  ,
  nmm.parser.operators.test.p(!IO)
  ,
  p_test(!IO)
  .
