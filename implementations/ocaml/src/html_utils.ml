let rec html_of_exml (element:Xml.xml):Xml.xml=
	match element with
	|Xml.Element ("doc", attr_list, xml_list) -> Xml.Element ("div", attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("title", _, xml_list) -> Xml.Element ("h1", [("class", "title")], List.map html_of_exml xml_list)
	|Xml.Element ("author", _, xml_list) -> Xml.Element ("p", [("class", "author")], List.map html_of_exml xml_list)
	|Xml.Element ("abstract_hdr", _,xml_list) -> Xml.Element ("h2", [("class", "abstract_hdr")], List.map html_of_exml xml_list)
	|Xml.Element ("refs_hdr", _,xml_list) -> Xml.Element ("h2", [("class", "refs_hdr")],List.map html_of_exml xml_list)
	|Xml.Element ("ch_hdr", _, xml_list) -> Xml.Element ("h2", [("class", "ch_hdr")], List.map html_of_exml xml_list)
	|Xml.Element ("ch_lbl_hdr", _, xml_list) -> Xml.Element ("h2", [("class", "ch_lbl_hdr")], List.map html_of_exml xml_list)
	|Xml.Element ("sec_hdr", _, xml_list) -> Xml.Element ("h3", [("class", "sec_hdr")], List.map html_of_exml xml_list)
	|Xml.Element ("sec_lbl_hdr", attr_list, xml_list) -> Xml.Element ("h3", ("class", "sec_lbl_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("par_hdr", attr_list, xml_list) -> Xml.Element ("h4", ("class", "par_hdr")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element ("blk_txt", _, xml_list) -> Xml.Element ("p", [("class", "blk_txt")], List.map html_of_exml xml_list)
	|Xml.Element ("txt_unit_wysiwyg", _, [Xml.PCData s]) -> Xml.PCData s
	|Xml.Element ("txt_unit_emph", _, xml_list) -> Xml.Element ("em", [("class", "txt_unit_emph")], List.map html_of_exml xml_list)
	|Xml.Element ("txt_unit_c_ref", attr_list, xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map html_of_exml xml_list)
	|Xml.Element (tag, attr_list, xml_list) -> Xml.Element ("div", ("class", tag)::attr_list, List.map html_of_exml xml_list)
	|Xml.PCData s -> Xml.PCData s

let internal_css ( doc_settings : Common_utils.t_doc_settings) : string =
	let left_margin : string = (Int.to_string (Int.max 0 (doc_settings.left_margin - 4))) ^ "rem" in
	let tab_length : string = (Int.to_string doc_settings.tab_length) ^ "ch" in
"html {
  --left_margin:" ^ left_margin ^ ";
  --tab_length:" ^ tab_length ^ ";
  font-family:monospace;
  font-size:medium;
  line-height:165%;
}


.doc {
  display:block;
}


.title {
  display:block;
  margin-left:var(--left_margin);
  font-weight:normal;
  font-size:large;
}


.chs .title {
  font-size:xx-large;
}


.doc.secs .title {
  font-size:x-large;
}


.authors {
  display:block;
  margin-left:var(--left_margin);
  margin-bottom:3em;
}


.doc.chs .author {
 font-size:large;
}


.doc.secs .author {
 font-size:large;
}


.abstract {
  display:block;
  margin-bottom:3em;
}


.abstract_hdr {
  display:block;
  margin-left:var(--left_margin);
  font-weight:normal;
  font-size:large;
}


.refs {
  display:block;
  margin-top:3em;
}


.refs_hdr {
  display:block;
  margin-left:var(--left_margin);
  font-weight:normal;
  font-size:large;
}


.doc.chs .refs_hdr {
 font-size:x-large;
}


.doc.secs .refs_hdr {
 font-size:large;
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
  margin-left:var(--left_margin);
  font-weight:normal;
  font-size:x-large;
}


.ch_hdr {
  display:block;
  margin-left:var(--left_margin);
  font-size:x-large;
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
  font-size:large;
}


.sec_hdr {
  display:block;
  margin-left:var(--left_margin);
  font-size:large;
}



.sec_main {
  display:block;
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


/* Content of par_hdr has been copied to par_main for inline display, and visibility is set to hidden
by inline styling. It is there to ensure that it shows up in disposition when printing to pdf with weasyprint. */
.par_hdr {
  height:0;
  width:0;
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

  html {
    font-size:12px;
  }


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

