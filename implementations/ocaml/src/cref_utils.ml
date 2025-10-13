open Doc_types

exception Error of string

type t_cref_table = (Doc_types.tr_id * t_path) list

and t_path = t_node list

and t_node =
	| CH_NODE of int
	| SEC_NODE of int
	| APP_NODE of int
	| PAR_NODE of int
	| ITM_NODE of t_itm_node
	| DSP_NODE
	| BLT_NODE
	| DSP_LINE_NODE of t_dsp_line_node

and t_itm_node = ITM_INT of int | ITM_STRING of string

and t_dsp_line_node =
	| DSP_INT of int
	| DSP_STRING of string
	| NONE

type t_doc_cref_table = { mutable content : t_cref_table }

let doc_cref_table : t_doc_cref_table = { content = [] }

let rec string_of_ts_c_ref (pos : t_path) (c_ref : Doc_types.ts_c_ref) : string =
	match c_ref with Cs_c_ref (id : Doc_types.tr_id) ->
	let s : string =
		match string_of_path pos pos with 
		| None -> "document" 
		| Some s -> s
	in
	let rec aux (cref_table : t_cref_table) : string option =
		match cref_table with
		| [] -> None
		| ((id_entry : Doc_types.tr_id), (path_entry : t_path)) :: tl -> 
			match id = id_entry with
			| true -> string_of_path path_entry (sub_path_of_cref_path pos path_entry)
			| false -> aux tl
	in
	match aux doc_cref_table.content with
	| None ->
		let _ : unit = Debug_utils.print_to_stderr ("WARNING: undefined reference in " ^ s) in 
		"??"
	| Some (t : string) -> t


and sub_path_of_cref_path (pos : t_path) (path : t_path) : t_path =
	let rev_pos : t_path = List.rev pos in
	let rev_path : t_path = List.rev path in
	let s : string =
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
			let _ : unit = Debug_utils.print_to_stderr ("WARNING: self-reference in " ^ s) in
			[List.hd path]
		| pos_hd :: pos_tl, [] ->
			let _ : unit = Debug_utils.print_to_stderr ("WARNING: reference to parent node in " ^ s) in
			[List.hd path]
		| [], path_hd :: path_tl ->
		(*	let _:unit=Debug_utils.print_to_stderr ("WARNING: reference to child node in "^s) in *)
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
		| PAR_NODE _ -> (
			match (string_of_node full_path_tl path_hd) with
			| Some s -> Some s
			| None -> None
		)
		| _ -> (
			match (string_of_path full_path_tl path_tl, string_of_node full_path_tl path_hd) with
			| Some s, Some t -> Some (s ^ t)
			| None, Some t -> Some t
			| Some s, None -> Some s
			| None, None -> None
		)
	)
	| [], _ -> raise (Error "full path shorter than path")

and string_of_node (pos : t_path) (node : t_node) : string option =
	match node with
	| CH_NODE (n : int)
	| SEC_NODE (n : int)
	| PAR_NODE (n : int) -> (
		match string_of_path pos pos with
		|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
		|None -> Some (string_of_int (n + 1))
	)
	| APP_NODE (n : int) -> (
		match string_of_path pos pos with
		|Some s -> (try Some (s ^ "." ^ upper_case_latin_letters.(n)) with _ -> raise (Error "You have too many appendices!"))
		|None -> Some upper_case_latin_letters.(n)
	)
	| DSP_NODE -> None
	| DSP_LINE_NODE (a : t_dsp_line_node) -> (
		match a with
		| NONE -> None
		| DSP_INT (n : int) ->
			let s : string =
				match lvl_of_path pos mod 3 with
				| 0 -> string_of_int (n + 1)
				| 1 -> lower_case_latin_letters.(n)
				| _ -> lower_case_roman_numerals.(n)
			in Some (String.concat s [ "("; ")" ])
		| DSP_STRING (s : string) -> Some (String.concat s [ "("; ")" ])
	)
	| ITM_NODE (a : t_itm_node) ->
		string_of_node pos (DSP_LINE_NODE (dsp_line_node_of_itm_node a))
	| BLT_NODE ->
		let l : int = lvl_of_path pos in
		Some bullets.(l mod Array.length bullets)

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
		| Ce_lbl_auto Cs_lbl_auto -> ITM_INT auto_nr
		| Ce_lbl_custom (Cs_lbl_custom (s : string)) -> ITM_STRING s
	in ITM_NODE itm_node

and node_of_dsp_line (auto_nr : int) (a : Doc_types.tr_dsp_line) : t_node =
	let dsp_line_node : t_dsp_line_node =
		match a.fld_dsp_line_lbl with
		| Some (Ce_lbl_auto Cs_lbl_auto)-> DSP_INT auto_nr
		| Some (Ce_lbl_custom (Cs_lbl_custom (s : string))) -> DSP_STRING s
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


