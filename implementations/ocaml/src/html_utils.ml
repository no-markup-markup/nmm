let rec html_of_exml (element:Xml.xml):Xml.xml=
	match element with
	|Xml.Element ("title", attr_list, xml_list) -> Xml.Element ("h1", ("class", "title")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("author", attr_list, xml_list) -> Xml.Element ("p", ("class", "author")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("abstract_hdr", attr_list,xml_list) -> Xml.Element ("h2", ("class", "abstract_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("refs_hdr", attr_list,xml_list) -> Xml.Element ("h2", ("class", "refs_hdr")::attr_list,List.map html_of_exml xml_list)
	|Xml.Element ("ch_hdr", attr_list, xml_list) -> Xml.Element ("h2", ("class", "ch_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("ch_lbl_hdr", attr_list, xml_list) -> Xml.Element ("h2", ("class", "ch_lbl_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("sec_hdr", attr_list, xml_list) -> Xml.Element ("h3", ("class", "sec_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("sec_lbl_hdr", attr_list, xml_list) -> Xml.Element ("h3", ("class", "sec_lbl_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("par_hdr", attr_list, xml_list) -> Xml.Element ("h4", ("class", "par_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("blk_txt", attr_list, xml_list) -> Xml.Element ("p", ("class", "blk_txt")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("txt_unit_wysiwyg", attr_list, [Xml.PCData s]) -> Xml.PCData s
	|Xml.Element ("txt_unit_emph", attr_list, xml_list) -> Xml.Element ("em", ("class", "txt_unit_emph")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("txt_unit_c_ref", attr_list, xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element (tag, attr_list, xml_list) -> Xml.Element ("div", ("class", tag)::attr_list, List.map html_of_exml xml_list)
	|Xml.PCData s -> Xml.PCData s

let internal_css ( doc_settings : Common_utils.t_doc_settings) : string = 
	let n : int = 8 in
	let title_indent : string = Int.to_string (doc_settings.title_indent * n) in
	let author_indent : string = Int.to_string (doc_settings.author_indent * n) in
	let abstract_indent : string = Int.to_string (doc_settings.abstract_indent * n) in
	let refs_indent : string = Int.to_string (doc_settings.refs_indent * n) in
	let left_margin : string = Int.to_string (doc_settings.left_margin * n) in
	let tab_length : string = Int.to_string doc_settings.tab_length in
"html {
        --font_family:monospace;
        --font_size:12px;
        --title_indent:" ^ title_indent ^ "px;
        --author_indent:" ^ author_indent ^ "px;
        --abstract_indent:" ^ abstract_indent ^ "px;
        --refs_indent:" ^ refs_indent ^ "px;
        --left_margin:" ^ left_margin ^ "px;
        --tab_length:" ^ tab_length ^ "ch;
        font-family:var(--font_family);
        font-size:var(--font-size);
}

.doc {
        display:block;
}


.title {
        display:block;
        font-size:24px;
        margin-left:var(--title_indent);
}


.author {
        display:block;
        margin-left:var(--author_indent);
        font-size:14px;
        margin-bottom:3em;
}


.abstract {
        display:block;
        margin-left:var(--abstract_indent);
        margin-bottom:3em;
}


.abstract_hdr {
        display:block;
        font-weight:normal;
        font-size:14px;
}

.refs {
        display:block;
        margin-left:var(--refs_indent);
        margin-top:3em;
}


.refs_hdr {
        display:block;
        font-weight:normal;
        font-size:14px;
}


.doc_main {
        display:block;
}


.ch {
        display:block;
}


.ch + .ch {
        margin-top:3em;
}


.ch_lbl, .ch_lbl_hdr {
        display:block;
        font-size:14px;
        margin-left:var(--left_margin);
        font-weight:normal;
}


.ch_hdr {
        display:block;
        font-size:20px;
        margin-left:var(--left_margin);
}


.sec {
        display:block;
}


.sec + .sec {
        margin-top:2em;
}


.sec_lbl {
        display:block;
        float:left;
        margin-right:1ch;
        font-size:16px;
}


.sec_hdr {
        display:block;
        font-size:16px;
        margin-left:var(--left_margin);
}

/* ensures that sec_lbl_hdr shows up in disposition when printing to pdf with weasyprint */
.sec_lbl_hdr {
        visibility:hidden;
        font-size:16px;
}

.sec_main {
        display:block;
}


/* prevents par from jumping up when left_margin is 0 */
.sec_lbl + .sec_main::before {
        content:\" \";
        white-space:pre;
}


.par {
        display:block;
}

.par + .par {
        margin-top:2em;
}


.par_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


/* content of par_hdr has been copied to par_main for inline display.
this ensures that par_hdr shows up in disposition when printing to pdf with weasyprint */
.par_hdr {
        visibility:hidden;
        height:0ch;
        width:0ch;
        float:left;
}


.par_main {
        display:block;
}


.blk_txt {
        display:block;
        hyphens:auto;
        white-space:pre-wrap;
        margin-left:var(--left_margin);
}


.blk_blt {
        display:block;
        margin-left:var(--left_margin);
}

.blk_blt_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


.blk_blt_main {
        display:block;
        margin-left:var(--tab_length);
}


.blk_itm {
        display:block;
        margin-left:var(--left_margin);
}


.blk_itm_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


.blk_itm_main {
        display:block;
        margin-left:var(--tab_length);
}


.blk_dsp {
        display:block;
        white-space:nowrap;
        margin-left:var(--left_margin);
}



.dsp_line {
        display:block;
}


.dsp_line_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


.dsp_line_main {
        display:block;
        white-space:pre;
        margin-left:var(--tab_length);
}


a {
        text-decoration:none;
}


@media print {
        .ch_hdr, .ch_lbl, .sec_hdr, .sec_lbl, .par_hdr, .par_lbl {
                page-break-after:avoid;
        }

/* For one-sided printing:*/
        @page {
                size:a4;
                margin-top:20mm;
                margin-left:20mm;
                margin-right:20mm;
                margin-bottom:30mm;

                @top-center {
                        content:\" \";
                }

                @bottom-center {
                        padding:10mm;
                        content: counter(page) \" of \" counter(pages);
                }
        }
}"

