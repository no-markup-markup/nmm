(*
type xml = Xml_light_types.xml =
  | Element of (string * (string * string) list * xml list)
  | PCData of string
*)

open Doc_types

exception Error of string

let string_of_xml_list (xml_list:Xml.xml list):string=
        String.concat "\n" (List.map Xml_right.to_string xml_list)

let rec f_tr_doc_of_axml (xml:Xml.xml):tr_doc =
    match xml with
    |Xml.Element ("cr_doc",[],xml_list) -> 
        let (preamble_opt, preamble_tl) = f_ts_preamble_opt_of_xml_list xml_list in
        let (title_opt, title_tl) = f_ts_title_opt_of_xml_list preamble_tl in
        let (authors_opt, authors_tl) = f_ts_authors_opt_of_xml_list title_tl in
        let (date_opt, date_tl) = f_ts_date_opt_of_xml_list authors_tl in
        let (abstract_opt, abstract_tl) = f_ts_abstract_opt_of_xml_list date_tl in
        let (doc_main, doc_main_tl) = f_tu_doc_main_of_xml_list abstract_tl in
        let refs_opt = f_ts_doc_refs_opt_of_xml_list doc_main_tl in
        {   
            fld_doc_preamble    =   preamble_opt;
            fld_doc_title       =   title_opt;
            fld_doc_date        =   date_opt;
            fld_doc_authors     =   authors_opt;
            fld_doc_abstract    =   abstract_opt;
            fld_doc_main        =   doc_main;
            fld_doc_refs        =   refs_opt;
        }
    |_ -> raise (Error (String.concat "" ["Expected cr_doc, got: ";string_of_xml_list [xml]]))

and f_ts_preamble_opt_of_xml_list (xml_list : Xml.xml list) : (ts_preamble option) * (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cs_preamble",[],pcdata_list) -> (Some (Cs_preamble (f_string_of_pcdata_list pcdata_list)),tl)
        |Xml.Element ("cs_title",[],_)
        |Xml.Element ("cs_authors",[],_)
        |Xml.Element ("cs_date",[],_)
        |Xml.Element ("cs_abstract",[],_)
        |Xml.Element ("cu_doc_main_chs",[],_)
        |Xml.Element ("cu_doc_main_secs",[],_)
        |Xml.Element ("cu_doc_main_pars",[],_)
        |Xml.Element ("cu_doc_main_blks",[],_)
        |Xml.Element ("cs_refs",[],_) -> (None, xml_list)
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))

and f_ts_title_opt_of_xml_list (xml_list:Xml.xml list):(ts_title option) * (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cs_title",[],pcdata_list) -> (Some (Cs_title (f_string_of_pcdata_list pcdata_list)), tl)
        |Xml.Element ("cs_authors",[],_)
        |Xml.Element ("cs_date",[],_)
        |Xml.Element ("cs_abstract",[],_)
        |Xml.Element ("cu_doc_main_chs",[],_)
        |Xml.Element ("cu_doc_main_secs",[],_)
        |Xml.Element ("cu_doc_main_pars",[],_)
        |Xml.Element ("cu_doc_main_blks",[],_)
        |Xml.Element ("cs_refs",[],_) -> (None, xml_list)
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))

and f_ts_authors_opt_of_xml_list (xml_list:Xml.xml list) : (ts_authors option) *  (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cs_authors",[],xmls) -> (Some (Cs_authors (List.map f_ts_author_of_xml xmls)), tl)
        |Xml.Element ("cs_date",[],_)
        |Xml.Element ("cs_abstract",[],_)
        |Xml.Element ("cu_doc_main_chs",[],_)
        |Xml.Element ("cu_doc_main_secs",[],_)
        |Xml.Element ("cu_doc_main_pars",[],_)
        |Xml.Element ("cu_doc_main_blks",[],_)
        |Xml.Element ("cs_refs",[],_) -> (None, xml_list)
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))

and f_ts_author_of_xml (xml : Xml.xml) : ts_author =
        match xml with
        |Xml.Element ("cs_author",[],pcdata_list) -> Cs_author (f_string_of_pcdata_list pcdata_list)
        |x -> raise (Error (String.concat "" ["expected cs_author, got: ";string_of_xml_list [x]]))

