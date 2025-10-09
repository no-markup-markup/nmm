let expand (s : string) : string option =
	match s with
	|"DEF" -> Some "DEFINITION"
	|"PRF" -> Some "PROOF"
	|"FCT" -> Some "FACT"
	|"LMA" -> Some "LEMMA"
	|"THM" -> Some "THEOREM"
	| _  -> None
