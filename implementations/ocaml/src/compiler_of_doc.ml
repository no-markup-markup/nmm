open Doc_types
open Common_utils
open Txt_utils
open Exml_utils

exception Error of string

type t_acc =
  |CREF_TABLE of t_cref_table
  |LINES of (string list)
  |EXML of (Xml.xml list)
  |MARGIN_LABELS of (string list)
  |NTE_TABLE of t_nte_table

(* blks *)

let add_empty_lines_after_blk
  (tl : tu_blk list)
  (acc : t_acc)
  : t_acc =
  match tl, acc with
  |_::_, LINES lines -> LINES (List.concat [lines;[""]])
  |_, _ -> acc


let rec acc_of_ts_blks
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (blks : ts_blks)
  : t_acc =
  let new_doc_settings =
    Common_utils.doc_settings_of_ts_blks
    doc_settings (lvl_of_path path)
    blks
  in
  let rec aux
    (auto_nr : int)
    (a : t_acc)
    (blk_list : tu_blk list)
    : t_acc =
    match blk_list with
    |[] -> a
    |hd :: tl ->
      match
        acc_of_tu_blk
        new_doc_settings cref_table nte_table auto_nr path a
        hd
      with
      |(b : t_acc), (auto_nr : int) ->
        aux auto_nr (add_empty_lines_after_blk tl b) tl
  in
  match blks with
  |Cs_blks (blk_list : tu_blk list) ->
    match acc with
    |LINES _ ->
      let filter (blk : tu_blk) : tu_blk option =
        match blk with
          |Cu_blk_nte _ -> None
          |_ -> Some blk
      in
      let filtered_blk_list : tu_blk list =
        List.filter_map filter blk_list
      in
      aux 0 acc filtered_blk_list
    |CREF_TABLE _
    |EXML _
    |MARGIN_LABELS _
    |NTE_TABLE _ -> aux 0 acc blk_list


and acc_of_tu_blk
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (auto_nr : int)
  (path : t_path)
  (acc : t_acc)
  (blk : tu_blk)
  : t_acc * int =
  match blk with
  |Cu_blk_itm (blk_itm : tr_blk_itm) ->
    let node : t_node =
      Common_utils.node_of_blk_itm
      doc_settings path auto_nr blk_itm
    in
    let next_auto_nr =
      match blk_itm.fld_blk_itm_lbl with 
      |Cu_lbl_auto Cs_lbl_auto -> auto_nr + 1
      | _ -> auto_nr
    in
    acc_of_tr_blk_itm
    doc_settings cref_table nte_table (node :: path) acc blk_itm,
    next_auto_nr
  |Cu_blk_dsp (blk_dsp : ts_blk_dsp) ->
    acc_of_ts_blk_dsp
    doc_settings cref_table nte_table auto_nr (DSP_NODE :: path) acc 
    blk_dsp
  |Cu_blk_txt (blk_txt : ts_blk_txt) ->
    acc_of_ts_blk_txt
    doc_settings cref_table nte_table path acc
    blk_txt,
    auto_nr
  |Cu_blk_blt (blk_blt : ts_blk_blt) ->
    acc_of_ts_blk_blt
    doc_settings cref_table nte_table (BLT_NODE :: path) acc
    blk_blt,
    auto_nr
  |Cu_blk_vrb (blk_vrb : ts_blk_vrb) ->
    acc_of_ts_blk_vrb
    doc_settings path acc
    blk_vrb,
    auto_nr
  |Cu_blk_nte (blk_nte : tr_blk_nte) ->
    acc_of_tr_blk_nte
    doc_settings cref_table path acc
    blk_nte,
    auto_nr
  |Cu_blk_qtn (blk_qtn : ts_blk_qtn) ->
    acc_of_ts_blk_qtn
    doc_settings path acc
    blk_qtn,
    auto_nr


(* blk_qtn *)

and acc_of_ts_blk_qtn
  (doc_settings : t_doc_settings)
  (path : t_path)
  (acc : t_acc)
  (blk_qtn : ts_blk_qtn)
  : t_acc =
  match acc with
  |MARGIN_LABELS _
  |CREF_TABLE _ 
  |NTE_TABLE _ -> acc
  |LINES acc_lines ->
    let lines : string list =
      Txt_utils.lines_of_ts_blk_qtn
      doc_settings path
      blk_qtn
    in
    LINES (List.concat [acc_lines; lines])
  |EXML acc_list ->
    let exml : Xml.xml =
      Exml_utils.xml_of_ts_blk_qtn blk_qtn
    in
    EXML (List.concat [acc_list; [exml]])


(* blk_txt *)

and acc_of_ts_blk_txt
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (blk_txt : ts_blk_txt)
  : t_acc =
  match acc with
  |MARGIN_LABELS _
  |CREF_TABLE _ -> acc
  |LINES acc_lines ->
    let lines : string list =
      Txt_utils.lines_of_ts_blk_txt
      doc_settings cref_table nte_table path
      blk_txt
    in
    LINES (List.concat [acc_lines; lines])
  |EXML acc_list ->
    let exml : Xml.xml =
      Exml_utils.xml_of_ts_blk_txt
      doc_settings cref_table nte_table path
      blk_txt
    in
    EXML (List.concat [acc_list; [exml]])
  |NTE_TABLE acc_table -> NTE_TABLE (
    Common_utils.nte_table_of_ts_blk_txt
    doc_settings cref_table path acc_table
    blk_txt
  )


(* blk_dsp *)

and acc_of_ts_blk_dsp
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (auto_nr : int)
  (path : t_path)
  (acc : t_acc)
  (blk_dsp : ts_blk_dsp)
  : t_acc * int =
  let rec aux
    (auto_nr : int)
    (a : t_acc)
    (dsp_line_list : tr_dsp_line list) 
    : t_acc * int = (
    match dsp_line_list with
    |[] -> a, auto_nr
    |hd :: tl ->
      let node : t_node =
        Common_utils.node_of_dsp_line doc_settings
        path auto_nr hd
      in
      let next_auto_nr =
        match hd.fld_dsp_line_lbl with 
        |Some (Cu_lbl_auto Cs_lbl_auto) -> auto_nr + 1 
        |_ -> auto_nr
      in
      let b : t_acc =
        acc_of_tr_dsp_line
        doc_settings cref_table nte_table (node :: path) a
        hd
      in
      aux next_auto_nr b tl
  )
  in
  match blk_dsp with
  |Cs_blk_dsp (dsp_lines : ts_dsp_lines) ->
    match dsp_lines with
    |Cs_dsp_lines (dsp_line_list : tr_dsp_line list) ->
      match acc with
      |MARGIN_LABELS _ -> acc, auto_nr
      |CREF_TABLE _
      |NTE_TABLE _ -> aux auto_nr acc dsp_line_list
      |LINES acc_lines -> (
        match aux auto_nr (LINES []) dsp_line_list with 
        |LINES lines, nr ->
          LINES (List.concat [acc_lines;lines]), nr
        |_ -> raise (Error "accumulator type")
      )
      |EXML acc_list -> (
         match aux auto_nr (EXML []) dsp_line_list with 
         |EXML xml_list, nr ->
           let exml : Xml.xml =
             Xml.Element ("blk_dsp",[],xml_list)
           in
           EXML (List.concat [acc_list;[exml]]), nr
         |_ -> raise (Error "accumulator type")
      )

