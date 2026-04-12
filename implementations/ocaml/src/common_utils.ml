open Doc_types

exception Error of string

(* document classes *)

type t_doc_class = DOC_CHS | DOC_SECS | DOC_PARS | DOC_BLKS

let class_of_tr_doc (doc : Doc_types.tr_doc) : t_doc_class =
        match doc.fld_doc_main with
        |Cu_doc_main_chs _ -> DOC_CHS
        |Cu_doc_main_secs _ -> DOC_SECS
        |Cu_doc_main_pars _ -> DOC_PARS
        |Cu_doc_main_blks _ -> DOC_BLKS

let string_of_t_doc_class (doc_class : t_doc_class) : string =
        match doc_class with
        |DOC_CHS -> "doc chs"
        |DOC_SECS -> "doc secs"
        |DOC_PARS -> "doc pars"
        |DOC_BLKS -> "doc blks"



(* document settings *)

type t_doc_settings = {
        doc_width : int;
        left_margin: int;
        title_indent: int;
        author_indent: int;
        abstract_indent: int;
        refs_indent: int;
        tab_length : int;
        abstract_hdr: (string * string) option;
        refs_hdr: (string * string) option;
	endnotes_hdr : (string * string) option;
        ch_prefix: (string * string) option;
        sec_prefix: (string * string) option;
        app_prefix: (string * string) option;
        par_prefix : (string * string) option;
        expand_tag: Doc_types.ts_tag -> (string * string) option;
        auto_numbering : int -> int -> string;
        allow_custom_numbering : bool;
}



let expand_tag_default (tag : Doc_types.ts_tag) : (string * string) option =
        match tag with
        |Cs_tag "DEF" -> Some ("DEFINITION", "Definition")
        |Cs_tag "PRF" -> Some ("PROOF", "Proof")
        |Cs_tag "FCT" -> Some ("FACT", "Fact")
        |Cs_tag "LMA" -> Some ("LEMMA", "Lemma")
        |Cs_tag "THM" -> Some ("THEOREM", "Theorem")
        |Cs_tag "RMK" -> Some ("REMARK", "Remark")
        |Cs_tag "DEFS" -> Some ("DEFINITIONS", "Definitions")
        |Cs_tag "PRFS" -> Some ("PROOFS", "Proofs")
        |Cs_tag "FCTS" -> Some ("FACTS", "Facts")
        |Cs_tag "LMAS" -> Some ("LEMMAS", "Lemmas")
        |Cs_tag "THMS" -> Some ("THEOREMS", "Theorems")
        |Cs_tag "RMKS" -> Some ("REMARKS", "Remarks")
        | _  -> None

