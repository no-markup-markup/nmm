:- module nmm.cli.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module io.


%% MAIN

:- pred main(io.io::di,io.io::uo) is det.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module
  term_to_xml
  ,
  nmm.lexer
  ,
  nmm.parser
  ,
  nmm.test
  .


%% TYPE ABBREVIATIONS T_TKN AND T_TKNS

:- type t_tkn  == nmm.lexer.t_tkn.
:- type t_tkns == nmm.lexer.t_tkns.


%% P_WRITE_USAGE

:- pred p_write_usage(io.io::di,io.io::uo) is det.
p_write_usage(!IO) :-
  io.progname_base("nmm-mercury",BIN_NAME,!IO),
  io.write_string("Usages:\n",                                        !IO),
  io.write_string("  " ++ BIN_NAME ++ " -h\n",                        !IO),
  io.write_string("  " ++ BIN_NAME ++ " --help\n",                    !IO),
  io.write_string("  " ++ BIN_NAME ++ " test\n",                      !IO),
  io.write_string("  " ++ BIN_NAME ++ " nmm2xml path-to-nmm-source\n",!IO).


%% P_PARSE

%%% TYPE T_LEX_FILE_RES AND HELPER P_LEX_FILE

:- type t_lex_file_res --->
  c_lex_file_res_ok(t_tkns);
  c_lex_file_res_err(str).

:- pred p_lex_file(str::in,   t_lex_file_res::out, io.io::di, io.io::uo) is det.
p_lex_file(        FILE_PATH, RES,                 !IO) :-
  io.read_named_file_as_string(FILE_PATH,RES_,!IO),
  (
    (
      RES_ = io.error(ERR_CODE),
      RES  = c_lex_file_res_err(io.error_message(ERR_CODE))
    );
    (
      RES_         = io.ok(FILE_AS_STR),
      TKNS_OR_ERRS = nmm.lexer.f_tknize(str2chrs(FILE_AS_STR)),
      (
        (
          TKNS_OR_ERRS = nmm.lexer.c_tknize_res_err(ERR_MSG),
          RES          = c_lex_file_res_err(ERR_MSG)
        );
        (
          TKNS_OR_ERRS = nmm.lexer.c_tknize_res_ok(TKNS),
          RES          = c_lex_file_res_ok(TKNS)
        )
      )
    )
  ).

%%% CONSTANT K_VALID_TAGS_COMMON

:- func k_valid_tags_common = strs.
k_valid_tags_common = [
  "ABBR",  % abbreviation
  "ABBRS",
  "ASM",   % assumption
  "ASMS",
  "CONV",  % convention
  "CONVS",
  "COR",   % corollary
  "CORS",
  "DEF",   % definition
  "DEFS",
  "EX",    % example
  "EXS",
  "FCT",   % fact
  "FCTS",
  "LMA",   % lemma
  "LMAS",
  "NTN",   % notation
  "NTNS",
  "PRF",   % proof
  "PRFS",
  "PRP",   % proposition
  "PRPS",
  "Q",     % question
  "QS",
  "RMK",   % remark
  "RMKS",
  "THM",   % theorem
  "THMS",
  "TMY",   % terminology
  "TODO",
  "TODOS"
].

%%% CONSTANT K_VALID_TAGS

:- func k_valid_tags = nmm.parser.t_valid_tags.
k_valid_tags = VALID_TAGS :-
  nmm.parser.fld_valid_tags_ch(VALID_TAGS)  = k_valid_tags_common++["CH"],
  nmm.parser.fld_valid_tags_sec(VALID_TAGS) = k_valid_tags_common++["SEC"],
  nmm.parser.fld_valid_tags_app(VALID_TAGS) = k_valid_tags_common++["APP"],
  nmm.parser.fld_valid_tags_par(VALID_TAGS) = k_valid_tags_common++["PAR"],
  nmm.parser.fld_valid_tags_itm(VALID_TAGS) = k_valid_tags_common++["ITM"],
  nmm.parser.fld_valid_tags_dsp(VALID_TAGS) = k_valid_tags_common++["DSP"].