and acc_of_tr_dsp_line
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (dsp_line : tr_dsp_line)
  : t_acc =
  match acc with
  |MARGIN_LABELS _ -> acc
  |CREF_TABLE table -> (
    match dsp_line.fld_dsp_line_id with
    |Some (id : tr_id) ->
      CREF_TABLE (
        (id, path, Cref_element_dsp_line dsp_line) :: table
      )
    |None -> acc
  )
  |LINES acc_lines ->
    let lines : string list =
      Txt_utils.lines_of_tr_dsp_line
      doc_settings cref_table nte_table path
      dsp_line
    in
    LINES (List.concat [acc_lines; lines])
  |EXML acc_list ->
    let exml : Xml.xml =
      Exml_utils.xml_of_tr_dsp_line
      doc_settings cref_table nte_table path
      dsp_line
    in
    EXML (List.concat [acc_list; [exml]])
  |NTE_TABLE acc_table ->
    let table : t_nte_table =
      Common_utils.nte_table_of_tr_dsp_line
      doc_settings cref_table path acc_table
      dsp_line
    in
    NTE_TABLE table

(* blk_vrb *)

and acc_of_ts_blk_vrb 
  (doc_settings : t_doc_settings)
  (path : t_path)
  (acc : t_acc)
  (blk_vrb : ts_blk_vrb)
  : t_acc =
  match acc with
  |NTE_TABLE _
  |MARGIN_LABELS _
  |CREF_TABLE _ -> acc
  |LINES acc_lines ->
    let lines : string list =
      Txt_utils.lines_of_ts_blk_vrb doc_settings path blk_vrb
    in
    LINES (List.concat [acc_lines; lines])
  |EXML acc_list ->
    let exml : Xml.xml =
      Exml_utils.xml_of_ts_blk_vrb blk_vrb
    in
    EXML (List.concat [acc_list; [exml]])


(* blk_nte *)

and paths_match (path : t_path) (table_path : t_path) : bool =
  match List.rev path, List.rev table_path with
  |[], _ -> true
  |(CH_NODE path_ch)::[],
   (CH_NODE table_ch)::_ -> path_ch = table_ch
  |(SEC_NODE path_sec)::[],
   (SEC_NODE table_sec)::_ -> path_sec = table_sec
  |(APP_NODE path_app)::[],
   (APP_NODE table_app)::_ -> path_app = table_app 
  |(PAR_NODE path_par)::[],
   (PAR_NODE table_par)::_ -> path_par = table_par
  |(CH_NODE path_ch)::((SEC_NODE path_sec)::[]),
   (CH_NODE table_ch)::((SEC_NODE table_sec)::_) ->
      path_ch = table_ch && path_sec = table_sec
  |(CH_NODE path_ch)::((APP_NODE path_app)::[]),
   (CH_NODE table_ch)::((APP_NODE table_app)::_) ->
      path_ch = table_ch && path_app = table_app
  |(CH_NODE path_ch)::((PAR_NODE path_par)::[]),
   (CH_NODE table_ch)::((PAR_NODE table_par)::_) ->
      path_ch = table_ch && path_par = table_par
  |(CH_NODE path_ch)::((SEC_NODE path_sec)::(PAR_NODE path_par::[])),
   (CH_NODE table_ch)::((SEC_NODE table_sec)::(PAR_NODE table_par::_)) ->
      path_ch = table_ch && path_sec = table_sec && path_par = table_par
  |(CH_NODE path_ch)::((APP_NODE path_app)::(PAR_NODE path_par::[])),
   (CH_NODE table_ch)::((APP_NODE table_app)::(PAR_NODE table_par::_)) ->
      path_ch = table_ch && path_app = table_app && path_par = table_par
  |((SEC_NODE path_sec)::(PAR_NODE path_par::[])),
   ((SEC_NODE table_sec)::(PAR_NODE table_par::_)) ->
      path_sec = table_sec && path_par = table_par
  |((APP_NODE path_app)::(PAR_NODE path_par::[])),
   ((APP_NODE table_app)::(PAR_NODE table_par::_)) ->
      path_app = table_app && path_par = table_par
  |REFS_NODE::_, REFS_NODE::_ -> true
  |ABSTRACT_NODE::_, ABSTRACT_NODE::_ -> true
  |_, _ -> false

and acc_of_tr_blk_nte
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (path : t_path)
  (acc : t_acc)
  (blk_nte : tr_blk_nte)
  : t_acc =
  match acc with
  |CREF_TABLE table ->
    CREF_TABLE (
      (
        blk_nte.fld_blk_nte_id,
        path,
        Cref_element_blk_nte blk_nte
      ) :: table
    )
  |_ -> acc

and lines_of_nte_blks
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (path : t_path)
  (blks : ts_blks)
  : string list =
  let new_cref_table =
    match
      acc_of_ts_blks
      doc_settings [] [] path (CREF_TABLE cref_table)
      blks
    with
    |CREF_TABLE table -> table
    |_ -> raise (Error "accumulator type")
  in
  match
    acc_of_ts_blks
    doc_settings new_cref_table [] path (LINES [])
    blks
  with
  |LINES lines -> (
    match lines with
    |hd :: tl -> (insert_label doc_settings path hd)::tl
    |[] -> []
  )
  |_ -> raise (Error "accumulator type")


and lines_of_nte_table
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (path : t_path)
  (nte_table : t_nte_table)
  : string list =
  let map (nte_entry : t_nte_entry) : (string list) option =
    match nte_entry with
    |Ftn_entry_ref (_, table_path, n, blk_nte) -> (
      match paths_match path table_path with
      |true -> Some (
          lines_of_nte_blks doc_settings cref_table
          ((NTE_NODE n)::path) blk_nte.fld_blk_nte_main
      )
      |false -> None
    )
    |Ftn_entry_inline (Cs_nte_inline (blks,_), table_path, n) -> (
      match paths_match path table_path with
        |true -> Some (
          lines_of_nte_blks doc_settings cref_table
          ((NTE_NODE n)::path) blks
        )
        |false -> None
    )
  in
  let rec aux1
    (table : t_nte_table)
    (acc : string list list)
    : string list list =
    match table with
    |[] -> acc
    |hd::tl ->
      match map hd with
      |None -> aux1 tl acc
      |Some lst -> aux1 tl (lst::acc)
  in
  let endnote_list : string list list = List.rev (aux1 nte_table []) in
  let rec aux2
    (string_list_list : string list list)
    (acc : string list)
    : string list =
    match string_list_list with
    |[] -> acc
    |hd::[] -> List.concat [hd;acc]
    |hd::tl -> aux2 tl (List.concat [[""];hd;acc])
  in
  let endnotes : string list = aux2 endnote_list [] in
  let hdr_lines : string list =
    lines_of_endnotes_hdr doc_settings path
  in
  match endnotes with
  |[] -> []
  |_ ->
    let indent : int = indent_of_path doc_settings path in
    let overline : string =
      String.concat "" [
        make_string indent " ";
        make_string (doc_settings.doc_width - indent) "─";
      ]
    in
    match hdr_lines with
     |[] -> List.concat [["";overline];endnotes]
     |_::_ -> List.concat [["";overline];hdr_lines;[""];endnotes]


and xml_of_blk_nte_inline
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (path : t_path)
  (nte_inline : ts_nte_inline)
  : Xml.xml =
  match nte_inline with
  |Cs_nte_inline (blks,Cs_int i) ->
    let new_cref_table =
      match
        acc_of_ts_blks
        doc_settings [] [] path (CREF_TABLE cref_table)
        blks
      with
      |CREF_TABLE table -> table
      |_ -> raise (Error "accumulator type")
    in
    let xml_list_main : Xml.xml list = 
      match
        acc_of_ts_blks
        doc_settings new_cref_table [] path (EXML [])
        blks
      with
      |EXML xml_list -> xml_list
      |_ -> raise (Error "accumulator type")
    in
    let addendum : string = string_of_int i in
    let attr_list : (string * string) list =
      [("id","NTE" ^ addendum)]
    in
    let xml_list_lbl : Xml.xml list =
      [xml_of_string (label_of_path doc_settings path)]
    in
    let attr_list_lbl : (string * string) list =
      match attr_list with
        |[("id",s)] -> [("href","#ref_" ^ s)]
        |_ -> []
    in
    let xml_lbl : Xml.xml =
      Xml.Element ("blk_nte_lbl", attr_list_lbl, xml_list_lbl)
    in
    let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
    let xml_main : Xml.xml =
      Xml.Element ("blk_nte_main",[],xml_list_main)
    in
    Xml.Element ("blk_nte",attr_list,[xml_lbl;xml_clear;xml_main])


