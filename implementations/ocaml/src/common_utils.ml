open Doc_types

exception Error of string

(**************************** document settings ************************)

type t_doc_settings = {
	doc_width : int;
	left_margin: int;
	title_indent: int;
	author_indent: int;
	abstract_indent: int;
	refs_indent: int;
	tab_length : int;
	abstract_hdr: string option;
	refs_hdr: string;
	ch_prefix: string option;
	sec_prefix: string option;
	par_prefix : string option;
	expand_tag_singular: Doc_types.ts_tag -> string option;
	expand_tag_plural: Doc_types.ts_tag -> (string * string) option;
	preserve_vertical_white_space : bool;
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
	|Cs_tag "RMK" -> Some "REMARK"
	| _  -> None

let expand_tag_plural_default (tag : Doc_types.ts_tag) : (string * string) option =
	match tag with
	|Cs_tag "DEFS" -> Some ("DEFINITION", "DEFINITIONS")
	|Cs_tag "PRFS" -> Some ("PROOF", "PROOFS")
	|Cs_tag "FCTS" -> Some ("FACT", "FACTS")
	|Cs_tag "LMAS" -> Some ("LEMMA", "LEMMAS")
	|Cs_tag "THMS" -> Some ("THEOREM", "THEOREMS")
	|Cs_tag "RMKS" -> Some ("REMARK", "REMARKS")
	| _  -> None


let doc_settings_default () : t_doc_settings = {
	doc_width = 68;
	left_margin = 0;
	title_indent = 0;
	author_indent = 0;
	abstract_indent = 0;
	refs_indent = 0;
	tab_length = 6;
	abstract_hdr = Some "ABSTRACT";
	refs_hdr = "REFERENCES";
	ch_prefix = Some "CHAPTER";
	sec_prefix = Some "§";
	par_prefix = Some "¶";
	expand_tag_singular = expand_tag_singular_default;
	expand_tag_plural = expand_tag_plural_default;
	preserve_vertical_white_space = false;
}

let rec doc_settings_of_tr_doc (doc : Doc_types.tr_doc) : t_doc_settings =
	match doc.fld_doc_preamble with
	|None -> doc_settings_default ()
	|Some preamble -> doc_settings_of_ts_preamble (doc_settings_default ()) preamble 

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


and doc_settings_of_ts_preamble (doc_settings : t_doc_settings) (preamble : Doc_types.ts_preamble) : t_doc_settings =
	let rec aux (str_list : string list) (settings : t_doc_settings) : t_doc_settings =
		match str_list with
		| hd :: tl -> (
			let new_doc_settings : t_doc_settings =
				match key_value_pair_of_string_opt hd with
				|Some ("doc-width", v) -> set_doc_width v settings
				|Some ("left-margin", v) -> set_left_margin v settings
				|Some ("title-indent", v) -> set_title_indent v settings
				|Some ("author-indent", v) -> set_author_indent v settings
				|Some ("abstract-indent", v) -> set_abstract_indent v settings
				|Some ("refs-indent", v) -> set_refs_indent v settings
				|Some ("tab-length", v) -> set_tab_length v settings
				|Some ("ch-prefix", v) -> set_ch_prefix v settings
				|Some ("sec-prefix", v) -> set_sec_prefix v settings
				|Some ("par-prefix", v) -> set_par_prefix v settings
				|Some ("abstract-hdr", v) -> set_abstract_hdr v settings
				|Some ("refs-hdr", v) -> set_refs_hdr v settings
				|Some ("singular-tag", v) -> set_expand_tag_singular settings.expand_tag_singular v settings
				|Some ("plural-tag", v) -> set_expand_tag_plural settings.expand_tag_plural v settings
				|_ -> let _ : unit = Debug_utils.print_to_stderr 
					(String.concat "" ["WARNING: invalid attribute: ";hd;"; ";"ignoring it"]) in settings
			in aux tl new_doc_settings
		)
		| [] -> settings
	in
	match preamble with 
	(Cs_preamble (s : string)) -> 
		let str_list : string list = String.split_on_char ';' s in
		aux str_list doc_settings

and key_value_pair_of_string_opt (s : string): (string*string) option=
	match String.split_on_char '=' s with
	|[key;value] -> Some (key, value)
	| _ -> None

and set_doc_width (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try 
	{
	doc_width = int_of_string v;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid doc_width value: ";v;"\n";"using default value"])
	in doc_settings

and set_left_margin (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try
	{
	doc_width = doc_settings.doc_width;
	left_margin = int_of_string v;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid left_margin value: ";v;"\n";"using default value"])
	in doc_settings

and set_title_indent (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = int_of_string v;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid title_indent value: ";v;"\n";"using default value"])
	in doc_settings

and set_author_indent (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = int_of_string v;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid author_indent value: ";v;"\n";"using default value"])
	in doc_settings

and set_abstract_indent (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = int_of_string v;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid abstract_indent value: ";v;"\n";"using default value"])
	in doc_settings

and set_refs_indent (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = int_of_string v;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid refs_indent value: ";v;"\n";"using default value"])
	in doc_settings


and set_tab_length (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = int_of_string v;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid tab_length value: ";v;"; ";"using default value"])
	in doc_settings

and set_abstract_hdr (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = prefix_value_of_string v;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}

and set_refs_hdr (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = v;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}

and set_ch_prefix (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = prefix_value_of_string v;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}

and set_sec_prefix (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = prefix_value_of_string v;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}

and set_par_prefix (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = prefix_value_of_string v;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}


and set_expand_tag_singular (expand_tag_old : Doc_types.ts_tag -> string option) (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = singular_tag_value_of_string expand_tag_old v;
	expand_tag_plural = doc_settings.expand_tag_plural;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid singular_tag value: ";v;"; ";"using default value"])
	in doc_settings

and set_expand_tag_plural (expand_tag_old : Doc_types.ts_tag -> (string * string) option) (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
	try
	{
	doc_width = doc_settings.doc_width;
	left_margin = doc_settings.left_margin;
	title_indent = doc_settings.title_indent;
	author_indent = doc_settings.author_indent;
	abstract_indent = doc_settings.abstract_indent;
	refs_indent = doc_settings.refs_indent;
	tab_length = doc_settings.tab_length;
	abstract_hdr = doc_settings.abstract_hdr;
	refs_hdr = doc_settings.refs_hdr;
	ch_prefix = doc_settings.ch_prefix;
	sec_prefix = doc_settings.sec_prefix;
	par_prefix = doc_settings.par_prefix;
	expand_tag_singular = doc_settings.expand_tag_singular;
	expand_tag_plural = plural_tag_value_of_string expand_tag_old v;
	preserve_vertical_white_space = doc_settings.preserve_vertical_white_space;
	}
	with _ ->
	let _ : unit =
	Debug_utils.print_to_stderr (String.concat "" ["WARNING: invalid plural_tag value: ";v;"; ";"using default value"])
	in doc_settings

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
	| _ -> raise (Error "invalid singular_tag value")

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

and t_itm_node = ITM_AUTO of int | ITM_CUSTOM of string | ITM_TAG_AUTO of (string * int) | ITM_TAG_CUSTOM of (string * string)

and t_dsp_line_node =
	| DSP_AUTO of int
	| DSP_CUSTOM of string
	| DSP_NONE


type t_cref_element = 
	|Cref_element_ch of tr_ch
	|Cref_element_sec of tr_sec
	|Cref_element_par of tr_par_std
	|Cref_element_blk_itm of tr_blk_itm
	|Cref_element_dsp_line of tr_dsp_line

type t_cref_table = (Doc_types.tr_id * t_path * t_cref_element) list

type t_doc_cref_table = { mutable content : t_cref_table }

let doc_cref_table : t_doc_cref_table = { content = [] }

let path_to_ch_node (path : t_path) : t_path =
	let rec aux (rev_path : t_path) (acc : t_path) : t_path =
		match rev_path with
		|[] -> acc
		|hd::tl ->
			match hd with
			|CH_NODE _ -> hd::acc
			|_ -> aux tl (hd::acc)
	in aux (List.rev path) []

let path_to_sec_node (path : t_path) : t_path =
	let rec aux (rev_path : t_path) (acc : t_path) : t_path =
		match rev_path with
		|[] -> acc
		|hd::tl ->
			match hd with
			|SEC_NODE _ -> hd::acc
			|_ -> aux tl (hd::acc)
	in aux (List.rev path) []


let path_to_par_node (path : t_path) : t_path =
	let rec aux (rev_path : t_path) (acc : t_path) : t_path =
		match rev_path with
		|[] -> acc
		|hd::tl ->
			match hd with
			|PAR_NODE _ -> hd::acc
			|_ -> aux tl (hd::acc)
	in aux (List.rev path) []


let rec string_of_ts_c_ref (doc_settings : t_doc_settings) (c_ref_loc : t_path) (c_ref : Doc_types.ts_c_ref) : string =
	match reference_of_ts_c_ref c_ref_loc c_ref with
	|Some (_, id_loc, _) -> (
		match id_loc, string_of_sub_path_opt doc_settings id_loc (path_from_common_ancestor c_ref_loc id_loc) with
		|id_loc_hd::id_loc_tl, Some (sub : string) -> (
			match List.rev id_loc_tl with 
			|ABSTRACT_NODE::_ -> (
				match List.rev c_ref_loc with
				|ABSTRACT_NODE::_ -> sub
				|_ -> String.concat "\u{00A0}" [sub;"of";label_of_path doc_settings [ABSTRACT_NODE]]
			)
			|REFS_NODE::_ -> (
				match List.rev c_ref_loc with
				|REFS_NODE::_ -> sub
				|_ -> String.concat "\u{00A0}" [sub;"of";label_of_path doc_settings [REFS_NODE]]
			)
			|_ ->
			match id_loc_hd with
			|CH_NODE _ -> (
				match doc_settings.ch_prefix with
				|None -> sub
				|Some prefix -> String.concat "\u{00A0}" [prefix;sub]
			)
			|SEC_NODE _ -> (
				match doc_settings.sec_prefix with
				|None -> sub
				|Some prefix -> String.concat "\u{00A0}" [prefix;sub]
			)
			|PAR_NODE (par_node : t_par_node) -> (
				match par_node with
				|NO_TAG (prefix_opt,_) -> (
					match prefix_opt with
					|None -> sub
					|Some prefix -> String.concat "\u{00A0}" [prefix; sub]
				)
				|SINGULAR_TAG (singular, _) -> String.concat "\u{00A0}" [singular; sub]
				|PLURAL_TAG (_, plural, _) -> String.concat "\u{00A0}" [plural; sub]
			)
			|ITM_NODE (ITM_TAG_AUTO (singular,_)) -> (
				let label = label_of_path doc_settings id_loc in
				match label = sub with
				|true -> String.concat "\u{00A0}" [singular;label]
				|false -> String.concat "\u{00A0}" [singular;label;"of";label_of_path doc_settings id_loc_tl]
			)
			|ITM_NODE (ITM_TAG_CUSTOM (singular,_)) -> (
				let label = label_of_path doc_settings id_loc in
				match label = sub with
				|true -> String.concat "\u{00A0}" [singular;label]
				|false -> String.concat "\u{00A0}" [singular;label;"of";label_of_path doc_settings id_loc_tl]
			)
			|_ -> sub
		)
		|_ , _ -> raise (Error "id_loc in cref_table not expected to be an empty path")
	)
	|None ->
		match c_ref with Cs_c_ref id_c_ref ->
		let _ : unit = Debug_utils.print_to_stderr (String.concat "" [
			"WARNING: id \'";
			string_of_tr_id id_c_ref;
			"\' referenced in ";
			string_of_path doc_settings c_ref_loc;
			" is undefined or out of scope";
		]) in "??"


and reference_of_ts_c_ref (c_ref_path : t_path) (c_ref : Doc_types.ts_c_ref) : (Doc_types.tr_id * t_path * t_cref_element) option =
	match c_ref with
	|Cs_c_ref (c_ref_id) ->
	let rec aux (cref_table : t_cref_table) : (Doc_types.tr_id * t_path * t_cref_element) option =
		match cref_table with
		|[] -> None
		|(table_id, table_path, table_element) :: tl ->
			match ids_match c_ref_id c_ref_path table_id table_path with
			|true -> Some (table_id, table_path, table_element)
			|false -> aux tl
	in
	aux doc_cref_table.content


and ids_match (id_c_ref : Doc_types.tr_id) (c_ref_loc : t_path) (id : Doc_types.tr_id) (id_loc : t_path) : bool =
	if id_c_ref = id
	then
		c_ref_loc_is_within_scope_of_id c_ref_loc id.fld_id_scope id_loc
	else
	false

and c_ref_loc_is_within_scope_of_id (c_ref_loc : t_path) (scope_opt : tu_id_scope option) (id_loc : t_path) : bool =
	match scope_opt with
	|None | Some Cu_id_scope_gbl -> true
	|Some Cu_id_scope_ch -> path_to_ch_node c_ref_loc = path_to_ch_node id_loc
	|Some Cu_id_scope_sec -> path_to_sec_node c_ref_loc = path_to_sec_node id_loc
	|Some Cu_id_scope_par -> path_to_par_node c_ref_loc = path_to_par_node id_loc


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

and string_of_path (doc_settings : t_doc_settings) (path : t_path) : string =
	match string_of_path_opt doc_settings path with
	|None -> "document"
	|Some s -> s

and string_of_path_opt (doc_settings : t_doc_settings) (path : t_path) : string option =
	string_of_sub_path_opt doc_settings path path

and string_of_sub_path_opt (doc_settings : t_doc_settings) (full_path:t_path) (sub_path : t_path) : string option =
	match full_path, sub_path with
	| _, [] -> None
	| full_path_hd::full_path_tl,sub_path_hd :: sub_path_tl -> (
		match sub_path_hd with 
		| CH_NODE _ 
		| SEC_NODE _
		| APP_NODE _
		| PAR_NODE _ -> 
			string_of_node_opt doc_settings full_path_tl sub_path_hd
		| _ -> (
			match (string_of_sub_path_opt doc_settings full_path_tl sub_path_tl, string_of_node_opt doc_settings full_path_tl sub_path_hd)
			with
			| Some s, Some t -> Some (s ^ t)
			| None, Some t -> Some t
			| Some s, None -> Some s
			| None, None -> None
		)
	)
	| [], _ -> raise (Error "full_path shorter than sub_path")

and string_of_node_opt (doc_settings : t_doc_settings) (tail : t_path) (head : t_node) : string option =
	match head with
	| CH_NODE (n : int)
	| SEC_NODE (n : int) -> (
		match string_of_path_opt doc_settings tail with
		|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
		|None -> Some (string_of_int (n + 1))
	)
	| PAR_NODE (par_node : t_par_node) -> (
		match par_node with
		|NO_TAG (_,n) -> (
			match string_of_path_opt doc_settings tail with
			|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
			|None -> Some (string_of_int (n + 1))
		)
		|SINGULAR_TAG (_, n) -> (
			match string_of_path_opt doc_settings tail with
			|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
			|None -> Some (string_of_int (n + 1))
		)
		|PLURAL_TAG (_, _, n) -> (
			match string_of_path_opt doc_settings tail with
			|Some s ->  Some (s ^ "." ^ (string_of_int (n + 1)))
			|None -> Some (string_of_int (n + 1))
		)
	)
	| APP_NODE (n : int) -> (
		match string_of_path_opt doc_settings tail with
		|Some s -> (try Some (s ^ "." ^ upper_case_latin_letters.(n)) with _ -> raise (Error "You have too many appendices!"))
		|None -> Some upper_case_latin_letters.(n)
	)
	| DSP_NODE -> None
	| DSP_LINE_NODE (a : t_dsp_line_node) -> (
		match a with
		| DSP_NONE -> None
		| DSP_AUTO (n : int) ->
			let s : string =
				match lvl_of_path tail mod 3 with
				| 0 -> string_of_int (n + 1)
				| 1 -> lower_case_latin_letters.(n)
				| _ -> lower_case_roman_numerals.(n)
			in Some (String.concat s ["(";")"])
		| DSP_CUSTOM (s : string) -> Some (String.concat s ["(";")"])
	)
	| ITM_NODE (a : t_itm_node) -> (
		match a with
		|ITM_AUTO n -> (
			let s : string =
				match lvl_of_path tail mod 3 with
				| 0 -> string_of_int (n + 1)
				| 1 -> lower_case_latin_letters.(n)
				| _ -> lower_case_roman_numerals.(n)
			in Some (String.concat s ["(";")"])
		)
		|ITM_CUSTOM s -> Some (String.concat s ["(";")"])
		|ITM_TAG_AUTO (_,n) -> (
			let s : string =
				match lvl_of_path tail mod 3 with
				| 0 -> string_of_int (n + 1)
				| 1 -> lower_case_latin_letters.(n)
				| _ -> lower_case_roman_numerals.(n)
			in
			match string_of_path_opt doc_settings tail with
			|None -> Some (String.concat "" ["("; s;")"])
			|Some (t : string) -> Some (String.concat "" ["("; s;")"])
		)
		|ITM_TAG_CUSTOM (_,s) -> (
			match string_of_path_opt doc_settings tail with
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

and node_of_tr_par_std (doc_settings : t_doc_settings) (auto_nr : int) (par : Doc_types.tr_par_std) : t_node =
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
			| Cu_lbl_auto Cs_lbl_auto -> ITM_TAG_AUTO (singular,auto_nr)
			| Cu_lbl_custom (Cs_lbl_custom (s : string)) -> ITM_TAG_CUSTOM (singular,s)
		)
		|_ -> (
			match a.fld_blk_itm_lbl with
			| Cu_lbl_auto Cs_lbl_auto -> ITM_AUTO auto_nr
			| Cu_lbl_custom (Cs_lbl_custom (s : string)) -> ITM_CUSTOM s
		)
	in ITM_NODE itm_node

and node_of_dsp_line (auto_nr : int) (a : Doc_types.tr_dsp_line) : t_node =
	let dsp_line_node : t_dsp_line_node =
		match a.fld_dsp_line_lbl with
		| Some (Cu_lbl_auto Cs_lbl_auto)-> DSP_AUTO auto_nr
		| Some (Cu_lbl_custom (Cs_lbl_custom (s : string))) -> DSP_CUSTOM s
		| None -> DSP_NONE
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


and label_of_path_opt (doc_settings : t_doc_settings) (path : t_path) : string option =
	match path with
	| [] -> None
	| hd :: tl ->
		let s_opt : string option = string_of_node_opt doc_settings tl hd in
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
		| ABSTRACT_NODE -> doc_settings.abstract_hdr
		| REFS_NODE -> Some doc_settings.refs_hdr
		| _ -> s_opt

and label_of_path (doc_settings : t_doc_settings) (path : t_path) : string=
	match label_of_path_opt doc_settings path with
	| None -> ""
	| Some (s : string) -> s

and string_of_tr_id (id : Doc_types.tr_id) : string =
	match id.fld_id_tag, id.fld_id_name, id.fld_id_scope with
	|Cs_tag tag, Cs_name name, Some scope -> String.concat ":" [tag;name;string_of_tu_id_scope scope]
	|Cs_tag tag, Cs_name name, _ -> String.concat ":" [tag;name]

and string_of_tu_id_scope (scope : tu_id_scope) : string =
	match scope with
	|Cu_id_scope_gbl -> "GBL"
	|Cu_id_scope_ch -> "CH"
	|Cu_id_scope_sec -> "SEC"
	|Cu_id_scope_par -> "PAR"

let check_cref_table (doc_settings : t_doc_settings) (table : t_cref_table) : t_cref_table =
	let rec aux1 (lst : t_cref_table) (acc : (Doc_types.tr_id * t_path) list): (Doc_types.tr_id * t_path) list =
		match lst with
		|[] -> acc
		|hd::tl ->
			match hd with
			|(id, path, _) ->
				match id.fld_id_scope with
				|None | Some Cu_id_scope_gbl -> aux1 tl ((id,[])::acc)
				|Some Cu_id_scope_ch -> aux1 tl ((id, path_to_ch_node path)::acc)
				|Some Cu_id_scope_sec -> aux1 tl ((id, path_to_sec_node path)::acc)
				|Some Cu_id_scope_par -> aux1 tl ((id, path_to_par_node path)::acc)
	in
	let rec aux2 (lst : (Doc_types.tr_id * t_path) list) : unit =
		match lst with
		|[] -> ()
		|(id,path)::tl ->
			match List.mem (id,path) tl with
			|true ->
				let _ : unit = Debug_utils.print_to_stderr (String.concat "" [
					"WARNING: id \'";
					string_of_tr_id id;"\'";
					" is defined more than once in ";
					string_of_path doc_settings path;
					])
				in aux2 tl
			|false -> aux2 tl
	in
	let lst : (Doc_types.tr_id * t_path) list = aux1 table [] in
	let _ : unit = aux2 lst in
	table

(** Repeat *)

let par_restated_of_tr_par (par : Doc_types.tr_par_std) : Doc_types.tr_par_std =
	let space : tu_txt_unit =  Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " ") in
	let lpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg "(") in
	let rpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg ")") in
	let restated : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg "[restated]") in
	let par_hdr_opt : Doc_types.ts_hdr option =
		match par.fld_par_tag_or_id, par.fld_par_hdr with
		|None, hdr_opt -> hdr_opt 
		|Some tag_or_id, hdr_opt ->
			match tag_or_id with
			|Cu_tag_or_id_tag _ -> hdr_opt
			|Cu_tag_or_id_id id ->
				let c_ref : Doc_types.ts_c_ref = Cs_c_ref id in
				let txt_unit_c_ref = Cs_txt_unit_c_ref c_ref in
				let txt_unit = Cu_txt_unit_c_ref txt_unit_c_ref in
				match hdr_opt with
				|None -> Some (Cs_hdr (Cs_txt_units [txt_unit; space; restated]))
				|Some (Cs_hdr (Cs_txt_units txt_unit_list)) -> 
					Some (Cs_hdr (Cs_txt_units (List.concat [[txt_unit; space; lpar]; txt_unit_list; [rpar; space; restated]])))
	in
	{ 	
		fld_par_hdr = par_hdr_opt;
		fld_par_tag_or_id = None;
		fld_par_main = par.fld_par_main;
	}



let par_restated_of_tr_id (doc_settings : t_doc_settings) (path : t_path) (id : tr_id) : (Doc_types.tr_par_std * t_path) option =
	match reference_of_ts_c_ref path (Cs_c_ref id) with
	|None -> let _ : unit = Debug_utils.print_to_stderr (String.concat "" [
			"WARNING: id \'";string_of_tr_id id;
			"\' referenced in ";
			string_of_path doc_settings path;
			" is undefined or out of scope";
		]) in None
	|Some (table_id, table_path, Cref_element_par par) ->
		Some (par_restated_of_tr_par par, table_path)
	|_ -> let _ : unit = Debug_utils.print_to_stderr (String.concat "" [
				"WARNING: id \'";
				string_of_tr_id id;
				"\' does not belong to a paragraph";
		]) in None

let node_of_tu_par (doc_settings : t_doc_settings) (auto_nr : int) (p : tu_par) : t_node =
	match p with
	|Cu_par_rpt (Cs_par_rpt (id : tr_id)) -> PAR_NODE (NO_TAG (doc_settings.par_prefix,auto_nr))
	|Cu_par_std (par : tr_par_std) -> node_of_tr_par_std doc_settings auto_nr par

