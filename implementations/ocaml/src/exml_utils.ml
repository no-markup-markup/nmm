open Doc_types
open Cref_utils

let rec xml_of_ts_title (title : Doc_types.ts_title) : Xml.xml =
	match title with
	| Cs_title (s : string) -> Xml.Element ("title", [], [Xml.PCData (pcdata_of_string s)])

and xml_of_ts_author (author : Doc_types.ts_author) : Xml.xml =
	match author with
	| Cs_author (s : string) -> Xml.Element ("author", [], [Xml.PCData (pcdata_of_string s)])


and xml_list_of_ts_txt_units (path : Cref_utils.t_path) (a : Doc_types.ts_txt_units) : Xml.xml list =
	match a with
	| Cs_txt_units (b : Doc_types.te_txt_unit list) -> List.map (xml_of_te_txt_unit path) b

and xml_of_te_txt_unit (path : Cref_utils.t_path) (a : Doc_types.te_txt_unit) : Xml.xml =
	match a with
	| Ce_txt_unit_wysiwyg (b: ts_txt_unit_wysiwyg) -> xml_of_ts_txt_unit_wysiwug b
	| Ce_txt_unit_emph (b : ts_txt_unit_emph) -> xml_of_ts_txt_unit_emph b
	| Ce_txt_unit_c_ref (b : ts_txt_unit_c_ref) -> xml_of_ts_txt_unit_c_ref path b 

and xml_of_ts_txt_unit_wysiwug (a : ts_txt_unit_wysiwyg) : Xml.xml =
	match a with Cs_txt_unit_wysiwyg (b : string) -> Xml.Element ("txt_unit_wysiwyg", [], [Xml.PCData (pcdata_of_string b)])

and xml_of_ts_txt_unit_emph (a : ts_txt_unit_emph) : Xml.xml =
	match a with Cs_txt_unit_emph (b : string) -> Xml.Element ("txt_unit_emph", [], [Xml.PCData (pcdata_of_string b)])

and xml_of_ts_txt_unit_c_ref (path : Cref_utils.t_path) (a : ts_txt_unit_c_ref) : Xml.xml =
	match a with Cs_txt_unit_c_ref (b : ts_c_ref) -> Xml.Element ("txt_unit_c_ref", attr_list_of_ts_c_ref b, [xml_of_ts_c_ref path b])

and xml_of_ts_c_ref (path : Cref_utils.t_path) (a : ts_c_ref) : Xml.xml =
	Xml.PCData (pcdata_of_string (Cref_utils.string_of_ts_c_ref path a))

and attr_list_of_ts_c_ref (a : Doc_types.ts_c_ref) : (string*string) list =
	match a with Cs_c_ref (id : Doc_types.tr_id) -> [("href","#" ^ (string_of_tr_id id))]

and attr_list_of_tag_or_id (a : Doc_types.te_tag_or_id option) : (string*string) list=
	match a with
	| None -> []
	| Some (tag_or_id : Doc_types.te_tag_or_id) -> 
		match tag_or_id with
		| Ce_tag_or_id_tag (tag : Doc_types.ts_tag) -> attr_list_of_ts_tag tag
		| Ce_tag_or_id_id (id : Doc_types.tr_id)-> attr_list_of_tr_id (Some id)

and attr_list_of_ts_tag (tag : Doc_types.ts_tag) : (string*string) list =
	match tag with
	| Cs_tag (s : string) -> [("tag",s)]

and attr_list_of_tr_id (id_opt : Doc_types.tr_id option) : (string*string) list =
	match id_opt with
	| None -> []
	| Some id -> ("id", string_of_tr_id id)::(attr_list_of_ts_tag id.fld_id_tag)

and string_of_tr_id (id : Doc_types.tr_id) : string =
	match id.fld_id_tag with
	|Cs_tag (tag_string : string) ->
		match id.fld_id_name with
		|Cs_name (name_string : string) -> (tag_string ^ ":" ^ name_string)



and pcdata_of_string (s: string): string = 
	let s_amp = Str.global_replace (Str.regexp "&") "&amp;" s in
	let s_lt = Str.global_replace (Str.regexp "<") "&lt;" s_amp in
	let s_gt = Str.global_replace (Str.regexp ">") "&gt;" s_lt in
	let s_apos = Str.global_replace (Str.regexp "\'") "&apos;" s_gt in
	let s_quot = Str.global_replace (Str.regexp "\"") "&quot;" s_apos in
	s_quot

and string_of_pcdata (s : string): string =
	let s_amp = Str.global_replace (Str.regexp "&amp;") "&" s in
	let s_lt = Str.global_replace (Str.regexp "&lt;") "<" s_amp in
	let s_gt = Str.global_replace (Str.regexp "&gt;") ">" s_lt in
	let s_apos = Str.global_replace (Str.regexp "&apos;") "\'" s_gt in
	let s_quot = Str.global_replace (Str.regexp "&quot;") "\"" s_apos in
	s_quot

and string_of_predefined_entity (s : string) : string=
	match s with
	| "&lt;" -> "<"
	| "&gt;" -> ">"
	| "&amp;" -> "&"
	| "&apos;" -> "\'"
	| "&quot;" -> "\""
	| _ -> s

and predefined_entity_of_string (s : string) : string =
	match s with
	| "<" -> "&lt;" 
	| ">" -> "&gt;" 
	| "&" -> "&amp;"
	| "\'" -> "&apos;"
	| "\"" -> "&quot;"
	| _ -> s

