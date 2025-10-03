let rec diff_of_xmls (xml1:Xml.xml) (xml2:Xml.xml):(Xml.xml option*Xml.xml option) list =
	match xml1=xml2 with
	|true -> []
	|false -> (
		match xml1,xml2 with
		|Xml.Element (tag1,attr_list1,xml_list1), Xml.Element (tag2,attr_list2,xml_list2) -> (
			match tag1=tag2, attr_list1=attr_list2 with
			|false,_ -> [(Some xml1, Some xml2)]
			| _,false -> [(Some xml1, Some xml2)]
			|true,true -> (
				let rec aux (list1:Xml.xml list) (list2:Xml.xml list):(Xml.xml option*Xml.xml option) list=
						match list1, list2 with
						|hd1::tl1, hd2::tl2 -> List.concat [(diff_of_xmls hd1 hd2);(aux tl1 tl2)]
						|[],hd2::tl2 -> (None, Some hd2)::(aux [] tl2)
						|hd1::tl1,[] -> (Some hd1, None)::(aux tl1 [])
						|[],[] -> []
				in aux xml_list1 xml_list2
			)
		)
		|Xml.PCData s, Xml.PCData t -> (
			match s=t with
			|false -> [(Some xml1, Some xml2)]
			|true -> []
		)
		|x,y -> [(Some x, Some y)]
	)

let string_of_diff (diff:(Xml.xml option*Xml.xml option) list):string=
	let sep:string="" in
	let map (diff_item:Xml.xml option*Xml.xml option):string=
		match diff_item with
		|(Some xml1, Some xml2) -> String.concat sep ["🡄";Xml_right.to_string xml1;"\n";"🡆";Xml_right.to_string xml2]
		|(Some xml1, None) -> String.concat sep ["🡄";Xml_right.to_string xml1;"\n";"🡆";""]
		|(None, Some xml2) -> String.concat sep ["🡄";"";"\n";"🡆";Xml_right.to_string xml2]
		|(None, None) -> String.concat sep ["🡄";"";"\n";"🡆";""]
	in String.concat "\n\n" (List.map map diff)

let string_of_file (path:string):string =
	let ic = open_in path in
	let s = In_channel.input_all ic in
	let _ = close_in ic in s


let print_to_file (s : string) (filename : string) : unit =
	let oc = open_out filename in
	let _ = output_string oc s in
	let _ = flush oc in
	let _ = close_out oc in ()
