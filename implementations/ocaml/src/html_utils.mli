val html_of_exml : Xml.xml -> Xml.xml
(**
{[html_of_exml exml]}
evaluates recursively to
{[
match element with
| Xml.Element ("title", attr_list, xml_list) -> Xml.Element ("h1", ("class", "title")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("author", attr_list, xml_list) -> Xml.Element ("p", ("class", "author")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("abstract_hdr", attr_list,xml_list) -> Xml.Element ("h2", ("class", "abstract_hdr")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("refs_hdr", attr_list,xml_list) -> Xml.Element ("h2", ("class", "refs_hdr")::attr_list,List.map html_of_exml xml_list)
| Xml.Element ("ch_hdr", attr_list, xml_list) -> Xml.Element ("h2", ("class", "ch_hdr")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("ch_lbl_hdr", attr_list, xml_list) -> Xml.Element ("h2", ("class", "ch_lbl_hdr")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("sec_hdr", attr_list, xml_list) -> Xml.Element ("h3", ("class", "sec_hdr")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("sec_lbl_hdr", attr_list, xml_list) -> Xml.Element ("h3", ("class", "sec_lbl_hdr")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("par_hdr", attr_list, xml_list) -> Xml.Element ("h4", ("class", "par_hdr")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("blk_txt", attr_list, xml_list) -> Xml.Element ("p", ("class", "blk_txt")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("txt_unit_wysiwyg", attr_list, [Xml.PCData s]) -> Xml.PCData s
| Xml.Element ("txt_unit_emph", attr_list, xml_list) -> Xml.Element ("em", ("class", "txt_unit_emph")::attr_list, List.map html_of_exml xml_list)
| Xml.Element ("txt_unit_c_ref", attr_list, xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref")::attr_list, List.map html_of_exml xml_list)
| Xml.Element (tag, attr_list, xml_list) -> Xml.Element ("div", ("class", tag)::attr_list, List.map html_of_exml xml_list)
| Xml.PCData s -> Xml.PCData s
]}
*)

val internal_css : Common_utils.t_doc_type -> Common_utils.t_doc_settings -> string
(**
With the default [doc_settings], [internal_css doc_settings] evaluates to a string corresponding to {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/css/default.css}default.css}. 
*)
