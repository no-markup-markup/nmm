val axml_of_tr_doc : Doc_types.tr_doc -> Xml.xml
(**
{[axml_of_tr_doc doc]}
evaluates to an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml] that is also an instance of the xml-schema {{:https://github.com/no-markup-markup/nmm/blob/main/specification/AST.dtd}AST.dtd}.

---

Ideally, if [axml] is an object of the {{:https://github.com/ncannasse/xml-light}Xml-light} type [Xml.xml] that is also an instance of {{:https://github.com/no-markup-markup/nmm/blob/main/specification/AST.dtd}AST.dtd}, then

[axml_of_tr_doc (] {!val:Doc_of_axml.f_tr_doc_of_axml} [ axml)]

should evaluate to [axml].

*)
