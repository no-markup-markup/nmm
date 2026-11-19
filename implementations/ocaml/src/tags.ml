open Doc_types

(* tag strings default and standard *)


let tag_strings_default : string list =
  [ "ABBR" ; "ABBRS" ; "ASM" ; "ASMS" ; "CONJ" ; "CONJS" ; "CONV" ; "CONVS" ;
    "COR" ; "CORS" ; "DEF" ; "DEFS" ; "EX" ; "EXS" ; "FCT" ; "FCTS" ; "LMA" ;
    "LMAS" ; "NTN" ; "NTNS" ; "PRF" ; "PRFS" ; "PRP" ; "PRPS" ; "QTN" ; "QTNS" ;
    "RMK" ; "RMKS" ; "SLN" ; "SLNS" ; "THM" ; "THMS" ; "TMY" ]

let tag_strings_standard : string list =
  [ "CH"; "SEC"; "APP"; "PAR"; "ITM"; "DSP"; "BIB"; "NTE" ]

let tag_strings_standard_blk_itm : string list = [ "ITM"; "BIB" ]

(* default expander *)

let expand_tag_default (tag : Doc_types.ts_tag) : (string * string) option =
  match tag with
  | Cs_tag "ABBR" -> Some ("ABBREVIATION", "Abbreviation")
  | Cs_tag "ASM" -> Some ("ASSUMPTION", "Assumption")
  | Cs_tag "CONJ" -> Some ("CONJECTURE", "Conjecture")
  | Cs_tag "CONV" -> Some ("CONVENTION", "Convention")
  | Cs_tag "COR" -> Some ("COROLLARY", "Corollary")
  | Cs_tag "DEF" -> Some ("DEFINITION", "Definition")
  | Cs_tag "EX" -> Some ("EXAMPLE", "Example")
  | Cs_tag "FCT" -> Some ("FACT", "Fact")
  | Cs_tag "LMA" -> Some ("LEMMA", "Lemma")
  | Cs_tag "NTN" -> Some ("NOTATION", "Notation")
  | Cs_tag "PRF" -> Some ("PROOF", "Proof")
  | Cs_tag "PRP" -> Some ("PROPOSITION", "Proposition")
  | Cs_tag "QTN" -> Some ("QUOTATION", "Quotation")
  | Cs_tag "RMK" -> Some ("REMARK", "Remark")
  | Cs_tag "SLN" -> Some ("SOLUTION", "Solution")
  | Cs_tag "THM" -> Some ("THEOREM", "Theorem")
  | Cs_tag "TMY" -> Some ("TERMINOLOGY", "Terminology")
  | Cs_tag "ABBRS" -> Some ("ABBBREVIATIONS", "Abbbreviations")
  | Cs_tag "ASMS" -> Some ("ASSUMPTIONS", "Assumptions")
  | Cs_tag "CONJS" -> Some ("CONJECTURES", "Conjectures")
  | Cs_tag "CONVS" -> Some ("CONVENTIONS", "Conventions")
  | Cs_tag "CORS" -> Some ("COROLLARIES", "Corollaries")
  | Cs_tag "DEFS" -> Some ("DEFINITIONS", "Definitions")
  | Cs_tag "EXS" -> Some ("EXAMPLES", "Examples")
  | Cs_tag "FCTS" -> Some ("FACTS", "Facts")
  | Cs_tag "LMAS" -> Some ("LEMMAS", "Lemmas")
  | Cs_tag "NTNS" -> Some ("NOTATIONS", "Notations")
  | Cs_tag "PRFS" -> Some ("PROOFS", "Proofs")
  | Cs_tag "PRPS" -> Some ("PROPOSITIONS", "Propositions")
  | Cs_tag "QTNS" -> Some ("QUOTATIONS", "Quotations")
  | Cs_tag "RMKS" -> Some ("REMARKS", "Remarks")
  | Cs_tag "SLNS" -> Some ("SOLUTIONS", "Solutions")
  | Cs_tag "THMS" -> Some ("THEOREMS", "Theorems")
  | Cs_tag tag_string ->
      let _ : unit =
        if List.mem tag_string tag_strings_standard then () else
        IO.print_warning ("WARNING: undefined tag: " ^ tag_string)
      in
      None

(* custom expander *)

