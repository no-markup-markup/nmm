open Nmm_ocaml

exception Error of string

let commands : string list =
  [
    "txt-of-nmm";
    "html-of-nmm";
    "exml-of-nmm";
    "axml-of-nmm";
    "txt-of-axml";
    "html-of-axml";
    "exml-of-axml";
    "check-xml-schema";
    "validate-xml";
    "normalize-axml";
    "show-axml-schema";
    "show-exml-schema";
    "version";
    "help";
  ]

let usage_msg_of_command (command : string) : string =
  match command with
  | "txt-of-nmm" -> "[ OPTIONS ] { PATH-TO-NMM-FILE | - }"
  | "html-of-nmm" -> "[ OPTIONS ] { PATH-TO-NMM-FILE | - }"
  | "exml-of-nmm" -> "[ OPTIONS ] { PATH-TO-NMM-FILE | - }"
  | "axml-of-nmm" -> "[ OPTIONS ] { PATH-TO-NMM-FILE | - }"
  | "txt-of-axml" -> "[ OPTIONS ] { PATH-TO-AXML-FILE | - }"
  | "html-of-axml" -> "[ OPTIONS ] { PATH-TO-AXML-FILE | - }"
  | "exml-of-axml" -> "[ OPTIONS ] { PATH-TO-AXML-FILE | - }"
  | "check-xml-schema" -> "PATH-TO-DTD-FILE"
  | "validate-xml" -> "PATH-TO-DTD-FILE { PATH-TO-XML-FILE | - }"
  | "normalize-axml" -> "{ PATH-TO-AXML-FILE | - }"
  | _ -> ""

let usage_msg : string =
"nmm-ocaml [
  | txt-of-nmm   [ TXT-OPTIONS  ] { PATH-TO-NMM-FILE  | - }
  | html-of-nmm  [ HTML-OPTIONS ] { PATH-TO-NMM-FILE  | - }
  | exml-of-nmm  [ EXML-OPTIONS ] { PATH-TO-NMM-FILE  | - }
  | axml-of-nmm  [ AXML-OPTIONS ] { PATH-TO-NMM-FILE  | - }
  | txt-of-axml  [ TXT-OPTIONS  ] { PATH-TO-AXML-FILE | - }
  | html-of-axml [ HTML-OPTIONS ] { PATH-TO-AXML-FILE | - }
  | exml-of-axml [ EXML-OPTIONS ] { PATH-TO-AXML-FILE | - }
  | check-xml-schema PATH-TO-DTD-FILE
  | validate-xml PATH-TO-DTD-FILE { PATH-TO-XML-FILE | - }
  | normalize-axml { PATH-TO-AXML-FILE | - }
  | show-axml-schema
  | show-exml-schema
  | version
  | help
]"

let stdin_msg : string =
"In cases where '-' may be provided instead of a path, the program
reads from standard input."


let axml_options : string list =
  [
    "--tags PATH-TO-TSV-FILE";
  ]

let exml_options : string list =
  List.concat [
    axml_options;
    [
      "--numbering { a1i | ai1 | 1ai | 1ia | ia1 | i1a }";
      "--allow-custom-numbering";
      "--quiet";
    ];
  ]

let txt_options : string list =
  List.concat [
    exml_options;
    [
      "--margin NON-NEGATIVE-INTEGER";
      "--indent NON-NEGATIVE-INTEGER";
      "--width NON-NEGATIVE-INTEGER";
    ];
  ]

let html_options : string list =
  List.concat [
    exml_options;
    [
      "--margin NON-NEGATIVE-INTEGER";
      "--indent NON-NEGATIVE-INTEGER";
      "--lang ISO-LANGUAGE-CODE";
      "--internal-css PATH-TO-CSS-FILE";
      "--external-css URI";
    ];
  ]

let options_of_command (command : string) : string list =
  match command with
  | "txt-of-nmm"
  | "txt-of-axml" -> txt_options
  | "html-of-nmm"
  | "html-of-axml" -> html_options
  | "exml-of-nmm" 
  | "exml-of-axml" -> exml_options
  | "axml-of-nmm" -> axml_options
  | _ -> []

