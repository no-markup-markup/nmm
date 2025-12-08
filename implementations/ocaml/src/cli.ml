exception Error of string

let usage : string=
"USAGE:
nmm-ocaml [
  | txt-of-xml [ <txt-options> ] { <path-to-xml-file> | - }
  | html-of-xml [ <html-options> ] { <path-to-xml-file> | - }
  | xml-of-nmm <path-to-nmm-file>
  | txt-of-nmm [ <txt-options> ] <path-to-nmm-file>
  | html-of-nmm [ <html-options> ] <path-to-nmm-file>
  | check-xml-schema <path-to-dtd-file>
  | validate-xml <path-to-dtd-file> { <path-to-xml-file> | - }
  | show-default-css
]

In cases where '-' can be supplied instead of a path,
the program reads from standard input.

TXT-OPTIONS:
  --margin <numeral>
  --preserve-vertical-white-space

HTML-OPTIONS:
  --margin <numeral>
  --preserve-vertical-white-space
  --lang <language-code>
  --css <uri>
"

type t_keyspecdoc = (Arg.key *  Arg.spec * Arg.doc)

let rec anon_arg_fun arg : unit =
	match anon_arg_count.contents with
	|0 ->
		let _ : unit =
		match arg with
		|"txt-of-xml" -> keyspecdoc_list.contents <- keyspecdoc_list_txt_of_xml
		|"test-with-xml"
		|"html-of-xml" -> keyspecdoc_list.contents <- keyspecdoc_list_html_of_xml
		|"xml-of-nmm" -> ()
		|"txt-of-nmm" -> keyspecdoc_list.contents <- keyspecdoc_list_txt_of_nmm
		|"test-with-nmm"
		|"html-of-nmm" -> keyspecdoc_list.contents <- keyspecdoc_list_html_of_nmm
		|"check-xml-schema" -> ()
		|"validate-xml" -> ()
		|"show-default-css" -> ()
		|_ -> raise (Error (String.concat " " ["unknown command:";arg]))
		in
		let _ : unit = cmd_name.contents <- arg
		in anon_arg_count.contents <- (anon_arg_count.contents + 1)

	|1 ->
		let _ : unit =
		match cmd_name.contents with
		|"txt-of-xml" -> path_to_xml_file.contents <- arg
		|"test-with-xml"
		|"html-of-xml" -> path_to_xml_file.contents <- arg
		|"xml-of-nmm" -> path_to_nmm_file.contents <- arg
		|"txt-of-nmm" -> path_to_nmm_file.contents <- arg
		|"test-with-nmm"
		|"html-of-nmm" -> path_to_nmm_file.contents <- arg
		|"check-xml-schema" -> path_to_dtd_file.contents <- arg
		|"validate-xml" -> path_to_dtd_file.contents <- arg
		|"show-default-css" -> raise (Error (String.concat " " ["one too many arguments:";arg]))
		|_ -> raise (Error (String.concat " " ["unknown command:";cmd_name.contents]))
		in anon_arg_count.contents <- (anon_arg_count.contents + 1)
	|2 -> 
		let _ : unit =
		match cmd_name.contents with
		|"txt-of-xml"
		|"test-with-xml"
		|"html-of-xml"
		|"xml-of-nmm"
		|"txt-of-nmm"
		|"test-with-nmm"
		|"html-of-nmm"
		|"check-xml-schema" -> raise (Error (String.concat " " ["one too many arguments:";arg]))
		|"validate-xml" -> path_to_xml_file.contents <- arg
		|"" -> raise (Error "missing sub-command")
		|_ -> raise (Error (String.concat " " ["unknown command:";cmd_name.contents]))
		in anon_arg_count.contents <- (anon_arg_count.contents + 1)
	|_ -> raise (Error (String.concat " " ["one too many arguments:";arg]))

and cmd_name : string ref = ref ""

and path_to_nmm_file: string ref = ref ""

