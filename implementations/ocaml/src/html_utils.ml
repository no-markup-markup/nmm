open Common_utils

exception Error of string

let rec html_of_exml (doc_class : Common_utils.t_doc_class) (element:Xml.xml):Xml.xml=
	match element with
	|Xml.Element ("doc", attr_list, xml_list) -> 
		Xml.Element ("div", ("style","display:block")::attr_list, List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("title", _, xml_list) ->
		Xml.Element ("h1", [("class", "title")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("authors", _, xml_list) ->
		Xml.Element ("div", [("class", "authors");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("author", _, xml_list) ->
		Xml.Element ("p", [("class", "author")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("abstract_hdr", _,xml_list) -> (
		match doc_class with
		|DOC_CHS ->
			Xml.Element ("h2", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)
		|DOC_SECS ->
			Xml.Element ("h3", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)
		|DOC_PARS ->
			Xml.Element ("h4", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)
		|DOC_BLKS ->
			Xml.Element ("h5", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)
	)
	|Xml.Element ("abstract", _, xml_list) ->
		Xml.Element ("div", [("class", "abstract");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("refs_hdr", attr_list,xml_list) -> (
		match doc_class with
		|DOC_CHS ->
			Xml.Element ("h2", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)
		|DOC_SECS ->
			Xml.Element ("h3", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)
		|DOC_PARS ->
			Xml.Element ("h4", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)
		|DOC_BLKS ->
			Xml.Element ("h5", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)
	)
	|Xml.Element ("refs", _ , xml_list) -> 
		Xml.Element ("div", [("class","refs");("style","display:block")], List.map (html_of_exml doc_class) xml_list)


	|Xml.Element ("doc_main", _, xml_list) ->
		Xml.Element ("div", [("class", "doc_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)


	|Xml.Element ("ch", attr_list, xml_list) -> 
		Xml.Element ("div", ("style","display:block")::attr_list, List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("ch_lbl", _ , xml_list) -> 
		Xml.Element ("div", [("class","ch_lbl");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("ch_hdr", _, xml_list) ->
		Xml.Element ("h2", [("class", "ch_hdr")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("ch_lbl_hdr", _, xml_list) ->
		Xml.Element ("h2", [("class", "ch_lbl_hdr")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("ch_main", _ , xml_list) -> 
		Xml.Element ("div", [("class","ch_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)


	|Xml.Element ("sec", attr_list, xml_list) ->
		Xml.Element ("div", ("class", "sec")::(("style","display:block")::attr_list), List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("sec_lbl", _, xml_list) ->
		Xml.Element ("div", [("class", "sec_lbl");("style","display:block;float:left")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("sec_hdr", _, xml_list) ->
		Xml.Element ("h3", [("class", "sec_hdr");("style","margin-top:0")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("sec_lbl_hdr", _, xml_list) ->
		Xml.Element ("h3", [("class", "sec_lbl_hdr");("style","display:block;visibility:hidden")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("sec_main", _ , xml_list) -> 
		Xml.Element ("div", [("class","sec_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)


	|Xml.Element ("par", attr_list, xml_list) ->
		Xml.Element ("div", ("class", "par")::(("style","display:block")::attr_list), List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("par_hdr", attr_list, xml_list) ->
		Xml.Element ("h4", [("style","visibility:hidden;height:0;width:0;float:left")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("par_lbl", _, xml_list) ->
		Xml.Element ("div",[("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("par_main", _ , xml_list) -> 
		Xml.Element ("div", [("class","par_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)


	|Xml.Element ("blk_txt", _, xml_list) ->
		Xml.Element ("p", [("class", "blk_txt");("style","margin-top:0")], List.map (html_of_exml doc_class) xml_list)
	

	|Xml.Element ("blk_itm", attr_list, xml_list) ->
		Xml.Element ("div", ("class", "blk_itm")::(("style","display:block")::attr_list), List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("blk_itm_lbl", _, xml_list) ->
		Xml.Element ("div",[("class","blk_itm_lbl");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("blk_itm_main", _, xml_list) ->
		Xml.Element ("div", [("class", "blk_itm_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)


	|Xml.Element ("blk_blt", _, xml_list) ->
		Xml.Element ("div", [("class", "blk_blt");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("blk_blt_lbl", _, xml_list) ->
		Xml.Element ("div",[("class","blk_blt_lbl");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("blk_blt_main", _, xml_list) ->
		Xml.Element ("div", [("class", "blk_blt_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)


	|Xml.Element ("blk_dsp", _, xml_list) ->
		Xml.Element ("div", [("class", "blk_dsp");("style","display:block;white-space:nowrap")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("dsp_line", attr_list, xml_list) ->
		Xml.Element ("div", ("class", "dsp_line")::(("style","display:block")::attr_list), List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("dsp_line_lbl", _, xml_list) ->
		Xml.Element ("div",[("class","dsp_line_lbl");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("dsp_line_main", _, xml_list) ->
		Xml.Element ("div", [("class", "dsp_line_main");("style","display:block;white-space:pre")], List.map (html_of_exml doc_class) xml_list)
		

	|Xml.Element ("txt_unit_wysiwyg", _, [Xml.PCData s]) -> Xml.PCData s

	|Xml.Element ("txt_unit_emph", _, xml_list) ->
		Xml.Element ("em", [("class", "txt_unit_emph")], List.map (html_of_exml doc_class) xml_list)

	|Xml.Element ("txt_unit_c_ref", attr_list, xml_list) ->
		Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map (html_of_exml doc_class) xml_list)

	|Xml.PCData s -> Xml.PCData s

	|Xml.Element (tag, _, _) ->
		raise (Error ("unexpected element: " ^ tag))

let internal_css ( doc_settings : Common_utils.t_doc_settings) : string =
	let left_margin : string = (Float.to_string ((Float.of_int doc_settings.left_margin) /. 1.5)) ^ "0" ^ "rem" in
	let tab_length : string = (Int.to_string doc_settings.tab_length) ^ "ch" in
"html {
  --left_margin:" ^ left_margin ^ ";
  --tab_length:" ^ tab_length ^ ";
  font-family:monospace;
  font-size:medium;
  line-height:165%;
}


.title {
  font-weight:normal;
  font-size:large;
  margin-left:var(--left_margin);
}

.doc.chs .title {
  font-size:xx-large;
  margin-left:0;
}


.doc.secs .title {
  font-size:x-large;
}


.authors {
  margin-bottom:3em;
  margin-left:var(--left_margin);
}


.doc.chs .authors {
  font-size:large;
  margin-left:0;
}


.doc.secs .author {
  font-size:large;
}


.abstract {
  margin-bottom:2em;
}

.doc.chs .abstract {
  margin-bottom:3em;
  margin-left:0;
}


.abstract_hdr {
  font-weight:normal;
  font-size:large;
  margin-left:var(--left_margin);
}

.doc.chs .abstract_hdr {
  margin-left:0;
}


.refs {
  padding-top:2rem;
}

.doc.chs .refs {
  border-top:thin solid gray;
}


.refs_hdr {
  font-weight:normal;
  font-size:large;
  margin-bottom:3rem;
  margin-left:var(--left_margin);
}


.doc.chs .refs_hdr {
  font-size:x-large;
  margin-left:0;
}


.ch {
  padding-top:3rem;
  padding-bottom:3rem;
  border-top:thin solid gray;
}


.ch_lbl, .ch_lbl_hdr {
  font-weight:normal;
  font-size:x-large;
}


.ch_hdr {
  font-size:x-large;
}


.ch_hdr, .ch_lbl_hdr {
  margin-bottom:3rem;
}


.sec + .sec {
  margin-top:2em;
}


.sec_lbl {
  font-size:large;
}


.sec_hdr {
  margin-left:var(--left_margin);
  font-size:large;
}


.par + .par {
  margin-top:2em;
}


.blk_txt {
  hyphens:auto;
  white-space:pre-wrap;
}

.abstract > .blk_txt {
  margin-left:var(--left_margin);
}

.refs > .blk_txt {
  margin-left:var(--left_margin);
}

.sec_main > .blk_txt {
  margin-left:var(--left_margin);
}


.par_main > .blk_txt {
  margin-left:var(--left_margin);
}


.sec_main > .blk_blt {
  margin-left:var(--left_margin);
}


.abstract > .blk_blt {
  margin-left:var(--left_margin);
}


.refs > .blk_blt {
  margin-left:var(--left_margin);
}


.par_main > .blk_blt {
  margin-left:var(--left_margin);
}


.blk_blt_main {
  margin-left:var(--tab_length);
}


.abstract > .blk_itm {
  margin-left:var(--left_margin);
}

.refs > .blk_itm {
  margin-left:var(--left_margin);
}


.sec_main > .blk_itm {
  margin-left:var(--left_margin);
}


.par_main > .blk_itm {
  margin-left:var(--left_margin);
}


.blk_itm_main {
  margin-left:var(--tab_length);
}


.abstract > .blk_dsp {
  margin-left:var(--left_margin);
}


.refs > .blk_dsp {
  margin-left:var(--left_margin);
}


.sec_main > .blk_dsp {
  margin-left:var(--left_margin);
}


.par_main > .blk_dsp {
  margin-left:var(--left_margin);
}


.dsp_line_main {
  margin-left:var(--tab_length);
}


a {
  text-decoration:none;
}



@media print {

  html {
    font-size:12px;
  }

  .doc.chs .title {
    margin-left:0;
  }

  .doc.chs .authors {
    margin-left:0;
  }

  .doc.chs .abstract {
    margin-left:0;
  }

  .ch.blks {
    --left_margin:0;
  }

  .ch_hdr, .ch_lbl, .ch_lbl_hdr {
    margin-left:0;
  }

  .ch_hdr, .ch_lbl, .sec_hdr, .sec_lbl, .par_hdr, .par_lbl, .itm_lbl, .dsp_lbl, .blt_lbl, .abstract_hdr, .refs_hdr {
    break-after:avoid;
  }

  .ch_main, .sec_main, .par_main {
    break-before:avoid;
  }

  .blk_dsp {
    break-inside:avoid;
  }

  .ch {
    break-before:page;
    border:none;
}

  .doc.chs .refs {
    break-before:page;
    border:none;
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

