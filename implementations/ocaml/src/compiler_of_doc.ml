open Doc_types
open Common_utils
open Txt_utils
open Exml_utils

exception Error of string

type t_acc = CREF_TABLE of t_cref_table | LINES of (string list) | EXML of (Xml.xml list) | MARGIN_LABELS of (string list)

let rec cref_table_of_tr_doc (doc_settings : t_doc_settings) (doc : tr_doc) : t_cref_table =
        match acc_of_tr_doc doc_settings [] (CREF_TABLE []) doc with
        | CREF_TABLE table -> check_cref_table doc_settings (List.rev table)
        | _ -> raise (Error "accumulator output type not identical to accumulator input type")

and txt_of_tr_doc (options : string list) (doc : tr_doc) : string =
        let doc_settings : t_doc_settings = doc_settings_of_tr_doc doc in
        let left_margin : int = 
                match Txt_utils.left_margin_of_options options with
                |Some (margin : int) -> margin
                |None -> 
                        let margin_labels : string list = margin_labels_of_tr_doc doc_settings doc in
                        Txt_utils.left_margin_of_margin_labels margin_labels
        in
        let doc_width : int = 
                match Txt_utils.doc_width_of_options options with
                |Some (width : int) -> width
                |None -> if 68 + left_margin > 80 then 80 else 68 + left_margin
        in
        let auto_numbering : int -> int -> string = auto_numbering_of_options options in
        let allow_custom_numbering : bool = allow_custom_numbering_of_options options in
        let new_doc_settings : t_doc_settings = {
                doc_width = doc_width;
                left_margin = left_margin;
                title_indent = left_margin;
                author_indent = left_margin;
                abstract_indent = left_margin;
                refs_indent = left_margin;
                tab_length = doc_settings.tab_length;
                abstract_hdr = doc_settings.abstract_hdr;
                refs_hdr = doc_settings.refs_hdr;
                ch_prefix = doc_settings.ch_prefix;
                sec_prefix = doc_settings.sec_prefix;
                app_prefix = doc_settings.app_prefix;
                par_prefix = doc_settings.par_prefix;
                expand_tag = doc_settings.expand_tag;
                auto_numbering = auto_numbering;
                allow_custom_numbering = allow_custom_numbering;
        }
        in
        String.concat "\n" (lines_of_tr_doc new_doc_settings doc)

and exml_of_tr_doc (options : string list) (doc : tr_doc) : Xml.xml =
        let doc_settings : t_doc_settings = doc_settings_of_tr_doc doc in
        let auto_numbering = auto_numbering_of_options options in
        let allow_custom_numbering : bool = allow_custom_numbering_of_options options in
        let new_doc_settings : t_doc_settings = {
                doc_width = doc_settings.doc_width;
                left_margin = doc_settings.left_margin;
                title_indent = doc_settings.title_indent;
                author_indent = doc_settings.author_indent;
                abstract_indent = doc_settings.abstract_indent;
                refs_indent = doc_settings.refs_indent;
                tab_length = doc_settings.tab_length;
                abstract_hdr = doc_settings.abstract_hdr;
                refs_hdr = doc_settings.refs_hdr;
                ch_prefix = doc_settings.ch_prefix;
                sec_prefix = doc_settings.sec_prefix;
                app_prefix = doc_settings.app_prefix;
                par_prefix = doc_settings.par_prefix;
                expand_tag = doc_settings.expand_tag;
                auto_numbering = auto_numbering;
                allow_custom_numbering = allow_custom_numbering;
        }
        in
        match xml_list_of_tr_doc new_doc_settings doc with
        | hd::[] -> hd
        | _ -> raise (Error "function expected to return an exml-list with exactly one element")

and lines_of_tr_doc (doc_settings : t_doc_settings) (doc : tr_doc) : string list =
        let cref_table = cref_table_of_tr_doc doc_settings doc in
        match acc_of_tr_doc doc_settings cref_table (LINES []) doc with
        | LINES lines -> lines
        | _ -> raise (Error "accumulator output type not identical to accumulator input type")

and xml_list_of_tr_doc (doc_settings : t_doc_settings) (doc : tr_doc) : Xml.xml list =
        let cref_table = cref_table_of_tr_doc doc_settings doc in
        match acc_of_tr_doc doc_settings cref_table (EXML []) doc with
        | EXML xml_list -> xml_list
        | _ -> raise (Error "accumulator output type not identical to accumulator input type")

