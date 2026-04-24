
open Doc_types

(* expander *)

let expand_tag_default (tag : Doc_types.ts_tag) : (string * string) option =
match tag with
| Cs_tag "ABBR" -> Some ("ABBREVIATION", "Abbreviation")
| Cs_tag "ASM" -> Some ("ASSUMPTION", "Assumption")
| Cs_tag "CONJ" -> Some ("CONJECTURE", "Conjecture")
| Cs_tag "CONV" -> Some ("CONVENTION", "Convention")
| Cs_tag "COR" -> Some ("COROLLARY", "Corollary")
| Cs_tag "DEF" -> Some ("DEFINITION", "Definition")
| Cs_tag "EX" -> Some ("EXAMPLE", "Example")
| Cs_tag "FCT" -> Some ("FACT", "Fact")
| Cs_tag "LMA" -> Some ("LEMMA", "Lemma")
| Cs_tag "NTN" -> Some ("NOTATION", "Notation")
| Cs_tag "PRF" -> Some ("PROOF", "Proof")
| Cs_tag "PRP" -> Some ("PROPOSITION", "Proposition")
| Cs_tag "QTN" -> Some ("QUOTATION", "Quotation")
| Cs_tag "RMK" -> Some ("REMARK", "Remark")
| Cs_tag "SLN" -> Some ("SOLUTION", "Solution")
| Cs_tag "THM" -> Some ("THEOREM", "Theorem")
| Cs_tag "TMY" -> Some ("TERMINOLOGY", "Terminology")
| Cs_tag "ABBRS" -> Some ("ABBBREVIATIONS", "Abbbreviations")
| Cs_tag "ASMS" -> Some ("ASSUMPTIONS", "Assumptions")
| Cs_tag "CONJS" -> Some ("CONJECTURES", "Conjectures")
| Cs_tag "CONVS" -> Some ("CONVENTIONS", "Conventions")
| Cs_tag "CORS" -> Some ("COROLLARIES", "Corollaries")
| Cs_tag "DEFS" -> Some ("DEFINITIONS", "Definitions")
| Cs_tag "EXS" -> Some ("EXAMPLES", "Examples")
| Cs_tag "FCTS" -> Some ("FACTS", "Facts")
| Cs_tag "LMAS" -> Some ("LEMMAS", "Lemmas")
| Cs_tag "NTNS" -> Some ("NOTATIONS", "Notations")
| Cs_tag "PRFS" -> Some ("PROOFS", "Proofs")
| Cs_tag "PRPS" -> Some ("PROPOSITIONS", "Propositions")
| Cs_tag "QTNS" -> Some ("QUOTATIONS", "Quotations")
| Cs_tag "RMKS" -> Some ("REMARKS", "Remarks")
| Cs_tag "SLNS" -> Some ("SOLUTIONS", "Solutions")
| Cs_tag "THMS" -> Some ("THEOREMS", "Theorems")
| Cs_tag "PAR"
| Cs_tag "ITM"
| Cs_tag "DSP"
| Cs_tag "BIB" -> None
| Cs_tag tag_string -> let _ : unit = IO.print_warning ("WARNING: undefined tag: " ^ tag_string) in None

let standard_tags : Doc_types.ts_tag list = [Cs_tag "PAR"; Cs_tag "ITM"; Cs_tag "DSP"; Cs_tag "BIB"]

let expander_of_file (path : string) : Doc_types.ts_tag -> (string * string) option = (* TODO *)
	let file_string = IO.string_of_file path in
	let lines = String.split_on_char '\n' file_string in
	let rec collect_tags_singular (line_list : string list) (acc : (string*string*string) list) =
		match line_list with
		|[] -> acc
		|hd::tl -> 
			match String.split_on_char '\t' hd with
			|""::_ -> collect_tags_singular tl acc
			|singular::(_::(exp_ref::(exp_lbl::_))) -> collect_tags_singular tl ((singular, exp_lbl, exp_ref)::acc)
			|_ -> collect_tags_singular tl acc
	in
	let tag_list_singular : (string * string * string) list = collect_tags_singular lines [] in
	let rec collect_tags_plural (line_list : string list) (acc : (string*string*string) list) =
		match line_list with
		|[] -> acc
		|hd::tl -> 
			match String.split_on_char '\t' hd with
			|_::(""::_) -> collect_tags_plural tl acc
			|_::(plural::(_::(_::(exp_ref::(exp_lbl::_))))) -> collect_tags_plural tl ((plural, exp_lbl, exp_ref)::acc)
			|_ -> collect_tags_plural tl acc
	in
	let tag_list : (string * string * string) list = collect_tags_plural lines tag_list_singular in
	let rec match_tag_rec (tag_string : string) (lst : (string * string * string) list) : (string * string) option =
		match lst with
		|[] -> let _ : unit = IO.print_warning ("WARNING: undefined tag: " ^ tag_string) in None
		|(tag,exp_lbl,exp_ref)::tl ->
			if tag=tag_string then Some (exp_lbl, exp_ref) else match_tag_rec tag_string tl
	in
	let expand_tag (tag : Doc_types.ts_tag) : (string * string) option =
		if List.mem tag standard_tags then None else
		match tag with
		|Cs_tag tag_string -> match_tag_rec tag_string tag_list
	in expand_tag

