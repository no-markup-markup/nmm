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
                        let _ = Debug_utils.print_to_stderr ("Xml_right failed, read the following tokens from string:") in
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
                let _ = Debug_utils.print_to_stderr ("Xml_right failed, read the following tokens from standard input:") in
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
                                match contains_text xml_list with
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

and contains_text (xml_list:Xml.xml list):bool =
        match xml_list with
        |[] -> false
        |hd::tl -> 
                match hd with
                |Xml.Element ("a",_,_)
                |Xml.Element ("em",_,_)
                |Xml.PCData _ -> true
                |_ -> contains_text tl

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



(* for debugging purposes *)

let rec diff_of_xmls (xml1:Xml.xml) (xml2:Xml.xml):(Xml.xml option*Xml.xml option) list =
        match xml1=xml2 with
        |true -> []
        |false -> (
                match xml1,xml2 with
                |Xml.Element (tag1,attr_list1,xml_list1), Xml.Element (tag2,attr_list2,xml_list2) -> (
                        match tag1=tag2, attr_list1=attr_list2 with
                        |false,_ -> [(Some xml1, Some xml2)]
                        | _,false -> [(Some xml1, Some xml2)]
                        |true,true -> (
                                let rec aux (list1:Xml.xml list) (list2:Xml.xml list):(Xml.xml option*Xml.xml option) list=
                                                match list1, list2 with
                                                |hd1::tl1, hd2::tl2 -> List.concat [(diff_of_xmls hd1 hd2);(aux tl1 tl2)]
                                                |[],hd2::tl2 -> (None, Some hd2)::(aux [] tl2)
                                                |hd1::tl1,[] -> (Some hd1, None)::(aux tl1 [])
                                                |[],[] -> []
                                in aux xml_list1 xml_list2
                        )
                )
                |Xml.PCData s, Xml.PCData t -> (
                        match s=t with
                        |false -> [(Some xml1, Some xml2)]
                        |true -> []
                )
                |x,y -> [(Some x, Some y)]
        )

let string_of_diff (diff:(Xml.xml option*Xml.xml option) list):string=
        let sep:string="" in
        let map (diff_item:Xml.xml option*Xml.xml option):string=
                match diff_item with
                |(Some xml1, Some xml2) -> String.concat sep ["🡄";to_string xml1;"\n";"🡆";to_string xml2]
                |(Some xml1, None) -> String.concat sep ["🡄";to_string xml1;"\n";"🡆";""]
                |(None, Some xml2) -> String.concat sep ["🡄";"";"\n";"🡆";to_string xml2]
                |(None, None) -> String.concat sep ["🡄";"";"\n";"🡆";""]
        in String.concat "\n\n" (List.map map diff)


let xml_diff (xml1 : Xml.xml) (xml2 : Xml.xml) : string =
        string_of_diff (diff_of_xmls xml1 xml2)

let xml_diff_of_files (path1 : string) (path2 : string) : string =
        let xml1 : Xml.xml = parse_file false path1 in
        let xml2 : Xml.xml = parse_file false path2 in
        xml_diff xml1 xml2
