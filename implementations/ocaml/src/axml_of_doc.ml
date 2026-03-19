(*
type xml = Xml_light_types.xml =
  | Element of (string * (string * string) list * xml list)
  | PCData of string
*)

open Doc_types

let rec axml_of_tr_doc (doc:tr_doc):Xml.xml=
        let xml_list_preamble : Xml.xml list = xml_list_of_ts_preamble_opt doc.fld_doc_preamble in
        let xml_list_title : Xml.xml list = xml_list_of_ts_title_opt doc.fld_doc_title in
        let xml_list_authors : Xml.xml list = xml_list_of_ts_authors_opt doc.fld_doc_authors in
        let xml_list_date : Xml.xml list = xml_list_of_ts_date_opt doc.fld_doc_date in
        let xml_list_abstract : Xml.xml list = xml_list_of_ts_abstract_opt doc.fld_doc_abstract in
        let xml_list_main : Xml.xml list = [xml_of_tu_doc_main doc.fld_doc_main] in
        let xml_list_refs : Xml.xml list = xml_list_of_ts_refs_opt doc.fld_doc_refs in
        let xml_list_doc : Xml.xml list = List.concat [
                xml_list_preamble;
                xml_list_title;
                xml_list_authors;
                xml_list_date;
                xml_list_abstract;
                xml_list_main;
                xml_list_refs;
        ]
        in
        Xml.Element ("cr_doc",[],xml_list_doc)

and xml_list_of_ts_preamble_opt (preamble_opt : ts_preamble option) : Xml.xml list =
        match preamble_opt with
        | None -> []
        | Some preamble -> [xml_of_ts_preamble preamble]

and xml_list_of_ts_title_opt (title_opt : ts_title option) : Xml.xml list =
        match title_opt with
        | None -> []
        | Some title -> [xml_of_ts_title title]

and xml_list_of_ts_authors_opt (authors_opt : ts_authors option) : Xml.xml list =
        match authors_opt with
        | None -> []
        | Some (Cs_authors (author_list : ts_author list)) -> 
                [Xml.Element ("cs_authors",[],List.map xml_of_ts_author author_list)]

and xml_list_of_ts_date_opt (date_opt : ts_date option) : Xml.xml list =
        match date_opt with
        | None -> []
        | Some date -> [xml_of_ts_date date]

and xml_list_of_ts_abstract_opt (abstract_opt : ts_abstract option) : Xml.xml list =
        match abstract_opt with
        | None -> []
        | Some abstract -> [xml_of_ts_abstract abstract]

and xml_list_of_ts_refs_opt (refs_opt : ts_refs option) : Xml.xml list =
        match refs_opt with
        | None -> []
        | Some refs -> [xml_of_ts_refs refs]


and xml_of_ts_preamble (preamble : ts_preamble) : Xml.xml =
        match preamble with
        | Cs_preamble (s : string) -> Xml.Element ("cs_preamble",[],[xml_of_string s])

and xml_of_ts_title (title:ts_title):Xml.xml=
        match title with
        |Cs_title (s:string) -> Xml.Element ("cs_title",[],[xml_of_string s])

and xml_of_ts_author (author:ts_author):Xml.xml=
        match author with
        |Cs_author (s:string) -> Xml.Element ("cs_author",[],[xml_of_string s])

and xml_of_ts_date (date : ts_date) : Xml.xml =
        match date with
        | Cs_date (s : string) -> Xml.Element ("cs_date",[],[xml_of_string s])

and xml_of_ts_abstract (abstract:ts_abstract):Xml.xml = 
        match abstract with
        |Cs_abstract (blks: ts_blks) ->
                Xml.Element ("cs_abstract",[], [xml_of_ts_blks blks])

and xml_of_ts_refs (refs:ts_refs):Xml.xml = 
        match refs with
        |Cs_refs (blks: ts_blks) ->
                Xml.Element ("cs_refs",[], [xml_of_ts_blks blks])

and xml_of_tu_doc_main (doc_main:tu_doc_main):Xml.xml=
        match doc_main with
        |Cu_doc_main_chs (chs:ts_chs) -> Xml.Element ("cu_doc_main_chs",[],[xml_of_ts_chs chs])
        |Cu_doc_main_secs (secs:ts_secs) -> Xml.Element ("cu_doc_main_secs",[],[xml_of_ts_secs secs])
        |Cu_doc_main_pars (pars:ts_pars) -> Xml.Element ("cu_doc_main_pars",[],[xml_of_ts_pars pars])
        |Cu_doc_main_blks (blks:ts_blks) -> Xml.Element ("cu_doc_main_blks",[],[xml_of_ts_blks blks])

and xml_of_ts_chs (chs:ts_chs):Xml.xml=
        match chs with
        |Cs_chs (ch_list:tr_ch list) -> Xml.Element ("cs_chs",[],List.map xml_of_tr_ch ch_list)

