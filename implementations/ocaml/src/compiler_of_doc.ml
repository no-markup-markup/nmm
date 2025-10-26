open Doc_types
open Common_utils
open Txt_utils
open Exml_utils

exception Error of string

type t_acc = CREF_TABLE of Common_utils.t_cref_table | LINES of (string list) | EXML of (Xml.xml list)

let rec cref_table_of_tr_doc (doc : Doc_types.tr_doc) : Common_utils.t_cref_table =
	match acc_of_tr_doc (CREF_TABLE []) doc with
	| CREF_TABLE table -> List.rev table
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")

and txt_of_tr_doc (doc : Doc_types.tr_doc) : string =
	let _ : unit = Common_utils.doc_settings_of_tr_doc doc in
	String.concat "\n" (lines_of_tr_doc doc)

and exml_of_tr_doc (doc : Doc_types.tr_doc) : Xml.xml =
	let _ : unit = Common_utils.doc_settings_of_tr_doc doc in
	match xml_list_of_tr_doc doc with
	| hd::[] -> hd
	| _ -> raise (Error "function expected to return an exml-list with exactly one element")

and lines_of_tr_doc (doc : Doc_types.tr_doc) : string list =
	let _ : unit = Common_utils.doc_cref_table.content <- cref_table_of_tr_doc doc in
	match acc_of_tr_doc (LINES []) doc with
	| LINES lines -> Txt_utils.remove_empty_endlines lines
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")

and xml_list_of_tr_doc (doc : Doc_types.tr_doc) : Xml.xml list =
	let _ : unit = Common_utils.doc_cref_table.content <- cref_table_of_tr_doc doc in
	match acc_of_tr_doc (EXML []) doc with
	| EXML xml_list -> xml_list
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")

