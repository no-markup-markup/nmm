open Doc_types
open Common_utils


let remove_empty_endlines (lines : string list) : string list =
	let rec aux (lst : string list) : string list =
		match lst with
		|""::tl -> aux tl
		|_ -> lst
	in
	List.rev (aux (List.rev lines))

let rec lines_of_ts_title_opt (title_opt : Doc_types.ts_title option) : string list =
	match title_opt with
	|None -> []
	|Some title -> lines_of_ts_title title

and lines_of_ts_authors_opt (authors_opt : Doc_types.ts_authors option) : string list =
	match authors_opt with
	|None -> []
	|Some authors -> lines_of_ts_authors authors


and lines_of_abstract_hdr (doc_class : string) : string list =
	match Common_utils.doc_settings.abstract_prefix with
	| None -> []
	| Some (prefix : string) -> lines_of_string (Common_utils.doc_settings.abstract_indent) prefix

and lines_of_refs_hdr (doc_class : string) : string list =
	let underline_symbol : string =
		match doc_class with
		|"doc chs" -> "═"
		| _ -> "─"
	in
	match Common_utils.doc_settings.refs_prefix with
	|None -> []
	|Some (prefix : string) -> 
		let indent : string = String.make (Common_utils.doc_settings.refs_indent) ' ' in
		let hdr_string : string = prefix in
		let underline = make_string (Int.min (utf8_length hdr_string) (doc_settings.doc_width - doc_settings.refs_indent)) underline_symbol in
		let hdr_lines : string list = lines_of_string doc_settings.refs_indent hdr_string in
		List.concat [hdr_lines;[indent ^ underline;""]]


and lines_of_ts_blk_txt (path : Common_utils.t_path) (blk_txt : Doc_types.ts_blk_txt) : string list =
	match blk_txt with
	|Cs_blk_txt (txt_units : Doc_types.ts_txt_units) -> List.concat [lines_of_ts_txt_units path txt_units;[""]]


and lines_of_ts_hdr_opt (path : Common_utils.t_path) (hdr_opt : Doc_types.ts_hdr option) : string list =
	match hdr_opt with
	| Some (hdr : Doc_types.ts_hdr) -> lines_of_ts_hdr path hdr
	| None ->
		match path with
		| hd::tl -> (
			match hd with
			|SEC_NODE _ | APP_NODE _ -> [label_of_path path;""]
			|CH_NODE _ ->
				let indent : string = String.make (doc_settings.left_margin) ' ' in
				let label : string = label_of_path path in
				let underline :string = make_string (utf8_length label) "═" in
				[indent ^ label; indent ^ underline; ""]
			| _ -> []
		)
		| [] -> []

and lines_of_ts_hdr (path : Common_utils.t_path) (hdr : Doc_types.ts_hdr) : string list =
	match hdr with 
	Cs_hdr (txt_units : ts_txt_units) ->
		match path with
		|path_hd::path_tl -> (
			let indent : string = String.make (doc_settings.left_margin) ' ' in
			let hdr_string : string = string_of_ts_txt_units path txt_units in
			let hdr_lines : string list = lines_of_string doc_settings.left_margin hdr_string in
			match path_hd with
			|SEC_NODE _ | APP_NODE _ -> (
				let underline = make_string (Int.min (utf8_length hdr_string) (doc_settings.doc_width - doc_settings.left_margin)) "─" in
				match hdr_lines with
				| hd::tl -> List.concat [[insert_label path hd];tl;[indent ^ underline;""]]
				| [] -> raise (Error "section header cannot be empty")
			)
			|CH_NODE _ ->
				let label : string = label_of_path path in
				let underline = make_string (Int.min (utf8_length hdr_string) (doc_settings.doc_width - doc_settings.left_margin)) "═" in
				List.concat [[indent ^ label]; hdr_lines; [indent ^ underline; ""]]
			| _ -> []
		)
		|[] -> raise (Error "path to chapter or section cannot be empty")


and lines_of_ts_title (title : Doc_types.ts_title) : string list =
	match title with
	|Cs_title (s : string) -> 
		let indent : string = String.make doc_settings.title_indent ' ' in
		let overline : string = make_string (doc_settings.doc_width - doc_settings.title_indent) "═" in
		let underline : string = overline in
		List.concat [[indent ^ overline]; lines_of_string doc_settings.title_indent s;[indent ^ underline;""]]

and lines_of_ts_authors (authors : Doc_types.ts_authors) : string list =
	match authors with
	|Cs_authors (author_list : ts_author list) -> List.concat [List.concat (List.map lines_of_ts_author author_list);[""]]


and lines_of_ts_author (author : Doc_types.ts_author) : string list =
	match author with
	|Cs_author (s : string) -> List.concat [lines_of_string doc_settings.author_indent s; [""]]

and make_string (n:int) (s:string) : string=
	let rec aux (i:int) (acc:string) = 
		if i > n - 1 then acc else aux (i+1) (acc ^ s) 
	in aux 0 ""

and lines_of_ts_txt_units (path : Common_utils.t_path) (a : Doc_types.ts_txt_units) : string list =
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

and string_of_ts_txt_units (path : Common_utils.t_path) (a : Doc_types.ts_txt_units) : string =
	match a with Cs_txt_units (b: Doc_types.tu_txt_unit list) ->
	String.concat "" (List.map (string_of_ts_txt_unit path) b)

and string_of_ts_txt_unit (path : Common_utils.t_path) (a : Doc_types.tu_txt_unit) : string =
	match a with
	| Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg (b : string)) -> b
	| Cu_txt_unit_emph (Cs_txt_unit_emph (b : string)) -> emph b
	| Cu_txt_unit_c_ref (Cs_txt_unit_c_ref (b : ts_c_ref)) -> string_of_ts_c_ref path b

and emph (a : string) : string = underline a

and underline (s : string) : string =
	let lst = utf8_of_string s in
	let map (el : string) : string = el ^ "\u{0332}" in
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

and insert_label (path : Common_utils.t_path) (s : string) : string =
	match label_of_path_opt path with
	| None -> s
	| Some (t : string) -> insert_string t (pos_of_label path) s

and pos_of_label (path : Common_utils.t_path) : int =
	match path with
	| [] -> 0
	| hd :: tl ->
		match hd with
		| ITM_NODE _ -> indent_of_path path - doc_settings.tab_length
		| BLT_NODE -> indent_of_path path - doc_settings.tab_length
		| DSP_LINE_NODE _ -> indent_of_path path - doc_settings.tab_length
		| _ -> 0

and insert_string (label : string) (pos : int) (s : string) : string =
	let string_len : int = String.length s in
	let label_len : int = utf8_length label in
	let target : string = String.sub s pos label_len in
	let ideal_target : string = String.make label_len ' ' in
	let s1 : string = String.sub s 0 pos in
	let s2 : string =
		match (*0<=(string_len - pos - mark_len) && mark_len<doc_settings.tab_length &&*) target = ideal_target with
		|true -> String.sub s (pos + label_len) (string_len - pos - label_len)
		|false -> ("\n"^s)
	in
	String.concat label [ s1; s2 ]


and indent_of_path (path : Common_utils.t_path) : int =
	match path with
	| [] -> 0
	| hd :: tl -> 
		match hd with
		| REFS_NODE -> doc_settings.refs_indent
		| ABSTRACT_NODE -> doc_settings.abstract_indent
		| CH_NODE _ -> doc_settings.left_margin
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


