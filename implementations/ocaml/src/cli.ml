exception Error of string

let usage : string=
"USAGE:

nmm-ocaml [

  | txt-of-xml [ <txt-options> ] { <path-to-xml-file> | - }
  | html-of-xml [ <html-options> ] { <path-to-xml-file> | - }

  | xml-of-nmm <path-to-nmm-file>

  | txt-of-nmm <path-to-nmm-file>
  | html-of-nmm [ <html-options> ] <path-to-nmm-file>

  | check-xml-schema <path-to-dtd-file>
  | validate-xml <path-to-dtd-file> { <path-to-xml-file> | - }

  | show-default-css

]

In cases where '-' can be supplied instead of a path, the program reads from stdin.

HTML-OPTIONS:

  --lang <lang-code>

  --external-css <uri>

  --auto-margin

TXT-OPTIONS:

  --auto-margin
"


let _ : unit =
try
	let argv_array : string array = Sys.argv in
	let argv_list : string list = Array.to_list argv_array in
	let arg_list : string list = List.tl argv_list in
	let command : string = List.hd arg_list in
	match List.rev (List.tl arg_list) with
	|[] -> (
		match command with
		|"show-default-css" -> print_endline Main.default_css
		|_ -> raise (Error "invalid argument(s)")
	)
	|path::options ->
		match command with
		|"txt-of-nmm" -> print_endline (Main.txt_of_nmm options path)
		|"txt-of-xml" -> print_endline (Main.txt_of_axml options path)
		|"xml-of-nmm" -> print_endline (Main.axml_of_nmm path)
		|"check-xml-schema" -> print_endline (Main.check_xml_schema path)
		|"validate-xml" -> print_endline (Main.validate_xml (List.hd options) path)
		|"html-of-nmm" -> print_endline (Main.html_of_nmm (List.rev options) path)
		|"html-of-xml" -> print_endline (Main.html_of_axml (List.rev options) path)
		|"test-with-nmm" -> Test.test_w_nmm_file path
		|"test-with-xml" -> Test.test_w_axml_file path
		|_ -> raise (Error "invalid argument(s)")
with 
|Main.Error e -> Debug_utils.print_to_stderr e
|_ -> Debug_utils.print_to_stderr ("invalid argument(s)" ^ "\n" ^ usage)
