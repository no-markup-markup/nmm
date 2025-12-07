exception Error of string

let usage : string=
"USAGE:

nmm-ocaml [

  | txt-of-xml  [ <options> ] { <path-to-xml-file> | - }
  | html-of-xml [ <options> ] { <path-to-xml-file> | - }

  | xml-of-nmm  <path-to-nmm-file>

  | txt-of-nmm  [ <options> ] <path-to-nmm-file>
  | html-of-nmm [ <options> ] <path-to-nmm-file>

  | check-xml-schema <path-to-dtd-file>
  | validate-xml     <path-to-dtd-file> { <path-to-xml-file> | - }

  | show-default-css

]

In cases where '-' can be supplied instead of a path, the program reads from stdin.

OPTIONS:

  --margin <non-negative-integer>

  --preserve-vertical-white-space

  The following options have no effect when combined with txt-of-xml or txt-of-nmm:

  --lang <language-code>

  --external-css <uri>
"


let _ : unit =
(*try*)
	let argv_array : string array = Sys.argv in
	let argv_list : string list = Array.to_list argv_array in
	match argv_list with
	|_::arg_list -> (
		match arg_list with
		|[] -> Debug_utils.print_to_stderr usage
		|"show-default-css"::[] ->  print_endline Main.default_css
		|"check-xml-schema"::[path_dtd] -> print_endline (Main.check_xml_schema path_dtd)
		|"validate-xml"::[path_dtd;path_xml] -> print_endline (Main.validate_xml path_dtd path_xml)
		|command::tl -> (
			match List.rev tl with
			|path::rev_options -> (
				let options = (List.rev rev_options) in
				match command with
				|"txt-of-nmm" -> print_endline (Main.txt_of_nmm options path)
				|"txt-of-xml" -> print_endline (Main.txt_of_axml options path)
				|"xml-of-nmm" -> print_endline (Main.axml_of_nmm path)
				|"html-of-nmm" -> print_endline (Main.html_of_nmm options path)
				|"html-of-xml" -> print_endline (Main.html_of_axml options path)
				|"test-with-nmm" -> Test.test_with_nmm_file options path
				|"test-with-xml" -> Test.test_with_axml_file options path
				|_ -> raise (Error (String.concat " " ["invalid argument:"; command]))
			)
			|[] -> raise (Error (String.concat " " ["missing operand after"; command]))
		)
	)
	|[] -> raise (Error "missing arguments")
(*
with 
|Test.Error e
|Main.Error e
|Error e -> Debug_utils.print_to_stderr e
*)
