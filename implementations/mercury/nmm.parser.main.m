:- module nmm.parser.main.

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module term_to_xml.

:- import_module nmm.parser.blks.
:- import_module nmm.parser.lines.
:- import_module nmm.parser.misc.


%% R_DOC, TR_DOC, TR_DOC XMLABLE

:- type tr_doc ---> cr_doc(
  fld_doc_preamble :: maybe(ts_preamble),
  fld_doc_title    :: maybe(ts_title),
  fld_doc_authors  :: maybe(ts_authors),
  fld_doc_date     :: maybe(tu_date),
  fld_doc_abstract :: maybe(ts_abstract),
  fld_doc_main     :: tu_doc_main,
  fld_doc_refs     :: maybe(ts_refs)
).

:- pred r_doc(ts_allowed_tags, tr_doc, ts_tkns, ts_tkns).
:- mode r_doc(in,              out,    in,      out) is semidet.

:- instance term_to_xml.xmlable(tr_doc).


%% R_PREAMBLE, TS_PREAMBLE

:- type ts_preamble ---> cs_preamble(ts_preamble_lines).

:- pred r_preamble(ts_preamble, ts_tkns, ts_tkns).
:- mode r_preamble(out,         in,      out) is semidet.


%% R_PREAMBLE_LINES, TS_PREAMBLE_LINES

:- type ts_preamble_lines ---> cs_preamble_lines(list(ts_preamble_line)).

:- pred r_preamble_lines(ts_preamble_lines, ts_tkns, ts_tkns).
:- mode r_preamble_lines(out,               in,      out) is semidet.


%% R_PREAMBLE_LINE, TS_PREAMBLE_LINE

:- type ts_preamble_line ---> cs_preamble_line(str).

:- pred r_preamble_line(ts_preamble_line, ts_tkns, ts_tkns).
:- mode r_preamble_line(out,              in,      out) is semidet.


%% R_TITLE, TS_TITLE

:- type ts_title ---> cs_title(str).

:- pred r_title(ts_title, ts_tkns, ts_tkns).
:- mode r_title(out,      in,      out) is semidet.


%% R_AUTHORS, TS_AUTHORS

:- type ts_authors ---> cs_authors(list(ts_author)).

:- pred r_authors(ts_authors, ts_tkns, ts_tkns).
:- mode r_authors(out,        in,      out) is semidet.


%% R_AUTHOR, TS_AUTHOR

:- type ts_author ---> cs_author(str).

:- pred r_author(ts_author, ts_tkns, ts_tkns).
:- mode r_author(out,       in,      out) is semidet.


%% TS_DATE_AUTO

:- type ts_date_auto ---> cs_date_auto.


%% TS_DATE_CUSTOM

:- type ts_date_custom ---> cs_date_custom(str).


%% R_DATE, TU_DATE

:- type tu_date ---> (
  cu_date_auto(ts_date_auto)
  ;
  cu_date_custom(ts_date_custom)
).

:- pred r_date(tu_date, ts_tkns, ts_tkns).
:- mode r_date(out,     in,      out) is semidet.


%% R_ABSTRACT, TS_ABSTRACT

:- type ts_abstract ---> cs_abstract(ts_blks).

:- pred r_abstract(ts_allowed_tags, ts_abstract, ts_tkns, ts_tkns).
:- mode r_abstract(in,              out,         in,      out) is semidet.


%% R_REFS, TS_REFS

:- type ts_refs ---> cs_refs(ts_blks).

:- pred r_refs(ts_allowed_tags, ts_refs, ts_tkns, ts_tkns).
:- mode r_refs(in,              out,     in,      out) is semidet.


%% R_REFS_START_MARKER

:- pred r_refs_start_marker(ts_tkns, ts_tkns).
:- mode r_refs_start_marker(in,      out) is semidet.


%% R_DOC_MAIN, TU_DOC_MAIN

:- type tu_doc_main ---> (
  cu_doc_main_chs(ts_chs)
  ;
  cu_doc_main_secs(ts_secs)
  ;
  cu_doc_main_pars(ts_pars)
  ;
  cu_doc_main_blks(ts_blks)
).

:- pred r_doc_main(ts_allowed_tags, tu_doc_main, ts_tkns, ts_tkns).
:- mode r_doc_main(in,              out,         in,      out) is semidet.


%% R_CHS, TS_CHS

:- type ts_chs ---> cs_chs(list(tr_ch)).

:- pred r_chs(ts_allowed_tags, ts_chs, ts_tkns, ts_tkns).
:- mode r_chs(in,              out,    in,      out) is semidet.


%% R_SECS, TS_SECS

:- type ts_secs ---> cs_secs(list(tr_sec)).