and xml_of_blk_nte_ref
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (path : t_path)
  (nte_ref : ts_nte_ref)
  (blk_nte : tr_blk_nte)
  : Xml.xml =
  let new_cref_table =
    match
      acc_of_ts_blks
      doc_settings [] [] path (CREF_TABLE cref_table)
      blk_nte.fld_blk_nte_main
    with
    |CREF_TABLE table -> table
    |_ -> raise (Error "accumulator type")
  in
  let xml_list_main : Xml.xml list = 
    match
      acc_of_ts_blks
      doc_settings new_cref_table [] path (EXML [])
      blk_nte.fld_blk_nte_main
    with
    |EXML xml_list -> xml_list
    |_ -> raise (Error "accumulator type")
  in
  let addendum : string =
    match nte_ref with
    |Cs_nte_ref (id, Cs_int i) -> string_of_int i
  in
  let attr_list : (string * string) list =
    match
      attr_list_of_tr_id
      doc_settings path
      blk_nte.fld_blk_nte_id
    with
    |[("id",s)] -> [("id",s ^ "_" ^ addendum)]
    |_ -> []
  in
  let xml_list_lbl:Xml.xml list =
    [xml_of_string (label_of_path doc_settings path)]
  in
  let attr_list_lbl : (string * string) list =
    match attr_list with
    |[("id",s)] -> [("href","#ref_" ^ s)]
    |_ -> []
  in
  let xml_lbl : Xml.xml =
    Xml.Element ("blk_nte_lbl", attr_list_lbl, xml_list_lbl)
  in
  let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
  let xml_main : Xml.xml =
    Xml.Element ("blk_nte_main",[],xml_list_main)
  in
  Xml.Element ("blk_nte",attr_list,[xml_lbl;xml_clear;xml_main])


and xml_of_nte_table_opt
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (path : t_path)
  (nte_table : t_nte_table)
  : Xml.xml option =
  let map (nte_entry : t_nte_entry) : Xml.xml option =
    match nte_entry with
    |Ftn_entry_ref (nte_ref, table_path, n, blk_nte) -> (
      match paths_match path table_path with
      |true -> Some (
        xml_of_blk_nte_ref
        doc_settings cref_table ((NTE_NODE n)::path) nte_ref
        blk_nte
      )
      |false -> None
    )
    |Ftn_entry_inline (nte_inline, table_path, n) -> (
      match paths_match path table_path with
        |true -> Some (
          xml_of_blk_nte_inline
          doc_settings cref_table ((NTE_NODE n)::path)
          nte_inline
        )
        |false -> None
    )
  in
  let rec aux
    (table : t_nte_table)
    (acc : Xml.xml list)
    : Xml.xml list = 
    match table with
    |[] -> acc
    |hd::tl ->
      match map hd with
      |None -> aux tl acc
      |Some xml -> aux tl (xml::acc)
  in
  let xml_list : Xml.xml list = aux nte_table [] in
  let xml_hdr_opt : Xml.xml option = 
    match doc_settings.endnotes_hdr, path with
    |Some hdr, [] -> Some (
      Xml.Element ("doc_endnotes_hdr",[],[xml_of_string hdr])
    )
    |Some hdr, (CH_NODE _)::_ -> Some (
      Xml.Element ("ch_endnotes_hdr",[],[xml_of_string hdr])
    )
    |Some hdr, (SEC_NODE _)::_ -> Some (
      Xml.Element ("sec_endnotes_hdr",[],[xml_of_string hdr])
    )
    |Some hdr, (APP_NODE _)::_ -> Some (
      Xml.Element ("app_endnotes_hdr",[],[xml_of_string hdr])
    )
    |Some hdr, (PAR_NODE _)::_ -> Some (
      Xml.Element ("par_endnotes_hdr",[],[xml_of_string hdr])
    )
    |Some hdr, ABSTRACT_NODE::_ -> Some (
      Xml.Element ("abstract_endnotes_hdr",[],[xml_of_string hdr])
    )
    |Some hdr, REFS_NODE::_ -> Some (
      Xml.Element ("refs_endnotes_hdr",[],[xml_of_string hdr])
    )
    |_, _ -> None
  in
  match xml_hdr_opt, xml_list, path with
  |Some hdr, _::_, [] -> Some (
    Xml.Element ("doc_endnotes", [], hdr::xml_list)
  )
  |None, _::_, [] -> Some (
    Xml.Element ("doc_endnotes", [], xml_list)
  )
  |Some hdr, _::_, (CH_NODE _)::_ -> Some (
    Xml.Element ("ch_endnotes", [], hdr::xml_list)
  )
  |None, _::_, (CH_NODE _)::_ -> Some (
    Xml.Element ("ch_endnotes", [], xml_list)
  )
  |Some hdr, _::_, (SEC_NODE _)::_ -> Some (
    Xml.Element ("sec_endnotes", [], hdr::xml_list)
  )
  |None, _::_, (SEC_NODE _)::_ -> Some (
    Xml.Element ("sec_endnotes", [], xml_list)
  )
  |None, _::_, (APP_NODE _)::_ -> Some (
    Xml.Element ("app_endnotes", [], xml_list)
  )
  |Some hdr, _::_, (APP_NODE _)::_ -> Some (
    Xml.Element ("app_endnotes", [], hdr::xml_list)
  )
  |None, _::_, (PAR_NODE _)::_ -> Some (
    Xml.Element ("par_endnotes", [], xml_list)
  )
  |Some hdr, _::_, (PAR_NODE _)::_ -> Some (
    Xml.Element ("par_endnotes", [], hdr::xml_list)
  )
  |None, _::_, ABSTRACT_NODE::_ -> Some (
    Xml.Element ("abstract_endnotes", [], xml_list)
  )
  |Some hdr, _::_, ABSTRACT_NODE::_ -> Some (
    Xml.Element ("abstract_endnotes", [], hdr::xml_list)
  )
  |None, _::_, REFS_NODE::_ -> Some (
    Xml.Element ("refs_endnotes", [], xml_list)
  )
  |Some hdr, _::_, REFS_NODE::_ -> Some (
    Xml.Element ("refs_endnotes", [], hdr::xml_list)
  )
  |_, _, _ -> None


(* blk_itm *)

and acc_of_tr_blk_itm 
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (blk_itm : tr_blk_itm)
  : t_acc =
  match acc with
  |NTE_TABLE _ ->
    acc_of_ts_blks
    doc_settings cref_table nte_table path acc
    blk_itm.fld_blk_itm_main
  |MARGIN_LABELS _ -> acc
  |CREF_TABLE table ->
    let new_acc : t_acc = CREF_TABLE (
      match blk_itm.fld_blk_itm_tag_or_id with
      |Some (tag_or_id : tu_tag_or_id) -> (
        match tag_or_id with
        |Cu_tag_or_id_id id -> 
          (id, path, Cref_element_blk_itm blk_itm) :: table
        |Cu_tag_or_id_tag _ -> table
      )
      |None -> table
    )
    in
    acc_of_ts_blks
    doc_settings cref_table nte_table path new_acc
    blk_itm.fld_blk_itm_main
  |LINES acc_lines -> (
    match
      acc_of_ts_blks
      doc_settings cref_table nte_table path (LINES [])
      blk_itm.fld_blk_itm_main
    with
    |LINES (lines : string list) ->
      let head : string = List.hd lines in
      let newhead : string =
        Txt_utils.insert_label doc_settings path head
      in
      let newlines : string list = newhead :: List.tl lines in
        LINES (List.concat [ acc_lines; newlines ])
    |_ -> raise (Error "accumulator type")
  )
  |EXML acc_list ->
    let xml_list_main =
      match
        acc_of_ts_blks
        doc_settings cref_table nte_table path (EXML [])
        blk_itm.fld_blk_itm_main
      with
      |EXML xml_list_blks -> xml_list_blks
      |_ -> raise (Error "accumulator type")
    in 
    let xml_list_lbl:Xml.xml list =
      [Exml_utils.xml_of_string (label_of_path doc_settings path)]
    in
    let xml_main : Xml.xml =
      Xml.Element ("blk_itm_main",[],xml_list_main)
    in
    let xml_lbl : Xml.xml =
      Xml.Element ("blk_itm_lbl",[],xml_list_lbl)
    in
    let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
    let classes : string list =
      match path with
      |(ITM_NODE (ITM_BIB_CUSTOM _))::_ -> ["bib_custom"]
      |_ -> []
    in
    let attr_list : (string * string) list =
      Exml_utils.attr_list_of_tu_tag_or_id_opt
      doc_settings path ("blk"::("itm"::classes))
      blk_itm.fld_blk_itm_tag_or_id
    in
    let exml : Xml.xml =
      Xml.Element ("blk_itm", attr_list, [xml_lbl;xml_clear;xml_main])
    in
    EXML (List.concat [acc_list;[exml]])