let expander_of_file (path : string) :
    Doc_types.ts_tag -> (string * string) option =
  let file_string = IO.string_of_file path in
  let lines = String.split_on_char '\n' file_string in
  let rec collect_tags_singular (line_list : string list)
      (acc : (string * string * string) list) =
    match line_list with
    | [] -> acc
    | hd :: tl -> (
        match String.split_on_char '\t' hd with
        | "" :: _ -> collect_tags_singular tl acc
        | singular :: _ :: exp_ref :: exp_lbl :: _ ->
            collect_tags_singular tl ((singular, exp_lbl, exp_ref) :: acc)
        | _ -> collect_tags_singular tl acc)
  in
  let tag_list_singular : (string * string * string) list =
    collect_tags_singular lines []
  in
  let rec collect_tags_plural (line_list : string list)
      (acc : (string * string * string) list) =
    match line_list with
    | [] -> acc
    | hd :: tl -> (
        match String.split_on_char '\t' hd with
        | _ :: "" :: _ -> collect_tags_plural tl acc
        | _ :: plural :: _ :: _ :: exp_ref :: exp_lbl :: _ ->
            collect_tags_plural tl ((plural, exp_lbl, exp_ref) :: acc)
        | _ -> collect_tags_plural tl acc)
  in
  let tag_list : (string * string * string) list =
    collect_tags_plural lines tag_list_singular
  in
  let rec match_tag_rec (tag_string : string)
      (lst : (string * string * string) list) : (string * string) option =
    match lst with
    | [] ->
        let _ : unit =
          IO.print_warning ("WARNING: undefined tag: " ^ tag_string)
        in
        None
    | (tag, exp_lbl, exp_ref) :: tl ->
        if tag = tag_string then Some (exp_lbl, exp_ref)
        else match_tag_rec tag_string tl
  in
  let expand_tag (tag : Doc_types.ts_tag) : (string * string) option =
    match tag with Cs_tag tag_string ->
      if List.mem tag_string tag_strings_standard then None
      else match_tag_rec tag_string tag_list
  in
  expand_tag

(* custom tags *)

let tag_strings_of_file (path : string) : string list =
  let file_string = IO.string_of_file path in
  let lines = String.split_on_char '\n' file_string in
  let rec collect_tags (line_list : string list) (acc : string list) =
    match line_list with
    | [] -> acc
    | hd :: tl -> (
        match String.split_on_char '\t' hd with
        | "" :: "" :: _ -> collect_tags tl acc
        | singular :: "" :: _ -> collect_tags tl (singular :: acc)
        | "" :: plural :: _ -> collect_tags tl (plural :: acc)
        | singular :: plural :: _ -> collect_tags tl (singular :: plural :: acc)
        | "" :: [] -> collect_tags tl acc
        | singular :: [] -> collect_tags tl (singular :: acc)
        | [] -> collect_tags tl acc)
  in
  collect_tags lines []

(* blk_itm *)

let string_of_id (id : tr_id) : string =
  match id.fld_id_tag, id.fld_id_name with
  | Cs_tag tag_string, Cs_name name_string ->
    String.concat "" [tag_string;":";name_string]

let string_of_tag_or_id (tag_or_id) : string =
  match tag_or_id with
  | Cu_tag_or_id_id id -> string_of_id id
  | Cu_tag_or_id_tag (Cs_tag tag_string) -> tag_string

let txt_line_of_tag_or_id (tag_or_id : tu_tag_or_id) : ts_txt_line =
  let tag_or_id_string = string_of_tag_or_id tag_or_id in
  Cs_txt_line
    (Cs_txt_units
      [
        Cu_txt_unit_wysiwyg
          (Cs_txt_unit_wysiwyg tag_or_id_string);
      ]
    )

let tag_string_of_tag_or_id (tag_or_id : tu_tag_or_id) : string =
  match tag_or_id with
  | Cu_tag_or_id_id id -> (
      match id.fld_id_tag with
        | Cs_tag tag_string -> tag_string
  )
  | Cu_tag_or_id_tag tag ->
      match tag with
      | Cs_tag tag_string -> tag_string