and f_ts_date_opt_of_xml_list (xml_list:Xml.xml list) : (ts_date option) *  (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cs_date",[],pcdata_list) -> (Some (Cs_date (f_string_of_pcdata_list pcdata_list)), tl)
        |Xml.Element ("cs_abstract",[],_)
        |Xml.Element ("cu_doc_main_chs",[],_)
        |Xml.Element ("cu_doc_main_secs",[],_)
        |Xml.Element ("cu_doc_main_pars",[],_)
        |Xml.Element ("cu_doc_main_blks",[],_)
        |Xml.Element ("cs_refs",[],_) -> (None, xml_list)
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))

and f_ts_abstract_opt_of_xml_list (xml_list:Xml.xml list) : (ts_abstract option) *  (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cs_abstract",[],[xml]) -> (Some (Cs_abstract (f_ts_blks_of_xml xml)), tl)
        |Xml.Element ("cu_doc_main_chs",[],_)
        |Xml.Element ("cu_doc_main_secs",[],_)
        |Xml.Element ("cu_doc_main_pars",[],_)
        |Xml.Element ("cu_doc_main_blks",[],_)
        |Xml.Element ("cs_refs",[],_) -> (None, xml_list)
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))

and f_tu_doc_main_of_xml_list (xml_list:Xml.xml list): tu_doc_main * (Xml.xml list) =
    match xml_list with
    |hd::tl -> (
        match hd with
        |Xml.Element ("cu_doc_main_chs",[],[xml]) -> (Cu_doc_main_chs (f_ts_chs_of_xml xml), tl)
        |Xml.Element ("cu_doc_main_secs",[],[xml]) -> (Cu_doc_main_secs (f_ts_secs_of_xml xml), tl)
        |Xml.Element ("cu_doc_main_pars",[],[xml]) -> (Cu_doc_main_pars (f_ts_pars_of_xml xml), tl)
        |Xml.Element ("cu_doc_main_blks",[],[xml]) -> (Cu_doc_main_blks (f_ts_blks_of_xml xml), tl)
        |Xml.Element ("cs_refs",[],_) -> raise (Error "doc_main must exist")
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))
    )
    |[] -> raise (Error "doc_main must exist")

and f_ts_doc_refs_opt_of_xml_list (xml_list):ts_refs option =
    match xml_list with
    |[] -> None
    |hd::tl ->
        match hd with
        |Xml.Element ("cs_refs",[],[xml]) -> Some (Cs_refs (f_ts_blks_of_xml xml))
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))

and f_ts_chs_of_xml (xml:Xml.xml):ts_chs =
    match xml with
    |Xml.Element ("cs_chs",[],xml_list) -> Cs_chs (List.map f_tr_ch_of_xml xml_list)
    |_ -> raise (Error (String.concat "" ["expected cs_chs, got: ";string_of_xml_list [xml]]))

and f_ts_secs_of_xml (xml:Xml.xml):ts_secs =
    match xml with
    |Xml.Element ("cs_secs",[],xml_list) -> Cs_secs (List.map f_tr_sec_of_xml xml_list)
    |_ -> raise (Error (String.concat "" ["expected cs_secs, got: "; string_of_xml_list [xml]]))

and f_ts_pars_of_xml (xml:Xml.xml):ts_pars =
    match xml with
    |Xml.Element ("cs_pars",[],xml_list) -> Cs_pars (List.map f_tu_par_of_xml xml_list)
    |_ -> raise (Error (String.concat "" ["expected cs_pars, got: ";string_of_xml_list [xml]]))

and f_ts_blks_of_xml (xml:Xml.xml):ts_blks =
    match xml with
    |Xml.Element ("cs_blks",[],xml_list) -> Cs_blks (List.map f_tu_blk_of_xml xml_list)
    |_ -> raise (Error (String.concat "" ["expected cs_blks, got: ";string_of_xml_list [xml]]))