let options_msg_of_command (command : string) : string =
  match options_of_command command with
  | [] -> ""
  | options ->
      String.concat "" [
        "  OPTIONS:\n";
        "  ";  
        String.concat "\n  " (options_of_command command);
      ]

let help_msg : string =
  String.concat "" [
    "USAGE:\n";
    usage_msg; "\n\n";
    stdin_msg; "\n\n";
    "TXT-OPTIONS:\n  ";
    String.concat "\n  " txt_options;"\n\n";
    "HTML-OPTIONS:\n  ";
    String.concat "\n  " html_options;"\n\n";
    "EXML-OPTIONS:";"\n  ";
    String.concat "\n  " exml_options;"\n\n";
    "AXML-OPTIONS:";"\n  ";
    String.concat "\n  " axml_options;
  ]

let help_msg_of_command (command : string) : string =
  match command with
  | "" -> "USAGE:\n" ^ usage_msg
  | _ ->
    let usage_msg : string =
      match usage_msg_of_command command with
      | "" -> String.concat " " ["nmm-ocaml"; command]
      | s -> String.concat " " ["nmm-ocaml"; command; s]
    in
    match options_msg_of_command command with
      | "" -> String.concat "\n" ["USAGE:"; usage_msg]
      | s -> String.concat "\n" ["USAGE:"; usage_msg; s]
 
type t_keyspecdoc = Arg.key * Arg.spec * Arg.doc

let cmd_name : string ref = ref ""
let path_to_nmm_file : string ref = ref ""
let path_to_xml_file : string ref = ref ""
let path_to_dtd_file : string ref = ref ""
let anon_arg_count : int ref = ref 0
let margin : int option ref = ref None
let indent : int option ref = ref None
let width : int option ref = ref None
let lang : string option ref = ref None
let internal_css : string list ref = ref []
let external_css : string list ref = ref []
let read_from_stdin : bool ref = ref false
let quiet : bool ref = ref false
let numbering : string option ref = ref None
let allow_custom_numbering : bool option ref = ref None
let tags : string option ref = ref None
let help : bool ref = ref false

let keyspecdoc_help1 : t_keyspecdoc = ("-help", Arg.Set help, "")
let keyspecdoc_help2 : t_keyspecdoc = ("--help", Arg.Set help, "")
let keyspecdoc_help3 : t_keyspecdoc = ("-h", Arg.Set help, "")

let help_list : t_keyspecdoc list =
  [
    keyspecdoc_help1;
    keyspecdoc_help2;
    keyspecdoc_help3;
  ]

let keyspecdoc_list : t_keyspecdoc list ref = ref help_list

let set_margin (s : string) : unit =
  try 
    let i = int_of_string s in
    if i<0 then raise (Invalid_argument s) else
    margin.contents <- Some i
  with _ -> raise (Error ("invalid --margin argument: " ^ s))

let set_indent (s : string) : unit =
  try
    let i = int_of_string s in
    if i<0 then raise (Invalid_argument s) else
    indent.contents <- Some i
  with _ -> raise (Error ("invalid --indent argument: " ^ s))

let keyspecdoc_margin : t_keyspecdoc = ("--margin", Arg.String set_margin, "")

let keyspecdoc_indent : t_keyspecdoc = ("--indent", Arg.String set_indent, "")

let set_width (s : string) : unit =
  try
    let i = int_of_string s in
    if i<0 then raise (Invalid_argument s) else
    width.contents <- Some i
  with _ -> raise (Error ("invalid --width argument: " ^ s))

let keyspecdoc_width : t_keyspecdoc = ("--width", Arg.String set_width, "")

let set_lang (s : string) : unit =
  lang.contents <- Some s

let keyspecdoc_lang : t_keyspecdoc = ("--lang", Arg.String set_lang, "")

let add_internal_css (s : string) : unit =
  internal_css.contents <- s :: internal_css.contents

let add_external_css (s : string) : unit =
  external_css.contents <- s :: external_css.contents

let keyspecdoc_internal_css : t_keyspecdoc =
  ("--internal-css", Arg.String add_internal_css, "")

