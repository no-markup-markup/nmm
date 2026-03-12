(** For translating parsed nmm source-code (an abstract syntax tree in the format specified by {!module:Doc_types}) to an abstract syntax tree in the XML-format specified by {{:specs/axml.dtd.txt}axml.dtd}. *)

val axml_of_tr_doc : Doc_types.tr_doc -> Xml.xml
(**
[axml_of_tr_doc doc] evaluates to an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml] that is also an instance of the xml-schema {{:specs/axml.dtd.txt}axml.dtd}.

Ideally, if [axml] is an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml] that is also an instance of {{:specs/axml.dtd.txt}axml.dtd}, then [axml_of_tr_doc (]{!val:Doc_of_axml.f_tr_doc_of_axml}[ axml)] should evaluate to [axml].

*)
