open Nmm_parser

exception Error of string

(******* For debugging purposes: *************) 

let string_of_token (t:Nmm_parser.token):string=
	match t with
	|SECTION -> "SECTION"
	|SECTION_NL -> "SECTION_NL"
	|PILCROW -> "PILCROW"
	|PILCROW_NL -> "PILCROW_NL"
	|DASH_TAB -> "DASH_TAB"
	|DSP_AUTO_TAB -> "DSP_AUTO_TAB"
	|ITM_AUTO_TAB -> "ITM_AUTO_TAB"
	|NL -> "NL"
	|NL_TAB -> "NL_TAB"
	|NL_TAB_TAB -> "NL_TAB_TAB"
	|NL_TAB_TAB_TAB -> "NL_TAB_TAB_TAB"
	|STAR -> "STAR"
	|TAB -> "TAB"
	|LBR -> "LBR"
	|RBR -> "RBR"
	|COLON -> "COLON"
	|EOF -> "EOF"
	|CH_TAG_OR_ID_NL s -> ("CH_TAG_OR_ID_NL " ^ "\"" ^ s ^ "\"")
	|SECTION_SPACES_TAG_OR_ID_NL s -> ("SECTION_SPACES_TAG_OR_ID_NL " ^ "\"" ^ s ^ "\"")
	|PILCROW_SPACES_TAG_OR_ID_NL s -> ("PILCROW_SPACES_TAG_OR_ID_NL " ^ "\"" ^ s ^ "\"")
	|PILCROW_SPACES_RPT_SPACES_ID_NL s -> ("PILCROW_SPACES_RPT_SPACES_ID_NL " ^ "\"" ^ s ^ "\"")
	|TXT s -> ("TXT " ^ "\"" ^ s ^ "\"")
	|DSP_CUSTOM_TAB s -> ("DSP_CUSTOM_TAB " ^ "\"" ^ s ^ "\"")
	|ITM_CUSTOM_TAB s -> ("ITM_CUSTOM_TAB " ^ "\"" ^ s ^ "\"")
	|ITM_AUTO_TAB_ID s -> ("ITM_AUTO_TAB_ID " ^ "\"" ^ s ^ "\"")
	|ITM_CUSTOM_TAB_ID s -> ("ITM_CUSTOM_TAB_ID " ^ "\"" ^ s ^ "\"")
	|DSP_ID s -> ("DSP_ID " ^ "\"" ^ s ^ "\"")
	|C_REF s -> ("C_REF " ^ "\"" ^ s ^ "\"")
	|TITLE s -> ("TITLE " ^ "\"" ^ s ^ "\"")
	|AUTHOR s -> ("AUTHOR " ^ "\"" ^ s ^ "\"")
	|PREAMBLE s -> ("PREAMBLE " ^ "\"" ^ s ^ "\"")
	|ESC_CHAR s -> ("ESC_CHAR " ^ "\"" ^ s ^ "\"")
	|ABSTRACT s -> ("ABSTRACT " ^ "\"" ^ s ^ "\"")
	|SECTION_REFS_NLS -> "SECTION_REFS_NLS"
	|PILCROW_REFS_NLS -> "PICLROW_REFS_NLS"
	|VRB_LINE s -> ("VRB_LINE " ^ "\"" ^ s ^ "\"")
	|START_VRB -> "START_VRB"
	|VRB_LINE_EMPTY -> "VRB_LINE_EMPTY"
	|END_VRB -> "END_VRB"
	|TAB_END_VRB -> "TAB_END_VRB"
	|TAB_TAB_END_VRB -> "TAB_TAB_END_VRB"
	|TAB_TAB_TAB_END_VRB -> "TAB_TAB_TAB_END_VRB"

let lexer (print_tokens:bool) (b:Sedlexing.lexbuf):(Nmm_parser.token*Lexing.position*Lexing.position)=
	let t:Nmm_parser.token=Nmm_lexer.lex b in
	let start_pos,end_pos=Sedlexing.lexing_positions b in
	match print_tokens with
	|true -> let _ = Debug_utils.print_to_stderr ("Line " ^ (Nmm_lexer.line_of_lexbuf b) ^ ": " ^ (string_of_token t)) in (t,start_pos,end_pos)
	|false -> (t,start_pos,end_pos)


