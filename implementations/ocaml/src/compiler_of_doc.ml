open Doc_types
open Cref_utils
open Txt_utils
open Exml_utils

exception Error of string

type t_acc = CREF_TABLE of Cref_utils.t_cref_table | LINES of (string list) | XML of (Xml.xml list)

let rec txt_string_of_doc (d : tr_doc) : string =
	String.concat "\n" (lines_of_doc d)

and lines_of_doc (d : tr_doc) : string list =
	let _ : unit = doc_cref_table.content <- cref_table_of_doc d in
	match acc_of_doc (LINES []) (d : tr_doc) with
	| LINES (lines : string list) -> lines
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")

and cref_table_of_doc (d : tr_doc) : t_cref_table =
	match acc_of_doc (CREF_TABLE []) (d : tr_doc) with
	| CREF_TABLE (c : t_cref_table) -> List.rev c
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")


and xml_list_of_doc (d : tr_doc):Xml.xml list =
	let _ : unit = doc_cref_table.content <- cref_table_of_doc d in
	match acc_of_doc (XML []) d with
	| XML (xml_list:Xml.xml list) -> xml_list
	| _ -> raise (Error "accumulator output type not identical to accumulator input type")


and xml_of_doc (d:tr_doc):Xml.xml =
	match xml_list_of_doc d with
	|hd::[]->hd
	|_ -> raise (Error "function expected to return an xml-list with exactly one element")