let lower_case_latin_letters : string array =
        [|"a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";"m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"x";"y";"z";|]

let lower_case_roman_numerals : string array =
        [|"i";"ii";"iii";"iv";"v";"vi";"vii";"viii";"ix";"x";"xi";"xii";"xiii";"xiv";"xv";"xvi";"xvii";"xviii";"xix";"xx";|]

let upper_case_latin_letters : string array =
        [|"A";"B";"C";"D";"E";"F";"G";"H";"I";"J";"K";"L";"M";"N";"O";"P";"Q";"R";"S";"T";"U";"V";"X";"Y";"Z";|]

let upper_case_roman_numerals : string array =
        [|"I";"II";"III";"IV";"V";"VI";"VII";"VIII";"IX";"X";"XI";"XII";"XIII";"XIV";"XV";"XVI";"XVII";"XVIII";"XIX";"XX";|]

let superscript_digits : string array = 
        [|"⁰";"¹";"²";"³";"⁴";"⁵";"⁶";"⁷";"⁸";"⁹"|]


let bullets : string array = [| "─" |]

let symbol_of_array (a : string array) (i : int) : string =
        let len : int = Array.length a in
        let rec aux (n : int) (acc : string) : string =
                match n < 0 with
                |true -> acc
                |false ->
                        let m = n mod (len - 1) in
                        aux (n - m - 1) (acc ^ a.(m))
        in aux i ""

let auto_numbering_of_string (s: string) : int -> int -> string =
        match s with
        |"a1i" ->
                let auto_numbering (lvl : int) (n:int) =
                        let symbol : string =
                        match lvl mod 3 with
                        |0 -> symbol_of_array lower_case_latin_letters n
                        |1 -> string_of_int (n+1)
                        |_ -> symbol_of_array lower_case_roman_numerals n
                        in String.concat symbol ["(";")"]
                in auto_numbering
        |"ai1" ->
                let auto_numbering (lvl : int) (n:int) =
                        let symbol : string =
                        match lvl mod 3 with
                        |0 -> symbol_of_array lower_case_latin_letters n
                        |1 -> symbol_of_array lower_case_roman_numerals n
                        |_ -> string_of_int (n+1)
                        in String.concat symbol ["(";")"]
                in auto_numbering
        |"1ai" ->
                let auto_numbering (lvl : int) (n:int) =
                        let symbol : string =
                        match lvl mod 3 with
                        |0 -> string_of_int (n+1)
                        |1 -> symbol_of_array lower_case_latin_letters n
                        |_ -> symbol_of_array lower_case_roman_numerals n
                        in String.concat symbol ["(";")"]
                in auto_numbering
        |"1ia"->
                let auto_numbering (lvl : int) (n:int) =
                        let symbol : string =
                        match lvl mod 3 with
                        |0 -> string_of_int (n+1)
                        |1 -> symbol_of_array lower_case_roman_numerals n
                        |_ -> symbol_of_array lower_case_latin_letters n
                        in String.concat symbol ["(";")"]
                in auto_numbering
        |"ia1" ->
                let auto_numbering (lvl : int) (n:int) =
                        let symbol : string =
                        match lvl mod 3 with
                        |0 -> symbol_of_array lower_case_roman_numerals n
                        |1 -> symbol_of_array lower_case_latin_letters n
                        |_ -> string_of_int (n+1)
                        in String.concat symbol ["(";")"]
                in auto_numbering
        |"i1a" ->
                let auto_numbering (lvl : int) (n:int) =
                        let symbol : string =
                        match lvl mod 3 with
                        |0 -> symbol_of_array lower_case_roman_numerals n
                        |1 -> string_of_int (n+1)
                        |_ -> symbol_of_array lower_case_latin_letters n
                        in String.concat symbol ["(";")"]
                in auto_numbering
        |_ -> raise (Invalid_argument s)


let auto_numbering_default (lvl : int) (n : int) : string =
        auto_numbering_of_string "a1i" lvl n

let doc_settings_default () : t_doc_settings = {
        doc_width = 68;
        left_margin = 0;
        title_indent = 0;
        author_indent = 0;
        abstract_indent = 0;
        refs_indent = 0;
        tab_length = 6;
        abstract_hdr = Some ("ABSTRACT", "Abstract");
        refs_hdr = Some ("REFERENCES", "References");
	endnotes_hdr = Some ("ENDNOTES", "Endnotes");
        ch_prefix = Some ("CHAPTER", "Chapter");
        sec_prefix = Some ("§","§");
        app_prefix = Some ("§","Appendix");
        par_prefix = Some ("¶","¶");
        expand_tag = expand_tag_default;
        auto_numbering = auto_numbering_default;
        allow_custom_numbering = true;
}


let doc_settings_of_ts_blks (doc_settings : t_doc_settings) (lvl : int) (blks : Doc_types.ts_blks) : t_doc_settings =
        if not doc_settings.allow_custom_numbering then doc_settings else
        let rec aux (blk_list : Doc_types.tu_blk list) : t_doc_settings =
                match blk_list with
                |[] -> doc_settings
                |hd ::tl ->
                        match hd with
                        |Cu_blk_itm (blk_itm : tr_blk_itm) -> (
                                match blk_itm.fld_blk_itm_lbl with
                                |Cu_lbl_custom (Cs_lbl_custom s) -> (
                                        match s with
                                        |"1" | "a" | "i" ->
                                                let inc : int =
                                                        match s, doc_settings.auto_numbering 1 0, doc_settings.auto_numbering 2 0 with
                                                        |"a","(a)",_  -> 1
                                                        |"a",_,"(a)" -> 2
                                                        |"1","(1)",_  -> 1
                                                        |"1",_,"(1)" -> 2
                                                        |"i","(i)",_  -> 1
                                                        |"i",_,"(i)" -> 2
                                                        |_,_,_ -> 0
                                                in
                                                let new_auto_numbering (l : int) (n : int) : string =
                                                        let new_n = if l=lvl then n+1 else n in
                                                        doc_settings.auto_numbering (l - lvl + inc) new_n
                                                in
                                                {
                                                        doc_width = doc_settings.doc_width;
                                                        left_margin = doc_settings.left_margin;
                                                        title_indent = doc_settings.title_indent;
                                                        author_indent = doc_settings.author_indent;
                                                        abstract_indent = doc_settings.abstract_indent;
                                                        refs_indent = doc_settings.refs_indent;
                                                        tab_length = doc_settings.tab_length;
                                                        abstract_hdr = doc_settings.abstract_hdr;
                                                        refs_hdr = doc_settings.refs_hdr;
							endnotes_hdr = doc_settings.endnotes_hdr;
                                                        ch_prefix = doc_settings.ch_prefix;
                                                        sec_prefix = doc_settings.sec_prefix;
                                                        app_prefix = doc_settings.app_prefix;
                                                        par_prefix = doc_settings.par_prefix;
                                                        expand_tag = doc_settings.expand_tag;
                                                        auto_numbering = new_auto_numbering;
                                                        allow_custom_numbering = doc_settings.allow_custom_numbering;
                                                }
                                        |_ -> doc_settings
                                )
                                |_ -> doc_settings
                        )
                        |_ -> aux tl
        in
        match blks with
        |Cs_blks blk_list -> aux blk_list




let tag_value_of_string (expand_tag_old : Doc_types.ts_tag -> (string * string) option) (v : string) : (Doc_types.ts_tag -> (string * string) option) =
        match String.split_on_char ',' v with
        |[tag_string; lbl; cref] -> (
                let expand_tag_new ( tag : Doc_types.ts_tag) : (string * string) option = 
                        match tag with
                        |Cs_tag (s : string) ->
                                match s = tag_string with
                                |true -> Some (lbl, cref)
                                |false -> expand_tag_old tag
                in expand_tag_new
        )
        | _ -> raise (Error "invalid tag value")

let prefix_value_of_string (v : string) : (string * string) option =
        match String.split_on_char ',' v with
        |[lbl; cref] -> Some (lbl, cref)
        |_ -> None


let key_value_pair_of_string_opt (s : string): (string*string) option=
        match String.split_on_char '=' s with
        |[key;value] -> Some (key, value)
        | _ -> None

let set_doc_width (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        try 
        {
        doc_width = int_of_string v;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }
        with _ ->
        let _ : unit =
        Debug_utils.print_warning (String.concat "" ["WARNING: invalid doc_width value: ";v;"\n";"using default value"])
        in doc_settings

let set_left_margin (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        try
        {
        doc_width = doc_settings.doc_width;
        left_margin = int_of_string v;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }
        with _ ->
        let _ : unit =
        Debug_utils.print_warning (String.concat "" ["WARNING: invalid left_margin value: ";v;"\n";"using default value"])
        in doc_settings

let set_title_indent (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        try
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = int_of_string v;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }
        with _ ->
        let _ : unit =
        Debug_utils.print_warning (String.concat "" ["WARNING: invalid title_indent value: ";v;"\n";"using default value"])
        in doc_settings

let set_author_indent (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        try
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = int_of_string v;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }
        with _ ->
        let _ : unit =
        Debug_utils.print_warning (String.concat "" ["WARNING: invalid author_indent value: ";v;"\n";"using default value"])
        in doc_settings

let set_abstract_indent (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        try
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = int_of_string v;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }
        with _ ->
        let _ : unit =
        Debug_utils.print_warning (String.concat "" ["WARNING: invalid abstract_indent value: ";v;"\n";"using default value"])
        in doc_settings

let set_refs_indent (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        try
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = int_of_string v;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }
        with _ ->
        let _ : unit =
        Debug_utils.print_warning (String.concat "" ["WARNING: invalid refs_indent value: ";v;"\n";"using default value"])
        in doc_settings


let set_tab_length (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        try
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = int_of_string v;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }
        with _ ->
        let _ : unit =
        Debug_utils.print_warning (String.concat "" ["WARNING: invalid tab_length value: ";v;"; ";"using default value"])
        in doc_settings

let set_abstract_hdr (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = prefix_value_of_string v;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }

let set_refs_hdr (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = prefix_value_of_string v;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }

let set_ch_prefix (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = prefix_value_of_string v;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }

let set_sec_prefix (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = prefix_value_of_string v;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }

let set_par_prefix (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = prefix_value_of_string v;
        expand_tag = doc_settings.expand_tag;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }

let set_expand_tag (expand_tag_old : Doc_types.ts_tag -> (string * string) option) (v : string) (doc_settings : t_doc_settings) : t_doc_settings =
        try
        {
        doc_width = doc_settings.doc_width;
        left_margin = doc_settings.left_margin;
        title_indent = doc_settings.title_indent;
        author_indent = doc_settings.author_indent;
        abstract_indent = doc_settings.abstract_indent;
        refs_indent = doc_settings.refs_indent;
        tab_length = doc_settings.tab_length;
        abstract_hdr = doc_settings.abstract_hdr;
        refs_hdr = doc_settings.refs_hdr;
        endnotes_hdr = doc_settings.endnotes_hdr;
        ch_prefix = doc_settings.ch_prefix;
        sec_prefix = doc_settings.sec_prefix;
        app_prefix = doc_settings.app_prefix;
        par_prefix = doc_settings.par_prefix;
        expand_tag = tag_value_of_string expand_tag_old v;
        auto_numbering = doc_settings.auto_numbering;
        allow_custom_numbering = doc_settings.allow_custom_numbering;
        }
        with _ ->
        let _ : unit =
        Debug_utils.print_warning (String.concat "" ["WARNING: invalid tag value: ";v;"; ";"using default value"])
        in doc_settings

let doc_settings_of_ts_preamble (doc_settings : t_doc_settings) (preamble : Doc_types.ts_preamble) : t_doc_settings =
        let rec aux (str_list : string list) (settings : t_doc_settings) : t_doc_settings =
                match str_list with
                | hd :: tl -> (
                        let new_doc_settings : t_doc_settings =
                                match key_value_pair_of_string_opt hd with
                                |Some ("doc-width", v) -> set_doc_width v settings
                                |Some ("left-margin", v) -> set_left_margin v settings
                                |Some ("title-indent", v) -> set_title_indent v settings
                                |Some ("author-indent", v) -> set_author_indent v settings
                                |Some ("abstract-indent", v) -> set_abstract_indent v settings
                                |Some ("refs-indent", v) -> set_refs_indent v settings
                                |Some ("tab-length", v) -> set_tab_length v settings
                                |Some ("ch-prefix", v) -> set_ch_prefix v settings
                                |Some ("sec-prefix", v) -> set_sec_prefix v settings
                                |Some ("par-prefix", v) -> set_par_prefix v settings
                                |Some ("abstract-hdr", v) -> set_abstract_hdr v settings
                                |Some ("refs-hdr", v) -> set_refs_hdr v settings
                                |Some ("tag", v) -> set_expand_tag settings.expand_tag v settings
                                |_ -> let _ : unit = Debug_utils.print_warning 
                                        (String.concat "" ["WARNING: invalid attribute: ";hd;"; ";"ignoring it"]) in settings
                        in aux tl new_doc_settings
                )
                | [] -> settings
        in
        match preamble with 
        (Cs_preamble (s : string)) -> 
                let str_list : string list = String.split_on_char ';' s in
                aux str_list doc_settings


let doc_settings_of_tr_doc (doc : Doc_types.tr_doc) : t_doc_settings =
        match doc.fld_doc_preamble with
        |None -> doc_settings_default ()
        |Some preamble -> doc_settings_of_ts_preamble (doc_settings_default ()) preamble 



(* cross-references *)


type t_path = t_node list

and t_node =
        | ABSTRACT_NODE
        | CH_NODE of int
        | SEC_NODE of int
        | APP_NODE of int
        | PAR_NODE of t_par_node
        | ITM_NODE of t_itm_node
        | DSP_NODE
        | BLT_NODE
        | DSP_LINE_NODE of t_dsp_line_node
        | REFS_NODE
        | FTN_NODE of int

and t_par_node = PAR_AUTO of int | PAR_TAG of (string * string * int)

and t_itm_node = ITM_AUTO of string | ITM_CUSTOM of string | ITM_TAG_AUTO of (string * string) | ITM_TAG_CUSTOM of (string * string)

and t_dsp_line_node =
        | DSP_AUTO of string
        | DSP_CUSTOM of string
        | DSP_NONE
        | DSP_TAG_AUTO of (string * string)
        | DSP_TAG_CUSTOM of (string * string)

type t_cref_element = 
        |Cref_element_ch of tr_ch
        |Cref_element_sec of tr_sec
        |Cref_element_par of tr_par_std
        |Cref_element_blk_itm of tr_blk_itm
        |Cref_element_dsp_line of tr_dsp_line
        |Cref_element_blk_ftn of tr_blk_ftn

type t_cref_table = (Doc_types.tr_id * t_path * t_cref_element) list

let path_to_ch_node (path : t_path) : t_path =
        let rec aux (rev_path : t_path) (acc : t_path) : t_path =
                match rev_path with
                |[] -> acc
                |hd::tl ->
                        match hd with
                        |CH_NODE _ -> hd::acc
                        |_ -> aux tl (hd::acc)
        in aux (List.rev path) []

let path_to_sec_node (path : t_path) : t_path =
        let rec aux (rev_path : t_path) (acc : t_path) : t_path =
                match rev_path with
                |[] -> acc
                |hd::tl ->
                        match hd with
                        |SEC_NODE _ -> hd::acc
                        |_ -> aux tl (hd::acc)
        in aux (List.rev path) []

let path_to_app_node (path : t_path) : t_path =
        let rec aux (rev_path : t_path) (acc : t_path) : t_path =
                match rev_path with
                |[] -> acc
                |hd::tl ->
                        match hd with
                        |APP_NODE _ -> hd::acc
                        |_ -> aux tl (hd::acc)
        in aux (List.rev path) []


let path_to_par_node (path : t_path) : t_path =
        let rec aux (rev_path : t_path) (acc : t_path) : t_path =
                match rev_path with
                |[] -> acc
                |hd::tl ->
                        match hd with
                        |PAR_NODE _ -> hd::acc
                        |_ -> aux tl (hd::acc)
        in aux (List.rev path) []

let path_to_ch_sec_par (path : t_path) : t_path =
        let rec aux (p : t_path) (acc : t_path) : t_path =
                match p with
                |[] -> acc
                |hd::tl ->
                        match hd with
                        |CH_NODE _ | SEC_NODE _ | APP_NODE _ | PAR_NODE _ -> aux tl (hd::acc)
                        |_ -> acc
        in
        aux (List.rev path) []


let path_from_ch_sec_par (path : t_path) : t_path =
        let rec aux (p : t_path) (acc : t_path) : t_path =
                match p with
                |[] -> List.rev acc
                |hd::tl ->
                        match hd with
                        |CH_NODE _ | SEC_NODE _ | APP_NODE _ | PAR_NODE _ -> List.rev acc
                        |_ -> aux tl (hd::acc)
        in
        aux path []


let path_from_common_ancestor (c_ref_loc : t_path) (id_loc : t_path) : t_path =
        let rev_c_ref_loc : t_path = List.rev c_ref_loc in
        let rev_id_loc : t_path = List.rev id_loc in
        let rec aux (rev_c_ref_loc : t_path) (rev_id_loc : t_path) : t_path = (
                match (rev_c_ref_loc, rev_id_loc) with
                | rev_c_ref_loc_hd :: rev_c_ref_loc_tl, rev_id_loc_hd :: rev_id_loc_tl -> (
                        match rev_c_ref_loc_hd = rev_id_loc_hd with
                        | true -> aux rev_c_ref_loc_tl rev_id_loc_tl
                        | false -> List.rev rev_id_loc
                )
                | [], [] -> (
(*                      let _ : unit = Debug_utils.print_warning ("WARNING: self-reference in " ^ (string_of_path c_ref_loc)) in *)
                        try [List.hd id_loc] with _ -> raise (Error "id_loc not expected to be an empty path")
                )
                | _ :: _, [] -> (
(*                      let _ : unit = Debug_utils.print_warning ("WARNING: reference to parent node in " ^ (string_of_path c_ref_loc)) in *)
                        try [List.hd id_loc] with _ -> raise (Error "id_loc not expected to be an empty path")
                )
                | [], _ :: _ ->
(*                      let _:unit=Debug_utils.print_warning ("WARNING: reference to child node in " ^ (string_of_path c_ref_loc)) in *)
                        List.rev rev_id_loc
        )
        in 
        aux rev_c_ref_loc rev_id_loc

let rec lvl_of_path (path : t_path) : int =
        match path with
        | [] -> 0
        | hd :: tl ->
                match hd with
                | ITM_NODE _ -> lvl_of_path tl + 1
                | BLT_NODE -> lvl_of_path tl + 1
                | _ -> lvl_of_path tl


let c_ref_loc_is_within_scope_of_id (c_ref_loc : t_path) (scope_opt : tu_scope option) (id_loc : t_path) : bool =
        match scope_opt with
        |None | Some Cu_scope_gbl -> true
        |Some Cu_scope_ch -> path_to_ch_node c_ref_loc = path_to_ch_node id_loc
        |Some Cu_scope_sec -> path_to_sec_node c_ref_loc = path_to_sec_node id_loc
        |Some Cu_scope_app -> path_to_app_node c_ref_loc = path_to_app_node id_loc
        |Some Cu_scope_par -> path_to_par_node c_ref_loc = path_to_par_node id_loc

let ids_match (c_ref_id : Doc_types.tr_id) (c_ref_loc : t_path) (id : Doc_types.tr_id) (id_loc : t_path) : bool =
        if c_ref_id = id
        then
                c_ref_loc_is_within_scope_of_id c_ref_loc id.fld_id_scope id_loc
        else
        false

let reference_of_ts_c_ref (cref_table : t_cref_table) (c_ref_path : t_path) (c_ref : Doc_types.ts_c_ref) : (Doc_types.tr_id * t_path * t_cref_element) option =
        match c_ref with
        |Cs_c_ref c_ref_id ->
        let rec aux (cref_table : t_cref_table) : (Doc_types.tr_id * t_path * t_cref_element) option =
                match cref_table with
                |[] -> None
                |(table_id, table_path, table_element) :: tl ->
                        match ids_match c_ref_id c_ref_path table_id table_path with
                        |true -> Some (table_id, table_path, table_element)
                        |false -> aux tl
        in
        aux cref_table


let string_of_node_opt (doc_settings : t_doc_settings) (tail : t_path) (head : t_node) : string option =
        match head with
        | CH_NODE (n : int)
        | SEC_NODE (n : int) -> Some (string_of_int (n+1))
        | PAR_NODE (par_node : t_par_node) -> (
                match par_node with
                |PAR_AUTO n -> Some (string_of_int (n+1))
                |PAR_TAG (_,_,n) -> Some (string_of_int (n+1))
        )
        | APP_NODE (n : int) -> Some (symbol_of_array upper_case_latin_letters n)
        | DSP_NODE -> None
        | DSP_LINE_NODE (a : t_dsp_line_node) -> (
                match a with
                | DSP_NONE -> None
                | DSP_AUTO (s : string) -> Some s
                | DSP_CUSTOM (s : string) -> Some (String.concat s ["(";")"])
                | DSP_TAG_AUTO (_,s) -> Some s
                | DSP_TAG_CUSTOM (_,s) -> Some (String.concat s ["(";")"])
        )
        | ITM_NODE (a : t_itm_node) -> (
                match a with
                |ITM_AUTO s -> Some s
                |ITM_CUSTOM s -> Some (String.concat s ["(";")"])
                |ITM_TAG_AUTO (_,s) -> Some s
                |ITM_TAG_CUSTOM (_,s) -> Some (String.concat s ["(";")"])
        )
        | BLT_NODE ->
                let l : int = lvl_of_path tail in
                Some bullets.(l mod Array.length bullets)
        | ABSTRACT_NODE -> (
                match doc_settings.abstract_hdr with
                |Some (_,hdr) -> Some hdr
                |None -> None
        )
        | REFS_NODE -> (
                match doc_settings.refs_hdr with
                |Some (_, hdr) -> Some hdr
                |None -> None
        )
        | FTN_NODE n -> Some (string_of_int n)


let string_of_path_opt (doc_settings : t_doc_settings) (full_path : t_path) (path : t_path) : string option =
        let rec aux (full_p : t_path) (p : t_path) (acc : string option) : string option =
                match full_p, p with
                |full_p_hd::full_p_tl, p_hd::p_tl -> (
                        match p_hd, string_of_node_opt doc_settings full_p_tl p_hd with
                        |_, None -> aux full_p_tl p_tl acc
                        |CH_NODE _, Some s
                        |SEC_NODE _, Some s
                        |APP_NODE _, Some s
                        |PAR_NODE _, Some s -> (
                                match acc with
                                |Some t -> aux full_p_tl p_tl (Some (s ^ "." ^ t))
                                |None -> aux full_p_tl p_tl (Some s)
                        )
                        |_, Some s ->
                                match acc with
                                |Some t -> aux full_p_tl p_tl (Some (s ^ t))
                                |None -> aux full_p_tl p_tl (Some s)
                )
                |full_p_hd::full_p_tl, [] -> (
                        acc
                )
                |[],_ -> acc
        in
        aux full_path path None

let string_of_path (doc_settings : t_doc_settings) (path : t_path) : string =
        match string_of_path_opt doc_settings path path with
        |None -> "document"
        |Some s -> s


let rec string_of_shown_path (doc_settings : t_doc_settings) (full_path : t_path) (path : t_path) : string =
        let inner_path = path_from_ch_sec_par path in
        let outer_path = path_to_ch_sec_par path in
        let full_outer_path = path_to_ch_sec_par full_path in
        match inner_path, outer_path with
        |[],outer_path_hd::_ -> (
                match outer_path_hd with
                |CH_NODE _ -> (
                        match doc_settings.ch_prefix with
                        |Some (_,s) -> String.concat "\u{00A0}" [s;string_of_path doc_settings full_outer_path]
                        |None -> string_of_path doc_settings full_outer_path
                )
                |SEC_NODE _ -> (
                        match doc_settings.sec_prefix with
                        |Some (_,s) -> String.concat "\u{00A0}" [s;string_of_path doc_settings full_outer_path]
                        |None -> string_of_path doc_settings full_outer_path
                )
                |APP_NODE _ -> (
                        match doc_settings.app_prefix with
                        |Some (_,s) -> String.concat "\u{00A0}" [s;string_of_path doc_settings full_outer_path]
                        |None -> string_of_path doc_settings full_outer_path
                )
                |PAR_NODE par_node -> (
                        match par_node with
                        |PAR_AUTO _ -> (
                                match doc_settings.par_prefix with
                                |None -> string_of_path doc_settings full_outer_path
                                |Some (_,s) -> String.concat "\u{00A0}" [s;string_of_path doc_settings full_outer_path]
                        )
                        |PAR_TAG (_,tag,_) -> String.concat "\u{00A0}" [tag;string_of_path doc_settings full_outer_path]
                )
                |_ -> string_of_path doc_settings full_outer_path
        )
        |inner_path_hd::_, [] -> (
                match inner_path_hd with
                |ITM_NODE itm_node -> (
                        match itm_node with
                        |ITM_AUTO _ | ITM_CUSTOM _ -> (
                                match string_of_path_opt doc_settings full_path inner_path with
                                |None -> "NONE"
                                |Some s -> s
                        )
                        |ITM_TAG_AUTO (tag,_) | ITM_TAG_CUSTOM (tag,_) -> (
                                match string_of_path_opt doc_settings full_path inner_path with
                                |None -> tag
                                |Some s -> String.concat "\u{00A0}" [tag;s]
                        )
                )
                |DSP_LINE_NODE dsp_line_node -> (
                        match dsp_line_node with
                        |DSP_AUTO _ | DSP_CUSTOM _ -> (
                                match string_of_path_opt doc_settings full_path inner_path with
                                |None -> "NONE"
                                |Some s -> s
                        )
                        |DSP_TAG_AUTO (tag,_) | DSP_TAG_CUSTOM (tag,_) -> (
                                match string_of_path_opt doc_settings full_path inner_path with
                                |None -> tag
                                |Some s -> String.concat "\u{00A0}" [tag;s]
                        )
                        |DSP_NONE -> raise (Error "cannot refer to unlabeled display line")
                )
                |_ ->
                        match string_of_path_opt doc_settings full_path inner_path with
                        |None -> raise (Error "shown path cannot be empty")
                        |Some s -> s
        )
        |inner_path_hd::_, _::_ -> (
                match inner_path_hd with
                |ITM_NODE itm_node -> (
                        match itm_node with
                        |ITM_AUTO _ | ITM_CUSTOM _ -> (
                                match string_of_path_opt doc_settings full_path inner_path with
                                |None -> raise (Error "shown path cannot be empty")
                                |Some s -> String.concat "\u{00A0}" [s;"of";string_of_shown_path doc_settings full_outer_path full_outer_path]
                        )
                        |ITM_TAG_AUTO (tag,_) | ITM_TAG_CUSTOM (tag,_) -> (
                                match string_of_path_opt doc_settings full_path inner_path with
                                |None -> tag
                                |Some s -> String.concat "\u{00A0}" [tag;(string_of_path doc_settings full_outer_path) ^ s]
                        )
                )
                |DSP_LINE_NODE dsp_line_node -> (
                        match dsp_line_node with
                        |DSP_AUTO _ | DSP_CUSTOM _ -> (
                                match string_of_path_opt doc_settings full_path inner_path with
                                |None -> raise (Error "shown path cannot be empty")
                                |Some s -> String.concat "\u{00A0}" [s;"of";string_of_shown_path doc_settings full_outer_path full_outer_path]
                        )
                        |DSP_TAG_AUTO (tag,_) | DSP_TAG_CUSTOM (tag,_) -> (
                                match string_of_path_opt doc_settings full_path inner_path with
                                |None -> tag
                                |Some s -> String.concat "\u{00A0}" [tag;(string_of_path doc_settings full_outer_path) ^ s]
                        )
                        |DSP_NONE -> raise (Error "cannot refer to unlabeled display line")
                )
                |_ ->
                        match string_of_path_opt doc_settings full_path inner_path with
                        |None -> raise (Error "shown path cannot be empty")
                        |Some s -> String.concat "\u{00A0}" [s;"of";string_of_shown_path doc_settings full_outer_path full_outer_path]
        )
        |[],[] -> raise (Error "shown path cannot be empty")


let string_of_tu_scope (scope : tu_scope) : string =
        match scope with
        |Cu_scope_gbl -> "GBL"
        |Cu_scope_ch -> "CH"
        |Cu_scope_sec -> "SEC"
        |Cu_scope_app -> "APP"
        |Cu_scope_par -> "PAR"


let string_of_tr_id (id : Doc_types.tr_id) : string =
        match id.fld_id_tag, id.fld_id_name, id.fld_id_scope with
        |Cs_tag tag, Cs_name name, Some scope -> String.concat ":" [tag;name;string_of_tu_scope scope]
        |Cs_tag tag, Cs_name name, None -> String.concat ":" [tag;name]


let rec string_of_ts_c_ref (doc_settings : t_doc_settings) (cref_table : t_cref_table) (c_ref_loc : t_path) (c_ref : Doc_types.ts_c_ref) : string =
        match reference_of_ts_c_ref cref_table c_ref_loc c_ref with
        |None -> (
                match c_ref with
                |Cs_c_ref id_c_ref ->
                        let _ : unit = Debug_utils.print_warning (String.concat "" [
                                "WARNING: id \'";
                                string_of_tr_id id_c_ref;
                                "\' referenced in ";
                                string_of_path doc_settings c_ref_loc;
                                " does not exist or is out of scope.";
                        ]) in "??"
        )
        |Some (_, id_loc, _) -> 
                let sub_path = (path_from_common_ancestor c_ref_loc id_loc) in
                match List.rev sub_path with
                |hd::tl -> (
                        match hd with
                        |ABSTRACT_NODE | REFS_NODE ->
                                String.concat "\u{00A0}" [string_of_shown_path doc_settings id_loc (List.rev tl);"of"; string_of_path doc_settings [hd]]
                        |_ -> string_of_shown_path doc_settings id_loc sub_path
                )
                |[] -> raise (Error "path to id cannot be empty")

let check_cref_table (doc_settings : t_doc_settings) (table : t_cref_table) : t_cref_table =
        let rec aux1 (lst : t_cref_table) (acc : (Doc_types.tr_id * t_path) list): (Doc_types.tr_id * t_path) list =
                match lst with
                |[] -> acc
                |hd::tl ->
                        match hd with
                        |(id, path, _) ->
                                match id.fld_id_scope with
                                |None | Some Cu_scope_gbl -> aux1 tl ((id,[])::acc)
                                |Some Cu_scope_ch -> aux1 tl ((id, path_to_ch_node path)::acc)
                                |Some Cu_scope_sec -> aux1 tl ((id, path_to_sec_node path)::acc)
                                |Some Cu_scope_app -> aux1 tl ((id, path_to_app_node path)::acc)
                                |Some Cu_scope_par -> aux1 tl ((id, path_to_par_node path)::acc)
        in
        let rec aux2 (lst : (Doc_types.tr_id * t_path) list) : unit =
                match lst with
                |[] -> ()
                |(id,path)::tl ->
                        match List.mem (id,path) tl with
                        |true ->
                                let _ : unit = Debug_utils.print_warning (String.concat "" [
                                        "WARNING: id \'";
                                        string_of_tr_id id;"\'";
                                        " is defined more than once in ";
                                        string_of_path doc_settings path;
                                        ])
                                in aux2 tl
                        |false -> aux2 tl
        in
        let lst : (Doc_types.tr_id * t_path) list = aux1 table [] in
        let _ : unit = aux2 lst in
        table


(* labels *)

let label_of_path_opt (doc_settings : t_doc_settings) (path : t_path) : string option =
        match path with
        | [] -> None
        | hd :: tl ->
                match hd with
                | CH_NODE _ -> (
                        match doc_settings.ch_prefix, string_of_path doc_settings path with
                        | None, p -> Some p 
                        | Some (lbl,_), p -> Some (lbl ^ "\u{00A0}" ^ p)
                )
                | SEC_NODE _ -> (
                        match doc_settings.sec_prefix, string_of_path doc_settings path with
                        | None, p -> Some p 
                        | Some (lbl,_), p -> Some (lbl ^ "\u{00A0}" ^ p)
                )
                | APP_NODE _ -> (
                        match doc_settings.app_prefix, string_of_path doc_settings path with
                        | None, p -> Some p 
                        | Some (lbl,_), p -> Some (lbl ^ "\u{00A0}" ^ p)
                )
                | PAR_NODE _ -> (
                        match doc_settings.par_prefix, string_of_path doc_settings path with
                        | None, p -> Some p 
                        | Some (lbl,_), p -> Some (lbl ^ "\u{00A0}" ^ p)
                )
                | ITM_NODE _
                | BLT_NODE
                | DSP_LINE_NODE _ -> string_of_node_opt doc_settings tl hd
                | ABSTRACT_NODE -> (
                        match doc_settings.abstract_hdr with
                        |Some (lbl,_) -> Some lbl
                        |None -> None
                )
                | REFS_NODE -> (
                        match doc_settings.refs_hdr with
                        |Some (lbl,_) -> Some lbl
                        |None -> None
                )
                |FTN_NODE n -> Some (string_of_int n)
                | _ -> None

let label_of_path (doc_settings : t_doc_settings) (path : t_path) : string=
        match label_of_path_opt doc_settings path with
        | None -> "DOCUMENT"
        | Some (s : string) -> s


(* nodes *)


let node_of_tr_par_std (doc_settings : t_doc_settings) (auto_nr : int) (par : Doc_types.tr_par_std) : t_node =
        match par.fld_par_tag_or_id with
        |None -> PAR_NODE (PAR_AUTO auto_nr)
        |Some (tag_or_id : tu_tag_or_id) ->
                match tag_or_id with
                |Cu_tag_or_id_tag (tag : ts_tag) -> (
                        match doc_settings.expand_tag tag with
                        |Some (lbl,cref) -> PAR_NODE (PAR_TAG (lbl,cref,auto_nr))
                        |None -> PAR_NODE (PAR_AUTO auto_nr)
                )
                |Cu_tag_or_id_id (id : tr_id) -> (
                        match doc_settings.expand_tag id.fld_id_tag with
                        |Some (lbl,cref) -> PAR_NODE (PAR_TAG (lbl,cref,auto_nr))
                        |None -> PAR_NODE (PAR_AUTO auto_nr)
                )

let node_of_tu_par (doc_settings : t_doc_settings) (auto_nr : int) (p : tu_par) : t_node =
        match p with
        |Cu_par_rpt (Cs_par_rpt (id : tr_id)) -> PAR_NODE (PAR_AUTO auto_nr)
        |Cu_par_std (par : tr_par_std) -> node_of_tr_par_std doc_settings auto_nr par


let node_of_blk_itm (doc_settings : t_doc_settings) (path : t_path) (auto_nr : int) (a : Doc_types.tr_blk_itm) : t_node =
        match a.fld_blk_itm_lbl with
                | Cu_lbl_auto Cs_lbl_auto -> (
                        let lvl : int = lvl_of_path path in
                        let lbl : string = doc_settings.auto_numbering lvl auto_nr in
                        match a.fld_blk_itm_id with
                        |None -> ITM_NODE (ITM_AUTO lbl)
                        |Some id -> (
                                match doc_settings.expand_tag id.fld_id_tag with
                                |None -> ITM_NODE (ITM_AUTO lbl)
                                |Some (_,tag) -> ITM_NODE (ITM_TAG_AUTO (tag, lbl))
                        )
                )
                | Cu_lbl_custom (Cs_lbl_custom (s : string)) -> 
                        match a.fld_blk_itm_id with
                        |None -> ITM_NODE (ITM_CUSTOM s)
                        |Some id -> (
                                match doc_settings.expand_tag id.fld_id_tag with
                                |None -> ITM_NODE (ITM_CUSTOM s)
                                |Some (_,tag) -> ITM_NODE (ITM_TAG_CUSTOM (tag,s))
                        )

let node_of_dsp_line (doc_settings : t_doc_settings) (path : t_path) (auto_nr : int) (a : Doc_types.tr_dsp_line) : t_node =
        match a.fld_dsp_line_lbl with
                | Some (Cu_lbl_auto Cs_lbl_auto) -> (
                        let lvl : int = lvl_of_path path in
                        let lbl : string = doc_settings.auto_numbering lvl auto_nr in
                        match a.fld_dsp_line_id with
                        |None -> DSP_LINE_NODE (DSP_AUTO lbl)
                        |Some id -> (
                                match doc_settings.expand_tag id.fld_id_tag with
                                |None -> DSP_LINE_NODE (DSP_AUTO lbl)
                                |Some (_,tag) -> DSP_LINE_NODE (DSP_TAG_AUTO (tag, lbl))
                        )
                )
                | Some (Cu_lbl_custom (Cs_lbl_custom (s : string))) -> ( 
                        match a.fld_dsp_line_id with
                        |None -> DSP_LINE_NODE (DSP_CUSTOM s)
                        |Some id -> (
                                match doc_settings.expand_tag id.fld_id_tag with
                                |None -> DSP_LINE_NODE (DSP_CUSTOM s)
                                |Some (_,tag) -> DSP_LINE_NODE (DSP_TAG_CUSTOM (tag,s))
                        )
                )
                | None -> DSP_LINE_NODE DSP_NONE


(* Repeat *)

let par_restated_of_tr_par (par : Doc_types.tr_par_std) : Doc_types.tr_par_std =
        let space : tu_txt_unit =  Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " ") in
        let lpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg "(") in
        let rpar : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg ")") in
        let restated : tu_txt_unit = Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg "[restated]") in
        let par_hdr_opt : Doc_types.ts_hdr option =
                match par.fld_par_tag_or_id, par.fld_par_hdr with
                |None, hdr_opt -> hdr_opt 
                |Some tag_or_id, hdr_opt ->
                        match tag_or_id with
                        |Cu_tag_or_id_tag _ -> hdr_opt
                        |Cu_tag_or_id_id id ->
                                let c_ref : Doc_types.ts_c_ref = Cs_c_ref id in
                                let txt_unit_c_ref = Cs_txt_unit_c_ref c_ref in
                                let txt_unit = Cu_txt_unit_c_ref txt_unit_c_ref in
                                match hdr_opt with
                                |None -> Some (Cs_hdr (Cs_txt_units [txt_unit; space; restated]))
                                |Some (Cs_hdr (Cs_txt_units txt_unit_list)) -> 
                                        Some (Cs_hdr (Cs_txt_units (List.concat [[txt_unit; space; lpar]; txt_unit_list; [rpar; space; restated]])))
        in
        {       
                fld_par_hdr = par_hdr_opt;
                fld_par_tag_or_id = None;
                fld_par_main = par.fld_par_main;
        }