and xml_of_ts_secs (secs:ts_secs):Xml.xml=
        match secs with
        |Cs_secs (sec_list:tr_sec list) -> Xml.Element ("cs_secs",[],List.map xml_of_tr_sec sec_list)

and xml_of_ts_pars (pars:ts_pars):Xml.xml=
        match pars with
        |Cs_pars (par_list:tu_par list) -> Xml.Element ("cs_pars",[],List.map xml_of_tu_par par_list)

and xml_of_ts_blks (blks:ts_blks):Xml.xml=
        match blks with
        |Cs_blks (blk_list:tu_blk list) -> Xml.Element ("cs_blks",[],List.map xml_of_tu_blk blk_list)

and xml_of_tr_ch (ch:tr_ch):Xml.xml=
        let a:Xml.xml list=
                match ch.fld_ch_tag_or_id with
                |None -> []
                |Some (tag_or_id:tu_tag_or_id)->[xml_of_tu_tag_or_id tag_or_id]
        in
        let b:Xml.xml list=
                match ch.fld_ch_hdr with
                |None -> []
                |Some (hdr:ts_hdr)->[xml_of_ts_hdr hdr]
        in
        let c:Xml.xml list=[xml_of_tu_secs_pars_or_blks ch.fld_ch_main] in
        Xml.Element ("cr_ch",[],List.concat [a;b;c])

and xml_of_tr_sec (sec:tr_sec):Xml.xml=
        let a:Xml.xml list=
                match sec.fld_sec_tag_or_id with
                |None -> []
                |Some (tag_or_id:tu_tag_or_id)->[xml_of_tu_tag_or_id tag_or_id]
        in
        let b:Xml.xml list=
                match sec.fld_sec_hdr with
                |None -> []
                |Some (hdr:ts_hdr)->[xml_of_ts_hdr hdr]
        in
        let c:Xml.xml list=[xml_of_tu_pars_or_blks sec.fld_sec_main] in
        Xml.Element ("cr_sec",[],List.concat [a;b;c])

and xml_of_tu_par (p : tu_par) : Xml.xml =
        match p with
        |Cu_par_std (par_std : tr_par_std) -> Xml.Element ("cu_par_std", [], [xml_of_tr_par_std par_std])
        |Cu_par_rpt (par_rpt : ts_par_rpt) -> Xml.Element ("cu_par_rpt",[],[xml_of_ts_par_rpt par_rpt])

and xml_of_tr_par_std (par:tr_par_std):Xml.xml=
        let a:Xml.xml list=
                match par.fld_par_tag_or_id with
                |None -> []
                |Some (tag_or_id:tu_tag_or_id)->[xml_of_tu_tag_or_id tag_or_id]
        in
        let b:Xml.xml list=
                match par.fld_par_hdr with
                |None -> []
                |Some (hdr:ts_hdr)->[xml_of_ts_hdr hdr]
        in
        let c:Xml.xml list=[xml_of_ts_blks par.fld_par_main] in
        Xml.Element ("cr_par_std",[],List.concat [a;b;c])

and xml_of_ts_par_rpt (par_rpt : ts_par_rpt) : Xml.xml =
        match par_rpt with
        |Cs_par_rpt (id : tr_id) -> Xml.Element ("cs_par_rpt",[],[xml_of_tr_id id])

and xml_of_tu_blk (blk:tu_blk):Xml.xml=
        match blk with
        |Cu_blk_txt (blk_txt:ts_blk_txt) -> Xml.Element ("cu_blk_txt",[],[xml_of_ts_blk_txt blk_txt])
        |Cu_blk_blt (blk_blt:ts_blk_blt) -> Xml.Element ("cu_blk_blt",[],[xml_of_ts_blk_blt blk_blt])
        |Cu_blk_itm (blk_itm:tr_blk_itm) -> Xml.Element ("cu_blk_itm",[],[xml_of_tr_blk_itm blk_itm])
        |Cu_blk_dsp (blk_dsp:ts_blk_dsp) -> Xml.Element ("cu_blk_dsp",[],[xml_of_ts_blk_dsp blk_dsp])
        |Cu_blk_vrb (blk_vrb:ts_blk_vrb) -> Xml.Element ("cu_blk_vrb",[],[xml_of_ts_blk_vrb blk_vrb])

and xml_of_tu_secs_pars_or_blks (secs_pars_or_blks:tu_secs_pars_or_blks):Xml.xml=
        match secs_pars_or_blks with
        |Cu_secs_pars_or_blks_secs (secs:ts_secs) -> Xml.Element ("cu_secs_pars_or_blks_secs",[],[xml_of_ts_secs secs])
        |Cu_secs_pars_or_blks_pars (pars:ts_pars) -> Xml.Element ("cu_secs_pars_or_blks_pars",[],[xml_of_ts_pars pars])
        |Cu_secs_pars_or_blks_blks (blks:ts_blks) -> Xml.Element ("cu_secs_pars_or_blks_blks",[],[xml_of_ts_blks blks])

