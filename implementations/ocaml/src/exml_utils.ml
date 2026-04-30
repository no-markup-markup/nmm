open Doc_types
open Common_utils

let pcdata_of_string (s: string): string = 
        let s_amp = Str.global_replace (Str.regexp "&") "&amp;" s in
        let s_lt = Str.global_replace (Str.regexp "<") "&lt;" s_amp in
        let s_gt = Str.global_replace (Str.regexp ">") "&gt;" s_lt in
        let s_apos = Str.global_replace (Str.regexp "\'") "&apos;" s_gt in
        let s_quot = Str.global_replace (Str.regexp "\"") "&quot;" s_apos in
        s_quot

let string_of_pcdata (s : string): string =
        let s_amp = Str.global_replace (Str.regexp "&amp;") "&" s in
        let s_lt = Str.global_replace (Str.regexp "&lt;") "<" s_amp in
        let s_gt = Str.global_replace (Str.regexp "&gt;") ">" s_lt in
        let s_apos = Str.global_replace (Str.regexp "&apos;") "\'" s_gt in
        let s_quot = Str.global_replace (Str.regexp "&quot;") "\"" s_apos in
        s_quot

let xml_of_string (s : string) : Xml.xml =
        Xml.PCData (pcdata_of_string s)

let xml_of_ts_title (title : ts_title) : Xml.xml =
        match title with Cs_title (s : string) -> 
        let content : Xml.xml list = [xml_of_string s] in 
        Xml.Element ("title",[],content)

let xml_list_of_ts_title_opt (title_opt : ts_title option) : Xml.xml list =
        match title_opt with
        |None -> []
        |Some title -> [xml_of_ts_title title]

let xml_of_ts_author (author : ts_author) : Xml.xml =
        match author with
        | Cs_author (s : string) -> Xml.Element ("author", [], [xml_of_string s])

let xml_list_of_ts_authors_opt (authors_opt : ts_authors option) : Xml.xml list =
        match authors_opt with
        |None -> []
        |Some (Cs_authors (author_list : ts_author list)) -> 
                [Xml.Element ("authors",[],List.map xml_of_ts_author author_list)]

let string_of_timezone (timezone : string * int * int) : string =
        match timezone with
        |sign,h,m -> sign ^ (Printf.sprintf "%.2i" h) ^ ":" ^ (Printf.sprintf "%.2i" m)

let xml_of_ts_date_auto (doc_settings : t_doc_settings) (date : ts_date_auto) : Xml.xml option =
        match Common_utils.time_of_ts_date_auto doc_settings date with
        |None -> None
        |Some (time : Common_utils.t_time) ->
                let format (i : int) : string = Printf.sprintf "%.2i" i in
                let date_string : string = String.concat "-" [format time.year;format time.month;format time.day] in
                let time_string : string = String.concat ":" [format time.hour;format time.minute] in
                let display_string : string = String.concat " " [date_string;time_string;utc_timezone time.timezone] in
                let datetime_string : string = String.concat "" [date_string;"T";time_string;string_of_timezone time.timezone] in
                Some (Xml.Element ("date",[("datetime", datetime_string)],[xml_of_string display_string]))

let xml_of_ts_date_custom (date : ts_date_custom) : Xml.xml =
        match date with
        |Cs_date_custom s -> Xml.Element ("date",[("datetime", s)],[xml_of_string s])

let xml_of_tu_date (doc_settings : t_doc_settings) (date : tu_date) : Xml.xml option =
        match date with
        |Cu_date_auto d -> xml_of_ts_date_auto doc_settings d
        |Cu_date_custom d -> Some (xml_of_ts_date_custom d) 


let xml_list_of_tu_date_opt (doc_settings : t_doc_settings) (date_opt : tu_date option) : Xml.xml list =
        match date_opt with
        |None -> []
        |Some date ->
                match xml_of_tu_date doc_settings date with
                |Some xml -> [xml]
                |None -> []


let xml_list_of_abstract_hdr (doc_settings : t_doc_settings) : Xml.xml list =
        match doc_settings.abstract_hdr with
        |None -> []
        |Some (abstract_hdr,_) -> [Xml.Element ("abstract_hdr",[],[xml_of_string abstract_hdr])]