:- pred r_secs(ts_allowed_tags, ts_secs, ts_tkns, ts_tkns).
:- mode r_secs(in,               out,    in,      out) is semidet.


%% R_PARS, TS_PARS

:- type ts_pars ---> cs_pars(list(tu_par)).

:- pred r_pars(ts_allowed_tags, ts_pars, ts_tkns, ts_tkns).
:- mode r_pars(in,              out,     in,      out) is semidet.


%% R_SECS_PARS_OR_BLKS, TU_SECS_PARS_OR_BLKS

:- type tu_secs_pars_or_blks ---> (
  cu_secs_pars_or_blks_secs(ts_secs)
  ;
  cu_secs_pars_or_blks_pars(ts_pars)
  ;
  cu_secs_pars_or_blks_blks(ts_blks)
).

:- pred r_secs_pars_or_blks(
  ts_allowed_tags, tu_secs_pars_or_blks, ts_tkns, ts_tkns
).
:- mode r_secs_pars_or_blks(
  in,              out,                  in,      out
) is semidet.


%% R_PARS_OR_BLKS, TU_PARS_OR_BLKS

:- type tu_pars_or_blks ---> (
  cu_pars_or_blks_pars(ts_pars)
  ;
  cu_pars_or_blks_blks(ts_blks)
).

:- pred r_pars_or_blks(ts_allowed_tags, tu_pars_or_blks, ts_tkns, ts_tkns).
:- mode r_pars_or_blks(
                       in,              out,             in,      out
) is semidet.


%% R_CH, TR_CH

:- type tr_ch ---> cr_ch(
  fld_ch_tag_or_id :: maybe(tu_tag_or_id)
  ,
  fld_ch_hdr       :: maybe(ts_hdr)
  ,
  fld_ch_main      :: tu_secs_pars_or_blks
).

:- pred r_ch(ts_allowed_tags, tr_ch,  ts_tkns, ts_tkns).
:- mode r_ch(in,              out,    in,      out) is semidet.


%% R_SEC, TR_SEC

:- type tr_sec ---> cr_sec(
  fld_sec_tag_or_id :: maybe(tu_tag_or_id)
  ,
  fld_sec_hdr       :: maybe(ts_hdr)
  ,
  fld_sec_main      :: tu_pars_or_blks
).

:- pred r_sec(ts_allowed_tags, tr_sec, ts_tkns, ts_tkns).
:- mode r_sec(in,              out,    in,      out) is semidet.


%% R_PAR, TU_PAR

:- type tu_par ---> (
  cu_par_std(tr_par_std)
  ;
  cu_par_rpt(ts_par_rpt)
).

:- pred r_par(ts_allowed_tags, tu_par, ts_tkns, ts_tkns).
:- mode r_par(in,              out,    in,      out) is semidet.


%% R_PAR_STD, TR_PAR_STD

:- type tr_par_std ---> cr_par_std(
  fld_par_tag_or_id :: maybe(tu_tag_or_id)
  ,
  fld_par_hdr       :: maybe(ts_hdr)
  ,
  fld_par_main      :: ts_blks
).

:- pred r_par_std(ts_allowed_tags, tr_par_std, ts_tkns, ts_tkns).
:- mode r_par_std(in,              out,        in,      out) is semidet.


%% R_PAR_RPT, TS_PAR_RPT

:- type ts_par_rpt ---> cs_par_rpt(tr_id).

:- pred r_par_rpt(ts_allowed_tags, ts_par_rpt, ts_tkns, ts_tkns).
:- mode r_par_rpt(in,              out,        in,      out) is semidet.


%% R_HDR, TS_HDR

:- type ts_hdr ---> cs_hdr(ts_txt_lines).

:- pred r_hdr(ts_allowed_tags, ts_hdr, ts_tkns, ts_tkns).
:- mode r_hdr(in,              out,    in,      out) is semidet.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module nmm.lexer.
:- use_module nmm.parser.operators.
:- use_module nmm.parser.xml.

:- import_module nmm.parser.helpers.
:- import_module nmm.parser.operators.plus.
:- import_module nmm.parser.operators.q_mark.
:- import_module nmm.parser.operators.star.


%% R_DOC, TR_DOC XMLABLE

%%% R_DOC