%%% HELPER P_PARSE_AS_FAR_AS_POSSIBLE

:- pred p_parse_as_far_as_possible(
  t_tkns, nmm.lexer.t_line_no, nmm.parser.t_doc_main
).
:- mode p_parse_as_far_as_possible(
  in,     out,                 out
) is semidet.
p_parse_as_far_as_possible(
  TKNS,   LINE_NO_BEFORE_FAIL, DOC_MAIN
) :- (
  list.last(TKNS,LAST_TKN),
  (
    if (
      nmm.parser.r_doc_main(
        DOC_MAIN_,
        k_valid_tags,
        TKNS++[nmm.lexer.c_tkn_eof],
        []
      )
    ) then (
      DOC_MAIN = DOC_MAIN_,
      nmm.lexer.p_tkn_line_no(LAST_TKN,LINE_NO_BEFORE_FAIL)
    ) else (
      list.remove_suffix(TKNS,[LAST_TKN],TKNS_),
      p_parse_as_far_as_possible(TKNS_,LINE_NO_BEFORE_FAIL,DOC_MAIN)
    )
  )
).

%%% HELPER P_HANDLE_PARSE_FAILURE

:- pred p_handle_parse_failure(t_tkns::in, io.io::di, io.io::uo) is det.
p_handle_parse_failure(        TKNS,       !IO) :-
  io.set_exit_status(1,!IO),
  io.write_string(
    io.stderr_stream,
    (
      "Parsing failed.\n"
      ++
      "Trying to parse as far as possible.\n"
      ++
      "This may take a while (slow implementation because of lazy developer).\n"
    ),
    !IO
  ),
  (
    if p_parse_as_far_as_possible(TKNS,LINE_NO_BEFORE_FAIL,DOC_MAIN) then (
      io.write_string(io.stderr_stream,"\n",                            !IO),
      term_to_xml.write_xml_doc(io.stderr_stream,DOC_MAIN,              !IO),
      io.write_string(io.stderr_stream,"\n",                            !IO),
      io.write_string(io.stderr_stream,"Parsing succeeded up to line ", !IO),
      io.write_uint(  io.stderr_stream,LINE_NO_BEFORE_FAIL,             !IO),
      io.write_string(io.stderr_stream,".\n",                           !IO)
    ) else (
      io.write_string(io.stderr_stream,"Parsing failed completely :(\n",!IO)
    )
  ).

%%% THE PREDICATE

:- pred p_parse(str::in,   io.io::di, io.io::uo) is det.
p_parse(        FILE_PATH, !IO) :-
  p_lex_file(FILE_PATH,RES,!IO),
  (
    (
      RES = c_lex_file_res_err(ERR),
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,ERR,!IO)
    );
    (
      RES = c_lex_file_res_ok(TKNS),
      (
        nmm.parser.r_doc_main(DOC_MAIN,k_valid_tags,TKNS,[]) -> (
          term_to_xml.write_xml_doc(io.stdout_stream,DOC_MAIN,!IO)
        );
        p_handle_parse_failure(TKNS,!IO)
      )
    )
  ).


%% P_TEST

:- pred p_test(io.io::di, io.io::uo) is det.
p_test(!IO) :-
  io.set_exit_status(1,!IO),
  io.write_string(io.stderr_stream,"TODO!\n",!IO).

%% MAIN

main(!IO) :-
  io.command_line_arguments(ARGS,!IO),
  (
    ARGS = ["nmm2xml",FILE_PATH_AS_STR] -> p_parse(FILE_PATH_AS_STR,!IO);
    ARGS = ["test"]                     -> p_test(!IO);
    ARGS = ["-h"]                       -> p_write_usage(!IO);
    ARGS = ["--help"]                   -> p_write_usage(!IO);
                                           p_write_usage(!IO)
  ).
