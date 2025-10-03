%{

exception Error of string

let string_of_predefined_entity (s:string):string=
	match s with
	| "&lt;" -> "<"
	| "&gt;" -> ">"
	| "&amp;" -> "&"
	| "&apos;" -> "'"
	| "&quot;" -> "\""
	| _ -> s

let first (pair:'a*'a):'a =
	match pair with
	|(x,_) -> x

let second (pair:'a*'a):'a =
	match pair with
	|(_,y) -> y

let attr_list_of_string (s:string):(string*string) list=
	match s with
	|""->[]
	|_->
		let str_list:string list=String.split_on_char '\"' s in
		let trimmed_str_list:string list=List.map String.trim str_list in
		let rec pair (x:string list):(string*string) list = (
			match x with
			|[] | [""] -> []
			|a::(b::tl) -> ((String.concat "" (String.split_on_char '=' a),b)::(pair tl))
			|_ -> raise (Error (String.concat "%" trimmed_str_list))
		)
		in pair trimmed_str_list

%}

%token				EOF
%token <string>			NON_SPECIAL_DATA
%token <string>			SPECIAL_DATA
%token <string>			PREDEFINED_ENTITY
%token <string*string>		TAG_OPEN
%token <string*string>		TAG_OPEN_CLOSE
%token <string>			TAG_CLOSE

%start main
%type <Xml.xml> main

%%
main:
	|TAG_OPEN xml_list TAG_CLOSE EOF	{ Xml.Element (first $1, attr_list_of_string (second $1), $2) }
	|TAG_OPEN_CLOSE	EOF			{ Xml.Element (first $1, attr_list_of_string (second $1),[]) }
	|TAG_OPEN TAG_CLOSE EOF			{ Xml.Element (first $1, attr_list_of_string (second $1),[]) }
;

xml_list:
	|xml					{ $1::[] }
	|xml xml_list				{ $1::$2 }
;

xml:
	|data					{ Xml.PCData $1 }
	|TAG_OPEN xml_list TAG_CLOSE		{ Xml.Element (first $1, attr_list_of_string (second $1), $2) }
	|TAG_OPEN_CLOSE				{ Xml.Element (first $1, attr_list_of_string (second $1),[]) }
	|TAG_OPEN TAG_CLOSE			{ Xml.Element (first $1, attr_list_of_string (second $1),[]) }
;

data:
	|NON_SPECIAL_DATA			{ $1:string }
	|SPECIAL_DATA				{ $1:string }
	|PREDEFINED_ENTITY			{ (string_of_predefined_entity $1):string }
;

