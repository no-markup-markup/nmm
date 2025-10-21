exception Error of string

let usage : string=
"Usage:

nmm-ocaml [

 | txt-of-xml { <path-to-xml-file> | - }
 | html-of-xml { <URI-of-css-file> | none } { <language-code> | none } { <path-to-xml-file> | - }

 | xml-of-nmm <path-to-nmm-file>

 | txt-of-nmm <path-to-nmm-file>
 | html-of-nmm { <URI-of-css-file> | none } { <language-code> | none } <path-to-nmm-file>

 | check-xml-schema <path-to-dtd-file>
 | validate-xml <path-to-dtd-file> <entry-point> { <path-to-xml-file> | - }

]

In cases where '-' can be supplied instead of a path, the program reads from stdin."

let doc_of_nmm (path : string) : Doc_types.tr_doc =
	let print_tokens = false in
	Doc_of_nmm.doc_of_nmm_file print_tokens path

let txt_of_doc (doc : Doc_types.tr_doc) : string =
	Compiler_of_doc.txt_of_tr_doc doc

let html_of_doc (uri_opt : string option) (lang_opt : string option)  (doc : Doc_types.tr_doc) : string =
	let doc_type : Common_utils.t_doc_type = Common_utils.doc_type_of_tr_doc doc in
	let exml:Xml.xml = Compiler_of_doc.exml_of_tr_doc doc in
	let html:Xml.xml = Html_utils.html_of_exml exml in
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
	match lang_opt with 
		| None -> "" 
		| Some lang -> (" lang=\"" ^ lang ^ "\"") 
	in
	let internal_css: string = ("<style>\n" ^ (Html_utils.internal_css doc_type Common_utils.doc_settings) ^ "\n</style>\n")
	in
	let external_css: string = 
		match uri_opt with
		|None -> ""
		|Some uri ->  ("<link rel=\"stylesheet\" href=\"" ^ uri ^ "\">\n")
	in
	let intro:string = (
		"<!DOCTYPE html>\n" ^
		"<html" ^ lang_attr ^ ">\n" ^
		"<head>\n" ^
		"<meta charset=\"UTF-8\">\n" ^
		"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ^
		title ^ author ^ internal_css ^ external_css ^
		"</head>\n" ^
		"<body>\n"
	) 
	in
	let outro:string = (
		"\n</body>\n" ^
		"</html>"
	)
	in 
	(intro ^ html_string ^ outro)

let doc_of_axml (path : string) : Doc_types.tr_doc = 
	let print_tokens = false in
	let axml:Xml.xml =
		match path with
		|"-" -> Xml_right.parse_stdin print_tokens
		|_ -> Xml_right.parse_file print_tokens path 
	in
	Doc_of_axml.f_tr_doc_of_axml axml

let axml_of_doc (doc : Doc_types.tr_doc) : string =
	"<?xml version=\"1.0\"?>\n" ^ 
	(Xml_right.to_string_fmt (Axml_of_doc.axml_of_tr_doc doc))

let html_of_nmm (uri_opt : string option) (lang_opt : string option) (path : string) : string =
	html_of_doc uri_opt lang_opt (doc_of_nmm path)

let txt_of_nmm (path:string):string =
	txt_of_doc (doc_of_nmm path)

let txt_of_axml (path : string) : string =
	txt_of_doc (doc_of_axml path) 

let html_of_axml (uri_opt : string option) (lang_opt : string option) (path : string) : string =
	html_of_doc uri_opt lang_opt (doc_of_axml path)

let axml_of_nmm (path : string) : string =
	axml_of_doc (doc_of_nmm path)

let check_xml_schema (path:string):string =
	try
		let dtd:Dtd.dtd=Dtd.parse_file path in
		let _:Dtd.checked=Dtd.check dtd in
		String.concat " " [path;"is a well-defined xml-schema"]
	with 
	|Xml_light_errors.Dtd_check_error e -> raise (Error (String.concat " " [path; "-> ERROR:";Dtd.check_error e]))

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
	|Xml_light_errors.Dtd_parse_error e -> raise (Error (String.concat " " [path_to_dtd;"-> ERROR:";Dtd.parse_error e]))
	|Xml_light_errors.Dtd_check_error e -> raise (Error (String.concat " " [path_to_dtd;"-> ERROR:";Dtd.check_error e]))
	|Xml_light_errors.Dtd_prove_error e -> raise (Error (String.concat " " [path_to_dtd;entry_point;path_to_xml;"-> ERROR:";Dtd.prove_error e]))
	|Xml_light_errors.Xml_error e -> raise (Error (String.concat " " [path_to_xml;"-> ERROR:";Xml.error e]))


let test_w_nmm (path_to_nmm_file : string) : unit =
	Test.test_w_nmm path_to_nmm_file

let test_w_xml (path_to_xml_file : string) : unit =
	Test.test_w_xml path_to_xml_file

let argv=Sys.argv

let _ : unit =
	match Array.length argv with
	|3 -> (
		match argv.(1),argv.(2) with
		|"txt-of-nmm", path -> print_endline (txt_of_nmm path)
		|"txt-of-xml", path -> print_endline (txt_of_axml path)
		|"xml-of-nmm", path -> print_endline (axml_of_nmm path)
		|"check-xml-schema", path -> print_endline (check_xml_schema path)
		|"test-with-nmm", path -> test_w_nmm path
		|"test-with-xml", path -> test_w_xml path
		|_-> print_endline usage
	)
	|5 -> (
		match argv.(1),argv.(2),argv.(3),argv.(4) with
		|"html-of-nmm", "none", "none", path -> print_endline (html_of_nmm None None path)
		|"html-of-nmm", "none", lang, path -> print_endline (html_of_nmm None (Some lang) path)
		|"html-of-nmm", uri, "none", path -> print_endline (html_of_nmm (Some uri) None path)
		|"html-of-nmm", uri, lang, path -> print_endline (html_of_nmm (Some uri) (Some lang) path)
		|"html-of-xml", "none", "none", path -> print_endline (html_of_axml None None path)
		|"html-of-xml", "none", lang, path -> print_endline (html_of_axml None (Some lang) path)
		|"html-of-xml", uri, "none", path -> print_endline (html_of_axml (Some uri) None path)
		|"html-of-xml", uri, lang, path -> print_endline (html_of_axml (Some uri) (Some lang) path)
		|"validate-xml", path_to_dtd, entry_point, path_to_xml -> print_endline (validate_xml path_to_dtd entry_point path_to_xml)
		|_-> print_endline usage
	)
	|_ -> print_endline usage


