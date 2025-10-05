open Doc_types
open Cref_utils

type t_doc_settings = {
	mutable doc_width : int;
	mutable par_indent : int;
	mutable sec_symbol: string option;
	mutable par_symbol : string option;
	mutable tab_length : int;
	mutable abstract_indent : int;
	mutable qtn_indent : int;
}

let doc_settings : t_doc_settings = {
	doc_width = 75;
	par_indent = 6;
	sec_symbol = Some "§";
	par_symbol = Some "¶";
	tab_length = 6;
	abstract_indent = 0;
	qtn_indent = 4;
}


let rec lines_of_ts_hdr (path:t_path) (a:ts_hdr):string list =
	match a with
	|Cs_hdr (b:ts_txt_units) -> 
		match lines_of_ts_txt_units path b with
		|hd::tl -> decoration_of_head path ((insert_mark path hd)::tl)
		|[] -> []


and lines_of_ts_title (title:ts_title):string list=
	match title with
	|Cs_title (s:string) -> List.concat [decoration_of_head [] (lines_of_string 0 s);[""]]

and lines_of_ts_author (author:ts_author):string list=
	match author with
	|Cs_author (s:string) -> List.concat [lines_of_string 0 s;[""]]


and decoration_of_head (path:t_path) (lines:string list):string list =
	match path with
	|hd::tl -> (
		match hd with
		|PAR_NODE _ -> 
			let line =
				String.concat "" [
				String.make doc_settings.par_indent ' ';
				make_string (doc_settings.doc_width - doc_settings.par_indent) "-";
				] 
			in List.concat [[line];lines;[line]]
		|SEC_NODE _ -> 
			let line = make_string doc_settings.doc_width "=" in
			List.concat [[line];lines;[line]]
		|CH_NODE _ -> 
			let line = make_string doc_settings.doc_width "≡" in
			List.concat [[line];lines;[line]]
		|_ -> lines
	)
	|[] -> lines
(*		let line = make_string doc_settings.doc_width "—" in
		List.concat [[line];lines;[line]]
*)

and make_string (n:int) (s:string):string=
	let rec aux (i:int) (acc:string) = 
		if i > n then acc else aux (i+1) (acc ^ s) 
	in aux 0 ""

and lines_of_ts_txt_units (path : t_path) (a : ts_txt_units) : string list =
	let lines_of_string_function : int -> string -> string list = (
		match path with
		| [] -> lines_of_string
		| hd :: tl -> 
			match hd with
			| DSP_LINE_NODE _ -> lines_of_string_dsp
			| _ -> lines_of_string
	)
	in 
	lines_of_string_function (indent_of_path path) (string_of_txt_units path a)

and string_of_txt_units (path : t_path) (a : ts_txt_units) : string =
	match a with Cs_txt_units (b:te_txt_unit list) ->
	String.concat "" (List.map (string_of_txt_unit path) b)

and string_of_txt_unit (path : t_path) (a : te_txt_unit) : string =
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

and insert_mark (path : t_path) (s : string) : string =
	match mark_of_path_opt path with
	| None -> s
	| Some (t : string) -> insert_string t (pos_of_mark path) s

and pos_of_mark (path : t_path) : int =
	match path with
	| [] -> 0
	| hd :: tl ->
		match hd with
		| PAR_NODE _ -> 0
		| ITM_NODE _ -> indent_of_path path - doc_settings.tab_length
		| BLT_NODE -> indent_of_path path - doc_settings.tab_length
		| DSP_LINE_NODE _ -> indent_of_path path - doc_settings.tab_length
		| _ -> 0

and insert_string (mark : string) (pos : int) (s : string) : string =
	let string_len : int = String.length s in
	let mark_len : int = utf8_length mark in
	let s1 : string = String.sub s 0 pos in
	let s2 : string =
		match 0<=(string_len - pos - mark_len) && mark_len<doc_settings.tab_length with
		|true -> String.sub s (pos + mark_len) (string_len - pos - mark_len)
		|false -> ("\n"^s)
	in
	String.concat mark [ s1; s2 ]

and mark_of_path_opt (path : t_path) : string option =
	match path with
	| [] -> None
	| hd :: tl ->
		let s = string_of_node tl hd in
		match hd with
		| SEC_NODE _ -> (
			match (doc_settings.sec_symbol, s) with
			| None, Some s -> Some s
			| Some u, Some s -> Some (u ^ " " ^ s)
			| _, None-> None
		)
		| PAR_NODE _ -> (
			match (doc_settings.par_symbol, s) with
			| None, Some s -> Some s
			| Some u, Some s -> Some (u ^ " " ^ s)
			| _, None-> None
		)
		| ITM_NODE _ -> s
		| BLT_NODE -> s
		| DSP_LINE_NODE _ -> s
		| _ -> None

and mark_of_path (path:t_path):string=
	match mark_of_path_opt path with
	|None -> ""
	|Some (s:string)->s

and indent_of_path (path : t_path) : int =
	match path with
	| [] -> 0
	| hd :: tl -> 
		match hd with
		| SEC_NODE _ -> doc_settings.par_indent
		| PAR_NODE _ -> doc_settings.par_indent
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


