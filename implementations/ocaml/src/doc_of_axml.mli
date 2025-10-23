(** For translating parsed nmm source-code (an abstract syntax tree in the XML-format specified by {{:https://github.com/no-markup-markup/nmm/blob/main/implementations/ocaml/testing/dtd/axml.dtd}axml.dtd}) to an abstract syntax tree in the format specified by {!module:Doc_types}. *)

exception Error of string


val f_tr_doc_of_axml : Xml.xml -> Doc_types.tr_doc
(**
If [axml] is an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml] that is also an instance of the xml-schema {{:https://github.com/no-markup-markup/nmm/blob/main/specification/AST.dtd}AST.dtd}, then 

[f_tr_doc_of_axml axml]

evaluates to an object of type {!type:Doc_types.tr_doc}. Otherwise it raises an [Error].

---

Ideally, if [doc] is an object of type {!type:Doc_types.tr_doc}, then

[f_tr_doc_of_axml (]{!val:Axml_of_doc.axml_of_tr_doc} [ doc)]

should evaluate to [doc].

*)