and path_to_xml_file: string ref = ref ""

and path_to_dtd_file: string ref = ref ""

and anon_arg_count : int ref = ref 0

and margin : string ref = ref ""

and preserve : bool ref = ref false

and lang : string ref = ref "en"

and css : string ref = ref ""

and read_from_stdin : bool ref = ref false

and keyspecdoc_list : t_keyspecdoc list ref =ref []

and keyspecdoc_margin : t_keyspecdoc =
	("--margin", Arg.Set_string margin, "Set left margin")

and keyspecdoc_preserve : t_keyspecdoc =
	("--preserve-vertical-white-space", Arg.Set preserve, "Preserve vertical white-space following blocks on level 0")

and keyspecdoc_lang : t_keyspecdoc =
	("--lang", Arg.Set_string lang, "Set html language attribute")

and keyspecdoc_css : t_keyspecdoc =
	("--css", Arg.Set_string css, "Set uri of external stylesheet")

and keyspecdoc_stdin : t_keyspecdoc =
	("-", Arg.Set read_from_stdin, "Read from standard input")


and keyspecdoc_list_txt_of_nmm : t_keyspecdoc list = [
	keyspecdoc_margin;
	keyspecdoc_preserve;
]

and keyspecdoc_list_txt_of_xml : t_keyspecdoc list = [
	keyspecdoc_margin;
	keyspecdoc_preserve;
	keyspecdoc_stdin;
]

and keyspecdoc_list_html_of_nmm : t_keyspecdoc list = [
	keyspecdoc_margin;
	keyspecdoc_preserve;
	keyspecdoc_lang;
	keyspecdoc_css;
]

and keyspecdoc_list_html_of_xml : t_keyspecdoc list = [
	keyspecdoc_margin;
	keyspecdoc_preserve;
	keyspecdoc_stdin;
	keyspecdoc_lang;
	keyspecdoc_css;
]


let _ : unit = 
	let _ : unit = Arg.parse_dynamic keyspecdoc_list anon_arg_fun usage in
	let margin_options : string list =
		match margin.contents with
		|"" -> []
		|some_margin -> ["--margin";some_margin]
	in
	let preserve_options : string list =
	match preserve.contents with
		|false -> []
		|true -> ["--preserve-vertical-white-space"]
	in
	let lang_options : string list =
		match lang.contents with
		|"" -> []
		|lang_code -> ["--lang";lang_code]
	in
	let css_options : string list =
		match css.contents with
		|"" -> []
		|uri -> ["--css";uri]
	in
	let options = List.concat [margin_options;preserve_options;lang_options;css_options] in
	match cmd_name.contents with
	|"txt-of-xml" -> (
		match read_from_stdin.contents with
		|true -> print_endline (Main.txt_of_axml options "-")
		|false -> print_endline (Main.txt_of_axml options path_to_xml_file.contents)
	)
	|"html-of-xml" -> (
		match read_from_stdin.contents with
		|true -> print_endline (Main.html_of_axml options "-")
		|false -> print_endline (Main.html_of_axml options path_to_xml_file.contents)
	)
	|"xml-of-nmm" -> print_endline (Main.axml_of_nmm path_to_nmm_file.contents)
	|"txt-of-nmm" -> print_endline (Main.txt_of_nmm options path_to_nmm_file.contents)
	|"html-of-nmm" -> print_endline (Main.html_of_nmm options path_to_nmm_file.contents)
	|"check-xml-schema" -> print_endline (Main.check_xml_schema path_to_dtd_file.contents)
	|"validate-xml" -> print_endline (Main.validate_xml path_to_dtd_file.contents path_to_xml_file.contents)
	|"show-default-css" -> print_endline Main.default_css
	|"test-with-xml" -> Test.test_with_axml_file options path_to_xml_file.contents
	|"test-with-nmm" -> Test.test_with_nmm_file options path_to_nmm_file.contents
	|_ -> raise (Error "missing sub-command")