and f_tr_ch_of_xml (xml:Xml.xml):tr_ch =
    match xml with
    |Xml.Element ("cr_ch",[],xml_list) -> 
        let (tag_or_id_opt, tag_or_id_tl) = f_ch_sec_par_tag_or_id_opt_of_xml_list xml_list in
        let (hdr_opt, hdr_tl) = f_ch_sec_par_hdr_opt_of_xml_list tag_or_id_tl in
        let main = f_tu_secs_pars_or_blks_of_xml_list hdr_tl in
        {   
            fld_ch_tag_or_id    =   tag_or_id_opt;
            fld_ch_hdr          =   hdr_opt;
            fld_ch_main         =   main;
        }
    |_ -> raise (Error (String.concat "" ["expected cr_ch, got: ";string_of_xml_list [xml]]))


and f_tr_sec_of_xml (xml:Xml.xml):tr_sec =
    match xml with
    |Xml.Element ("cr_sec",[],xml_list) -> 
        let (tag_or_id_opt, tag_or_id_tl) = f_ch_sec_par_tag_or_id_opt_of_xml_list xml_list in
        let (hdr_opt, hdr_tl) = f_ch_sec_par_hdr_opt_of_xml_list tag_or_id_tl in
        let main = f_tu_pars_or_blks_of_xml_list hdr_tl in
        {   
            fld_sec_tag_or_id    =   tag_or_id_opt;
            fld_sec_hdr          =   hdr_opt;
            fld_sec_main         =   main;
        }
    |_ -> raise (Error (String.concat "" ["expected cr_sec, got: ";string_of_xml_list [xml]]))

and f_tu_par_of_xml (xml : Xml.xml) : tu_par =
        match xml with
        |Xml.Element ("cu_par_std", [], [x]) -> Cu_par_std (f_tr_par_std_of_xml x)
        |Xml.Element ("cu_par_rpt", [], [x]) -> Cu_par_rpt (f_ts_par_rpt_of_xml x) 
        |_ -> raise (Error (String.concat "" ["expected cu_par_std or cu_par_rpt, got: ";string_of_xml_list [xml]]))


and f_ts_par_rpt_of_xml (xml : Xml.xml) : ts_par_rpt =
        match xml with
        |Xml.Element ("cs_par_rpt",[],[x]) -> Cs_par_rpt (f_tr_id_of_xml x)
        |_ -> raise (Error (String.concat "" ["expected cs_par_rpt, got: ";string_of_xml_list [xml]]))

and f_tr_par_std_of_xml (xml:Xml.xml):tr_par_std =
    match xml with
    |Xml.Element ("cr_par_std",[],xml_list) ->
        let (tag_or_id_opt, tag_or_id_tl) = f_ch_sec_par_tag_or_id_opt_of_xml_list xml_list in
        let (hdr_opt, hdr_tl) = f_ch_sec_par_hdr_opt_of_xml_list tag_or_id_tl in
        let main = f_par_main_of_xml_list hdr_tl in
        {   
            fld_par_tag_or_id    =   tag_or_id_opt;
            fld_par_hdr          =   hdr_opt;
            fld_par_main         =   main;
        }
    |_ -> raise (Error (String.concat "" ["expected cr_par_std, got: ";string_of_xml_list [xml]]))

and f_ch_sec_par_tag_or_id_opt_of_xml_list (xml_list:Xml.xml list): (tu_tag_or_id option) * (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cu_tag_or_id_tag",[],[xml]) -> (Some (Cu_tag_or_id_tag (f_ts_tag_of_xml xml)), tl)
        |Xml.Element ("cu_tag_or_id_id",[],[xml]) -> (Some (Cu_tag_or_id_id (f_tr_id_of_xml xml)), tl)
        | _ -> (None, xml_list)

and f_ch_sec_par_hdr_opt_of_xml_list (xml_list:Xml.xml list): (ts_hdr option) * (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cs_hdr",[],[xml]) -> (Some (Cs_hdr (f_ts_txt_units_of_xml xml)), tl)
        |_ -> (None, xml_list)

and f_tu_tag_or_id_opt_of_xml_list (xml_list:Xml.xml list):tu_tag_or_id option =
    match xml_list with
    |[] -> None
    |hd::tl ->
        match hd with
        |Xml.Element ("cu_tag_or_id_tag",[],[xml]) -> Some (Cu_tag_or_id_tag (f_ts_tag_of_xml xml))
        |Xml.Element ("cu_tag_or_id_id",[],[xml]) -> Some (Cu_tag_or_id_id (f_tr_id_of_xml xml))
        |_ -> f_tu_tag_or_id_opt_of_xml_list tl

and f_ts_hdr_opt_of_xml_list (xml_list:Xml.xml list):ts_hdr option =
    match xml_list with
    |[] -> None
    |hd::tl ->
        match hd with
        |Xml.Element ("cs_hdr",[],[xml]) -> Some (Cs_hdr (f_ts_txt_units_of_xml xml))
        |_ -> f_ts_hdr_opt_of_xml_list tl

and f_tu_secs_pars_or_blks_of_xml_list (xml_list:Xml.xml list):tu_secs_pars_or_blks =
    match xml_list with
    |hd::tl -> (
        match hd with
        |Xml.Element ("cu_secs_pars_or_blks_secs",[],[xml]) -> Cu_secs_pars_or_blks_secs (f_ts_secs_of_xml xml)
        |Xml.Element ("cu_secs_pars_or_blks_pars",[],[xml]) -> Cu_secs_pars_or_blks_pars (f_ts_pars_of_xml xml)
        |Xml.Element ("cu_secs_pars_or_blks_blks",[],[xml]) -> Cu_secs_pars_or_blks_blks (f_ts_blks_of_xml xml)
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))
    )
    |_ -> raise (Error "ch_main must exist")