(******************************************************************)

let rec doc_of_nmm_file (print_tokens:bool) (filename:string):Doc_types.tr_doc=
	let _ : unit = Nmm_lexer.return_nl.contents <- true in
	let _ : unit = Nmm_lexer.verbatim.contents <- false in
	let _ : unit = Nmm_lexer.first_nl.contents <- true in
	let _ : unit = Nmm_lexer.display.contents <- false in
	match Sys.file_exists filename with
	|false -> raise (Error ("cannot read from " ^ filename ^ ": No such file"))
	|true -> 
	let ic=open_in filename in
	let lexbuf=Sedlexing.Utf8.from_channel ic in
	let revised_lexer () = (lexer print_tokens) lexbuf in 
	let revised_parser = MenhirLib.Convert.Simplified.traditional2revised Nmm_parser.main in
	try
		let doc = revised_parser revised_lexer in
		let _ : unit = close_in ic in doc
	with
	| Nmm_parser.Error (n : int) ->
		match print_tokens with
		|false -> 
			let _ : unit = Debug_utils.print_to_stderr (
				String.concat "\n" [
					"Parsing failed in the following state of the automaton:";
					"=======================================================";
					Nmm_parser_automaton.state n;
					"=======================================================";
					"Read the the following tokens from " ^ filename ^ ":";
				]
			) 
			in doc_of_nmm_file true filename
		|true -> raise (Error ("Last token does not match any transition- or reduction-rule of State " ^ (Int.to_string n) ^ "."))

let rec doc_of_nmm_string (print_tokens:bool) (s:string):Doc_types.tr_doc=
	let _ : unit = Nmm_lexer.return_nl.contents <- true in
	let _ : unit = Nmm_lexer.verbatim.contents <- false in
	let _ : unit = Nmm_lexer.first_nl.contents <- true in
	let _ : unit = Nmm_lexer.display.contents <- false in
	let lexbuf = Sedlexing.Utf8.from_string s in
	let revised_lexer () = (lexer print_tokens) lexbuf in 
	let revised_parser = MenhirLib.Convert.Simplified.traditional2revised Nmm_parser.main in
	try
		revised_parser revised_lexer
	with
	| Nmm_parser.Error (n : int) ->
		match print_tokens with
		|false -> 
			let _ : unit = Debug_utils.print_to_stderr (
				String.concat "\n" [
					"Parsing failed in the following state of the automaton:";
					"=======================================================";
					Nmm_parser_automaton.state n;
					"=======================================================";
					"Read the the following tokens from string:";
				]
			) 
			in doc_of_nmm_string true s
		|true -> raise (Error ("Last token does not match any transition- or reduction-rule of State " ^ (Int.to_string n) ^ "."))

let rec doc_of_nmm_stdin (print_tokens:bool) : Doc_types.tr_doc=
	let _ : unit = Nmm_lexer.return_nl.contents <- true in
	let _ : unit = Nmm_lexer.verbatim.contents <- false in
	let _ : unit = Nmm_lexer.first_nl.contents <- true in
	let _ : unit = Nmm_lexer.display.contents <- false in
	let input : string = In_channel.input_all stdin in
	let lexbuf = Sedlexing.Utf8.from_string input in
	let revised_lexer () = (lexer print_tokens) lexbuf in 
	let revised_parser = MenhirLib.Convert.Simplified.traditional2revised Nmm_parser.main in
	try
		revised_parser revised_lexer
	with
	| Nmm_parser.Error (n : int) ->
		match print_tokens with
		|false -> 
			let _ : unit = Debug_utils.print_to_stderr (
				String.concat "\n" [
					"Parsing failed in the following state of the automaton:";
					"=======================================================";
					Nmm_parser_automaton.state n;
					"=======================================================";
					"Read the the following tokens from standard input:";
				]
			) 
			in doc_of_nmm_stdin true
		|true -> raise (Error ("Last token does not match any transition- or reduction-rule of State " ^ (Int.to_string n) ^ "."))