r_doc(
  ALLOWED_TAGS,
  cr_doc(
    MAYBE_PREAMBLE,
    MAYBE_TITLE,
    MAYBE_AUTHORS,
    MAYBE_DATE,
    MAYBE_ABSTRACT,
    MAIN,
    MAYBE_REFS
  )
) --> (
  ?([],         r_preamble,             MAYBE_PREAMBLE,[*([r_lb])]),
  ?([],         r_title,                MAYBE_TITLE,   [*([r_lb])]),
  ?([],         r_authors,              MAYBE_AUTHORS, [*([r_lb])]),
  ?([],         r_date,                 MAYBE_DATE,    [*([r_lb])]),
  ?([],         r_abstract,ALLOWED_TAGS,MAYBE_ABSTRACT,[*([r_lb])]),
  r_doc_main(ALLOWED_TAGS,MAIN),
  ?([+([r_lb])],r_refs,    ALLOWED_TAGS,MAYBE_REFS,    []),
  *([r_lb]),
  r_eof
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_doc) where [
  to_xml(DOC) = nmm.parser.xml.f_to_xml(DOC)
].


%% R_PREAMBLE

r_preamble(cs_preamble(PREAMBLE_LINES)) --> (
  r_str("START"), r_tab, r_str("PREAMBLE"), r_lb,
  r_preamble_lines(PREAMBLE_LINES),
  r_str("END"),   r_tab, r_str("PREAMBLE"), r_lb
).


%% R_PREAMBLE_LINES

r_preamble_lines(cs_preamble_lines(PREAMBLE_LINES)) --> (
  +([],r_preamble_line,PREAMBLE_LINES,[])
).


%% R_PREAMBLE_LINE

r_preamble_line(cs_preamble_line(STR)) --> (
  r_tab, r_tkns_line(TKNS) -> {STR = nmm.lexer.f_detknize(TKNS)};
  r_lb                     -> {STR = ""};
                              {false}
).


%% R_TITLE

%%% R_TITLE

r_title(cs_title(STR)) --> (
  r_str("TITLE:"),
  +([r_lb]),
  +([r_tab],r_title_line,LINES,[]),
  {STR = string.join_list(" ",LINES)}
).

%%% HELPER R_TITLE_LINE

:- pred r_title_line(str::out, ts_tkns::in, ts_tkns::out) is semidet.
r_title_line(        LINE) -->
  +([],r_title_line_chr,CS,[]), r_lb, {LINE = chrs2str(CS)}.

% needed because some mode error otherwise
:- pred r_title_line_chr(chr::out, ts_tkns::in, ts_tkns::out) is semidet.
r_title_line_chr(        C) --> r_c(C).


%% R_AUTHORS

r_authors(cs_authors(AUTHORS)) --> +([],r_author,AUTHORS,[?([r_lb])]).


%% R_AUTHOR

%%% R_AUTHOR

r_author(cs_author(STR)) --> (
  r_str("AUTHOR:"),
  +([r_lb]),
  +([r_tab],r_author_line,LINES,[]),
  {STR = string.join_list(" ",LINES)}
).

%%% HELPER R_AUTHOR_LINE

:- pred r_author_line(str::out, ts_tkns::in, ts_tkns::out) is semidet.
r_author_line(        LINE) -->
  +([],r_author_line_chr,CS,[]), r_lb, {LINE = chrs2str(CS)}.

% needed because some mode error otherwise
:- pred r_author_line_chr(chr::out, ts_tkns::in, ts_tkns::out) is semidet.
r_author_line_chr(        C) --> r_c(C).


%% R_DATE

r_date(DATE) --> (
  r_str("DATE:"),
  +([r_lb]),
  r_tab,
  (
    r_str("auto")  -> {DATE = cu_date_auto(cs_date_auto)};
    r(STR)         -> {DATE = cu_date_custom(cs_date_custom(STR))};
                      {false}
  ),
  r_lb
).


%% R_ABSTRACT

r_abstract(ALLOWED_TAGS,cs_abstract(BLKS)) --> (
  r_str("ABSTRACT:"),
  +([r_lb]),
  r_tab,
  r_blks(ALLOWED_TAGS,1u,BLKS)
).


%% R_REFS

r_refs(ALLOWED_TAGS,cs_refs(BLKS)) -->
  r_refs_start_marker, +([r_lb]), r_blks(ALLOWED_TAGS,0u,BLKS).


%% R_REFS_START_MARKER

r_refs_start_marker --> (
  r_str("CH"), +([r_sp]), r_str("REFS"), r_lb -> {true};
  r_str("§"),  +([r_sp]), r_str("REFS"), r_lb -> {true};
  r_str("¶"),  +([r_sp]), r_str("REFS"), r_lb -> {true};
                                                 {false}
).


%% R_DOC_MAIN

r_doc_main(ALLOWED_TAGS,DOC_MAIN) --> (
  r_chs( ALLOWED_TAGS,   CHS)  -> {DOC_MAIN = cu_doc_main_chs( CHS)};
  r_secs(ALLOWED_TAGS,   SECS) -> {DOC_MAIN = cu_doc_main_secs(SECS)};
  r_pars(ALLOWED_TAGS,   PARS) -> {DOC_MAIN = cu_doc_main_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) -> {DOC_MAIN = cu_doc_main_blks(BLKS)};
                                  {false}
).