and f_tu_pars_or_blks_of_xml_list (xml_list:Xml.xml list):tu_pars_or_blks =
    match xml_list with
    |hd::tl -> (
        match hd with
        |Xml.Element ("cu_pars_or_blks_pars",[],[xml]) -> Cu_pars_or_blks_pars (f_ts_pars_of_xml xml)
        |Xml.Element ("cu_pars_or_blks_blks",[],[xml]) -> Cu_pars_or_blks_blks (f_ts_blks_of_xml xml)
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))
    )
    |_ -> raise (Error "sec_main must exist")

and f_par_main_of_xml_list (xml_list:Xml.xml list):ts_blks =
    match xml_list with
    |hd::tl -> (
        match hd with
        |Xml.Element ("cs_blks",[],_) -> f_ts_blks_of_xml hd
        |xml -> raise (Error (String.concat "" ["unexcpected element: ";string_of_xml_list [xml]]))
    )
    |_ -> raise (Error "par_main must exist")

and f_ts_blks_of_xml_list (xml_list:Xml.xml list):ts_blks =
    match xml_list with
    |hd::tl -> (
        match hd with
        |Xml.Element ("cs_blks",[],_) -> f_ts_blks_of_xml hd
        |_ -> f_ts_blks_of_xml_list tl
    )
    |_ -> raise (Error "blks must exist")


and f_tu_blk_of_xml (xml:Xml.xml):tu_blk =
    match xml with
    |Xml.Element ("cu_blk_txt",[],[x]) -> Cu_blk_txt (f_ts_blk_txt_of_xml x)
    |Xml.Element ("cu_blk_blt",[],[x]) -> Cu_blk_blt (f_ts_blk_blt_of_xml x)
    |Xml.Element ("cu_blk_itm",[],[x]) -> Cu_blk_itm (f_tr_blk_itm_of_xml x)
    |Xml.Element ("cu_blk_dsp",[],[x]) -> Cu_blk_dsp (f_ts_blk_dsp_of_xml x)
    |Xml.Element ("cu_blk_vrb",[],[x]) -> Cu_blk_vrb (f_ts_blk_vrb_of_xml x)
    |_ -> raise (Error (String.concat "" ["expected cu_blk_txt, cu_blk_blt, cu_blk_itm, or cu_blk_dsp, got: ";string_of_xml_list [xml]]))


and f_ts_blk_txt_of_xml (xml:Xml.xml):ts_blk_txt =
    match xml with
    |Xml.Element ("cs_blk_txt",[],[x]) -> Cs_blk_txt (f_ts_txt_units_of_xml x)
    |_ -> raise (Error (String.concat "" ["expected cs_blk_txt, got: ";string_of_xml_list [xml]]))

and f_ts_blk_blt_of_xml (xml:Xml.xml):ts_blk_blt =
    match xml with
    |Xml.Element ("cs_blk_blt",[],[x]) -> Cs_blk_blt (f_ts_blks_of_xml x)
    |_ -> raise (Error (String.concat "" ["expected cs_blk_blt, got: ";string_of_xml_list [xml]]))