and acc_of_doc (acc : t_acc) (d : tr_doc) : t_acc =
	match acc with
	|XML _ -> (
		let xml_main:Xml.xml = (
			match acc_of_doc_main acc d.fld_doc_main with
			|XML xml_list -> Xml.Element ("doc_main",[],xml_list) 
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		match d.fld_doc_title, d.fld_doc_author with
		| None, None -> XML [Xml.Element ("doc",[],[xml_main])]
		| Some (title:ts_title), None -> 
			let xml_title:Xml.xml = xml_of_ts_title title in
			XML [Xml.Element ("doc",[],[xml_title;xml_main])]
		| None, Some (author:ts_author) -> 
			let xml_author:Xml.xml = xml_of_ts_author author in
			XML [Xml.Element ("doc",[],[xml_author;xml_main])]
		| Some (title:ts_title), Some (author:ts_author) -> 
			let xml_title:Xml.xml = xml_of_ts_title title in
			let xml_author:Xml.xml = xml_of_ts_author author in
			XML [Xml.Element ("doc",[],[xml_title;xml_author;xml_main])]
	)
	|LINES _ -> (
		let lines_main:string list = (
			match acc_of_doc_main acc d.fld_doc_main with
			|LINES lines -> lines 
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		match d.fld_doc_title, d.fld_doc_author with
		| None, None -> LINES lines_main
		| Some (title:ts_title), None -> 
			let lines_title = lines_of_ts_title title in
			LINES (List.concat [lines_title;lines_main])
		| None, Some (author:ts_author) -> 
			let lines_author = lines_of_ts_author author in
			LINES (List.concat [lines_author;lines_main])
		| Some (title:ts_title), Some (author:ts_author) -> 
			let lines_title = lines_of_ts_title title in
			let lines_author = lines_of_ts_author author in
			LINES (List.concat [lines_title;lines_author;lines_main])
	)
	| _ ->  acc_of_doc_main acc d.fld_doc_main

and acc_of_doc_main (acc : t_acc) (a : te_doc_main) : t_acc =
	match a with
	| Ce_doc_main_chs (b : ts_chs) -> acc_of_chs ([] : t_path) acc b
	| Ce_doc_main_secs (b : ts_secs) -> acc_of_secs ([] : t_path) acc b
	| Ce_doc_main_pars (b : ts_pars) -> acc_of_pars ([] : t_path) acc b
	| Ce_doc_main_blks (b : ts_blks) -> acc_of_blks ([] : t_path) acc b

and acc_of_chs (path : t_path) (acc : t_acc) (a : ts_chs) : t_acc =
	match a with Cs_chs (b:tr_ch list) ->
	let rec aux (ch_nr : int) (acc : t_acc) (b : tr_ch list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> aux (ch_nr + 1) (acc_of_ch (CH_NODE ch_nr :: path) acc hd) tl
	)
	in
	aux 0 acc b

and acc_of_secs (path : t_path) (acc : t_acc) (a : ts_secs) : t_acc =
	match a with | Cs_secs (b:tr_sec list) ->
	let rec aux (sec_nr : int) (acc : t_acc) (b : tr_sec list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> aux (sec_nr + 1) (acc_of_sec (SEC_NODE sec_nr :: path) acc hd) tl
	)
	in 
	aux 0 acc b

and acc_of_pars (path : t_path) (acc : t_acc) (a : ts_pars) : t_acc =
	match a with Cs_pars (b:tr_par list) ->
	let rec aux (par_nr : int) (acc : t_acc) (b : tr_par list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> aux (par_nr + 1) (acc_of_par (PAR_NODE par_nr :: path) acc hd) tl
	)
	in 
	aux 0 acc b

and acc_of_blks (path : t_path) (acc : t_acc) (a : ts_blks) : t_acc =
	match a with Cs_blks (b:te_blk list) ->
	let rec aux (auto_nr : int) (acc : t_acc) (b : te_blk list) : t_acc = (
		match b with
		| [] -> acc
		| hd :: tl -> (
			match acc_of_blk auto_nr path acc hd with
			(acc : t_acc), (auto_nr : int) -> aux auto_nr acc tl
		)
	)	
	in 
	aux 0 acc b

and acc_of_ch (path : t_path) (acc : t_acc) (a : tr_ch) : t_acc =
	match acc with
	|CREF_TABLE table ->
		let newacc : t_acc = CREF_TABLE (
			match a.fld_ch_tag_or_id with
			|Some (Ce_tag_or_id_id (id : tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in 
		acc_of_ch_main path newacc a.fld_ch_main
	|LINES acc_lines -> 
		let newacc : t_acc = LINES (
			match a.fld_ch_hdr with
			|None -> List.concat [acc_lines;decoration_of_head path [mark_of_path path];[""]]
			|Some (hdr : ts_hdr) -> List.concat [acc_lines;lines_of_ts_hdr path hdr;[""]]
		)
		in 
		acc_of_ch_main path newacc a.fld_ch_main
	|XML acc_list -> 
		let xml_list_main:Xml.xml list = (
			match acc_of_ch_main path (XML []) a.fld_ch_main with
			|XML xml_list -> xml_list
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		let xml_hdr_opt:Xml.xml option= (
			match a.fld_ch_hdr with
			|None -> None
			|Some (hdr : ts_hdr) -> 
				match hdr with
				|Cs_hdr (t:ts_txt_units) -> Some (Xml.Element ("ch_hdr",[],xml_list_of_ts_txt_units path t))
		)
		in 
		let xml_list_lbl:Xml.xml list= (
			match path with 
			|hd::tl -> (
				match string_of_node tl hd with
				|Some (s:string) -> [Xml.PCData s]
				|None -> []
			)
			|[] -> raise (Error "path to ch cannot be empty")
		)
		in 
		let xml_main:Xml.xml = Xml.Element ("ch_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("ch_lbl",[],xml_list_lbl) in
		match xml_hdr_opt with
		|None -> XML (List.concat [acc_list;[Xml.Element ("ch",(attr_of_tag_or_id a.fld_ch_tag_or_id),[xml_lbl;xml_main])]])
		|Some xml_hdr -> XML (List.concat [acc_list;[Xml.Element ("ch",(attr_of_tag_or_id a.fld_ch_tag_or_id),[xml_lbl;xml_hdr;xml_main])]])


and acc_of_sec (path : t_path) (acc : t_acc) (a : tr_sec) : t_acc =
	match acc with
	|CREF_TABLE table ->
		let newacc : t_acc = CREF_TABLE (
			match a.fld_sec_tag_or_id with
			|Some (Ce_tag_or_id_id (id : tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in 
		acc_of_sec_main path newacc a.fld_sec_main
	|LINES acc_lines -> (
		let newacc : t_acc = LINES (
			match a.fld_sec_hdr with
			|None -> List.concat [acc_lines;decoration_of_head path [mark_of_path path];[""]]
			|Some (hdr : ts_hdr) -> List.concat [acc_lines;lines_of_ts_hdr path hdr;[""]]
		)
		in 
		acc_of_sec_main path newacc a.fld_sec_main
	)
	|XML acc_list -> 
		let xml_list_main:Xml.xml list= (
			match acc_of_sec_main path (XML []) a.fld_sec_main with
			|XML xml_list -> xml_list
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
		let xml_list_lbl:Xml.xml list = (
			match path with 
			|hd::tl -> (
				match string_of_node tl hd with
				|Some (s:string) -> [Xml.PCData s]
				|None -> []
			)
			|[] -> raise (Error "path to sec cannot be empty")
		)
		in
		let xml_main:Xml.xml = Xml.Element ("sec_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("sec_lbl",[],xml_list_lbl) in
		match xml_hdr_opt with
		|None -> XML (List.concat [acc_list;[Xml.Element ("sec",(attr_of_tag_or_id a.fld_sec_tag_or_id),[xml_lbl;xml_main])]])
		|Some xml_hdr -> XML (List.concat [acc_list;[Xml.Element ("sec",(attr_of_tag_or_id a.fld_sec_tag_or_id),[xml_lbl;xml_hdr;xml_main])]])

and acc_of_par (path : t_path) (acc : t_acc) (a : tr_par) : t_acc =
	match acc with
	|CREF_TABLE table -> (
		let newacc : t_acc = CREF_TABLE (
			match a.fld_par_tag_or_id with
			|Some (Ce_tag_or_id_id (id : tr_id)) -> (id, path) :: table
			|_ -> table
		)
		in acc_of_blks path newacc a.fld_par_main
	)
	|LINES acc_lines -> (
		match a.fld_par_hdr, acc_of_par_main path (LINES []) a.fld_par_main with
		|None, LINES (hd::tl) -> LINES (List.concat [acc_lines;[insert_mark path hd];tl])
		|Some (hdr : ts_hdr), LINES lines_main -> LINES (List.concat [acc_lines;lines_of_ts_hdr path hdr;[""];lines_main])
		|None, LINES [] -> raise (Error "ch_main cannot be empty")
		|_,_ -> raise (Error "accumulator output type not identical to accumulator input type")
	)
	|XML acc_list -> (
		let xml_list_main:Xml.xml list= (
			match acc_of_par_main path (XML []) a.fld_par_main with
			|XML xml_list -> xml_list
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in
		let xml_hdr_opt:Xml.xml option= (
			match a.fld_par_hdr with
			|None -> None
			|Some (hdr : ts_hdr) -> 
				match hdr with
				|Cs_hdr (t:ts_txt_units) -> Some (Xml.Element ("par_hdr",[],xml_list_of_ts_txt_units path t))
		)
		in 
		let xml_list_lbl:Xml.xml list = (
			match path with 
			|hd::tl -> (
				match string_of_node tl hd with
				|Some (s:string) -> [Xml.PCData s]
				|None -> []
			)
			|[] -> raise (Error "path to par cannot be empty")
		)
		in
		let xml_main:Xml.xml = Xml.Element ("par_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("par_lbl",[],xml_list_lbl) in
		match xml_hdr_opt with
		|None -> XML (List.concat [acc_list;[Xml.Element ("par",(attr_of_tag_or_id a.fld_par_tag_or_id),[xml_lbl;xml_main])]])
		|Some xml_hdr -> XML (List.concat [acc_list;[Xml.Element ("par",(attr_of_tag_or_id a.fld_par_tag_or_id),[xml_lbl;xml_hdr;xml_main])]])
	)

and acc_of_ch_main (path : t_path) (acc : t_acc) (a : te_secs_pars_or_blks) : t_acc =
	match a with
	| Ce_secs_pars_or_blks_secs (b : ts_secs) -> acc_of_secs path acc b
	| Ce_secs_pars_or_blks_pars (b : ts_pars) -> acc_of_pars path acc b
	| Ce_secs_pars_or_blks_blks (b : ts_blks) -> acc_of_blks path acc b

and acc_of_sec_main (path : t_path) (acc : t_acc) (a : te_pars_or_blks) : t_acc =
	match a with
	| Ce_pars_or_blks_pars (b : ts_pars) -> acc_of_pars path acc b
	| Ce_pars_or_blks_blks (b : ts_blks) -> acc_of_blks path acc b

and acc_of_par_main (path : t_path) (acc : t_acc) (a : ts_blks) : t_acc =
	acc_of_blks path acc a

and acc_of_blk (auto_nr : int) (path : t_path) (acc : t_acc) (a : te_blk) : t_acc * int =
	match a with
	| Ce_blk_itm (b : tr_blk_itm) ->
		let node : t_node = node_of_blk_itm auto_nr b in
		let next_auto_nr =
			match b.fld_blk_itm_lbl with 
			|Ce_lbl_auto Cs_lbl_auto -> auto_nr + 1 
			| _ -> auto_nr
		in 
		(acc_of_blk_itm (node :: path) acc b, next_auto_nr)
	| Ce_blk_dsp (b : ts_blk_dsp) ->
		let node : t_node = DSP_NODE in
		acc_of_blk_dsp auto_nr (node :: path) acc b
	| Ce_blk_txt (b : ts_blk_txt) -> (acc_of_blk_txt path acc b, auto_nr)
	| Ce_blk_blt (b : ts_blk_blt) ->
		let node : t_node = BLT_NODE in
		(acc_of_blk_blt (node :: path) acc b, auto_nr)

and acc_of_blk_txt (path : t_path) (acc : t_acc) (a : ts_blk_txt) : t_acc =
	match a with Cs_blk_txt (b:ts_txt_units) ->
		match acc with
		| CREF_TABLE _ -> acc
		| LINES acc -> LINES (List.concat [ acc; lines_of_ts_txt_units path b; [""] ])
		| XML acc_list -> XML (List.concat [acc_list;[Xml.Element ("blk_txt",[],xml_list_of_ts_txt_units path b)]])

and acc_of_blk_itm (path : t_path) (acc : t_acc) (a : tr_blk_itm) : t_acc =
	match acc with
	| CREF_TABLE table ->
		let newacc : t_acc = CREF_TABLE (
			match a.fld_blk_itm_id with
			| Some (id : tr_id) -> (id, path) :: table
			| _ -> table
		)
		in acc_of_blks path newacc a.fld_blk_itm_main
	| LINES acc_lines -> (
		match acc_of_blks path (LINES []) a.fld_blk_itm_main with
		| LINES (lines : string list) -> (
			let head : string = List.hd lines in
			let newhead : string = insert_mark path head in
			let newlines : string list = newhead :: List.tl lines in
			LINES (List.concat [ acc_lines; newlines ])
		)
		| _ -> raise (Error "accumulator output type not identical to accumulator input type")

	)
	| XML acc_list ->
		let xml_list_main = (
			match acc_of_blks path (XML []) a.fld_blk_itm_main with
			|XML xml_list_blks -> xml_list_blks
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in 
		let xml_list_lbl:Xml.xml list = (
			match path with 
			|hd::tl -> (
				match string_of_node tl hd with
				|Some (s:string) -> [Xml.PCData s]
				|None -> []
			)
			|[] -> raise (Error "path to blk_itm cannot be empty")

		)
		in
		let xml_main:Xml.xml = Xml.Element ("blk_itm_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("blk_itm_lbl",[],xml_list_lbl) in
		XML (List.concat [acc_list;[Xml.Element ("blk_itm",(attr_of_tr_id a.fld_blk_itm_id),[xml_lbl;xml_main])]])


and acc_of_blk_blt (path : t_path) (acc : t_acc) (a : ts_blk_blt) : t_acc =
	match a with Cs_blk_blt (b:ts_blks) ->
	match acc with
	| CREF_TABLE _ -> acc_of_blks path acc b
	| LINES acc_lines -> (
		match acc_of_blks path (LINES []) b with
		| LINES (lines : string list) -> (
			let head : string = List.hd lines in
			let newhead : string = insert_mark path head in
			let newlines : string list = newhead :: List.tl lines in
			LINES (List.concat [ acc_lines; newlines; ])
		)
		| _ -> raise (Error "accumulator output type not identical to accumulator input type")

	)
	| XML acc_list ->
		let xml_list_main:Xml.xml list = (
			match acc_of_blks path (XML []) b with
			|XML xml_list_blks -> xml_list_blks
			| _ -> raise (Error "accumulator output type not identical to accumulator input type")
		)
		in 
		let xml_list_lbl:Xml.xml list = (
			match path with 
			|hd::tl -> (
				match string_of_node tl hd with
				|Some (s:string) -> [Xml.PCData s]
				|None -> []
			)
			|[] -> raise (Error "path to blk_blt cannot be empty")

		)
		in
		let xml_main:Xml.xml = Xml.Element ("blk_blt_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("blk_blt_lbl",[],xml_list_lbl) in
		XML (List.concat [acc_list;[Xml.Element ("blk_blt",[],[xml_lbl;xml_main])]])

and acc_of_blk_dsp (auto_nr : int) (path : t_path) (acc : t_acc) (a : ts_blk_dsp) : t_acc * int =
	match a with Cs_blk_dsp (b:ts_dsp_lines) ->
	match b with Cs_dsp_lines (c:tr_dsp_line list) ->
	let rec aux (auto_nr : int) (acc : t_acc) (c : tr_dsp_line list) : t_acc * int = (
		match c with
		| [] -> (acc, auto_nr)
		| hd :: tl ->
			let node : t_node = node_of_dsp_line auto_nr hd in
			let next_auto_nr =
				match hd.fld_dsp_line_lbl with 
				| Some (Ce_lbl_auto Cs_lbl_auto) -> auto_nr + 1 
				| _ -> auto_nr
			in
			aux next_auto_nr (acc_of_dsp_line (node :: path) auto_nr acc hd) tl
	)
	in
	match acc with
	|LINES acc_lines -> (
		match aux auto_nr (LINES []) c with 
		| (LINES lines,nr) -> 
			(LINES (List.concat [acc_lines;lines;[""]]),nr)
		| _ -> raise (Error "accumulator output type not identical to accumulator input type")

	)
	|XML acc_list -> (
		match aux auto_nr (XML []) c with 
		|(XML xml_list,nr) -> 
			(XML (List.concat [acc_list;[Xml.Element ("blk_dsp",[],xml_list)]]),nr)
		| _ -> raise (Error "accumulator output type not identical to accumulator input type")

	)
	|_ -> aux auto_nr acc c

and acc_of_dsp_line (path : t_path) (auto_nr : int) (acc : t_acc) (a : tr_dsp_line) : t_acc =
	match acc with
	| CREF_TABLE table -> (
		match a.fld_dsp_line_id with
			| Some (id : tr_id) -> CREF_TABLE ((id, path) :: table)
			| None -> CREF_TABLE table
	)
	| LINES acc_lines -> (
		match a.fld_dsp_line_lbl, lines_of_ts_txt_units path a.fld_dsp_line_units with
		|Some _, hd::tl -> LINES (List.concat [acc_lines;[insert_mark path hd];tl])
		|None, lines -> LINES (List.concat [acc_lines;lines])
		|_,[] -> raise (Error "dps_line cannot be empty")
	)
	| XML acc_list -> (
		let xml_list_main:Xml.xml list = xml_list_of_dsp_line_units path a.fld_dsp_line_units in 
		let xml_list_lbl:Xml.xml list = (
			match a.fld_dsp_line_lbl with
			|None -> []
			|Some _ -> 
				match path with 
				|hd::tl -> (
					match string_of_node tl hd with
					|Some (s:string) -> [Xml.PCData s]
					|None -> []
				)
				|[] -> raise (Error "path to dsp_line cannot be empty")
		)
		in
		let xml_main:Xml.xml = Xml.Element ("dsp_line_main",[],xml_list_main) in
		let xml_lbl:Xml.xml = Xml.Element ("dsp_line_lbl",[],xml_list_lbl) in
		match a.fld_dsp_line_lbl with
		|None -> XML (List.concat [acc_list;[Xml.Element ("dsp_line",(attr_of_tr_id a.fld_dsp_line_id),[xml_main])]])
		|Some _ -> XML (List.concat [acc_list;[Xml.Element ("dsp_line",(attr_of_tr_id a.fld_dsp_line_id),[xml_lbl;xml_main])]])
	)


