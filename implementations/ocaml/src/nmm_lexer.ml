open Nmm_parser

exception ERROR of string

(* regular expressions *)

let tab = [%sedlex.regexp? "\t"]
let nl = [%sedlex.regexp? "\n" | "\r\n"]
let nl_tab = [%sedlex.regexp? nl, tab]
let nl_tab_tab = [%sedlex.regexp? nl_tab, tab]
let nl_tab_tab_tab = [%sedlex.regexp? nl_tab_tab, tab]
let dash_tab = [%sedlex.regexp? "-", tab]
let star_tab = [%sedlex.regexp? "*", tab]
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
let nte_lbr = [%sedlex.regexp? "\\NTE["]

let non_txt_chars = [%sedlex.regexp? Chars "\r\n\t*[]:\\"| pilcrow | section]
let txt_chars = [%sedlex.regexp? Compl non_txt_chars]
let txt = [%sedlex.regexp? Plus txt_chars]

let scope = [%sedlex.regexp? "GBL" | "CH" | "SEC" | "APP" | "PAR"]
let non_name_chars = [%sedlex.regexp? Chars "\r\n\t:[]<>()/,;= \\"]
let name = [%sedlex.regexp? Plus (Compl non_name_chars)]
let tag_shared = [%sedlex.regexp? name]
let tag_unique = [%sedlex.regexp? "CH" | "SEC" | "APP" | "PAR" | "ITM" | "DSP" ]
let tag = [%sedlex.regexp? tag_unique | tag_shared | "BIB"]
let ch_tag_or_id = [%sedlex.regexp? "CH", Opt (":", name, Opt ":GBL")]
let sec_tag_or_id = [%sedlex.regexp? ("SEC" | "APP"), Opt (":", name, Opt (":", ("GBL"|"CH")))]
let par_tag_or_id = [%sedlex.regexp? ("PAR" | tag_shared), Opt (":", name, Opt (":", ("GBL" | "CH" | "SEC" | "APP")))]
let itm_id = [%sedlex.regexp? ("ITM" | "BIB" | tag_shared), ":", name, Opt (":", scope)]
let dsp_id = [%sedlex.regexp? ("DSP" | tag_shared), ":", name, Opt (":", scope)]
let nte_id = [%sedlex.regexp? "NTE", ":", name, Opt (":", scope)]
let c_ref = [%sedlex.regexp? "[", tag, ":", name, Opt (":", scope), "]"]
let nte_ref = [%sedlex.regexp? "[", nte_id, "]"]
let par_id = [%sedlex.regexp? ("PAR" | tag_shared), ":", name, Opt (":", ("GBL" | "CH" | "SEC" | "APP"))]
let itm_auto_tab_id = [%sedlex.regexp? itm_auto_tab, itm_id]
let itm_custom_tab_id = [%sedlex.regexp? itm_custom_tab, itm_id]
let star_tab_id = [%sedlex.regexp? star_tab, nte_id]
let ch_tag_or_id_nl = [%sedlex.regexp? ch_tag_or_id, nl]

let spaces = [%sedlex.regexp? Plus " "]
let section_nl = [%sedlex.regexp? section, nl]
let section_spaces_tag_or_id_nl = [%sedlex.regexp? section, spaces, sec_tag_or_id, nl]
let pilcrow_nl = [%sedlex.regexp? pilcrow, nl]
let pilcrow_spaces_tag_or_id_nl = [%sedlex.regexp? pilcrow, spaces, par_tag_or_id, nl]
let pilcrow_spaces_rpt_spaces_id_nl = [%sedlex.regexp? pilcrow, spaces, "rpt", spaces, par_id, nl]

let title_colon = [%sedlex.regexp? "TITLE:"]
let author_colon = [%sedlex.regexp? "AUTHOR:"]
let date_colon = [%sedlex.regexp? "DATE:"]
let abstract_colon = [%sedlex.regexp? "ABSTRACT:"]
let section_refs_nls = [%sedlex.regexp? Utf8 "§", Plus " ", "REFS", Plus nl]
let pilcrow_refs_nls = [%sedlex.regexp? Utf8 "¶", Plus " ", "REFS", Plus nl]

let esc_char = [%sedlex.regexp? '\\', any]

let start_vrb = [%sedlex.regexp? "START", tab, "VERBATIM", nl]
let vrb_line = [%sedlex.regexp? Plus (Compl (Chars "\r\n\t")), nl]
let end_vrb = [%sedlex.regexp? "END", tab, "VERBATIM", nl]
let tab_end_vrb = [%sedlex.regexp? tab, end_vrb]
let tab_tab_end_vrb = [%sedlex.regexp? tab, tab_end_vrb]
let tab_tab_tab_end_vrb = [%sedlex.regexp? tab, tab_tab_end_vrb]