and f_tr_blk_itm_of_xml (xml:Xml.xml):tr_blk_itm =
    match xml with
    |Xml.Element ("cr_blk_itm",[],xml_list) -> 
        let (lbl, lbl_tl) = f_itm_lbl_of_xml_list xml_list in
        let (id_opt, id_tl) = f_itm_id_opt_of_xml_list lbl_tl in
        let main = f_ts_blks_of_xml_list id_tl in
        {   
            fld_blk_itm_lbl         =   lbl;
            fld_blk_itm_id          =   id_opt;
            fld_blk_itm_main        =   main;
        }
    |_ -> raise (Error (String.concat "" ["expected cr_blk_itm, got: ";string_of_xml_list [xml]]))

and f_ts_blk_dsp_of_xml (xml:Xml.xml):ts_blk_dsp =
    match xml with
    |Xml.Element ("cs_blk_dsp",[],[x]) -> Cs_blk_dsp (f_ts_dsp_lines_of_xml x)
    |_ -> raise (Error (String.concat "" ["expected cs_blk_dsp, got: ";string_of_xml_list [xml]]))

and f_ts_blk_vrb_of_xml (xml:Xml.xml):ts_blk_vrb =
    match xml with
    |Xml.Element ("cs_blk_vrb",[],[x]) -> Cs_blk_vrb (f_ts_vrb_lines_of_xml x)
    |_ -> raise (Error (String.concat "" ["expected cs_blk_vrb, got: ";string_of_xml_list [xml]]))

and f_ts_vrb_lines_of_xml (xml:Xml.xml):ts_vrb_lines =
    match xml with
    |Xml.Element ("cs_vrb_lines",[],xml_list) -> Cs_vrb_lines (List.map f_ts_vrb_line_of_xml xml_list)
    |_ -> raise (Error (String.concat "" ["expected cs_vrb_lines, got: ";string_of_xml_list [xml]]))

and f_ts_vrb_line_of_xml (xml:Xml.xml):ts_vrb_line =
    match xml with
    |Xml.Element ("cs_vrb_line",[],xml_list) -> Cs_vrb_line (f_string_of_pcdata_list xml_list)
    |_ -> raise (Error (String.concat "" ["expected cs_vrb_line, got: ";string_of_xml_list [xml]]))

and f_itm_lbl_of_xml_list (xml_list:Xml.xml list) : tu_lbl * (Xml.xml list) =
    match xml_list with
    |hd::tl -> (
        match hd with
        |Xml.Element ("cu_lbl_auto",[],[xml]) -> (Cu_lbl_auto (f_ts_lbl_auto_of_xml xml), tl)
        |Xml.Element ("cu_lbl_custom",[],[xml]) -> (Cu_lbl_custom (f_ts_lbl_custom_of_xml xml), tl)
        |xml -> raise (Error (String.concat "" ["expected cu_lbl_auto or cu_lbl_custom, got: ";string_of_xml_list [xml]]))
    )
    |[] -> raise (Error (String.concat "" ["expected cu_lbl_auto or cu_lbl_custom, got: ";string_of_xml_list xml_list]))


and f_ts_lbl_auto_of_xml (xml:Xml.xml):ts_lbl_auto=
        match xml with 
        |Xml.Element ("cs_lbl_auto",[],[]) -> Cs_lbl_auto
    |_ -> raise (Error (String.concat "" ["expected cs_lbl_auto, got: ";string_of_xml_list [xml]]))

and f_ts_lbl_custom_of_xml (xml:Xml.xml):ts_lbl_custom=
        match xml with 
        |Xml.Element ("cs_lbl_custom",[],pcdata_list) -> Cs_lbl_custom (f_string_of_pcdata_list pcdata_list) 
    |_ -> raise (Error (String.concat "" ["expected cs_lbl_custom, got: ";string_of_xml_list [xml]]))

and f_ts_tag_of_xml (xml:Xml.xml):ts_tag =
    match xml with
    |Xml.Element ("cs_tag",[],pcdata_list) -> Cs_tag (f_string_of_pcdata_list pcdata_list)
    |_ -> raise (Error (String.concat "" ["expected cs_tag, got: ";string_of_xml_list [xml]]))


