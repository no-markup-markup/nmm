:- module nmm.lexer.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% SUBMODULES

:- include_module lexer.test.


%% ALIAS TYPE TA_LINE_NO (= UINT)

:- type ta_line_no == uint.


%% UNION TYPE TU_TKN AND SIMPLE TYPE TS_TKNS

:- type tu_tkn --->
  cu_tkn_nws(ta_line_no,chr); % non-whitespace character
  cu_tkn_sp( ta_line_no,chr); % non-tab space character
  cu_tkn_esc(ta_line_no,chr); % escaped character
  cu_tkn_tab(ta_line_no);
  cu_tkn_lb( ta_line_no);     % line break
  cu_tkn_eof.

:- type ts_tkns == list(tu_tkn).


%% PREDICATE P_TKN_LINE_NO

:- pred p_tkn_line_no(tu_tkn::in,ta_line_no::out) is semidet.


%% UNION TYPE TU_TKNIZE_RES

:- type tu_tknize_res --->
  cu_tknize_res_ok(ts_tkns);
  cu_tknize_res_err(str).


%% FUNCTION F_TKNIZE

:- func f_tknize(chrs) = tu_tknize_res.

%% FUNCTION F_DETKNIZE

:- func f_detknize(ts_tkns) = str.


%% FUNCTION F_TKNS2STR

:- func f_tkns2str(ts_tkns) = str.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- import_module uint.

:- use_module exception, string.


%% P_TKN_LINE_NO

p_tkn_line_no(cu_tkn_nws(LINE_NO,_),LINE_NO).
p_tkn_line_no(cu_tkn_sp( LINE_NO,_),LINE_NO).
p_tkn_line_no(cu_tkn_esc(LINE_NO,_),LINE_NO).
p_tkn_line_no(cu_tkn_tab(LINE_NO),  LINE_NO).
p_tkn_line_no(cu_tkn_lb( LINE_NO),  LINE_NO).


%% F_TKNIZE

%%% THE FUNCTION

f_tknize(CHRS) = RES :- (
  p_tknize(1u,CHRS,[],[],TKNS,ERRS),
  (
    (
      ERRS = [],
      RES  = cu_tknize_res_ok(TKNS)
    );
      ERRS = [_|_],
      RES  = cu_tknize_res_err(string.join_list("\n",ERRS)++"\n")
  )
).

%%% HELPER PREDICATE P_TKNIZE

%%%% THE PREDICATE

:- pred p_tknize(ta_line_no, chrs, ts_tkns,  strs,    ts_tkns,  strs).
:- mode p_tknize(in,         in,   in,       in,      out,      out) is det.
p_tknize(        LINE_NO,    CHRS, TKNS_IN,  ERRS_IN, TKNS_OUT, ERRS_OUT) :- (
  if CHRS = [C|CHRS_TL],p_unsupported(char.to_int(C),CP,N) then
    ERRS_IN_NEW =
    (
      ERRS_IN
      ++
      [
        string.append_list([
          "line ",
          string.uint_to_string(LINE_NO),
          ": unsupported character ",
          CP,
          " ",
          N,
          "."
        ])
      ]
    ),
    p_tknize(LINE_NO,CHRS_TL,TKNS_IN,ERRS_IN_NEW,TKNS_OUT,ERRS_OUT)
  else if p_leading_esc_chr(CHRS,ESC_CHR,CHRS_TL) then
    TKNS_IN_NEW = TKNS_IN++[cu_tkn_esc(LINE_NO,ESC_CHR)],
    p_tknize(LINE_NO,CHRS_TL,TKNS_IN_NEW,ERRS_IN,TKNS_OUT,ERRS_OUT)
  else if p_leading_line_break(CHRS,CHRS_TL) then
    TKNS_IN_NEW = TKNS_IN++[cu_tkn_lb(LINE_NO)],
    p_tknize(LINE_NO+1u,CHRS_TL,TKNS_IN_NEW,ERRS_IN,TKNS_OUT,ERRS_OUT)
  else if CHRS = ['\t'|CHRS_TL] then
    TKNS_IN_NEW = TKNS_IN++[cu_tkn_tab(LINE_NO)],
    p_tknize(LINE_NO,CHRS_TL,TKNS_IN_NEW,ERRS_IN,TKNS_OUT,ERRS_OUT)
  else if CHRS = [C|CHRS_TL], p_sp_but_not_tab(C) then
    TKNS_IN_NEW = TKNS_IN++[cu_tkn_sp(LINE_NO,C)],
    p_tknize(LINE_NO,CHRS_TL,TKNS_IN_NEW,ERRS_IN,TKNS_OUT,ERRS_OUT)
  else (
    (
      CHRS = [C|CHRS_TL],
      p_tknize(
        LINE_NO,
        CHRS_TL,
        TKNS_IN++[cu_tkn_nws(LINE_NO,C)],
        ERRS_IN,
        TKNS_OUT,
        ERRS_OUT
      )
    );
    (
      CHRS     = [],
      TKNS_OUT = TKNS_IN++[cu_tkn_eof],
      ERRS_OUT = ERRS_IN
    )
  )
).

%%%% HELPER PREDICATE P_UNSUPPORTED

% these characters have difficult semantics
:- pred p_unsupported(int::in, str::out, str::out) is semidet.
p_unsupported(        0x000B,  "U+000B", "Vertical Tab").
p_unsupported(        0x000C,  "U+000C", "Form Feed").
p_unsupported(        0x2029,  "U+2029", "Paragraph Separator").

