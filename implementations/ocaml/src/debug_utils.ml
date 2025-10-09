let string_of_file (path:string):string =
	let ic = open_in path in
	let s = In_channel.input_all ic in
	let _ = close_in ic in s


let print_to_file (s : string) (path : string) : unit =
	let oc = open_out path in
	let _ = output_string oc s in
	let _ = flush oc in
	let _ = close_out oc in ()

let print_to_stderr (s:string):unit = 
	Printf.eprintf "%s\n" s