(* blk_blt *)

and acc_of_ts_blk_blt
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (blk_blt : ts_blk_blt)
  : t_acc =
  match blk_blt with
  |Cs_blk_blt (blks : ts_blks) ->
    match acc with
    |MARGIN_LABELS _ -> acc
    |NTE_TABLE _ 
    |CREF_TABLE _ ->
      acc_of_ts_blks
      doc_settings cref_table nte_table path acc
      blks
    |LINES acc_lines -> (
      match
        acc_of_ts_blks
        doc_settings cref_table nte_table path (LINES [])
        blks
      with
      |LINES ((lines_hd::lines_tl) : string list) -> (
        let new_head : string =
          Txt_utils.insert_label doc_settings path lines_hd
        in
        let new_lines : string list =
          new_head :: lines_tl
        in
        LINES (List.concat [acc_lines; new_lines])
      )
      |LINES [] -> raise (Error "blk_blt empty")
      |_ -> raise (Error "accumulator type")
    )
    |EXML acc_list ->
      let xml_list_main:Xml.xml list = (
        match
          acc_of_ts_blks
          doc_settings cref_table nte_table path (EXML [])
          blks
        with
        |EXML xml_list_blks -> xml_list_blks
        |_ -> raise (Error "accumulator type")
      )
      in 
      let xml_list_lbl:Xml.xml list =
        [Exml_utils.xml_of_string (label_of_path doc_settings path)]
      in
      let xml_main:Xml.xml =
        Xml.Element ("blk_blt_main",[],xml_list_main)
      in
      let xml_lbl:Xml.xml =
        Xml.Element ("blk_blt_lbl",[],xml_list_lbl)
      in
      let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
      let exml : Xml.xml =
        Xml.Element ("blk_blt",[],[xml_lbl;xml_clear;xml_main])
      in
      EXML (List.concat [acc_list;[exml]])


(* pars *)

let acc_of_par_main
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (blks : ts_blks)
  : t_acc =
  acc_of_ts_blks doc_settings cref_table nte_table path acc blks


let acc_of_tr_par_std
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (path_origin : t_path)
  (acc : t_acc)
  (par_std : tr_par_std)
  : t_acc =
  match acc with
  |NTE_TABLE acc_table -> (
    let table_hdr : t_nte_table =
      Common_utils.nte_table_of_ts_hdr_opt
      doc_settings cref_table path []
      par_std.fld_par_hdr
    in
    match
      acc_of_par_main
      doc_settings cref_table nte_table path (NTE_TABLE table_hdr)
      par_std.fld_par_main
    with
    |NTE_TABLE table -> NTE_TABLE (List.concat [table;acc_table])
    | _ -> raise (Error "accumulator type")
  )
  |MARGIN_LABELS string_list ->
    MARGIN_LABELS ((label_of_path doc_settings path)::string_list)
  |CREF_TABLE table ->
    let newacc : t_acc = CREF_TABLE (
      match par_std.fld_par_tag_or_id with
      |Some (Cu_tag_or_id_id (id : tr_id)) ->
        (id, path, Cref_element_par par_std) :: table
      |_ -> table
    )
    in
    acc_of_ts_blks doc_settings cref_table nte_table
    path newacc par_std.fld_par_main
  |LINES acc_lines -> (
    let new_par =
      Txt_utils.copy_hdr_to_main doc_settings par_std
    in
    let lines_endnotes : string list =
      lines_of_nte_table
      doc_settings cref_table path
      nte_table
    in
    match
      acc_of_ts_blks
      doc_settings cref_table nte_table path_origin (LINES [])
      new_par.fld_par_main
    with
    |LINES (hd::tl) -> LINES (
      List.concat [
        acc_lines;
        [Txt_utils.insert_label doc_settings path hd];
        tl;lines_endnotes
      ]
    )
    |_ -> raise (Error "par_main empty")
  )
  |EXML acc_list ->
    let xml_list_hdr_opt : (Xml.xml list) option =
      Exml_utils.par_hdr_opt
      doc_settings cref_table nte_table path_origin 
      par_std.fld_par_tag_or_id
      par_std.fld_par_hdr
    in
    let xml_list_lbl : Xml.xml list =
      [Exml_utils.xml_of_string (label_of_path doc_settings path)]
    in
    let xml_lbl : Xml.xml = 
      match xml_list_hdr_opt with
      |None -> Xml.Element ("par_lbl_hdr",[],xml_list_lbl)
      |Some _ -> Xml.Element ("par_lbl",[],xml_list_lbl)
    in
    let xml_clear : Xml.xml = Xml.Element ("clear",[],[]) in
    let xml_main : Xml.xml =
      match
        acc_of_par_main
        doc_settings cref_table nte_table path_origin (EXML [])
        par_std.fld_par_main
      with
      |EXML xml_list -> (
        match xml_list_hdr_opt with
        |None -> Xml.Element ("par_main",[],xml_list)
        |Some xml_list_hdr ->
          Xml.Element (
            "par_main_w_hdr",[],List.concat [xml_list_hdr;xml_list]
          )
      )
      | _ -> raise (Error "accumulator type")
    in
    let attr_list : (string*string) list =
      Exml_utils.attr_list_of_tu_tag_or_id_opt
      doc_settings path ["par"]
      par_std.fld_par_tag_or_id 
    in
    let exml : Xml.xml =
      match
        xml_of_nte_table_opt
        doc_settings cref_table path
        nte_table
      with
      |None ->
        Xml.Element ("par",attr_list,[xml_lbl;xml_clear;xml_main])
      |Some endnotes ->
        Xml.Element (
          "par", attr_list,[xml_lbl;xml_clear;xml_main;endnotes]
        )
    in
    EXML (List.concat [acc_list;[exml]])

let acc_of_tu_par
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (par : tu_par)
  : t_acc =
  match par with
  |Cu_par_std (par_std : tr_par_std) ->
    acc_of_tr_par_std
    doc_settings cref_table nte_table path path acc
    par_std
  |Cu_par_rpt (Cs_par_rpt (id : tr_id)) ->
    match acc with
    |MARGIN_LABELS string_list ->
      MARGIN_LABELS ((label_of_path doc_settings path)::string_list)
    |NTE_TABLE _
    |CREF_TABLE _ -> acc
    |_ -> 
      match
        par_restated_of_tr_id
        doc_settings cref_table path
        id
      with
      |Some ((par_std : tr_par_std), (path_origin : t_path)) ->
        acc_of_tr_par_std
        doc_settings cref_table nte_table path path_origin acc
        par_std
      |None ->
        let _ : unit =
          IO.print_warning (
            String.concat "" [
              "WARNING: failed to restate paragraph with id \'";
              string_of_tr_id id;"\' in ";
              string_of_path doc_settings path;
            ]
          )
        in
        acc


