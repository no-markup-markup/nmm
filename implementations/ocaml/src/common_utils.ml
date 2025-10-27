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
	mutable abstract_hdr: string;
	mutable refs_hdr: string;
	mutable ch_prefix: string option;
	mutable sec_prefix: string option;
	mutable par_prefix : string option;
	mutable expand_tag_singular: Doc_types.ts_tag -> string option;
	mutable expand_tag_plural: Doc_types.ts_tag -> (string * string) option;
}

type t_doc_class = DOC_CHS | DOC_SECS | DOC_PARS | DOC_BLKS

type t_ch_class = CH_SECS | CH_PARS | CH_BLKS


let expand_tag_singular_default (tag : Doc_types.ts_tag) : string option =
	match tag with
	|Cs_tag "DEF" -> Some "DEFINITION"
	|Cs_tag "PRF" -> Some "PROOF"
	|Cs_tag "FCT" -> Some "FACT"
	|Cs_tag "LMA" -> Some "LEMMA"
	|Cs_tag "THM" -> Some "THEOREM"
	| _  -> None

let expand_tag_plural_default (tag : Doc_types.ts_tag) : (string * string) option =
	match tag with
	|Cs_tag "DEFS" -> Some ("DEFINITION", "DEFINITIONS")
	|Cs_tag "PRFS" -> Some ("PROOF", "PROOFS")
	|Cs_tag "FCTS" -> Some ("FACT", "FACTS")
	|Cs_tag "LMAS" -> Some ("LEMMA", "LEMMAS")
	|Cs_tag "THMS" -> Some ("THEOREM", "THEOREMS")
	| _  -> None


let doc_settings : t_doc_settings = {
	doc_width = 80;
	left_margin = 12;
	title_indent = 12;
	author_indent = 12;
	abstract_indent = 12;
	refs_indent = 12;
	tab_length = 6;
	abstract_hdr = "ABSTRACT";
	refs_hdr = "REFERENCES";
	ch_prefix = Some "CHAPTER";
	sec_prefix = Some "§";
	par_prefix = Some "¶";
	expand_tag_singular = expand_tag_singular_default;
	expand_tag_plural = expand_tag_plural_default;
}

