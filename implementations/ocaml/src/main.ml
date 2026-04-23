open Doc_types

exception Error of string

let doc_of_nmm (options : Common_utils.t_axml_options) (path : string) : Doc_types.tr_doc =
        try
        match path with
        |"-" -> Doc_of_nmm.doc_of_nmm_stdin_with_tagger (Tags.tagger_of_path_opt options.tags)
        |_ -> Doc_of_nmm.doc_of_nmm_file_with_tagger (Tags.tagger_of_path_opt options.tags) path
        with 
        |Doc_of_nmm.Error e -> raise (Error (String.concat " " [path;"->";"Doc_of_nmm.Error:";e]))


let txt_of_doc (options : Common_utils.t_txt_options) (doc : Doc_types.tr_doc) : string =
        try
        Compiler_of_doc.txt_of_tr_doc options doc
        with
        |Compiler_of_doc.Error e -> raise (Error (String.concat " " ["Compiler_of_doc.Error:";e]))


let html_of_doc (options : Common_utils.t_html_options) (doc : Doc_types.tr_doc) : string =
        try
        let exml:Xml.xml = Compiler_of_doc.exml_of_tr_doc (Common_utils.exml_options_of_html_options options) doc in
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
        let lang_attr : string = (" lang=\"" ^ options.lang ^ "\"") in
        let margin_left : string = 
                match options.margin with
                |Some m -> (string_of_int m) ^ "rem"
                |None -> Html_utils.margin_left_of_tr_doc doc
        in
        let internal_css: string = ("<style>\n" ^ (Html_utils.internal_css "6ch" margin_left) ^ "\n</style>") in
        let external_css: string =
                let map (uri : string) : string = ("<link rel=\"stylesheet\" href=\"" ^ uri ^ "\">\n") in
                String.concat "" (List.map map options.css)
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
        |Common_utils.Error e -> raise (Error (String.concat " " ["Common_utils.Error:"; e]))
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
        (Xml_right.to_string_fmt (Axml_of_doc.normalize_axml (Axml_of_doc.axml_of_tr_doc doc)))

let html_of_nmm (options : Common_utils.t_html_options) (path : string) : string =
        html_of_doc options (doc_of_nmm (Common_utils.axml_options_of_html_options options) path)

let txt_of_nmm (options : Common_utils.t_txt_options) (path:string):string =
        txt_of_doc options (doc_of_nmm (Common_utils.axml_options_of_txt_options options) path)

let txt_of_axml (options : Common_utils.t_txt_options) (path : string) : string =
        txt_of_doc options (doc_of_axml path) 

let html_of_axml (options : Common_utils.t_html_options) (path : string) : string =
        html_of_doc options (doc_of_axml path)

let axml_of_nmm (options : Common_utils.t_axml_options) (path : string) : string =
        axml_of_doc (doc_of_nmm options path)

let check_xml_schema (path : string) : string =
        try
        let dtd:Dtd.dtd=Dtd.parse_file path in
        let _:Dtd.checked=Dtd.check dtd in
        String.concat " " [path;"is a well-defined xml-schema"]
        with
        |Xml_light_errors.Dtd_check_error e -> raise (Error (String.concat " " [path;"->";"Xml_light_errors.Dtd_check_error:";Dtd.check_error e]))
        |Xml_light_errors.Dtd_parse_error e -> raise (Error (String.concat " " [path;"->";"Xml_light_errors.Dtd_parse_error:";Dtd.parse_error e]))

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
        |Xml_light_errors.File_not_found e -> raise (Error (String.concat " " ["Xml_light_errors.File_not_found:";e]))
        |Xml_right.Error e -> raise (Error (String.concat " " [path_to_xml;"->";"Xml_right.Error:";e]))

let default_css () : string = Html_utils.internal_css "6ch" "0rem"


let exml_of_doc (options : Common_utils.t_exml_options) (doc : Doc_types.tr_doc) : string =
        "<?xml version=\"1.0\"?>\n" ^ 
        (Xml_right.to_string_fmt (Exml_utils.normalize_exml (Compiler_of_doc.exml_of_tr_doc options doc)))

let exml_of_nmm (options : Common_utils.t_exml_options) (path : string) : string =
        exml_of_doc options (doc_of_nmm (Common_utils.axml_options_of_exml_options options) path)

let exml_of_axml (options : Common_utils.t_exml_options) (path : string) : string =
        exml_of_doc options (doc_of_axml path)

let normalize_axml_file (path : string) : string =
        let axml:Xml.xml =
                match path with
                |"-" -> Xml_right.parse_stdin false
                |_ -> Xml_right.parse_file false path 
	in
        "<?xml version=\"1.0\"?>\n" ^ 
        (Xml_right.to_string_fmt (Axml_of_doc.normalize_axml axml))