let xml_list_of_refs_hdr (doc_settings : t_doc_settings): Xml.xml list =
        match doc_settings.refs_hdr with
        |None -> []
        |Some (hdr,_) ->
                let content : Xml.xml list = [xml_of_string hdr] in
                [Xml.Element ("refs_hdr",[],content)]


let string_of_scope (doc_settings : t_doc_settings) (path : t_path) (scope : tu_scope) : string =
        match scope with
        |Cu_scope_gbl -> "GBL"
        |Cu_scope_ch -> "CH_" ^ (string_of_path doc_settings (path_to_ch_node path))
        |Cu_scope_sec -> "SEC_" ^ (string_of_path doc_settings (path_to_sec_node path))
        |Cu_scope_app -> "APP_" ^ (string_of_path doc_settings (path_to_app_node path))
        |Cu_scope_par -> "PAR_" ^ (string_of_path doc_settings (path_to_par_node path))

let cdata_of_tr_id (doc_settings : t_doc_settings) (path : t_path) (id : tr_id) : string =
        match id.fld_id_tag, id.fld_id_name, id.fld_id_scope with
        |Cs_tag (tag_string : string), Cs_name (name_string : string), None -> (tag_string ^ "_" ^ name_string)
        |Cs_tag (tag_string : string), Cs_name (name_string : string), Some scope -> (tag_string ^ "_" ^ name_string ^ "_" ^ (string_of_scope doc_settings path scope))


let attr_list_of_ts_tag (classes : string list) (tag : ts_tag) : (string*string) list =
        match tag with
        |Cs_tag (s : string) -> [("class"), String.concat " " (s::classes)]



let attr_list_of_tr_id (doc_settings : t_doc_settings) (path : t_path) (id : tr_id) : (string*string) list =
        [("id", cdata_of_tr_id doc_settings path id)]


let attr_list_of_tr_id_opt (doc_settings : t_doc_settings) (path : t_path) (classes : string list) (id_opt : tr_id option) : (string*string) list =
        match id_opt with
        | None -> [("class"), String.concat " " classes]
        | Some id -> List.concat [attr_list_of_ts_tag classes id.fld_id_tag;attr_list_of_tr_id doc_settings path id]



let attr_list_of_tu_tag_or_id_opt (doc_settings : t_doc_settings) (path : t_path) (classes : string list) (a : tu_tag_or_id option) : (string*string) list=
        match a with
        | None -> (
                match classes with
                |[] -> []
                |_::_ -> ["class", String.concat " " classes]
        )
        | Some (tag_or_id : tu_tag_or_id) -> 
                match tag_or_id with
                | Cu_tag_or_id_tag (tag : ts_tag) -> attr_list_of_ts_tag classes tag
                | Cu_tag_or_id_id (id : tr_id) -> 
                        List.concat [attr_list_of_ts_tag classes id.fld_id_tag;attr_list_of_tr_id doc_settings path id]


let attr_list_of_ts_c_ref (doc_settings : t_doc_settings) (path : t_path) (a : ts_c_ref) : (string*string) list =
        match a with Cs_c_ref (id : tr_id) -> [("href","#" ^ (cdata_of_tr_id doc_settings path id))]

let attr_list_of_ts_nte_ref (doc_settings : t_doc_settings) (path : t_path) (a : ts_nte_ref) : (string*string) list =
        match a with Cs_nte_ref (id, Cs_int i) -> 
                let addendum : string = string_of_int i in
                let href_string : string = (cdata_of_tr_id doc_settings path id) ^ "_" ^ addendum in
                let id_string : string = "ref_" ^ href_string in
                [("href","#" ^ href_string);("id", id_string)]

let attr_list_of_ts_nte_inline (doc_settings : t_doc_settings) (path : t_path) (a : ts_nte_inline) : (string*string) list =
        match a with Cs_nte_inline (_, Cs_int i) -> 
                let addendum : string = string_of_int i in
                let href_string : string = "NTE" ^ addendum in
                let id_string : string = "ref_" ^ href_string in
                [("href","#" ^ href_string);("id", id_string)]