(* tagger *)

let tag_of_string_default (s : string) : ts_tag option =
match s with
| "ABBR" | "ABBRS" 
| "ASM" | "ASMS" 
| "CONJ" | "CONJS" 
| "CONV" | "CONVS" 
| "COR" | "CORS" 
| "DEF" | "DEFS" 
| "EX" | "EXS" 
| "FCT" | "FCTS" 
| "LMA" | "LMAS" 
| "NTN" | "NTNS" 
| "PRF" | "PRFS" 
| "PRP" | "PRPS" 
| "QTN" | "QTNS" 
| "RMK" | "RMKS" 
| "SLN" | "SLNS" 
| "THM" | "THMS" 
| "TMY" 
| "ITM"
| "BIB" -> Some (Cs_tag s)
| _ -> None

let tag_blk_itm_gen (tag_of_string : string -> ts_tag option) (blk_itm : Doc_types.tr_blk_itm) : Doc_types.tr_blk_itm =
	match blk_itm.fld_blk_itm_tag_or_id with
	|Some _ -> blk_itm
	|None ->
		match blk_itm.fld_blk_itm_main with
		|Cs_blks (blk_list : tu_blk list) ->
			match blk_list with
			|[] -> blk_itm
			|blk_list_hd::blk_list_tl ->
				match blk_list_hd with
				|Cu_blk_txt blk_txt -> (
					match blk_txt with
					|Cs_blk_txt txt_units ->
						match txt_units with
						|Cs_txt_units txt_unit_list ->
							match txt_unit_list with
							|tag_unit::(space_unit::(txt_unit_list_tl)) -> (
								match tag_unit, space_unit with
								|Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg tag_string),
								 Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " ") -> (
									match tag_of_string tag_string with
									|None -> blk_itm
									|Some tag -> {
										fld_blk_itm_lbl = blk_itm.fld_blk_itm_lbl;
										fld_blk_itm_tag_or_id = Some (Cu_tag_or_id_tag tag);
										fld_blk_itm_main = Cs_blks (
											(Cu_blk_txt (
												Cs_blk_txt (
													Cs_txt_units txt_unit_list_tl)))::blk_list_tl
										)
									}
								)
								|_,_ -> blk_itm
							)
							|tag::[] -> (
								match tag, blk_list_tl with
								|Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg tag_string), _::_ -> (
									match tag_of_string tag_string with
									|None -> blk_itm
									|Some tag -> {
										fld_blk_itm_lbl = blk_itm.fld_blk_itm_lbl;
										fld_blk_itm_tag_or_id = Some (Cu_tag_or_id_tag tag);
										fld_blk_itm_main = Cs_blks blk_list_tl;
									}
								)
								|_,_ -> blk_itm
							)
							|_ -> blk_itm
				)
				|_ -> blk_itm

let tag_blk_itm_default (blk_itm : tr_blk_itm) : tr_blk_itm =
	tag_blk_itm_gen tag_of_string_default blk_itm

let standard_blk_itm_tags : string list = ["ITM";"BIB"]

let tagger_of_file (path : string) : tr_blk_itm -> tr_blk_itm =
	let file_string = IO.string_of_file path in
	let lines = String.split_on_char '\n' file_string in
	let rec collect_tags (line_list : string list) (acc : string list) =
		match line_list with
		|[] -> acc
		|hd::tl -> 
			match String.split_on_char '\t' hd with
			|""::(""::_) -> collect_tags tl acc
			|singular::(""::_) -> collect_tags tl (singular::acc)
			|""::(plural::_) -> collect_tags tl (plural::acc)
			|singular::(plural::_) -> collect_tags tl (singular::(plural::acc))
			|""::[] -> collect_tags tl acc
			|singular::[] -> collect_tags tl (singular::acc)
			|[] -> collect_tags tl acc
	in
	let tag_list : string list = collect_tags lines standard_blk_itm_tags in
	let tag_of_string (s : string) : ts_tag option =
		if List.mem s tag_list then Some (Cs_tag s) else None
	in tag_blk_itm_gen tag_of_string


let tagger_of_path_opt (path_opt : string option) : tr_blk_itm -> tr_blk_itm =
	match path_opt with
	|None -> tag_blk_itm_default
	|Some path -> tagger_of_file path
