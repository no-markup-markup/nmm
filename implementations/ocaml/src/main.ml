exception Error of string

let doc_of_nmm (path : string) : Doc_types.tr_doc =
	try
	let print_tokens = false in
	match path with
	|"-" -> Doc_of_nmm.doc_of_nmm_stdin print_tokens 
	|_ -> Doc_of_nmm.doc_of_nmm_file print_tokens path
	with 
	|Doc_of_nmm.Error e -> raise (Error (String.concat " " [path;"->";"Doc_of_nmm.Error:";e]))


let txt_of_doc (options : string list) (doc : Doc_types.tr_doc) : string =
	let _ : unit = Debug_utils.quiet.contents <- List.mem "--quiet" options in
	try
	Compiler_of_doc.txt_of_tr_doc options doc
	with
	|Compiler_of_doc.Error e -> raise (Error (String.concat " " ["Compiler_of_doc.Error:";e]))


let html_of_doc (options : string list) (doc : Doc_types.tr_doc) : string =
	try
	let _ : unit = Debug_utils.quiet.contents <- List.mem "--quiet" options in
	let exml:Xml.xml = Compiler_of_doc.exml_of_tr_doc options doc in
	let doc_class : Common_utils.t_doc_class = Common_utils.class_of_tr_doc doc in
	let html:Xml.xml = Html_utils.html_of_exml doc_class exml in
	let html_string:string = Xml_right.to_string_fmt html in
	let title:string = 
		match doc.fld_doc_title with
		|None -> String.concat "" ["<title>";"untitled";"</title>"]
		|Some (Cs_title s) -> String.concat "" ["<title>";s;"</title>"]
	in
	let authors:string = 
		match doc.fld_doc_authors with
		|None -> ""
		|Some (Cs_authors (author_list : Doc_types.ts_author list)) -> 
			let map (author : Doc_types.ts_author) : string = 
				match author with
				|Cs_author s -> String.concat "" ["<meta name=\"author\" content=\"";s;"\">"]
			in String.concat "\n" (List.map map author_list)
	in
	let lang_attr : string =
	match Html_utils.lang_code_of_options options with 
		| None -> (" lang=\"" ^ (Html_utils.default_lang_code ())^ "\"")
		| Some lang_code -> (" lang=\"" ^ lang_code ^ "\"") 
	in
	let margin_left : string = 
		match Html_utils.margin_left_of_options options with
		|Some margin -> margin
		|None -> Html_utils.margin_left_of_tr_doc doc
	in
	let internal_css: string = ("<style>\n" ^ (Html_utils.internal_css (Html_utils.default_tab_length ()) margin_left) ^ "\n</style>") in
	let external_css: string = 
		match Html_utils.external_css_of_options options with
		|None -> ""
		|Some uri ->  ("<link rel=\"stylesheet\" href=\"" ^ uri ^ "\">\n")
	in
	let intro : string = (
		"<!DOCTYPE html>\n" ^
		"<html" ^ lang_attr ^ ">\n" ^
		"<head>\n" ^
		"<meta charset=\"UTF-8\">\n" ^
		"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ^
		title ^ "\n" ^
		authors ^ "\n" ^
		internal_css ^ "\n" ^
		external_css ^
		"</head>\n" ^
		"<body>\n"
	) 
	in
	let outro : string = (
		"\n</body>\n" ^
		"</html>"
	)
	in 
	(intro ^ html_string ^ outro)
	with
	|Html_utils.Error e -> raise (Error (String.concat " " ["Html_utils.Error:"; e]))
	|Compiler_of_doc.Error e -> raise (Error (String.concat " " ["Compiler_of_doc.Error:"; e]))
	|Xml_right.Error e -> raise (Error (String.concat " " ["Xml_right.Error:"; e]))


