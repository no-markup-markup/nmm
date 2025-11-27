open Doc_types
open Common_utils

let special_tag (a : tu_tag_or_id option) : tu_txt_unit option =
	match a with
	|None -> None
	|Some (b : tu_tag_or_id) ->
		match b with
		|Cu_tag_or_id_tag (tag : ts_tag) 
		|Cu_tag_or_id_id { fld_id_tag = (tag : ts_tag); fld_id_name = _ } ->
			match doc_settings.expand_tag_singular tag with
			| Some (singular: string) -> Some (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg singular))
			| None ->
				match doc_settings.expand_tag_plural tag with
				|Some (_,plural) -> Some (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg plural))
				|None -> None

let copy_hdr_to_main (par : tr_par_std): tr_par_std = 
	let space : tu_txt_unit =  Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " ") in
	let lpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg "(") in
	let rpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg ")") in
	match special_tag par.fld_par_tag_or_id, par.fld_par_hdr, par.fld_par_main with
	| Some (s : tu_txt_unit),
	  Some (Cs_hdr (Cs_txt_units (h : tu_txt_unit list))), 
	  Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units (t : tu_txt_unit list)))::tl) -> {
		fld_par_tag_or_id = par.fld_par_tag_or_id;
		fld_par_hdr = par.fld_par_hdr;
		fld_par_main = Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;lpar];h;[rpar;space;space];t])))::tl)
	  }
	| None,
	  Some (Cs_hdr (Cs_txt_units (h : tu_txt_unit list))), 
	  Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units (t : tu_txt_unit list)))::tl) -> {
		fld_par_tag_or_id = par.fld_par_tag_or_id;
		fld_par_hdr = par.fld_par_hdr;
		fld_par_main = Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [h;[space;space];t])))::tl)
	  }
	| None,
	  None,
	  _ -> {
		fld_par_tag_or_id = par.fld_par_tag_or_id;
		fld_par_hdr = par.fld_par_hdr;
		fld_par_main = par.fld_par_main
	  }
	| Some (s : tu_txt_unit),
	  None,
	  Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units (t : tu_txt_unit list)))::tl) -> {
		fld_par_tag_or_id = par.fld_par_tag_or_id;
		fld_par_hdr = par.fld_par_hdr;
		fld_par_main = Cs_blks (Cu_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;space];t])))::tl)
	  }
	| Some (s : tu_txt_unit),
	  Some (Cs_hdr (Cs_txt_units (h : tu_txt_unit list))), 
	  Cs_blks (blks : tu_blk list) -> {
		fld_par_tag_or_id = par.fld_par_tag_or_id;
		fld_par_hdr = par.fld_par_hdr;
		fld_par_main = Cs_blks ((Cu_blk_txt (Cs_blk_txt (Cs_txt_units ( List.concat [[s;space;lpar];h;[rpar]]))))::blks)
	  }
	| None,
	  Some (Cs_hdr (Cs_txt_units (h : tu_txt_unit list))), 
	  Cs_blks (blks : tu_blk list) -> {
		fld_par_tag_or_id = par.fld_par_tag_or_id;
		fld_par_hdr = par.fld_par_hdr;
		fld_par_main = Cs_blks ((Cu_blk_txt (Cs_blk_txt (Cs_txt_units h)))::blks)
	  }
	| Some (s : tu_txt_unit),
	  None,
	  Cs_blks (blks : tu_blk list) -> {
		fld_par_tag_or_id = par.fld_par_tag_or_id;
		fld_par_hdr = par.fld_par_hdr;
		fld_par_main = Cs_blks ((Cu_blk_txt (Cs_blk_txt (Cs_txt_units [s])))::blks)
	  }

let put_c_ref_in_hdr_and_remove_id (par : Doc_types.tr_par_std) : Doc_types.tr_par_std =
	par