%%%% HELPER PREDICATE P_LEADING_ESC_CHR

:- pred p_leading_esc_chr(chrs::in, chr::out, chrs::out) is semidet.
p_leading_esc_chr(        CHRS_IN,  ESC_CHR,  CHRS_OUT) :-
  CHRS_IN = ['\\'|CHRS_1],
  (
    if CHRS_1 = ['C','H'|CHRS_2] then
      ESC_CHR  = 'C',
      CHRS_OUT = ['H'|CHRS_2]
    else if CHRS_1 = [C|CHRS_2], list.member(C,['§','¶','[','*','\\']) then
      ESC_CHR  = C,
      CHRS_OUT = CHRS_2
    else
      false
  ).

%%%% HELPER PREDICATE P_LEADING_LINE_BREAK

% see
% https://en.wikipedia.org/wiki/Newline#Unicode
% https://www.unicode.org/reports/tr14/tr14-32.html

:- func k_lf = chr. % line feed
:- func k_cr = chr. % carriage return
:- func k_nl = chr. % new line
:- func k_ls = chr. % line separator
k_lf = char.det_from_int(0x000A).
k_cr = char.det_from_int(0x000D).
k_nl = char.det_from_int(0x0085).
k_ls = char.det_from_int(0x2028).

:- pred p_leading_line_break(chrs::in,chrs::out) is semidet.
p_leading_line_break(        CHRS_IN, CHRS_OUT) :- (
  CHRS_IN = [k_cr,k_lf|CHRS] -> CHRS_OUT = CHRS;
  CHRS_IN = [k_lf     |CHRS] -> CHRS_OUT = CHRS;
  CHRS_IN = [k_cr     |CHRS] -> CHRS_OUT = CHRS;
  CHRS_IN = [k_nl     |CHRS] -> CHRS_OUT = CHRS;
  CHRS_IN = [k_ls     |CHRS] -> CHRS_OUT = CHRS;
  false
).

%%%% HELPER PREDICATE P_SP_BUT_NOT_TAB

% see
% https://en.wikipedia.org/wiki/Whitespace_character#Unicode

:- pred p_sp_but_not_tab(chr::in) is semidet.
p_sp_but_not_tab(char.det_from_int(0x0020)). % space
p_sp_but_not_tab(char.det_from_int(0x00A0)). % no break space
p_sp_but_not_tab(char.det_from_int(0x1680)). % ogham space mark
p_sp_but_not_tab(char.det_from_int(0x2000)). % en quad
p_sp_but_not_tab(char.det_from_int(0x2001)). % em quad
p_sp_but_not_tab(char.det_from_int(0x2002)). % en space
p_sp_but_not_tab(char.det_from_int(0x2003)). % em space
p_sp_but_not_tab(char.det_from_int(0x2004)). % 1/3 em space
p_sp_but_not_tab(char.det_from_int(0x2005)). % 1/4 em space
p_sp_but_not_tab(char.det_from_int(0x2006)). % 1/6 em space
p_sp_but_not_tab(char.det_from_int(0x2007)). % figure space
p_sp_but_not_tab(char.det_from_int(0x2008)). % punctuation space
p_sp_but_not_tab(char.det_from_int(0x2009)). % thin space
p_sp_but_not_tab(char.det_from_int(0x200A)). % hair space
p_sp_but_not_tab(char.det_from_int(0x202F)). % narrow no break space
p_sp_but_not_tab(char.det_from_int(0x205F)). % medium math space
p_sp_but_not_tab(char.det_from_int(0x3000)). % ideographic space


%% F_DETKNIZE

f_detknize(TKNS) = string.join_list("",list.map(f_detknize_tkn,TKNS)).

:- func f_detknize_tkn(tu_tkn)  = str.
f_detknize_tkn(cu_tkn_nws(_,C)) = chr2str(C).
f_detknize_tkn(cu_tkn_sp( _,C)) = chr2str(C).
f_detknize_tkn(cu_tkn_esc(_,C)) = "\\" ++ chr2str(C).
f_detknize_tkn(cu_tkn_tab(_))   =
  exception.throw("attempted detokenization of tab token").
f_detknize_tkn(cu_tkn_lb( _))   =
  exception.throw("attempted detokenization of line break token").
f_detknize_tkn(cu_tkn_eof)      =
  exception.throw("attempted detokenization of end-of-file token").


%% F_TKNS2STR

%%% THE FUNCTION

f_tkns2str(TKNS) = string.append_list(list.map(f_tkn2str,TKNS)).

%%% HELPER FUNCTION F_TKN2STR

:- func f_tkn2str(tu_tkn) = str.
f_tkn2str(cu_tkn_nws(_,C)) = S :- (
  if list.member(C,['␛','␉','␤','␄']) then
    S = string.append("␛",chr2str(C))
  else
    S = chr2str(C)
).
f_tkn2str(cu_tkn_sp(_,C))  = chr2str(C).
f_tkn2str(cu_tkn_esc(_,C)) = string.append("␛",chr2str(C)).
f_tkn2str(cu_tkn_tab(_))   = "␉\t".
f_tkn2str(cu_tkn_lb(_))    = "␤\n".
f_tkn2str(cu_tkn_eof)      = "␄\n".