let start_qtn = [%sedlex.regexp? "START", tab, "QUOTATION", nl]
let end_qtn = [%sedlex.regexp? "END", tab, "QUOTATION", nl]
let br = [%sedlex.regexp? "BR"]
let tab_end_qtn = [%sedlex.regexp? tab, end_qtn]
let tab_tab_end_qtn = [%sedlex.regexp? tab, tab_end_qtn]
let tab_tab_tab_end_qtn = [%sedlex.regexp? tab, tab_tab_end_qtn]

let start_preamble = [%sedlex.regexp? "START", tab, "PREAMBLE", nl]
let end_preamble = [%sedlex.regexp? "END", tab, "PREAMBLE", nl]
let preamble_line = [%sedlex.regexp? Plus (Compl (Chars "\r\n\t"))]

let nl_not_nl = [%sedlex.regexp? nl, Compl (Chars "\n\r")]

(* helper functions *)

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

let remove_nls (s : string) : string =
        String.concat "" (String.split_on_char '\n' s)

(* lexer_env *)

type t_lexer_env = {
        mutable preamble : bool;
        mutable quotation : bool;
        mutable verbatim : bool;
        mutable display : bool;
        mutable nte_counter : int;
        mutable end_of_file : bool;
}

let lexer_env : t_lexer_env = {
        preamble = false;
        quotation = false;
        verbatim = false;
        display = false;
        nte_counter = 0;
        end_of_file = false;
}

let set_preamble_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.preamble <- true in tkn

let reset_preamble_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.preamble <- false in tkn

let set_quotation_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.quotation <- true in tkn

let reset_quotation_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.quotation <- false in tkn

let set_verbatim_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.verbatim <- true in tkn

let reset_verbatim_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.verbatim <- false in tkn

let set_display_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.display <- true in tkn

let reset_display_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.display <- false in tkn

let increase_nte_count_and_return_previous () : int =
        let n = lexer_env.nte_counter in
        let _ : unit = lexer_env.nte_counter <- n + 1 in
        n

let set_end_of_file_and_return_token (tkn : Nmm_parser.token) : Nmm_parser.token =
        let _ : unit = lexer_env.end_of_file <- true in tkn

(* the lexer *)