and acc_of_tr_doc (acc : t_acc) (doc : Doc_types.tr_doc) : t_acc =
	let doc_class : string = Common_utils.class_of_tr_doc doc in
	match acc with
	| CREF_TABLE _ -> (
		let table_abstract : Common_utils.t_cref_table = 
			match doc.fld_doc_abstract with
			|None -> []
			|Some (abstract : ts_abstract) -> 
				match acc_of_ts_abstract doc_class [ABSTRACT_NODE] (CREF_TABLE []) abstract with
				|CREF_TABLE table -> table
				| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		in
		let table_refs : Common_utils.t_cref_table = 
			match doc.fld_doc_refs with
			|None -> []
			|Some (refs : ts_refs) -> 
				match acc_of_ts_refs doc_class [REFS_NODE] (CREF_TABLE []) refs with
				|CREF_TABLE table -> table
				| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		in
		let table_main : Common_utils.t_cref_table = 
			match acc_of_tu_doc_main (CREF_TABLE []) doc.fld_doc_main with
			|CREF_TABLE table -> table
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		in
		CREF_TABLE (List.concat [table_abstract; table_main; table_refs])
	)
	| LINES _ -> (
		let lines_title:string list = Txt_utils.lines_of_ts_title_opt doc.fld_doc_title in
		let lines_authors:string list = Txt_utils.lines_of_ts_authors_opt doc.fld_doc_authors in
		let lines_abstract:string list =
			match doc.fld_doc_abstract with
			|None -> []
			|Some (abstract : ts_abstract) -> 
				match acc_of_ts_abstract doc_class [ABSTRACT_NODE] (LINES []) abstract with
				|LINES lines -> lines
				| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		in
		let lines_refs:string list =
			match doc.fld_doc_refs with
			|None -> []
			|Some (refs : ts_refs) -> 
				match acc_of_ts_refs doc_class [REFS_NODE] (LINES []) refs with
				|LINES lines -> lines
				| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		in
		let lines_main:string list =
			match acc_of_tu_doc_main (LINES []) doc.fld_doc_main with
			|LINES lines -> lines 
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		in
		LINES (List.concat [lines_title;lines_authors;lines_abstract;lines_main;lines_refs])
	)
	| EXML _ ->
		let xml_list_title:Xml.xml list = Exml_utils.xml_list_of_ts_title_opt doc.fld_doc_title in
		let xml_list_authors:Xml.xml list = Exml_utils.xml_list_of_ts_authors_opt doc.fld_doc_authors in
		let xml_list_abstract : Xml.xml list = 
			match doc.fld_doc_abstract with
			|None -> []
			|Some (abstract : ts_abstract) -> 
				match acc_of_ts_abstract doc_class [ABSTRACT_NODE] (EXML []) abstract with
				|EXML xml_list -> xml_list
				| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		in
		let xml_list_refs:Xml.xml list = 
			match doc.fld_doc_refs with
			|None -> []
			|Some (refs : ts_refs) -> 
				match acc_of_ts_refs doc_class [REFS_NODE] (EXML []) refs with
				|EXML xml_list -> xml_list
				| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		in
		let xml_main:Xml.xml = (
			match acc_of_tu_doc_main acc doc.fld_doc_main with
			|EXML xml_list -> Xml.Element ("doc_main",[],xml_list) 
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		let xml_list_doc = List.concat [xml_list_title;xml_list_authors;xml_list_abstract;[xml_main];xml_list_refs] in
		EXML [Xml.Element ("doc",[("class",doc_class)],xml_list_doc)]
	
and acc_of_ts_abstract (doc_class : string) (path : Common_utils.t_path) (acc : t_acc) (a : ts_abstract) : t_acc =
	match a with
	|Cs_abstract (b : ts_blks) -> 
		match acc with
		|LINES _ -> (
			let padding : string list =
			match doc_class with
			|"doc chs" -> ["";"";""]
			|"doc secs" -> ["";""]
			| _ -> [""]
			in
			let hdr : string list = Txt_utils.lines_of_abstract_hdr doc_class Common_utils.doc_settings.abstract_indent Common_utils.doc_settings.abstract_hdr in
			match acc_of_ts_blks path (LINES []) b with
			|LINES lines -> LINES (List.concat [hdr; lines; padding])
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		|EXML _ -> (
			let hdr : Xml.xml = Exml_utils.xml_of_abstract_hdr Common_utils.doc_settings.abstract_hdr in
			match acc_of_ts_blks path (EXML []) b with
			|EXML xml_list -> EXML [Xml.Element ("abstract",[],hdr::xml_list)]
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		| _ -> acc_of_ts_blks path acc b

and acc_of_ts_refs (doc_class : string)  (path : Common_utils.t_path) (acc : t_acc) (a : ts_refs) : t_acc =
	match a with
	|Cs_refs (b : ts_blks) -> 
		match acc with
		|LINES _ -> (
			let padding : string list =
			match doc_class with
			|"doc chs" -> ["";"";""]
			|"doc secs" -> ["";""]
			| _ -> [""]
			in
			let hdr : string list = Txt_utils.lines_of_refs_hdr doc_class Common_utils.doc_settings.refs_indent Common_utils.doc_settings.refs_hdr in
			match acc_of_ts_blks path (LINES []) b with
			|LINES lines -> LINES (List.concat [padding; hdr; lines])
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		|EXML _ -> (
			let hdr : Xml.xml = Exml_utils.xml_of_refs_hdr Common_utils.doc_settings.refs_hdr in
			match acc_of_ts_blks path (EXML []) b with
			|EXML xml_list -> EXML [Xml.Element ("refs",[],hdr::xml_list)]
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		| _ -> acc_of_ts_blks path acc b

and acc_of_tu_doc_main (acc : t_acc) (a : Doc_types.tu_doc_main) : t_acc =
	match a with
	| Cu_doc_main_chs (b : Doc_types.ts_chs) -> acc_of_ts_chs ([] : Common_utils.t_path) acc b
	| Cu_doc_main_secs (b : Doc_types.ts_secs) -> acc_of_ts_secs ([] : Common_utils.t_path) acc b
	| Cu_doc_main_pars (b : Doc_types.ts_pars) -> acc_of_ts_pars ([] : Common_utils.t_path) acc b
	| Cu_doc_main_blks (b : Doc_types.ts_blks) -> acc_of_ts_blks ([] : Common_utils.t_path) acc b

and acc_of_ts_chs (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.ts_chs) : t_acc =
	match a with Cs_chs (b : Doc_types.tr_ch list) ->
	let rec aux (ch_nr : int) (acc : t_acc) (b : tr_ch list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> aux (ch_nr + 1) (add_empty_lines_after_ch tl (acc_of_tr_ch (CH_NODE ch_nr :: path) acc hd)) tl
	)
	in
	aux 0 acc b

and add_empty_lines_after_ch (tl:tr_ch list) (acc : t_acc) : t_acc =
	match tl, acc with
	|a::b, LINES lines -> LINES (List.concat [lines;["";"";""]])
	|_, _ -> acc


and acc_of_ts_secs (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.ts_secs) : t_acc =
	match a with | Cs_secs (b : Doc_types.tr_sec list) ->
	let rec aux (sec_nr : int) (app_nr : int) (acc : t_acc) (b : tr_sec list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> 
			match is_appendix hd with
			|true -> aux sec_nr (app_nr + 1) (add_empty_lines_after_sec tl (acc_of_tr_sec (APP_NODE app_nr :: path) acc hd)) tl
			|false -> aux (sec_nr + 1) app_nr (add_empty_lines_after_sec tl (acc_of_tr_sec (SEC_NODE sec_nr :: path) acc hd)) tl
	)
	in 
	aux 0 0 acc b

and is_appendix (a : tr_sec) : bool =
	match a.fld_sec_tag_or_id with
	|None -> false
	|Some (b : tu_tag_or_id) -> 
		match b with
		|Cu_tag_or_id_tag (tag : ts_tag) -> (
			match tag with
			|Cs_tag (s : string) ->
				match s with
				|"APP" -> true
				|_ -> false
		)
		|Cu_tag_or_id_id (id : tr_id) ->
			match id.fld_id_tag with
			|Cs_tag (s : string) ->
				match s with
				|"APP" -> true
				|_ -> false

and add_empty_lines_after_sec (tl:tr_sec list) (acc : t_acc) : t_acc =
	match tl, acc with
	|a::b, LINES lines -> LINES (List.concat [lines;["";""]])
	|_, _ -> acc


and acc_of_ts_pars (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.ts_pars) : t_acc =
	match a with Cs_pars (b : Doc_types.tr_par list) ->
	let rec aux (par_nr : int) (acc : t_acc) (b : tr_par list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> aux (par_nr + 1) (add_empty_lines_after_par tl (acc_of_tr_par ((Common_utils.node_of_tr_par par_nr hd):: path) acc hd)) tl
	)
	in 
	aux 0 acc b

and add_empty_lines_after_par (tl:tr_par list) (acc : t_acc) : t_acc =
	match tl, acc with
	|a::b, LINES lines -> LINES (List.concat [lines;[""]])
	|_, _ -> acc


and acc_of_ts_blks (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blks) : t_acc =
	match a with Cs_blks (b : Doc_types.tu_blk list) ->
	let rec aux (auto_nr : int) (acc : t_acc) (b : tu_blk list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> (
			match acc_of_tu_blk auto_nr path acc hd with
			(acc : t_acc), (auto_nr : int) -> aux auto_nr acc tl
		)
	)	
	in 
	aux 0 acc b


and acc_of_tr_ch (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.tr_ch) : t_acc =
	let ch_class : string = Common_utils.class_of_tr_ch a in
	match acc with
	|CREF_TABLE table ->
		let newacc : t_acc = CREF_TABLE (
			match a.fld_ch_tag_or_id with
			|Some (Cu_tag_or_id_id (id : Doc_types.tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in 
		acc_of_ch_main path newacc a.fld_ch_main
	|LINES acc_lines -> 
		let newacc : t_acc = LINES (
			List.concat [acc_lines;Txt_utils.lines_of_ts_hdr_opt path a.fld_ch_hdr]
		)
		in 
		acc_of_ch_main path newacc a.fld_ch_main
	|EXML acc_list -> 
		let xml_list_main : Xml.xml list = (
			match acc_of_ch_main path (EXML []) a.fld_ch_main with
			|EXML xml_list -> xml_list
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Common_utils.label_of_path path))] in
		let xml_hdr : Xml.xml = (
			match a.fld_ch_hdr with
			|None -> Xml.Element ("ch_lbl_hdr", [], xml_list_lbl)
			|Some (hdr : Doc_types.ts_hdr) ->
				match hdr with
				|Cs_hdr (t : Doc_types.ts_txt_units) -> Xml.Element ("ch_hdr", [], Exml_utils.xml_list_of_ts_txt_units path t)
		)
		in
		let xml_main:Xml.xml = Xml.Element ("ch_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("ch_lbl",[],xml_list_lbl) in
		let attr_list : (string*string) list = ("class",ch_class)::(Exml_utils.attr_list_of_tu_tag_or_id a.fld_ch_tag_or_id) in
		match a.fld_ch_hdr with
		|None -> EXML (List.concat [acc_list;[Xml.Element ("ch", attr_list, [xml_hdr;xml_main])]])
		|Some _ -> EXML (List.concat [acc_list;[Xml.Element ("ch", attr_list, [xml_lbl;xml_hdr;xml_main])]])


and acc_of_tr_sec (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.tr_sec) : t_acc =
	match acc with
	|CREF_TABLE table ->
		let newacc : t_acc = CREF_TABLE (
			match a.Doc_types.fld_sec_tag_or_id with
			|Some (Cu_tag_or_id_id (id : Doc_types.tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in 
		acc_of_sec_main path newacc a.fld_sec_main
	|LINES acc_lines -> (
		let newacc : t_acc = LINES (
			List.concat [acc_lines;Txt_utils.lines_of_ts_hdr_opt path a.fld_sec_hdr]
		)
		in 
		acc_of_sec_main path newacc a.fld_sec_main
	)
	|EXML acc_list -> 
		let xml_list_main:Xml.xml list= (
			match acc_of_sec_main path (EXML []) a.fld_sec_main with
			|EXML xml_list -> xml_list
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Common_utils.label_of_path path))] in
		let xml_hdr:Xml.xml = (
			match a.fld_sec_hdr with
			|None -> 
				Xml.Element ("sec_lbl_hdr",[("style","visibility:hidden")],xml_list_lbl)
			|Some (hdr : ts_hdr) -> 
				match hdr with
				|Cs_hdr (t:ts_txt_units) -> Xml.Element ("sec_hdr",[],xml_list_of_ts_txt_units path t)
		)
		in
		let xml_main:Xml.xml = Xml.Element ("sec_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("sec_lbl",[],xml_list_lbl) in
		let attr_list : (string*string) list = Exml_utils.attr_list_of_tu_tag_or_id a.fld_sec_tag_or_id in
		EXML (List.concat [acc_list;[Xml.Element ("sec", attr_list, [xml_lbl;xml_hdr; xml_main])]])

and acc_of_tr_par (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.tr_par) : t_acc =
	match acc with
	|CREF_TABLE table -> (
		let newacc : t_acc = CREF_TABLE (
			match a.fld_par_tag_or_id with
			|Some (Cu_tag_or_id_id (id : Doc_types.tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in acc_of_ts_blks path newacc a.fld_par_main
	)
	|LINES acc_lines -> (
		let new_par = Par_hdr_mod.copy_hdr_to_main_and_lbl_to_hdr path a in
		match acc_of_ts_blks path (LINES []) new_par.fld_par_main with
		|LINES (hd::tl) -> LINES (List.concat [acc_lines;[Txt_utils.insert_label path hd];tl])
		|_ -> raise (Error "par_main cannot be empty")
	)
	|EXML acc_list -> (
		let new_par = Par_hdr_mod.copy_hdr_to_main_and_lbl_to_hdr path a in
		let xml_list_main:Xml.xml list= (
			match acc_of_par_main path (EXML []) new_par.fld_par_main with
			|EXML xml_list -> xml_list
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Common_utils.label_of_path path))] in
		let xml_hdr:Xml.xml = (
			match new_par.fld_par_hdr with
			|None -> raise (Error "new par expected to have hdr")
			|Some (hdr : ts_hdr) -> 
				match hdr with
				|Cs_hdr (t:ts_txt_units) -> Xml.Element ("par_hdr",[("style","visibility:hidden")],Exml_utils.xml_list_of_ts_txt_units path t)
		)
		in 
		let xml_main:Xml.xml = Xml.Element ("par_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("par_lbl",[],xml_list_lbl) in
		let attr_list : (string*string) list = Exml_utils.attr_list_of_tu_tag_or_id a.fld_par_tag_or_id in
		EXML (List.concat [acc_list;[Xml.Element ("par", attr_list, [xml_lbl; xml_hdr; xml_main])]])
	)

and acc_of_ch_main (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.tu_secs_pars_or_blks) : t_acc =
	match a with
	| Cu_secs_pars_or_blks_secs (b : Doc_types.ts_secs) -> acc_of_ts_secs path acc b
	| Cu_secs_pars_or_blks_pars (b : Doc_types.ts_pars) -> acc_of_ts_pars path acc b
	| Cu_secs_pars_or_blks_blks (b : Doc_types.ts_blks) -> acc_of_ts_blks path acc b

and acc_of_sec_main (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.tu_pars_or_blks) : t_acc =
	match a with
	| Cu_pars_or_blks_pars (b : Doc_types.ts_pars) -> acc_of_ts_pars path acc b
	| Cu_pars_or_blks_blks (b : Doc_types.ts_blks) -> acc_of_ts_blks path acc b

and acc_of_par_main (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blks) : t_acc =
	acc_of_ts_blks path acc a

and acc_of_tu_blk (auto_nr : int) (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.tu_blk) : t_acc * int =
	match a with
	| Cu_blk_itm (b : Doc_types.tr_blk_itm) ->
		let path_hd_opt : Common_utils.t_node option=
			match path with
			|hd::tl -> Some hd
			|[] -> None
		in
		let node : Common_utils.t_node = Common_utils.node_of_blk_itm path_hd_opt auto_nr b in
		let next_auto_nr =
			match b.fld_blk_itm_lbl with 
			|Cu_lbl_auto Cs_lbl_auto -> auto_nr + 1
			| _ -> auto_nr
		in 
		(acc_of_tr_blk_itm (node :: path) acc b, next_auto_nr)
	| Cu_blk_dsp (b : Doc_types.ts_blk_dsp) ->
		let node : Common_utils.t_node = DSP_NODE in
		acc_of_ts_blk_dsp auto_nr (node :: path) acc b
	| Cu_blk_txt (b : Doc_types.ts_blk_txt) -> (acc_of_ts_blk_txt path acc b, auto_nr)
	| Cu_blk_blt (b : Doc_types.ts_blk_blt) ->
		let node : Common_utils.t_node = BLT_NODE in
		(acc_of_ts_blk_blt (node :: path) acc b, auto_nr)

and acc_of_ts_blk_txt (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blk_txt) : t_acc =
	match acc with
		| CREF_TABLE _ -> acc
		| LINES acc_lines -> LINES (List.concat [acc_lines; Txt_utils.lines_of_ts_blk_txt path a])
		| EXML acc_list -> EXML (List.concat [acc_list; [Exml_utils.xml_of_ts_blk_txt path a]])

and acc_of_ts_blk_blt (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blk_blt) : t_acc =
	match a with Cs_blk_blt (b : Doc_types.ts_blks) ->
	match acc with
	| CREF_TABLE _ -> acc_of_ts_blks path acc b
	| LINES acc_lines -> (
		match acc_of_ts_blks path (LINES []) b with
		| LINES (lines : string list) -> (
			let head : string = List.hd lines in
			let newhead : string = Txt_utils.insert_label path head in
			let newlines : string list = newhead :: List.tl lines in
			LINES (List.concat [ acc_lines; newlines; ])
		)
		| _ -> raise (Error "accumulator output type not identical to accumulator input type")

	)
	| EXML acc_list ->
		let xml_list_main:Xml.xml list = (
			match acc_of_ts_blks path (EXML []) b with
			|EXML xml_list_blks -> xml_list_blks
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in 
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Common_utils.label_of_path path))]
		in
		let xml_main:Xml.xml = Xml.Element ("blk_blt_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("blk_blt_lbl",[],xml_list_lbl) in
		EXML (List.concat [acc_list;[Xml.Element ("blk_blt",[],[xml_lbl;xml_main])]])


and acc_of_tr_blk_itm (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.tr_blk_itm) : t_acc =
	match acc with
	| CREF_TABLE table ->
		let newacc : t_acc = CREF_TABLE (
			match a.fld_blk_itm_id with
			| Some (id : Doc_types.tr_id) -> (id, path) :: table
			| _ -> table
		)
		in acc_of_ts_blks path newacc a.fld_blk_itm_main
	| LINES acc_lines -> (
		match acc_of_ts_blks path (LINES []) a.fld_blk_itm_main with
		| LINES (lines : string list) -> (
			let head : string = List.hd lines in
			let newhead : string = Txt_utils.insert_label path head in
			let newlines : string list = newhead :: List.tl lines in
			LINES (List.concat [ acc_lines; newlines ])
		)
		| _ -> raise (Error "accumulator output type not identical to accumulator input type")

	)
	| EXML acc_list ->
		let xml_list_main = (
			match acc_of_ts_blks path (EXML []) a.fld_blk_itm_main with
			|EXML xml_list_blks -> xml_list_blks
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in 
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Common_utils.label_of_path path))]
		in
		let xml_main : Xml.xml = Xml.Element ("blk_itm_main",[],xml_list_main) in
		let xml_lbl : Xml.xml = Xml.Element ("blk_itm_lbl",[],xml_list_lbl) in
		let attr_list = Exml_utils.attr_list_of_tr_id a.fld_blk_itm_id in
		EXML (List.concat [acc_list;[Xml.Element ("blk_itm", attr_list, [xml_lbl;xml_main])]])


and acc_of_ts_blk_dsp (auto_nr : int) (path : Common_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blk_dsp) : t_acc * int =
	match a with Cs_blk_dsp (b : Doc_types.ts_dsp_lines) ->
	match b with Cs_dsp_lines (c : Doc_types.tr_dsp_line list) ->
	let rec aux (auto_nr : int) (acc : t_acc) (c : tr_dsp_line list) : t_acc * int = (
		match c with
		| [] -> (acc, auto_nr)
		| hd :: tl ->
			let node : Common_utils.t_node = Common_utils.node_of_dsp_line auto_nr hd in
			let next_auto_nr =
				match hd.fld_dsp_line_lbl with 
				| Some (Cu_lbl_auto Cs_lbl_auto) -> auto_nr + 1 
				| _ -> auto_nr
			in
			aux next_auto_nr (acc_of_tr_dsp_line (node :: path) auto_nr acc hd) tl
	)
	in
	match acc with
	| CREF_TABLE _ -> aux auto_nr acc c
	| LINES acc_lines -> (
		match aux auto_nr (LINES []) c with 
		| (LINES lines,nr) -> 
			(LINES (List.concat [acc_lines;lines;[""]]),nr)
		| _ -> raise (Error "accumulator output type not identical to accumulator input type")

	)
	| EXML acc_list -> (
		match aux auto_nr (EXML []) c with 
		|(EXML xml_list,nr) -> 
			(EXML (List.concat [acc_list;[Xml.Element ("blk_dsp",[],xml_list)]]),nr)
		| _ -> raise (Error "accumulator output type not identical to accumulator input type")

	)

and acc_of_tr_dsp_line (path : Common_utils.t_path) (auto_nr : int) (acc : t_acc) (a : Doc_types.tr_dsp_line) : t_acc =
	match acc with
	| CREF_TABLE table -> (
		match a.fld_dsp_line_id with
			| Some (id : Doc_types.tr_id) -> CREF_TABLE ((id, path) :: table)
			| None -> CREF_TABLE table
	)
	| LINES acc_lines -> (
		match a.fld_dsp_line_lbl, Txt_utils.lines_of_ts_txt_units path a.fld_dsp_line_units with
		|Some _, hd::tl -> LINES (List.concat [acc_lines;[Txt_utils.insert_label path hd];tl])
		|None, lines -> LINES (List.concat [acc_lines;lines])
		|_,[] -> raise (Error "dps_line cannot be empty")
	)
	| EXML acc_list -> (
		let xml_list_main:Xml.xml list = Exml_utils.xml_list_of_ts_txt_units path a.fld_dsp_line_units in 
		let xml_list_lbl:Xml.xml list = 
			match Common_utils.label_of_path_opt path with
			|None -> []
			|Some (s:string) -> [Xml.PCData (Exml_utils.pcdata_of_string s)]
		in
		let xml_main:Xml.xml = Xml.Element ("dsp_line_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("dsp_line_lbl",[],xml_list_lbl) in
		let attr_list: (string*string) list = attr_list_of_tr_id a.fld_dsp_line_id in
		match a.fld_dsp_line_lbl with
		|None -> EXML (List.concat [acc_list;[Xml.Element ("dsp_line", attr_list, [xml_main])]])
		|Some _ -> EXML (List.concat [acc_list;[Xml.Element ("dsp_line",attr_list, [xml_lbl; xml_main])]])
	)

