exception Error of string

let usage:string=
"usage:\n
  nmm-ocaml [\n
\ttxt-of-xml { <path-to-xml-file> | - } |\n
\thtml-of-xml <URI-of-css-file> [<language-code>] { <path-to-xml-file> | - } |\n
\tvalidate-xml <path-to-dtd-file> <entry-point> { <path-to-xml-file> | - } |\n
\tcheck-xml-schema <path-to-dtd-file> |\n
    ]"

let print_usage ():unit =
	print_endline usage

let txt_of_axml (path:string):string =
	let print_tokens = false in
	let axml:Xml.xml=
		match path with
		|"-" -> Xml_right.parse_stdin print_tokens 
		|_ -> Xml_right.parse_file print_tokens path
	in
	let doc:Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
	Compiler_of_doc.txt_of_tr_doc doc

let html_of_axml (path:string) (uri:string) (lang:string option):string =
	let print_tokens = false in
	let axml:Xml.xml=
		match path with
		|"-" -> Xml_right.parse_stdin print_tokens 
		|_ -> Xml_right.parse_file print_tokens path
	in
	let doc:Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
	let exml:Xml.xml = Compiler_of_doc.exml_of_tr_doc doc in
	let html:Xml.xml = Html_of_exml.html_of_exml exml in
	let html_string:string = Xml_right.to_string_fmt html in
	let title:string = 
		match doc.fld_doc_title with
		|None -> ""
		|Some (Cs_title s) -> String.concat "" ["<title>";s;"</title>\n"]
	in
	let author:string = 
		match doc.fld_doc_author with
		|None -> ""
		|Some (Cs_author s) -> String.concat "" ["<meta name=\"author\" content=\"";s;"\">\n"]
	in

	let lang_attr=
	match lang with 
		| None -> "" 
		| Some lang -> (" lang=\"" ^ lang ^ "\"") 
	in
	let intro:string = (
		"<html" ^ lang_attr ^ ">\n" ^
		"<head>\n" ^ title ^ author ^
		"<meta charset=\"utf-8\"/>\n" ^
		"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>\n" ^
		"<link rel=\"stylesheet\" href=\"" ^ uri ^ "\"/>\n" ^
		"</head>\n" ^
		"<body>\n"
	) in
	let outro:string = (
		"\n</body>\n" ^
		"</html>\n"
	) in (intro ^ html_string ^ outro)
	

let check_xml_schema (path:string):string =
	try
		let dtd:Dtd.dtd=Dtd.parse_file path in
		let _:Dtd.checked=Dtd.check dtd in
		String.concat " " [path;"is a well-defined xml-schema"]
	with 
	|Xml_light_errors.Dtd_check_error e -> String.concat " " [path; "-> ERROR:";Dtd.check_error e]

let validate_xml (path_to_dtd:string) (entry_point:string) (path_to_xml:string):string =
	let print_tokens = false in 
	try 
		let dtd:Dtd.dtd=Dtd.parse_file path_to_dtd in
		let checked_dtd:Dtd.checked=Dtd.check dtd in
		let xml:Xml.xml=
			match path_to_xml with
			|"-" -> Xml_right.parse_stdin print_tokens 
			|path -> Xml_right.parse_file print_tokens path
		in
		let _=Dtd.prove checked_dtd entry_point xml in 
		String.concat " " [path_to_xml;"is an instance of";path_to_dtd;"with entry-point";entry_point]
	with 
	|Xml_light_errors.Dtd_parse_error e -> String.concat " " [path_to_dtd;"-> ERROR:";Dtd.parse_error e]
	|Xml_light_errors.Dtd_check_error e -> String.concat " " [path_to_dtd;"-> ERROR:";Dtd.check_error e]
	|Xml_light_errors.Dtd_prove_error e -> String.concat " " [path_to_dtd;entry_point;path_to_xml;"-> ERROR:";Dtd.prove_error e]
	|Xml_light_errors.Xml_error e -> String.concat " " [path_to_xml;"-> ERROR:";Xml.error e]

let argv=Sys.argv

let _:unit=
	match Array.length argv with
	|3 -> (
		match argv.(1),argv.(2) with
		|"check-xml-schema", path -> print_endline (check_xml_schema path)
		|"txt-of-xml", path -> print_endline (txt_of_axml path)
		|_-> print_usage ()
	)
	|4 -> (
		match argv.(1),argv.(2),argv.(3) with
		|"html-of-xml", uri, path -> print_endline (html_of_axml path uri None)
		|_-> print_usage ()
	)
	|5 -> (
		match argv.(1),argv.(2),argv.(3),argv.(4) with
		|"html-of-xml", uri, lang, path -> print_endline (html_of_axml path uri (Some lang))
		|"validate-xml", path_to_dtd, entry_point, path_to_xml -> print_endline (validate_xml path_to_dtd entry_point path_to_xml)
		|_-> print_usage ()
	)
	|_ -> print_usage ()