let tag_blk_itm_gen (tag_of_string : string -> ts_tag option)
    (blk_itm : Doc_types.tr_blk_itm) : Doc_types.tr_blk_itm =
  match blk_itm.fld_blk_itm_tag_or_id with
  | Some tag_or_id -> (
      let tag_string : string =
        tag_string_of_tag_or_id tag_or_id
      in
      match tag_of_string tag_string with
      | Some _ -> blk_itm
      | None ->
          match blk_itm.fld_blk_itm_main with
          | Cs_blks (blk_list : tu_blk list) ->
            match blk_list with
            | [] -> blk_itm
            | blk_list_hd :: blk_list_tl -> (
                match blk_list_hd with
                | Cu_blk_txt blk_txt -> (
                    match blk_txt with
                    | Cs_blk_txt txt_lines ->
                        match txt_lines with
                        | Cs_txt_lines txt_line_list ->
                            {
                              fld_blk_itm_lbl =
                                blk_itm.fld_blk_itm_lbl;
                              fld_blk_itm_tag_or_id = None;
                              fld_blk_itm_main =
                                Cs_blks ((
                                  Cu_blk_txt (
                                    Cs_blk_txt (
                                      Cs_txt_lines (
                                        (txt_line_of_tag_or_id tag_or_id) :: txt_line_list
                                      )
                                    )
                                  )
                                ):: blk_list_tl);
                             }
                 )
                 | _ ->
                            {
                              fld_blk_itm_lbl =
                                blk_itm.fld_blk_itm_lbl;
                              fld_blk_itm_tag_or_id = None;
                              fld_blk_itm_main =
                                Cs_blks ((
                                  Cu_blk_txt (
                                    Cs_blk_txt (
                                      Cs_txt_lines (
                                        (txt_line_of_tag_or_id tag_or_id) :: []
                                      )
                                    )
                                  )
                                ):: blk_list_tl);
                             }
             )
  )
  | None -> (
      match blk_itm.fld_blk_itm_main with
      | Cs_blks (blk_list : tu_blk list) -> (
          match blk_list with
          | [] -> blk_itm
          | blk_list_hd :: blk_list_tl -> (
              match blk_list_hd with
              | Cu_blk_txt blk_txt -> (
                  match blk_txt with
                  | Cs_blk_txt txt_lines -> (
                      match txt_lines with
                      | Cs_txt_lines txt_line_list -> (
                          match txt_line_list with
                          | first_line :: [] -> (
                              match (first_line, blk_list_tl) with
                              | ( Cs_txt_line
                                    (Cs_txt_units
                                       [
                                         Cu_txt_unit_wysiwyg
                                           (Cs_txt_unit_wysiwyg tag_string);
                                       ]),
                                  _ :: _ ) -> (
                                  match tag_of_string tag_string with
                                  | None -> blk_itm
                                  | Some tag ->
                                      {
                                        fld_blk_itm_lbl =
                                          blk_itm.fld_blk_itm_lbl;
                                        fld_blk_itm_tag_or_id =
                                          Some (Cu_tag_or_id_tag tag);
                                        fld_blk_itm_main = Cs_blks blk_list_tl;
                                      })
                              | _, _ -> blk_itm)
                          | first_line :: txt_line_list_tl -> (
                              match first_line with
                              | Cs_txt_line
                                  (Cs_txt_units
                                     [
                                       Cu_txt_unit_wysiwyg
                                         (Cs_txt_unit_wysiwyg tag_string);
                                     ]) -> (
                                  match tag_of_string tag_string with
                                  | None -> blk_itm
                                  | Some tag ->
                                      {
                                        fld_blk_itm_lbl =
                                          blk_itm.fld_blk_itm_lbl;
                                        fld_blk_itm_tag_or_id =
                                          Some (Cu_tag_or_id_tag tag);
                                        fld_blk_itm_main =
                                          Cs_blks
                                            (Cu_blk_txt
                                               (Cs_blk_txt
                                                  (Cs_txt_lines txt_line_list_tl))
                                           :: blk_list_tl);
                                      })
                              | _ -> blk_itm)
                          | _ -> blk_itm)))
              | _ -> blk_itm)))


let blk_itm_tag_of_string_default (s : string) : ts_tag option =
  let tag_list : string list =
    List.concat [tag_strings_default; tag_strings_standard_blk_itm]
  in
  if List.mem s tag_list then Some (Cs_tag s) else None

let tag_blk_itm_default (blk_itm : tr_blk_itm) : tr_blk_itm =
  tag_blk_itm_gen blk_itm_tag_of_string_default blk_itm


let tag_blk_itm_of_path (path : string) : tr_blk_itm -> tr_blk_itm =
  let tag_list : string list =
    List.concat [tag_strings_of_file path; tag_strings_standard_blk_itm]
  in
  let tag_of_string (s : string) : ts_tag option =
    if List.mem s tag_list then Some (Cs_tag s) else None
  in
  tag_blk_itm_gen tag_of_string

let tag_blk_itm_of_path_opt (path_opt : string option) : tr_blk_itm -> tr_blk_itm =
  match path_opt with
  | None -> tag_blk_itm_default
  | Some path -> tag_blk_itm_of_path path

(* c_ref *)


let string_of_c_ref (c_ref : ts_c_ref) : string =
  match c_ref with
  | Cs_c_ref id -> String.concat "" ["["; string_of_id id; "]"]

let c_ref_or_wysiwyg_gen (tag_strings : string list) (txt_unit : tu_txt_unit)  : tu_txt_unit =
  match txt_unit with
  | Cu_txt_unit_c_ref (Cs_txt_unit_c_ref (Cs_c_ref id)) -> (
      match id.fld_id_tag with
      | Cs_tag tag_string ->
         if List.mem tag_string tag_strings then txt_unit
         else Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg (string_of_c_ref (Cs_c_ref id)))
  )
  | _ -> txt_unit

let tag_strings_c_ref_default : string list =
  List.concat [tag_strings_default; tag_strings_standard]

let c_ref_or_wysiwyg_default (txt_unit : tu_txt_unit) : tu_txt_unit =
  c_ref_or_wysiwyg_gen tag_strings_c_ref_default txt_unit

let c_ref_or_wysiwyg_of_path (path : string) : (tu_txt_unit -> tu_txt_unit) =
  let tag_strings : string list =
    List.concat [tag_strings_of_file path; tag_strings_standard]
  in
  c_ref_or_wysiwyg_gen tag_strings

let c_ref_or_wysiwyg_of_path_opt (path_opt : string option) : (tu_txt_unit -> tu_txt_unit) =
  match path_opt with
  | None -> c_ref_or_wysiwyg_default
  | Some path -> c_ref_or_wysiwyg_of_path path