let keyspecdoc_external_css : t_keyspecdoc =
  ("--external-css", Arg.String add_external_css, "")

let keyspecdoc_stdin : t_keyspecdoc = ("-", Arg.Set read_from_stdin, "")

let keyspecdoc_quiet : t_keyspecdoc = ("--quiet", Arg.Set quiet, "")

let set_numbering (s : string) : unit =
  numbering.contents <- Some s

let keyspecdoc_numbering : t_keyspecdoc =
  ("--numbering", Arg.String set_numbering, "")

let set_allow_custom_numbering () : unit =
  allow_custom_numbering.contents <- (Some true)

let keyspecdoc_allow_custom_numbering : t_keyspecdoc =
  ("--allow-custom-numbering", Arg.Unit set_allow_custom_numbering, "")

let add_tags (s : string) : unit = tags.contents <- Some s
let keyspecdoc_tags : t_keyspecdoc = ("--tags", Arg.String add_tags, "")

let normalize_axml_list : t_keyspecdoc list =
  keyspecdoc_stdin::help_list

let axml_of_nmm_list : t_keyspecdoc list =
  keyspecdoc_tags::normalize_axml_list

let exml_of_nmm_list : t_keyspecdoc list =
  List.concat [
    axml_of_nmm_list;
    [
      keyspecdoc_quiet;
      keyspecdoc_numbering;
      keyspecdoc_allow_custom_numbering;
    ];
  ]


let txt_of_nmm_list : t_keyspecdoc list =
  List.concat [
    exml_of_nmm_list;
    [
      keyspecdoc_margin;
      keyspecdoc_indent;
      keyspecdoc_width;
    ];
  ]

let txt_of_axml_list : t_keyspecdoc list =
  txt_of_nmm_list


let html_of_nmm_list : t_keyspecdoc list =
  List.concat [
    exml_of_nmm_list;
    [
      keyspecdoc_margin;
      keyspecdoc_indent;
      keyspecdoc_lang;
      keyspecdoc_internal_css;
      keyspecdoc_external_css;
    ];
  ]

let html_of_axml_list : t_keyspecdoc list =
  html_of_nmm_list


let exml_of_axml_list : t_keyspecdoc list =
  exml_of_nmm_list


let anon_arg_fun arg : unit =
  match anon_arg_count.contents with
  | 0 ->
      let _ : unit =
        match arg with
        | "txt-of-axml" ->
            keyspecdoc_list.contents <- txt_of_axml_list
        | "test-with-axml" | "html-of-axml" ->
            keyspecdoc_list.contents <- html_of_axml_list
        | "axml-of-nmm" ->
            keyspecdoc_list.contents <- axml_of_nmm_list
        | "txt-of-nmm" -> keyspecdoc_list.contents <- txt_of_nmm_list
        | "test-with-nmm" | "html-of-nmm" ->
            keyspecdoc_list.contents <- html_of_nmm_list
        | "check-xml-schema" | "validate-xml" | "show-axml-schema"
        | "show-exml-schema" | "show-default-css" | "version" | "help" ->
            ()
        | "exml-of-nmm" ->
            keyspecdoc_list.contents <- exml_of_nmm_list
        | "exml-of-axml" ->
            keyspecdoc_list.contents <- exml_of_axml_list
        | "normalize-axml" ->
            keyspecdoc_list.contents <- normalize_axml_list
        | unknown -> raise (Error (String.concat " " [ "unknown command:"; unknown ]))
      in
      let _ : unit = cmd_name.contents <- arg in
      anon_arg_count.contents <- anon_arg_count.contents + 1
  | 1 ->
      let _ : unit =
        match cmd_name.contents with
        | "txt-of-axml" -> path_to_xml_file.contents <- arg
        | "test-with-axml" | "html-of-axml" -> path_to_xml_file.contents <- arg
        | "axml-of-nmm" -> path_to_nmm_file.contents <- arg
        | "txt-of-nmm" -> path_to_nmm_file.contents <- arg
        | "test-with-nmm" | "html-of-nmm" -> path_to_nmm_file.contents <- arg
        | "check-xml-schema" -> path_to_dtd_file.contents <- arg
        | "validate-xml" ->
            let _ : unit = path_to_dtd_file.contents <- arg in
            keyspecdoc_list.contents <-
              keyspecdoc_stdin :: keyspecdoc_list.contents
        | "show-axml-schema" | "show-exml-schema" | "show-default-css"
        | "version" | "help" ->
            raise (Error (String.concat " " [ "one too many arguments:"; arg ]))
        | "exml-of-nmm" -> path_to_nmm_file.contents <- arg
        | "exml-of-axml" -> path_to_xml_file.contents <- arg
        | "normalize-axml" -> path_to_xml_file.contents <- arg
        | unknown ->
            raise
              (Error
                 (String.concat " " [ "unknown command:"; unknown ]))
      in
      anon_arg_count.contents <- anon_arg_count.contents + 1
  | 2 ->
      let _ : unit =
        match cmd_name.contents with
        | "txt-of-axml" | "test-with-axml" | "html-of-axml" | "axml-of-nmm"
        | "txt-of-nmm" | "test-with-nmm" | "html-of-nmm" | "check-xml-schema" ->
            raise (Error (String.concat " " [ "one too many arguments:"; arg ]))
        | "validate-xml" -> path_to_xml_file.contents <- arg
        | unknown ->
            raise
              (Error
                 (String.concat " " [ "unknown command:"; unknown ]))
      in
      anon_arg_count.contents <- anon_arg_count.contents + 1
  | _ -> raise (Error (String.concat " " [ "one too many arguments:"; arg ]))

