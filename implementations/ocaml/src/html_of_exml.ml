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

