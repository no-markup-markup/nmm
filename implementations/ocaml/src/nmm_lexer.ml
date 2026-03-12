open Nmm_parser

exception ERROR of string

(************ regular expressions ******************)

let tab = [%sedlex.regexp? "\t"]
let nl = [%sedlex.regexp? "\n" | "\r\n"]
let nl_tab = [%sedlex.regexp? nl, tab]
let nl_tab_tab = [%sedlex.regexp? nl_tab, tab]
let nl_tab_tab_tab = [%sedlex.regexp? nl_tab_tab, tab]
let dash_tab = [%sedlex.regexp? "-", tab]
let dsp_auto_tab = [%sedlex.regexp? "()", tab]
let itm_auto_tab = [%sedlex.regexp? "[]", tab]
let non_custom_chars = [%sedlex.regexp? Chars "\r\n\t"]
let dsp_custom_tab = [%sedlex.regexp? "(", Plus (Compl non_custom_chars), ")", tab]
let itm_custom_tab = [%sedlex.regexp? "[", Plus (Compl non_custom_chars), "]", tab]

let star = [%sedlex.regexp? "*"]
let lbr = [%sedlex.regexp? "["]
let rbr = [%sedlex.regexp? "]"]
let colon = [%sedlex.regexp? ":"]
let section = [%sedlex.regexp? Utf8 "§"]
let pilcrow = [%sedlex.regexp? Utf8 "¶"]

let non_txt_chars = [%sedlex.regexp? Chars "\r\n\t*[]:\\"| pilcrow | section]
let txt_chars = [%sedlex.regexp? Compl non_txt_chars]
let txt = [%sedlex.regexp? Plus txt_chars]

let scope = [%sedlex.regexp? "GBL" | "CH" | "SEC" | "APP" | "PAR"]
let non_name_chars = [%sedlex.regexp? Chars "\r\n\t:[] \\"]
let name = [%sedlex.regexp? Plus (Compl non_name_chars)]
let tag_unique = [%sedlex.regexp? "CH" | "SEC" | "APP" | "PAR" | "ITM" | "DSP" ]
let tag_shared = [%sedlex.regexp? "DEF" | "DEFS" | "FCT" | "FCTS" | "PRF" | "PRFS" | "THM" | "THMS" | "LMA" | "LMAS" | "RMK" | "RMKS"]
let tag = [%sedlex.regexp? tag_unique | tag_shared]
let ch_tag_or_id = [%sedlex.regexp? "CH", Opt (":", name, Opt ":GBL")]
let sec_tag_or_id = [%sedlex.regexp? ("SEC" | "APP"), Opt (":", name, Opt (":", ("GBL"|"CH")))]
let par_tag_or_id = [%sedlex.regexp? ("PAR" | tag_shared), Opt (":", name, Opt (":", ("GBL" | "CH" | "SEC" | "APP")))]
let itm_id = [%sedlex.regexp? ("ITM" | tag_shared), ":", name, Opt (":", scope)]
let dsp_id = [%sedlex.regexp? ("DSP" | tag_shared), ":", name, Opt (":", scope)]
let c_ref = [%sedlex.regexp? "[", tag, ":", name, Opt (":", scope), "]"]
let par_id = [%sedlex.regexp? ("PAR" | tag_shared), ":", name, Opt (":", ("GBL" | "CH" | "SEC" | "APP"))]
let itm_auto_tab_id = [%sedlex.regexp? itm_auto_tab, itm_id]
let itm_custom_tab_id = [%sedlex.regexp? itm_custom_tab, itm_id]

let ch_tag_or_id_nl = [%sedlex.regexp? ch_tag_or_id, nl]

let section_nl = [%sedlex.regexp? section, nl]
let section_spaces_tag_or_id_nl = [%sedlex.regexp? section, Plus " ", sec_tag_or_id, nl]

let pilcrow_nl = [%sedlex.regexp? pilcrow, nl]
let pilcrow_spaces_tag_or_id_nl = [%sedlex.regexp? pilcrow, Plus " ", par_tag_or_id, nl]
let pilcrow_spaces_rpt_spaces_id_nl = [%sedlex.regexp? pilcrow, Plus " ", "rpt", Plus " ", par_id, nl]

let preamble = [%sedlex.regexp? "PREAMBLE:"]
let title = [%sedlex.regexp? "TITLE:"]
let author = [%sedlex.regexp? "AUTHOR:"]
let abstract = [%sedlex.regexp? "ABSTRACT:"]
let section_refs_nls = [%sedlex.regexp? Utf8 "§", Plus " ", "REFS", Plus nl]
let pilcrow_refs_nls = [%sedlex.regexp? Utf8 "¶", Plus " ", "REFS", Plus nl]

let esc_char = [%sedlex.regexp? '\\', any]

let start_vrb = [%sedlex.regexp? "START", tab, "VERBATIM", nl]
let vrb_line = [%sedlex.regexp? Plus (Compl (Chars "\r\n\t"))]
let end_vrb = [%sedlex.regexp? "END", tab, "VERBATIM", nl]
let tab_end_vrb = [%sedlex.regexp? tab, end_vrb]
let tab_tab_end_vrb = [%sedlex.regexp? tab, tab_end_vrb]
let tab_tab_tab_end_vrb = [%sedlex.regexp? tab, tab_tab_end_vrb]

(************ helper functions *********************)

let get_esc_char (s : string) : string = 
        String.sub s 1 (String.length s - 1)

let get_label (s:string):string=
        String.sub s 1 ((String.length s)-3)

let get_tag_or_id (s:string):string=
        let x=String.trim s in
        let y=String.split_on_char ' ' x in
        let z=List.tl y in
        String.concat "" z