let _ : unit =
  let _ : unit = Arg.parse_dynamic keyspecdoc_list anon_arg_fun "" in
  let command : string = cmd_name.contents in
  if help.contents then print_endline (help_msg_of_command command) else
  match command with
  | "txt-of-axml" -> (
      let options : Common_utils.t_txt_options =
        {
          margin = margin.contents;
          indent = indent.contents;
          width = width.contents;
          quiet = quiet.contents;
          numbering = numbering.contents;
          allow_custom_numbering = allow_custom_numbering.contents;
          tags = tags.contents;
        }
      in
      match read_from_stdin.contents with
      | true -> print_endline (Main.txt_of_axml options "-")
      | false -> (
          match path_to_xml_file.contents with
          | "" -> raise (Error "missing PATH-TO-AXML-FILE")
          | path -> print_endline (Main.txt_of_axml options path)))
  | "html-of-axml" -> (
      let options : Common_utils.t_html_options =
        {
          margin = margin.contents;
          indent = indent.contents;
          lang = lang.contents;
          internal_css = List.rev internal_css.contents;
          external_css = List.rev external_css.contents;
          quiet = quiet.contents;
          numbering = numbering.contents;
          allow_custom_numbering = allow_custom_numbering.contents;
          tags = tags.contents;
        }
      in
      match read_from_stdin.contents with
      | true -> print_endline (Main.html_of_axml options "-")
      | false -> (
          match path_to_xml_file.contents with
          | "" -> raise (Error "missing PATH-TO-AXML-FILE")
          | path -> print_endline (Main.html_of_axml options path)))
  | "axml-of-nmm" -> (
      let options : Common_utils.t_axml_options = { tags = tags.contents } in
      match read_from_stdin.contents with
      | true -> print_endline (Main.axml_of_nmm options "-")
      | false -> (
          match path_to_nmm_file.contents with
          | "" -> raise (Error "missing PATH-TO-NMM-FILE")
          | path -> print_endline (Main.axml_of_nmm options path)))
  | "txt-of-nmm" -> (
      let options : Common_utils.t_txt_options =
        {
          margin = margin.contents;
          indent = indent.contents;
          width = width.contents;
          quiet = quiet.contents;
          numbering = numbering.contents;
          allow_custom_numbering = allow_custom_numbering.contents;
          tags = tags.contents;
        }
      in
      match read_from_stdin.contents with
      | true -> print_endline (Main.txt_of_nmm options "-")
      | false -> (
          match path_to_nmm_file.contents with
          | "" -> raise (Error "missing PATH-TO-NMM-FILE")
          | path -> print_endline (Main.txt_of_nmm options path)))
  | "html-of-nmm" -> (
      let options : Common_utils.t_html_options =
        {
          margin = margin.contents;
          indent = indent.contents;
          lang = lang.contents;
          internal_css = List.rev internal_css.contents;
          external_css = List.rev external_css.contents;
          quiet = quiet.contents;
          numbering = numbering.contents;
          allow_custom_numbering = allow_custom_numbering.contents;
          tags = tags.contents;
        }
      in
      match read_from_stdin.contents with
      | true -> print_endline (Main.html_of_nmm options "-")
      | false -> (
          match path_to_nmm_file.contents with
          | "" -> raise (Error "missing PATH-TO-NMM-FILE")
          | path -> print_endline (Main.html_of_nmm options path)))
  | "check-xml-schema" ->
      print_endline (Main.check_xml_schema path_to_dtd_file.contents)
  | "validate-xml" -> (
      match read_from_stdin.contents with
      | true -> print_endline (Main.validate_xml path_to_dtd_file.contents "-")
      | false ->
          print_endline
            (Main.validate_xml path_to_dtd_file.contents
               path_to_xml_file.contents))
  | "show-axml-schema" -> print_endline (Main.axml_schema ())
  | "show-exml-schema" -> print_endline (Main.exml_schema ())
  | "show-default-css" -> print_endline (Main.default_css ())
  | "test-with-axml" -> (
      let options : Common_utils.t_html_options =
        {
          margin = margin.contents;
          indent = indent.contents;
          lang = lang.contents;
          internal_css = List.rev internal_css.contents;
          external_css = List.rev external_css.contents;
          quiet = quiet.contents;
          numbering = numbering.contents;
          allow_custom_numbering = allow_custom_numbering.contents;
          tags = tags.contents;
        }
      in
      match path_to_xml_file.contents with
      | "" -> raise (Error "missing PATH-TO-AXML-FILE")
      | path -> Test.test_with_axml_file options path)
  | "test-with-nmm" -> (
      let options : Common_utils.t_html_options =
        {
          margin = margin.contents;
          indent = indent.contents;
          lang = lang.contents;
          internal_css = List.rev internal_css.contents;
          external_css = List.rev external_css.contents;
          quiet = quiet.contents;
          numbering = numbering.contents;
          allow_custom_numbering = allow_custom_numbering.contents;
          tags = tags.contents;
        }
      in
      match path_to_nmm_file.contents with
      | "" -> raise (Error "missing PATH-TO-NMM-FILE")
      | path -> Test.test_with_nmm_file options path)
  | "exml-of-nmm" -> (
      let options : Common_utils.t_exml_options =
        {
          quiet = quiet.contents;
          numbering = numbering.contents;
          allow_custom_numbering = allow_custom_numbering.contents;
          tags = tags.contents;
        }
      in
      match read_from_stdin.contents with
      | true -> print_endline (Main.exml_of_nmm options "-")
      | false -> (
          match path_to_nmm_file.contents with
          | "" -> raise (Error "missing PATH-TO-NMM-FILE")
          | path -> print_endline (Main.exml_of_nmm options path)))
  | "exml-of-axml" -> (
      let options : Common_utils.t_exml_options =
        {
          quiet = quiet.contents;
          numbering = numbering.contents;
          allow_custom_numbering = allow_custom_numbering.contents;
          tags = tags.contents;
        }
      in
      match read_from_stdin.contents with
      | true -> print_endline (Main.exml_of_axml options "-")
      | false -> (
          match path_to_xml_file.contents with
          | "" -> raise (Error "missing PATH-TO-AXML-FILE")
          | path -> print_endline (Main.exml_of_axml options path)))
  | "normalize-axml" -> (
      match read_from_stdin.contents with
      | true -> print_endline (Main.normalize_axml_file "-")
      | false -> (
          match path_to_xml_file.contents with
          | "" -> raise (Error "missing PATH-TO-AXML-FILE")
          | path -> print_endline (Main.normalize_axml_file path)))
  | "version" -> print_endline (Main.version ())
  | "" | "help" -> print_endline help_msg
  | unknown -> raise (Error ("unknown command: " ^ unknown))
