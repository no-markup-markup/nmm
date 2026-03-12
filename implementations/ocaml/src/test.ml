exception Error of string

let validate_exml (path : string) (format : string) (path_to_dtd : string) (exml : Xml.xml) : unit =
        try
                let dtd : Dtd.dtd = Dtd.parse_file path_to_dtd in
                let checked : Dtd.checked = Dtd.check dtd in
                let _ = Dtd.prove checked "doc" exml in ()
        with
        |Dtd.Prove_error e -> raise (Error (String.concat " " [path;format;"->";"Ddt.prove_error:";Dtd.prove_error e]))

let validate_axml (path : string) (format : string) (path_to_dtd : string) (axml : Xml.xml) : unit =
        try
                let dtd : Dtd.dtd = Dtd.parse_file path_to_dtd in
                let checked : Dtd.checked = Dtd.check dtd in
                let _ = Dtd.prove checked "cr_doc" axml in ()
        with
        |Dtd.Prove_error e -> raise (Error (String.concat " " [path;format;"->";"Ddt.prove_error:";Dtd.prove_error e]))

let rec test_with_nmm_file (options : string list) (path : string) : unit =
try
        let _ : unit = Debug_utils.quiet.contents <- List.mem "--quiet" options in
        let doc : Doc_types.tr_doc = Main.doc_of_nmm path in
        let axml : Xml.xml = Axml_of_doc.axml_of_tr_doc doc in
        let doc_of_axml : Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
        let exml : Xml.xml = Compiler_of_doc.exml_of_tr_doc options doc in
        let _ : unit = identity_test_w_doc path doc doc_of_axml in
        let _ : unit = xml_right_test path "axml" doc axml in
        let _ : unit = xml_right_test path "exml" doc exml in
        let _ : unit = xml_right_test_fmt path "axml" doc axml in
        let _ : unit = xml_right_test_fmt path "exml" doc exml in
        let _ : unit = validate_axml path "axml" "../docs/specs/axml.dtd" axml in
        let _ : unit = validate_exml path "exml" "../docs/specs/exml.dtd" exml in
        ()
with
|Main.Error e -> raise (Error (String.concat " " [path;" -> ";"Main.Error:";e]))
|Compiler_of_doc.Error e -> raise (Error (String.concat " " [path;" -> ";"Compiler_of_doc.Error:";e]))
|Doc_of_axml.Error e -> raise (Error (String.concat " " [path;" -> ";"Doc_of_axml.Error:";e]))


and test_with_axml_file (options : string list) (path : string) : unit =
try
        let _ : unit = Debug_utils.quiet.contents <- List.mem "--quiet" options in
        let axml : Xml.xml = Xml_right.parse_file false path in
        let doc : Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
        let axml_of_doc : Xml.xml = Axml_of_doc.axml_of_tr_doc doc in
        let exml : Xml.xml = Compiler_of_doc.exml_of_tr_doc options doc in
        let _ : unit = identity_test_w_axml path axml axml_of_doc in
        let _ : unit = xml_right_test path "axml" doc axml in
        let _ : unit = xml_right_test path "exml" doc exml in
        let _ : unit = xml_right_test_fmt path "axml" doc axml in
        let _ : unit = xml_right_test_fmt path "exml" doc exml in
        let _ : unit = validate_axml path "axml" "../docs/specs/axml.dtd" axml in
        let _ : unit = validate_exml path "exml" "../docs/specs/exml.dtd" exml in
        ()
with
|Xml_right.Error e -> raise (Error (String.concat " " [path;" -> ";"Xml_right.Error:";e]))
|Main.Error e -> raise (Error (String.concat " " [path;" -> ";"Main.Error:";e]))
|Compiler_of_doc.Error e -> raise (Error (String.concat " " [path;" -> ";"Compiler_of_doc.Error:";e]))
|Doc_of_axml.Error e -> raise (Error (String.concat " " [path;" -> ";"Doc_of_axml.Error:";e]))


and identity_test_w_doc (path : string) (doc : Doc_types.tr_doc) (doc_of_axml : Doc_types.tr_doc) : unit =
        match doc = doc_of_axml with
        |true -> ()
        |false -> raise (Error (String.concat " " [path;"->";"doc_of_axml (axml_of_doc doc) NOT EQUAL TO doc"]))

and identity_test_w_axml (path : string) (axml : Xml.xml) (axml_of_doc : Xml.xml) : unit =
        match axml = axml_of_doc with
        |true -> ()
        |false -> raise (Error (String.concat " " [path;"->";"axml_of_doc (doc_of_axml axml) NOT EQUAL TO axml"]))


and xml_right_test (path : string) (format : string) (doc : Doc_types.tr_doc) (xml : Xml.xml): unit =
        try
                let xml_string : string = Xml_right.to_string xml in
                let xml_of_string : Xml.xml = Xml_right.parse_string false xml_string in
                match xml = xml_of_string with
                |true -> ()
                |false -> raise (Error (String.concat " " [path;"->";format;"NOT EQUAL TO Xml_right.parse_string (Xml_right.to_string";format;")"]))
        with
        |Error s 
        |Xml_right.Error s -> raise (Error s)

and xml_right_test_fmt (path : string) (format : string) (doc : Doc_types.tr_doc) (xml : Xml.xml): unit =
        try
                let xml_string : string = Xml_right.to_string_fmt xml in
                let xml_of_string : Xml.xml = Xml_right.parse_string false xml_string in
                match xml = xml_of_string with
                |true -> ()
                |false -> raise (Error (String.concat " " [path;"->";format;"NOT EQUAL TO Xml_right.parse_string (Xml_right.to_string_fmt";format;")"]))
        with
        |Error s 
        |Xml_right.Error s -> raise (Error s)

