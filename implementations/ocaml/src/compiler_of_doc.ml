open Doc_types
open Cref_utils
open Txt_utils
open Exml_utils

exception Error of string

type t_acc = CREF_TABLE of Cref_utils.t_cref_table | LINES of (string list) | EXML of (Xml.xml list)

let rec cref_table_of_tr_doc (doc : Doc_types.tr_doc) : Cref_utils.t_cref_table =
	match acc_of_tr_doc (CREF_TABLE []) doc with
	| CREF_TABLE table -> List.rev table
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")

and txt_of_tr_doc (doc : Doc_types.tr_doc) : string =
	String.concat "\n" (lines_of_tr_doc doc)

and exml_of_tr_doc (doc : Doc_types.tr_doc) : Xml.xml =
	match xml_list_of_tr_doc doc with
	| hd::[] -> hd
	| _ -> raise (Error "function expected to return an exml-list with exactly one element")

and lines_of_tr_doc (doc : Doc_types.tr_doc) : string list =
	let _ : unit = Cref_utils.doc_cref_table.content <- cref_table_of_tr_doc doc in
	match acc_of_tr_doc (LINES []) doc with
	| LINES lines -> Txt_utils.remove_empty_endlines lines
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")

and xml_list_of_tr_doc (doc : Doc_types.tr_doc) : Xml.xml list =
	let _ : unit = Cref_utils.doc_cref_table.content <- cref_table_of_tr_doc doc in
	match acc_of_tr_doc (EXML []) doc with
	| EXML xml_list -> xml_list
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")

