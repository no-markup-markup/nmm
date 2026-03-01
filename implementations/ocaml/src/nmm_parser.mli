(**
An LR(1) parser of nmm source-code used by {!module:Doc_of_nmm} together with {!module:Nmm_lexer}. Generated from [nmm_parser.mly] with [ocamlyacc].
*)

type token =
      | VRB_LINE_EMPTY
      | VRB_LINE of string
      | TXT of string
      | TITLE of string
      | TAB_TAB_TAB_END_VRB
      | TAB_TAB_END_VRB
      | TAB_END_VRB
      | TAB
      | START_VRB
      | STAR
      | SECTION_SPACES_TAG_OR_ID_NL of string
      | SECTION_REFS_NLS
      | SECTION_NL
      | SECTION
      | RBR
      | PREAMBLE of string
      | PILCROW_SPACES_TAG_OR_ID_NL of string
      | PILCROW_SPACES_RPT_SPACES_ID_NL of string
      | PILCROW_REFS_NLS
      | PILCROW_NL
      | PILCROW
      | NL_TAB_TAB_TAB
      | NL_TAB_TAB
      | NL_TAB
      | NL
      | LBR
      | ITM_CUSTOM_TAB_ID of string
      | ITM_CUSTOM_TAB of string
      | ITM_AUTO_TAB_ID of string
      | ITM_AUTO_TAB
      | ESC_CHAR of string
      | EOF
      | END_VRB
      | DSP_ID of string
      | DSP_CUSTOM_TAB of string
      | DSP_AUTO_TAB
      | DASH_TAB
      | C_REF of string
      | COLON
      | CH_TAG_OR_ID_NL of string
      | AUTHOR of string
      | ABSTRACT of string

exception Error of int

val main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> Doc_types.tr_doc

