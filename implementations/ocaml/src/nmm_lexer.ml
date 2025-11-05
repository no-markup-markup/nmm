open Nmm_parser

exception ERROR of string

(************ regular expressions ******************)

let nl = [%sedlex.regexp? "\n" | "\r\n"]
let nl_tab = [%sedlex.regexp? nl, "\t"]
let nl_tab_tab = [%sedlex.regexp? nl_tab, "\t"]
let nl_tab_tab_tab = [%sedlex.regexp? nl_tab_tab, "\t"]
let non_txt_chars = [%sedlex.regexp? Chars "\r\n\t*[]:\\"|Utf8 "¶"|Utf8 "§"]
let txt_chars = [%sedlex.regexp? Compl non_txt_chars]
let txt = [%sedlex.regexp? Plus txt_chars]

let non_name_chars = [%sedlex.regexp? Chars "\r\n\t: \\"]
let name = [%sedlex.regexp? Plus (Compl non_name_chars)]

let tag_unique = [%sedlex.regexp? "CH" | "SEC" | "APP" | "PAR" | "ITM" | "DSP" ]
let tag_shared = [%sedlex.regexp? name]
let tag = [%sedlex.regexp? tag_unique | tag_shared]
let ch_tag_or_id = [%sedlex.regexp? "CH", Opt (":", name)]
let sec_tag_or_id = [%sedlex.regexp? "SEC", Opt (":", name)]
let par_tag_or_id = [%sedlex.regexp? "PAR", Opt (":", name)]
let itm_id = [%sedlex.regexp? "ITM", ":", name]
let dsp_id = [%sedlex.regexp? "DSP", ":", name]
let shared_tag_or_id = [%sedlex.regexp? tag_shared, Opt (":", name)]
let c_ref = [%sedlex.regexp? "[", tag, ":", name, "]"]

let non_custom_chars = [%sedlex.regexp? Chars "\r\n\t"]
let dsp_custom_tab = [%sedlex.regexp? '(', Plus (Compl non_custom_chars), ")\t"]
let itm_custom_tab = [%sedlex.regexp? '[', Plus (Compl non_custom_chars), "]\t"]

let ch_tag_or_id_nl = [%sedlex.regexp? "CH", Opt (":", name), nl]

let pilcrow_nl = [%sedlex.regexp? Utf8 "¶", nl]
let pilcrow_spaces_tag_or_id_nl = [%sedlex.regexp? Utf8 "¶", Star " ", (par_tag_or_id | shared_tag_or_id), nl]

let section_nl = [%sedlex.regexp? Utf8 "§", nl]
let section_spaces_tag_or_id_nl = [%sedlex.regexp? Utf8 "§", Star " ", sec_tag_or_id, nl]

let preamble = [%sedlex.regexp? "PREAMBLE:"]
let title = [%sedlex.regexp? "TITLE:"]
let author = [%sedlex.regexp? "AUTHOR:"]
let abstract = [%sedlex.regexp? "ABSTRACT:"]
let section_refs_nl = [%sedlex.regexp? Utf8 "§", Plus " ", "REFS", Plus nl]

let esc_char = [%sedlex.regexp? '\\', any]

let start_vrb = [%sedlex.regexp? "START\tVERBATIM\n"]
let vrb_line = [%sedlex.regexp? Plus (Compl (Chars "\r\n\t"))]
let end_vrb = [%sedlex.regexp? "END\tVERBATIM\n"]
let tab_end_vrb = [%sedlex.regexp? "\t", end_vrb]
let tab_tab_end_vrb = [%sedlex.regexp? "\t", tab_end_vrb]
let tab_tab_tab_end_vrb = [%sedlex.regexp? "\t", tab_tab_end_vrb]

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

let lexeme (lexbuf:Sedlexing.lexbuf):string=
	Sedlexing.Utf8.lexeme lexbuf