and acc_of_tr_doc (acc : t_acc) (doc : Doc_types.tr_doc) : t_acc =
	let _ : unit = Txt_utils.doc_settings_of_tr_doc doc in
	match acc with
	| CREF_TABLE _ ->  acc_of_te_doc_main acc doc.fld_doc_main
	| LINES _ -> (
		let lines_main:string list = (
			match acc_of_te_doc_main acc doc.fld_doc_main with
			|LINES lines -> lines 
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		match doc.fld_doc_title, doc.fld_doc_author with
		| None, None -> LINES lines_main
		| Some (title : Doc_types.ts_title), None -> 
			let lines_title : string list = lines_of_ts_title title in
			LINES (List.concat [lines_title;lines_main])
		| None, Some (author : Doc_types.ts_author) -> 
			let lines_author : string list = lines_of_ts_author author in
			LINES (List.concat [lines_author;lines_main])
		| Some (title : Doc_types.ts_title), Some (author : Doc_types.ts_author) -> 
			let lines_title : string list = lines_of_ts_title title in
			let lines_author : string list = lines_of_ts_author author in
			LINES (List.concat [lines_title;lines_author;lines_main])
	)
	| EXML _ -> (
		let xml_main:Xml.xml = (
			match acc_of_te_doc_main acc doc.fld_doc_main with
			|EXML xml_list -> Xml.Element ("doc_main",[],xml_list) 
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		match doc.fld_doc_title, doc.fld_doc_author with
		| None, None -> EXML [Xml.Element ("doc",[],[xml_main])]
		| Some (title : Doc_types.ts_title), None -> 
			let xml_title : Xml.xml = xml_of_ts_title title in
			EXML [Xml.Element ("doc",[],[xml_title;xml_main])]
		| None, Some (author : Doc_types.ts_author) -> 
			let xml_author : Xml.xml = xml_of_ts_author author in
			EXML [Xml.Element ("doc",[],[xml_author;xml_main])]
		| Some (title:ts_title), Some (author:ts_author) -> 
			let xml_title : Xml.xml = xml_of_ts_title title in
			let xml_author : Xml.xml = xml_of_ts_author author in
			EXML [Xml.Element ("doc",[],[xml_title;xml_author;xml_main])]
	)

and acc_of_te_doc_main (acc : t_acc) (a : Doc_types.te_doc_main) : t_acc =
	match a with
	| Ce_doc_main_chs (b : Doc_types.ts_chs) -> acc_of_ts_chs ([] : Cref_utils.t_path) acc b
	| Ce_doc_main_secs (b : Doc_types.ts_secs) -> acc_of_ts_secs ([] : Cref_utils.t_path) acc b
	| Ce_doc_main_pars (b : Doc_types.ts_pars) -> acc_of_ts_pars ([] : Cref_utils.t_path) acc b
	| Ce_doc_main_blks (b : Doc_types.ts_blks) -> acc_of_ts_blks ([] : Cref_utils.t_path) acc b

and acc_of_ts_chs (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.ts_chs) : t_acc =
	match a with Cs_chs (b : Doc_types.tr_ch list) ->
	let rec aux (ch_nr : int) (acc : t_acc) (b : tr_ch list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> aux (ch_nr + 1) (acc_of_tr_ch (CH_NODE ch_nr :: path) acc hd) tl
	)
	in
	aux 0 acc b

and acc_of_ts_secs (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.ts_secs) : t_acc =
	match a with | Cs_secs (b : Doc_types.tr_sec list) ->
	let rec aux (sec_nr : int) (acc : t_acc) (b : tr_sec list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> aux (sec_nr + 1) (add_newlines_after_sec tl (acc_of_tr_sec (SEC_NODE sec_nr :: path) acc hd)) tl
	)
	in 
	aux 0 acc b

and add_newlines_after_sec (tl:tr_sec list) (acc : t_acc) : t_acc =
	match tl, acc with
	|a::b, LINES lines -> LINES (List.concat [lines;["";""]])
	|_, _ -> acc


and acc_of_ts_pars (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.ts_pars) : t_acc =
	match a with Cs_pars (b : Doc_types.tr_par list) ->
	let rec aux (par_nr : int) (acc : t_acc) (b : tr_par list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> aux (par_nr + 1) (add_newlines_after_par tl (acc_of_tr_par (PAR_NODE par_nr :: path) acc hd)) tl
	)
	in 
	aux 0 acc b

and add_newlines_after_par (tl:tr_par list) (acc : t_acc) : t_acc =
	match tl, acc with
	|a::b, LINES lines -> LINES (List.concat [lines;[""]])
	|_, _ -> acc


and acc_of_ts_blks (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blks) : t_acc =
	match a with Cs_blks (b : Doc_types.te_blk list) ->
	let rec aux (auto_nr : int) (acc : t_acc) (b : te_blk list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> (
			match acc_of_te_blk auto_nr path acc hd with
			(acc : t_acc), (auto_nr : int) -> aux auto_nr acc tl
		)
	)	
	in 
	aux 0 acc b


and acc_of_tr_ch (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.tr_ch) : t_acc =
	match acc with
	|CREF_TABLE table ->
		let newacc : t_acc = CREF_TABLE (
			match a.fld_ch_tag_or_id with
			|Some (Ce_tag_or_id_id (id : Doc_types.tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in 
		acc_of_ch_main path newacc a.fld_ch_main
	|LINES acc_lines -> 
		let newacc : t_acc = LINES (
			match a.fld_ch_hdr with
			|None -> List.concat [acc_lines; [Txt_utils.mark_of_path path]; ["";""]]
			|Some (hdr : Doc_types.ts_hdr) -> List.concat [acc_lines; Txt_utils.lines_of_ts_hdr path hdr; [""]]
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
		let xml_hdr_opt : Xml.xml option= (
			match a.fld_ch_hdr with
			|None -> None
			|Some (hdr : Doc_types.ts_hdr) -> 
				match hdr with
				|Cs_hdr (t : Doc_types.ts_txt_units) -> Some (Xml.Element ("ch_hdr", [], Exml_utils.xml_list_of_ts_txt_units path t))
		)
		in 
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Txt_utils.mark_of_path path))]
		in 
		let xml_main:Xml.xml = Xml.Element ("ch_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("ch_lbl",[],xml_list_lbl) in
		let attr_list : (string*string) list = Exml_utils.attr_list_of_tag_or_id a.fld_ch_tag_or_id in
		match xml_hdr_opt with
		|None -> EXML (List.concat [acc_list;[Xml.Element ("ch", attr_list, [xml_lbl; xml_main])]])
		|Some xml_hdr -> EXML (List.concat [acc_list;[Xml.Element ("ch", attr_list, [xml_lbl;xml_hdr;xml_main])]])


and acc_of_tr_sec (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.tr_sec) : t_acc =
	match acc with
	|CREF_TABLE table ->
		let newacc : t_acc = CREF_TABLE (
			match a.Doc_types.fld_sec_tag_or_id with
			|Some (Ce_tag_or_id_id (id : Doc_types.tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in 
		acc_of_sec_main path newacc a.fld_sec_main
	|LINES acc_lines -> (
		let newacc : t_acc = LINES (
			match a.fld_sec_hdr with
			|None -> List.concat [acc_lines;[Txt_utils.mark_of_path path];["";""]]
			|Some (hdr : ts_hdr) -> List.concat [acc_lines;lines_of_ts_hdr path hdr;[""]]
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
		let xml_hdr_opt:Xml.xml option= (
			match a.fld_sec_hdr with
			|None -> None
			|Some (hdr : ts_hdr) -> 
				match hdr with
				|Cs_hdr (t:ts_txt_units) -> Some (Xml.Element ("sec_hdr",[],xml_list_of_ts_txt_units path t))
		)
		in 
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Txt_utils.mark_of_path path))]
		in
		let xml_main:Xml.xml = Xml.Element ("sec_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("sec_lbl",[],xml_list_lbl) in
		let attr_list : (string*string) list = Exml_utils.attr_list_of_tag_or_id a.fld_sec_tag_or_id in
		match xml_hdr_opt with
		|None -> EXML (List.concat [acc_list;[Xml.Element ("sec", attr_list, [xml_lbl; xml_main])]])
		|Some xml_hdr -> EXML (List.concat [acc_list;[Xml.Element ("sec", attr_list, [xml_lbl;xml_hdr; xml_main])]])

and acc_of_tr_par (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.tr_par) : t_acc =
	match acc with
	|CREF_TABLE table -> (
		let newacc : t_acc = CREF_TABLE (
			match a.fld_par_tag_or_id with
			|Some (Ce_tag_or_id_id (id : Doc_types.tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in acc_of_ts_blks path newacc a.fld_par_main
	)
	|LINES acc_lines -> (
		let new_par = Par_hdr_mod.copy_hdr_to_main a in
		match acc_of_ts_blks path (LINES []) new_par.fld_par_main with
		|LINES (hd::tl) -> LINES (List.concat [acc_lines;[Txt_utils.insert_mark path hd];tl])
		|_ -> raise (Error "par_main cannot be empty")
	)
	|EXML acc_list -> (
		let xml_list_main:Xml.xml list= (
			let new_par = Par_hdr_mod.copy_hdr_to_main a in
			match acc_of_par_main path (EXML []) new_par.fld_par_main with
			|EXML xml_list -> xml_list
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		let xml_hdr_opt:Xml.xml option= (
			match a.fld_par_hdr with
			|None -> None
			|Some (hdr : ts_hdr) -> 
				match hdr with
				|Cs_hdr (t:ts_txt_units) -> Some (Xml.Element ("par_hdr",[],Exml_utils.xml_list_of_ts_txt_units path t))
		)
		in 
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Txt_utils.mark_of_path path))]
		in
		let xml_main:Xml.xml = Xml.Element ("par_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("par_lbl",[],xml_list_lbl) in
		let attr_list : (string*string) list = Exml_utils.attr_list_of_tag_or_id a.fld_par_tag_or_id in
		match xml_hdr_opt with
		|None -> EXML (List.concat [acc_list;[Xml.Element ("par", attr_list, [xml_lbl; xml_main])]])
		|Some xml_hdr -> EXML (List.concat [acc_list;[Xml.Element ("par", attr_list, [xml_lbl; xml_hdr; xml_main])]])
	)

and acc_of_ch_main (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.te_secs_pars_or_blks) : t_acc =
	match a with
	| Ce_secs_pars_or_blks_secs (b : Doc_types.ts_secs) -> acc_of_ts_secs path acc b
	| Ce_secs_pars_or_blks_pars (b : Doc_types.ts_pars) -> acc_of_ts_pars path acc b
	| Ce_secs_pars_or_blks_blks (b : Doc_types.ts_blks) -> acc_of_ts_blks path acc b

and acc_of_sec_main (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.te_pars_or_blks) : t_acc =
	match a with
	| Ce_pars_or_blks_pars (b : Doc_types.ts_pars) -> acc_of_ts_pars path acc b
	| Ce_pars_or_blks_blks (b : Doc_types.ts_blks) -> acc_of_ts_blks path acc b

and acc_of_par_main (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blks) : t_acc =
	acc_of_ts_blks path acc a

and acc_of_te_blk (auto_nr : int) (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.te_blk) : t_acc * int =
	match a with
	| Ce_blk_itm (b : Doc_types.tr_blk_itm) ->
		let node : Cref_utils.t_node = Cref_utils.node_of_blk_itm auto_nr b in
		let next_auto_nr =
			match b.fld_blk_itm_lbl with 
			|Ce_lbl_auto Cs_lbl_auto -> auto_nr + 1 
			| _ -> auto_nr
		in 
		(acc_of_tr_blk_itm (node :: path) acc b, next_auto_nr)
	| Ce_blk_dsp (b : Doc_types.ts_blk_dsp) ->
		let node : Cref_utils.t_node = DSP_NODE in
		acc_of_ts_blk_dsp auto_nr (node :: path) acc b
	| Ce_blk_txt (b : Doc_types.ts_blk_txt) -> (acc_of_ts_blk_txt path acc b, auto_nr)
	| Ce_blk_blt (b : Doc_types.ts_blk_blt) ->
		let node : Cref_utils.t_node = BLT_NODE in
		(acc_of_ts_blk_blt (node :: path) acc b, auto_nr)

and acc_of_ts_blk_txt (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blk_txt) : t_acc =
	match a with Cs_blk_txt (b : Doc_types.ts_txt_units) ->
		match acc with
		| CREF_TABLE _ -> acc
		| LINES acc -> LINES (List.concat [ acc; Txt_utils.lines_of_ts_txt_units path b; [""] ])
		| EXML acc_list -> EXML (List.concat [acc_list; [Xml.Element ("blk_txt",[], Exml_utils.xml_list_of_ts_txt_units path b)]])

and acc_of_ts_blk_blt (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blk_blt) : t_acc =
	match a with Cs_blk_blt (b : Doc_types.ts_blks) ->
	match acc with
	| CREF_TABLE _ -> acc_of_ts_blks path acc b
	| LINES acc_lines -> (
		match acc_of_ts_blks path (LINES []) b with
		| LINES (lines : string list) -> (
			let head : string = List.hd lines in
			let newhead : string = Txt_utils.insert_mark path head in
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
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Txt_utils.mark_of_path path))]
		in
		let xml_main:Xml.xml = Xml.Element ("blk_blt_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("blk_blt_lbl",[],xml_list_lbl) in
		EXML (List.concat [acc_list;[Xml.Element ("blk_blt",[],[xml_lbl;xml_main])]])


and acc_of_tr_blk_itm (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.tr_blk_itm) : t_acc =
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
			let newhead : string = Txt_utils.insert_mark path head in
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
		let xml_list_lbl:Xml.xml list = [Xml.PCData (Exml_utils.pcdata_of_string (Txt_utils.mark_of_path path))]
		in
		let xml_main : Xml.xml = Xml.Element ("blk_itm_main",[],xml_list_main) in
		let xml_lbl : Xml.xml = Xml.Element ("blk_itm_lbl",[],xml_list_lbl) in
		let attr_list = Exml_utils.attr_list_of_tr_id a.fld_blk_itm_id in
		EXML (List.concat [acc_list;[Xml.Element ("blk_itm", attr_list, [xml_lbl;xml_main])]])


and acc_of_ts_blk_dsp (auto_nr : int) (path : Cref_utils.t_path) (acc : t_acc) (a : Doc_types.ts_blk_dsp) : t_acc * int =
	match a with Cs_blk_dsp (b : Doc_types.ts_dsp_lines) ->
	match b with Cs_dsp_lines (c : Doc_types.tr_dsp_line list) ->
	let rec aux (auto_nr : int) (acc : t_acc) (c : tr_dsp_line list) : t_acc * int = (
		match c with
		| [] -> (acc, auto_nr)
		| hd :: tl ->
			let node : Cref_utils.t_node = Cref_utils.node_of_dsp_line auto_nr hd in
			let next_auto_nr =
				match hd.fld_dsp_line_lbl with 
				| Some (Ce_lbl_auto Cs_lbl_auto) -> auto_nr + 1 
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

and acc_of_tr_dsp_line (path : Cref_utils.t_path) (auto_nr : int) (acc : t_acc) (a : Doc_types.tr_dsp_line) : t_acc =
	match acc with
	| CREF_TABLE table -> (
		match a.fld_dsp_line_id with
			| Some (id : Doc_types.tr_id) -> CREF_TABLE ((id, path) :: table)
			| None -> CREF_TABLE table
	)
	| LINES acc_lines -> (
		match a.fld_dsp_line_lbl, Txt_utils.lines_of_ts_txt_units path a.fld_dsp_line_units with
		|Some _, hd::tl -> LINES (List.concat [acc_lines;[Txt_utils.insert_mark path hd];tl])
		|None, lines -> LINES (List.concat [acc_lines;lines])
		|_,[] -> raise (Error "dps_line cannot be empty")
	)
	| EXML acc_list -> (
		let xml_list_main:Xml.xml list = Exml_utils.xml_list_of_ts_txt_units path a.fld_dsp_line_units in 
		let xml_list_lbl:Xml.xml list = 
			match Txt_utils.mark_of_path_opt path with
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

