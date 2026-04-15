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

:- use_module dir, exception, term_to_xml, nmm.lexer, nmm.parser, nmm.test.


%% TYPE ABBREVIATIONS TU_TKN AND TS_TKNS

:- type tu_tkn  == nmm.lexer.tu_tkn.
:- type ts_tkns == nmm.lexer.ts_tkns.


%% P_WRITE_USAGE

:- pred p_write_usage(io.io::di,io.io::uo) is det.
p_write_usage(!IO) :-
  io.progname_base("nmm-mercury",BIN_NAME,!IO),
  io.write_string("Usages:\n",                                        !IO),
  io.write_string("  " ++ BIN_NAME ++ " nmm2xml path-to-nmm-source\n",!IO),
  io.write_string("  " ++ BIN_NAME ++ " lex2txt path-to-nmm-source\n",!IO),
  io.write_string("  " ++ BIN_NAME ++ " test\n",                      !IO),
  io.write_string("  " ++ BIN_NAME ++ " version\n",                   !IO),
  io.write_string("  " ++ BIN_NAME ++ " --version\n",                 !IO),
  io.write_string("  " ++ BIN_NAME ++ " help\n",                      !IO),
  io.write_string("  " ++ BIN_NAME ++ " -h\n",                        !IO),
  io.write_string("  " ++ BIN_NAME ++ " --help\n",                    !IO).



%% UNION TYPE TU_LEX_FILE_RES AND HELPER P_LEX_FILE

:- type tu_lex_file_res --->
  cu_lex_file_res_ok(ts_tkns);
  cu_lex_file_res_err(str).

:- pred p_lex_file(str,       tu_lex_file_res, io.io, io.io).
:- mode p_lex_file(in,        out,             di,    uo) is det.
p_lex_file(        FILE_PATH, RES,             !IO) :-
  io.read_named_file_as_string(FILE_PATH,RES_,!IO),
  (
    (
      RES_ = io.error(ERR_CODE),
      RES  = cu_lex_file_res_err(io.error_message(ERR_CODE))
    );
    (
      RES_         = io.ok(FILE_AS_STR),
      TKNS_OR_ERRS = nmm.lexer.f_tknize(str2chrs(FILE_AS_STR)),
      (
        (
          TKNS_OR_ERRS = nmm.lexer.cu_tknize_res_err(ERR_MSG),
          RES          = cu_lex_file_res_err(ERR_MSG)
        );
        (
          TKNS_OR_ERRS = nmm.lexer.cu_tknize_res_ok(TKNS),
          RES          = cu_lex_file_res_ok(TKNS)
        )
      )
    )
  ).


%% P_LEX

:- pred p_lex(str::in,   io.io::di, io.io::uo) is det.
p_lex(        FILE_PATH, !IO) :-
  p_lex_file(FILE_PATH,RES,!IO),
  (
    (
      RES = cu_lex_file_res_err(ERR),
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,ERR,!IO),
      io.write_string("\n",!IO)
    );
    (
      RES = cu_lex_file_res_ok(TKNS),
      io.write_string(nmm.lexer.f_tkns2str(TKNS),!IO)
    )
  ).


%% P_PARSE

%%% HELPER P_PARSE_TAGS_FILE

:- pred p_parse_tags_file(nmm.parser.ts_allowed_tags, io.io, io.io).
:- mode p_parse_tags_file(out,                        di,    uo) is det.
p_parse_tags_file(        TAGS,                       !IO) :- (
  io.progname(
    "DpsDpah9yYRgO5nAukY48e2l6ENJkURSLEZIfbukE0CYFc9ICT6rZQusFjXne",
    PROG_NAME,
    !IO
  ),
  (
    PROG_NAME \= "DpsDpah9yYRgO5nAukY48e2l6ENJkURSLEZIfbukE0CYFc9ICT6rZQusFjXne"
    ;
    exception.throw("could not get binary's path")
  ),
  dir.directory_separator(SEP_CHR),
  TAGS_FILE_PATH = dir.dirname(PROG_NAME) ++ chr2str(SEP_CHR) ++ "tags.tsv",
  io.read_named_file_as_string(TAGS_FILE_PATH,RES,!IO),
  (
    (
      RES = io.error(ERR_CODE),
      io.error_message(ERR_CODE,ERR_STR),
      io.write_string("cannot open tags.tsv\n",!IO),
      exception.throw(ERR_STR)
    );
    (
      RES        = io.ok(FILE_AS_STR),
      LINES      = string.split_into_lines(FILE_AS_STR),
      TAG_PAIRS  = list.map(
        (
          func(LINE::in) = (TAG_PAIR::out) is det :- (
            (
              TAB_SEPARATED_VALUES              =
                string.split_at_char('\t',LINE),
              [TAG_SINGULAR,TAG_PLURAL,_,_,_,_] = TAB_SEPARATED_VALUES,
              TAG_PAIR                          = [TAG_SINGULAR,TAG_PLURAL]
            )
            ;
            (
              exception.throw("failed to parse tag file line:\n\t" ++ LINE)
            )
          )
        ),
        LINES
      ),
      TAGS_ = list.condense(TAG_PAIRS),
      list.filter((pred(TAG::in) is semidet :- TAG \= ""),TAGS_,TAGS__),
      TAGS  = nmm.parser.cs_allowed_tags(TAGS__)
    )
  )
).