let doc_of_axml (path : string) : Doc_types.tr_doc = 
	try
	let print_tokens = false in
	let axml:Xml.xml =
		match path with
		|"-" -> Xml_right.parse_stdin print_tokens
		|_ -> Xml_right.parse_file print_tokens path 
	in
	Doc_of_axml.f_tr_doc_of_axml axml
	with
	|Xml_right.Error e -> raise (Error (String.concat " " [path;"->";"Xml_right.Error:";e])) 
	|Doc_of_axml.Error e -> raise (Error (String.concat " " [path;"->";"Doc_of_axml.Error:";e])) 


let axml_of_doc (doc : Doc_types.tr_doc) : string =
	"<?xml version=\"1.0\"?>\n" ^ 
	(Xml_right.to_string_fmt (Axml_of_doc.axml_of_tr_doc doc))

let html_of_nmm (options : string list) (path : string) : string =
	html_of_doc options (doc_of_nmm path)

let txt_of_nmm (options : string list) (path:string):string =
	txt_of_doc options (doc_of_nmm path)

let txt_of_axml (options : string list) (path : string) : string =
	txt_of_doc options (doc_of_axml path) 

let html_of_axml (options : string list) (path : string) : string =
	try 
	html_of_doc options (doc_of_axml path)
	with
	Compiler_of_doc.Error e -> raise (Error (String.concat " " [path;"->";"Compiler_of_doc.Error:";e]))

let axml_of_nmm (path : string) : string =
	axml_of_doc (doc_of_nmm path)

let check_xml_schema (path:string):string =
	try
	let dtd:Dtd.dtd=Dtd.parse_file path in
	let _:Dtd.checked=Dtd.check dtd in
	String.concat " " [path;"is a well-defined xml-schema"]
	with 
	Xml_light_errors.Dtd_check_error e -> raise (Error (String.concat " " [path;"->";"Xml_light_errors.Dtd_check_error:";Dtd.check_error e]))

let validate_xml (path_to_dtd : string) (path_to_xml : string) : string =
	let print_tokens = false in 
	try 
	let dtd:Dtd.dtd=Dtd.parse_file path_to_dtd in
	let checked_dtd:Dtd.checked=Dtd.check dtd in
	let xml:Xml.xml=
		match path_to_xml with
		|"-" -> Xml_right.parse_stdin print_tokens 
		|path -> Xml_right.parse_file print_tokens path
	in
	match xml with
	|Xml.Element (entry_point, _, _) ->
		let _=Dtd.prove checked_dtd entry_point xml in 
		String.concat " " [path_to_xml;"is an instance of";path_to_dtd;"with entry-point";entry_point]
	| _  -> raise (Error (path_to_xml ^ " has no entry_point"))
	with 
	|Xml_light_errors.Dtd_parse_error e -> raise (Error (String.concat " " [path_to_dtd;"->";"Xml_light_errors.Dtd_parse_error:";Dtd.parse_error e]))
	|Xml_light_errors.Dtd_check_error e -> raise (Error (String.concat " " [path_to_dtd;"->";"Xml_light_errors.Dtd_check_error:";Dtd.check_error e]))
	|Xml_light_errors.Dtd_prove_error e -> raise (Error (String.concat " " [path_to_dtd;path_to_xml;"->";"Xml_light_errors.Dtd_prove_error:";Dtd.prove_error e]))
	|Xml_light_errors.Xml_error e -> raise (Error (String.concat " " [path_to_xml;"->";"Xml_light_errors.Xml_error:";Xml.error e]))

let default_css () : string = Html_utils.internal_css (Html_utils.default_tab_length ()) (Html_utils.default_margin ())


let exml_of_doc (options : string list) (doc : Doc_types.tr_doc) : string =
	let _ : unit = Debug_utils.quiet.contents <- List.mem "--quiet" options in
	"<?xml version=\"1.0\"?>\n" ^ 
	(Xml_right.to_string_fmt (Compiler_of_doc.exml_of_tr_doc options doc))

let exml_of_nmm (options : string list) (path : string) : string =
	exml_of_doc options (doc_of_nmm path)

let exml_of_axml (options : string list) (path : string) : string =
	exml_of_doc options (doc_of_axml path)