let get_id (s : string) : string =
        let x=String.trim s in
        let y=String.split_on_char ' ' x in
        let z=List.tl (List.tl y) in
        String.concat "" z

let lexeme (lexbuf:Sedlexing.lexbuf):string=
        Sedlexing.Utf8.lexeme lexbuf

let line_of_lexbuf (lexbuf:Sedlexing.lexbuf):string=
        match Sedlexing.lexing_positions lexbuf with
        (start_pos,end_pos) -> string_of_int (start_pos.pos_lnum)

let return_nl: bool ref = ref true

let verbatim : bool ref = ref false

let first_nl : bool ref = ref true

let nl_or_vrb_line_empty (first : bool ) : Nmm_parser.token =
        match first with
        |true -> let _ : unit = first_nl.contents <- false in NL
        |false -> VRB_LINE_EMPTY

let display : bool ref = ref false

(************** the lexer ******************************)

let rec token (lexbuf : Sedlexing.lexbuf) : Nmm_parser.token=
        match verbatim.contents, display.contents with
        |false, false -> (
                match%sedlex lexbuf with
                |esc_char                       ->      ESC_CHAR (get_esc_char (lexeme lexbuf))
                |preamble                       ->      PREAMBLE (lexeme lexbuf)
                |title                          ->      TITLE (lexeme lexbuf)
                |author                         ->      AUTHOR (lexeme lexbuf)
                |abstract                       ->      ABSTRACT (lexeme lexbuf)
                |ch_tag_or_id_nl                ->      CH_TAG_OR_ID_NL (String.trim (lexeme lexbuf))
                |c_ref                          ->      C_REF (lexeme lexbuf)
                |section_nl                     ->      SECTION_NL
                |section_spaces_tag_or_id_nl    ->      SECTION_SPACES_TAG_OR_ID_NL (get_tag_or_id (lexeme lexbuf))
                |pilcrow_nl                     ->      PILCROW_NL
                |pilcrow_spaces_tag_or_id_nl    ->      PILCROW_SPACES_TAG_OR_ID_NL (get_tag_or_id (lexeme lexbuf))
                |pilcrow_spaces_rpt_spaces_id_nl ->     PILCROW_SPACES_RPT_SPACES_ID_NL (get_id (lexeme lexbuf))
                |section_refs_nls               ->      SECTION_REFS_NLS
                |pilcrow_refs_nls               ->      PILCROW_REFS_NLS
                |tab                            ->      TAB 
                |dash_tab                       ->      DASH_TAB
                |dsp_auto_tab                   ->      let _ : unit = display.contents <- true in DSP_AUTO_TAB 
                |dsp_custom_tab                 ->      let _ : unit = display.contents <- true in DSP_CUSTOM_TAB (get_label (lexeme lexbuf))
                |itm_auto_tab                   ->      ITM_AUTO_TAB
                |itm_custom_tab                 ->      ITM_CUSTOM_TAB (get_label (lexeme lexbuf))
                |itm_auto_tab_id                ->      ITM_AUTO_TAB_ID (lexeme lexbuf)
                |itm_custom_tab_id              ->      ITM_CUSTOM_TAB_ID (lexeme lexbuf)
                |nl                             ->      NL
                |nl_tab                         ->      NL_TAB
                |nl_tab_tab                     ->      NL_TAB_TAB
                |nl_tab_tab_tab                 ->      NL_TAB_TAB_TAB
                |star                           ->      STAR
                |lbr                            ->      LBR
                |rbr                            ->      RBR
                |colon                          ->      COLON
                |section                        ->      SECTION
                |pilcrow                        ->      PILCROW
                |txt                            ->      TXT (lexeme lexbuf)
                |start_vrb                      ->      let _ : unit = verbatim.contents <- true in START_VRB
                |eof                            ->      end_of_file lexbuf
                |_ -> raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
        )

        |true, _ -> (
                match%sedlex lexbuf with
                |end_vrb                        ->      let _ : unit = verbatim.contents <- false in END_VRB
                |tab_end_vrb                    ->      let _ : unit = verbatim.contents <- false in TAB_END_VRB
                |tab_tab_end_vrb                ->      let _ : unit = verbatim.contents <- false in TAB_TAB_END_VRB
                |tab_tab_tab_end_vrb            ->      let _ : unit = verbatim.contents <- false in TAB_TAB_TAB_END_VRB
                |vrb_line                       ->      let _ : unit = first_nl.contents <- true in VRB_LINE (lexeme lexbuf)
                |nl                             ->      nl_or_vrb_line_empty first_nl.contents
                |tab                            ->      TAB
                |_ -> raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
        )

        |_, true -> (
                match%sedlex lexbuf with
                |esc_char                       ->      ESC_CHAR (get_esc_char (lexeme lexbuf))
                |star                           ->      STAR
                |lbr                            ->      LBR
                |rbr                            ->      RBR
                |colon                          ->      COLON
                |section                        ->      SECTION
                |pilcrow                        ->      PILCROW
                |c_ref                          ->      C_REF (lexeme lexbuf)
                |txt                            ->      TXT (lexeme lexbuf)
                |tab                            ->      TAB 
                |dsp_id                         ->      DSP_ID (lexeme lexbuf)
                |nl                             ->      let _ : unit = display.contents <- false in NL
                |nl_tab                         ->      let _ : unit = display.contents <- false in NL_TAB
                |nl_tab_tab                     ->      let _ : unit = display.contents <- false in NL_TAB_TAB
                |nl_tab_tab_tab                 ->      let _ : unit = display.contents <- false in NL_TAB_TAB_TAB
                |_ -> raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
        )

and end_of_file (lexbuf : Sedlexing.lexbuf) : Nmm_parser.token =
        match return_nl.contents with
        |true -> let _ = return_nl.contents <- false in let _ = token lexbuf in NL
        |false -> EOF


