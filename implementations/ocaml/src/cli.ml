exception Error of string

let usage : string=
"Usage:

nmm-ocaml {

 | txt-of-xml { <path-to-xml-file> | - }
 | html-of-xml { <URI-of-css-file> | none } { <language-code> | none } { <path-to-xml-file> | - }

 | xml-of-nmm <path-to-nmm-file>

 | txt-of-nmm <path-to-nmm-file>
 | html-of-nmm { <URI-of-css-file> | none } { <language-code> | none } <path-to-nmm-file>

 | check-xml-schema <path-to-dtd-file>
 | validate-xml <path-to-dtd-file> { <path-to-xml-file> | - }

 | show-default-css

}

In cases where '-' can be supplied instead of a path, the program reads from stdin."


let argv=Sys.argv

let _ : unit =
try 
	match Array.length argv with
	|2 -> (
		match argv.(1) with
		|"show-default-css" -> print_endline Main.default_css
		|_ -> raise (Error "invalid argument(s)")
	)
	|3 -> (
		match argv.(1),argv.(2) with
		|"txt-of-nmm", path -> print_endline (Main.txt_of_nmm path)
		|"txt-of-xml", path -> print_endline (Main.txt_of_axml path)
		|"xml-of-nmm", path -> print_endline (Main.axml_of_nmm path)
		|"check-xml-schema", path -> print_endline (Main.check_xml_schema path)
		|"test-with-nmm", basename -> Test.test_w_nmm_file basename
		|"test-with-xml", basename -> Test.test_w_axml_file basename
		|_ -> raise (Error "invalid argument(s)")
	)
	|4 -> (
		match argv.(1),argv.(2),argv.(3) with
		|"validate-xml", path_to_dtd, path_to_xml -> print_endline (Main.validate_xml path_to_dtd path_to_xml)
		|_ -> raise (Error "invalid argument(s)")
	)
	|5 -> (
		match argv.(1),argv.(2),argv.(3),argv.(4) with
		|"html-of-nmm", "none", "none", path -> print_endline (Main.html_of_nmm None None path)
		|"html-of-nmm", "none", lang, path -> print_endline (Main.html_of_nmm None (Some lang) path)
		|"html-of-nmm", uri, "none", path -> print_endline (Main.html_of_nmm (Some uri) None path)
		|"html-of-nmm", uri, lang, path -> print_endline (Main.html_of_nmm (Some uri) (Some lang) path)
		|"html-of-xml", "none", "none", path -> print_endline Main.(html_of_axml None None path)
		|"html-of-xml", "none", lang, path -> print_endline (Main.html_of_axml None (Some lang) path)
		|"html-of-xml", uri, "none", path -> print_endline (Main.html_of_axml (Some uri) None path)
		|"html-of-xml", uri, lang, path -> print_endline (Main.html_of_axml (Some uri) (Some lang) path)
		|_ -> raise (Error "invalid argument(s)")
	)
	|_ -> raise (Error "invalid argument(s)")
with 
|Error "invalid argument(s)" -> Debug_utils.print_to_stderr ("invalid argument(s)" ^ "\n" ^ usage)
|Main.Error e -> Debug_utils.print_to_stderr e
