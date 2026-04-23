open Nmm_ocaml

exception Error of string

let usage : string=
"USAGE:
nmm-ocaml [
  | txt-of-nmm   [ <txt-options>  ] { <path-to-nmm-file>  | - }
  | html-of-nmm  [ <html-options> ] { <path-to-nmm-file>  | - }
  | exml-of-nmm  [ <exml-options> ] { <path-to-nmm-file>  | - }

  | axml-of-nmm  [ <axml-options> ] { <path-to-nmm-file>  | - }

  | txt-of-axml  [ <txt-options>  ] { <path-to-axml-file> | - }
  | html-of-axml [ <html-options> ] { <path-to-axml-file> | - }
  | exml-of-axml [ <exml-options> ] { <path-to-axml-file> | - }

  | check-xml-schema <path-to-dtd-file>
  | validate-xml <path-to-dtd-file> { <path-to-xml-file> | - }
  | show-default-css
  | normalize-axml { <path-to-axml-file> | - }
]

In cases where '-' can be given instead of a path, the program
reads from standard input.

TXT-OPTIONS:
  --margin <numeral>
  --width <numeral>
  --quiet
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --tags <path-to-tsv-file>

HTML-OPTIONS:
  --margin <numeral>
  --lang <language-code>
  --css <uri>
  --quiet
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --tags <path-to-tsv-file>

EXML-OPTIONS:
  --numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }
  --allow-custom-numbering
  --quiet
  --tags <path-to-tsv-file>

AXML-OPTIONS:
  --tags <path-to-tsv-file>
"

type t_keyspecdoc = (Arg.key *  Arg.spec * Arg.doc)

let cmd_name : string ref = ref ""

let path_to_nmm_file: string ref = ref ""

let path_to_xml_file: string ref = ref ""

let path_to_dtd_file: string ref = ref ""

let anon_arg_count : int ref = ref 0

let margin : (int option) ref = ref None

let width : (int option) ref = ref None

let lang : string ref = ref "en"

let css : (string list) ref = ref []

let read_from_stdin : bool ref = ref false

let quiet : bool ref = ref false

let numbering : string ref = ref "a1i"

let allow_custom_numbering : bool ref = ref false

let tags : (string option) ref = ref None

let keyspecdoc_list : t_keyspecdoc list ref = ref []

let set_margin (s : string) : unit =
        margin.contents <- Some (int_of_string s)

let keyspecdoc_margin : t_keyspecdoc =
        ("--margin", Arg.String set_margin, "")

let set_width (s : string) : unit =
        width.contents <- Some (int_of_string s)

let keyspecdoc_width : t_keyspecdoc =
        ("--width", Arg.String set_width, "")


let keyspecdoc_lang : t_keyspecdoc =
        ("--lang", Arg.Set_string lang, "")

let add_css (s : string) : unit =
        css.contents <- (s::css.contents)

let keyspecdoc_css : t_keyspecdoc =
        ("--css", Arg.String add_css, "")

let keyspecdoc_stdin : t_keyspecdoc =
        ("-", Arg.Set read_from_stdin, "")

let keyspecdoc_quiet : t_keyspecdoc =
        ("--quiet", Arg.Set quiet, "")

let keyspecdoc_numbering : t_keyspecdoc =
        ("--numbering", Arg.Set_string numbering, "")

let keyspecdoc_allow_custom_numbering : t_keyspecdoc =
        ("--allow-custom-numbering", Arg.Set allow_custom_numbering, "")

let add_tags (s : string) : unit =
        tags.contents <- (Some s)

let keyspecdoc_tags : t_keyspecdoc =
        ("--tags", Arg.String add_tags, "")


let keyspecdoc_list_txt_of_nmm : t_keyspecdoc list = [
        keyspecdoc_margin;
        keyspecdoc_stdin;
        keyspecdoc_quiet;
        keyspecdoc_width;
        keyspecdoc_numbering;
        keyspecdoc_allow_custom_numbering;
        keyspecdoc_tags;
]