let rec token (lexbuf : Sedlexing.lexbuf) : Nmm_parser.token=
        match lexer_env.verbatim, lexer_env.display, lexer_env.quotation, lexer_env.preamble with
        |false, false, false, false -> (
                match%sedlex lexbuf with
                |start_preamble                  ->      set_preamble_and_return_token START_PREAMBLE
                |start_qtn                       ->      set_quotation_and_return_token START_QTN
                |esc_char                        ->      ESC_CHAR (get_esc_char (lexeme lexbuf))
                |title_colon                     ->      TITLE_COLON
                |author_colon                    ->      AUTHOR_COLON
                |date_colon                      ->      DATE_COLON
                |abstract_colon                  ->      ABSTRACT_COLON
                |ch_tag_or_id_nl                 ->      CH_TAG_OR_ID_NL (String.trim (lexeme lexbuf))
                |nte_ref                         ->      NTE_REF (lexeme lexbuf, increase_nte_count_and_return_previous ())
                |c_ref                           ->      C_REF (lexeme lexbuf)
                |section_nl                      ->      SECTION_NL
                |section_spaces_tag_or_id_nl     ->      SECTION_SPACES_TAG_OR_ID_NL (get_tag_or_id (lexeme lexbuf))
                |pilcrow_nl                      ->      PILCROW_NL
                |pilcrow_spaces_tag_or_id_nl     ->      PILCROW_SPACES_TAG_OR_ID_NL (get_tag_or_id (lexeme lexbuf))
                |pilcrow_spaces_rpt_spaces_id_nl ->      PILCROW_SPACES_RPT_SPACES_ID_NL (get_id (lexeme lexbuf))
                |section_refs_nls                ->      SECTION_REFS_NLS
                |pilcrow_refs_nls                ->      PILCROW_REFS_NLS
                |tab                             ->      TAB 
                |dash_tab                        ->      DASH_TAB
                |star_tab_id                     ->      STAR_TAB_ID (lexeme lexbuf)
                |dsp_auto_tab                    ->      set_display_and_return_token DSP_AUTO_TAB 
                |dsp_custom_tab                  ->      set_display_and_return_token (DSP_CUSTOM_TAB (get_label (lexeme lexbuf)))
                |itm_auto_tab                    ->      ITM_AUTO_TAB
                |itm_custom_tab                  ->      ITM_CUSTOM_TAB (get_label (lexeme lexbuf))
                |itm_auto_tab_id                 ->      ITM_AUTO_TAB_ID (lexeme lexbuf)
                |itm_custom_tab_id               ->      ITM_CUSTOM_TAB_ID (lexeme lexbuf)
                |nl                              ->      let _ : unit = skip_newlines lexbuf in NL
                |nl_tab                          ->      NL_TAB
                |nl_tab_tab                      ->      NL_TAB_TAB
                |nl_tab_tab_tab                  ->      NL_TAB_TAB_TAB
                |star                            ->      STAR
                |lbr                             ->      LBR
                |rbr                             ->      RBR
                |colon                           ->      COLON
                |section                         ->      SECTION
                |pilcrow                         ->      PILCROW
                |nte_lbr                         ->      NTE_LBR (increase_nte_count_and_return_previous ())
                |txt                             ->      TXT (lexeme lexbuf)
                |start_vrb                       ->      set_verbatim_and_return_token START_VRB
                |eof                             ->      if lexer_env.end_of_file then EOF else set_end_of_file_and_return_token NL
                |_ -> raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
        )

        |true, _, _, _ -> (
                match%sedlex lexbuf with
                |end_vrb                        ->      reset_verbatim_and_return_token END_VRB
                |tab_end_vrb                    ->      reset_verbatim_and_return_token TAB_END_VRB
                |tab_tab_end_vrb                ->      reset_verbatim_and_return_token TAB_TAB_END_VRB
                |tab_tab_tab_end_vrb            ->      reset_verbatim_and_return_token TAB_TAB_TAB_END_VRB
                |vrb_line                       ->      VRB_LINE (remove_nls (lexeme lexbuf))
                |nl                             ->      VRB_LINE_EMPTY
                |tab                            ->      TAB
                |_ -> raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
        )

        |_, true, _, _ -> (
                match%sedlex lexbuf with
                |esc_char                       ->      ESC_CHAR (get_esc_char (lexeme lexbuf))
                |star                           ->      STAR
                |lbr                            ->      LBR
                |rbr                            ->      RBR
                |colon                          ->      COLON
                |section                        ->      SECTION
                |pilcrow                        ->      PILCROW
                |nte_ref                        ->      NTE_REF (lexeme lexbuf, increase_nte_count_and_return_previous ())
                |c_ref                          ->      C_REF (lexeme lexbuf)
                |nte_lbr                        ->      NTE_LBR (increase_nte_count_and_return_previous ())
                |txt                            ->      TXT (lexeme lexbuf)
                |tab                            ->      TAB 
                |dsp_id                         ->      DSP_ID (lexeme lexbuf)
                |nl                             ->      reset_display_and_return_token NL
                |nl_tab                         ->      reset_display_and_return_token NL_TAB
                |nl_tab_tab                     ->      reset_display_and_return_token NL_TAB_TAB
                |nl_tab_tab_tab                 ->      reset_display_and_return_token NL_TAB_TAB_TAB
                |_ -> raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
        )
        |_, _, true, _ -> (
                match%sedlex lexbuf with
                |end_qtn                        ->      reset_quotation_and_return_token END_QTN
                |tab_end_qtn                    ->      reset_quotation_and_return_token TAB_END_QTN
                |tab_tab_end_qtn                ->      reset_quotation_and_return_token TAB_TAB_END_QTN
                |tab_tab_tab_end_qtn            ->      reset_quotation_and_return_token TAB_TAB_TAB_END_QTN
                |nl                             ->      NL
                |br                             ->      BR
                |tab                            ->      TAB
                |star                           ->      STAR
                |lbr                            ->      LBR
                |rbr                            ->      RBR
                |colon                          ->      COLON
                |section                        ->      SECTION
                |pilcrow                        ->      PILCROW
                |txt                            ->      TXT (lexeme lexbuf)
                |_ -> raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
        )
        |_, _, _, true -> (
                match%sedlex lexbuf with
                |end_preamble                   ->      reset_preamble_and_return_token END_PREAMBLE
                |preamble_line                  ->      PREAMBLE_LINE (lexeme lexbuf)
                |nl                             ->      token lexbuf
                |tab                            ->      token lexbuf
                |_ -> raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
        )


and skip_newlines (lexbuf : Sedlexing.lexbuf) : unit =
        match%sedlex lexbuf with
        |nl_not_nl -> Sedlexing.rollback lexbuf
        |nl -> skip_newlines lexbuf
        |_ -> ()
