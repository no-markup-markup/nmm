(** For translating a compiled nmm-document with resolved cross-references and labels (in the the XML-format specified by {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/dtd/exml.dtd}exml.dtd}) to HTML *)

exception Error of string


val html_of_exml : Common_utils.t_doc_class -> Xml.xml -> Xml.xml
(**
{[html_of_exml element]}

evaluates recursively to

{[
match element with
|Xml.Element ("doc", attr_list, xml_list) -> 
	Xml.Element ("div", ("style","display:block")::attr_list, List.map html_of_exml xml_list)

|Xml.Element ("title", _, xml_list) ->
	Xml.Element ("h1", [("class", "title")], List.map html_of_exml xml_list)

|Xml.Element ("authors", _, xml_list) ->
	Xml.Element ("div", [("class", "authors");("style","display:block")], List.map html_of_exml xml_list)

|Xml.Element ("author", _, xml_list) ->
	Xml.Element ("p", [("class", "author")], List.map html_of_exml xml_list)

|Xml.Element ("abstract_hdr", _,xml_list) ->
	Xml.Element ("h2", [("class", "abstract_hdr")], List.map html_of_exml xml_list)

|Xml.Element ("abstract", _, xml_list) ->
	Xml.Element ("div", [("class", "abstract");("style","display:block")], List.map html_of_exml xml_list)

|Xml.Element ("refs_hdr", attr_list,xml_list) ->
	Xml.Element ("h2", [("class", "refs_hdr")],List.map html_of_exml xml_list)

|Xml.Element ("refs", _ , xml_list) -> 
	Xml.Element ("div", [("class","refs");("style","display:block")], List.map html_of_exml xml_list)


|Xml.Element ("doc_main", _, xml_list) ->
	Xml.Element ("div", [("class", "doc_main");("style","display:block")], List.map html_of_exml xml_list)


|Xml.Element ("ch", attr_list, xml_list) -> 
	Xml.Element ("div", ("style","display:block")::attr_list, List.map html_of_exml xml_list)

|Xml.Element ("ch_lbl", _ , xml_list) -> 
	Xml.Element ("div", [("class","ch_lbl");("style","display:block")], List.map html_of_exml xml_list)

|Xml.Element ("ch_hdr", _, xml_list) ->
	Xml.Element ("h2", [("class", "ch_hdr")], List.map html_of_exml xml_list)

|Xml.Element ("ch_lbl_hdr", _, xml_list) ->
	Xml.Element ("h2", [("class", "ch_lbl_hdr")], List.map html_of_exml xml_list)

|Xml.Element ("ch_main", _ , xml_list) -> 
	Xml.Element ("div", [("class","ch_main");("style","display:block")], List.map html_of_exml xml_list)


|Xml.Element ("sec", attr_list, xml_list) ->
	Xml.Element ("div", ("class", "sec")::(("style","display:block")::attr_list), List.map html_of_exml xml_list)

|Xml.Element ("sec_lbl", _, xml_list) ->
	Xml.Element ("div", [("class", "sec_lbl");("style","display:block;float:left")], List.map html_of_exml xml_list)

|Xml.Element ("sec_hdr", _, xml_list) ->
	Xml.Element ("h3", [("class", "sec_hdr")], List.map html_of_exml xml_list)

|Xml.Element ("sec_lbl_hdr", _, xml_list) ->
	Xml.Element ("h3", [("class", "sec_lbl_hdr");("style","display:block;visibility:hidden")], List.map html_of_exml xml_list)

|Xml.Element ("sec_main", _ , xml_list) -> 
	Xml.Element ("div", [("class","sec_main");("style","display:block")], List.map html_of_exml xml_list)


|Xml.Element ("par", attr_list, xml_list) ->
	Xml.Element ("div", ("class", "par")::(("style","display:block")::attr_list), List.map html_of_exml xml_list)

|Xml.Element ("par_hdr", attr_list, xml_list) ->
	Xml.Element ("h4", [("style","visibility:hidden;height:0;width:0;float:left")], List.map html_of_exml xml_list)

|Xml.Element ("par_lbl", _, xml_list) ->
	Xml.Element ("div",[("style","display:block;float:left")],List.map html_of_exml xml_list)

|Xml.Element ("par_main", _ , xml_list) -> 
	Xml.Element ("div", [("class","par_main");("style","display:block")], List.map html_of_exml xml_list)


|Xml.Element ("blk_txt", _, xml_list) ->
	Xml.Element ("p", [("class", "blk_txt")], List.map html_of_exml xml_list)


|Xml.Element ("blk_itm", attr_list, xml_list) ->
	Xml.Element ("div", ("class", "blk_itm")::(("style","display:block")::attr_list), List.map html_of_exml xml_list)

|Xml.Element ("blk_itm_lbl", _, xml_list) ->
	Xml.Element ("div",[("class","blk_itm_lbl");("style","display:block;float:left")],List.map html_of_exml xml_list)

|Xml.Element ("blk_itm_main", _, xml_list) ->
	Xml.Element ("div", [("class", "blk_itm_main");("style","display:block")], List.map html_of_exml xml_list)


|Xml.Element ("blk_blt", _, xml_list) ->
	Xml.Element ("div", [("class", "blk_blt");("style","display:block")], List.map html_of_exml xml_list)

|Xml.Element ("blk_blt_lbl", _, xml_list) ->
	Xml.Element ("div",[("class","blk_blt_lbl");("style","display:block;float:left")],List.map html_of_exml xml_list)

|Xml.Element ("blk_blt_main", _, xml_list) ->
	Xml.Element ("div", [("class", "blk_blt_main");("style","display:block")], List.map html_of_exml xml_list)


|Xml.Element ("blk_dsp", _, xml_list) ->
	Xml.Element ("div", [("class", "blk_dsp");("style","display:block;white-space:nowrap")], List.map html_of_exml xml_list)

|Xml.Element ("dsp_line", attr_list, xml_list) ->
	Xml.Element ("div", ("class", "dsp_line")::(("style","display:block")::attr_list), List.map html_of_exml xml_list)

|Xml.Element ("dsp_line_lbl", _, xml_list) ->
	Xml.Element ("div",[("class","dsp_line_lbl");("style","display:block;float:left")],List.map html_of_exml xml_list)

|Xml.Element ("dsp_line_main", _, xml_list) ->
	Xml.Element ("div", [("class", "dsp_line_main");("style","display:block;white-space:pre")], List.map html_of_exml xml_list)


|Xml.Element ("txt_unit_wysiwyg", _, [Xml.PCData s]) ->
	Xml.PCData s

|Xml.Element ("txt_unit_emph", _, xml_list) ->
	Xml.Element ("em", [("class", "txt_unit_emph")], List.map html_of_exml xml_list)

|Xml.Element ("txt_unit_c_ref", attr_list, xml_list) ->
	Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map html_of_exml xml_list)

|Xml.PCData s ->
	Xml.PCData s

|Xml.Element (tag, _, _) ->
	raise (Error ("unexpected element: " ^ tag))
]}
*)

val internal_css : Common_utils.t_doc_settings -> string
(**
With the default [doc_settings], [internal_css doc_settings] evaluates to a string corresponding to {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/css/default.css}default.css}. 
*)
