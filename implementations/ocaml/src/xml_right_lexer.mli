(** Lexer generated from {{:specs/xml_right_lexer.mll.txt}xml_right_lexer.mll} with ocamllex.
*)

exception ERROR of string

val line_of_lexbuf : Lexing.lexbuf -> string

val token : Lexing.lexbuf -> Xml_right_parser.token