let add_empty_lines_after_par (tl : tu_par list) (acc : t_acc) : t_acc =
  match tl, acc with
  |_::_, LINES lines -> LINES (List.concat [lines;["";""]])
  |_, _ -> acc


let acc_of_ts_pars
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (pars : ts_pars)
  : t_acc =
  let rec aux
    (par_nr : int)
    (a : t_acc)
    (par_list : tu_par list)
    : t_acc =
    match par_list with
    |[] -> a
    |hd :: tl ->
      let new_path : t_path =
        (Common_utils.node_of_tu_par doc_settings par_nr hd):: path
      in
      let new_acc : t_acc =
        add_empty_lines_after_par
        tl
        (acc_of_tu_par doc_settings cref_table nte_table new_path a hd)
      in
      aux (par_nr + 1) new_acc tl
  in 
  match pars with
  |Cs_pars (par_list : tu_par list) -> aux 0 acc par_list


(* secs *)

let acc_of_sec_main
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (pars_or_blks : tu_pars_or_blks)
  : t_acc =
  match pars_or_blks with
  | Cu_pars_or_blks_pars (pars : ts_pars) ->
    acc_of_ts_pars doc_settings cref_table nte_table path acc pars
  | Cu_pars_or_blks_blks (blks : ts_blks) ->
    acc_of_ts_blks doc_settings cref_table nte_table path acc blks


let acc_of_tr_sec
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (sec : tr_sec)
  : t_acc =
  match acc with
  |NTE_TABLE acc_table -> (
    let table_hdr : t_nte_table =
      Common_utils.nte_table_of_ts_hdr_opt
      doc_settings cref_table path []
      sec.fld_sec_hdr
    in
    match
      acc_of_sec_main
      doc_settings cref_table nte_table path (NTE_TABLE table_hdr)
      sec.fld_sec_main
    with
    |NTE_TABLE table ->
      NTE_TABLE (List.concat [table;acc_table])
    | _ -> raise (Error "accumulator type")
  )
  |MARGIN_LABELS string_list ->
    acc_of_sec_main
    doc_settings cref_table nte_table path
    (MARGIN_LABELS ((label_of_path doc_settings path)::string_list))
    sec.fld_sec_main
  |CREF_TABLE table ->
    let newacc : t_acc = CREF_TABLE (
      match sec.fld_sec_tag_or_id with
      |Some (Cu_tag_or_id_id (id : tr_id)) ->
        (id, path, Cref_element_sec sec) :: table
      |_ -> table
    )
    in 
    acc_of_sec_main
    doc_settings cref_table nte_table path newacc
    sec.fld_sec_main
  |LINES acc_lines -> (
    let lines : string list =
      match sec.fld_sec_hdr, sec.fld_sec_main with
      |None, Cu_pars_or_blks_blks _ -> (
        match
          acc_of_sec_main
          doc_settings cref_table nte_table path (LINES [])
          sec.fld_sec_main
        with
        |LINES (hd::tl) ->
          (insert_label doc_settings path hd)::tl
        |LINES [] -> raise (Error "sec empty")
        |_ -> raise (Error "accumulator type")
      )
      |_, _ -> (
        let lines_hdr : string list =
          Txt_utils.lines_of_ts_hdr_opt
          doc_settings cref_table nte_table path
          sec.fld_sec_hdr
        in
        match
          acc_of_sec_main
          doc_settings cref_table nte_table path (LINES [])
          sec.fld_sec_main
        with
        |LINES lines_main -> List.concat [lines_hdr;lines_main]
        | _ -> raise (Error "accumulator type")
      )
    in
    let lines_endnotes : string list =
      match sec.fld_sec_main with
      |Cu_pars_or_blks_blks _ ->
        lines_of_nte_table
        doc_settings cref_table path
        nte_table
      |_ -> []
    in
    LINES (List.concat [acc_lines;lines;lines_endnotes])
  )
  |EXML acc_list -> 
    let xml_list_main : Xml.xml list =
      match
        acc_of_sec_main
        doc_settings cref_table nte_table path (EXML [])
        sec.fld_sec_main
      with
      |EXML xml_list -> xml_list
      | _ -> raise (Error "accumulator type")
    in
    let xml_list_lbl : Xml.xml list =
      [Exml_utils.xml_of_string (label_of_path doc_settings path)]
    in
    let xml_hdr:Xml.xml =
      match sec.fld_sec_hdr with
      |None -> 
         Xml.Element ("sec_lbl_hdr",[],xml_list_lbl)
      |Some (hdr : ts_hdr) -> 
        match hdr with
        |Cs_hdr (txt_lines : ts_txt_lines) ->
          Xml.Element (
            "sec_hdr",[],
            xml_list_of_ts_txt_lines
            doc_settings cref_table nte_table path
            txt_lines
          )
    in
    let xml_main : Xml.xml =
      Xml.Element ("sec_main",[],xml_list_main)
    in
    let xml_lbl : Xml.xml =
      Xml.Element ("sec_lbl",[],xml_list_lbl)
    in
    let xml_endnotes_opt : Xml.xml option = 
      match
        sec.fld_sec_main,
        xml_of_nte_table_opt doc_settings cref_table path nte_table
    with
    |Cu_pars_or_blks_blks _, Some xml_endnotes ->
      Some xml_endnotes
    |_,_ -> None
  in
  let sec_class : string = 
    match sec.fld_sec_main with
    |Cu_pars_or_blks_blks _ -> "blks"
    |Cu_pars_or_blks_pars _ -> "pars"
  in
  let attr_list : (string*string) list =
    Exml_utils.attr_list_of_tu_tag_or_id_opt
    doc_settings path ["sec";sec_class]
    sec.fld_sec_tag_or_id
  in
  let exml : Xml.xml =
    match sec.fld_sec_hdr, xml_endnotes_opt with
    |None, None ->
      Xml.Element ("sec", attr_list, [xml_hdr;xml_main])
    |Some _, None ->
      Xml.Element ("sec", attr_list, [xml_lbl;xml_hdr;xml_main])
    |None, Some endnotes ->
      Xml.Element ("sec", attr_list, [xml_hdr;xml_main;endnotes])
    |Some _, Some endnotes ->
      Xml.Element ("sec", attr_list,[xml_lbl;xml_hdr;xml_main;endnotes])
  in EXML (List.concat [acc_list; [exml]])


let add_empty_lines_after_sec (tl : tr_sec list) (acc : t_acc) : t_acc =
  match tl, acc with
  |_::_, LINES lines -> LINES (List.concat [lines; [""; ""; ""]])
  |_, _ -> acc

let is_appendix (sec : tr_sec) : bool =
  match sec.fld_sec_tag_or_id with
  |None -> false
  |Some (tag_or_id : tu_tag_or_id) -> 
    match tag_or_id with
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


let acc_of_ts_secs
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (secs : ts_secs)
  : t_acc =
  let rec aux
    (sec_nr : int)
    (app_nr : int)
    (a : t_acc)
    (sec_list : tr_sec list)
    : t_acc =
    match sec_list with
    |[] -> a
    |hd :: tl ->
      match is_appendix hd with
      |true ->
        let new_path : t_path = (APP_NODE app_nr) :: path in
        let new_acc : t_acc =
          add_empty_lines_after_sec tl 
          (acc_of_tr_sec doc_settings cref_table nte_table new_path a hd) 
        in
        aux sec_nr (app_nr + 1) new_acc tl
      |false ->
        let new_path : t_path = (SEC_NODE sec_nr) :: path in
        let new_acc : t_acc =
          add_empty_lines_after_sec tl
          (acc_of_tr_sec doc_settings cref_table nte_table new_path a hd)
        in
        aux (sec_nr + 1) app_nr new_acc tl
  in 
  match secs with
  | Cs_secs (sec_list : tr_sec list) -> aux 0 0 acc sec_list