let line_of_lexbuf (lexbuf:Sedlexing.lexbuf):string=
	match Sedlexing.lexing_positions lexbuf with
	(start_pos,end_pos) -> string_of_int (start_pos.pos_lnum)

let return_nl: bool array = [|true|]

let verbatim : bool array = [|false|]

let first_nl : bool array = [|true|]

let nl_or_vrb_line_empty (first : bool ) : Nmm_parser.token =
	match first with
	|true -> let _ : unit = first_nl.(0) <- false in NL
	|false -> VRB_LINE_EMPTY

(************** the lexer ******************************)

let rec lex (lexbuf : Sedlexing.lexbuf) : Nmm_parser.token=
match verbatim.(0) with
|false -> (
	match%sedlex lexbuf with
	|esc_char			->	ESC_CHAR (get_esc_char (lexeme lexbuf))
	|preamble			->	PREAMBLE (lexeme lexbuf)
	|title				->	TITLE (lexeme lexbuf)
	|author				->	AUTHOR (lexeme lexbuf)
	|abstract			->	ABSTRACT (lexeme lexbuf)
	|ch_tag_or_id_nl		->	CH_TAG_OR_ID_NL (String.trim (lexeme lexbuf))
	|c_ref				->	C_REF (lexeme lexbuf)
	|section_nl			->	SECTION_NL
	|section_spaces_tag_or_id_nl	->	SECTION_SPACES_TAG_OR_ID_NL (get_tag_or_id (lexeme lexbuf))
	|pilcrow_nl			->	PILCROW_NL
	|pilcrow_spaces_tag_or_id_nl	->	PILCROW_SPACES_TAG_OR_ID_NL (get_tag_or_id (lexeme lexbuf))
	|section_refs_nl		->	SECTION_REFS_NLS
	|"\t"				->	TAB 
	|"-\t"				->	DASH_TAB
	|"()\t"				->	DSP_AUTO_TAB 
	|"[]\t"				->	ITM_AUTO_TAB
	|nl				->	NL
	|nl_tab				->	NL_TAB
	|nl_tab_tab			->	NL_TAB_TAB
	|nl_tab_tab_tab			->	NL_TAB_TAB_TAB
	|'*'				->	STAR
	|'['				->	LBR
	|']'				->	RBR
	|':'				->	COLON
	|Utf8 "§"			->	SECTION
	|Utf8 "¶"			->	PILCROW
	|dsp_custom_tab			->	DSP_CUSTOM_TAB (get_label (lexeme lexbuf))
	|itm_custom_tab			->	ITM_CUSTOM_TAB (get_label (lexeme lexbuf))
	|itm_id				->	ITM_ID (lexeme lexbuf)
	|dsp_id				->	DSP_ID (lexeme lexbuf)
	|txt				->	TXT (lexeme lexbuf)
	|start_vrb			->	let _ : unit = verbatim.(0) <- true in START_VRB
	|eof				->	end_of_file lexbuf
	|_				->	raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
)
|true -> (
	match%sedlex lexbuf with
	|end_vrb			->	let _ : unit = verbatim.(0) <- false in END_VRB
	|tab_end_vrb			->	let _ : unit = verbatim.(0) <- false in TAB_END_VRB
	|tab_tab_end_vrb		->	let _ : unit = verbatim.(0) <- false in TAB_TAB_END_VRB
	|tab_tab_tab_end_vrb		->	let _ : unit = verbatim.(0) <- false in TAB_TAB_TAB_END_VRB
	|vrb_line			->	let _ : unit = first_nl.(0) <- true in VRB_LINE (lexeme lexbuf)
	|nl				->	nl_or_vrb_line_empty first_nl.(0)
	|"\t"				->	TAB
	|_				->	raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (lexeme lexbuf) ^ "\""))
)

and end_of_file (lexbuf : Sedlexing.lexbuf) : Nmm_parser.token =
	match return_nl.(0) with
	|true -> let _ = return_nl.(0) <- false in let _ = lex lexbuf in NL
	|false -> EOF


