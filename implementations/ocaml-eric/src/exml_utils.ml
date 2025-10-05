open Doc_types
open Cref_utils

let rec xml_of_ts_title (title:ts_title):Xml.xml=
	match title with
	|Cs_title (s:string) -> Xml.Element ("title",[],[Xml.PCData s])

let rec xml_of_ts_author (author:ts_author):Xml.xml=
	match author with
	|Cs_author (s:string) -> Xml.Element ("author",[],[Xml.PCData s])


and xml_list_of_ts_txt_units (path:t_path) (a:ts_txt_units):Xml.xml list=
	match a with
	|Cs_txt_units (b:te_txt_unit list) -> List.map (xml_of_txt_unit path) b

and xml_list_of_dsp_line_units (path:t_path) (a:ts_txt_units):Xml.xml list=
	match a with
	|Cs_txt_units (b:te_txt_unit list) -> List.map (xml_of_dsp_line_unit path) b

and xml_of_txt_unit (path:t_path) (a:te_txt_unit):Xml.xml=
	match a with
	|Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg (s:string)) -> Xml.Element ("txt_unit_norm",[],[Xml.PCData s])
	|Ce_txt_unit_emph (Cs_txt_unit_emph (s:string)) -> Xml.Element ("txt_unit_emph",[],[Xml.PCData s])
	|Ce_txt_unit_c_ref (Cs_txt_unit_c_ref (c:ts_c_ref)) -> Xml.Element ("txt_unit_c_ref",(attr_of_ts_c_ref c),[Xml.PCData (string_of_ts_c_ref path c)])

and xml_of_dsp_line_unit (path:t_path) (a:te_txt_unit):Xml.xml=
	match a with
	|Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg (s:string)) -> Xml.Element ("txt_unit_norm_dsp",[],[Xml.PCData s])
	|Ce_txt_unit_emph (Cs_txt_unit_emph (s:string)) -> Xml.Element ("txt_unit_emph_dsp",[],[Xml.PCData s])
	|Ce_txt_unit_c_ref (Cs_txt_unit_c_ref (c:ts_c_ref)) -> Xml.Element ("txt_unit_c_ref_dsp",(attr_of_ts_c_ref c),[Xml.PCData (string_of_ts_c_ref path c)])

and attr_of_ts_c_ref (a:ts_c_ref):(string*string) list=
	match a with Cs_c_ref (id:tr_id) -> [("href","#" ^ (string_of_tr_id id))]

and attr_of_tag_or_id (a:te_tag_or_id option):(string*string) list=
	match a with
	|None -> []
	|Some (tag_or_id:te_tag_or_id) -> 
		match tag_or_id with
		|Ce_tag_or_id_tag tag -> attr_of_ts_tag tag
		|Ce_tag_or_id_id id -> attr_of_tr_id (Some id)

and attr_of_ts_tag (tag:ts_tag):(string*string) list=
	match tag with
	|Cs_tag (s:string) -> [("tag",s)]

and attr_of_tr_id (id_opt:tr_id option):(string*string) list=
	match id_opt with
	|None -> []
	|Some id -> ("id",string_of_tr_id id)::(attr_of_ts_tag id.fld_id_tag)

and string_of_tr_id (id:tr_id):string=
	match id.fld_id_tag with
	|Cs_tag tag_string ->
		match id.fld_id_name with
		|Cs_name name_string -> (tag_string ^ ":" ^ name_string)


