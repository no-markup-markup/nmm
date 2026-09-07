(**
For testing various properties of {!module:Xml_right}, {!module:Axml_of_doc}, and {!module:Doc_of_axml}.
*)


exception Error of string

val test_with_axml_file : Common_utils.t_exml_options -> string -> unit
val test_with_nmm_file : Common_utils.t_exml_options -> string -> unit
