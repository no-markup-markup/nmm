(**
Lexer used by {!module:Doc_of_nmm} together with {!module:Nmm_parser}. Relies on {{:https://github.com/ocaml-community/sedlex}Sedlex}.
*)

exception ERROR of string

val line_of_lexbuf : Sedlexing.lexbuf -> string

type t_lexer_env = {
        mutable preamble : bool;
        mutable quotation : bool;
        mutable verbatim : bool;
        mutable display : bool;
        mutable nte_counter : int;
        mutable end_of_file : bool;
}

val lexer_env : t_lexer_env

val token : Sedlexing.lexbuf -> Nmm_parser.token


