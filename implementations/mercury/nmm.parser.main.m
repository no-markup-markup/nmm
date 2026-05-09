:- module nmm.parser.main.
%
% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module nmm.


%% R_DOC, TR_DOC, F_DOC_TO_XML, TR_DOC XMLABLE

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

:- func (
  f_doc_to_xml(tr_doc::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tr_doc).


%% R_PREAMBLE (TODO), TS_PREAMBLE, F_PREAMBLE_TO_XML, TS_PREAMBLE XMLABLE

:- type ts_preamble ---> cs_preamble(str).

:- pred r_preamble(ts_preamble, ts_tkns, ts_tkns).
:- mode r_preamble(out,         in,      out) is semidet.

:- func (
  f_preamble_to_xml(ts_preamble::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_preamble).


%% R_TITLE, TS_TITLE, F_TITLE_TO_XML, TS_TITLE XMLABLE

:- type ts_title ---> cs_title(str).

:- pred r_title(ts_title, ts_tkns, ts_tkns).
:- mode r_title(out,      in,      out) is semidet.

:- func (
  f_title_to_xml(ts_title::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_title).


%% R_AUTHORS, TS_AUTHORS, F_AUTHORS_TO_XML, TS_AUTHORS XMLABLE

:- type ts_authors ---> cs_authors(list(ts_author)).

:- pred r_authors(ts_authors, ts_tkns, ts_tkns).
:- mode r_authors(out,        in,      out) is semidet.

:- func (
  f_authors_to_xml(ts_authors::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_authors).


%% R_AUTHOR, TS_AUTHOR, F_AUTHOR_TO_XML, TS_AUTHOR XMLABLE

:- type ts_author ---> cs_author(str).

:- pred r_author(ts_author, ts_tkns, ts_tkns).
:- mode r_author(out,       in,      out) is semidet.

:- func (
  f_author_to_xml(ts_author::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_author).


%% TS_DATE_AUTO, F_DATE_AUTO_TO_XML, TS_DATE_AUTO XMLABLE

:- type ts_date_auto ---> cs_date_auto.

:- func (
  f_date_auto_to_xml(ts_date_auto::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_date_auto).


%% TS_DATE_CUSTOM,F_DATE_CUSTOM_TO_XML, TS_DATE_CUSTOM XMLABLE

:- type ts_date_custom ---> cs_date_custom(str).

:- func (
  f_date_custom_to_xml(ts_date_custom::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_date_custom).


%% R_DATE, TU_DATE, F_DATE_TO_XML, TU_DATE XMLABLE

:- type tu_date ---> (
  cu_date_auto(ts_date_auto)
  ;
  cu_date_custom(ts_date_custom)
).

:- pred r_date(tu_date, ts_tkns, ts_tkns).
:- mode r_date(out,     in,      out) is semidet.

:- func (
  f_date_to_xml(tu_date::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_date).


%% R_ABSTRACT, TS_ABSTRACT, F_ABSTRACT_TO_XML, TS_ABSTRACT XMLABLE

:- type ts_abstract ---> cs_abstract(ts_blks).

:- pred r_abstract(ts_allowed_tags, ts_abstract, ts_tkns, ts_tkns).
:- mode r_abstract(in,              out,         in,      out) is semidet.

:- func (
  f_abstract_to_xml(ts_abstract::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_abstract).


%% R_REFS, TS_REFS, F_REFS_TO_XML, TS_REFS XMLABLE

:- type ts_refs ---> cs_refs(ts_blks).

:- pred r_refs(ts_allowed_tags, ts_refs, ts_tkns, ts_tkns).
:- mode r_refs(in,              out,     in,      out) is semidet.

:- func (
  f_refs_to_xml(ts_refs::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_refs).


%% R_REFS_START_MARKER

:- pred r_refs_start_marker(ts_tkns, ts_tkns).
:- mode r_refs_start_marker(in,      out) is semidet.


%% R_DOC_MAIN, TU_DOC_MAIN, F_DOC_MAIN_TO_XML, TU_DOC_MAIN XMLABLE

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

:- func (
  f_doc_main_to_xml(tu_doc_main::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_doc_main).


%% R_CHS, TS_CHS, F_CHS_TO_XML, TS_CHS_XMLABLE

:- type ts_chs ---> cs_chs(list(tr_ch)).

:- pred r_chs(ts_allowed_tags, ts_chs, ts_tkns, ts_tkns).
:- mode r_chs(in,              out,    in,      out) is semidet.

:- func (
  f_chs_to_xml(ts_chs::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_chs).


%% R_SECS, TS_SECS, F_SECS_TO_XML, TS_SECS_XMLABLE

:- type ts_secs ---> cs_secs(list(tr_sec)).

:- pred r_secs(ts_allowed_tags, ts_secs, ts_tkns, ts_tkns).
:- mode r_secs(in,               out,    in,      out) is semidet.

:- func (
  f_secs_to_xml(ts_secs::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_secs).


%% R_PARS, TS_PARS, F_PARS_TO_XML, TS_PAR_XMLABLE

:- type ts_pars ---> cs_pars(list(tu_par)).

:- pred r_pars(ts_allowed_tags, ts_pars, ts_tkns, ts_tkns).
:- mode r_pars(in,              out,     in,      out) is semidet.

:- func (
  f_pars_to_xml(ts_pars::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_pars).


%% R_SECS_PARS_OR_BLKS, TU_SECS_PARS_OR_BLKS, F_SECS_PARS_OR_BLKS_TO_XML, TU_SECS_PARS_OR_BLKS XMLABLE

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

:- func (
  f_secs_pars_or_blks_to_xml(tu_secs_pars_or_blks::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_secs_pars_or_blks).


%% R_PARS_OR_BLKS, TU_PARS_OR_BLKS, F_PARS_OR_BLKS_TO_XML, TU_PARS_OR_BLKS XMLABLE

:- type tu_pars_or_blks ---> (
  cu_pars_or_blks_pars(ts_pars)
  ;
  cu_pars_or_blks_blks(ts_blks)
).

:- pred r_pars_or_blks(ts_allowed_tags, tu_pars_or_blks, ts_tkns, ts_tkns).
:- mode r_pars_or_blks(
                       in,              out,             in,      out
) is semidet.

:- func (
  f_pars_or_blks_to_xml(tu_pars_or_blks::in)
  =
  (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_pars_or_blks).


%% R_CH, TR_CH, F_CH_TO_XML, TR_CH XMLABLE

:- type tr_ch ---> cr_ch(
  fld_ch_tag_or_id :: maybe(tu_tag_or_id)
  ,
  fld_ch_hdr       :: maybe(ts_hdr)
  ,
  fld_ch_main      :: tu_secs_pars_or_blks
).

:- pred r_ch(ts_allowed_tags, tr_ch,  ts_tkns, ts_tkns).
:- mode r_ch(in,              out,    in,      out) is semidet.

:- func (
  f_ch_to_xml(tr_ch::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tr_ch).


%% R_SEC, TR_SEC, F_SEC_TO_XML, TR_SEC XMLABLE

:- type tr_sec ---> cr_sec(
  fld_sec_tag_or_id :: maybe(tu_tag_or_id)
  ,
  fld_sec_hdr       :: maybe(ts_hdr)
  ,
  fld_sec_main      :: tu_pars_or_blks
).

:- pred r_sec(ts_allowed_tags, tr_sec, ts_tkns, ts_tkns).
:- mode r_sec(in,              out,    in,      out) is semidet.

:- func (
  f_sec_to_xml(tr_sec::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tr_sec).


%% R_PAR, TU_PAR, F_PAR_TO_XML, TU_PAR XMLABLE

:- type tu_par ---> (
  cu_par_std(tr_par_std)
  ;
  cu_par_rpt(ts_par_rpt)
).

:- pred r_par(ts_allowed_tags, tu_par, ts_tkns, ts_tkns).
:- mode r_par(in,              out,    in,      out) is semidet.

:- func (
  f_par_to_xml(tu_par::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tu_par).


%% R_PAR_STD, TR_PAR_STD, F_PAR_STD_TO_XML, TR_PAR_STD XMLABLE

:- type tr_par_std ---> cr_par_std(
  fld_par_tag_or_id :: maybe(tu_tag_or_id)
  ,
  fld_par_hdr       :: maybe(ts_hdr)
  ,
  fld_par_main      :: ts_blks
).

:- pred r_par_std(ts_allowed_tags, tr_par_std, ts_tkns, ts_tkns).
:- mode r_par_std(in,              out,        in,      out) is semidet.

:- func (
  f_par_std_to_xml(tr_par_std::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(tr_par_std).


%% R_PAR_RPT, TS_PAR_RPT, F_PAR_RPT_TO_XML, TS_PAR_RPT XMLABLE

:- type ts_par_rpt ---> cs_par_rpt(tr_id).

:- pred r_par_rpt(ts_allowed_tags, ts_par_rpt, ts_tkns, ts_tkns).
:- mode r_par_rpt(in,              out,        in,      out) is semidet.

:- func (
  f_par_rpt_to_xml(ts_par_rpt::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_par_rpt).


%% R_HDR, TS_HDR, F_HDR_TO_XML, TS_HDR XMLABLE

:- type ts_hdr ---> cs_hdr(ts_txt_lines).

:- pred r_hdr(ts_allowed_tags, ts_hdr, ts_tkns, ts_tkns).
:- mode r_hdr(in,              out,    in,      out) is semidet.

:- func (
  f_hdr_to_xml(ts_hdr::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.

:- instance term_to_xml.xmlable(ts_hdr).



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% R_DOC, F_DOC_TO_XML, TR_DOC XMLABLE

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

%%% F_DOC_TO_XML

f_doc_to_xml(DOC) = XML :- (
  (
    (
      fld_doc_preamble(DOC) = maybe.no,
      PREAMBLE_XML_LIST     = []
    );
    (
      fld_doc_preamble(DOC) = maybe.yes(PREAMBLE),
      PREAMBLE_XML_LIST     = [f_preamble_to_xml(PREAMBLE)]
    )
  ),
  (
    (
      fld_doc_title(DOC) = maybe.no,
      TITLE_XML_LIST     = []
    );
    (
      fld_doc_title(DOC) = maybe.yes(TITLE),
      TITLE_XML_LIST     = [f_title_to_xml(TITLE)]
    )
  ),
  (
    (
      fld_doc_authors(DOC) = maybe.no,
      AUTHORS_XML_LIST      = []
    );
    (
      fld_doc_authors(DOC) = maybe.yes(AUTHOR),
      AUTHORS_XML_LIST     = [f_authors_to_xml(AUTHOR)]
    )
  ),
  (
    (
      fld_doc_date(DOC) = maybe.no,
      DATE_XML_LIST     = []
    );
    (
      fld_doc_date(DOC) = maybe.yes(DATE),
      DATE_XML_LIST     = [f_date_to_xml(DATE)]
    )
  ),
  (
    (
      fld_doc_abstract(DOC) = maybe.no,
      ABSTRACT_XML_LIST     = []
    );
    (
      fld_doc_abstract(DOC) = maybe.yes(ABSTRACT),
      ABSTRACT_XML_LIST     = [f_abstract_to_xml(ABSTRACT)]
    )
  ),
  (
    (
      fld_doc_refs(DOC) = maybe.no,
      REFS_XML_LIST     = []
    );
    (
      fld_doc_refs(DOC) = maybe.yes(REFS),
      REFS_XML_LIST     = [f_refs_to_xml(REFS)]
    )
  ),
  XML = term_to_xml.elem(
    "cr_doc",
    [],
    (
      PREAMBLE_XML_LIST
      ++
      TITLE_XML_LIST
      ++
      AUTHORS_XML_LIST
      ++
      DATE_XML_LIST
      ++
      ABSTRACT_XML_LIST
      ++
      [f_doc_main_to_xml(fld_doc_main(DOC))]
      ++
      REFS_XML_LIST
    )
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_doc) where [
  func(to_xml/1) is f_doc_to_xml
].


%% R_PREAMBLE (TODO), F_PREAMBLE_TO_XML, TS_PREAMBLE XMLABLE

%%% TODO: R_PREAMBLE

:- pragma no_determinism_warning(r_preamble/3).
r_preamble(_) --> {false}.

%%% F_PREAMBLE_TO_XML

f_preamble_to_xml(cs_preamble(STR)) =
  term_to_xml.elem("cs_preamble",[],[term_to_xml.data(STR)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_preamble) where [
  func(to_xml/1) is f_preamble_to_xml
].


%% R_TITLE, F_TITLE_TO_XML, TS_TITLE XMLABLE

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

%%% F_TITLE_TO_XML

f_title_to_xml(cs_title(STR)) =
  term_to_xml.elem("cs_title",[],[term_to_xml.data(STR)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_title) where [
  func(to_xml/1) is f_title_to_xml
].


%% R_AUTHORS, F_AUTHORS_TO_XML, TS_AUTHORS XMLABLE

%%% R_AUTHOR

r_authors(cs_authors(AUTHORS)) --> (
  +([],r_author,AUTHORS,[?([r_lb])])
).

%%% F_AUTHORS_TO_XML

f_authors_to_xml(cs_authors(AUTHORS)) =
  term_to_xml.elem("cs_authors",[],list.map(f_author_to_xml,AUTHORS)).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_authors) where [
  func(to_xml/1) is f_authors_to_xml
].


%% R_AUTHOR, F_AUTHOR_TO_XML, TS_AUTHOR XMLABLE

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

%%% F_AUTHOR_TO_XML

f_author_to_xml(cs_author(STR)) =
  term_to_xml.elem("cs_author",[],[term_to_xml.data(STR)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_author) where [
  func(to_xml/1) is f_author_to_xml
].


%% F_DATE_AUTO_TO_XML, TS_DATE_AUTO XMLABLE

f_date_auto_to_xml(cs_date_auto) = term_to_xml.elem("cs_date_auto",[],[]).

:- instance term_to_xml.xmlable(ts_date_auto) where [
  func(to_xml/1) is f_date_auto_to_xml
].


%% F_DATE_CUSTOM_TO_XML, TS_DATE_CUSTOM XMLABLE

f_date_custom_to_xml(cs_date_custom(STR)) =
  term_to_xml.elem("cs_date_custom",[],[term_to_xml.data(STR)]).

:- instance term_to_xml.xmlable(ts_date_custom) where [
  func(to_xml/1) is f_date_custom_to_xml
].


%% R_DATE, F_DATE_TO_XML, TU_DATE XMLABLE

%%% R_DATE

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

%%% F_DATE_TO_XML

f_date_to_xml(cu_date_auto(DATE_AUTO))     =
  term_to_xml.elem("cu_date_auto",  [],[f_date_auto_to_xml(DATE_AUTO)]).
f_date_to_xml(cu_date_custom(DATE_CUSTOM)) =
  term_to_xml.elem("cu_date_custom",[],[f_date_custom_to_xml(DATE_CUSTOM)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_date) where [
  func(to_xml/1) is f_date_to_xml
].


%% R_ABSTRACT, F_ABSTRACT_TO_XML, TS_ABSTRACT XMLABLE

%%% R_ABSTRACT

r_abstract(ALLOWED_TAGS,cs_abstract(BLKS)) --> (
  r_str("ABSTRACT:"),
  +([r_lb]),
  r_tab,
  r_blks(ALLOWED_TAGS,1u,BLKS)
).

%%% F_ABSTRACT_TO_XML

f_abstract_to_xml(cs_abstract(BLKS)) =
  term_to_xml.elem("cs_abstract",[],[f_blks_to_xml(BLKS)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_abstract) where [
  func(to_xml/1) is f_abstract_to_xml
].


%% R_REFS, TS_REFS XMLABLE

%%% R_REFS

r_refs(ALLOWED_TAGS,cs_refs(BLKS)) -->
  r_refs_start_marker, +([r_lb]), r_blks(ALLOWED_TAGS,0u,BLKS).

%%% F_REFS_TO_XML

f_refs_to_xml(cs_refs(BLKS)) =
  term_to_xml.elem("cs_refs",[],[f_blks_to_xml(BLKS)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_refs) where [
  func(to_xml/1) is f_refs_to_xml
].


%% R_REFS_START_MARKER

r_refs_start_marker --> (
  r_str("CH"), +([r_sp]), r_str("REFS"), r_lb -> {true};
  r_str("§"),  +([r_sp]), r_str("REFS"), r_lb -> {true};
  r_str("¶"),  +([r_sp]), r_str("REFS"), r_lb -> {true};
                                                 {false}
).


%% R_DOC_MAIN, F_DOC_MAIN_TO_XML, TU_DOC_MAIN XMLABLE

%%% R_DOC_MAIN

r_doc_main(ALLOWED_TAGS,DOC_MAIN) --> (
  r_chs( ALLOWED_TAGS,   CHS)  -> {DOC_MAIN = cu_doc_main_chs( CHS)};
  r_secs(ALLOWED_TAGS,   SECS) -> {DOC_MAIN = cu_doc_main_secs(SECS)};
  r_pars(ALLOWED_TAGS,   PARS) -> {DOC_MAIN = cu_doc_main_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) -> {DOC_MAIN = cu_doc_main_blks(BLKS)};
                                  {false}
).

%%% F_DOC_MAIN_TO_XML

f_doc_main_to_xml(cu_doc_main_chs(CHS))   =
  term_to_xml.elem("cu_doc_main_chs", [],[f_chs_to_xml(CHS)]).
f_doc_main_to_xml(cu_doc_main_secs(SECS)) =
  term_to_xml.elem("cu_doc_main_secs",[],[f_secs_to_xml(SECS)]).
f_doc_main_to_xml(cu_doc_main_pars(PARS)) =
  term_to_xml.elem("cu_doc_main_pars",[],[f_pars_to_xml(PARS)]).
f_doc_main_to_xml(cu_doc_main_blks(BLKS)) =
  term_to_xml.elem("cu_doc_main_blks",[],[f_blks_to_xml(BLKS)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_doc_main) where [
  func(to_xml/1) is f_doc_main_to_xml
].


%% R_CHS, F_CHS_TO_XML, TS_CHS_XMLABLE

%%% R_CHS

r_chs(ALLOWED_TAGS,CHS) --> (
  r_ch(ALLOWED_TAGS,CH),
  (
    +([r_lb]), r_chs(ALLOWED_TAGS,cs_chs(CHS_)) -> {CHS = cs_chs([CH]++CHS_)};
                                                   {CHS = cs_chs([CH])}
  )
).

%%% F_CHS_TO_XML

f_chs_to_xml(cs_chs(CHS)) = (
  term_to_xml.elem("cs_chs",[],list.map(f_ch_to_xml,CHS))
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_chs) where [
  func(to_xml/1) is f_chs_to_xml
].


%% R_SECS, F_SECS_TO_XML, TS_SECS_XMLABLE

%%% R_SECS

r_secs(ALLOWED_TAGS,SECS) --> (
  r_sec(ALLOWED_TAGS,SEC),
  (
    +([r_lb]), r_secs(ALLOWED_TAGS,cs_secs(SECS_)) ->
      {SECS = cs_secs([SEC]++SECS_)};
    {SECS = cs_secs([SEC])}
  )
).

%%% F_SECS_TO_XML

f_secs_to_xml(cs_secs(SECS)) = (
  term_to_xml.elem("cs_secs",[],list.map(f_sec_to_xml,SECS))
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_secs) where [
  func(to_xml/1) is f_secs_to_xml
].


%% R_PARS, F_PARS_TO_XML, TS_PARS_XMLABLE

%%% R_PARS

r_pars(ALLOWED_TAGS,PARS) --> (
  r_par(ALLOWED_TAGS,PAR),
  (
    +([r_lb]), r_pars(ALLOWED_TAGS,cs_pars(PARS_)) ->
      {PARS = cs_pars([PAR]++PARS_)};
    {PARS = cs_pars([PAR])}
  )
).

%%% F_PARS_TO_XML

f_pars_to_xml(cs_pars(PARS)) = (
  term_to_xml.elem("cs_pars",[],list.map(f_par_to_xml,PARS))
).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_pars) where [
  func(to_xml/1) is f_pars_to_xml
].


%% R_SECS_PARS_OR_BLKS, F_SECS_PARS_OR_BLKS_TO_XML, TU_SECS_PARS_OR_BLKS_XMLABLE

%%% R_SECS_PARS_OR_BLKS

r_secs_pars_or_blks(ALLOWED_TAGS,SECS_PARS_OR_BLKS) --> (
  r_secs(ALLOWED_TAGS,   SECS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_secs(SECS)};
  r_pars(ALLOWED_TAGS,   PARS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) ->
    {SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_blks(BLKS)};
  {false}
).

%%% F_SECS_PARS_OR_BLKS_TO_XML

f_secs_pars_or_blks_to_xml(SECS_PARS_OR_BLKS) = XML :- (
  (
    SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_secs(SECS),
    XML               =
      term_to_xml.elem("cu_secs_pars_or_blks_secs",[],[f_secs_to_xml(SECS)])
  );
  (
    SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_pars(PARS),
    XML               =
      term_to_xml.elem("cu_secs_pars_or_blks_pars",[],[f_pars_to_xml(PARS)])
  );
  (
    SECS_PARS_OR_BLKS = cu_secs_pars_or_blks_blks(BLKS),
    XML               =
      term_to_xml.elem("cu_secs_pars_or_blks_blks",[],[f_blks_to_xml(BLKS)])
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_secs_pars_or_blks) where [
  func(to_xml/1) is f_secs_pars_or_blks_to_xml
].


%% R_PARS_OR_BLKS, F_PARS_OR_BLKS_TO_XML, TU_PARS_OR_BLKS_XMLABLE

%%% R_PARS_OR_BLKS

r_pars_or_blks(ALLOWED_TAGS,PARS_OR_BLKS) --> (
  r_pars(ALLOWED_TAGS,   PARS) -> {PARS_OR_BLKS = cu_pars_or_blks_pars(PARS)};
  r_blks(ALLOWED_TAGS,0u,BLKS) -> {PARS_OR_BLKS = cu_pars_or_blks_blks(BLKS)};
                                  {false}
).

%%% F_PARS_OR_BLKS_TO_XML

f_pars_or_blks_to_xml(PARS_OR_BLKS) = XML :- (
  (
    PARS_OR_BLKS = cu_pars_or_blks_pars(PARS),
    XML          =
      term_to_xml.elem("cu_pars_or_blks_pars",[],[f_pars_to_xml(PARS)])
  );
  (
    PARS_OR_BLKS = cu_pars_or_blks_blks(BLKS),
    XML          =
      term_to_xml.elem("cu_pars_or_blks_blks",[],[f_blks_to_xml(BLKS)])
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_pars_or_blks) where [
  func(to_xml/1) is f_pars_or_blks_to_xml
].


%% R_CH, F_CH_TO_XML, TR_CH XMLABLE

%%% R_CH

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

%%% F_CH_TO_XML

f_ch_to_xml(CH) = XML :- (
  (
    (
      fld_ch_tag_or_id(CH) = maybe.no,
      TAG_OR_ID_XML_LIST   = []
    );
    (
      fld_ch_tag_or_id(CH) = maybe.yes(TAG_OR_ID),
      TAG_OR_ID_XML_LIST   = [f_tag_or_id_to_xml(TAG_OR_ID)]
    )
  ),
  (
    (
      fld_ch_hdr(CH) = maybe.no,
      HDR_XML_LIST   = []
    );
    (
      fld_ch_hdr(CH) = maybe.yes(HDR),
      HDR_XML_LIST   = [f_hdr_to_xml(HDR)]
    )
  ),
  SECS_PARS_OR_BLKS = fld_ch_main(CH),
  XML  = term_to_xml.elem(
    "cr_ch",
    [],
    (
      TAG_OR_ID_XML_LIST
      ++
      HDR_XML_LIST
      ++
      [f_secs_pars_or_blks_to_xml(SECS_PARS_OR_BLKS)]
    )
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_ch) where [
  func(to_xml/1) is f_ch_to_xml
].


%% R_SEC, F_SEC_TO_XML, TR_SEC XMLABLE

%%% R_SEC

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

%%% F_SEC_TO_XML

f_sec_to_xml(SEC) = XML :- (
  (
    (
      fld_sec_tag_or_id(SEC) = maybe.no,
      TAG_OR_ID_XML_LIST     = []
    );
    (
      fld_sec_tag_or_id(SEC) = maybe.yes(TAG_OR_ID),
      TAG_OR_ID_XML_LIST     = [f_tag_or_id_to_xml(TAG_OR_ID)]
    )
  ),
  (
    (
      fld_sec_hdr(SEC) = maybe.no,
      HDR_XML_LIST     = []
    );
    (
      fld_sec_hdr(SEC) = maybe.yes(HDR),
      HDR_XML_LIST     = [f_hdr_to_xml(HDR)]
    )
  ),
  MAIN = fld_sec_main(SEC),
  XML  = term_to_xml.elem(
    "cr_sec",
    [],
    (
      TAG_OR_ID_XML_LIST
      ++
      HDR_XML_LIST
      ++
      [f_pars_or_blks_to_xml(MAIN)]
    )
  )
).


%%% XMLABLE

:- instance term_to_xml.xmlable(tr_sec) where [
  func(to_xml/1) is f_sec_to_xml
].


%% R_PAR, F_PAR_TO_XML, TU_PAR XMLABLE

%%% R_PAR

r_par(ALLOWED_TAGS,PAR) --> (
  r_par_std(ALLOWED_TAGS,PAR_) -> {PAR = cu_par_std(PAR_)};
  r_par_rpt(ALLOWED_TAGS,PAR_) -> {PAR = cu_par_rpt(PAR_)};
                                  {false}
).

%%% F_PAR_TO_XML

f_par_to_xml(cu_par_std(PAR)) =
  term_to_xml.elem("cu_par_std",[],[f_par_std_to_xml(PAR)]).
f_par_to_xml(cu_par_rpt(PAR)) =
  term_to_xml.elem("cu_par_rpt",[],[f_par_rpt_to_xml(PAR)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(tu_par) where [
  func(to_xml/1) is f_par_to_xml
].


%% R_PAR_STD, F_PAR_STD_TO_XML, TR_PAR_STD XMLABLE

%%% R_PAR_STD

r_par_std(ALLOWED_TAGS,cr_par_std(MAYBE_TAG_OR_ID,MAYBE_HDR,BLKS)) -->
  r_str("¶"),
  ?([*([r_sp])],r_tag_or_id,ALLOWED_TAGS,cu_tag_type_par,MAYBE_TAG_OR_ID,[]),
  r_lb,
  ?([],r_hdr,ALLOWED_TAGS,MAYBE_HDR,[]),
  +([r_lb]),
  r_blks(ALLOWED_TAGS,0u,BLKS).

%%% F_PAR_STD_TO_XML

f_par_std_to_xml(PAR) = XML :- (
  (
    (
      fld_par_tag_or_id(PAR) = maybe.no,
      TAG_OR_ID_XML_LIST     = []
    );
    (
      fld_par_tag_or_id(PAR) = maybe.yes(TAG_OR_ID),
      TAG_OR_ID_XML_LIST     = [f_tag_or_id_to_xml(TAG_OR_ID)]
    )
  ),
  (
    (
      fld_par_hdr(PAR) = maybe.no,
      HDR_XML_LIST     = []
    );
    (
      fld_par_hdr(PAR) = maybe.yes(HDR),
      HDR_XML_LIST     = [f_hdr_to_xml(HDR)]
    )
  ),
  BLKS = fld_par_main(PAR),
  XML  = term_to_xml.elem(
    "cr_par_std",
    [],
    TAG_OR_ID_XML_LIST++HDR_XML_LIST++[f_blks_to_xml(BLKS)]
  )
).

%%% XMLABLE

:- instance term_to_xml.xmlable(tr_par_std) where [
  func(to_xml/1) is f_par_std_to_xml
].


%% R_PAR_RPT, F_PAR_RPT_TO_XML, TS_PAR_RPT XMLABLE

%%% R_PAR_RPT

r_par_rpt(ALLOWED_TAGS,cs_par_rpt(ID)) --> (
  r_str("¶"),
  *([r_sp]),
  r_str("rpt"),
  *([r_sp]),
  r_id(ALLOWED_TAGS,cu_tag_type_par_rpt_ref,ID),
  r_lb
).

%%% F_PAR_RPT_TO_XML

f_par_rpt_to_xml(cs_par_rpt(ID)) =
  term_to_xml.elem("cs_par_rpt",[],[f_id_to_xml(ID)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_par_rpt) where [
  func(to_xml/1) is f_par_rpt_to_xml
].


%% R_HDR, TS_HDR XMLABLE

%%% R_HDR

r_hdr(ALLOWED_TAGS,cs_hdr(LINES)) --> r_txt_lines(ALLOWED_TAGS,0u,LINES).

%%% F_HDR_TO_XML

f_hdr_to_xml(cs_hdr(LINES)) =
  term_to_xml.elem("cs_hdr",[],[f_txt_lines_to_xml(LINES)]).

%%% XMLABLE

:- instance term_to_xml.xmlable(ts_hdr) where [
  func(to_xml/1) is f_hdr_to_xml
].
