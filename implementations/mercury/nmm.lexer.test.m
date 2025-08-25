:- module nmm.lexer.test.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.

%% USE MODULES

:- use_module io.


%% PREDICATE P_TEST

:- pred p_test(io.io::di,io.io::uo) is det.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION 

:- implementation.


%% USE MODULES

:- use_module nmm.lexer.


%% P_TEST

p_test(!IO) :-
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
          TKNS_OR_ERRS = c_tknize_res_err(ERR_MSG),
          io.write_string(ERR_MSG,!IO)
        );
        (
          TKNS_OR_ERRS = c_tknize_res_ok(TKNS),
          io.write_string(f_tkns2str(TKNS),!IO)
        )
      )
    )
  ).
