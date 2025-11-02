exception Error of string

let string_of_token (t:Xml_right_parser.token):string =
	match t with
	|Xml_right_parser.EOF -> "EOF"
	|Xml_right_parser.PCDATA s -> String.concat "" ["PCDATA";" ";"\'";s;"\'"]
	|Xml_right_parser.TAG_OPEN (x,y) -> String.concat "" ["TAG_OPEN";" ";"\'";x;"'";" ";"\'";y;"\'"]
	|Xml_right_parser.TAG_OPEN_CLOSE (x,y) -> String.concat "" ["TAG_OPEN_CLOSE";" ";"\'";x;"\'";" ";"\'";y;"\'"]
	|Xml_right_parser.TAG_CLOSE s -> String.concat "" ["TAG_CLOSE";" ";"\'";s;"\'"]

let lexer (print_tokens:bool) (b:Lexing.lexbuf):Xml_right_parser.token=
	let t:Xml_right_parser.token=Xml_right_lexer.token b in
	match print_tokens with
	|true -> let _ = Debug_utils.print_to_stderr ("Line " ^ (Xml_right_lexer.line_of_lexbuf b) ^ ": " ^ (string_of_token t)) in t
	|false -> t

let rec parse_file (print_tokens:bool) (s:string):Xml.xml =
	match Sys.file_exists s with
	|false -> raise (Error ("cannot read from " ^ s ^ ": No such file"))
	|true -> 
	try
		let ic=open_in s in
		let lexbuf=Lexing.from_channel ic in
		let parse=Xml_right_parser.main (lexer print_tokens) in
		let result=parse lexbuf in
		let _=close_in ic in result
	with
	|_ ->
		match print_tokens with
		|false -> 
			let _ = Debug_utils.print_to_stderr ("Xml_right failed, read the following tokens from " ^ s ^ ":") in
			parse_file true s
		|true -> raise (Error "parsing failed")


let rec parse_string (print_tokens:bool) (s:string):Xml.xml =
	try
		let lexbuf = Lexing.from_string s in
		let parse = Xml_right_parser.main (lexer print_tokens) in
		parse lexbuf
	with
	|_ ->
		match print_tokens with
		|false -> 
			let _ = Debug_utils.print_to_stderr ("Xml_right failed, read the following tokens from \"" ^ s ^ "\":") in
			parse_string true s
		|true -> raise (Error "parsing failed")


let parse_stdin (print_tokens:bool):Xml.xml =
	let input : string = In_channel.input_all stdin in
	try
		let lexbuf = Lexing.from_string input in
		let parse = Xml_right_parser.main (lexer print_tokens) in
		parse lexbuf
	with
	|_ ->
		let _ = Debug_utils.print_to_stderr ("Xml_right failed, read the following tokens from stdin:") in
		let print_tokens =  true in
		let lexbuf = Lexing.from_string input in
		let parse = Xml_right_parser.main (lexer print_tokens) in
		parse lexbuf


let rec to_string_fmt (xml:Xml.xml):string=
	string_of_xml true xml

and to_string (xml:Xml.xml):string=
	string_of_xml false xml

and string_of_xml (fmt:bool) (xml:Xml.xml):string =
	match xml with
	|Xml.Element ((tag_name:string),(attr_list:(string*string) list),(xml_list:Xml.xml list)) -> (
		let sep:string = 
			match fmt with
			|false -> ""
			|true ->
				match contains_pcdata xml_list with
				|true -> ""
				|false -> "\n"
		in
		match xml_list with
		|[] -> string_of_tag_open_close tag_name (string_of_attr_list attr_list)
		|_ ->
			String.concat sep [
				string_of_tag_open tag_name (string_of_attr_list attr_list);
				String.concat sep (List.map (string_of_xml fmt) xml_list);
				string_of_tag_close tag_name;
			]
	)
	|Xml.PCData (s:string) -> s

and contains_pcdata (xml_list:Xml.xml list):bool =
	match xml_list with
	|[] -> false
	|hd::tl -> 
		match hd with
		|Xml.PCData _ -> true
		|_ -> contains_pcdata tl

and string_of_tag_open (tag_name:string) (attrs:string):string =
	String.concat "" ["<";tag_name;attrs;">"]

and string_of_tag_close (tag_name:string):string =
	String.concat "" ["</";tag_name;">"]

and string_of_attr_list (attr_list:(string*string) list):string =
	match String.concat " " (List.map string_of_key_value_pair attr_list) with
	|""->""
	|x -> (" " ^ x)

and string_of_key_value_pair (key_value_pair:string*string):string =
	match key_value_pair with
	|(key,value) -> String.concat "" [key;"=";"\"";value;"\""]

and string_of_tag_open_close (tag_name:string) (attrs:string):string =
	String.concat "" ["<";tag_name;attrs;"/>"]




