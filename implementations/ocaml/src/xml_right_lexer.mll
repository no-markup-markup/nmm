{
open Xml_right_parser

exception ERROR of string

let line_of_lexbuf (lexbuf:Lexing.lexbuf):string=
	string_of_int (lexbuf.Lexing.lex_start_p).Lexing.pos_lnum

let newlines (s:string) (b:Lexing.lexbuf):unit=
	let rec aux (string_list:string list):unit=
		match string_list with
		|[]->()
		|hd::[]->()
		|hd::tl-> let _=Lexing.new_line b in aux tl
	in
	aux (String.split_on_char '\n' s)
}


let st = [' ' '\t']

let nrst = ['\n' '\r' ' ' '\t']

let xml_declaration = '<' st* '?' [^ '?' '<' '>' '\n' '\r']* '?' st* '>'

let pcdata = [^ '\n' '\r' '<' '>' ]+

let tag = [^ ' ' '\t' '\n' '\r' '&' ';' '<' '>' '\'' '\"' '=' '/']+

let key = tag

let value = '\"' [^ '\n' '\r' '<' '>' '/' '\"']* '\"'

let attr = key '=' value

let attrs = attr (st+ attr)*

let comment = "<!--" [^ '!']* "-->"


rule token = parse
	|'<' st* (tag as s) st* (attrs* as t) st* '>'		{ TAG_OPEN (s,t) }
	|'<' st* (tag as s) st* (attrs* as t) st* '/' st* '>'	{ TAG_OPEN_CLOSE (s,t) }
	|'<' st* '/' st* (tag as s) st* '>'			{ TAG_CLOSE s }
	|pcdata as s						{ PCDATA s }
	|xml_declaration					{ token lexbuf }
	|nrst+ as s						{ let _=newlines s lexbuf in token lexbuf }
	|comment as s						{ let _=newlines s lexbuf in token lexbuf }
	|eof							{ EOF }
	|_							{ raise (ERROR ("unexpected string on line " ^ (line_of_lexbuf lexbuf) ^ ": \"" ^ (Lexing.lexeme lexbuf) ^ "\"")) }


