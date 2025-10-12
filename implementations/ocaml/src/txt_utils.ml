open Doc_types
open Cref_utils

type t_doc_settings = {
	mutable doc_width : int;
	mutable left_margin: int;
	mutable title_indent: int;
	mutable author_indent: int;
	mutable tab_length : int;
	mutable sec_symbol: string option;
	mutable par_symbol : string option;
}

let doc_settings : t_doc_settings = {
	doc_width = 80;
	left_margin = 12;
	title_indent = 12;
	author_indent = 12;
	tab_length = 6;
	sec_symbol = Some "§";
	par_symbol = Some "¶";
}

let remove_empty_endlines (lines : string list) : string list =
	let rec aux (lst : string list) : string list =
		match lst with
		|""::tl -> aux tl
		|_ -> lst
	in
	List.rev (aux (List.rev lines))


let rec doc_settings_of_tr_doc (doc : Doc_types.tr_doc) : unit =
	let _ : unit = (
		match doc.fld_doc_main with
			|Ce_doc_main_blks _ -> 
				let _ : unit = doc_settings.title_indent <- 0 in 
				let _ : unit = doc_settings.author_indent <- 0 in
				doc_settings.doc_width <- 68
			| _ -> ()
	)
	in
	match doc.fld_doc_preamble with
	|None -> ()
	|Some preamble -> doc_settings_of_ts_preamble preamble 

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
				|Some ("sec_symbol", v) -> set_sec_symbol v
				|Some ("par_symbol", v) -> set_par_symbol v
				|_ -> Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid attribute: ";hd;"\n";"ignoring it"])
			in aux tl
		| [] -> ()
	in
	match preamble with 
	(Cs_preamble (s : string)) -> 
		let str_list : string list = List.map String.trim (String.split_on_char ' ' s) in
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

