(**
An LR(1) parser of nmm source-code used by {!module:Doc_of_nmm} together with {!module:Nmm_lexer}.
Generated from {{:specs/nmm_parser.mly.txt}nmm_parser.mly} with ocamlyacc.
*)

type token = 
        |STAR
        |LBR
        |RBR
        |COLON
        |PILCROW
        |SECTION
        |EOF
        |NL
        |TAB
        |NL_TAB
        |NL_TAB_TAB
        |NL_TAB_TAB_TAB
        |DASH_TAB
        |STAR_TAB
        |ITM_AUTO_TAB
        |DSP_AUTO_TAB
        |PILCROW_NL
        |SECTION_NL
        |SECTION_REFS_NLS
        |PILCROW_REFS_NLS
        |START_VRB
        |VRB_LINE_EMPTY
        |END_VRB
        |TAB_END_VRB
        |TAB_TAB_END_VRB
        |TAB_TAB_TAB_END_VRB
        |PREAMBLE
        |TITLE
        |AUTHOR
        |DATE
        |ABSTRACT
        |VRB_LINE of string
        |ESC_CHAR of string
        |TXT of string
        |C_REF of string
        |DSP_ID of string
        |CH_TAG_OR_ID_NL of string
        |SECTION_SPACES_TAG_OR_ID_NL of string
        |PILCROW_SPACES_TAG_OR_ID_NL of string
        |PILCROW_SPACES_RPT_SPACES_ID_NL of string
        |ITM_CUSTOM_TAB of string
        |DSP_CUSTOM_TAB of string
        |ITM_AUTO_TAB_ID of string
        |ITM_CUSTOM_TAB_ID of string
        |STAR_TAB_ID of string
        |FTN_REF of (string * int)

val main : (Stdlib.Lexing.lexbuf -> token) -> Stdlib.Lexing.lexbuf -> Doc_types.tr_doc
