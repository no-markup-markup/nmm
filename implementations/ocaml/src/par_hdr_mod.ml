open Doc_types

let special_tag (a : tu_tag_or_id option) : tu_txt_unit option =
	match a with
	|None -> None
	|Some (b : tu_tag_or_id) ->
		match b with
		|Cu_tag_or_id_tag (tag : ts_tag) 
		|Cu_tag_or_id_id { fld_id_tag = (tag : ts_tag); fld_id_name = _ } ->
			match Common_utils.doc_settings.expand_tag tag with
			| Some (s: string) -> Some (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg s))
			| None -> None

let copy_hdr_to_main_and_lbl_to_hdr (path : Common_utils.t_path) (par : tr_par): tr_par = 
	let space : tu_txt_unit =  Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " ") in
	let lpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg "(") in
	let rpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg ")") in
	let label : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg (Common_utils.label_of_path path)) in
	match special_tag par.fld_par_tag_or_id, par.fld_par_hdr, par.fld_par_main with
	|	Some (s : tu_txt_unit),
		Some (Cs_hdr (Cs_txt_units (h : tu_txt_unit list))), 
		Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units (t : tu_txt_unit list)))::tl) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = Some (Cs_hdr (Cs_txt_units (List.concat [[label;space;s;space;lpar];h;[rpar]])));
			fld_par_main = Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;lpar];h;[rpar;space;space];t])))::tl)
		}
	|	None,
		Some (Cs_hdr (Cs_txt_units (h : tu_txt_unit list))), 
		Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units (t : tu_txt_unit list)))::tl) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = Some (Cs_hdr (Cs_txt_units (List.concat [[label;space];h])));
			fld_par_main = Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [h;[space;space];t])))::tl)
		}
	|	None,
		None,
		_ ->
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = Some (Cs_hdr (Cs_txt_units [label]));
			fld_par_main = par.fld_par_main
		}
	
	|	Some (s : tu_txt_unit),
		None,
		Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units (t : tu_txt_unit list)))::tl) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = Some (Cs_hdr (Cs_txt_units [label;space;s]));
			fld_par_main = Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;space];t])))::tl)
		}
	|	Some (s : tu_txt_unit),
		Some (Cs_hdr (Cs_txt_units (h : tu_txt_unit list))), 
		Cs_blks (blks : tu_blk list) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = Some (Cs_hdr (Cs_txt_units (List.concat [[label;space;s;space;lpar];h;[rpar]])));
			fld_par_main = Cs_blks ((Cu_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;lpar];h;[rpar]]))))::blks)
		}
	|	None,
		Some (Cs_hdr (Cs_txt_units (h : tu_txt_unit list))), 
		Cs_blks (blks : tu_blk list) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = Some (Cs_hdr (Cs_txt_units (List.concat [[label;space];h])));
			fld_par_main = Cs_blks ((Cu_blk_txt (Cs_blk_txt (Cs_txt_units h)))::blks)
		}
	|	Some (s : tu_txt_unit),
		None,
		Cs_blks (blks : tu_blk list) -> 
		{
			fld_par_tag_or_id = par.fld_par_tag_or_id;
			fld_par_hdr = Some (Cs_hdr (Cs_txt_units [label;space;s]));
			fld_par_main = Cs_blks ((Cu_blk_txt (Cs_blk_txt (Cs_txt_units [s])))::blks)
		}