let rec doc_settings_of_tr_doc (doc : Doc_types.tr_doc) : unit =
	let _ : unit = (
		match doc_contains_sec_or_par doc with
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

and class_of_tr_doc (doc : Doc_types.tr_doc) : t_doc_class =
	match doc.fld_doc_main with
	|Cu_doc_main_chs _ -> DOC_CHS
	|Cu_doc_main_secs _ -> DOC_SECS
	|Cu_doc_main_pars _ -> DOC_PARS
	|Cu_doc_main_blks _ -> DOC_BLKS

and string_of_t_doc_class (doc_class : t_doc_class) : string =
	match doc_class with
	|DOC_CHS -> "doc chs"
	|DOC_SECS -> "doc secs"
	|DOC_PARS -> "doc pars"
	|DOC_BLKS -> "doc blks"

and class_of_tr_ch (ch : Doc_types.tr_ch) : t_ch_class =
	match ch.fld_ch_main with
	| Cu_secs_pars_or_blks_secs _ -> CH_SECS
	| Cu_secs_pars_or_blks_pars _ -> CH_PARS
	| Cu_secs_pars_or_blks_blks _ -> CH_BLKS

and string_of_t_ch_class (ch_class : t_ch_class) : string =
	match ch_class with
	|CH_SECS -> "ch secs"
	|CH_PARS -> "ch pars"
	|CH_BLKS -> "ch blks"


and doc_contains_sec_or_par (doc : Doc_types.tr_doc) : bool =
	match doc.fld_doc_main with
	| Cu_doc_main_blks _ -> false
	| Cu_doc_main_chs (chs : Doc_types.ts_chs) -> (
		let rec aux (ch_list : Doc_types.tr_ch list) : bool =
			match ch_list with
			|[] -> false
			|hd::tl -> 
				match ch_contains_sec_or_par hd with
				| true -> true
				| false -> aux tl
		in
		match chs with
		|Cs_chs ch_list -> aux ch_list
	)
	| Cu_doc_main_secs _ -> true
	| Cu_doc_main_pars _ -> true

and ch_contains_sec_or_par (ch : Doc_types.tr_ch) : bool =
	match ch.fld_ch_main with
	| Cu_secs_pars_or_blks_blks _ -> false
	| Cu_secs_pars_or_blks_secs _ -> true
	| Cu_secs_pars_or_blks_pars _ -> true


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
				|Some ("abstract_hdr", v) -> set_abstract_hdr v
				|Some ("refs_hdr", v) -> set_refs_hdr v
				|Some ("singular_tag", v) -> set_expand_tag_singular doc_settings.expand_tag_singular v
				|Some ("plural_tag", v) -> set_expand_tag_plural doc_settings.expand_tag_plural v
				|_ -> Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid attribute: ";hd;"; ";"ignoring it"])
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
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid tab_length value: ";v;"; ";"using default value"])

and set_ch_prefix (v : string) : unit =
	try doc_settings.ch_prefix <- (prefix_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid ch_prefix value: ";v;"; ";"using default value"])

and set_sec_prefix (v : string) : unit =
	try doc_settings.sec_prefix <- (prefix_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid sec_prefix value: ";v;"; ";"using default value"])

and set_par_prefix (v : string) : unit =
	try doc_settings.par_prefix <- (prefix_value_of_string v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid par_prefix value: ";v;"; ";"using default value"])

and set_abstract_hdr (v : string) : unit =
	doc_settings.abstract_hdr <- v 

and set_refs_hdr (v : string) : unit =
	doc_settings.refs_hdr <- v 

and set_expand_tag_singular (expand_tag_old : Doc_types.ts_tag -> string option) (v : string) : unit =
	try doc_settings.expand_tag_singular <- (singular_tag_value_of_string expand_tag_old v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid singular_tag value: ";v;"; ";"using default value"])

and set_expand_tag_plural (expand_tag_old : Doc_types.ts_tag -> (string * string) option) (v : string) : unit =
	try doc_settings.expand_tag_plural <- (plural_tag_value_of_string expand_tag_old v) with _ ->
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid plural_tag value: ";v;"; ";"using default value"])

and prefix_value_of_string (v : string) : string option =
	match v with
	|"None" | "none" | "" | "\"\"" -> None
	| _ -> Some v

and singular_tag_value_of_string (expand_tag_old : Doc_types.ts_tag -> string option) (v : string) : (Doc_types.ts_tag -> string option) =
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

and plural_tag_value_of_string (expand_tag_old : Doc_types.ts_tag -> (string * string) option) (v : string) : (Doc_types.ts_tag -> (string * string) option) =
	match String.split_on_char '>' v with
	|[tag_string; singular; plural] -> (
		let expand_tag_new ( tag : Doc_types.ts_tag) : (string *  string) option = 
			match tag with
			|Cs_tag (s : string) ->
				match s = tag_string with
				|true -> Some (singular, plural)
				|false -> expand_tag_old tag
		in expand_tag_new
	)
	| _ -> raise (Error "invalid plural_tag value")

(**************************** labels and cross-references *********************************)

type t_path = t_node list

and t_node =
	| ABSTRACT_NODE
	| CH_NODE of int
	| SEC_NODE of int
	| APP_NODE of int
	| PAR_NODE of t_par_node
	| ITM_NODE of t_itm_node
	| DSP_NODE
	| BLT_NODE
	| DSP_LINE_NODE of t_dsp_line_node
	| REFS_NODE

and t_par_node = NO_TAG of (string option * int) | SINGULAR_TAG of (string * int) | PLURAL_TAG of (string * string * int)

and t_itm_node = ITM_INT of int | ITM_STRING of string | ITM_TAG_INT of (string * int) | ITM_TAG_STRING of (string * string)

and t_dsp_line_node =
	| DSP_INT of int
	| DSP_STRING of string
	| NONE

type t_cref_table = (Doc_types.tr_id * t_path) list

type t_doc_cref_table = { mutable content : t_cref_table }

let doc_cref_table : t_doc_cref_table = { content = [] }

let rec string_of_ts_c_ref (c_ref_loc : t_path) (c_ref : Doc_types.ts_c_ref) : string =
	match c_ref with Cs_c_ref (id_c_ref : Doc_types.tr_id) ->
	let rec aux (cref_table : t_cref_table) : string option =
		match cref_table with
		| [] -> None
		| ((id : Doc_types.tr_id), (id_loc : t_path)) :: c_ref_table_tl -> 
			match id_c_ref = id with
			| true -> (
				match id_loc, string_of_sub_path_opt id_loc (path_from_common_ancestor c_ref_loc id_loc) with
				|id_loc_hd::id_loc_tl, Some (sub : string) -> (
					match List.rev id_loc_tl with 
					|ABSTRACT_NODE::_ -> (
						match List.rev c_ref_loc with
						|ABSTRACT_NODE::_ -> Some sub
						|_ -> Some (String.concat "\u{00A0}" [sub;"of";label_of_path [ABSTRACT_NODE]])
					)
					|REFS_NODE::_ -> (
						match List.rev c_ref_loc with
						|REFS_NODE::_ -> Some sub
						|_ -> Some (String.concat "\u{00A0}" [sub;"of";label_of_path [REFS_NODE]])
					)
					|_ ->
					match id_loc_hd with
					|CH_NODE _ -> (
						match doc_settings.ch_prefix with
						|None -> Some sub
						|Some prefix -> Some (String.concat "\u{00A0}" [prefix;sub])
					)
					|SEC_NODE _ -> (
						match doc_settings.sec_prefix with
						|None -> Some sub
						|Some prefix -> Some (String.concat "\u{00A0}" [prefix;sub])
					)
					|PAR_NODE (par_node : t_par_node) -> (
						match par_node with
						|NO_TAG (prefix_opt,_) -> (
							match prefix_opt with
							|None -> Some sub
							|Some prefix -> Some (String.concat "\u{00A0}" [prefix; sub])
						)
						|SINGULAR_TAG (singular, _) -> Some (String.concat "\u{00A0}" [singular; sub])
						|PLURAL_TAG (_, plural, _) -> Some (String.concat "\u{00A0}" [plural; sub])
					)
					|ITM_NODE (ITM_TAG_INT (singular,_)) -> (
						let label = label_of_path id_loc in
						match label = sub with
						|true -> Some (String.concat "\u{00A0}" [singular;label])
						|false -> Some (String.concat "\u{00A0}" [singular;label;"of";label_of_path id_loc_tl])
					)
					|ITM_NODE (ITM_TAG_STRING (singular,_)) -> (
						let label = label_of_path id_loc in
						match label = sub with
						|true -> Some (String.concat "\u{00A0}" [singular;label])
						|false -> Some (String.concat "\u{00A0}" [singular;label;"of";label_of_path id_loc_tl])
					)
					| _ -> Some sub
				)
				| _ , _ -> raise (Error "id_loc in cref_table not expected to be an empty path")
			)
			| false -> aux c_ref_table_tl
	in
	match aux doc_cref_table.content with
	| None ->
		let _ : unit = Debug_utils.print_to_stderr ("WARNING: undefined reference in " ^ (string_of_path c_ref_loc)) in 
		"??"
	| Some (s : string) -> s


and path_from_common_ancestor (c_ref_loc : t_path) (id_loc : t_path) : t_path =
	let rev_c_ref_loc : t_path = List.rev c_ref_loc in
	let rev_id_loc : t_path = List.rev id_loc in
	let rec aux (rev_c_ref_loc : t_path) (rev_id_loc : t_path) : t_path = (
		match (rev_c_ref_loc, rev_id_loc) with
		| rev_c_ref_loc_hd :: rev_c_ref_loc_tl, rev_id_loc_hd :: rev_id_loc_tl -> (
			match rev_c_ref_loc_hd = rev_id_loc_hd with
			| true -> aux rev_c_ref_loc_tl rev_id_loc_tl
			| false -> List.rev rev_id_loc
		)
		| [], [] -> (
(*			let _ : unit = Debug_utils.print_to_stderr ("WARNING: self-reference in " ^ (string_of_path c_ref_loc)) in *)
			try [List.hd id_loc] with _ -> raise (Error "id_loc not expected to be an empty path")
		)
		| _ :: _, [] -> (
(*			let _ : unit = Debug_utils.print_to_stderr ("WARNING: reference to parent node in " ^ (string_of_path c_ref_loc)) in *)
			try [List.hd id_loc] with _ -> raise (Error "id_loc not expected to be an empty path")
		)
		| [], _ :: _ ->
(*			let _:unit=Debug_utils.print_to_stderr ("WARNING: reference to child node in " ^ (string_of_path c_ref_loc)) in *)
			List.rev rev_id_loc
	)
	in 
	aux rev_c_ref_loc rev_id_loc

and string_of_path (path : t_path) : string =
	match string_of_path_opt path with
	|None -> "document"
	|Some s -> s

and string_of_path_opt (path : t_path) : string option =
	string_of_sub_path_opt path path

and string_of_sub_path_opt (full_path:t_path) (sub_path : t_path) : string option =
	match full_path, sub_path with
	| _, [] -> None
	| full_path_hd::full_path_tl,sub_path_hd :: sub_path_tl -> (
		match sub_path_hd with 
		| CH_NODE _ 
		| SEC_NODE _
		| APP_NODE _
		| PAR_NODE _ -> 
			string_of_node_opt full_path_tl sub_path_hd
		| _ -> (
			match (string_of_sub_path_opt full_path_tl sub_path_tl, string_of_node_opt full_path_tl sub_path_hd) with
			| Some s, Some t -> Some (s ^ t)
			| None, Some t -> Some t
			| Some s, None -> Some s
			| None, None -> None
		)
	)
	| [], _ -> raise (Error "full_path shorter than sub_path")

and string_of_node_opt (tail : t_path) (head : t_node) : string option =
	match head with
	| CH_NODE (n : int)
	| SEC_NODE (n : int) -> (
		match string_of_path_opt tail with
		|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
		|None -> Some (string_of_int (n + 1))
	)
	| PAR_NODE (par_node : t_par_node) -> (
		match par_node with
		|NO_TAG (_,n) -> (
			match string_of_path_opt tail with
			|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
			|None -> Some (string_of_int (n + 1))
		)
		|SINGULAR_TAG (_, n) -> (
			match string_of_path_opt tail with
			|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
			|None -> Some (string_of_int (n + 1))
		)
		|PLURAL_TAG (_, _, n) -> (
			match string_of_path_opt tail with
			|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
			|None -> Some (string_of_int (n + 1))
		)
	)
	| APP_NODE (n : int) -> (
		match string_of_path_opt tail with
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
			in Some (String.concat s ["(";")"])
		| DSP_STRING (s : string) -> Some (String.concat s ["(";")"])
	)
	| ITM_NODE (a : t_itm_node) -> (
		match a with
		|ITM_INT n -> (
			let s : string =
				match lvl_of_path tail mod 3 with
				| 0 -> string_of_int (n + 1)
				| 1 -> lower_case_latin_letters.(n)
				| _ -> lower_case_roman_numerals.(n)
			in Some (String.concat s ["(";")"])
		)
		|ITM_STRING s -> Some (String.concat s ["(";")"])
		|ITM_TAG_INT (_,n) -> (
			let s : string =
				match lvl_of_path tail mod 3 with
				| 0 -> string_of_int (n + 1)
				| 1 -> lower_case_latin_letters.(n)
				| _ -> lower_case_roman_numerals.(n)
			in
			match string_of_path_opt tail with
			|None -> Some (String.concat "" ["("; s;")"])
			|Some (t : string) -> Some (String.concat "" ["("; s;")"])
		)
		|ITM_TAG_STRING (_,s) -> (
			match string_of_path_opt tail with
			|None -> Some (String.concat "" ["("; s;")"])
			|Some (t : string) -> Some (String.concat "" ["("; s;")"])
		)
	)
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


and node_of_tr_par (auto_nr) (par : Doc_types.tr_par) : t_node =
	match par.fld_par_tag_or_id with
	|None -> PAR_NODE (NO_TAG (doc_settings.par_prefix,auto_nr))
	|Some (tag_or_id : tu_tag_or_id) ->
		match tag_or_id with
		|Cu_tag_or_id_tag (tag : ts_tag) -> (
			match doc_settings.expand_tag_singular tag with
			|Some (expansion : string) -> PAR_NODE (SINGULAR_TAG (expansion,auto_nr))
			|None ->
				match doc_settings.expand_tag_plural tag with
				|Some (singular,plural) -> PAR_NODE (PLURAL_TAG (singular,plural,auto_nr))
				|None -> PAR_NODE (NO_TAG (doc_settings.par_prefix, auto_nr))
		)
		|Cu_tag_or_id_id (id : tr_id) -> (
			match doc_settings.expand_tag_singular id.fld_id_tag with
			|Some (expansion : string) -> PAR_NODE (SINGULAR_TAG (expansion,auto_nr))
			|None ->
				match doc_settings.expand_tag_plural id.fld_id_tag with
				|Some (singular,plural) -> PAR_NODE (PLURAL_TAG (singular,plural,auto_nr))
				|None -> PAR_NODE (NO_TAG (doc_settings.par_prefix, auto_nr))
		)

and node_of_blk_itm (path_hd_opt : t_node option) (auto_nr : int) (a : Doc_types.tr_blk_itm) : t_node =
	let itm_node : t_itm_node =
		match path_hd_opt with
		| Some (PAR_NODE (PLURAL_TAG (singular, _, _))) -> (
			match a.fld_blk_itm_lbl with
			| Cu_lbl_auto Cs_lbl_auto -> ITM_TAG_INT (singular,auto_nr)
			| Cu_lbl_custom (Cs_lbl_custom (s : string)) -> ITM_TAG_STRING (singular,s)
		)
		|_ -> (
			match a.fld_blk_itm_lbl with
			| Cu_lbl_auto Cs_lbl_auto -> ITM_INT auto_nr
			| Cu_lbl_custom (Cs_lbl_custom (s : string)) -> ITM_STRING s
		)
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
		let s_opt : string option = string_of_node_opt tl hd in
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
		| ABSTRACT_NODE -> Some doc_settings.abstract_hdr
		| REFS_NODE -> Some doc_settings.refs_hdr
		| _ -> s_opt

and label_of_path (path : t_path) : string=
	match label_of_path_opt path with
	| None -> ""
	| Some (s : string) -> s


