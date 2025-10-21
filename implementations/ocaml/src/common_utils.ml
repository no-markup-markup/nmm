open Doc_types

exception Error of string

(**************************** document settings ************************)

type t_doc_settings = {
	mutable doc_width : int;
	mutable left_margin: int;
	mutable title_indent: int;
	mutable author_indent: int;
	mutable abstract_indent: int;
	mutable refs_indent: int;
	mutable tab_length : int;
	mutable abstract_prefix: string option;
	mutable refs_prefix: string option;
	mutable ch_prefix: string option;
	mutable sec_prefix: string option;
	mutable par_prefix : string option;
	mutable expand_tag: Doc_types.ts_tag -> string option;
}

type t_doc_type = CHS | SECS | PARS | BLKS

let expand_tag_default (tag : Doc_types.ts_tag) : string option =
	match tag with
	|Cs_tag "DEF" -> Some "DEFINITION"
	|Cs_tag "PRF" -> Some "PROOF"
	|Cs_tag "FCT" -> Some "FACT"
	|Cs_tag "LMA" -> Some "LEMMA"
	|Cs_tag "THM" -> Some "THEOREM"
	| _  -> None


let doc_settings : t_doc_settings = {
	doc_width = 80;
	left_margin = 12;
	title_indent = 12;
	author_indent = 12;
	abstract_indent = 12;
	refs_indent = 12;
	tab_length = 6;
	abstract_prefix = Some "Abstract";
	refs_prefix = Some "References";
	ch_prefix = Some "CHAPTER";
	sec_prefix = Some "§";
	par_prefix = Some "¶";
	expand_tag = expand_tag_default;
}

let rec doc_settings_of_tr_doc (doc : Doc_types.tr_doc) : unit =
	let _ : unit = (
		match contains_sec_or_par doc with
			|false -> 
				let _ : unit = doc_settings.title_indent <- 0 in 
				let _ : unit = doc_settings.author_indent <- 0 in
				let _ : unit = doc_settings.abstract_indent <- 0 in
				let _ : unit = doc_settings.refs_indent <- 0 in
				let _ : unit = doc_settings.left_margin <- 0 in
				doc_settings.doc_width <- 68
			|true -> ()
	)
	in
	match doc.fld_doc_preamble with
	|None -> ()
	|Some preamble -> doc_settings_of_ts_preamble preamble 

and doc_type_of_tr_doc (doc : Doc_types.tr_doc) : t_doc_type =
	match doc.fld_doc_main with
	|Cu_doc_main_chs _ -> CHS
	|Cu_doc_main_secs _ -> SECS
	|Cu_doc_main_pars _ -> PARS
	|Cu_doc_main_blks _ -> BLKS

and contains_sec_or_par (doc : Doc_types.tr_doc) : bool =
	match doc.fld_doc_main with
	| Cu_doc_main_blks _ -> false
	| Cu_doc_main_chs (chs : Doc_types.ts_chs) -> (
		let rec aux (ch_list : Doc_types.tr_ch list) : bool =
			match ch_list with
			|[] -> false
			|hd::tl -> 
				match hd.fld_ch_main with
				| Cu_secs_pars_or_blks_secs _ -> true
				| Cu_secs_pars_or_blks_pars _ -> true
				| Cu_secs_pars_or_blks_blks _ -> aux tl
		in
		match chs with
		|Cs_chs ch_list -> aux ch_list
	)
	| Cu_doc_main_secs _ -> true
	| Cu_doc_main_pars _ -> true

and doc_settings_of_ts_preamble (preamble : Doc_types.ts_preamble) : unit =
	let rec aux (str_list : string list) : unit =
		match str_list with
		| hd :: tl -> 
			let _ : unit =
				match key_value_pair_of_string_opt hd with
				|Some ("doc_width", v) -> set_doc_width v
				|Some ("left_margin", v) -> set_left_margin v
				|Some ("title_indent", v) -> set_title_indent v
				|Some ("author_indent", v) -> set_author_indent v
				|Some ("tab_length", v) -> set_tab_length v
				|Some ("ch_prefix", v) -> set_ch_prefix v
				|Some ("sec_prefix", v) -> set_sec_prefix v
				|Some ("par_prefix", v) -> set_par_prefix v
				|Some ("abstract_prefix", v) -> set_abstract_prefix v
				|Some ("refs_prefix", v) -> set_refs_prefix v
				|Some ("expand_tag", v) -> set_expand_tag doc_settings.expand_tag v
				|_ -> Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid attribute: ";hd;"\n";"ignoring it"])
			in aux tl
		| [] -> ()
	in
	match preamble with 
	(Cs_preamble (s : string)) -> 
		let str_list : string list = String.split_on_char ';' s in
		aux str_list

