let rec html_of_exml (element:Xml.xml):Xml.xml=
	match element with
	|Xml.Element ("title", attr_list, xml_list) -> Xml.Element ("h1", ("class", "title")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("author", attr_list, xml_list) -> Xml.Element ("p", ("class", "author")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("ch_hdr", attr_list, xml_list) -> Xml.Element ("h2", ("class", "ch_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("sec_hdr", attr_list, xml_list) -> Xml.Element ("h3", ("class", "sec_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("par_hdr", attr_list, xml_list) -> Xml.Element ("h4", ("class", "par_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("blk_txt", attr_list, xml_list) -> Xml.Element ("p", ("class", "blk_txt")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("txt_unit_wysiwyg", attr_list, [Xml.PCData s]) -> Xml.PCData s
	|Xml.Element ("txt_unit_emph", attr_list, xml_list) -> Xml.Element ("em", ("class", "txt_unit_emph")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("txt_unit_c_ref", attr_list, xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element (tag,attr_list, xml_list) -> Xml.Element ("div", ("class", tag)::attr_list, List.map html_of_exml xml_list)
	|Xml.PCData s -> Xml.PCData s

let css_for_html ( doc_settings : Txt_utils.t_doc_settings) : string = 

"html {
        --font_family:monospace;
        --font_size:12px;
        --title_indent:" ^ (string_of_int doc_settings.title_indent) ^ "ch;
        --author_indent:" ^ (string_of_int doc_settings.author_indent) ^ "ch;
        --left_margin:" ^ (string_of_int doc_settings.left_margin) ^ "ch;
        --tab_length:" ^ (string_of_int doc_settings.tab_length) ^ "ch;
        font-family:var(--font_family);
        font-size:var(--font-size);
}

div.doc {
        display:block;
}


h1.title {
        display:block;
        font-size:var(--font-size);
        margin-left:var(--title_indent);
}


p.author {
        display:block;
        margin-left:var(--author_indent);
}


div.doc_main {
        display:block;
}


div.sec {
        display:block;
}


div.sec + div.sec {
        margin-top:3ch;
}


div.sec_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


h3.sec_hdr {
        display:block;
        font-size:var(--font-size);
        margin-left:var(--left_margin);
}


div.sec_main {
        display:block;
}


div.sec_lbl + div.sec_main::before {    /* prevents par from jumping up when left_margin is 0 */
        content:\" \";
        white-space:pre;
}


div.par {
        display:block;
}


div.par + div.par {
        margin-top:2ch;
}


div.par_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


h4.par_hdr {                      /* content of par_hdr is moved inside par_main for inline display */
        visibility:hidden;
        height:0ch;
        width:0ch;
        float:left;
}


div.par_main {
        display:block;
}


p.blk_txt {
        display:block;
        hyphens:auto;
        white-space:pre-wrap;
}


div.par_main > p.blk_txt {
        margin-left:var(--left_margin);
}


div.sec_main > p.blk_txt {
        margin-left:var(--left_margin);
}


div.blk_blt {
        display:block;
}


div.par_main > div.blk_blt {
        margin-left:var(--left_margin)
}


div.sec_main > div.blk_blt {
        margin-left:var(--left_margin);
}


div.blk_blt_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


div.blk_blt_main {
        display:block;
        margin-left:var(--tab_length);
}


div.blk_itm {
        display:block;
}


div.par_main > div.blk_itm {
        margin-left:var(--left_margin);
}


div.sec_main > div.blk_itm {
        margin-left:var(--left_margin);
}


div.blk_itm_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


div.blk_itm_main {
        display:block;
        margin-left:var(--tab_length);
}


div.blk_dsp {
        display:block;
        white-space:nowrap;
}


div.par_main > div.blk_dsp {
        margin-left:var(--left_margin);
}


div.sec_main > div.blk_dsp {
        margin-left:var(--left_margin);
}


div.dsp_line {
        display:block;
}


div.dsp_line_lbl {
        display:block;
        float:left;
        margin-right:1ch;
}


div.dsp_line_main {
        display:block;
        white-space:pre;
        margin-left:var(--tab_length);
}


a {
        text-decoration:none;
}


@media print {
        .sec_hdr, .sec_lbl, .par_hdr, .par_lbl {
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

