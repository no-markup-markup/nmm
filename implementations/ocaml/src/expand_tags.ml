
open Doc_types

let expand_tag (tag : Doc_types.ts_tag) : (string * string) option =
match tag with

|Cs_tag "ABBR" -> Some("ABBREVIATION","Abbreviation")

|Cs_tag "ASM" -> Some("ASSUMPTION","Assumption")

|Cs_tag "CONJ" -> Some("CONJECTURE","Conjecture")

|Cs_tag "CONV" -> Some("CONVENTION","Convention")

|Cs_tag "COR" -> Some("COROLLARY","Corollary")

|Cs_tag "DEF" -> Some("DEFINITION","Definition")

|Cs_tag "EX" -> Some("EXAMPLE","Example")

|Cs_tag "FCT" -> Some("FACT","Fact")

|Cs_tag "LMA" -> Some("LEMMA","Lemma")

|Cs_tag "NTN" -> Some("NOTATION","Notation")

|Cs_tag "PRF" -> Some("PROOF","Proof")

|Cs_tag "PRP" -> Some("PROPOSITION","Proposition")

|Cs_tag "QTN" -> Some("QUOTATION","Quotation")

|Cs_tag "RMK" -> Some("REMARK","Remark")

|Cs_tag "THM" -> Some("THEOREM","Theorem")

|Cs_tag "TMY" -> Some("TERMINOLOGY","Terminology")

|Cs_tag "ABBRS" -> Some("ABBBREVIATIONS","Abbbreviations")

|Cs_tag "ASMS" -> Some("ASSUMPTIONS","Assumptions")

|Cs_tag "CONJS" -> Some("CONJECTURES","Conjectures")

|Cs_tag "CONVS" -> Some("CONVENTIONS","Conventions")

|Cs_tag "CORS" -> Some("COROLLARIES","Corollaries")

|Cs_tag "DEFS" -> Some("DEFINITIONS","Definitions")

|Cs_tag "EXS" -> Some("EXAMPLES","Examples")

|Cs_tag "FCTS" -> Some("FACTS","Facts")

|Cs_tag "LMAS" -> Some("LEMMAS","Lemmas")

|Cs_tag "NTNS" -> Some("NOTATIONS","Notations")

|Cs_tag "PRFS" -> Some("PROOFS","Proofs")

|Cs_tag "PRPS" -> Some("PROPOSITIONS","Propositions")

|Cs_tag "QTNS" -> Some("QUOTATIONS","Quotations")

|Cs_tag "RMKS" -> Some("REMARKS","Remarks")

|Cs_tag "THMS" -> Some("THEOREMS","Theorems")



|Cs_tag "PAR"
|Cs_tag "ITM"
|Cs_tag "DSP"
|Cs_tag "BIB" -> None
|Cs_tag s -> let _ : unit = Debug_utils.print_warning ("WARNING: undefined tag: " ^ s) in None

