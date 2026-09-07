exception Error of string

let exml_dtd : Dtd.dtd = Dtd.parse_string (Exml_utils.exml_schema ())
let exml_dtd_checked : Dtd.checked = Dtd.check exml_dtd


let validate_exml (exml : Xml.xml) : unit =
  try
    let _ = Dtd.prove exml_dtd_checked "doc" exml in
    ()
  with Dtd.Prove_error e ->
    raise
      (Error
         (String.concat " "
            [ "exml Ddt.prove_error:"; Dtd.prove_error e ]))

let axml_dtd : Dtd.dtd = Dtd.parse_string (Axml_of_doc.axml_schema ())
let axml_dtd_checked : Dtd.checked = Dtd.check axml_dtd


let validate_axml (axml : Xml.xml) : unit =
  try
    let _ = Dtd.prove axml_dtd_checked "cr_doc" axml in
    ()
  with Dtd.Prove_error e ->
    raise
      (Error
         (String.concat " "
            [ "axml Ddt.prove_error:"; Dtd.prove_error e ]))


let identity_test_w_doc (doc : Doc_types.tr_doc)
    (doc_of_axml : Doc_types.tr_doc) : unit =
  match doc = doc_of_axml with
  | true -> ()
  | false ->
      raise
        (Error "doc_of_axml (axml_of_doc doc) != doc")

let identity_test_w_axml (axml : Xml.xml)
    (axml_of_doc : Xml.xml) : unit =
  match axml = axml_of_doc with
  | true -> ()
  | false ->
      raise
        (Error "axml_of_doc (doc_of_axml axml) != axml")

let xml_right_test (format : string) (xml : Xml.xml) : unit =
  try
    let xml_string : string = Xml_right.to_string xml in
    let xml_of_string : Xml.xml = Xml_right.parse_string false xml_string in
    match xml = xml_of_string with
    | true -> ()
    | false ->
        raise
          (Error
             (String.concat " "
                [
                  format;
                  "!= Xml_right.parse_string (Xml_right.to_string";
                  format;
                  ")";
                ]))
  with Error s | Xml_right.Error s -> raise (Error s)

let xml_right_test_fmt (format : string) (xml : Xml.xml) : unit =
  try
    let xml_string : string = Xml_right.to_string_fmt xml in
    let xml_of_string : Xml.xml = Xml_right.parse_string false xml_string in
    match xml = xml_of_string with
    | true -> ()
    | false ->
        raise
          (Error
             (String.concat " "
                [
                  format;
                  "!= Xml_right.parse_string (Xml_right.to_string_fmt";
                  format;
                  ")";
                ]))
  with Error s | Xml_right.Error s -> raise (Error s)

let test_with_nmm_file (options : Common_utils.t_exml_options)
    (path : string) : unit =
  try
    let doc : Doc_types.tr_doc =
      Main.doc_of_nmm (Common_utils.axml_options_of_exml_options options) path
    in
    let axml : Xml.xml = Axml_of_doc.axml_of_tr_doc doc in
    let doc_of_axml : Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
    let exml : Xml.xml = Compiler_of_doc.exml_of_tr_doc options doc
    in
    let _ : unit = identity_test_w_doc doc doc_of_axml in
    let _ : unit = xml_right_test "axml" axml in
    let _ : unit = xml_right_test "exml" exml in
    let _ : unit = xml_right_test_fmt "axml" axml in
    let _ : unit = xml_right_test_fmt "exml" exml in
    let _ : unit = validate_axml axml in
    let _ : unit = validate_exml exml in
    print_endline (path ^ " -> All tests PASSED")
  with
  | Error e -> 
      raise (Error (String.concat " " [ path; "->"; "Error:"; e ]))
  | Main.Error e ->
      raise (Error (String.concat " " [ path; "->"; "Main.Error:"; e ]))
  | Compiler_of_doc.Error e ->
      raise
        (Error (String.concat " " [ path; "->"; "Compiler_of_doc.Error:"; e ]))
  | Doc_of_axml.Error e ->
      raise
        (Error (String.concat " " [ path; "->"; "Doc_of_axml.Error:"; e ]))

let test_with_axml_file (options : Common_utils.t_exml_options) (path : string)
    : unit =
  try
    let axml : Xml.xml = Xml_right.parse_file false path in
    let doc : Doc_types.tr_doc = Doc_of_axml.f_tr_doc_of_axml axml in
    let axml_of_doc : Xml.xml = Axml_of_doc.axml_of_tr_doc doc in
    let exml : Xml.xml = Compiler_of_doc.exml_of_tr_doc options doc in
    let _ : unit = identity_test_w_axml axml axml_of_doc in
    let _ : unit = xml_right_test "axml" axml in
    let _ : unit = xml_right_test "exml" exml in
    let _ : unit = xml_right_test_fmt "axml" axml in
    let _ : unit = xml_right_test_fmt "exml" exml in
    let _ : unit = validate_axml axml in
    let _ : unit = validate_exml exml in
    print_endline (path ^ " -> All tests PASSED")
  with
  | Error e -> 
      raise (Error (String.concat " " [ path; "->"; "Error:"; e ]))
  | Xml_right.Error e ->
      raise (Error (String.concat " " [ path; "->"; "Xml_right.Error:"; e ]))
  | Main.Error e ->
      raise (Error (String.concat " " [ path; "->"; "Main.Error:"; e ]))
  | Compiler_of_doc.Error e ->
      raise
        (Error (String.concat " " [ path; "->"; "Compiler_of_doc.Error:"; e ]))
  | Doc_of_axml.Error e ->
      raise
        (Error (String.concat " " [ path; "->"; "Doc_of_axml.Error:"; e ]))