let xml_of_ts_c_ref (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (a : ts_c_ref) : Xml.xml =
        Xml.PCData (pcdata_of_string (string_of_ts_c_ref doc_settings cref_table path a))

let xml_of_ts_nte_ref (doc_settings : t_doc_settings) (nte_table : t_nte_table) (path : t_path) (a : ts_nte_ref) : Xml.xml =
        Xml.PCData (pcdata_of_string (string_of_ts_nte_ref doc_settings nte_table path a))

let xml_of_ts_nte_inline (doc_settings : t_doc_settings) (nte_table : t_nte_table) (path : t_path) (a : ts_nte_inline) : Xml.xml =
        Xml.PCData (pcdata_of_string (string_of_ts_nte_inline doc_settings nte_table path a))

let xml_of_ts_txt_unit_wysiwyg (a : ts_txt_unit_wysiwyg) : Xml.xml =
        match a with Cs_txt_unit_wysiwyg (b : string) -> Xml.Element ("txt_unit_wysiwyg", [], [xml_of_string b])

let xml_of_ts_txt_unit_emph (a : ts_txt_unit_emph) : Xml.xml =
        match a with Cs_txt_unit_emph (b : string) -> Xml.Element ("txt_unit_emph", [], [xml_of_string b])

let xml_of_ts_txt_unit_c_ref (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (a : ts_txt_unit_c_ref) : Xml.xml =
        match a with Cs_txt_unit_c_ref (b : ts_c_ref) ->
        Xml.Element ("txt_unit_c_ref", attr_list_of_ts_c_ref doc_settings path b, [xml_of_ts_c_ref doc_settings cref_table path b])

let xml_of_ts_txt_unit_nte_ref (doc_settings : t_doc_settings) (nte_table : t_nte_table) (path : t_path) (a : ts_txt_unit_nte_ref) : Xml.xml =
        match a with Cs_txt_unit_nte_ref (b : ts_nte_ref) ->
        Xml.Element ("txt_unit_nte", attr_list_of_ts_nte_ref doc_settings path b, [xml_of_ts_nte_ref doc_settings nte_table path b])

let xml_of_ts_txt_unit_nte_inline (doc_settings : t_doc_settings) (nte_table : t_nte_table) (path : t_path) (a : ts_txt_unit_nte_inline) : Xml.xml =
        match a with Cs_txt_unit_nte_inline (b : ts_nte_inline) ->
        Xml.Element ("txt_unit_nte", attr_list_of_ts_nte_inline doc_settings path b, [xml_of_ts_nte_inline doc_settings nte_table path b])

let xml_of_tu_txt_unit (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (a : tu_txt_unit) : Xml.xml =
        match a with
        | Cu_txt_unit_wysiwyg (b: ts_txt_unit_wysiwyg) -> xml_of_ts_txt_unit_wysiwyg b
        | Cu_txt_unit_emph (b : ts_txt_unit_emph) -> xml_of_ts_txt_unit_emph b
        | Cu_txt_unit_c_ref (b : ts_txt_unit_c_ref) -> xml_of_ts_txt_unit_c_ref doc_settings cref_table path b 
        | Cu_txt_unit_nte_ref (b : ts_txt_unit_nte_ref) -> xml_of_ts_txt_unit_nte_ref doc_settings nte_table path b
        | Cu_txt_unit_nte_inline (b : ts_txt_unit_nte_inline) -> xml_of_ts_txt_unit_nte_inline doc_settings nte_table path b



let xml_list_of_ts_txt_units (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (a : ts_txt_units) : Xml.xml list =
        let rec aux (lst : tu_txt_unit list) (acc : Xml.xml list) =
                match lst with
                |[] -> acc
                |hd::tl ->
                        let xml_hd : Xml.xml = xml_of_tu_txt_unit doc_settings cref_table nte_table path hd in
                        aux tl (xml_hd::acc)
        in
        match a with
        | Cs_txt_units (b : tu_txt_unit list) -> List.rev (aux b [])


let xml_of_ts_blk_txt (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (blk_txt : ts_blk_txt) : Xml.xml =
        match blk_txt with
        |Cs_blk_txt (txt_units : ts_txt_units) -> Xml.Element ("blk_txt",[],xml_list_of_ts_txt_units doc_settings cref_table nte_table path txt_units)

let xml_of_ts_vrb_line (vrb_line : ts_vrb_line) : Xml.xml =
        match vrb_line with
        |Cs_vrb_line (line : string) -> 
                match line with
                |"" -> Xml.Element ("vrb_line_empty",[],[])
                |_ -> Xml.Element ("vrb_line",[],[xml_of_string line])

let xml_list_of_ts_vrb_lines (vrb_lines : ts_vrb_lines) : Xml.xml list =
        match vrb_lines with
        |Cs_vrb_lines (vrb_line_list : ts_vrb_line list) -> List.map xml_of_ts_vrb_line vrb_line_list

let xml_of_ts_blk_vrb (blk_vrb : ts_blk_vrb) : Xml.xml =
        match blk_vrb with
        |Cs_blk_vrb (vrb_lines : ts_vrb_lines) -> Xml.Element ("blk_vrb",[],xml_list_of_ts_vrb_lines vrb_lines)



let par_hdr_opt (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (tag_or_id_opt : tu_tag_or_id option) (hdr_opt : ts_hdr option) : (Xml.xml list) option=
        let tag_content_opt : (Xml.xml list) option = 
                match tag_or_id_opt with
                |Some (tag_or_id : tu_tag_or_id) -> (
                        match tag_or_id with
                        |Cu_tag_or_id_tag (tag : ts_tag) 
                        |Cu_tag_or_id_id { fld_id_tag = (tag : ts_tag); fld_id_name = _ } ->
                                match doc_settings.expand_tag tag with
                                | Some (lbl,_) -> Some [xml_of_string lbl]
                                | None -> None
                )
                | None -> None
        in
        let hdr_content_opt : (Xml.xml list) option = 
                match hdr_opt with
                |None -> None
                |Some (Cs_hdr (txt_units : ts_txt_units)) ->
                        Some (xml_list_of_ts_txt_units doc_settings cref_table nte_table path txt_units)
        in
        match tag_content_opt, hdr_content_opt with
                |Some tag_content, Some hdr_content ->
                        Some [Xml.Element ("par_tag",[],tag_content);Xml.Element ("par_hdr",[],hdr_content)]
                |None, Some hdr_content ->
                        Some [Xml.Element ("par_hdr",[],hdr_content)]
                |Some tag_content, None ->
                        Some [Xml.Element ("par_tag_hdr",[],tag_content)]
                |None, None -> None


(* normalize *)

let unite_exml_txt_units_wysiwyg (xml_list : Xml.xml list) : Xml.xml =
        let rec aux (lst : Xml.xml list) (acc : string) : string =
                match lst with
                |[] -> acc
                |hd::tl ->
                        match hd with
                        |Xml.PCData s ->
                                aux tl (acc ^ s)
                        |_ -> aux tl acc
        in
        Xml.Element ("txt_unit_wysiwyg",[], [Xml.PCData (aux xml_list "")])

let normalize_exml_txt_units (xml_list : Xml.xml list) : Xml.xml list =
        let rec aux (lst : Xml.xml list) (acc_list : Xml.xml list) (acc_wysiwyg : Xml.xml list) =
                match lst with
                |[] -> (
                        match acc_wysiwyg with
                        |[] -> acc_list
                        |_::_ -> (unite_exml_txt_units_wysiwyg (List.rev acc_wysiwyg))::acc_list
                )
                |hd::tl ->
                        match hd, acc_wysiwyg with
                        |Xml.Element ("txt_unit_wysiwyg", _, [xml]), _ -> aux tl acc_list (xml::acc_wysiwyg)
                        |_, _::_ -> aux tl (hd::((unite_exml_txt_units_wysiwyg (List.rev acc_wysiwyg))::acc_list)) []
                        |_, [] -> aux tl (hd::acc_list) []
        in List.rev (aux xml_list [] [])


let rec normalize_exml (xml : Xml.xml) : Xml.xml =
        match xml with
        |Xml.Element (tag, attr_list, xml_list) -> (
                match tag with
                |"blk_txt"
                |"dsp_line_main"
                |"par_hdr_inline"
                |"par_hdr"
                |"sec_hdr"
                |"ch_hdr" -> Xml.Element (tag, attr_list, normalize_exml_txt_units xml_list)
                |_ -> Xml.Element (tag, attr_list, List.map normalize_exml xml_list)
        )
        |Xml.PCData s -> Xml.PCData s
