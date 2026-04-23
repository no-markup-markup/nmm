open Doc_types
open Common_utils

(* utf8-segmentation *)

let utf_8_segments (boundary : Uuseg.boundary) (s : string) : string list =
        let flush_segment (buf : Buffer.t) (acc : string list) : string list =
                let segment : string = Buffer.contents buf in
                let _ : unit = Buffer.clear buf in
                if segment = "" then acc else segment :: acc
        in
        let rec add (buf : Buffer.t) (acc : string list) (segmenter : Uuseg.t) (v : [ `Await | `End | `Uchar of Uchar.t ]) : string list =
                match ((Uuseg.add segmenter v) : Uuseg.ret) with
                | `Uchar u ->
                        let _ : unit = Buffer.add_utf_8_uchar buf u in
                        add buf acc segmenter `Await
                | `Boundary -> add buf (flush_segment buf acc) segmenter `Await
                | `Await 
                | `End -> acc
        in
        let rec loop (buf : Buffer.t) (acc : string list) (s : string) (i : int) (max : int) (segmenter : Uuseg.t) : string list =
                if i > max then flush_segment buf (add buf acc segmenter `End) else
                let dec : Uchar.utf_decode = String.get_utf_8_uchar s i in
                let acc : string list = add buf acc segmenter (`Uchar (Uchar.utf_decode_uchar dec)) in
                loop buf acc s (i + Uchar.utf_decode_length dec) max segmenter
        in
        let buf : Buffer.t = Buffer.create 42 in
        let segmenter : Uuseg.t = Uuseg.create boundary in
        List.rev (loop buf [] s 0 (String.length s - 1) segmenter)

let utf_8_grapheme_clusters (s : string) : string list =
        utf_8_segments `Grapheme_cluster s

let utf_8_length (s : string) : int =
        List.length (utf_8_grapheme_clusters s)

(* inserting labels *)

let rec indent_of_path (doc_settings : t_doc_settings) (path : t_path) : int =
        match path with
        | [] -> 0
        | hd :: tl -> 
                match hd with
                | REFS_NODE -> doc_settings.refs_indent
                | ABSTRACT_NODE -> doc_settings.abstract_indent
                | CH_NODE _ -> doc_settings.left_margin
                | SEC_NODE _ -> doc_settings.left_margin
                | PAR_NODE _ -> doc_settings.left_margin
                | ITM_NODE _ -> indent_of_path doc_settings tl + doc_settings.tab_length
                | BLT_NODE -> indent_of_path doc_settings tl + doc_settings.tab_length
                | DSP_NODE -> indent_of_path doc_settings tl + doc_settings.tab_length
                | NTE_NODE _ -> 3
                | _ -> indent_of_path doc_settings tl


let insert_string (label : string) (pos : int) (s : string) : string =
        let string_len : int = String.length s in
        let label_len : int = utf_8_length label in
        match string_len < pos + label_len with
        |true -> String.concat "\n" [label;s]
        |false ->
        let actual_target : string = String.sub s pos label_len in
        let ideal_target : string = String.make label_len ' ' in
        let s1 : string = String.sub s 0 pos in
        let s2 : string =
                match actual_target = ideal_target with
                |true -> String.sub s (pos + label_len) (string_len - pos - label_len)
                |false -> ("\n"^s)
        in
        String.concat label [ s1; s2 ]


let pos_of_label (doc_settings : t_doc_settings) (path : t_path) : int =
        match path with
        | [] -> 0
        | hd :: tl ->
                match hd with
                | ITM_NODE _ -> indent_of_path doc_settings path - doc_settings.tab_length
                | BLT_NODE -> indent_of_path doc_settings path - doc_settings.tab_length
                | DSP_LINE_NODE _ -> indent_of_path doc_settings path - doc_settings.tab_length
                | NTE_NODE _ -> 0
                |_ -> 0


let insert_label (doc_settings : t_doc_settings) (path : t_path) (s : string) : string =
        match label_of_path_opt doc_settings path with
        | None -> s
        | Some (t : string) -> insert_string t (pos_of_label doc_settings path) s


(* line breaks *)

let lines_of_string_dsp (indent : int) (s : string) : string list =
        let ind : string = String.make indent ' ' in
        [ind ^ s]


let line_break (line_width : int) (s : string) : string list =
        let graphemes : string list = utf_8_grapheme_clusters s in
        let rec aux (remaining_graphemes : string list) (acc_line : (string * string * int) option) (acc_word : (string*int) option) (acc : string list) : string list =
                match remaining_graphemes with
                |[] -> (
                        match acc_line, acc_word with
                        |None,None -> acc
                        |None,Some (w,_) -> w::acc
                        |Some (l,s,_),None -> (l ^ s)::acc
                        |Some (l,s,i), Some (w,j) -> 
                                match i + j < line_width with
                                |true -> (l ^ s ^ w)::acc
                                |false -> w :: (l :: acc)
                )
                |hd::tl -> 
                        match acc_line, acc_word with
                        |None, None -> (
                                match hd with
                                |" " -> aux tl (Some ("", " ", 0)) None acc
                                |_ -> aux tl acc_line (Some (hd, 1)) acc
                        )
                        |None, Some (w,n) -> (
                                match n < line_width with
                                |true -> (
                                        match hd with
                                        |" " -> aux tl (Some (w, " ", n)) None acc
                                        |_ -> aux tl acc_line (Some (w ^ hd, n + 1)) acc
                                )
                                |false -> (
                                        match hd with
                                        |" " -> aux tl (Some (w," ", n)) None acc
                                        |_ -> aux tl acc_line (Some (w ^ hd, n + 1)) acc
                                )
                        )
                        |Some (l,s,n), None -> (
                                match n < line_width with
                                |true -> (
                                        match hd with
                                        |" " -> aux tl (Some (l ^ s," ", n + 1)) acc_word acc
                                        |_ -> aux tl acc_line (Some (hd, 1)) acc
                                )
                                |false -> (
                                        match hd with
                                        |" " -> aux tl None acc_word (l::acc)
                                        |_ -> aux tl None (Some (hd,1)) (l::acc)
                                )
                        )
                        |Some (l,s,i), Some (w,j) -> (
                                match i+j < line_width with
                                |true -> (
                                        match hd with
                                        |" " -> aux tl (Some (l ^ s ^ w, " ", i + j + 1)) None acc
                                        |_ -> aux tl acc_line (Some (w ^ hd, j + 1)) acc
                                )
                                |false -> (
                                        match hd with
                                        |" " -> aux tl (Some (w, " ", j)) None (l::acc)
                                        |_ -> aux tl None (Some (w ^ hd, j + 1)) (l::acc)
                                )
                        )
        in List.rev (aux graphemes None None [])


let lines_of_string (doc_settings : t_doc_settings) (indent : int) (s: string) : string list =
        let line_width : int = doc_settings.doc_width - indent in
        let lines : string list = line_break line_width s in
        let ind : string = String.make indent ' ' in
        let add_ind (t : string) : string = ind ^ t in
        List.map add_ind lines


let underline (s : string) : string =
        let lst = utf_8_grapheme_clusters s in
        let map (el : string) : string = 
                match el with
                |" " -> " "
                |_ -> el ^ "\u{0332}"
        in
        String.concat "" (List.map map lst)

let emph (a : string) : string = underline a


let string_of_tu_txt_unit (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (a : tu_txt_unit) : string =
        match a with
        | Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg (b : string)) -> b
        | Cu_txt_unit_emph (Cs_txt_unit_emph (b : string)) -> emph b
        | Cu_txt_unit_c_ref (Cs_txt_unit_c_ref (b : ts_c_ref)) -> string_of_ts_c_ref doc_settings cref_table path b
        | Cu_txt_unit_nte_ref (Cs_txt_unit_nte_ref (b : ts_nte_ref)) -> string_of_ts_nte_ref doc_settings nte_table path b
        | Cu_txt_unit_nte_inline (Cs_txt_unit_nte_inline (b : ts_nte_inline)) -> string_of_ts_nte_inline doc_settings nte_table path b

let string_of_ts_txt_units (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (a : ts_txt_units) : string =
        match a with Cs_txt_units (b: tu_txt_unit list) ->
        String.concat "" (List.map (string_of_tu_txt_unit doc_settings cref_table nte_table path) b)

let lines_of_ts_txt_units (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (a : ts_txt_units) : string list =
        let lines_of_string_function : int -> string -> string list = (
                match path with
                | [] -> lines_of_string doc_settings
                | hd :: tl -> 
                        match hd with
                        | DSP_LINE_NODE _ -> lines_of_string_dsp
                        | _ -> lines_of_string doc_settings
        )
        in 
        lines_of_string_function (indent_of_path doc_settings path) (string_of_ts_txt_units doc_settings cref_table nte_table path a)


let lines_of_ts_author (doc_settings : t_doc_settings) (author : ts_author) : string list =
        match author with
        |Cs_author (s : string) -> List.concat [lines_of_string doc_settings doc_settings.author_indent s; [""]]


let lines_of_ts_authors (doc_settings : t_doc_settings) (authors : ts_authors) : string list =
        match authors with
        |Cs_authors (author_list : ts_author list) -> List.concat [List.concat (List.map (lines_of_ts_author doc_settings) author_list);]

let lines_of_ts_authors_opt (doc_settings : t_doc_settings) (authors_opt : ts_authors option) : string list =
        match authors_opt with
        |None -> []
        |Some authors -> lines_of_ts_authors doc_settings authors


let lines_of_ts_date_custom (doc_settings : t_doc_settings) (date : ts_date_custom) : string list =
        match date with
        |Cs_date_custom (s : string) -> List.concat [lines_of_string doc_settings doc_settings.author_indent s; [""]]

let lines_of_ts_date_auto (doc_settings : t_doc_settings) (date : ts_date_auto) : string list =
        match Common_utils.time_of_ts_date_auto doc_settings date with
        |None -> []
        |Some time ->
                let format (i : int) : string = Printf.sprintf "%.2i" i in
                let date_string : string = String.concat "-" [format time.year;format time.month;format time.day] in
                let time_string : string = String.concat ":" [format time.hour;format time.minute] in
                let s : string = String.concat " " [date_string;time_string;utc_timezone time.timezone] in
                List.concat [lines_of_string doc_settings doc_settings.author_indent s; [""]]

let lines_of_tu_date (doc_settings : t_doc_settings) (date : tu_date) : string list =
        match date with
        |Cu_date_auto d -> lines_of_ts_date_auto doc_settings d
        |Cu_date_custom d -> lines_of_ts_date_custom doc_settings d

let lines_of_tu_date_opt (doc_settings : t_doc_settings) (date_opt : tu_date option) : string list =
        match date_opt with
        |None -> []
        |Some date -> lines_of_tu_date doc_settings date



let make_string (n:int) (s:string) : string=
        let rec aux (i:int) (acc:string) = 
                if i > n - 1 then acc else aux (i+1) (acc ^ s) 
        in aux 0 ""


let lines_of_ts_hdr (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (hdr : ts_hdr) : string list =
        match hdr with 
        Cs_hdr (txt_units : ts_txt_units) ->
                match path with
                |path_hd::path_tl -> (
                        let indent : string = String.make (doc_settings.left_margin) ' ' in
                        let hdr_string : string = string_of_ts_txt_units doc_settings cref_table nte_table path txt_units in
                        let hdr_lines : string list = lines_of_string doc_settings doc_settings.left_margin hdr_string in
                        match path_hd with
                        |SEC_NODE _ | APP_NODE _ -> (
                                let underline = make_string (Int.min (utf_8_length hdr_string) (doc_settings.doc_width - doc_settings.left_margin)) "─" in
                                match hdr_lines with
                                | hd::tl -> List.concat [[insert_label doc_settings path hd];tl;[indent ^ underline;""]]
                                | [] -> []
                        )
                        |CH_NODE _ ->
                                let label : string = label_of_path doc_settings path in
                                let underline = make_string (Int.min (utf_8_length hdr_string) (doc_settings.doc_width - doc_settings.left_margin)) "═" in
                                List.concat [[indent ^ label]; hdr_lines; [indent ^ underline; ""]]
                        | _ -> []
                )
                |[] -> []

let lines_of_ts_hdr_opt (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (hdr_opt : ts_hdr option) : string list =
        match hdr_opt with
        | Some (hdr : ts_hdr) -> lines_of_ts_hdr doc_settings cref_table nte_table path hdr
        | None ->
                match path with
                | hd::tl -> (
                        match hd with
                        |SEC_NODE _ | APP_NODE _ -> [label_of_path doc_settings path;""]
                        |CH_NODE _ ->
                                let indent : string = String.make (doc_settings.left_margin) ' ' in
                                let label : string = label_of_path doc_settings path in
                                let underline :string = make_string (utf_8_length label) "═" in
                                [indent ^ label; indent ^ underline; ""]
                        | _ -> []
                )
                | [] -> []


let lines_of_ts_title (doc_settings : t_doc_settings) (title : ts_title) : string list =
        match title with
        |Cs_title (s : string) -> 
                let indent : string = String.make doc_settings.title_indent ' ' in
                let overline : string = make_string (doc_settings.doc_width - doc_settings.title_indent) "═" in
                let underline : string = overline in
                List.concat [[indent ^ overline]; lines_of_string doc_settings doc_settings.title_indent s;[indent ^ underline;""]]


let lines_of_ts_title_opt (doc_settings : t_doc_settings) (title_opt : ts_title option) : string list =
        match title_opt with
        |None -> []
        |Some title -> lines_of_ts_title doc_settings title




let lines_of_abstract_hdr (doc_settings : t_doc_settings) (doc_class : t_doc_class) : string list =
        match doc_settings.abstract_hdr with
        |None -> []
        |Some (hdr,_) -> 
                lines_of_string doc_settings doc_settings.abstract_indent hdr

let lines_of_refs_hdr (doc_settings : t_doc_settings) (doc_class : t_doc_class) : string list =
        match doc_settings.refs_hdr with
        |None -> []
        |Some (hdr,_) -> 
        let underline_symbol : string =
                match doc_class with
                |DOC_CHS -> "═"
                | _ -> "─"
        in
        let indent : string = String.make doc_settings.refs_indent ' ' in
        let underline = make_string (Int.min (utf_8_length hdr) (doc_settings.doc_width - doc_settings.refs_indent)) underline_symbol in
        let hdr_lines : string list = lines_of_string doc_settings doc_settings.refs_indent hdr in
        List.concat [hdr_lines;[indent ^ underline;""]]

let lines_of_endnotes_hdr (doc_settings : t_doc_settings) : string list =
        match doc_settings.endnotes_hdr with
        |None -> []
        |Some hdr -> lines_of_string doc_settings 0 hdr

let lines_of_ts_blk_txt (doc_settings : t_doc_settings) (cref_table : t_cref_table) (nte_table : t_nte_table) (path : t_path) (blk_txt : ts_blk_txt) : string list =
        match blk_txt with
        |Cs_blk_txt (txt_units : ts_txt_units) -> List.concat [lines_of_ts_txt_units doc_settings cref_table nte_table path txt_units]


let line_of_vrb_line (doc_settings : t_doc_settings) (path : t_path) (vrb_line : ts_vrb_line) : string =
        match vrb_line with
        |Cs_vrb_line (line:string) -> 
                let indent : string = String.make (indent_of_path doc_settings path) ' ' in
                match line with
                |"" -> ""
                |_ -> String.concat "" [indent;line]


let lines_of_ts_vrb_lines (doc_settings : t_doc_settings) (path : t_path) (vrb_lines : ts_vrb_lines) : string list =
        match vrb_lines with
        |Cs_vrb_lines (vrb_line_list : ts_vrb_line list) ->
                List.map (line_of_vrb_line doc_settings path) vrb_line_list


let lines_of_ts_blk_vrb (doc_settings : t_doc_settings) (path : t_path) (blk_vrb : ts_blk_vrb) : string list =
        match blk_vrb with
        |Cs_blk_vrb (vrb_lines : ts_vrb_lines) -> lines_of_ts_vrb_lines doc_settings path vrb_lines



let max_length_of_margin_labels (margin_labels : string list) : int =
        let rec aux (i : int) (labels : string list) : int =
                match  labels with
                |[] -> i
                |hd::tl -> aux (Int.max i (utf_8_length hd)) tl
        in
        aux 0 margin_labels

let left_margin_of_margin_labels (margin_labels : string list) : int =
        let max_length : int = max_length_of_margin_labels margin_labels in
        if max_length = 0 then 0 else max_length + 2


let special_tag (doc_settings : t_doc_settings) (a : tu_tag_or_id option) : tu_txt_unit option =
        match a with
        |None -> None
        |Some (b : tu_tag_or_id) ->
                match b with
                |Cu_tag_or_id_tag (tag : ts_tag) 
                |Cu_tag_or_id_id { fld_id_tag = (tag : ts_tag); fld_id_name = _ } ->
                        match doc_settings.expand_tag tag with
                        | Some (lbl,_) -> Some (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg lbl))
                        | None -> None

let copy_hdr_to_main (doc_settings : t_doc_settings) (par : tr_par_std): tr_par_std = 
        let space : tu_txt_unit =  Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " ") in
        let lpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg "(") in
        let rpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg ")") in
        match special_tag doc_settings par.fld_par_tag_or_id, par.fld_par_hdr, par.fld_par_main with
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