let keyspecdoc_list_txt_of_xml : t_keyspecdoc list = [
        keyspecdoc_margin;
        keyspecdoc_stdin;
        keyspecdoc_quiet;
        keyspecdoc_width;
        keyspecdoc_numbering;
        keyspecdoc_allow_custom_numbering;
        keyspecdoc_tags;
]


let keyspecdoc_list_xml_of_nmm : t_keyspecdoc list = [
        keyspecdoc_stdin;
        keyspecdoc_tags;
]

let keyspecdoc_list_html_of_nmm : t_keyspecdoc list = [
        keyspecdoc_margin;
        keyspecdoc_stdin;
        keyspecdoc_quiet;
        keyspecdoc_lang;
        keyspecdoc_css;
        keyspecdoc_numbering;
        keyspecdoc_allow_custom_numbering;
        keyspecdoc_tags;
]

let keyspecdoc_list_html_of_xml : t_keyspecdoc list = [
        keyspecdoc_margin;
        keyspecdoc_stdin;
        keyspecdoc_quiet;
        keyspecdoc_lang;
        keyspecdoc_css;
        keyspecdoc_numbering;
        keyspecdoc_allow_custom_numbering;
        keyspecdoc_tags;
]

let keyspecdoc_list_exml_of_nmm : t_keyspecdoc list = [
        keyspecdoc_stdin;
        keyspecdoc_quiet;
        keyspecdoc_numbering;
        keyspecdoc_allow_custom_numbering;
        keyspecdoc_tags;
]

let keyspecdoc_list_exml_of_axml : t_keyspecdoc list = [
        keyspecdoc_stdin;
        keyspecdoc_quiet;
        keyspecdoc_numbering;
        keyspecdoc_allow_custom_numbering;
        keyspecdoc_tags;
]

let keyspecdoc_list_normalize_axml : t_keyspecdoc list = [
        keyspecdoc_stdin;
]

let anon_arg_fun arg : unit =
        match anon_arg_count.contents with
        |0 ->
                let _ : unit =
                match arg with
                |"txt-of-axml" -> keyspecdoc_list.contents <- keyspecdoc_list_txt_of_xml
                |"test-with-axml"
                |"html-of-axml" -> keyspecdoc_list.contents <- keyspecdoc_list_html_of_xml
                |"axml-of-nmm" -> keyspecdoc_list.contents <- keyspecdoc_list_xml_of_nmm
                |"txt-of-nmm" -> keyspecdoc_list.contents <- keyspecdoc_list_txt_of_nmm
                |"test-with-nmm"
                |"html-of-nmm" -> keyspecdoc_list.contents <- keyspecdoc_list_html_of_nmm
                |"check-xml-schema" -> ()
                |"validate-xml" -> ()
                |"show-default-css" -> ()
                |"exml-of-nmm" -> keyspecdoc_list.contents <- keyspecdoc_list_exml_of_nmm
                |"exml-of-axml" -> keyspecdoc_list.contents <- keyspecdoc_list_exml_of_axml
                |"normalize-axml" -> keyspecdoc_list.contents <- keyspecdoc_list_normalize_axml
                |_ -> raise (Error (String.concat " " ["unknown command:";arg]))
                in
                let _ : unit = cmd_name.contents <- arg
                in anon_arg_count.contents <- (anon_arg_count.contents + 1)

        |1 ->
                let _ : unit =
                match cmd_name.contents with
                |"txt-of-axml" -> path_to_xml_file.contents <- arg
                |"test-with-axml"
                |"html-of-axml" -> path_to_xml_file.contents <- arg
                |"axml-of-nmm" -> path_to_nmm_file.contents <- arg
                |"txt-of-nmm" -> path_to_nmm_file.contents <- arg
                |"test-with-nmm"
                |"html-of-nmm" -> path_to_nmm_file.contents <- arg
                |"check-xml-schema" -> path_to_dtd_file.contents <- arg
                |"validate-xml" -> let _ : unit = path_to_dtd_file.contents <- arg in keyspecdoc_list.contents <- (keyspecdoc_stdin::keyspecdoc_list.contents)
                |"show-default-css" -> raise (Error (String.concat " " ["one too many arguments:";arg]))
                |"exml-of-nmm" -> path_to_nmm_file.contents <- arg
                |"exml-of-axml" -> path_to_xml_file.contents <- arg
                |"normalize-axml" -> path_to_xml_file.contents <- arg
                |_ -> raise (Error (String.concat " " ["unknown command:";cmd_name.contents]))
                in anon_arg_count.contents <- (anon_arg_count.contents + 1)
        |2 -> 
                let _ : unit =
                match cmd_name.contents with
                |"txt-of-axml"
                |"test-with-axml"
                |"html-of-axml"
                |"axml-of-nmm"
                |"txt-of-nmm"
                |"test-with-nmm"
                |"html-of-nmm"
                |"check-xml-schema" -> raise (Error (String.concat " " ["one too many arguments:";arg]))
                |"validate-xml" -> path_to_xml_file.contents <- arg
                |_ -> raise (Error (String.concat " " ["unknown command:";cmd_name.contents]))
                in anon_arg_count.contents <- (anon_arg_count.contents + 1)
        |_ -> raise (Error (String.concat " " ["one too many arguments:";arg]))