%%% HELPER P_PARSE_AS_FAR_AS_POSSIBLE

:- pred p_parse_as_far_as_possible(
  nmm.parser.ts_allowed_tags, ts_tkns, nmm.lexer.ta_line_no, nmm.parser.tr_doc
).
:- mode p_parse_as_far_as_possible(
  in,                         in,      out,                  out
) is semidet.
p_parse_as_far_as_possible(
  TAGS,            TKNS,    LINE_NO_BEFORE_FAIL,  DOC
) :- (
  % remove one token at a time from end of source, until parsing succeeds
  % this is very inefficient
  % a binary search for longest possible parsing ought to be performed instead
  list.last(TKNS,LAST_TKN),
  (
    if nmm.parser.r_doc(TAGS,DOC_,TKNS++[nmm.lexer.cu_tkn_eof],[]) then (
      DOC = DOC_,
      nmm.lexer.p_tkn_line_no(LAST_TKN,LINE_NO_BEFORE_FAIL)
    ) else (
      list.remove_suffix(TKNS,[LAST_TKN],TKNS_),
      p_parse_as_far_as_possible(TAGS,TKNS_,LINE_NO_BEFORE_FAIL,DOC)
    )
  )
).

%%% HELPER P_HANDLE_PARSE_FAILURE

:- pred p_handle_parse_failure(
  ts_tkns, nmm.parser.ts_allowed_tags, io.io, io.io
).
:- mode p_handle_parse_failure(
  in,      in,                         di,    uo
) is det.
p_handle_parse_failure(
  TKNS,    TAGS,                       !IO
) :-
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
    if p_parse_as_far_as_possible(TAGS,TKNS,LINE_NO_BEFORE_FAIL,DOC) then (
      io.write_string(io.stderr_stream,"\n",                            !IO),
      term_to_xml.write_xml_doc(io.stderr_stream,DOC,                   !IO),
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
  p_parse_tags_file(TAGS,!IO),
  p_lex_file(FILE_PATH,RES,!IO),
  (
    (
      RES = cu_lex_file_res_err(ERR),
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,ERR,!IO),
      io.write_string("\n",!IO)
    );
    (
      RES = cu_lex_file_res_ok(TKNS),
      (
        if nmm.parser.r_doc(TAGS,DOC,TKNS,[]) then
          term_to_xml.write_xml_doc(io.stdout_stream,DOC,!IO)
        else
          p_handle_parse_failure(TKNS,TAGS,!IO)
      )
    )
  ).


%% P_TEST

:- pred p_test(io.io::di, io.io::uo) is det.
p_test(!IO) :- nmm.test.p(!IO).


%% P_WRITE_VERSION

:- pred p_write_version(io.io::di, io.io::uo) is det.
p_write_version(!IO) :-
  io.write_string(io.stderr_stream,"-1\n",!IO).


%% MAIN

main(!IO) :-
  io.command_line_arguments(ARGS,!IO),
  (
    ARGS = ["nmm2xml",FILE_PATH_AS_STR] -> p_parse(FILE_PATH_AS_STR,!IO);
    ARGS = ["lex2txt",FILE_PATH_AS_STR] -> p_lex(FILE_PATH_AS_STR,!IO);
    ARGS = ["test"]                     -> p_test(!IO);
    ARGS = ["version"]                  -> p_write_version(!IO);
    ARGS = ["--version"]                -> p_write_version(!IO);
    ARGS = ["help"]                     -> p_write_usage(!IO);
    ARGS = ["-h"]                       -> p_write_usage(!IO);
    ARGS = ["--help"]                   -> p_write_usage(!IO);
    ARGS = ["test-read-tags.tsv"]       -> (
      p_parse_tags_file(TAGS,!IO),
      io.write(TAGS,!IO),
      io.write_string("\n",!IO)
    );
                                           p_write_usage(!IO)
  ).