let par_restated_of_tr_id (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (id : tr_id) : (Doc_types.tr_par_std * t_path) option =
        match reference_of_ts_c_ref cref_table path (Cs_c_ref id) with
        |None -> let _ : unit = Debug_utils.print_warning (String.concat "" [
                        "WARNING: id \'";string_of_tr_id id;
                        "\' referenced in ";
                        string_of_path doc_settings path;
                        " does not exist or is out of scope.";
                ]) in None
        |Some (table_id, table_path, Cref_element_par par) ->
                Some (par_restated_of_tr_par par, table_path)
        |_ -> let _ : unit = Debug_utils.print_warning (String.concat "" [
                                "WARNING: id \'";
                                string_of_tr_id id;
                                "\' does not belong to a paragraph.";
                ]) in None

(* date *)

type t_time = {
        year : int;
        month : int;
        day : int;
        hour : int;
        minute : int;
        second : int;
        timezone : string * int * int;
}

let utc_timezone ((sign, hour, minute) : string * int * int) : string =
        match hour, minute with
        |0,0 -> "UTC"
        |_,0 -> "UTC" ^ sign ^ (Printf.sprintf "%.2i" hour)
        |_,_ -> "UTC" ^ sign ^ (Printf.sprintf "%.2i" hour) ^ ":" ^ (Printf.sprintf "%.2i" minute)

let time_of_ts_date_auto (doc_settings : t_doc_settings) (date : ts_date_auto) : t_time option =
        match date with
        |Cs_date_auto -> try
                let time : float = Unix.time () in
                let local_time : Unix.tm = Unix.localtime time in 
                let year_int : int = local_time.tm_year + 1900 in
                let month_int : int = local_time.tm_mon + 1 in
                let day_int : int = local_time.tm_mday in
                let hour_int : int = local_time.tm_hour in
                let minute_int : int = local_time.tm_min in
                let second_int : int = local_time.tm_sec in
                let time_ref : float = float_of_int (12 * 60 * 60) in
                let local_time_ref : Unix.tm = Unix.localtime time_ref in 
                let local_minutes_ref : int = (local_time_ref.tm_hour * 60) + local_time_ref.tm_min in
                let gm_time_ref : Unix.tm = Unix.gmtime time_ref in
                let gm_minutes_ref : int = (gm_time_ref.tm_hour * 60) + gm_time_ref.tm_min in
                let diff_minutes : int = local_minutes_ref + (60 * (Bool.to_int local_time.tm_isdst)) - gm_minutes_ref in
                let sign : string = if diff_minutes < 0 then "-" else "+" in
                let diff_minute : int = abs diff_minutes mod 60 in
                let diff_hour : int = (abs diff_minutes - diff_minute) / 60 in
                Some
                {
                        year = year_int;
                        month = month_int;
                        day = day_int;
                        hour = hour_int;
                        minute = minute_int;
                        second = second_int;
                        timezone = (sign, diff_hour, diff_minute);
                }
                with
                |_ -> let _ : unit = Debug_utils.print_warning "WARNING: cannot get system time and date." in None

(* footnotes *)

type t_ftn_entry = Ftn_entry_ref of (ts_ftn_ref * t_path * int * tr_blk_ftn) | Ftn_entry_inline of (ts_ftn_inline * t_path * int)

type t_ftn_table = t_ftn_entry list

let reference_of_ts_ftn_ref (doc_settings : t_doc_settings) (cref_table : t_cref_table) (ftn_path : t_path) (ftn_ref : Doc_types.ts_ftn_ref) : tr_blk_ftn option =
        match ftn_ref with
        |Cs_ftn_ref (ftn_id,i) ->
        let rec aux (cref_table : t_cref_table) : tr_blk_ftn option =
                match cref_table with
                |[] -> None
                |(table_id, table_path, Cref_element_blk_ftn blk_ftn) :: tl -> (
                        match ids_match ftn_id ftn_path table_id table_path with
                        |true -> Some blk_ftn
                        |false -> aux tl
                )
                |_::tl -> aux tl
        in
        aux cref_table


let ftn_table_of_ts_txt_unit_ftn_ref (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (ftn_table : t_ftn_table) (txt_unit_ftn_ref : ts_txt_unit_ftn_ref) : t_ftn_table =
        match txt_unit_ftn_ref with
        |Cs_txt_unit_ftn_ref ftn_ref ->
                match reference_of_ts_ftn_ref doc_settings cref_table path ftn_ref with
                |None -> ftn_table
                |Some blk_ftn ->
                        match ftn_table with
                        |[] -> (Ftn_entry_ref (ftn_ref, path, 1, blk_ftn)):: ftn_table
                        |(Ftn_entry_ref (_,_,n,_))::_ -> Ftn_entry_ref((ftn_ref, path, n+1, blk_ftn)) :: ftn_table
                        |(Ftn_entry_inline (_,_,n))::_ -> Ftn_entry_ref((ftn_ref, path, n+1, blk_ftn)) :: ftn_table

let ftn_table_of_ts_txt_unit_ftn_inline (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (ftn_table : t_ftn_table) (txt_unit_ftn_inline : ts_txt_unit_ftn_inline) : t_ftn_table =
        match txt_unit_ftn_inline with
        |Cs_txt_unit_ftn_inline ftn_inline ->
                        match ftn_table with
                        |[] -> (Ftn_entry_inline (ftn_inline, path, 1)):: ftn_table
                        |(Ftn_entry_inline (_,_,n))::_ -> Ftn_entry_inline ((ftn_inline, path, n+1)) :: ftn_table
                        |(Ftn_entry_ref (_,_,n,_))::_ -> Ftn_entry_inline ((ftn_inline, path, n+1)) :: ftn_table


let rec ftn_table_of_tu_txt_unit_list (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (ftn_table : t_ftn_table) (txt_unit_list : tu_txt_unit list) : t_ftn_table =
        match txt_unit_list with
        |[] -> ftn_table
        |hd::tl ->
                match hd with
                |Cu_txt_unit_ftn_ref ftn_ref -> 
                        let new_ftn_table = ftn_table_of_ts_txt_unit_ftn_ref doc_settings cref_table path ftn_table ftn_ref in
                        ftn_table_of_tu_txt_unit_list doc_settings cref_table path new_ftn_table tl
                |Cu_txt_unit_ftn_inline ftn_inline -> 
                        let new_ftn_table = ftn_table_of_ts_txt_unit_ftn_inline doc_settings cref_table path ftn_table ftn_inline in
                        ftn_table_of_tu_txt_unit_list doc_settings cref_table path new_ftn_table tl
                |_ -> ftn_table_of_tu_txt_unit_list doc_settings cref_table path ftn_table tl


let ftn_table_of_ts_txt_units (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (ftn_table : t_ftn_table) (txt_units : ts_txt_units) : t_ftn_table =
        match txt_units with
        |Cs_txt_units txt_unit_list ->
                ftn_table_of_tu_txt_unit_list doc_settings cref_table path ftn_table txt_unit_list

let ftn_table_of_ts_blk_txt (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (ftn_table : t_ftn_table) (blk_txt : ts_blk_txt) : t_ftn_table =
        match blk_txt with
        |Cs_blk_txt txt_units -> ftn_table_of_ts_txt_units doc_settings cref_table path ftn_table txt_units



let ftn_table_of_tr_dsp_line (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (ftn_table : t_ftn_table) (dsp_line : tr_dsp_line) : t_ftn_table =
        ftn_table_of_ts_txt_units doc_settings cref_table path ftn_table dsp_line.fld_dsp_line_units


let ftn_string_of_int (n : int) : string =
        symbol_of_array superscript_digits n

let string_of_ts_ftn_ref (doc_settings : t_doc_settings) (ftn_table : t_ftn_table) (path : t_path) (ftn_ref : ts_ftn_ref) : string =
        match ftn_ref with
        |Cs_ftn_ref (id,i) ->
        let rec aux (table : t_ftn_table) : string =
                match table with
                |[] -> let _ : unit = Debug_utils.print_warning (String.concat "" [
                        "WARNING: id \'";string_of_tr_id id;
                        "\' referenced in ";
                        string_of_path doc_settings path;
                        " does not exist or is out of scope.";
                ]) in "??"
                |(Ftn_entry_ref (table_ftn_ref, _, n, _))::tl ->
                        if ftn_ref=table_ftn_ref then ftn_string_of_int n
                        else aux tl
		|hd::tl -> aux tl
        in
        aux ftn_table

let string_of_ts_ftn_inline (doc_settings : t_doc_settings) (ftn_table : t_ftn_table) (path : t_path) (ftn_inline : ts_ftn_inline) : string =
        match ftn_inline with
        |Cs_ftn_inline (_,i) ->
        let rec aux (table : t_ftn_table) : string =
                match table with
                |[] -> let _ : unit = Debug_utils.print_warning (String.concat "" [
                        "WARNING: footnote ";
                        string_of_path doc_settings path;
                        " contains a footnote; nested footnotes are not supported.";
                ]) in "??"
                |(Ftn_entry_inline (Cs_ftn_inline (_,j), _, n))::tl ->
                        if i=j then ftn_string_of_int n
                        else aux tl
		|hd::tl -> aux tl
        in
        aux ftn_table


let ftn_table_of_ts_hdr (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (hdr : ts_hdr) =
        match hdr with
        |Cs_hdr txt_units -> ftn_table_of_ts_txt_units doc_settings cref_table path ([] : t_ftn_table) txt_units

let ftn_table_of_ts_hdr_opt (doc_settings : t_doc_settings) (cref_table : t_cref_table) (path : t_path) (hdr_opt : ts_hdr option) =
        match hdr_opt with
        |None -> []
        |Some hdr -> ftn_table_of_ts_hdr doc_settings cref_table path hdr


(* options *)

type t_txt_options = {
        margin : int option;
        width : int option;
        quiet : bool;
        numbering : string;
        allow_custom_numbering : bool;
}

type t_html_options = {
        margin : int option;
        lang : string;
        css : string list;
        quiet : bool;
        numbering : string;
        allow_custom_numbering : bool;
}

type t_exml_options = {
        quiet : bool;
        numbering : string;
        allow_custom_numbering : bool;
}

let exml_options_of_html_options (html_options : t_html_options) : t_exml_options = {
        quiet = html_options.quiet;
        numbering = html_options.numbering;
        allow_custom_numbering = html_options.allow_custom_numbering;
}

let txt_options_default () : t_txt_options = {
        margin = None;
        width = None;
        quiet = false;
        numbering = "a1i";
        allow_custom_numbering = false;
}

let html_options_default () : t_html_options = {
        margin = None;
        lang = "en";
        css = [];
        quiet = false;
        numbering = "a1i";
        allow_custom_numbering = false;
}

let exml_options_default () : t_exml_options = {
        quiet = false;
        numbering = "a1i";
        allow_custom_numbering = false;
}