and f_ts_txt_units_of_xml (xml:Xml.xml):ts_txt_units =
    match xml with
    |Xml.Element ("cs_txt_units",[],xml_list) -> Cs_txt_units (List.map f_tu_txt_unit_of_xml xml_list)
    |_ -> raise (Error (String.concat "" ["expected cs_txt_units, got: ";string_of_xml_list [xml]]))

and f_tu_txt_unit_of_xml (xml:Xml.xml):tu_txt_unit =
    match xml with
    |Xml.Element ("cu_txt_unit_wysiwyg",[],[xml]) -> Cu_txt_unit_wysiwyg (f_ts_txt_unit_wysiwyg_of_xml xml)
    |Xml.Element ("cu_txt_unit_emph",[],[xml]) -> Cu_txt_unit_emph (f_ts_txt_unit_emph_of_xml xml)
    |Xml.Element ("cu_txt_unit_c_ref",[],[xml]) -> Cu_txt_unit_c_ref (f_ts_txt_unit_c_ref xml) 
    |_-> raise (Error (String.concat "" ["expected cu_txt_unit_wysiwyg, cu_txt_unit_emph, or cu_txt_unit_c_ref, got: ";string_of_xml_list [xml]]))

and f_ts_txt_unit_wysiwyg_of_xml (xml:Xml.xml):ts_txt_unit_wysiwyg=
        match xml with 
        |Xml.Element ("cs_txt_unit_wysiwyg",[],pcdata_list) -> Cs_txt_unit_wysiwyg (f_string_of_pcdata_list pcdata_list)
    |_ -> raise (Error (String.concat "" ["expected cs_txt_unit_wysiwyg, got: ";string_of_xml_list [xml]]))

and f_ts_txt_unit_emph_of_xml (xml:Xml.xml):ts_txt_unit_emph=
        match xml with 
        |Xml.Element ("cs_txt_unit_emph",[],pcdata_list) -> Cs_txt_unit_emph (f_string_of_pcdata_list pcdata_list)
    |_ -> raise (Error (String.concat "" ["expected cs_txt_unit_emph, got: ";string_of_xml_list [xml]]))

and f_ts_txt_unit_c_ref (xml:Xml.xml):ts_txt_unit_c_ref=
        match xml with 
        |Xml.Element ("cs_txt_unit_c_ref",[],[xml]) -> Cs_txt_unit_c_ref (f_ts_c_ref_of_xml xml)
    |_ -> raise (Error (String.concat "" ["expected cs_txt_unit_c_ref, got: ";string_of_xml_list [xml]]))

and f_ts_dsp_lines_of_xml (xml:Xml.xml):ts_dsp_lines =
    match xml with
    |Xml.Element ("cs_dsp_lines",[],xml_list) -> Cs_dsp_lines (List.map f_tr_dsp_line_of_xml xml_list)
    |_ -> raise (Error (String.concat "" ["expected cs_dsp_lines, got: ";string_of_xml_list [xml]]))

and f_tr_dsp_line_of_xml (xml:Xml.xml):tr_dsp_line =
    match xml with
    |Xml.Element ("cu_dsp_line_no_lbl",[],[Xml.Element ("cs_dsp_line_no_lbl",[],[x])]) ->
        {   
            fld_dsp_line_lbl        =   None;
            fld_dsp_line_id         =   None;
            fld_dsp_line_units      =   f_ts_txt_units_of_xml x;
        }
    |Xml.Element ("cu_dsp_line_lbld",[],[Xml.Element ("cr_dsp_line_lbld",[],xml_list)]) ->
        let (lbl_opt, lbl_tl) = f_dsp_lbl_opt_of_xml_list xml_list in
        let (id_opt, id_tl) = f_dsp_id_opt_of_xml_list lbl_tl in
        let main = f_ts_txt_units_of_xml_list id_tl in
        {   
            fld_dsp_line_lbl        =   lbl_opt;
            fld_dsp_line_id         =   id_opt;
            fld_dsp_line_units      =   main;
        }
    |_ -> raise (Error (String.concat "" ["expected cu_dsp_line_no_lbl or cu_dsp_line_lbld, got: ";string_of_xml_list [xml]]))

