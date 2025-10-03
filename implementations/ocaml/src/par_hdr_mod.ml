open Doc_types

let expand (s : string) : string option =
	match s with
	|"DEF" -> Some "DEFINITION"
	|"PRF" -> Some "PROOF"
	|"FCT" -> Some "FACT"
	|"LMA" -> Some "LEMMA"
	|"THM" -> Some "THEOREM"
	| _  -> None

let space : te_txt_unit =  Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " ")
let lpar : te_txt_unit = Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg "(")
let rpar : te_txt_unit = Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg ")")

let special_tag (a : te_tag_or_id option) : te_txt_unit option =
	match a with
	|None -> None
	|Some (b : te_tag_or_id) ->
		match b with
		|Ce_tag_or_id_tag (Cs_tag s) 
		|Ce_tag_or_id_id { fld_id_tag = Cs_tag s; fld_id_name = _ } ->
			match expand s with
			| Some (t: string) -> Some (Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg t))
			| None -> None

let copy_hdr_to_main (par : tr_par): tr_par = 
	match special_tag par.fld_par_tag_or_id, par.fld_par_hdr, par.fld_par_main with
	|	Some (s : te_txt_unit),
		Some (Cs_hdr (Cs_txt_units (h : te_txt_unit list))), 
		Cs_blks (Ce_blk_txt (Cs_blk_txt (Cs_txt_units (t : te_txt_unit list)))::tl) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = par.fld_par_hdr;
			fld_par_main = Cs_blks (Ce_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;lpar];h;[rpar;space;space];t])))::tl)
		}
	|	None,
		Some (Cs_hdr (Cs_txt_units (h : te_txt_unit list))), 
		Cs_blks (Ce_blk_txt (Cs_blk_txt (Cs_txt_units (t : te_txt_unit list)))::tl) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = par.fld_par_hdr;
			fld_par_main = Cs_blks (Ce_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [h;[space;space];t])))::tl)
		}
	|	None,
		None,
		_ -> par
	
	|	Some (s : te_txt_unit),
		None,
		Cs_blks (Ce_blk_txt (Cs_blk_txt (Cs_txt_units (t : te_txt_unit list)))::tl) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = par.fld_par_hdr;
			fld_par_main = Cs_blks (Ce_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;space];t])))::tl)
		}
	|	Some (s : te_txt_unit),
		Some (Cs_hdr (Cs_txt_units (h : te_txt_unit list))), 
		Cs_blks (blks : te_blk list) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = par.fld_par_hdr;
			fld_par_main = Cs_blks ((Ce_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;lpar];h;[rpar]]))))::blks)
		}
	|	None,
		Some (Cs_hdr (Cs_txt_units (h : te_txt_unit list))), 
		Cs_blks (blks : te_blk list) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = par.fld_par_hdr;
			fld_par_main = Cs_blks ((Ce_blk_txt (Cs_blk_txt (Cs_txt_units h)))::blks)
		}
	|	Some (s : te_txt_unit),
		None,
		Cs_blks (blks : te_blk list) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = par.fld_par_hdr;
			fld_par_main = Cs_blks ((Ce_blk_txt (Cs_blk_txt (Cs_txt_units [s])))::blks)
		}

