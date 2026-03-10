(** For translating a compiled nmm-document with resolved cross-references and labels (in the the XML-format specified by {{:specs/exml.dtd.txt}exml.dtd}) to HTML *)

exception Error of string


val html_of_exml : Common_utils.t_doc_class -> Xml.xml -> Xml.xml
(**
{[html_of_exml doc_class element]}

evaluates recursively to

{[
match element with
|Xml.Element ("doc", attr_list, xml_list) -> Xml.Element ("div", ("style","display:block")::attr_list, List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("title", _, xml_list) -> Xml.Element ("h1", [("class", "title")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("authors", _, xml_list) -> Xml.Element ("div", [("class", "authors");("style","display:block")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("author", _, xml_list) -> Xml.Element ("p", [("class", "author")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("abstract", _, xml_list) -> Xml.Element ("div", [("class", "abstract");("style","display:block")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("abstract_hdr", _, xml_list) -> (
	match doc_class with
	|DOC_CHS -> Xml.Element ("h2", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)
	|DOC_SECS -> Xml.Element ("h3", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)
	|DOC_PARS -> Xml.Element ("h4", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)
	|DOC_BLKS -> Xml.Element ("h5", [("class", "abstract_hdr")], List.map (html_of_exml doc_class) xml_list)
)

|Xml.Element ("refs", _ , xml_list) -> Xml.Element ("div", [("class","refs");("style","display:block")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("refs_hdr", _, xml_list) -> (
	match doc_class with
	|DOC_CHS -> Xml.Element ("h2", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)
	|DOC_SECS -> Xml.Element ("h3", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)
	|DOC_PARS -> Xml.Element ("h4", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)
	|DOC_BLKS -> Xml.Element ("h5", [("class", "refs_hdr")],List.map (html_of_exml doc_class) xml_list)
)

|Xml.Element ("doc_main", _, xml_list) -> Xml.Element ("div", [("class", "doc_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("ch", attr_list, xml_list) -> Xml.Element ("div", ("style","display:block")::attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_lbl", _ , xml_list) -> Xml.Element ("div", [("class","ch_lbl");("style","display:block")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_hdr", _, xml_list) -> Xml.Element ("h2", [("class", "ch_hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_lbl_hdr", _, xml_list) -> Xml.Element ("h2", [("class", "ch_lbl hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("ch_main", _ , xml_list) -> Xml.Element ("div", [("class","ch_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("sec", attr_list, xml_list) -> Xml.Element ("div", ("style","display:block")::attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("sec_lbl", _, xml_list) -> Xml.Element ("div", [("class", "sec_lbl");("style","display:block;float:left")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("sec_hdr", _, xml_list) -> Xml.Element ("h3", [("class", "sec_hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("sec_lbl_hdr", _, xml_list) -> Xml.Element ("h3", [("class", "sec_lbl hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("sec_main", _ , xml_list) -> Xml.Element ("div", [("class","sec_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("par", attr_list, xml_list) -> Xml.Element ("div", ("style","display:block")::attr_list, List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_lbl", _, xml_list) -> Xml.Element ("div",[("class","par_lbl");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_lbl_hdr", _, xml_list) -> Xml.Element ("h4",[("class","par_lbl hdr");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_tag",[],xml_list) -> Xml.Element ("div", [("class", "par_tag");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_hdr", _, xml_list) -> Xml.Element ("h4", [("class","par_hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_hdr_inline", _, xml_list) -> Xml.Element ("h4", [("class","par_hdr inline");("style","float:left;margin-bottom:0")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_tag_hdr", _, xml_list) -> Xml.Element ("h4", [("class","par_tag hdr")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_tag_hdr_inline", _, xml_list) -> Xml.Element ("h4", [("class","par_tag hdr inline");("style","float:left;margin-bottom:0")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_main", _ , xml_list) -> Xml.Element ("div", [("class","par_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_main_w_hdr", _ , xml_list) -> Xml.Element ("div", [("class","par_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("par_main_w_hdr_inline", _ , xml_list) -> Xml.Element ("div", [("class","par_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_txt", _, xml_list) -> Xml.Element ("p", [("class", "blk txt")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_itm", attr_list, xml_list) -> Xml.Element ("div", ("class", "blk itm")::(("style","display:block")::attr_list), List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_itm_lbl", _, xml_list) -> Xml.Element ("div",[("class","blk_itm_lbl");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_itm_main", _, xml_list) -> Xml.Element ("div", [("class", "blk_itm_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_blt", _, xml_list) -> Xml.Element ("div", [("class", "blk blt");("style","display:block")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_blt_lbl", _, xml_list) -> Xml.Element ("div",[("class","blk_blt_lbl");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("blk_blt_main", _, xml_list) -> Xml.Element ("div", [("class", "blk_blt_main");("style","display:block")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_dsp", _, xml_list) -> Xml.Element ("div", [("class", "blk dsp");("style","display:block;white-space:nowrap")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("dsp_line", attr_list, xml_list) -> Xml.Element ("div", ("class", "dsp_line")::(("style","display:block")::attr_list), List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("dsp_line_lbl", _, xml_list) -> Xml.Element ("div",[("class","dsp_line_lbl");("style","display:block;float:left")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("dsp_line_main", _, xml_list) -> Xml.Element ("div", [("class", "dsp_line_main");("style","display:block;white-space:pre")], List.map (html_of_exml doc_class) xml_list)

|Xml.Element ("blk_vrb",_,xml_list) -> Xml.Element ("div",[("class","blk vrb");("style","display:block")],List.map (html_of_exml doc_class) xml_list) 
|Xml.Element ("vrb_line",_,xml_list) -> Xml.Element ("pre",[("class","vrb_line")],List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("vrb_line_empty",_,_) -> Xml.Element ("br",[("class","vrb_line_empty")],[])

|Xml.Element ("txt_unit_wysiwyg", _, [Xml.PCData s]) -> Xml.PCData s
|Xml.Element ("txt_unit_emph", _, xml_list) -> Xml.Element ("em", [("class", "txt_unit_emph")], List.map (html_of_exml doc_class) xml_list)
|Xml.Element ("txt_unit_c_ref", attr_list, xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map (html_of_exml doc_class) xml_list)

|Xml.PCData s -> Xml.PCData s

|Xml.Element ("clear",[],[]) -> Xml.Element ("div",[("class","clear")],[Xml.PCData ""])

|Xml.Element (tag, _, _) -> raise (Error ("unexpected element: " ^ tag))

]}
*)

val default_tab_length : unit -> string

val default_lang_code : unit -> string

val default_margin : unit -> string

val margin_left_of_tr_doc : Doc_types.tr_doc -> string

val lang_code_of_options : string list -> string option

val margin_left_of_options : string list -> string option

val external_css_of_options : string list -> string option

val internal_css : string -> string -> string
(**
[internal_css tab_length left_margin] evaluates to a string representing an internal css style-sheet.
*)