and margin_labels_of_tr_doc (doc_settings : t_doc_settings) (doc : tr_doc) : string list=
        match acc_of_tr_doc doc_settings [] (MARGIN_LABELS []) doc with
        | MARGIN_LABELS string_list -> string_list
        | _ -> raise (Error "accumulator output type not identical to accumulator input type")

and acc_of_tr_doc (doc_settings : t_doc_settings) (cref_table : t_cref_table) (acc : t_acc) (doc : tr_doc) : t_acc =
        let doc_class : t_doc_class = class_of_tr_doc doc in
        match acc with
        | MARGIN_LABELS _ -> acc_of_tu_doc_main doc_settings cref_table acc doc.fld_doc_main
        | CREF_TABLE _ -> (
                let table_abstract : t_cref_table = 
                        match doc.fld_doc_abstract with
                        |None -> []
                        |Some (abstract : ts_abstract) -> 
                                match acc_of_ts_abstract doc_settings cref_table doc_class [ABSTRACT_NODE] (CREF_TABLE []) abstract with
                                |CREF_TABLE table -> table
                                | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                in
                let table_refs : t_cref_table = 
                        match doc.fld_doc_refs with
                        |None -> []
                        |Some (refs : ts_refs) -> 
                                match acc_of_ts_refs doc_settings cref_table doc_class [REFS_NODE] (CREF_TABLE []) refs with
                                |CREF_TABLE table -> table
                                | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                in
                let table_main : t_cref_table = 
                        match acc_of_tu_doc_main doc_settings cref_table (CREF_TABLE []) doc.fld_doc_main with
                        |CREF_TABLE table -> table
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                in
                CREF_TABLE (List.concat [table_abstract; table_main; table_refs])
        )
        | LINES _ -> (
                let lines_title:string list = Txt_utils.lines_of_ts_title_opt doc_settings doc.fld_doc_title in
                let lines_authors:string list = Txt_utils.lines_of_ts_authors_opt doc_settings doc.fld_doc_authors in
                let lines_abstract:string list =
                        match doc.fld_doc_abstract with
                        |None -> []
                        |Some (abstract : ts_abstract) -> 
                                match acc_of_ts_abstract doc_settings cref_table doc_class [ABSTRACT_NODE] (LINES []) abstract with
                                |LINES lines -> lines
                                | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                in
                let lines_refs:string list =
                        match doc.fld_doc_refs with
                        |None -> []
                        |Some (refs : ts_refs) -> 
                                match acc_of_ts_refs doc_settings cref_table doc_class [REFS_NODE] (LINES []) refs with
                                |LINES lines -> lines
                                | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                in
                let lines_main:string list =
                        match acc_of_tu_doc_main doc_settings cref_table (LINES []) doc.fld_doc_main with
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
                                match acc_of_ts_abstract doc_settings cref_table doc_class [ABSTRACT_NODE] (EXML []) abstract with
                                |EXML xml_list -> xml_list
                                | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                in
                let xml_list_refs:Xml.xml list = 
                        match doc.fld_doc_refs with
                        |None -> []
                        |Some (refs : ts_refs) -> 
                                match acc_of_ts_refs doc_settings cref_table doc_class [REFS_NODE] (EXML []) refs with
                                |EXML xml_list -> xml_list
                                | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                in
                let xml_main:Xml.xml = (
                        match acc_of_tu_doc_main doc_settings cref_table acc doc.fld_doc_main with
                        |EXML xml_list -> Xml.Element ("doc_main",[],xml_list) 
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                in
                let xml_list_doc = List.concat [xml_list_title;xml_list_authors;xml_list_abstract;[xml_main];xml_list_refs] in
                let doc_class_string = string_of_t_doc_class doc_class in
                EXML [Xml.Element ("doc",[("class",doc_class_string)],xml_list_doc)]

and acc_of_ts_abstract (doc_settings : t_doc_settings) (cref_table : t_cref_table) (doc_class : t_doc_class) (path : t_path) (acc : t_acc) (a : ts_abstract) : t_acc =
        match a with
        |Cs_abstract (b : ts_blks) -> 
                match acc with
                |LINES _ -> (
                        let padding : string list =
                        match doc_class with
                        |DOC_CHS -> ["";"";"";""]
                        |DOC_SECS -> ["";"";""]
                        | _ -> ["";""]
                        in
                        let hdr : string list = Txt_utils.lines_of_abstract_hdr doc_settings doc_class in
                        match acc_of_ts_blks doc_settings cref_table path (LINES []) b with
                        |LINES lines -> LINES (List.concat [hdr; lines; padding])
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                |EXML _ -> (
                        let hdr : Xml.xml list = Exml_utils.xml_list_of_abstract_hdr doc_settings in
                        match acc_of_ts_blks doc_settings cref_table path (EXML []) b with
                        |EXML xml_list -> EXML [Xml.Element ("abstract",[],List.concat [hdr;xml_list])]
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                | _ -> acc_of_ts_blks doc_settings cref_table path acc b

and acc_of_ts_refs (doc_settings : t_doc_settings) (cref_table : t_cref_table) (doc_class : t_doc_class)  (path : t_path) (acc : t_acc) (a : ts_refs) : t_acc =
        match a with
        |Cs_refs (b : ts_blks) -> 
                match acc with
                |LINES _ -> (
                        let padding : string list =
                        match doc_class with
                        |DOC_CHS -> ["";"";"";""]
                        |DOC_SECS -> ["";"";""]
                        | _ -> ["";""]
                        in
                        let hdr : string list = Txt_utils.lines_of_refs_hdr doc_settings doc_class in
                        match acc_of_ts_blks doc_settings cref_table path (LINES []) b with
                        |LINES lines -> LINES (List.concat [padding; hdr; lines])
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                |EXML _ -> (
                        let hdr : Xml.xml list = Exml_utils.xml_list_of_refs_hdr doc_settings in
                        match acc_of_ts_blks doc_settings cref_table path (EXML []) b with
                        |EXML xml_list -> EXML [Xml.Element ("refs",[],List.concat [hdr;xml_list])]
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                | _ -> acc_of_ts_blks doc_settings cref_table path acc b

and acc_of_tu_doc_main (doc_settings : t_doc_settings) (cref_table : t_cref_table) (acc : t_acc) (a : tu_doc_main) : t_acc =
        match a with
        | Cu_doc_main_chs (b : ts_chs) -> acc_of_ts_chs doc_settings cref_table ([] : t_path) acc b
        | Cu_doc_main_secs (b : ts_secs) -> acc_of_ts_secs doc_settings cref_table ([] : t_path) acc b
        | Cu_doc_main_pars (b : ts_pars) -> acc_of_ts_pars doc_settings cref_table ([] : t_path) acc b
        | Cu_doc_main_blks (b : ts_blks) -> acc_of_ts_blks doc_settings cref_table ([] : t_path) acc b

and acc_of_ts_chs (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : ts_chs) : t_acc =
        match a with Cs_chs (b : tr_ch list) ->
        let rec aux (ch_nr : int) (acc : t_acc) (b : tr_ch list) : t_acc = (
                match b with
                | [] -> acc
                | hd :: tl -> aux (ch_nr + 1) (add_empty_lines_after_ch tl (acc_of_tr_ch doc_settings cref_table (CH_NODE ch_nr :: path) acc hd)) tl
        )
        in
        aux 0 acc b

and add_empty_lines_after_ch (tl:tr_ch list) (acc : t_acc) : t_acc =
        match tl, acc with
        |a::b, LINES lines -> LINES (List.concat [lines;["";"";"";""]])
        |_, _ -> acc


and acc_of_ts_secs (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : ts_secs) : t_acc =
        match a with | Cs_secs (b : tr_sec list) ->
        let rec aux (sec_nr : int) (app_nr : int) (acc : t_acc) (b : tr_sec list) : t_acc = (
                match b with
                | [] -> acc
                | hd :: tl -> 
                        match is_appendix hd with
                        |true -> aux sec_nr (app_nr + 1) (add_empty_lines_after_sec tl (acc_of_tr_sec doc_settings cref_table (APP_NODE app_nr :: path) acc hd)) tl
                        |false -> aux (sec_nr + 1) app_nr (add_empty_lines_after_sec tl (acc_of_tr_sec doc_settings cref_table (SEC_NODE sec_nr :: path) acc hd)) tl
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
        |a::b, LINES lines -> LINES (List.concat [lines;["";"";""]])
        |_, _ -> acc


and acc_of_ts_pars (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : ts_pars) : t_acc =
        match a with Cs_pars (b : tu_par list) ->
        let rec aux (par_nr : int) (acc : t_acc) (b : tu_par list) : t_acc =
                match b with
                | [] -> acc
                | hd :: tl -> 
                        aux (par_nr + 1) (add_empty_lines_after_par tl (acc_of_tu_par doc_settings cref_table ((node_of_tu_par doc_settings par_nr hd):: path) acc hd)) tl
        in 
        aux 0 acc b

and add_empty_lines_after_par (tl : tu_par list) (acc : t_acc) : t_acc =
        match tl, acc with
        |a::b, LINES lines -> LINES (List.concat [lines;["";""]])
        |_, _ -> acc


and acc_of_ts_blks (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : ts_blks) : t_acc =
        let new_doc_settings = doc_settings_of_ts_blks doc_settings (lvl_of_path path) a in
        match a with Cs_blks (b : tu_blk list) ->
        let rec aux (auto_nr : int) (acc : t_acc) (b : tu_blk list) : t_acc = (
                match b with
                | [] -> acc
                | hd :: tl -> (
                        match acc_of_tu_blk new_doc_settings cref_table auto_nr path acc hd with
                        (acc : t_acc), (auto_nr : int) -> aux auto_nr (add_empty_lines_after_blk tl acc) tl
                )
        )
        in 
        aux 0 acc b

and add_empty_lines_after_blk (tl:tu_blk list) (acc : t_acc) : t_acc =
        match tl, acc with
        |_::_, LINES lines -> LINES (List.concat [lines;[""]])
        |_, _ -> acc


and acc_of_tr_ch (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : tr_ch) : t_acc =
        match acc with
        |MARGIN_LABELS _ -> acc_of_ch_main doc_settings cref_table path acc a.fld_ch_main
        |CREF_TABLE table ->
                let newacc : t_acc = CREF_TABLE (
                        match a.fld_ch_tag_or_id with
                        |Some (Cu_tag_or_id_id (id : tr_id)) -> (id, path, Cref_element_ch a) :: table
                        |_ -> table
                )
                in 
                acc_of_ch_main doc_settings cref_table path newacc a.fld_ch_main
        |LINES acc_lines -> 
                let newacc : t_acc = LINES (
                        List.concat [acc_lines;Txt_utils.lines_of_ts_hdr_opt doc_settings cref_table path a.fld_ch_hdr]
                )
                in 
                acc_of_ch_main doc_settings cref_table path newacc a.fld_ch_main
        |EXML acc_list -> 
                let xml_list_main : Xml.xml list = (
                        match acc_of_ch_main doc_settings cref_table path (EXML []) a.fld_ch_main with
                        |EXML xml_list -> xml_list
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                in
                let xml_list_lbl:Xml.xml list = [Exml_utils.xml_of_string (label_of_path doc_settings path)] in
                let xml_hdr : Xml.xml = (
                        match a.fld_ch_hdr with
                        |None -> Xml.Element ("ch_lbl_hdr", [], xml_list_lbl)
                        |Some (hdr : ts_hdr) ->
                                match hdr with
                                |Cs_hdr (t : ts_txt_units) -> Xml.Element ("ch_hdr", [], Exml_utils.xml_list_of_ts_txt_units doc_settings cref_table path t)
                )
                in
                let xml_main:Xml.xml = Xml.Element ("ch_main",[],xml_list_main) in
                let xml_lbl:Xml.xml = Xml.Element ("ch_lbl",[],xml_list_lbl) in
                let attr_list : (string*string) list = Exml_utils.attr_list_of_tu_tag_or_id doc_settings path ["ch"] a.fld_ch_tag_or_id in
                match a.fld_ch_hdr with
                |None -> EXML (List.concat [acc_list;[Xml.Element ("ch", attr_list, [xml_hdr;xml_main])]])
                |Some _ -> EXML (List.concat [acc_list;[Xml.Element ("ch", attr_list, [xml_lbl;xml_hdr;xml_main])]])


and acc_of_tr_sec (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : tr_sec) : t_acc =
        match acc with
        |MARGIN_LABELS string_list -> acc_of_sec_main doc_settings cref_table path (MARGIN_LABELS ((label_of_path doc_settings path)::string_list)) a.fld_sec_main
        |CREF_TABLE table ->
                let newacc : t_acc = CREF_TABLE (
                        match a.fld_sec_tag_or_id with
                        |Some (Cu_tag_or_id_id (id : tr_id)) -> (id, path, Cref_element_sec a) :: table
                        |_ -> table
                )
                in 
                acc_of_sec_main doc_settings cref_table path newacc a.fld_sec_main
        |LINES acc_lines -> (
                let newacc : t_acc = LINES (
                        List.concat [acc_lines;Txt_utils.lines_of_ts_hdr_opt doc_settings cref_table path a.fld_sec_hdr]
                )
                in 
                acc_of_sec_main doc_settings cref_table path newacc a.fld_sec_main
        )
        |EXML acc_list -> 
                let xml_list_main:Xml.xml list= (
                        match acc_of_sec_main doc_settings cref_table path (EXML []) a.fld_sec_main with
                        |EXML xml_list -> xml_list
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                in
                let xml_list_lbl:Xml.xml list = [Exml_utils.xml_of_string (label_of_path doc_settings path)] in
                let xml_hdr:Xml.xml = (
                        match a.fld_sec_hdr with
                        |None -> 
                                Xml.Element ("sec_lbl_hdr",[],xml_list_lbl)
                        |Some (hdr : ts_hdr) -> 
                                match hdr with
                                |Cs_hdr (t:ts_txt_units) -> Xml.Element ("sec_hdr",[],xml_list_of_ts_txt_units doc_settings cref_table path t)
                )
                in
                let xml_main:Xml.xml = Xml.Element ("sec_main",[],xml_list_main) in
                let xml_lbl:Xml.xml = Xml.Element ("sec_lbl",[],xml_list_lbl) in
                let attr_list : (string*string) list = Exml_utils.attr_list_of_tu_tag_or_id doc_settings path ["sec"] a.fld_sec_tag_or_id in
                match a.fld_sec_hdr with
                |None -> EXML (List.concat [acc_list;[Xml.Element ("sec", attr_list, [xml_hdr;xml_main])]])
                |Some _ -> EXML (List.concat [acc_list;[Xml.Element ("sec", attr_list, [xml_lbl;xml_hdr;xml_main])]])


and acc_of_tu_par (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : tu_par) : t_acc =
        match a with
        |Cu_par_std (par : tr_par_std) -> acc_of_tr_par_std doc_settings cref_table path path acc par
        |Cu_par_rpt (Cs_par_rpt (id : tr_id)) ->
                match acc with
                |MARGIN_LABELS string_list -> MARGIN_LABELS ((label_of_path doc_settings path)::string_list)
                |CREF_TABLE _ -> acc
                |_ -> 
                        match par_restated_of_tr_id doc_settings cref_table path id with
                        |Some ((par : tr_par_std), (path_origin : t_path)) -> acc_of_tr_par_std doc_settings cref_table path path_origin acc par
                        |None -> let _ : unit = Debug_utils.print_warning (String.concat "" [
                                        "WARNING: failed to restate paragraph with id \'";
                                        string_of_tr_id id;"\' in ";
                                        string_of_path doc_settings path;
                                ]) in acc

and acc_of_tr_par_std (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (path_origin : t_path) (acc : t_acc) (par : tr_par_std) : t_acc =
        match acc with
        |MARGIN_LABELS string_list -> MARGIN_LABELS ((label_of_path doc_settings path)::string_list)
        |CREF_TABLE table -> (
                let newacc : t_acc = CREF_TABLE (
                        match par.fld_par_tag_or_id with
                        |Some (Cu_tag_or_id_id (id : tr_id)) -> (id, path, Cref_element_par par) :: table
                        |_ -> table
                )
                in acc_of_ts_blks doc_settings cref_table path newacc par.fld_par_main
        )
        |LINES acc_lines -> (
                let new_par = Txt_utils.copy_hdr_to_main doc_settings par in
                match acc_of_ts_blks doc_settings cref_table path_origin (LINES []) new_par.fld_par_main with
                |LINES (hd::tl) -> LINES (List.concat [acc_lines;[Txt_utils.insert_label doc_settings path hd];tl])
                |_ -> raise (Error "par_main cannot be empty")
        )
        |EXML acc_list -> (
                let inline_hdr : bool =
                        match par.fld_par_main with
                        |Cs_blks ((Cu_blk_txt _) :: _) -> true
                        |_ -> false
                in
                let xml_list_hdr_opt : (Xml.xml list) option =
                        Exml_utils.par_hdr_opt doc_settings cref_table path_origin par.fld_par_tag_or_id par.fld_par_hdr inline_hdr
                in
                let xml_list_lbl : Xml.xml list = [Exml_utils.xml_of_string (label_of_path doc_settings path)] in
                let xml_lbl : Xml.xml = 
                        match xml_list_hdr_opt with
                        |None -> Xml.Element ("par_lbl_hdr",[],xml_list_lbl)
                        |Some _ -> Xml.Element ("par_lbl",[],xml_list_lbl)
                in
                let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
                let xml_main : Xml.xml = (
                        match acc_of_par_main doc_settings cref_table path_origin (EXML []) par.fld_par_main with
                        |EXML xml_list -> (
                                match xml_list_hdr_opt with
                                |None -> Xml.Element ("par_main",[],xml_list)
                                |Some xml_list_hdr -> 
                                        match inline_hdr with
                                        |true -> Xml.Element ("par_main_w_hdr_inline",[],List.concat [xml_list_hdr;xml_list])
                                        |false -> Xml.Element ("par_main_w_hdr",[],List.concat [xml_list_hdr;xml_list])
                        )
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                in
                let attr_list : (string*string) list = Exml_utils.attr_list_of_tu_tag_or_id doc_settings path ["par"] par.fld_par_tag_or_id in
                EXML (List.concat [acc_list;[Xml.Element ("par", attr_list,[xml_lbl;xml_clear;xml_main])]])
        )



and acc_of_ch_main (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : tu_secs_pars_or_blks) : t_acc =
        match a with
        | Cu_secs_pars_or_blks_secs (b : ts_secs) -> acc_of_ts_secs doc_settings cref_table path acc b
        | Cu_secs_pars_or_blks_pars (b : ts_pars) -> acc_of_ts_pars doc_settings cref_table path acc b
        | Cu_secs_pars_or_blks_blks (b : ts_blks) -> acc_of_ts_blks doc_settings cref_table path acc b

and acc_of_sec_main (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : tu_pars_or_blks) : t_acc =
        match a with
        | Cu_pars_or_blks_pars (b : ts_pars) -> acc_of_ts_pars doc_settings cref_table path acc b
        | Cu_pars_or_blks_blks (b : ts_blks) -> acc_of_ts_blks doc_settings cref_table path acc b

and acc_of_par_main (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : ts_blks) : t_acc =
        acc_of_ts_blks doc_settings cref_table path acc a

and acc_of_tu_blk (doc_settings : t_doc_settings) (cref_table : t_cref_table) (auto_nr : int) (path : t_path) (acc : t_acc) (a : tu_blk) : t_acc * int =
        match a with
        | Cu_blk_itm (b : tr_blk_itm) ->
                let node : t_node = node_of_blk_itm doc_settings path auto_nr b in
                let next_auto_nr =
                        match b.fld_blk_itm_lbl with 
                        |Cu_lbl_auto Cs_lbl_auto -> auto_nr + 1
                        | _ -> auto_nr
                in 
                (acc_of_tr_blk_itm doc_settings cref_table (node :: path) acc b, next_auto_nr)
        | Cu_blk_dsp (b : ts_blk_dsp) ->
                let node : t_node = DSP_NODE in
                acc_of_ts_blk_dsp doc_settings cref_table auto_nr (node :: path) acc b
        | Cu_blk_txt (b : ts_blk_txt) -> (acc_of_ts_blk_txt doc_settings cref_table path acc b, auto_nr)
        | Cu_blk_blt (b : ts_blk_blt) ->
                let node : t_node = BLT_NODE in
                (acc_of_ts_blk_blt doc_settings cref_table (node :: path) acc b, auto_nr)
        | Cu_blk_vrb (b: ts_blk_vrb) -> (acc_of_ts_blk_vrb doc_settings path acc b, auto_nr)


and acc_of_ts_blk_txt (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : ts_blk_txt) : t_acc =
        match acc with
                | MARGIN_LABELS _
                | CREF_TABLE _ -> acc
                | LINES acc_lines -> LINES (List.concat [acc_lines; Txt_utils.lines_of_ts_blk_txt doc_settings cref_table path a])
                | EXML acc_list -> EXML (List.concat [acc_list; [Exml_utils.xml_of_ts_blk_txt doc_settings cref_table path a]])

and acc_of_ts_blk_blt (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : ts_blk_blt) : t_acc =
        match a with Cs_blk_blt (b : ts_blks) ->
        match acc with
        | MARGIN_LABELS _ -> acc
        | CREF_TABLE _ -> acc_of_ts_blks doc_settings cref_table path acc b
        | LINES acc_lines -> (
                match acc_of_ts_blks doc_settings cref_table path (LINES []) b with
                | LINES (lines : string list) -> (
                        let head : string = List.hd lines in
                        let newhead : string = Txt_utils.insert_label doc_settings path head in
                        let newlines : string list = newhead :: List.tl lines in
                        LINES (List.concat [ acc_lines; newlines; ])
                )
                | _ -> raise (Error "accumulator output type not identical to accumulator input type")

        )
        | EXML acc_list ->
                let xml_list_main:Xml.xml list = (
                        match acc_of_ts_blks doc_settings cref_table path (EXML []) b with
                        |EXML xml_list_blks -> xml_list_blks
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                in 
                let xml_list_lbl:Xml.xml list = [Exml_utils.xml_of_string (label_of_path doc_settings path)]
                in
                let xml_main:Xml.xml = Xml.Element ("blk_blt_main",[],xml_list_main) in
                let xml_lbl:Xml.xml = Xml.Element ("blk_blt_lbl",[],xml_list_lbl) in
                let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
                EXML (List.concat [acc_list;[Xml.Element ("blk_blt",[],[xml_lbl;xml_clear;xml_main])]])


and acc_of_tr_blk_itm (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (acc : t_acc) (a : tr_blk_itm) : t_acc =
        match acc with
        | MARGIN_LABELS _ -> acc
        | CREF_TABLE table ->
                let newacc : t_acc = CREF_TABLE (
                        match a.fld_blk_itm_id with
                        | Some (id : tr_id) -> (id, path, Cref_element_blk_itm a) :: table
                        | _ -> table
                )
                in acc_of_ts_blks doc_settings cref_table path newacc a.fld_blk_itm_main
        | LINES acc_lines -> (
                match acc_of_ts_blks doc_settings cref_table path (LINES []) a.fld_blk_itm_main with
                | LINES (lines : string list) -> (
                        let head : string = List.hd lines in
                        let newhead : string = Txt_utils.insert_label doc_settings path head in
                        let newlines : string list = newhead :: List.tl lines in
                        LINES (List.concat [ acc_lines; newlines ])
                )
                | _ -> raise (Error "accumulator output type not identical to accumulator input type")

        )
        | EXML acc_list ->
                let xml_list_main = (
                        match acc_of_ts_blks doc_settings cref_table path (EXML []) a.fld_blk_itm_main with
                        |EXML xml_list_blks -> xml_list_blks
                        | _ -> raise (Error "accumulator output type not identical to accumulator input type")
                )
                in 
                let xml_list_lbl:Xml.xml list = [Exml_utils.xml_of_string (label_of_path doc_settings path)]
                in
                let xml_main : Xml.xml = Xml.Element ("blk_itm_main",[],xml_list_main) in
                let xml_lbl : Xml.xml = Xml.Element ("blk_itm_lbl",[],xml_list_lbl) in
                let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
                let attr_list = Exml_utils.attr_list_of_tr_id doc_settings path a.fld_blk_itm_id in
                EXML (List.concat [acc_list;[Xml.Element ("blk_itm", attr_list, [xml_lbl;xml_clear;xml_main])]])

and acc_of_ts_blk_vrb (doc_settings : t_doc_settings) (path : t_path) (acc : t_acc) (a : ts_blk_vrb): t_acc =
        match acc with
        |MARGIN_LABELS _ -> acc
        |CREF_TABLE _ -> acc
        |LINES acc_lines -> LINES (List.concat [acc_lines;Txt_utils.lines_of_ts_blk_vrb doc_settings path a])
        |EXML acc_list -> EXML (List.concat [acc_list;[Exml_utils.xml_of_ts_blk_vrb a]])


and acc_of_ts_blk_dsp (doc_settings : t_doc_settings) (cref_table : t_cref_table) (auto_nr : int) (path : t_path) (acc : t_acc) (a : ts_blk_dsp) : t_acc * int =
        match a with Cs_blk_dsp (b : ts_dsp_lines) ->
        match b with Cs_dsp_lines (c : tr_dsp_line list) ->
        let rec aux (auto_nr : int) (acc : t_acc) (c : tr_dsp_line list) : t_acc * int = (
                match c with
                | [] -> (acc, auto_nr)
                | hd :: tl ->
                        let node : t_node = node_of_dsp_line doc_settings path auto_nr hd in
                        let next_auto_nr =
                                match hd.fld_dsp_line_lbl with 
                                | Some (Cu_lbl_auto Cs_lbl_auto) -> auto_nr + 1 
                                | _ -> auto_nr
                        in
                        aux next_auto_nr (acc_of_tr_dsp_line doc_settings cref_table (node :: path) auto_nr acc hd) tl
        )
        in
        match acc with
        | MARGIN_LABELS _ -> (acc, auto_nr)
        | CREF_TABLE _ -> aux auto_nr acc c
        | LINES acc_lines -> (
                match aux auto_nr (LINES []) c with 
                | (LINES lines,nr) -> 
                        (LINES (List.concat [acc_lines;lines]),nr)
                | _ -> raise (Error "accumulator output type not identical to accumulator input type")

        )
        | EXML acc_list -> (
                match aux auto_nr (EXML []) c with 
                |(EXML xml_list,nr) -> 
                        (EXML (List.concat [acc_list;[Xml.Element ("blk_dsp",[],xml_list)]]),nr)
                | _ -> raise (Error "accumulator output type not identical to accumulator input type")

        )

and acc_of_tr_dsp_line (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (auto_nr : int) (acc : t_acc) (a : tr_dsp_line) : t_acc =
        match acc with
        | MARGIN_LABELS _ -> acc
        | CREF_TABLE table -> (
                match a.fld_dsp_line_id with
                        | Some (id : tr_id) -> CREF_TABLE ((id, path, Cref_element_dsp_line a) :: table)
                        | None -> CREF_TABLE table
        )
        | LINES acc_lines -> (
                match a.fld_dsp_line_lbl, Txt_utils.lines_of_ts_txt_units doc_settings cref_table path a.fld_dsp_line_units with
                |Some _, hd::tl -> LINES (List.concat [acc_lines;[Txt_utils.insert_label doc_settings path hd];tl])
                |None, lines -> LINES (List.concat [acc_lines;lines])
                |_,[] -> raise (Error "dps_line cannot be empty")
        )
        | EXML acc_list -> (
                let xml_list_main:Xml.xml list = Exml_utils.xml_list_of_ts_txt_units doc_settings cref_table path a.fld_dsp_line_units in 
                let xml_list_lbl:Xml.xml list = 
                        match label_of_path_opt doc_settings path with
                        |None -> []
                        |Some (s:string) -> [Exml_utils.xml_of_string s]
                in
                let xml_main:Xml.xml = Xml.Element ("dsp_line_main",[],xml_list_main) in
                let xml_lbl:Xml.xml = Xml.Element ("dsp_line_lbl",[],xml_list_lbl) in
                let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
                let attr_list: (string*string) list = attr_list_of_tr_id doc_settings path a.fld_dsp_line_id in
                match a.fld_dsp_line_lbl with
                |None -> EXML (List.concat [acc_list;[Xml.Element ("dsp_line", attr_list, [xml_main])]])
                |Some _ -> EXML (List.concat [acc_list;[Xml.Element ("dsp_line", attr_list, [xml_lbl; xml_clear; xml_main])]])
        )

