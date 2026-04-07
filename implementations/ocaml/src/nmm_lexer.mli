(**
Lexer used by {!module:Doc_of_nmm} together with {!module:Nmm_parser}. Relies on {{:https://github.com/ocaml-community/sedlex}Sedlex}.
*)

exception ERROR of string

val line_of_lexbuf : Sedlexing.lexbuf -> string

val return_nl : bool ref

val verbatim : bool ref

val first_nl : bool ref

val display : bool ref

val ftn_counter : int ref

val token : Sedlexing.lexbuf -> Nmm_parser.token