and set_sec_symbol (v : string) : unit =
	try doc_settings.sec_symbol <- (symbol_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid sec_symbol value: ";v;"\n";"using default value"])

and set_par_symbol (v : string) : unit =
	try doc_settings.par_symbol <- (symbol_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid par_symbol value: ";v;"\n";"using default value"])

and symbol_value_of_string (v : string) : string option =
	match v with
	|"None" | "none" | "" | "\"\"" -> None
	| _ -> Some v

and lines_of_ts_hdr (path : Cref_utils.t_path) (a : Doc_types.ts_hdr) : string list =
	match a with
	| Cs_hdr (b : Doc_types.ts_txt_units) -> 
		let hdr_string = string_of_ts_txt_units path b in
		let underline = String.concat "" [
			make_string doc_settings.left_margin " ";
			make_string (Int.min (utf8_length hdr_string) (doc_settings.doc_width - doc_settings.left_margin)) "─";
		]
		in
		match lines_of_string doc_settings.left_margin hdr_string with
		| hd::tl -> List.concat [(insert_mark path hd)::tl;[underline]]
		| [] -> []


and lines_of_ts_title (title : Doc_types.ts_title) : string list =
	match title with
	|Cs_title (s : string) -> List.concat [lines_of_string doc_settings.title_indent s; [""]]

and lines_of_ts_author (author : Doc_types.ts_author) : string list =
	match author with
	|Cs_author (s : string) -> List.concat [lines_of_string doc_settings.author_indent s; [""]]

and make_string (n:int) (s:string) : string=
	let rec aux (i:int) (acc:string) = 
		if i > n - 1 then acc else aux (i+1) (acc ^ s) 
	in aux 0 ""

and lines_of_ts_txt_units (path : Cref_utils.t_path) (a : Doc_types.ts_txt_units) : string list =
	let lines_of_string_function : int -> string -> string list = (
		match path with
		| [] -> lines_of_string
		| hd :: tl -> 
			match hd with
			| DSP_LINE_NODE _ -> lines_of_string_dsp
			| _ -> lines_of_string
	)
	in 
	lines_of_string_function (indent_of_path path) (string_of_ts_txt_units path a)

and string_of_ts_txt_units (path : Cref_utils.t_path) (a : Doc_types.ts_txt_units) : string =
	match a with Cs_txt_units (b: Doc_types.te_txt_unit list) ->
	String.concat "" (List.map (string_of_ts_txt_unit path) b)

and string_of_ts_txt_unit (path : Cref_utils.t_path) (a : Doc_types.te_txt_unit) : string =
	match a with
	| Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg (b : string)) -> b
	| Ce_txt_unit_emph (Cs_txt_unit_emph (b : string)) -> emph b
	| Ce_txt_unit_c_ref (Cs_txt_unit_c_ref (b : ts_c_ref)) -> string_of_ts_c_ref path b

and emph (a : string) : string = underline a

and underline (s : string) : string =
	let lst = utf8_of_string s in
	let map (el : string) : string = el ^ "\u{0331}" in 
	String.concat "" (List.map map lst)

and lines_of_string (indent : int) (s : string) : string list =
	let line_width : int = doc_settings.doc_width - indent in
	let ind : string = String.make indent ' ' in
	let rec aux (ind : string) (line_width : int) (s : string) (acc : string list) : string list = (
		match String.length s with
		| 0 -> List.rev acc
		| _ -> match line_break line_width s with
			| s1, s2 -> aux ind line_width s2 ((ind ^ s1) :: acc)
	)
	in 
	aux ind line_width s []

and lines_of_string_dsp (indent : int) (s : string) : string list =
	let ind : string = String.make indent ' ' in
	let lst : string list = String.split_on_char '\n' s in
	List.map (fun t -> ind ^ t) lst

and line_break (line_width : int) (s : string) : string * string =
	match utf8_length s <= line_width with
	| true -> (s, "")
	| false -> 
		let rec aux (line_width : int) (s : string) (i : int) : int = (
			match String.index_from_opt s (i + 1) ' ' with
			| None -> i
			| Some (j : int) -> 
				match utf8_length (String.sub s 0 j) <= line_width with
				| true -> aux line_width s j
				| false -> i
		)
		in
		match String.index_from_opt s 0 ' ' with
		| None -> (s, "")
		| Some (i : int) ->
			match utf8_length (String.sub s 0 i) <= line_width with
			| true ->
				let j = aux line_width s i in
				(String.sub s 0 j, String.sub s (j + 1) (String.length s - j - 1))
			| false -> (s, "")

and insert_mark (path : Cref_utils.t_path) (s : string) : string =
	match mark_of_path_opt path with
	| None -> s
	| Some (t : string) -> insert_string t (pos_of_mark path) s

and pos_of_mark (path : Cref_utils.t_path) : int =
	match path with
	| [] -> 0
	| hd :: tl ->
		match hd with
		| ITM_NODE _ -> indent_of_path path - doc_settings.tab_length
		| BLT_NODE -> indent_of_path path - doc_settings.tab_length
		| DSP_LINE_NODE _ -> indent_of_path path - doc_settings.tab_length
		| _ -> 0

and insert_string (mark : string) (pos : int) (s : string) : string =
	let string_len : int = String.length s in
	let mark_len : int = utf8_length mark in
	let target : string = String.sub s pos mark_len in
	let ideal_target : string = String.make mark_len ' ' in
	let s1 : string = String.sub s 0 pos in
	let s2 : string =
		match (*0<=(string_len - pos - mark_len) && mark_len<doc_settings.tab_length &&*) target = ideal_target with
		|true -> String.sub s (pos + mark_len) (string_len - pos - mark_len)
		|false -> ("\n"^s)
	in
	String.concat mark [ s1; s2 ]

and mark_of_path_opt (path : Cref_utils.t_path) : string option =
	match path with
	| [] -> None
	| hd :: tl ->
		let s = string_of_node tl hd in
		match hd with
		| SEC_NODE _ -> (
			match (doc_settings.sec_symbol, s) with
			| None, Some s -> Some s
			| Some u, Some s -> Some (u ^ "\u{00A0}" ^ s)
			| _, None-> None
		)
		| PAR_NODE _ -> (
			match (doc_settings.par_symbol, s) with
			| None, Some s -> Some s
			| Some u, Some s -> Some (u ^ "\u{00A0}" ^ s)
			| _, None-> None
		)
		| ITM_NODE _ -> s
		| BLT_NODE -> s
		| DSP_LINE_NODE _ -> s
		| _ -> None

and mark_of_path (path : Cref_utils.t_path) : string=
	match mark_of_path_opt path with
	| None -> ""
	| Some (s : string) -> s

and indent_of_path (path : Cref_utils.t_path) : int =
	match path with
	| [] -> 0
	| hd :: tl -> 
		match hd with
		| SEC_NODE _ -> doc_settings.left_margin
		| PAR_NODE _ -> doc_settings.left_margin
		| ITM_NODE _ -> indent_of_path tl + doc_settings.tab_length
		| BLT_NODE -> indent_of_path tl + doc_settings.tab_length
		| DSP_NODE -> indent_of_path tl + doc_settings.tab_length
		| _ -> indent_of_path tl

and utf_8_segments seg s =
  let flush_segment buf acc =
    let segment = Buffer.contents buf in
    Buffer.clear buf;
    if segment = "" then acc else segment :: acc
  in
  let rec add buf acc segmenter v =
    match Uuseg.add segmenter v with
    | `Uchar u ->
        Buffer.add_utf_8_uchar buf u;
        add buf acc segmenter `Await
    | `Boundary -> add buf (flush_segment buf acc) segmenter `Await
    | `Await | `End -> acc
  in
  let rec loop buf acc s i max segmenter =
    if i > max then flush_segment buf (add buf acc segmenter `End)
    else
      let dec = String.get_utf_8_uchar s i in
      let acc = add buf acc segmenter (`Uchar (Uchar.utf_decode_uchar dec)) in
      loop buf acc s (i + Uchar.utf_decode_length dec) max segmenter
  in
  let buf = Buffer.create 42 in
  let segmenter = Uuseg.create seg in
  List.rev (loop buf [] s 0 (String.length s - 1) segmenter)

and utf8_of_string (s : string) : string list =
  utf_8_segments `Grapheme_cluster s

and utf8_length (s : string) : int =
  List.length (utf_8_segments `Grapheme_cluster s)


