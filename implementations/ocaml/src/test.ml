exception Error of string


let rec test_w_nmm_file (basename : string) : unit =
	let doc : Doc_types.tr_doc = Doc_of_nmm.doc_of_nmm_file false ("testing/input/" ^ basename) in
	let axml : Xml.xml = Axml_of_doc.axml_of_tr_doc doc in
	let txt : string = Main.txt_of_doc doc in
	let html : string = Main.html_of_doc None (Some "en") doc in
	let exml : Xml.xml = Compiler_of_doc.exml_of_tr_doc doc in
	let _ : unit = Debug_utils.print_to_file txt ("testing/output/" ^ basename ^ ".txt") in
	let _ : unit = Debug_utils.print_to_file html ("testing/output/" ^ basename ^ ".html") in
	let doc_of_axml : Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
	let _ : unit = identity_test_w_doc basename doc doc_of_axml in
	let _ : unit = xml_right_test basename "exml" doc exml in
	let _ : unit = xml_right_test basename "axml" doc axml in
	()

and test_w_axml_file (basename : string) : unit =
	let axml : Xml.xml = Xml_right.parse_file false ("testing/input/" ^ basename) in
	let doc : Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
	let txt : string = Main.txt_of_doc doc in
	let html : string = Main.html_of_doc None (Some "en") doc in
	let exml : Xml.xml = Compiler_of_doc.exml_of_tr_doc doc in
	let _ : unit = Debug_utils.print_to_file txt ("testing/output/" ^ basename ^ ".txt") in
	let _ : unit = Debug_utils.print_to_file html ("testing/output/" ^ basename ^ ".html") in
	let axml_of_doc : Xml.xml = Axml_of_doc.axml_of_tr_doc doc in
	let _ : unit = identity_test_w_axml basename axml axml_of_doc in
	let _ : unit = xml_right_test basename "exml" doc exml in
	let _ : unit = xml_right_test basename "axml" doc axml in
	()


and identity_test_w_doc (basename : string) (doc : Doc_types.tr_doc) (doc_of_axml : Doc_types.tr_doc) : unit =
	match doc = doc_of_axml with
	|true -> ()
	|false -> raise (Error ("FAIL: " ^ basename ^ " -> doc_of_axml (axml_of_doc doc) NOT EQUAL TO doc"))

and identity_test_w_axml (basename : string) (axml : Xml.xml) (axml_of_doc : Xml.xml) : unit =
	match axml = axml_of_doc with
	|true -> ()
	|false -> raise (Error ("FAIL: " ^ basename ^ " -> axml_of_doc (doc_of_axml axml) NOT EQUAL TO axml"))


and xml_right_test (basename : string) (format : string) (doc : Doc_types.tr_doc) (xml : Xml.xml): unit =
	try
		let xml_string : string = Xml_right.to_string xml in
		let xml_of_string : Xml.xml = Xml_right.parse_string false xml_string in
		match xml = xml_of_string with
		|true -> ()
		|false -> raise (Error (String.concat " " ["basename";"->";format;"NOT EQUAL TO Xml_right.parse_string (Xml_right.to_string";format;")"]))
	with
	|Error s 
	|Xml_right.Error s -> raise (Error s)

and xml_right_test_fmt (basename : string) (format : string) (doc : Doc_types.tr_doc) (xml : Xml.xml): unit =
	try
		let xml_string : string = Xml_right.to_string_fmt xml in
		let xml_of_string : Xml.xml = Xml_right.parse_string false xml_string in
		match xml = xml_of_string with
		|true -> ()
		|false -> raise (Error (String.concat " " ["basename";"->";format;"NOT EQUAL TO Xml_right.parse_string (Xml_right.to_string_fmt";format;")"]))
	with
	|Error s 
	|Xml_right.Error s -> raise (Error s)