(* chs *)

let acc_of_ch_main
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (ch_main : tu_secs_pars_or_blks)
  : t_acc =
  match ch_main with
  |Cu_secs_pars_or_blks_secs (secs : ts_secs) ->
      acc_of_ts_secs doc_settings cref_table nte_table path acc secs
  |Cu_secs_pars_or_blks_pars (pars : ts_pars) ->
    acc_of_ts_pars doc_settings cref_table nte_table path acc pars
  |Cu_secs_pars_or_blks_blks (blks : ts_blks) ->
    acc_of_ts_blks doc_settings cref_table nte_table path acc blks



let acc_of_tr_ch
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (ch : tr_ch)
  : t_acc =
  match acc with
  |NTE_TABLE acc_table -> (
    let table_hdr : t_nte_table =
      Common_utils.nte_table_of_ts_hdr_opt
      doc_settings cref_table path []
      ch.fld_ch_hdr
    in
    match
      acc_of_ch_main
      doc_settings cref_table nte_table path (NTE_TABLE table_hdr)
      ch.fld_ch_main
    with
    |NTE_TABLE table ->
      NTE_TABLE (List.concat [table;acc_table])
    | _ -> raise (Error "accumulator type")
  )
  |MARGIN_LABELS _ ->
    acc_of_ch_main
    doc_settings cref_table nte_table path acc
    ch.fld_ch_main
  |CREF_TABLE table ->
    let newacc : t_acc =
      CREF_TABLE (
        match ch.fld_ch_tag_or_id with
        |Some (Cu_tag_or_id_id (id : tr_id)) ->
          (id, path, Cref_element_ch ch) :: table
        |_ -> table
      )
    in 
    acc_of_ch_main
    doc_settings cref_table nte_table path newacc
    ch.fld_ch_main
  |LINES acc_lines -> 
    let lines_hdr : string list =
      Txt_utils.lines_of_ts_hdr_opt
      doc_settings cref_table nte_table path
      ch.fld_ch_hdr
    in
    let lines_main : string list =
      match
        acc_of_ch_main
        doc_settings cref_table nte_table path (LINES [])
        ch.fld_ch_main
      with
      |LINES lines -> lines
      |_ -> raise (Error "accumulator type")
    in
    let lines_endnotes : string list =
      match ch.fld_ch_main with
      |Cu_secs_pars_or_blks_blks _ ->
        lines_of_nte_table
        doc_settings cref_table path
        nte_table
      |_ -> []
    in
    LINES (List.concat [acc_lines; lines_hdr; lines_main; lines_endnotes])
  |EXML acc_list ->
    let xml_list_main : Xml.xml list =
      match
        acc_of_ch_main
        doc_settings cref_table nte_table path (EXML [])
        ch.fld_ch_main
      with
      |EXML xml_list -> xml_list
      | _ -> raise (Error "accumulator type")
    in
    let xml_list_lbl : Xml.xml list =
      [Exml_utils.xml_of_string (label_of_path doc_settings path)]
    in
    let xml_hdr : Xml.xml =
      match ch.fld_ch_hdr with
      |None -> Xml.Element ("ch_lbl_hdr", [], xml_list_lbl)
      |Some (hdr : ts_hdr) ->
        match hdr with
        |Cs_hdr (txt_lines : ts_txt_lines) ->
          Xml.Element (
            "ch_hdr", [],
            Exml_utils.xml_list_of_ts_txt_lines
            doc_settings cref_table nte_table path
            txt_lines
          )
    in
    let xml_endnotes_opt : Xml.xml option = 
      match
        ch.fld_ch_main,
        xml_of_nte_table_opt doc_settings cref_table path nte_table
      with
      |Cu_secs_pars_or_blks_blks _, Some xml_endnotes ->
         Some xml_endnotes
      |_, _ -> None
    in
    let xml_main : Xml.xml = Xml.Element ("ch_main",[],xml_list_main) in
    let xml_lbl : Xml.xml = Xml.Element ("ch_lbl",[],xml_list_lbl) in
    let attr_list : (string*string) list =
      Exml_utils.attr_list_of_tu_tag_or_id_opt
      doc_settings path ["ch"]
      ch.fld_ch_tag_or_id
    in
    let xml_list_ch = 
      match ch.fld_ch_hdr, xml_endnotes_opt with
      |None, Some xml_endnotes -> [xml_hdr;xml_main;xml_endnotes]
      |Some _, Some xml_endnotes ->
        [xml_lbl;xml_hdr;xml_main;xml_endnotes]
      |None, None -> [xml_hdr;xml_main]
      |Some _, None -> [xml_lbl;xml_hdr;xml_main]
    in
    let exml : Xml.xml =
      Xml.Element ("ch", attr_list,xml_list_ch)
    in
    EXML (List.concat [acc_list;[exml]])


let add_empty_lines_after_ch (tl : tr_ch list) (acc : t_acc) : t_acc =
  match tl, acc with
  |_::_, LINES lines -> LINES (List.concat [lines;[""; ""; ""; ""]])
  |_, _ -> acc


let acc_of_ts_chs
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (chs : ts_chs)
  : t_acc =
  let rec aux
    (ch_nr : int)
    (a : t_acc)
    (ch_list : tr_ch list)
    : t_acc =
    match ch_list with
    |[] -> a
    |hd :: tl ->
      let new_path : t_path = (CH_NODE ch_nr) :: path in
      let new_acc : t_acc =
        add_empty_lines_after_ch tl
        (acc_of_tr_ch doc_settings cref_table nte_table new_path a hd)
      in
      aux (ch_nr + 1) new_acc tl
  in
  match chs with
  |Cs_chs (ch_list : tr_ch list) -> aux 0 acc ch_list


(* doc *)


let acc_of_ts_abstract
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (doc_class : t_doc_class)
  (path : t_path)
  (acc : t_acc)
  (abstract : ts_abstract)
  : t_acc =
  match abstract with
  |Cs_abstract (blks : ts_blks) -> 
    match acc with
    |LINES _ -> (
      let padding : string list =
        match doc_class with
        |DOC_CHS -> ["";"";"";""]
        |DOC_SECS -> ["";"";""]
        | _ -> ["";""]
      in
      let hdr : string list =
        Txt_utils.lines_of_abstract_hdr doc_settings doc_class in
      let endnotes : string list =
        match doc_class with
        |DOC_BLKS -> []
        |_ -> lines_of_nte_table doc_settings cref_table path nte_table
      in
      match
        acc_of_ts_blks
        doc_settings cref_table nte_table path (LINES [])
        blks
      with
      |LINES lines ->
        LINES (List.concat [hdr; lines; endnotes; padding])
      | _ -> raise (Error "accumulator type")
    )
    |EXML _ -> (
      let hdr : Xml.xml list =
        Exml_utils.xml_list_of_abstract_hdr doc_settings
      in
      let endnotes : Xml.xml list =
        match doc_class with
        |DOC_BLKS -> []
        |_ ->
          match
            xml_of_nte_table_opt doc_settings cref_table path nte_table
        with
        |Some xml -> [xml]
        |None -> []
      in
      let exml : Xml.xml =
        match
          acc_of_ts_blks
          doc_settings cref_table nte_table path (EXML [])
          blks
        with
        |EXML xml_list ->
           Xml.Element (
             "abstract", [], List.concat [hdr;xml_list;endnotes]
           )
        |_ -> raise (Error "accumulator type")
      in EXML [exml]
    )
    |CREF_TABLE _
    |MARGIN_LABELS _
    |NTE_TABLE _ ->
      acc_of_ts_blks doc_settings cref_table nte_table path acc blks


