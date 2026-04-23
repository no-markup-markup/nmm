let quiet : bool ref = ref false

let string_of_file (path:string):string =
        let ic = open_in path in
        let s = In_channel.input_all ic in
        let _ = close_in ic in s


let print_to_file (s : string) (path : string) : unit =
        let oc = open_out path in
        let _ = output_string oc (s ^ "\n") in
        let _ = flush oc in
        let _ = close_out oc in ()

let print_to_stderr (s:string):unit = 
        Printf.eprintf "\027[31m%s\027[m\n" s


let print_warning (s:string):unit =
        if quiet.contents then () else Printf.eprintf "\027[33m%s\027[m\n" s

