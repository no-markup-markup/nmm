let rec html_of_exml (element:Xml.xml):Xml.xml=
	match element with
	|Xml.Element ("title", attr_list, xml_list) -> Xml.Element ("h1", ("class", "title")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("author", attr_list, xml_list) -> Xml.Element ("p", ("class", "author")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("abstract", attr_list,xml_list) -> 
		Xml.Element ("div",("class", "abstract")::attr_list, (Xml.Element ("h2", [("class", "abstract_hdr")],[Xml.PCData "ABSTRACT"]))::(List.map html_of_exml xml_list))
	|Xml.Element ("refs", attr_list,xml_list) -> 
		Xml.Element ("div",("class", "refs")::attr_list, (Xml.Element ("h2", [("class", "refs_hdr")],[Xml.PCData "REFERENCES"]))::(List.map html_of_exml xml_list))
	|Xml.Element ("ch_hdr", attr_list, xml_list) -> Xml.Element ("h2", ("class", "ch_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("ch_lbl_hdr", attr_list, xml_list) -> Xml.Element ("h2", ("class", "ch_lbl_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("sec_hdr", attr_list, xml_list) -> Xml.Element ("h3", ("class", "sec_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("sec_lbl_hdr", attr_list, xml_list) -> Xml.Element ("h3", ("class", "sec_lbl_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("par_hdr", attr_list, xml_list) -> Xml.Element ("h4", ("class", "par_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("par_lbl_hdr", attr_list, xml_list) -> Xml.Element ("h4", ("class", "par_lbl_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("blk_txt", attr_list, xml_list) -> Xml.Element ("p", ("class", "blk_txt")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("txt_unit_wysiwyg", attr_list, [Xml.PCData s]) -> Xml.PCData s
	|Xml.Element ("txt_unit_emph", attr_list, xml_list) -> Xml.Element ("em", ("class", "txt_unit_emph")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("txt_unit_c_ref", attr_list, xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element (tag,attr_list, xml_list) -> Xml.Element ("div", ("class", tag)::attr_list, List.map html_of_exml xml_list)
	|Xml.PCData s -> Xml.PCData s

let css_for_html ( doc_settings : Common_utils.t_doc_settings) : string = 

"html {
        --font_family:monospace;
        --font_size:12px;
        --title_indent:" ^ (string_of_int (doc_settings.title_indent * 8)) ^ "px;
        --author_indent:" ^ (string_of_int (doc_settings.author_indent * 8)) ^ "px;
        --abstract_indent:" ^ (string_of_int (doc_settings.abstract_indent * 8)) ^ "px;
        --left_margin:" ^ (string_of_int (doc_settings.left_margin * 8)) ^ "px;
        --tab_length:" ^ (string_of_int doc_settings.tab_length) ^ "ch;
        font-family:var(--font_family);
        font-size:var(--font-size);
}

.doc {
        display:block;
}


.title {
        display:block;
        font-size:20px;
        margin-left:var(--title_indent);
}


.author {
        display:block;
        margin-left:var(--author_indent);
        font-size:14px;
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
        font-size:18px;
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


/* content of par_hdr has been copied to par_main for inline display */
.par_hdr, .par_lbl_hdr {
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
}


.par_main > .blk_txt {
        margin-left:var(--left_margin);
}

.ch_main > .blk_txt {
        margin-left:var(--left_margin);
}


.sec_main > .blk_txt {
        margin-left:var(--left_margin);
}


.blk_blt {
        display:block;
}

.ch_main > .blk_blt {
        margin-left:var(--left_margin);
}


.sec_main > .blk_blt {
        margin-left:var(--left_margin);
}


.par_main > .blk_blt {
        margin-left:var(--left_margin)
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
}


.ch_main > .blk_itm {
        margin-left:var(--left_margin);
}


.sec_main > .blk_itm {
        margin-left:var(--left_margin);
}


.par_main > .blk_itm {
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
}


.ch_main > .blk_dsp {
        margin-left:var(--left_margin);
}


.sec_main > .blk_dsp {
        margin-left:var(--left_margin);
}


.par_main > .blk_dsp {
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