let acc_of_ts_refs
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (doc_class : t_doc_class)
  (path : t_path)
  (acc : t_acc)
  (refs : ts_refs)
  : t_acc =
  match refs with
  |Cs_refs (blks : ts_blks) -> 
    match acc with
    |LINES _ -> (
      let padding : string list =
        match doc_class with
        |DOC_CHS -> ["";"";"";""]
        |DOC_SECS -> ["";"";""]
        | _ -> ["";""]
      in
      let hdr : string list =
        Txt_utils.lines_of_refs_hdr doc_settings doc_class
      in
      let endnotes : string list =
        match doc_class with
        |DOC_BLKS -> []
        |_ -> lines_of_nte_table doc_settings cref_table path nte_table
      in
      match
        acc_of_ts_blks
        doc_settings cref_table nte_table path (LINES [])
        blks
      with
      |LINES lines ->
        LINES (List.concat [padding; hdr; lines; endnotes])
      | _ -> raise (Error "accumulator type")
    )
    |EXML _ -> (
      let hdr : Xml.xml list =
        Exml_utils.xml_list_of_refs_hdr doc_settings
      in
      let endnotes : Xml.xml list =
        match doc_class with
        |DOC_BLKS -> []
        |_ ->
          match
            xml_of_nte_table_opt
            doc_settings cref_table path
            nte_table
          with
          |Some xml -> [xml]
          |None -> []
      in
      match
        acc_of_ts_blks
        doc_settings cref_table nte_table path (EXML [])
        blks
      with
      |EXML xml_list -> EXML [
        Xml.Element ("refs",[],List.concat [hdr;xml_list; endnotes])
      ]
      | _ -> raise (Error "accumulator type")
    )
    |CREF_TABLE _
    |MARGIN_LABELS _
    |NTE_TABLE _ ->
      acc_of_ts_blks doc_settings cref_table nte_table path acc blks


let acc_of_tu_doc_main
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (doc_main : tu_doc_main)
  : t_acc =
  match doc_main with
  |Cu_doc_main_chs (chs : ts_chs) ->
    acc_of_ts_chs doc_settings cref_table nte_table path acc chs
  |Cu_doc_main_secs (sec : ts_secs) ->
      acc_of_ts_secs doc_settings cref_table nte_table path acc sec
  |Cu_doc_main_pars (pars : ts_pars) ->
      acc_of_ts_pars doc_settings cref_table nte_table path acc pars
  |Cu_doc_main_blks (blks : ts_blks) ->
      acc_of_ts_blks doc_settings cref_table nte_table path acc blks


let acc_of_tr_doc
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (nte_table : t_nte_table)
  (path : t_path)
  (acc : t_acc)
  (doc : tr_doc)
  : t_acc =
  let doc_class : t_doc_class = class_of_tr_doc doc in
  match acc with
  |MARGIN_LABELS _ ->
    acc_of_tu_doc_main
    doc_settings cref_table nte_table path acc
    doc.fld_doc_main
  |NTE_TABLE _ -> (
    let table_abstract : t_nte_table = 
      match doc.fld_doc_abstract with
      |None -> []
      |Some (abstract : ts_abstract) -> 
        match
          acc_of_ts_abstract
          doc_settings cref_table nte_table
          doc_class (ABSTRACT_NODE::path) acc
          abstract
        with
        |NTE_TABLE table -> table
        | _ -> raise (Error "accumulator type")
    in
    let table_refs : t_nte_table = 
      match doc.fld_doc_refs with
      |None -> []
      |Some (refs : ts_refs) -> 
        match
          acc_of_ts_refs doc_settings cref_table nte_table
          doc_class (REFS_NODE::path) acc
          refs
        with
        |NTE_TABLE table -> table
        | _ -> raise (Error "accumulator type")
    in
    let table_main : t_nte_table =
      match doc_class with
      |DOC_BLKS -> (
        match
          acc_of_tu_doc_main doc_settings cref_table nte_table path
          (NTE_TABLE table_abstract)
          doc.fld_doc_main
        with
        |NTE_TABLE table -> table
        |_ -> raise (Error "accumulator type")
      )
      |_ -> (
        match
          acc_of_tu_doc_main
          doc_settings cref_table nte_table path acc
          doc.fld_doc_main
        with
        |NTE_TABLE table -> List.concat [table_abstract;table]
        |_ -> raise (Error "accumulator type")
      )
    in
    NTE_TABLE (List.concat [table_main; table_refs])
  )
  |CREF_TABLE _ -> (
    let table_abstract : t_cref_table = 
      match doc.fld_doc_abstract with
      |None -> []
      |Some (abstract : ts_abstract) -> 
        match
          acc_of_ts_abstract
          doc_settings cref_table nte_table
          doc_class (ABSTRACT_NODE::path) acc
          abstract
        with
        |CREF_TABLE table -> table
        | _ -> raise (Error "accumulator type")
    in
    let table_refs : t_cref_table = 
      match doc.fld_doc_refs with
      |None -> []
      |Some (refs : ts_refs) -> 
        match
          acc_of_ts_refs
          doc_settings cref_table nte_table
          doc_class (REFS_NODE::path) acc
          refs
        with
        |CREF_TABLE table -> table
        |_ -> raise (Error "accumulator type")
    in
    let table_main : t_cref_table = 
      match
        acc_of_tu_doc_main
        doc_settings cref_table nte_table path acc
        doc.fld_doc_main
      with
      |CREF_TABLE table -> table
      | _ -> raise (Error "accumulator type")
    in
    CREF_TABLE (List.concat [table_abstract; table_main; table_refs])
  )
  |LINES _ -> (
    let lines_title : string list =
      Txt_utils.lines_of_ts_title_opt doc_settings doc.fld_doc_title
    in
    let lines_authors : string list =
      Txt_utils.lines_of_ts_authors_opt doc_settings doc.fld_doc_authors
    in
    let lines_date : string list =
      Txt_utils.lines_of_tu_date_opt doc_settings doc.fld_doc_date
    in
    let lines_abstract : string list =
      match doc.fld_doc_abstract with
      |None -> []
      |Some (abstract : ts_abstract) ->
        match
          acc_of_ts_abstract doc_settings cref_table nte_table
          doc_class (ABSTRACT_NODE::path) acc
          abstract
        with
        |LINES lines -> lines
        | _ -> raise (Error "accumulator type")
    in
    let lines_refs : string list =
      match doc.fld_doc_refs with
      |None -> []
      |Some (refs : ts_refs) -> 
        match
          acc_of_ts_refs doc_settings cref_table nte_table
          doc_class (REFS_NODE::path) acc
          refs
        with
        |LINES lines -> lines
        | _ -> raise (Error "accumulator type")
    in
    let lines_main : string list =
      match
        acc_of_tu_doc_main
        doc_settings cref_table nte_table path acc
        doc.fld_doc_main
      with
      |LINES lines -> lines 
      | _ -> raise (Error "accumulator type")
    in
    let lines_authors_date : string list =
      match lines_authors, lines_date with
      |[],_::_ -> List.concat [lines_date;[""]]
      |_::_,[] -> List.concat [lines_authors;[""]]
      |_::_,_::_ -> List.concat [lines_authors;lines_date;[""]]
      |[],[] -> []
    in
    let lines_endnotes : string list =
      match doc_class with
      |DOC_BLKS ->
        lines_of_nte_table doc_settings cref_table path nte_table
      |_ -> []
    in
    LINES (
      List.concat
        [
          lines_title;
          lines_authors_date;
          lines_abstract;
          lines_main;
          lines_refs;
          lines_endnotes;
        ]
    )
  )
  |EXML _ ->
    let xml_title_list : Xml.xml list =
      Exml_utils.xml_list_of_ts_title_opt doc.fld_doc_title
    in
    let xml_authors_list : Xml.xml list =
      Exml_utils.xml_list_of_ts_authors_opt doc.fld_doc_authors
    in
    let xml_date_list : Xml.xml list =
      Exml_utils.xml_list_of_tu_date_opt doc_settings doc.fld_doc_date
    in
    let xml_abstract_list : Xml.xml list = 
      match doc.fld_doc_abstract with
      |None -> []
      |Some (abstract : ts_abstract) -> 
        match
          acc_of_ts_abstract doc_settings cref_table nte_table
          doc_class (ABSTRACT_NODE::path) acc
          abstract
        with
        |EXML xml_list -> xml_list
        | _ -> raise (Error "accumulator type")
    in
    let xml_refs_list : Xml.xml list = 
      match doc.fld_doc_refs with
      |None -> []
      |Some (refs : ts_refs) -> 
        match
          acc_of_ts_refs
          doc_settings cref_table nte_table
          doc_class (REFS_NODE::path) acc
          refs
        with
        |EXML xml_list -> xml_list
        | _ -> raise (Error "accumulator type")
    in
    let xml_main_list : Xml.xml list =
      match
        acc_of_tu_doc_main
        doc_settings cref_table nte_table path acc
        doc.fld_doc_main
      with
     |EXML xml_list -> [Xml.Element ("doc_main",[],xml_list)]
     | _ -> raise (Error "accumulator type")
    in
    let xml_endnotes_opt : Xml.xml option =
      xml_of_nte_table_opt doc_settings cref_table path nte_table
    in
    let xml_endnotes_list : Xml.xml list =
      match doc.fld_doc_main, xml_endnotes_opt with
      |Cu_doc_main_blks _, Some xml -> [xml]
      |_, _ -> []
    in
    let xml_list_doc =
      List.concat [
        xml_title_list;
        xml_authors_list;
        xml_date_list;
        xml_abstract_list;
        xml_main_list;
        xml_refs_list;
        xml_endnotes_list;
      ]
    in
    let doc_class_string = string_of_t_doc_class doc_class in
    EXML [Xml.Element ("doc",[("class",doc_class_string)],xml_list_doc)]