and f_itm_id_opt_of_xml_list (xml_list:Xml.xml list): (tr_id option) * (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cr_id",_,_) -> (Some (f_tr_id_of_xml hd), tl)
        |_ -> (None, xml_list)

and f_dsp_lbl_opt_of_xml_list (xml_list:Xml.xml list): (tu_lbl option) * (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cu_lbl_auto",[],[xml]) -> (Some (Cu_lbl_auto (f_ts_lbl_auto_of_xml xml)), tl)
        |Xml.Element ("cu_lbl_custom",[],[xml]) -> (Some (Cu_lbl_custom (f_ts_lbl_custom_of_xml xml)), tl)
        |_ -> (None, xml_list)

and f_dsp_id_opt_of_xml_list (xml_list:Xml.xml list): (tr_id option) * (Xml.xml list) =
    match xml_list with
    |[] -> (None, xml_list)
    |hd::tl ->
        match hd with
        |Xml.Element ("cr_id",_,_) -> (Some (f_tr_id_of_xml hd), tl)
        |_ -> (None, xml_list)



and f_ts_txt_units_of_xml_list (xml_list:Xml.xml list):ts_txt_units =
    match xml_list with
    |hd::tl -> (
        match hd with
        |Xml.Element ("cs_txt_units",_,_) -> f_ts_txt_units_of_xml hd
        |_ -> raise (Error (String.concat "" ["expected cs_txt_units, got: ";string_of_xml_list xml_list]))
    )
    |_ -> raise (Error (String.concat "" ["expected cs_txt_units, got: ";string_of_xml_list xml_list]))

and f_tr_id_of_xml (xml:Xml.xml):tr_id =
    match xml with
    |Xml.Element ("cr_id",[],[x;y]) -> 
        {
            fld_id_tag      =   f_ts_tag_of_xml x;
            fld_id_name     =   f_ts_name_of_xml y;
            fld_id_scope    =   None;
        }
    |Xml.Element ("cr_id",[],[x;y;z]) -> 
        {
            fld_id_tag      =   f_ts_tag_of_xml x;
            fld_id_name     =   f_ts_name_of_xml y;
            fld_id_scope    =   Some (f_tu_scope_of_xml z);
        }
    |_ -> raise (Error (String.concat "" ["expected cr_id, got: ";string_of_xml_list [xml]]))

and f_ts_name_of_xml (xml:Xml.xml):ts_name =
    match xml with
    |Xml.Element ("cs_name",[],pcdata_list) -> Cs_name (f_string_of_pcdata_list pcdata_list)
    |_ -> raise (Error (String.concat "" ["expected cs_name, got: ";string_of_xml_list [xml]]))

and f_tu_scope_of_xml (xml : Xml.xml) : tu_scope =
        match xml with
        |Xml.Element ("cu_scope_gbl",[],[]) -> Cu_scope_gbl 
        |Xml.Element ("cu_scope_ch",[],[]) -> Cu_scope_ch
        |Xml.Element ("cu_scope_sec",[],[]) -> Cu_scope_sec
        |Xml.Element ("cu_scope_app",[],[]) -> Cu_scope_app
        |Xml.Element ("cu_scope_par",[],[]) -> Cu_scope_par
        |_ -> raise (Error (String.concat "" ["expected cu_scope_gbl, cu_scope_ch, cu_scope_sec, cu_scope_app, or cu_scope_par; got: ";string_of_xml_list [xml]]))

and f_ts_c_ref_of_xml (xml:Xml.xml):ts_c_ref=
        match xml with 
        |Xml.Element ("cs_c_ref",[],[xml]) -> Cs_c_ref (f_tr_id_of_xml xml)
        |_ -> raise (Error (String.concat "" ["expected cs_c_ref, got: ";string_of_xml_list [xml]]))

and f_string_of_pcdata_list (pcdata_list:Xml.xml list):string=
        String.concat "" (List.map f_string_of_pcdata pcdata_list)

and f_string_of_pcdata (pcdata:Xml.xml):string=
        match pcdata with
        |Xml.PCData s -> Exml_utils.string_of_pcdata s
        |_ -> raise (Error (String.concat "" ["expected pcdata, got: ";string_of_xml_list [pcdata]]))
