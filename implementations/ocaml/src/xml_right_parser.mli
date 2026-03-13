(**
LR(1) parser generated from {{:specs/xml_right_parser.mly.txt}xml_right_parser.mly} with ocamlyacc.
*)

type token =
      | EOF
      | PCDATA of string
      | TAG_OPEN of (string * string)
      | TAG_OPEN_CLOSE of (string * string)
      | TAG_CLOSE of string

val main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> Xml_light_types.xml