%% R_CHS

r_chs(ALLOWED_TAGS,CHS) --> (
  r_ch(ALLOWED_TAGS,CH),
  (
    +([r_lb]), r_chs(ALLOWED_TAGS,cs_chs(CHS_)) -> {CHS = cs_chs([CH]++CHS_)};
                                                   {CHS = cs_chs([CH])}
  )
).


%% R_SECS

r_secs(ALLOWED_TAGS,SECS) --> (
  r_sec(ALLOWED_TAGS,SEC),
  (
    +([r_lb]), r_secs(ALLOWED_TAGS,cs_secs(SECS_)) ->
      {SECS = cs_secs([SEC]++SECS_)};
    {SECS = cs_secs([SEC])}
  )
).


%% R_PARS

r_pars(ALLOWED_TAGS,PARS) --> (
  r_par(ALLOWED_TAGS,PAR),
  (
    +([r_lb]), r_pars(ALLOWED_TAGS,cs_pars(PARS_)) ->
      {PARS = cs_pars([PAR]++PARS_)};
    {PARS = cs_pars([PAR])}
  )
).


%% R_SECS_PARS_OR_BLKS

r_secs_pars_or_blks(ALLOWED_TAGS,SECS_PARS_OR_BLKS) --> (
  r_secs(ALLOWED_TAGS,   SECS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_secs(SECS)};
  r_pars(ALLOWED_TAGS,   PARS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_blks(BLKS)};
  {false}
).


%% R_PARS_OR_BLKS

r_pars_or_blks(ALLOWED_TAGS,PARS_OR_BLKS) --> (
  r_pars(ALLOWED_TAGS,   PARS) -> {PARS_OR_BLKS = cu_pars_or_blks_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) -> {PARS_OR_BLKS = cu_pars_or_blks_blks(BLKS)};
                                  {false}
).


%% R_CH

r_ch(ALLOWED_TAGS,cr_ch(MAYBE_TAG_OR_ID,MAYBE_HDR,MAIN)) --> (
  (
    if r_tag_or_id(ALLOWED_TAGS,cu_tag_type_ch,TAG_OR_ID) then
      {MAYBE_TAG_OR_ID = maybe.yes(TAG_OR_ID)}
    else
      r_str("CH"),
      {MAYBE_TAG_OR_ID = maybe.no}
  ),
  r_lb,
  ?([],r_hdr,ALLOWED_TAGS,MAYBE_HDR,[]),
  +([r_lb]),
  r_secs_pars_or_blks(ALLOWED_TAGS,MAIN)
).


%% R_SEC

r_sec(ALLOWED_TAGS,cr_sec(MAYBE_TAG_OR_ID,MAYBE_HDR,MAIN)) --> (
  r_str("§"),
  ?(
    [*([r_sp])],
    r_tag_or_id,cs_allowed_tags(["SEC","APP"]),cu_tag_type_sec,MAYBE_TAG_OR_ID,
    []
  ),
  r_lb,
  ?([],r_hdr,ALLOWED_TAGS,MAYBE_HDR,[]),
  +([r_lb]),
  r_pars_or_blks(ALLOWED_TAGS,MAIN)
).


%% R_PAR

r_par(ALLOWED_TAGS,PAR) --> (
  r_par_std(ALLOWED_TAGS,PAR_) -> {PAR = cu_par_std(PAR_)};
  r_par_rpt(ALLOWED_TAGS,PAR_) -> {PAR = cu_par_rpt(PAR_)};
                                  {false}
).


%% R_PAR_STD

r_par_std(ALLOWED_TAGS,cr_par_std(MAYBE_TAG_OR_ID,MAYBE_HDR,BLKS)) -->
  r_str("¶"),
  ?([*([r_sp])],r_tag_or_id,ALLOWED_TAGS,cu_tag_type_par,MAYBE_TAG_OR_ID,[]),
  r_lb,
  ?([],r_hdr,ALLOWED_TAGS,MAYBE_HDR,[]),
  +([r_lb]),
  r_blks(ALLOWED_TAGS,0u,BLKS).


%% R_PAR_RPT

r_par_rpt(ALLOWED_TAGS,cs_par_rpt(ID)) --> (
  r_str("¶"),
  *([r_sp]),
  r_str("rpt"),
  *([r_sp]),
  r_id(ALLOWED_TAGS,cu_tag_type_par_rpt_ref,ID),
  r_lb
).


%% R_HDR

r_hdr(ALLOWED_TAGS,cs_hdr(LINES)) --> r_txt_lines(ALLOWED_TAGS,0u,LINES).
