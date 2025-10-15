exception Error of string

let rec test_w_nmm (path_to_nmm_file : string) : unit =
	let _ = print_endline (bijectivity_test_w_nmm path_to_nmm_file) in
	let _ = print_endline (xml_right_test path_to_nmm_file "axml") in
	let _ = print_endline (xml_right_test path_to_nmm_file "exml") in
	let _ = print_endline (xml_right_test_fmt path_to_nmm_file "axml") in
	let _ = print_endline (xml_right_test_fmt path_to_nmm_file "exml") in ()

and test_w_xml (path_to_xml_file : string) : unit =
	let _ = print_endline (bijectivity_test_w_xml path_to_xml_file) in ()


and bijectivity_test_w_nmm (path_to_nmm_file:string):string =
	let doc:Doc_types.tr_doc = Doc_of_nmm.doc_of_nmm_file false path_to_nmm_file in
	let axml_of_doc:Xml.xml = Axml_of_doc.axml_of_tr_doc doc in
	let doc_of_axml_of_doc:Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml_of_doc in
	match doc_of_axml_of_doc = doc with
	|true -> "PASS: " ^ path_to_nmm_file ^ " -> doc_of_axml (axml_of_doc doc) = doc"
	|false -> "FAIL: " ^ path_to_nmm_file ^ " -> doc_of_axml (axml_of_doc doc) ≠ doc"

and bijectivity_test_w_xml (path_to_xml_file:string):string =
	let axml:Xml.xml = Xml_right.parse_file false path_to_xml_file in
	let doc_of_axml:Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
	let axml_of_doc:Xml.xml = Axml_of_doc.axml_of_tr_doc doc_of_axml in
	match axml_of_doc = axml with
	|true -> "PASS: " ^ path_to_xml_file ^ " -> axml_of_doc (doc_of_axml axml) = axml"
	|false -> "FAIL: " ^ path_to_xml_file ^ " -> axml_of_doc (doc_of_axml axml) ≠ axml"

and xml_right_test (path_to_nmm_file:string) (format:string)=
	try
		let doc:Doc_types.tr_doc = Doc_of_nmm.doc_of_nmm_file false path_to_nmm_file in
		let xml_of_doc:Xml.xml = 
			match format with
			|"axml" -> Axml_of_doc.axml_of_tr_doc doc
			|"exml" -> Compiler_of_doc.exml_of_tr_doc doc
			| _ -> raise (Error (format ^ " is not a valid format"))
		in
		let xml_string:string = Xml_right.to_string xml_of_doc in
		let xml_of_string:Xml.xml = Xml_right.parse_string false xml_string in
		match xml_of_doc = xml_of_string with
		|true -> "PASS: " ^ path_to_nmm_file ^ " -> " ^ format ^ "_of_doc (doc) = Xml_right.parse_string (Xml_right.to_string (" ^ format ^ "_of_doc (doc))"
		|false -> "FAIL: " ^ path_to_nmm_file ^ " -> " ^ format ^ "_of_doc (doc) ≠ Xml_right.parse_string (Xml_right.to_string (" ^ format ^ "_of_doc (doc))"
	with
	|Error s -> s

and xml_right_test_fmt (path_to_nmm_file:string) (format:string)=
	try
		let doc:Doc_types.tr_doc = Doc_of_nmm.doc_of_nmm_file false path_to_nmm_file in
		let xml_of_doc:Xml.xml = 
			match format with
			|"axml" -> Axml_of_doc.axml_of_tr_doc doc
			|"exml" -> Compiler_of_doc.exml_of_tr_doc doc
			| _ -> raise (Error (format ^ " is not a valid format"))
		in
		let xml_string:string = Xml_right.to_string_fmt xml_of_doc in
		let xml_of_string:Xml.xml = Xml_right.parse_string false xml_string in
		match xml_of_doc = xml_of_string with
		|true -> "PASS: " ^ path_to_nmm_file ^ " -> " ^ format ^ "_of_doc (doc) = Xml_right.parse_string (Xml_right.to_string_fmt (" ^ format ^ "_of_doc (doc))"
		|false -> "FAIL: " ^ path_to_nmm_file ^ " -> " ^ format ^ "_of_doc (doc) ≠ Xml_right.parse_string (Xml_right.to_string_fmt (" ^ format ^ "_of_doc (doc))"
	with
	|Error s -> s


and xml_light_test (path_to_nmm_file:string) (format:string)=
	try
		let doc:Doc_types.tr_doc = Doc_of_nmm.doc_of_nmm_file false path_to_nmm_file in
		let xml_of_doc:Xml.xml = match format with
			|"axml" -> Axml_of_doc.axml_of_tr_doc doc
			|"exml" -> Compiler_of_doc.exml_of_tr_doc doc
			| _ -> raise (Error (format ^ " is not a valid format"))
		in
		let xml_string:string = Xml.to_string xml_of_doc in
		let xml_of_string:Xml.xml = Xml.parse_string xml_string in
		match xml_of_doc = xml_of_string with
		|true -> "PASS: " ^ path_to_nmm_file ^ " -> " ^ format ^ "_of_doc (doc) = Xml.parse_string (Xml.to_string (" ^ format ^ "_of_doc (doc))"
		|false -> "FAIL: " ^ path_to_nmm_file ^ " -> " ^ format ^ "_of_doc (doc) ≠ Xml.parse_string (Xml.to_string (" ^ format ^ "_of_doc (doc))"
	with
	|Error s -> s

and xml_light_test_fmt (path_to_nmm_file:string) (format:string)=
	try
		let doc:Doc_types.tr_doc = Doc_of_nmm.doc_of_nmm_file false path_to_nmm_file in
		let xml_of_doc:Xml.xml = match format with
			|"axml" -> Axml_of_doc.axml_of_tr_doc doc
			|"exml" -> Compiler_of_doc.exml_of_tr_doc doc
			| _ -> raise (Error (format ^ " is not a valid format"))
		in
		let xml_string:string = Xml.to_string_fmt xml_of_doc in
		let xml_of_string:Xml.xml = Xml.parse_string xml_string in
		match xml_of_doc = xml_of_string with
		|true -> "PASS: " ^ path_to_nmm_file ^ " -> " ^ format ^ "_of_doc (doc) = Xml.parse_string (Xml.to_string_fmt (" ^ format ^ "_of_doc (doc))"
		|false -> "FAIL: " ^ path_to_nmm_file ^ " -> " ^ format ^ "_of_doc (doc) ≠ Xml.parse_string (Xml.to_string_fmt (" ^ format ^ "_of_doc (doc))"
	with
	|Error s -> s

