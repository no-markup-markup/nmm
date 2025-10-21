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

let internal_css (doc_type : Common_utils.t_doc_type) ( doc_settings : Common_utils.t_doc_settings) : string = 
	let n : int = 8 in
	let left_margin : string = Int.to_string (doc_settings.left_margin * n) in
	let tab_length : string = Int.to_string doc_settings.tab_length in
	let title_font_size : string = 
		match doc_type with
		|CHS -> "24px"
		|SECS -> "20px"
		|_ -> "16px"
	in
	let refs_hdr_font_size : string = 
		match doc_type with
		|CHS -> "var(--ch_hdr_font_size)"
		|SECS -> "var(--sec_hdr_font_size)"
		|_ -> "var(--small_hdr_font_size)"
	in
"html {
        --ch_hdr_font_size:20px;
        --sec_hdr_font_size:16px;
        --small_hdr_font_size:14px;
        --left_margin:" ^ left_margin ^ "px;
        --tab_length:" ^ tab_length ^ "ch;
        font-family:monospace;
        font-size:12px;
}

.doc {
        display:block;
}


.title {
        display:block;
        font-size:" ^ title_font_size ^ ";
        margin-left:var(--left_margin);
}


.author {
        display:block;
        margin-left:var(--left_margin);
        font-size:14px;
        margin-bottom:3em;
}


.abstract {
        display:block;
        margin-bottom:3em;
}


.abstract_hdr {
        display:block;
        margin-left:var(--left_margin);
        font-weight:bold;
        font-size:var(--small_hdr_font_size);
}

.refs {
        display:block;
        margin-top:3em;
}


.refs_hdr {
        display:block;
        margin-left:var(--left_margin);
        font-weight:normal;
        font-size:" ^ refs_hdr_font_size ^ ";
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
        font-size:var(--ch_hdr_font_size);
        margin-left:var(--left_margin);
        font-weight:normal;
}


.ch_hdr {
        display:block;
        font-size:var(--ch_hdr_font_size);
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
        font-size:var(--sec_hdr_font_size);
}


.sec_hdr {
        display:block;
        font-size:var(--sec_hdr_font_size);
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
}



.abstract > .blk_txt {
        margin-left:var(--left_margin);
}

.refs > .blk_txt {
        margin-left:var(--left_margin);
}


.ch_main > .blk_txt {
        margin-left:var(--left_margin);
}


.sec_main > .blk_txt {
        margin-left:var(--left_margin);
}


.par_main > .blk_txt {
        margin-left:var(--left_margin);
}


.blk_blt {
        display:block;
}

.abstract > .blk_blt {
        margin-left:var(--left_margin);
}

.refs > .blk_blt {
        margin-left:var(--left_margin);
}


.ch_main > .blk_blt {
        margin-left:var(--left_margin);
}


.sec_main > .blk_blt {
        margin-left:var(--left_margin);
}


.par_main > .blk_blt {
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
}

.abstract > .blk_itm {
        margin-left:var(--left_margin);
}

.refs > .blk_itm {
        margin-left:var(--left_margin);
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

.abstract > .blk_dsp {
        margin-left:var(--left_margin);
}

.refs > .blk_dsp {
        margin-left:var(--left_margin);
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