and key_value_pair_of_string_opt (s : string): (string*string) option=
	match String.split_on_char '=' s with
	|[key;value] -> Some (key, value)
	| _ -> None

and set_doc_width (v : string) : unit =
	try doc_settings.doc_width <- (int_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid doc_width value: ";v;"\n";"using default value"])

and set_left_margin (v : string) : unit =
	try doc_settings.left_margin <- (int_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid left_margin value: ";v;"\n";"using default value"])

and set_title_indent (v : string) : unit =
	try doc_settings.title_indent <- (int_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid title_indent value: ";v;"\n";"using default value"])

and set_author_indent (v : string) : unit =
	try doc_settings.author_indent <- (int_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid author_indent value: ";v;"\n";"using default value"])

and set_tab_length (v : string) : unit =
	try doc_settings.tab_length <- (int_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid tab_length value: ";v;"\n";"using default value"])

and set_ch_prefix (v : string) : unit =
	try doc_settings.ch_prefix <- (prefix_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid ch_prefix value: ";v;"\n";"using default value"])

and set_sec_prefix (v : string) : unit =
	try doc_settings.sec_prefix <- (prefix_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid sec_prefix value: ";v;"\n";"using default value"])

and set_par_prefix (v : string) : unit =
	try doc_settings.par_prefix <- (prefix_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid par_prefix value: ";v;"\n";"using default value"])

and set_abstract_prefix (v : string) : unit =
	try doc_settings.abstract_prefix <- (prefix_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid abstract_prefix value: ";v;"\n";"using default value"])

and set_refs_prefix (v : string) : unit =
	try doc_settings.refs_prefix <- (prefix_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid refs_prefix value: ";v;"\n";"using default value"])

and set_expand_tag (expand_tag_old : Doc_types.ts_tag -> string option) (v : string) : unit =
	try doc_settings.expand_tag <- (expand_tag_value_of_string expand_tag_old v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid expand_tag value: ";v;"\n";"using default value"])

and prefix_value_of_string (v : string) : string option =
	match v with
	|"None" | "none" | "" | "\"\"" -> None
	| _ -> Some v

and expand_tag_value_of_string (expand_tag_old : Doc_types.ts_tag -> string option) (v : string) : (Doc_types.ts_tag -> string option) =
	match String.split_on_char '>' v with
	|[tag_string; expanded_tag_string] -> (
		let expand_tag_new ( tag : Doc_types.ts_tag) : string option = 
			match tag with
			|Cs_tag (s : string) ->
				match s = tag_string with
				|true -> Some expanded_tag_string
				|false -> expand_tag_old tag
		in expand_tag_new
	)
	| _ -> raise (Error "invalid expand_tag value")

(**************************** labels and cross-references *********************************)

type t_path = t_node list

and t_node =
	| ABSTRACT_NODE
	| CH_NODE of int
	| SEC_NODE of int
	| APP_NODE of int
	| PAR_NODE of int
	| ITM_NODE of t_itm_node
	| DSP_NODE
	| BLT_NODE
	| DSP_LINE_NODE of t_dsp_line_node
	| REFS_NODE

and t_itm_node = ITM_INT of int | ITM_STRING of string

and t_dsp_line_node =
	| DSP_INT of int
	| DSP_STRING of string
	| NONE

type t_cref_table = (Doc_types.tr_id * t_path) list

type t_doc_cref_table = { mutable content : t_cref_table }

let doc_cref_table : t_doc_cref_table = { content = [] }

let rec string_of_ts_c_ref (pos : t_path) (c_ref : Doc_types.ts_c_ref) : string =
	match c_ref with Cs_c_ref (id : Doc_types.tr_id) ->
	let pos_string : string =
		match string_of_path pos pos with 
		| None -> "document" 
		| Some s -> s
	in
	let rec aux (cref_table : t_cref_table) : string option =
		match cref_table with
		| [] -> None
		| ((id_entry : Doc_types.tr_id), (path_entry : t_path)) :: tl -> 
			match id = id_entry with
			| true -> (
				match path_entry, string_of_path path_entry (sub_path_of_cref_path pos path_entry) with
				|hd::tl, Some (s : string) -> (
					match hd with
					|CH_NODE _ -> (
						match doc_settings.ch_prefix with
						|None -> Some s
						|Some prefix -> Some (String.concat "\u{00A0}" [prefix;s])
					)
					|SEC_NODE _ -> (
						match doc_settings.sec_prefix with
						|None -> Some s
						|Some prefix -> Some (String.concat "\u{00A0}" [prefix;s])
					)
					|PAR_NODE _ -> (
						match doc_settings.par_prefix with
						|None -> Some s
						|Some prefix -> Some (String.concat "\u{00A0}" [prefix;s])
					)
					| _ -> Some s
				)
				| _ , _ -> raise (Error "path in cref_table not expected to be empty")
			)
			| false -> aux tl

	in
	match aux doc_cref_table.content with
	| None ->
		let _ : unit = Debug_utils.print_to_stderr ("WARNING: undefined reference in " ^ pos_string) in 
		"??"
	| Some (t : string) -> t


and sub_path_of_cref_path (pos : t_path) (path : t_path) : t_path =
	let rev_pos : t_path = List.rev pos in
	let rev_path : t_path = List.rev path in
	let pos_string : string =
		match string_of_path pos pos with 
		| None -> "document" 
		| Some s -> s
	in
	let rec aux (rev_pos : t_path) (rev_path : t_path) : t_path = (
		match (rev_pos, rev_path) with
		| pos_hd :: pos_tl, path_hd :: path_tl -> (
			match pos_hd = path_hd with
			| true -> aux pos_tl path_tl
			| false -> List.rev rev_path
		)
		| [], [] -> 
			let _ : unit = Debug_utils.print_to_stderr ("WARNING: self-reference in " ^ pos_string) in
			[List.hd path]
		| pos_hd :: pos_tl, [] ->
			let _ : unit = Debug_utils.print_to_stderr ("WARNING: reference to parent node in " ^ pos_string) in
			[List.hd path]
		| [], path_hd :: path_tl ->
		(*	let _:unit=Debug_utils.print_to_stderr ("WARNING: reference to child node in " ^ pos_string) in *)
			List.rev rev_path
	)
	in 
	aux rev_pos rev_path


and string_of_path (full_path:t_path) (path : t_path) : string option =
	match full_path,path with
	| _, [] -> None
	| full_path_hd::full_path_tl,path_hd :: path_tl -> (
		match path_hd with 
		| CH_NODE _ 
		| SEC_NODE _
		| APP_NODE _
		| PAR_NODE _ -> 
			string_of_node full_path_tl path_hd
		| _ -> (
			match (string_of_path full_path_tl path_tl, string_of_node full_path_tl path_hd) with
			| Some s, Some t -> Some (s ^ t)
			| None, Some t -> Some t
			| Some s, None -> Some s
			| None, None -> None
		)
	)
	| [], _ -> raise (Error "full path shorter than path")

and string_of_node (tail : t_path) (head : t_node) : string option =
	let lpar,rpar = 
		match tail with
		|[] -> "(",")"
		|hd::tl ->
			match hd with
			|REFS_NODE -> "[","]"
			| _ -> "(",")"
	in
	match head with
	| CH_NODE (n : int)
	| SEC_NODE (n : int)
	| PAR_NODE (n : int) -> (
		match string_of_path tail tail with
		|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
		|None -> Some (string_of_int (n + 1))
	)
	| APP_NODE (n : int) -> (
		match string_of_path tail tail with
		|Some s -> (try Some (s ^ "." ^ upper_case_latin_letters.(n)) with _ -> raise (Error "You have too many appendices!"))
		|None -> Some upper_case_latin_letters.(n)
	)
	| DSP_NODE -> None
	| DSP_LINE_NODE (a : t_dsp_line_node) -> (
		match a with
		| NONE -> None
		| DSP_INT (n : int) ->
			let s : string =
				match lvl_of_path tail mod 3 with
				| 0 -> string_of_int (n + 1)
				| 1 -> lower_case_latin_letters.(n)
				| _ -> lower_case_roman_numerals.(n)
			in Some (String.concat s [ lpar; rpar ])
		| DSP_STRING (s : string) -> Some (String.concat s [ lpar; rpar ])
	)
	| ITM_NODE (a : t_itm_node) ->
		string_of_node tail (DSP_LINE_NODE (dsp_line_node_of_itm_node a))
	| BLT_NODE ->
		let l : int = lvl_of_path tail in
		Some bullets.(l mod Array.length bullets)
	| _ -> None

and lvl_of_path (path : t_path) : int =
	match path with
	| [] -> 0
	| hd :: tl ->
		match hd with
		| ITM_NODE _ -> lvl_of_path tl + 1
		| BLT_NODE -> lvl_of_path tl + 1
		| _ -> lvl_of_path tl

and dsp_line_node_of_itm_node (a : t_itm_node) : t_dsp_line_node =
	match a with
	| ITM_INT i -> DSP_INT i
	| ITM_STRING s -> DSP_STRING s


and node_of_blk_itm (auto_nr : int) (a : Doc_types.tr_blk_itm) : t_node =
	let itm_node : t_itm_node =
		match a.fld_blk_itm_lbl with
		| Cu_lbl_auto Cs_lbl_auto -> ITM_INT auto_nr
		| Cu_lbl_custom (Cs_lbl_custom (s : string)) -> ITM_STRING s
	in ITM_NODE itm_node

and node_of_dsp_line (auto_nr : int) (a : Doc_types.tr_dsp_line) : t_node =
	let dsp_line_node : t_dsp_line_node =
		match a.fld_dsp_line_lbl with
		| Some (Cu_lbl_auto Cs_lbl_auto)-> DSP_INT auto_nr
		| Some (Cu_lbl_custom (Cs_lbl_custom (s : string))) -> DSP_STRING s
		| None -> NONE
	in 
	DSP_LINE_NODE dsp_line_node

and lower_case_latin_letters : string array =
	[|"a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";"m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"x";"y";"z";|]

and lower_case_roman_numerals : string array =
	[|"i";"ii";"iii";"iv";"v";"vi";"vii";"viii";"ix";"x";"xi";"xii";"xiii";"xiv";"xv";"xvi";"xvii";"xviii";"xix";"xx";|]

and upper_case_latin_letters : string array =
	[|"A";"B";"C";"D";"E";"F";"G";"H";"I";"J";"K";"L";"M";"N";"O";"P";"Q";"R";"S";"T";"U";"V";"X";"Y";"Z";|]

and upper_case_roman_numerals : string array =
	[|"I";"II";"III";"IV";"V";"VI";"VII";"VIII";"IX";"X";"XI";"XII";"XIII";"XIV";"XV";"XVI";"XVII";"XVIII";"XIX";"XX";|]

and bullets : string array = [| "─" |]


and label_of_path_opt (path : t_path) : string option =
	match path with
	| [] -> None
	| hd :: tl ->
		let s_opt : string option = string_of_node tl hd in
		match hd with
		| CH_NODE _ -> (
			match (doc_settings.ch_prefix, s_opt) with
			| None, Some t -> Some t
			| Some u, Some t -> Some (u ^ "\u{00A0}" ^ t)
			| _, None-> None
		)
		| SEC_NODE _
		| APP_NODE _ -> (
			match (doc_settings.sec_prefix, s_opt) with
			| None, Some t -> Some t
			| Some u, Some t -> Some (u ^ "\u{00A0}" ^ t)
			| _, None-> None
		)
		| PAR_NODE _ -> (
			match (doc_settings.par_prefix, s_opt) with
			| None, Some t -> Some t
			| Some u, Some t -> Some (u ^ "\u{00A0}" ^ t)
			| _, None-> None
		)
		| ITM_NODE _ -> s_opt
		| BLT_NODE -> s_opt
		| DSP_LINE_NODE _ -> s_opt
		| ABSTRACT_NODE -> doc_settings.abstract_prefix
		| REFS_NODE -> doc_settings.refs_prefix
		| _ -> s_opt

and label_of_path (path : t_path) : string=
	match label_of_path_opt path with
	| None -> ""
	| Some (s : string) -> s