and xml_of_tu_pars_or_blks (pars_or_blks:tu_pars_or_blks):Xml.xml=
        match pars_or_blks with
        |Cu_pars_or_blks_pars (pars:ts_pars) -> Xml.Element ("cu_pars_or_blks_pars",[],[xml_of_ts_pars pars])
        |Cu_pars_or_blks_blks (blks:ts_blks) -> Xml.Element ("cu_pars_or_blks_blks",[],[xml_of_ts_blks blks])


and xml_of_ts_blk_txt (blk_txt:ts_blk_txt):Xml.xml=
        match blk_txt with
        |Cs_blk_txt (txt_units:ts_txt_units) -> Xml.Element ("cs_blk_txt",[],[xml_of_ts_txt_units txt_units])

and xml_of_ts_blk_blt (blk_blt:ts_blk_blt):Xml.xml=
        match blk_blt with
        |Cs_blk_blt (blks:ts_blks) -> Xml.Element ("cs_blk_blt",[],[xml_of_ts_blks blks])

and xml_of_tr_blk_itm (blk_itm:tr_blk_itm):Xml.xml=
        let a:Xml.xml list=[xml_of_tu_lbl blk_itm.fld_blk_itm_lbl] in
        let b:Xml.xml list=
                match blk_itm.fld_blk_itm_id with
                |None -> []
                |Some (id:tr_id)-> [xml_of_tr_id id]
                in
                let c:Xml.xml list=[xml_of_ts_blks blk_itm.fld_blk_itm_main] in
                Xml.Element ("cr_blk_itm",[],List.concat [a;b;c])

and xml_of_ts_blk_dsp (blk_dsp:ts_blk_dsp):Xml.xml=
        match blk_dsp with
        |Cs_blk_dsp (dsp_lines:ts_dsp_lines) -> Xml.Element ("cs_blk_dsp",[],[xml_of_ts_dsp_lines dsp_lines])

and xml_of_ts_blk_vrb (blk_vrb : ts_blk_vrb) : Xml.xml =
        match blk_vrb with
        |Cs_blk_vrb (vrb_lines : ts_vrb_lines) -> Xml.Element ("cs_blk_vrb",[],[xml_of_ts_vrb_lines vrb_lines])

and xml_of_ts_vrb_lines (vrb_lines : ts_vrb_lines) : Xml.xml =
        match vrb_lines with
        |Cs_vrb_lines (vrb_line_list : ts_vrb_line list) -> Xml.Element ("cs_vrb_lines",[],List.map xml_of_ts_vrb_line vrb_line_list)

and xml_of_ts_vrb_line (vrb_line : ts_vrb_line) : Xml.xml =
        match vrb_line with
        |Cs_vrb_line (s : string) -> 
                match s with
                |"" -> Xml.Element ("cs_vrb_line",[],[]) 
                |_ -> Xml.Element ("cs_vrb_line",[],[xml_of_string s])

and xml_of_ts_txt_units (txt_units:ts_txt_units):Xml.xml=
        match txt_units with
        |Cs_txt_units (txt_unit_list:tu_txt_unit list) -> Xml.Element ("cs_txt_units",[],List.map xml_of_tu_txt_unit txt_unit_list)

and xml_of_ts_dsp_lines (dsp_lines:ts_dsp_lines):Xml.xml=
        match dsp_lines with
        |Cs_dsp_lines (dsp_line_list:tr_dsp_line list) -> Xml.Element ("cs_dsp_lines",[],List.map xml_of_tr_dsp_line dsp_line_list)

and xml_of_tr_dsp_line (dsp_line:tr_dsp_line):Xml.xml=
        let c:Xml.xml list=[xml_of_ts_txt_units dsp_line.fld_dsp_line_units] in
        match dsp_line.fld_dsp_line_lbl with
                |None -> Xml.Element ("cu_dsp_line_no_lbl",[],[Xml.Element ("cs_dsp_line_no_lbl",[],c)])
                |Some (lbl:tu_lbl) -> 
                        let a:Xml.xml list=[xml_of_tu_lbl lbl] in
                        let b:Xml.xml list=
                                match dsp_line.fld_dsp_line_id with
                                |None -> []
                                |Some (id:tr_id)-> [xml_of_tr_id id]
                        in
                        let d:Xml.xml list=[Xml.Element ("cr_dsp_line_lbld",[],List.concat [a;b;c])] in
                        Xml.Element ("cu_dsp_line_lbld",[],d)

