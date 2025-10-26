(** For translating a compiled nmm-document with resolved cross-references and labels (in the the XML-format specified by {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/dtd/exml.dtd}exml.dtd}) to HTML *)

val html_of_exml : Xml.xml -> Xml.xml
(**
{[html_of_exml element]}

evaluates recursively to

{[
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
]}
*)

val internal_css : Common_utils.t_doc_settings -> string
(**
With the default [doc_settings], [internal_css doc_settings] evaluates to a string corresponding to {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/css/default.css}default.css}. 
*)
