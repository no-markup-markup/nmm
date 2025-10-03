let rec html_of_exml (element:Xml.xml):Xml.xml=
		match element with
		|Xml.Element ("title", attr, xml_list) -> Xml.Element ("h1", ("class", "title")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("ch_hdr", attr, xml_list) -> Xml.Element ("h2", ("class", "ch_hdr")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("sec_hdr", attr, xml_list) -> Xml.Element ("h3", ("class", "sec_hdr")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("par_hdr", attr, xml_list) -> Xml.Element ("h4", ("class", "par_hdr")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("blk_txt", attr, xml_list) -> Xml.Element ("p", ("class", "blk_txt")::attr, List.map html_of_exml xml_list)
(*		|Xml.Element ("blk_blt", attr, xml_list) -> Xml.Element ("p", ("class", "blk_blt")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("blk_itm", attr, xml_list) -> Xml.Element ("p", ("class", "blk_itm")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("blk_dsp", attr, xml_list) -> Xml.Element ("p", ("class", "blk_dsp")::attr, List.map html_of_exml xml_list)
*)
		|Xml.Element ("txt_unit_norm", attr, [Xml.PCData s]) -> Xml.PCData s
		|Xml.Element ("txt_unit_norm_dsp", attr, [Xml.PCData s]) -> Xml.PCData s
		|Xml.Element ("txt_unit_emph", attr, xml_list) -> Xml.Element ("em", ("class", "txt_unit_emph")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("txt_unit_emph_dsp", attr, xml_list) -> Xml.Element ("em", ("class", "txt_unit_emph_dsp")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("txt_unit_c_ref", attr, xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref")::attr, List.map html_of_exml xml_list)
		|Xml.Element ("txt_unit_c_ref_dsp", attr,xml_list) -> Xml.Element ("a", ("class", "txt_unit_c_ref_dsp")::attr, List.map html_of_exml xml_list)
		|Xml.Element (tag,attr, xml_list) -> Xml.Element ("div", ("class", tag)::attr, List.map html_of_exml xml_list)
		|Xml.PCData s -> Xml.PCData s

