open Common_utils

exception Error of string

let sec_hdr_of_doc_class (doc_class : Common_utils.t_doc_class) : string =
        match doc_class with
        |DOC_CHS -> "h3"
        |DOC_SECS -> "h2"
        |_ -> raise (Error "unexpected document class")

let par_hdr_of_doc_class (doc_class : Common_utils.t_doc_class) : string =
        match doc_class with
        |DOC_CHS -> "h4"
        |DOC_SECS -> "h3"
        |DOC_PARS -> "h2"
        |DOC_BLKS -> raise (Error "unexpected document class")


let rec html_of_exml (doc_class : Common_utils.t_doc_class) (element:Xml.xml):Xml.xml=
match element with
|Xml.Element ("doc", attr_list, xml_list) -> Xml.Element ("div", attr_list, List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("title", _, xml_list) -> Xml.Element ("h1", [("class", "title")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("authors", _, xml_list) -> Xml.Element ("div", [("class", "authors")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("author", _, xml_list) -> Xml.Element ("p", [("class", "author")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("date", attr_list, [Xml.PCData s]) -> Xml.Element ("time", ("class", "date")::attr_list, [Xml.PCData s])

|Xml.Element ("abstract", _, xml_list) -> Xml.Element ("div", [("class", "abstract")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("abstract_hdr", _, xml_list) -> Xml.Element ("h2", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("refs", _ , xml_list) -> Xml.Element ("div", [("class","refs")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("refs_hdr", _, xml_list) -> Xml.Element ("h2", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("doc_main", _, xml_list) -> Xml.Element ("div", [("class", "doc_main")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("ch", attr_list, xml_list) -> Xml.Element ("div", attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_lbl", _ , xml_list) -> Xml.Element ("div", [("class","ch_lbl")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_hdr", _, xml_list) -> Xml.Element ("h2", [("class", "ch_hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_lbl_hdr", _, xml_list) -> Xml.Element ("h2", [("class", "ch_lbl hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_main", _ , xml_list) -> Xml.Element ("div", [("class","ch_main")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("sec", attr_list, xml_list) -> Xml.Element ("div", attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("sec_lbl", _, xml_list) -> Xml.Element ("div", [("class", "sec_lbl")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("sec_hdr", _, xml_list) -> Xml.Element (sec_hdr_of_doc_class doc_class, [("class", "sec_hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("sec_lbl_hdr", _, xml_list) -> Xml.Element (sec_hdr_of_doc_class doc_class, [("class", "sec_lbl hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("sec_main", _ , xml_list) -> Xml.Element ("div", [("class","sec_main")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("par", attr_list, xml_list) -> Xml.Element ("div", attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_lbl", _, xml_list) -> Xml.Element ("div",[("class","par_lbl")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_lbl_hdr", _, xml_list) -> Xml.Element (par_hdr_of_doc_class doc_class,[("class","par_lbl hdr")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_tag",[],xml_list) -> Xml.Element ("div", [("class", "par_tag")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_hdr", _, xml_list) -> Xml.Element (par_hdr_of_doc_class doc_class, [("class","par_hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_tag_hdr", _, xml_list) -> Xml.Element (par_hdr_of_doc_class doc_class, [("class","par_tag hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_main", _ , xml_list) -> Xml.Element ("div", [("class","par_main")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_main_w_hdr", _ , xml_list) -> Xml.Element ("div", [("class","par_main")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_txt", _, xml_list) -> Xml.Element ("p", [("class", "blk txt")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_itm", attr_list, xml_list) -> Xml.Element ("div", attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_itm_lbl", _, xml_list) -> Xml.Element ("div",[("class","blk_itm_lbl")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_itm_main", _, xml_list) -> Xml.Element ("div", [("class", "blk_itm_main")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_blt", _, xml_list) -> Xml.Element ("div", [("class", "blk blt")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_blt_lbl", _, xml_list) -> Xml.Element ("div",[("class","blk_blt_lbl")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_blt_main", _, xml_list) -> Xml.Element ("div", [("class", "blk_blt_main")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_dsp", _, xml_list) -> Xml.Element ("div", [("class", "blk dsp")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("dsp_line", attr_list, xml_list) -> Xml.Element ("div", attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("dsp_line_lbl", _, xml_list) -> Xml.Element ("div",[("class","dsp_line_lbl")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("dsp_line_main", _, xml_list) -> Xml.Element ("div", [("class", "dsp_line_main")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_vrb",_,xml_list) -> Xml.Element ("div",[("class","blk vrb")],List.map (html_of_exml doc_class) xml_list) 
|Xml.Element ("vrb_line",_,xml_list) -> Xml.Element ("pre",[("class","vrb_line")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("vrb_line_empty",_,_) -> Xml.Element ("br",[("class","vrb_line_empty")],[])

|Xml.Element ("txt_unit_wysiwyg", _, [Xml.PCData s]) -> Xml.PCData s
|Xml.Element ("txt_unit_emph", _, xml_list) -> Xml.Element ("em", [("class", "txt_unit_emph")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("txt_unit_c_ref", attr_list, xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("txt_unit_nte",attr_list,xml_list) -> Xml.Element ("a", ("class","txt_unit_nte")::attr_list,List.map (html_of_exml doc_class) xml_list)


|Xml.Element ("doc_endnotes",_,xml_list) -> Xml.Element ("div",[("class","doc_endnotes")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_endnotes",_,xml_list) -> Xml.Element ("div",[("class","ch_endnotes")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("doc_endnotes_hdr",_,xml_list) -> Xml.Element ("h2",[("class","doc_endnotes_hdr")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_endnotes_hdr",_,xml_list) -> Xml.Element ("h3",[("class","ch_endnotes_hdr")],List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_nte",attr_list,xml_list) -> Xml.Element ("div",("class","blk nte")::attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_nte_lbl",attr_list,xml_list) -> Xml.Element ("a",("class","blk_nte_lbl")::attr_list,List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_nte_main",_,xml_list) -> Xml.Element ("div", [("class", "blk_nte_main")],List.map (html_of_exml doc_class) xml_list)

|Xml.PCData s -> Xml.PCData s

|Xml.Element ("clear",[],[]) -> Xml.Element ("div",[("class","clear")],[Xml.PCData ""])

|Xml.Element (tag, _, _) -> raise (Error ("unexpected element: " ^ tag))


let margin_left_of_tr_doc (doc : Doc_types.tr_doc) : string =
        let doc_settings : t_doc_settings = doc_settings_of_tr_doc doc in
        let margin_labels = Compiler_of_doc.margin_labels_of_tr_doc doc_settings doc in
        let max_length : int = Txt_utils.max_length_of_margin_labels margin_labels in
        let margin : float = (Float.of_int (max_length + 2)) *. 0.6 in
        String.concat "" [Printf.sprintf "%.2f" margin; "rem"]

let internal_css (tab_length : string) (margin_left : string) : string =
"
html {
    font-family   : monospace;
    font-size     : medium;
    line-height   : 150%;
}

em {
    font-style      : normal;
    text-decoration : underline;
}

a {
    text-decoration : none;
}

p, pre {
    margin-top    : 0;
    margin-bottom : 0;
}


h2, h3, h4, h5 {
    margin-top : 0;
}


/************* TITLE ********************/

.title {
    font-weight   : normal;
    font-size     : x-large;
    margin-bottom : 1rem;
    line-height   : 130%;
}

.doc.pars .title {
    margin-left : "^ margin_left ^";
}

.doc.secs .title {
    margin-left : "^ margin_left ^";
}

.doc.chs .title {
    font-size : xx-large;
}


/************ AUTHORS *******************/


.authors {
    font-size     : medium;
    margin-top    : 2rem;
    margin-bottom : 1rem;
}

.author + .author {
    margin-top : 1rem;
}

.doc.pars .authors {
    margin-left : "^ margin_left ^";
}

.doc.secs .authors {
    margin-left : "^ margin_left ^";
}

/************ DATE ******************/

.date {
    font-size : small;
}

.doc.pars .date {
    margin-left : "^ margin_left ^";
}

.doc.secs .date {
    margin-left : "^ margin_left ^";
}

/************ ABSTRACT ******************/

.abstract {
    margin-bottom : 3rem;
}

* + .abstract {
    margin-top : 2rem;
}

.doc.pars .abstract {
    margin-left : "^ margin_left ^";
}

.doc.secs .abstract {
    margin-left : "^ margin_left ^";
}

.abstract_hdr {
    font-weight   : normal;
    font-size     : large;
    margin-bottom : 0.5rem;
}


/************* REFS *********************/

.refs {
    margin-top : 3rem;
}

.doc.pars .refs {
    margin-left : "^ margin_left ^";
}

.doc.secs .refs {
    margin-left : "^ margin_left ^";
}

.doc.chs .refs {
    margin-top  : 0;
    padding-top : 3rem;
    border-top  : thin solid gray;
}

.refs_hdr {
    font-weight : normal;
    font-size   : large;
}

.doc.chs .refs_hdr {
    font-size : x-large;
    margin-bottom : 3rem;
}


/************* DOC_MAIN *****************/

* + .doc_main {
    margin-top : 2rem;
}

/************** CH **********************/

.ch {
    padding-top    : 3rem;
    padding-bottom : 3rem;
    border-top     : thin solid gray;
}

.ch_lbl {
    font-weight : normal;
    font-size   : x-large;
}

.ch_hdr {
    font-size   : x-large;
    line-height : 130%;
}

.ch_hdr, .ch_lbl.hdr {
    margin-bottom : 3rem;
}

.ch_lbl + .ch_hdr {
    margin-top : 1rem;
}


/************** SEC *********************/

.sec + .sec {
    margin-top : 3rem;
}

.sec_lbl {
    float       : left;
    font-size   : large;
    font-weight : normal;
    line-height : 130%;
}

.sec_hdr {
    margin-left : "^ margin_left ^";
    font-size   : large;
    line-height : 130%;
}

.sec_lbl.hdr {
    float : none;
}

/************** PAR *********************/

.par + .par {
    margin-top : 2rem;
}

.par_lbl {
    float       : left;
    font-weight : normal;
    font-size   : inherit;
}

.par_tag, .par_hdr {
    font-weight  : bold;
    display      : inline;
    font-size    : inherit;
}


.par_tag + .par_hdr::before {
    content : \" (\";
}

.par_tag + .par_hdr::after {
    content : \")\";
}

.par_main {
    margin-left : "^ margin_left ^";
}


/************** BLK *********************/

.par_hdr + p.blk.txt {
    display : inline;
}

.par_tag.hdr + p.blk.txt {
    display : inline;
}

.par_hdr + p.blk.txt::before {
    content : \"  \";
}

.par_tag.hdr + p.blk.txt::before {
    content : \"  \";
}

* + .blk {
    margin-top : 1rem;
}

.sec_main > .blk {
    margin-left : "^ margin_left ^";
}

.blk.txt {
    hyphens     : auto;
    white-space : pre-wrap;
}


.blk_blt_lbl {
    float : left;
}

.blk_blt_main {
    margin-left : "^ tab_length ^";
}


.blk_itm_lbl {
    float : left;
}

.blk_itm_main {
    margin-left : "^ tab_length ^";
}


.dsp_line_lbl {
    float : left;
}

.dsp_line_main {
    margin-left : "^ tab_length ^";
    white-space : pre;
}

/******** ENDNOTES and FOOTNOTES **********/

.doc_endnotes_hdr, .ch_endnotes_hdr {
    font-weight : normal;
}

.doc_endnotes, .ch_endnotes {
    margin-top  : 2rem;
    border-top  : thin grey solid;
    padding-top : 0.5rem;
}

.blk_nte_lbl {
    float : left;
}

.blk_nte_main {
    margin-left : 3ch;
}

/*************** BIB ********************/


.bib_custom .blk_itm_lbl {
	float : none;
}



/*************** PRINTING ***************/

@media print {

  html {
    font-size : 13px;
  }

  h1, h2, h3, h4, h5, .ch_lbl, .sec_lbl, .par_lbl, .par_tag, .blk_itm_lbl, .blk_blt_lbl, .clear {
    break-after  : avoid-page;
    break-inside : avoid-page;
  }


  .ch_main, .sec_main, .par_main, .blk_itm_main, .blk_blt_main {
    break-before : avoid-page;
  }


  .blk.dsp {
    break-inside : avoid-page;
  }


  .ch {
    break-before : page;
    border       : none;
  }


  .doc.chs .refs {
    break-before : page;
    border       : none;
  }


  @page {
    size          : a4;
    margin-top    : 20mm;
    margin-left   : 20mm;
    margin-right  : 20mm;
    margin-bottom : 30mm;

    @top-center {
       content : \" \";
    }

    @bottom-center {
      padding : 10mm;
      content : counter(page) \" of \" counter(pages);
    }
  }
}"