and xml_of_tu_txt_unit (a:tu_txt_unit):Xml.xml=
        match a with
        |Cu_txt_unit_wysiwyg (b:ts_txt_unit_wysiwyg) -> Xml.Element ("cu_txt_unit_wysiwyg",[],[xml_of_ts_txt_unit_wysiwyg b]) 
        |Cu_txt_unit_emph (b:ts_txt_unit_emph) -> Xml.Element ("cu_txt_unit_emph",[],[xml_of_ts_txt_unit_emph b])
        |Cu_txt_unit_c_ref (b:ts_txt_unit_c_ref) -> Xml.Element ("cu_txt_unit_c_ref",[],[xml_of_ts_txt_unit_c_ref b])

and xml_of_ts_txt_unit_wysiwyg (a:ts_txt_unit_wysiwyg):Xml.xml =
        match a with Cs_txt_unit_wysiwyg (b:string) -> Xml.Element ("cs_txt_unit_wysiwyg",[],[xml_of_string b]) 

and xml_of_ts_txt_unit_emph (a:ts_txt_unit_emph):Xml.xml =
        match a with Cs_txt_unit_emph (b:string) -> Xml.Element ("cs_txt_unit_emph",[],[xml_of_string b]) 

and xml_of_ts_txt_unit_c_ref (a:ts_txt_unit_c_ref):Xml.xml =
        match a with Cs_txt_unit_c_ref (b:ts_c_ref) -> Xml.Element ("cs_txt_unit_c_ref",[],[xml_of_ts_c_ref b])

and xml_of_ts_c_ref (a:ts_c_ref):Xml.xml=
        match a with Cs_c_ref (b:tr_id) -> Xml.Element ("cs_c_ref",[],[xml_of_tr_id b])

and xml_of_tu_tag_or_id (tag_or_id:tu_tag_or_id):Xml.xml=
        match tag_or_id with
        |Cu_tag_or_id_tag (tag:ts_tag) -> Xml.Element ("cu_tag_or_id_tag",[],[xml_of_ts_tag tag])
        |Cu_tag_or_id_id (id:tr_id) -> Xml.Element ("cu_tag_or_id_id",[],[xml_of_tr_id id])

and xml_of_ts_hdr (hdr:ts_hdr):Xml.xml=
        match hdr with
        |Cs_hdr (txt_units:ts_txt_units) -> Xml.Element ("cs_hdr",[],[xml_of_ts_txt_units txt_units])


and xml_of_tu_lbl (a:tu_lbl):Xml.xml=
        match a with
        |Cu_lbl_auto (b:ts_lbl_auto) -> Xml.Element ("cu_lbl_auto",[],[xml_of_ts_lbl_auto b])
        |Cu_lbl_custom (b:ts_lbl_custom) -> Xml.Element ("cu_lbl_custom",[],[xml_of_ts_lbl_custom b])

and xml_of_ts_lbl_auto (a:ts_lbl_auto):Xml.xml=
        match a with Cs_lbl_auto -> Xml.Element ("cs_lbl_auto",[],[])

and xml_of_ts_lbl_custom (a:ts_lbl_custom):Xml.xml=
        match a with Cs_lbl_custom (b:string) -> Xml.Element ("cs_lbl_custom",[],[xml_of_string b])


and xml_of_tr_id (id:tr_id):Xml.xml=
        let a:Xml.xml=xml_of_ts_tag id.fld_id_tag in
        let b:Xml.xml=xml_of_ts_name id.fld_id_name in
        match id.fld_id_scope with
        |Some scope ->
                let c:Xml.xml = xml_of_tu_scope scope in
                Xml.Element ("cr_id",[],[a;b;c])
        |None -> 
                Xml.Element ("cr_id",[],[a;b])

and xml_of_tu_scope (scope : tu_scope) : Xml.xml =
        match scope with
        |Cu_scope_gbl -> Xml.Element ("cu_scope_gbl",[],[])
        |Cu_scope_ch -> Xml.Element ("cu_scope_ch",[],[])
        |Cu_scope_sec -> Xml.Element ("cu_scope_sec",[],[])
        |Cu_scope_app -> Xml.Element ("cu_scope_app",[],[])
        |Cu_scope_par -> Xml.Element ("cu_scope_par",[],[])


and xml_of_ts_tag (tag:ts_tag):Xml.xml=
        match tag with
        |Cs_tag (s:string) -> Xml.Element ("cs_tag",[],[xml_of_string s])

and xml_of_ts_name (name:ts_name):Xml.xml=
        match name with
        |Cs_name (s:string) -> Xml.Element ("cs_name",[],[xml_of_string s])

and xml_of_string (s:string):Xml.xml=
        PCData (Exml_utils.pcdata_of_string s)