let _ : unit = try
        let _ : unit = Arg.parse_dynamic keyspecdoc_list anon_arg_fun usage in
        match cmd_name.contents with
        |"txt-of-axml" -> (
                let options : Common_utils.t_txt_options = {
                        margin = margin.contents;
                        width = width.contents;
                        quiet = quiet.contents;
                        numbering = numbering.contents;
                        allow_custom_numbering = allow_custom_numbering.contents;
                        tags = tags.contents;
                }
                in
                match read_from_stdin.contents with
                |true -> print_endline (Main.txt_of_axml options "-")
                |false ->
                        match path_to_xml_file.contents with
                        |"" -> raise (Error "missing path-to-axml-file")
                        |path -> print_endline (Main.txt_of_axml options path)
        )
        |"html-of-axml" -> (
                let options : Common_utils.t_html_options = {
                        margin = margin.contents;
                        lang = lang.contents;
                        css = css.contents;
                        quiet = quiet.contents;
                        numbering = numbering.contents;
                        allow_custom_numbering = allow_custom_numbering.contents;
                        tags = tags.contents;
                }
                in
                match read_from_stdin.contents with
                |true -> print_endline (Main.html_of_axml options "-")
                |false -> 
                        match path_to_xml_file.contents with
                        |"" -> raise (Error "missing path-to-axml-file")
                        |path ->print_endline (Main.html_of_axml options path)
        )
        |"axml-of-nmm" -> (
                let options : Common_utils.t_axml_options = {
                        tags = tags.contents;
                }
                in
                match read_from_stdin.contents with
                |true -> print_endline (Main.axml_of_nmm options "-")
                |false ->
                        match path_to_nmm_file.contents with
                        |"" -> raise (Error "missing path-to-nmm-file")
                        |path -> print_endline (Main.axml_of_nmm options path)
        )
        |"txt-of-nmm" -> (
                let options : Common_utils.t_txt_options = {
                        margin = margin.contents;
                        width = width.contents;
                        quiet = quiet.contents;
                        numbering = numbering.contents;
                        allow_custom_numbering = allow_custom_numbering.contents;
                        tags = tags.contents;
                }
                in
                match read_from_stdin.contents with
                |true -> print_endline (Main.txt_of_nmm options "-")
                |false ->
                        match path_to_nmm_file.contents with
                        |"" -> raise (Error "missing path-to-nmm-file")
                        |path -> print_endline (Main.txt_of_nmm options path)
        )
        |"html-of-nmm" -> (
                let options : Common_utils.t_html_options = {
                        margin = margin.contents;
                        lang = lang.contents;
                        css = css.contents;
                        quiet = quiet.contents;
                        numbering = numbering.contents;
                        allow_custom_numbering = allow_custom_numbering.contents;
                        tags = tags.contents;
                }
                in
                match read_from_stdin.contents with
                |true -> print_endline (Main.html_of_nmm options "-")
                |false ->
                        match path_to_nmm_file.contents with
                        |"" -> raise (Error "missing path-to-nmm-file")
                        |path -> print_endline (Main.html_of_nmm options path)
        )
        |"check-xml-schema" -> print_endline (Main.check_xml_schema path_to_dtd_file.contents)
        |"validate-xml" -> (
                match read_from_stdin.contents with
                |true -> print_endline (Main.validate_xml path_to_dtd_file.contents "-")
                |false -> print_endline (Main.validate_xml path_to_dtd_file.contents path_to_xml_file.contents)
        )
        |"show-default-css" -> print_endline (Main.default_css ())
        |"test-with-axml" -> (
                let options : Common_utils.t_html_options = {
                        margin = margin.contents;
                        lang = lang.contents;
                        css = css.contents;
                        quiet = quiet.contents;
                        numbering = numbering.contents;
                        allow_custom_numbering = allow_custom_numbering.contents;
                        tags = tags.contents;
                }
                in
                match path_to_xml_file.contents with
                |"" -> raise (Error "missing path-to-axml-file")
                |path -> Test.test_with_axml_file options path
        )
        |"test-with-nmm" -> (
                let options : Common_utils.t_html_options = {
                        margin = margin.contents;
                        lang = lang.contents;
                        css = css.contents;
                        quiet = quiet.contents;
                        numbering = numbering.contents;
                        allow_custom_numbering = allow_custom_numbering.contents;
                        tags = tags.contents;
                }
                in
                match path_to_nmm_file.contents with
                |"" -> raise (Error "missing path-to-nmm-file")
                |path -> Test.test_with_nmm_file options path
        )
        |"exml-of-nmm" -> (
                let options : Common_utils.t_exml_options = {
                        quiet = quiet.contents;
                        numbering = numbering.contents;
                        allow_custom_numbering = allow_custom_numbering.contents;
                        tags = tags.contents;
                }
                in
                match read_from_stdin.contents with
                |true -> print_endline (Main.exml_of_nmm options "-")
                |false ->
                        match path_to_nmm_file.contents with
                        |"" -> raise (Error "missing path-to-nmm-file")
                        |path -> print_endline (Main.exml_of_nmm options path)
        )
        |"exml-of-axml" -> (
                let options : Common_utils.t_exml_options = {
                        quiet = quiet.contents;
                        numbering = numbering.contents;
                        allow_custom_numbering = allow_custom_numbering.contents;
                        tags = tags.contents;
                }
                in
                match read_from_stdin.contents with
                |true -> print_endline (Main.exml_of_axml options "-")
                |false ->
                        match path_to_xml_file.contents with
                        |"" -> raise (Error "missing path-to-axml-file")
                        |path -> print_endline (Main.exml_of_axml options path)
        )
        |"normalize-axml" -> (
                match read_from_stdin.contents with
                |true -> print_endline (Main.normalize_axml_file "-")
                |false ->
                        match path_to_xml_file.contents with
                        |"" -> raise (Error "missing path-to-axml-file")
                        |path -> print_endline (Main.normalize_axml_file path)
        )
        |_ -> print_endline usage
with
|Error e -> 
        let _ : unit = IO.print_to_stderr e in
        print_endline usage
|Main.Error e -> IO.print_to_stderr e
|Test.Error e -> raise (Error (String.concat " " ["Test.Error:";e]))