(* margin labels *)

let margin_labels_of_tr_doc
  (doc_settings : t_doc_settings)
  (doc : tr_doc)
  : string list=
  let _ : unit = IO.quiet.contents <- true in
  match
    acc_of_tr_doc
    doc_settings ([] : t_cref_table) ([] : t_nte_table) ([] : t_path)
    (MARGIN_LABELS [])
    doc
  with
  |MARGIN_LABELS string_list -> string_list
  |_ -> raise (Error "accumulator type")

(* cref table *)

let cref_table_of_tr_doc
  (doc_settings : t_doc_settings)
  (doc : tr_doc)
  : t_cref_table =
  let _ : unit = IO.quiet.contents <- true in
  match
    acc_of_tr_doc
    doc_settings ([] : t_cref_table) ([] : t_nte_table) ([] : t_path)
    (CREF_TABLE [])
    doc
  with
  |CREF_TABLE table -> check_cref_table doc_settings (List.rev table)
  |_ -> raise (Error "accumulator type")

(* note table *)

let nte_table_of_tr_doc
  (doc_settings : t_doc_settings)
  (cref_table : t_cref_table)
  (doc : tr_doc)
  : t_nte_table =
  let _ : unit = IO.quiet.contents <- true in
  match
    acc_of_tr_doc
    doc_settings cref_table ([] : t_nte_table) ([] : t_path)
    (NTE_TABLE [])
    doc
  with
  |NTE_TABLE table -> table
  |_ -> raise (Error "accumulator type")


(* txt *)

let lines_of_tr_doc
  (doc_settings : t_doc_settings)
  (doc : tr_doc)
  : string list =
  let quiet : bool = IO.quiet.contents in
  let cref_table : t_cref_table =
    cref_table_of_tr_doc doc_settings doc
  in
  let nte_table : t_nte_table =
    nte_table_of_tr_doc doc_settings cref_table doc
  in
  let _ : unit = IO.quiet.contents <- quiet in
  match
    acc_of_tr_doc
    doc_settings cref_table nte_table ([] : t_path) (LINES [])
    doc
  with
  |LINES lines -> lines
  |_ -> raise (Error "accumulator type")


let txt_of_tr_doc (options : t_txt_options) (doc : tr_doc) : string =
  let doc_settings : t_doc_settings = doc_settings_of_tr_doc doc in
  let left_margin : int = 
    match options.margin with
    |Some (m : int) -> m
    |None -> 
      let margin_labels : string list =
        margin_labels_of_tr_doc doc_settings doc
      in
      Txt_utils.left_margin_of_margin_labels margin_labels
  in
  let doc_width : int = 
    match options.width with
    |Some (w : int) -> w
    |None -> if 68 + left_margin > 80 then 80 else 68 + left_margin
  in
  let auto_numbering : int -> int -> string =
    auto_numbering_of_string options.numbering
  in
  let allow_custom_numbering : bool = options.allow_custom_numbering in
  let expand_tag : ts_tag -> (string * string) option =
    match options.tags with
    |None -> doc_settings.expand_tag
    |Some path -> Tags.expander_of_file path
  in
  let tab_length : int =
    match options.indent with
   |None -> doc_settings.tab_length
   |Some n -> n
  in
  let new_doc_settings : t_doc_settings = {
    doc_width = doc_width;
    left_margin = left_margin;
    title_indent = left_margin;
    author_indent = left_margin;
    abstract_indent = left_margin;
    refs_indent = left_margin;
    tab_length = tab_length;
    abstract_hdr = doc_settings.abstract_hdr;
    refs_hdr = doc_settings.refs_hdr;
    endnotes_hdr = doc_settings.endnotes_hdr;
    ch_prefix = doc_settings.ch_prefix;
    sec_prefix = doc_settings.sec_prefix;
    app_prefix = doc_settings.app_prefix;
    par_prefix = doc_settings.par_prefix;
    expand_tag = expand_tag;
    auto_numbering = auto_numbering;
    allow_custom_numbering = allow_custom_numbering;
    nte_numbering = doc_settings.nte_numbering;
  }
  in
  let _ : unit = IO.quiet.contents <- options.quiet in
  String.concat "\n" (lines_of_tr_doc new_doc_settings doc)

(* exml *)

let xml_list_of_tr_doc
  (doc_settings : t_doc_settings)
  (doc : tr_doc)
  : Xml.xml list =
  let quiet : bool = IO.quiet.contents in
  let cref_table : t_cref_table =
    cref_table_of_tr_doc doc_settings doc
  in
  let nte_table : t_nte_table =
    nte_table_of_tr_doc doc_settings cref_table doc
  in
  let _ : unit = IO.quiet.contents <- quiet in
  match
    acc_of_tr_doc
    doc_settings cref_table nte_table ([] : t_path) (EXML [])
    doc
  with
  |EXML xml_list -> xml_list
  |_ -> raise (Error "accumulator type")


let exml_of_tr_doc (options : t_exml_options) (doc : tr_doc) : Xml.xml =
  let doc_settings : t_doc_settings = doc_settings_of_tr_doc doc in
  let auto_numbering = auto_numbering_of_string options.numbering in
  let allow_custom_numbering : bool = options.allow_custom_numbering in
  let expand_tag : ts_tag -> (string * string) option =
    match options.tags with
    |None -> doc_settings.expand_tag
    |Some path -> Tags.expander_of_file path
  in
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
    endnotes_hdr = doc_settings.endnotes_hdr;
    ch_prefix = doc_settings.ch_prefix;
    sec_prefix = doc_settings.sec_prefix;
    app_prefix = doc_settings.app_prefix;
    par_prefix = doc_settings.par_prefix;
    expand_tag = expand_tag;
    auto_numbering = auto_numbering;
    allow_custom_numbering = allow_custom_numbering;
    nte_numbering = doc_settings.nte_numbering;
  }
  in
  let _ : unit = IO.quiet.contents <- options.quiet in
  match xml_list_of_tr_doc new_doc_settings doc with
  | hd::[] -> hd
  | _ -> raise (Error "expected singleton exml-list")


