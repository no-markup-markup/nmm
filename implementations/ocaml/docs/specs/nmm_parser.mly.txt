%{
open Doc_types

exception ERROR of string

let scope_of_string (s : string) : tu_scope =
        match s with
        |"GBL" -> Cu_scope_gbl
        |"CH" -> Cu_scope_ch
        |"SEC" -> Cu_scope_sec
        |"PAR" -> Cu_scope_par
        |_ -> raise (ERROR (String.concat "" ["expected GBL, CH, SEC, or PAR, got: ";s]))

let first ((a,b):('a * 'b)):'a = a

let second ((a,b):('a * 'b)):'b = b

let tag_or_id_of_string (s:string):Doc_types.tu_tag_or_id=
        match String.split_on_char ':' s with
        |[tag;name]-> Cu_tag_or_id_id { fld_id_tag = Cs_tag tag; fld_id_name = Cs_name name; fld_id_scope = None }
        |[tag;name;scope]-> Cu_tag_or_id_id { fld_id_tag = Cs_tag tag; fld_id_name = Cs_name name; fld_id_scope = Some (scope_of_string scope) }
        |[tag]-> Cu_tag_or_id_tag (Cs_tag tag)
        |_ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

let id_of_string (s:string):Doc_types.tr_id =
       match String.split_on_char ':' s with
       | [tag;name] -> { fld_id_tag = Cs_tag tag; fld_id_name = Cs_name name; fld_id_scope = None }
       | [tag;name;scope]-> { fld_id_tag = Cs_tag tag; fld_id_name = Cs_name name; fld_id_scope = Some (scope_of_string scope) }
       | _ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

let c_ref_of_string (s:string):Doc_types.ts_c_ref=
        let t:string=String.sub s 1 ((String.length s)-2) in
        match String.split_on_char ':' t with
        |[tag;name] -> Cs_c_ref { fld_id_tag=Cs_tag tag;fld_id_name=Cs_name name;  fld_id_scope = None }
        |[tag;name;scope] -> Cs_c_ref { fld_id_tag=Cs_tag tag;fld_id_name=Cs_name name;  fld_id_scope = Some (scope_of_string scope) }
        | _ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

let ftn_ref_of_string_int ((s,i):string * int) : Doc_types.ts_ftn_ref =
        let t:string=String.sub s 1 ((String.length s)-2) in
        match String.split_on_char ':' t with
        |[tag;name] -> Cs_ftn_ref ({ fld_id_tag=Cs_tag tag; fld_id_name=Cs_name name; fld_id_scope = None }, Cs_int i)
        |[tag;name;scope] -> Cs_ftn_ref ({ fld_id_tag=Cs_tag tag;fld_id_name=Cs_name name;  fld_id_scope = Some (scope_of_string scope) }, Cs_int i)
        | _ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

let add_author (authors_opt : ts_authors option) (author : ts_author) : ts_authors option =
        match authors_opt with
        |None -> Some (Cs_authors [author])
        |Some (Cs_authors (authors : ts_author list)) -> Some (Cs_authors (author::authors))

let get_custom_string (s : string) : string =
        try
        match String.split_on_char '\t' s with
        |[a;_] -> (
                match String.split_on_char '[' a with
                |[_;b] -> (
                        match String.split_on_char ']' b with
                        |lst2 -> String.concat "" lst2
                )
                |_ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))
        )
        |_ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))
        with
        |_ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

let get_id_string (s : string) : string =
        try
        match String.split_on_char '\t' s with
        |[a;b] -> b
        |_ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))
        with
        |_ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

let date_of_string (s : string) : tu_date =
        match s with
        |"auto" -> Cu_date_auto Cs_date_auto
        |_ -> Cu_date_custom (Cs_date_custom s)

%}

%token                          STAR LBR RBR COLON PILCROW SECTION EOF F
%token                          NL TAB NL_TAB NL_TAB_TAB NL_TAB_TAB_TAB
%token                          DASH_TAB ITM_AUTO_TAB DSP_AUTO_TAB PILCROW_NL SECTION_NL SECTION_REFS_NLS PILCROW_REFS_NLS
%token                          START_VRB VRB_LINE_EMPTY END_VRB TAB_END_VRB TAB_TAB_END_VRB TAB_TAB_TAB_END_VRB
%token                          PREAMBLE TITLE AUTHOR DATE ABSTRACT
%token <string>                 VRB_LINE
%token <string>                 ESC_CHAR
%token <string>                 TXT C_REF
%token <string>                 DSP_ID
%token <string>                 CH_TAG_OR_ID_NL SECTION_SPACES_TAG_OR_ID_NL PILCROW_SPACES_TAG_OR_ID_NL PILCROW_SPACES_RPT_SPACES_ID_NL
%token <string>                 ITM_CUSTOM_TAB DSP_CUSTOM_TAB ITM_AUTO_TAB_ID ITM_CUSTOM_TAB_ID STAR_TAB_ID
%token <string * int>           FTN_REF
%token <int>			FTN_LBR

%type <Doc_types.tr_doc>                  main doc

%start main

%%
main:
  | doc EOF                                       { $1 : tr_doc }
  | nls doc EOF                                   { $2 : tr_doc }
;

doc:
  | doc_main                                      {
                                                    {
                                                      fld_doc_preamble = None;
                                                      fld_doc_title = None;
                                                      fld_doc_authors = None;
                                                      fld_doc_date = None;
                                                      fld_doc_abstract = None;
                                                      fld_doc_main = $1;
                                                      fld_doc_refs = None;
                                                    } : tr_doc 
                                                  }
  | doc_preamble nls doc                          {
                                                    {
                                                      fld_doc_preamble = Some $1;
                                                      fld_doc_title = $3.fld_doc_title;
                                                      fld_doc_authors = $3.fld_doc_authors;
                                                      fld_doc_date = $3.fld_doc_date;
                                                      fld_doc_abstract = $3.fld_doc_abstract;
                                                      fld_doc_main = $3.fld_doc_main;
                                                      fld_doc_refs = $3.fld_doc_refs; 
                                                    } : tr_doc 
                                                  }
  | doc_title nls doc                             { 
                                                    {
                                                      fld_doc_preamble = $3.fld_doc_preamble;
                                                      fld_doc_title = Some $1;
                                                      fld_doc_authors = $3.fld_doc_authors;
                                                      fld_doc_date = $3.fld_doc_date;
                                                      fld_doc_abstract = $3.fld_doc_abstract;
                                                      fld_doc_main = $3.fld_doc_main;
                                                      fld_doc_refs = $3.fld_doc_refs;
                                                    } : tr_doc 
                                                   }
  | doc_author nls doc                            {
                                                    {
                                                      fld_doc_preamble = $3.fld_doc_preamble;
                                                      fld_doc_title = $3.fld_doc_title;
                                                      fld_doc_authors = add_author $3.fld_doc_authors $1;
                                                      fld_doc_date = $3.fld_doc_date;
                                                      fld_doc_abstract = $3.fld_doc_abstract;
                                                      fld_doc_main = $3.fld_doc_main;
                                                      fld_doc_refs = $3.fld_doc_refs;
                                                    } : tr_doc 
                                                   }
  | doc_date nls doc                              {
                                                    {
                                                      fld_doc_preamble = $3.fld_doc_preamble;
                                                      fld_doc_title = $3.fld_doc_title;
                                                      fld_doc_authors = $3.fld_doc_authors;
                                                      fld_doc_date = Some $1;
                                                      fld_doc_abstract = $3.fld_doc_abstract;
                                                      fld_doc_main = $3.fld_doc_main;
                                                      fld_doc_refs = $3.fld_doc_refs;
                                                    } : tr_doc 
                                                   }
  | doc_abstract nls doc                             {
                                                    {
                                                      fld_doc_preamble = $3.fld_doc_preamble;
                                                      fld_doc_title = $3.fld_doc_title;
                                                      fld_doc_authors = $3.fld_doc_authors;
                                                      fld_doc_date = $3.fld_doc_date;
                                                      fld_doc_abstract = Some $1;
                                                      fld_doc_main = $3.fld_doc_main;
                                                      fld_doc_refs = $3.fld_doc_refs;
                                                    } : tr_doc 
                                                   }
  | doc_main doc_refs                              {
                                                    {
                                                      fld_doc_preamble = None;
                                                      fld_doc_title = None;
                                                      fld_doc_authors = None;
                                                      fld_doc_date = None;
                                                      fld_doc_abstract = None;
                                                      fld_doc_main = $1;
                                                      fld_doc_refs = Some $2;
                                                    } : tr_doc 
                                                   }
;


doc_preamble:
  | PREAMBLE TAB preamble_lines                   { (Cs_preamble $3) : ts_preamble }
  | PREAMBLE NL_TAB preamble_lines                { (Cs_preamble $3) : ts_preamble }
;

doc_title:
  | TITLE TAB lines                               { (Cs_title $3) : ts_title }
  | TITLE NL_TAB lines                            { (Cs_title $3) : ts_title }
;

doc_author:
  | AUTHOR TAB lines                              { (Cs_author $3) : ts_author }
  | AUTHOR NL_TAB lines                           { (Cs_author $3) : ts_author }
;

doc_date:
  | DATE TAB lines                              { (date_of_string $3) : tu_date }
  | DATE NL_TAB lines                           { (date_of_string $3) : tu_date }
;

doc_abstract:
  | ABSTRACT TAB blks1                            { (Cs_abstract (Cs_blks $3)) : ts_abstract }
  | ABSTRACT lb1 blks1                            { (Cs_abstract (Cs_blks $3)) : ts_abstract }
;

doc_refs:
  | SECTION_REFS_NLS blks0                        { (Cs_refs (Cs_blks $2)) : ts_refs }
  | PILCROW_REFS_NLS blks0                        { (Cs_refs (Cs_blks $2)) : ts_refs }
;

lines:
  | txt                                           { $1 : string }
  | txt lines                                     { ($1 ^ $2) : string }
  | txt NL_TAB lines                              { ($1 ^ " " ^ $3) : string }
;

preamble_lines:
  | txt                                           { $1 : string }
  | txt preamble_lines                            { ($1 ^ $2) : string }
  | txt NL_TAB preamble_lines                     { ($1 ^ ";" ^ $3) : string }
;

doc_main:
  |chs                                            { (Cu_doc_main_chs (Cs_chs $1)):tu_doc_main }
  |secs                                           { (Cu_doc_main_secs (Cs_secs $1)):tu_doc_main }
  |pars                                           { (Cu_doc_main_pars (Cs_pars $1)):tu_doc_main }
  |blks0                                          { (Cu_doc_main_blks (Cs_blks $1)):tu_doc_main }
;

chs:
  |ch                                             { ($1::[]):tr_ch list }
  |ch chs                                         { ($1::$2):tr_ch list }
;

secs:
  |sec                                            { ($1::[]):tr_sec list }
  |sec secs                                       { ($1::$2):tr_sec list }
;

ch:
  |ch_nl ch_main                                  { {fld_ch_tag_or_id=Some $1;fld_ch_hdr=None;fld_ch_main=$2}:tr_ch }
  |ch_nl hdr ch_main                              { {fld_ch_tag_or_id=Some $1;fld_ch_hdr=Some $2;fld_ch_main=$3}:tr_ch }
;

ch_main:
  |nls secs                                       { (Cu_secs_pars_or_blks_secs (Cs_secs $2)):tu_secs_pars_or_blks }
  |nls pars                                       { (Cu_secs_pars_or_blks_pars (Cs_pars $2)):tu_secs_pars_or_blks }
  |nls blks                                       { (Cu_secs_pars_or_blks_blks $2):tu_secs_pars_or_blks }
  |special_blks                                   { (Cu_secs_pars_or_blks_blks $1):tu_secs_pars_or_blks }
  |nls special_blks                               { (Cu_secs_pars_or_blks_blks $2):tu_secs_pars_or_blks }
;

sec:
  |section_nl sec_main                            { {fld_sec_tag_or_id=None;fld_sec_hdr=None;fld_sec_main=$2}:tr_sec }
  |section_spaces_tag_or_id_nl sec_main           { {fld_sec_tag_or_id=Some $1;fld_sec_hdr=None;fld_sec_main=$2}:tr_sec }
  |section_nl hdr sec_main                        { {fld_sec_tag_or_id=None;fld_sec_hdr=Some $2;fld_sec_main=$3}:tr_sec }
  |section_spaces_tag_or_id_nl hdr sec_main       { {fld_sec_tag_or_id=Some $1;fld_sec_hdr=Some $2;fld_sec_main=$3}:tr_sec }
;

sec_main:
  |nls pars                                       { (Cu_pars_or_blks_pars (Cs_pars $2)):tu_pars_or_blks }
  |nls blks                                       { (Cu_pars_or_blks_blks $2):tu_pars_or_blks }
  |special_blks                                   { (Cu_pars_or_blks_blks $1):tu_pars_or_blks }
  |nls special_blks                               { (Cu_pars_or_blks_blks $2):tu_pars_or_blks }
;

pars:
  |par                                            { ($1::[]):tu_par list }
  |par pars                                       { ($1::$2):tu_par list }
;

par:
  |pilcrow_nl par_main                            { Cu_par_std {fld_par_tag_or_id=None;fld_par_hdr=None;fld_par_main=$2}:tu_par }
  |pilcrow_spaces_tag_or_id_nl par_main           { Cu_par_std {fld_par_tag_or_id=Some $1;fld_par_hdr=None;fld_par_main=$2}:tu_par }
  |pilcrow_nl hdr par_main                        { Cu_par_std {fld_par_tag_or_id=None;fld_par_hdr=Some $2;fld_par_main=$3}:tu_par }
  |pilcrow_spaces_tag_or_id_nl hdr par_main       { Cu_par_std {fld_par_tag_or_id=Some $1;fld_par_hdr=Some $2;fld_par_main=$3}:tu_par }
  |pilcrow_spaces_rpt_spaces_id_nl nls            { Cu_par_rpt $1 : tu_par }
;

par_main:
  |nls blks                                       { $2:ts_blks }
  |special_blks                                   { $1:ts_blks }
  |nls special_blks                               { $2:ts_blks }
;

blks:
  |blks0                                         { Cs_blks $1 : ts_blks }
;

special_blks:
  |lb1 special_blk_dsp0                          { (Cs_blks ((Cu_blk_dsp $2)::[])):ts_blks }
  |lb1 special_blk_dsp0 NL blks0                 { (Cs_blks ((Cu_blk_dsp $2)::$4)):ts_blks }
;


(* Level 0: *)

blks0:
  |blk0 lb0                                       { ($1::[]):tu_blk list }
  |blk0 lb0 blks0                                 { ($1::$3):tu_blk list }
  |special_blks0                                  { $1:tu_blk list }
;

special_blks0:
  |blk_txt0 lb1 special_blk_dsp0  lb0             { [Cu_blk_txt $1;Cu_blk_dsp $3]:tu_blk list }
  |blk_txt0 lb1 special_blk_dsp0  lb0 blks0       { ((Cu_blk_txt $1)::((Cu_blk_dsp $3)::$5)):tu_blk list }
;

blk0:
  |blk_txt0                                       { Cu_blk_txt $1:tu_blk }
  |blk_blt0                                       { Cu_blk_blt $1:tu_blk }
  |blk_itm0                                       { Cu_blk_itm $1:tu_blk }
  |blk_dsp0                                       { Cu_blk_dsp $1:tu_blk }
  |blk_vrb0                                       { Cu_blk_vrb $1:tu_blk }
  |blk_ftn0                                       { Cu_blk_ftn $1:tu_blk }
  |blk0 NL                                        { $1 : tu_blk }
;

blk_txt0:
  |txt_units0                                     { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units0:
  |txt_unit0 lb0                                  { ($1::[]):tu_txt_unit list }
  |txt_unit0 txt_units0                           { ($1::$2):tu_txt_unit list }
  |txt_unit0 lb0 txt_units0                       { ($1::((Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):tu_txt_unit list }
;

txt_unit0:
  |txt                                            { (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):tu_txt_unit }
  |STAR emph_txt0 STAR                            { (Cu_txt_unit_emph (Cs_txt_unit_emph $2)):tu_txt_unit }   
  |c_ref                                          { (Cu_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):tu_txt_unit }
  |ftn_ref                                        { (Cu_txt_unit_ftn_ref (Cs_txt_unit_ftn_ref $1)):tu_txt_unit }
  |ftn_inline0                                    { (Cu_txt_unit_ftn_inline (Cs_txt_unit_ftn_inline $1)):tu_txt_unit }
;

ftn_inline0:
  |ftn_inline_short                               { $1 : ts_ftn_inline}
  |ftn_inline_long0                               { $1 : ts_ftn_inline}
;

ftn_inline_long0:
  |FTN_LBR lb1 blks1 RBR                          { Cs_ftn_inline (Cs_blks $3, Cs_int $1) : ts_ftn_inline}
;

emph_txt0:
  |emph_txt                                       { $1:string }
  |emph_txt lb0 emph_txt0                         { ($1 ^ " " ^ $3):string }
 ;


blk_blt0:
  |dash_tab blks1                                 { (Cs_blk_blt (Cs_blks $2)):ts_blk_blt }
;

blk_ftn0:
  |star_tab_id lb1 blks1                          { { fld_blk_ftn_id=$1; fld_blk_ftn_main=Cs_blks $3} : tr_blk_ftn }
;


blk_itm0:
  |itm_lbl_tab blks1                              { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $2}:tr_blk_itm }
  |itm_lbl_tab lb1 blks1                          { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
  |itm_lbl_tab_id lb1 blks1                       { {fld_blk_itm_lbl=first $1;fld_blk_itm_id=Some (second $1);fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
;

blk_dsp0:
  |dsp_lines0                                     { (Cs_blk_dsp (Cs_dsp_lines $1)):ts_blk_dsp }
;

special_blk_dsp0:
  |special_dsp_lines0                             { (Cs_blk_dsp (Cs_dsp_lines $1)):ts_blk_dsp }
  |special_blk_dsp0 NL                            { $1 : ts_blk_dsp }
;

dsp_lines0:
  |dsp_line lb0                                   { ($1::[]):tr_dsp_line list }
  |dsp_line lb0 dsp_lines0                        { ($1::$3):tr_dsp_line list }
  |dsp_line lb1 special_dsp_lines0                { ($1::$3):tr_dsp_line list }
;

special_dsp_lines0:
  |special_dsp_line lb0                           { ($1::[]):tr_dsp_line list }
  |special_dsp_line lb1 special_dsp_lines0        { ($1::$3):tr_dsp_line list }
  |special_dsp_line lb0 dsp_lines0                { ($1::$3):tr_dsp_line list }
;

blk_vrb0:
  |START_VRB vrb_lines0 END_VRB                   { (Cs_blk_vrb (Cs_vrb_lines $2)):ts_blk_vrb }
;

vrb_lines0:
  |vrb_line0                                      { ($1::[]) : ts_vrb_line list }
  |vrb_line0 vrb_lines0                           { ($1::$2) : ts_vrb_line list }
;

vrb_line0:
  |VRB_LINE NL                                    { Cs_vrb_line $1 : ts_vrb_line }
  |VRB_LINE_EMPTY                                 { Cs_vrb_line "" : ts_vrb_line }
;

lb0:
  |NL                                             { }
;

(* General recipe for n>0:

blks(n):
  |blk(n)                                                 { ($1::[]):tu_blk list }
  |blk(n) lb(n) blks(n)                                   { ($1::$3):tu_blk list }
  |special_blks(n)                                        { $1:tu_blk list }
;

special_blks(n):
  |blk_txt(n) lb(n+1) special_blk_dsp(n)                  { [Cu_blk_txt $1;Cu_blk_dsp $3]:tu_blk list }
  |blk_txt(n) lb(n+1) special_blk_dsp(n)  lb(n) blks(n)   { (Cu_blk_txt $1::((Cu_blk_dsp $3)::$5)):tu_blk list }
;

blk(n):
  |blk_txt(n)                                             { (Cu_blk_txt $1):tu_blk }
  |blk_blt(n)                                             { (Cu_blk_blt $1):tu_blk }
  |blk_itm(n)                                             { (Cu_blk_itm $1):tu_blk }
  |blk_dsp(n)                                             { (Cu_blk_dsp $1):tu_blk }
  |blk_vrb(n)                                             { (Cu_blk_vrb $1):tu_blk }
  |NL blk(n)                                              { $2:tu_blk }
;

blk_txt(n):
  |txt_units(n)                                           { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units(n):
  |txt_unit(n) lb0                                        { ($1::[]):tu_txt_unit list }
  |txt_unit(n) txt_units(n)                               { ($1::$2):tu_txt_unit list }
  |txt_unit(n) lb(n) txt_units(n)                         { ($1::((Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):tu_txt_unit list }
;

txt_unit(n):
  |txt                                                    { (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):tu_txt_unit }
  |STAR emph_txt(n) STAR                                  { (Cu_txt_unit_emph (Cs_txt_unit_emph $2)):tu_txt_unit }
  |LBR crefs RBR                                          { (Cu_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):tu_txt_unit }
;

emph_txt(n):
  |emph_txt                                               { $1:string }
  |emph_txt lb(n) emph_txt(n)                             { ($1 ^ " " ^ $3):string }
;

blk_blt(n):
  |dash_tab blks(n+1)                                     { (Cs_blk_blt (Cs_blks $2)):ts_blk_blt }
;

blk_itm(n):
  |itm_lbl_tab blks(n+1)                                  { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $2}:tr_blk_itm }
  |itm_lbl_tab lb(n+1) blks(n+1)                          { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
  |itm_lbl_tab itm_id lb(n+1) blks(n+1)                   { {fld_blk_itm_lbl=$1;fld_blk_itm_id=Some $2;fld_blk_itm_main=Cs_blks $4}:tr_blk_itm }
;

blk_dsp(n):
  |dsp_lines(n)                                           { (Cs_blk_dsp (Cs_dsp_lines $1)):ts_blk_dsp }
;

special_blk_dsp(n):
  |special_dsp_lines(n)                                   { (Cs_blk_dsp (Cs_dsp_lines $1)):ts_blk_dsp }
;

dsp_lines(n):
  |dsp_line lb0                                           { ($1::[]):tr_dsp_line list }
  |dsp_line lb(n) dsp_lines(n)                            { ($1::$3):tr_dsp_line list }
  |dsp_line lb(n+1) special_dsp_lines(n)                  { ($1::$3):tr_dsp_line list }
;

special_dsp_lines(n):
  |special_dsp_line lb0                                   { ($1::[]):tr_dsp_line list }
  |special_dsp_line lb(n+1) special_dsp_lines(n)          { ($1::$3):tr_dsp_line list }
  |special_dsp_line lb(n) dsp_lines(n)                    { ($1::$3):tr_dsp_line list }
;

blk_vrb(n):
  |START_VRB vrb_lines(n) end_vrb(n)                      { (Cs_blk_vrb (Cs_vrb_lines $2)):ts_blk_vrb }
;

vrb_lines(n):
  |vrb_line(n)                                            { ($1::[]) : ts_vrb_line list }
  |vrb_line(n) vrb_lines(n)                               { ($1::$2) : ts_vrb_line list }
;

vrb_line(n):
  |tab(n) VRB_LINE NL                                     { Cs_vrb_line $2 : ts_vrb_line }
  |VRB_LINE_EMPTY                                         { Cs_vrb_line "" : ts_vrb_line }
;

end_vrb(n):
  |TAB_end_vrb(n-1)                                       { }
;

tab(n):
  |tab(n-1)_TAB                                           { }
;

lb(n):
  |lb(n-1)_TAB                                            { }
;
*)

(* Level 1: *)

blks1:
  |blk1                                           { ($1::[]):tu_blk list }
  |blk1 lb1 blks1                                 { ($1::$3):tu_blk list }
  |special_blks1                                  { $1:tu_blk list }
;

special_blks1:
  |blk_txt1 lb2 special_blk_dsp1                  { [Cu_blk_txt $1;Cu_blk_dsp $3]:tu_blk list }
  |blk_txt1 lb2 special_blk_dsp1  lb1 blks1       { ((Cu_blk_txt $1)::((Cu_blk_dsp $3)::$5)):tu_blk list }
;

blk1:
  |blk_txt1                                       { (Cu_blk_txt $1):tu_blk }
  |blk_blt1                                       { (Cu_blk_blt $1):tu_blk }
  |blk_itm1                                       { (Cu_blk_itm $1):tu_blk }
  |blk_dsp1                                       { (Cu_blk_dsp $1):tu_blk }
  |blk_vrb1                                       { (Cu_blk_vrb $1):tu_blk }
  |NL blk1                                        { $2:tu_blk }
;

blk_txt1:
  |txt_units1                                     { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units1:
  |txt_unit1 lb0                                  { ($1::[]):tu_txt_unit list }
  |txt_unit1 txt_units1                           { ($1::$2):tu_txt_unit list }
  |txt_unit1 lb1 txt_units1                       { ($1::((Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):tu_txt_unit list }
;


txt_unit1:
  |txt                                            { (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):tu_txt_unit }
  |STAR emph_txt1 STAR                            { (Cu_txt_unit_emph (Cs_txt_unit_emph $2)):tu_txt_unit }
  |c_ref                                          { (Cu_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):tu_txt_unit }
  |ftn_ref                                        { (Cu_txt_unit_ftn_ref (Cs_txt_unit_ftn_ref $1)):tu_txt_unit }
  |ftn_inline1                                    { (Cu_txt_unit_ftn_inline (Cs_txt_unit_ftn_inline $1)):tu_txt_unit }
;

ftn_inline1:
  |ftn_inline_short                               { $1 : ts_ftn_inline}
  |ftn_inline_long1                               { $1 : ts_ftn_inline}
;

ftn_inline_long1:
  |FTN_LBR lb2 blks2 RBR                          { Cs_ftn_inline (Cs_blks $3, Cs_int $1) : ts_ftn_inline}
;

emph_txt1:
  |emph_txt                                       { $1:string }
  |emph_txt lb1 emph_txt1                         { ($1 ^ " " ^ $3):string }
;

blk_blt1:
  |dash_tab blks2                                 { (Cs_blk_blt (Cs_blks $2)):ts_blk_blt }
;

blk_itm1:
  |itm_lbl_tab blks2                              { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $2}:tr_blk_itm }
  |itm_lbl_tab lb2 blks2                          { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
  |itm_lbl_tab_id lb2 blks2                       { {fld_blk_itm_lbl=first $1;fld_blk_itm_id=Some (second $1);fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
;

blk_dsp1:
  |dsp_lines1                                     { (Cs_blk_dsp (Cs_dsp_lines $1)):ts_blk_dsp }
;

special_blk_dsp1:
  |special_dsp_lines1                             { (Cs_blk_dsp (Cs_dsp_lines $1)):ts_blk_dsp }
;

dsp_lines1:
  |dsp_line lb0                                   { ($1::[]):tr_dsp_line list }
  |dsp_line lb1 dsp_lines1                        { ($1::$3):tr_dsp_line list }
  |dsp_line lb2 special_dsp_lines1                { ($1::$3):tr_dsp_line list }
;

special_dsp_lines1:
  |special_dsp_line lb0                           { ($1::[]):tr_dsp_line list }
  |special_dsp_line lb2 special_dsp_lines1        { ($1::$3):tr_dsp_line list }
  |special_dsp_line lb1 dsp_lines1                { ($1::$3):tr_dsp_line list }
;

blk_vrb1:
  |START_VRB vrb_lines1 end_vrb1                  { (Cs_blk_vrb (Cs_vrb_lines $2)):ts_blk_vrb }
;

vrb_lines1:
  |vrb_line1                                      { ($1::[]) : ts_vrb_line list }
  |vrb_line1 vrb_lines1                           { ($1::$2) : ts_vrb_line list }
;

vrb_line1:
  |tab1 VRB_LINE NL                               { Cs_vrb_line $2 : ts_vrb_line }
  |VRB_LINE_EMPTY                                 { Cs_vrb_line "" : ts_vrb_line }
;

end_vrb1:
  |TAB_END_VRB                                    { }
;

tab1:
  |TAB                                            { }
;

lb1:
  |NL_TAB                                         { }
;

(* Level 2: *)

blks2:
  |blk2                                           { ($1::[]):tu_blk list }
  |blk2 lb2 blks2                                 { ($1::$3):tu_blk list }
  |special_blks2                                  { $1:tu_blk list }
;

special_blks2:
  |blk_txt2 lb3 special_blk_dsp2                  { [Cu_blk_txt $1;Cu_blk_dsp $3]:tu_blk list }
  |blk_txt2 lb3 special_blk_dsp2  lb2 blks2       { ((Cu_blk_txt $1)::((Cu_blk_dsp $3)::$5)):tu_blk list }
;

blk2:
  |blk_txt2                                       { (Cu_blk_txt $1):tu_blk }
  |blk_blt2                                       { (Cu_blk_blt $1):tu_blk }
  |blk_itm2                                       { (Cu_blk_itm $1):tu_blk }
  |blk_dsp2                                       { (Cu_blk_dsp $1):tu_blk }
  |blk_vrb2                                       { (Cu_blk_vrb $1):tu_blk }
  |NL blk2                                        { $2:tu_blk }
;

blk_txt2:
  |txt_units2                                     { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units2:
  |txt_unit2 lb0                                  { ($1::[]):tu_txt_unit list }
  |txt_unit2 txt_units2                           { ($1::$2):tu_txt_unit list }
  |txt_unit2 lb2 txt_units2                       { ($1::((Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):tu_txt_unit list }
;


txt_unit2:
  |txt                                            { (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):tu_txt_unit }
  |STAR emph_txt2 STAR                            { (Cu_txt_unit_emph (Cs_txt_unit_emph $2)):tu_txt_unit }   
  |c_ref                                          { (Cu_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):tu_txt_unit }
  |ftn_ref                                        { (Cu_txt_unit_ftn_ref (Cs_txt_unit_ftn_ref $1)):tu_txt_unit }
;

emph_txt2:
  |emph_txt                                       { $1:string }
  |emph_txt lb2 emph_txt2                         { ($1 ^ " " ^ $3):string }
;

blk_blt2:
  |dash_tab blks3                                 { (Cs_blk_blt (Cs_blks $2)):ts_blk_blt }
;

blk_itm2:
  |itm_lbl_tab blks3                              { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $2}:tr_blk_itm }
  |itm_lbl_tab lb3 blks3                          { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
  |itm_lbl_tab_id lb3 blks3                       { {fld_blk_itm_lbl=first $1;fld_blk_itm_id=Some (second $1);fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
;

blk_dsp2:
  |dsp_lines2                                     { (Cs_blk_dsp (Cs_dsp_lines $1)):ts_blk_dsp }
;

special_blk_dsp2:
  |special_dsp_lines2                             { (Cs_blk_dsp (Cs_dsp_lines $1)):ts_blk_dsp }

;
dsp_lines2:
  |dsp_line lb0                                   { ($1::[]):tr_dsp_line list }
  |dsp_line lb2 dsp_lines2                        { ($1::$3):tr_dsp_line list }
  |dsp_line lb3 special_dsp_lines2                { ($1::$3):tr_dsp_line list }
;

special_dsp_lines2:
  |special_dsp_line lb0                           { ($1::[]):tr_dsp_line list }
  |special_dsp_line lb3 special_dsp_lines2        { ($1::$3):tr_dsp_line list }
  |special_dsp_line lb2 dsp_lines2                { ($1::$3):tr_dsp_line list }
;

blk_vrb2:
  |START_VRB vrb_lines2 end_vrb2                  { (Cs_blk_vrb (Cs_vrb_lines $2)):ts_blk_vrb }
;

vrb_lines2:
  |vrb_line2                                      { ($1::[]) : ts_vrb_line list }
  |vrb_line2 vrb_lines2                           { ($1::$2) : ts_vrb_line list }
;

vrb_line2:
  |tab2 VRB_LINE NL                               { Cs_vrb_line $2 : ts_vrb_line }
  |VRB_LINE_EMPTY                                 { Cs_vrb_line "" : ts_vrb_line }
;

end_vrb2:
  |TAB_TAB_END_VRB                                { }
;

tab2:
  |TAB TAB                                        { }
;

lb2:
  |NL_TAB_TAB                                     { }
;

(* Level 3: *)

blks3:
  |blk3                                           { ($1::[]):tu_blk list }
  |blk3 lb3 blks3                                 { ($1::$3):tu_blk list }
;

blk3:
  |blk_txt3                                       { (Cu_blk_txt $1):tu_blk }
  |blk_vrb3                                       { (Cu_blk_vrb $1):tu_blk }
  (* et cetera *)
  |NL blk3                                        { $2:tu_blk }
;

blk_txt3:
  |txt_units3                                     { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units3:
  |txt_unit3 lb0                                  { ($1::[]):tu_txt_unit list }
  |txt_unit3 txt_units3                           { ($1::$2):tu_txt_unit list }
  |txt_unit3 lb3 txt_units3                       { ($1::((Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):tu_txt_unit list }
;

txt_unit3:
  |txt                                            { (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):tu_txt_unit }
  |STAR emph_txt3 STAR                            { (Cu_txt_unit_emph (Cs_txt_unit_emph $2)):tu_txt_unit }   
  |c_ref                                          { (Cu_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):tu_txt_unit }
  |ftn_ref                                        { (Cu_txt_unit_ftn_ref (Cs_txt_unit_ftn_ref $1)):tu_txt_unit }
;

emph_txt3:
  |emph_txt                                       { $1:string }
  |emph_txt lb3 emph_txt3                         { ($1 ^ " " ^ $3):string }
;

blk_vrb3:
  |START_VRB vrb_lines3 end_vrb3                  { (Cs_blk_vrb (Cs_vrb_lines $2)):ts_blk_vrb }
;

vrb_lines3:
  |vrb_line3                                      { ($1::[]) : ts_vrb_line list }
  |vrb_line3 vrb_lines3                           { ($1::$2) : ts_vrb_line list }
;

vrb_line3:
  |tab3 VRB_LINE NL                               { Cs_vrb_line $2 : ts_vrb_line }
  |VRB_LINE_EMPTY                                 { Cs_vrb_line "" : ts_vrb_line }
;

end_vrb3:
  |TAB_TAB_TAB_END_VRB                            { }
;

tab3:
  |TAB TAB TAB                                    { }
;

lb3:
  |NL_TAB_TAB_TAB                                 { }
;

(* Common to all levels: *)

dsp_line:
  |dsp_lbl_tab dsp_units                          { {fld_dsp_line_lbl=Some $1;fld_dsp_line_id=None;fld_dsp_line_units=Cs_txt_units $2}:tr_dsp_line }
  |dsp_lbl_tab dsp_units tabs dsp_id              { {fld_dsp_line_lbl=Some $1;fld_dsp_line_id=Some $4;fld_dsp_line_units=Cs_txt_units $2}:tr_dsp_line }
;

special_dsp_line:
  |dsp_units                                      { {fld_dsp_line_lbl=None;fld_dsp_line_id=None;fld_dsp_line_units=Cs_txt_units $1}:tr_dsp_line }
;

dsp_units:
  |dsp_unit                                       { ($1::[]):tu_txt_unit list }
  |dsp_unit dsp_units                             { ($1::$2):tu_txt_unit list }
;

dsp_unit:
  |txt                                            { (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):tu_txt_unit }
  |STAR emph_txt STAR                             { (Cu_txt_unit_emph (Cs_txt_unit_emph $2)):tu_txt_unit }   
  |c_ref                                          { (Cu_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):tu_txt_unit }
;

ftn_inline_short:
  |FTN_LBR blk_txt_ftn RBR                        { Cs_ftn_inline (Cs_blks [Cu_blk_txt $2], Cs_int $1) : ts_ftn_inline}
;

blk_txt_ftn:
  |txt_units_ftn                                  { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units_ftn:
  |txt_unit_ftn                                   { ($1::[]):tu_txt_unit list }
  |txt_unit_ftn txt_units_ftn                     { ($1::$2):tu_txt_unit list }
;

txt_unit_ftn:
  |txt_ftn                                        { (Cu_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):tu_txt_unit }
  |STAR emph_txt_ftn STAR                         { (Cu_txt_unit_emph (Cs_txt_unit_emph $2)):tu_txt_unit }
  |c_ref                                          { (Cu_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):tu_txt_unit }
;


txt:
  |TXT                                            { $1:string }
  |COLON                                          { ":":string }
  |LBR                                            { "[":string }
  |RBR                                            { "]":string }
  |PILCROW                                        { "¶":string }
  |SECTION                                        { "§":string }
  |PREAMBLE                                       { "PREAMBLE":string }
  |TITLE                                          { "TITLE":string }
  |AUTHOR                                         { "AUTHOR":string }
  |DATE                                           { "DATE":string }
  |ABSTRACT                                       { "ABSTRACT":string }
  |ESC_CHAR                                       { $1:string }
  |F                                              { "F":string }
;

txt_ftn:
  |TXT                                            { $1:string }
  |COLON                                          { ":":string }
  |LBR                                            { "[":string }
  |PILCROW                                        { "¶":string }
  |SECTION                                        { "§":string }
  |PREAMBLE                                       { "PREAMBLE":string }
  |TITLE                                          { "TITLE":string }
  |AUTHOR                                         { "AUTHOR":string }
  |DATE                                           { "DATE":string }
  |ABSTRACT                                       { "ABSTRACT":string }
  |ESC_CHAR                                       { $1:string }
  |F                                              { "F":string }
;

emph_txt:
  |txt                                            { $1:string }
  |txt emph_txt                                   { ($1 ^ $2):string }
;

emph_txt_ftn:
  |txt_ftn                                        { $1:string }
  |txt_ftn emph_txt_ftn                           { ($1 ^ $2):string }
;

c_ref:
  |C_REF                                          { (c_ref_of_string $1):ts_c_ref }
;

ftn_ref:
  |FTN_REF                                        { (ftn_ref_of_string_int $1):ts_ftn_ref }
;

dsp_id:
  |DSP_ID                                         { (id_of_string $1):tr_id }
;

ch_nl:
  |CH_TAG_OR_ID_NL                                { tag_or_id_of_string $1 }
;

section_nl:
  |SECTION_NL                                     { }
;

section_spaces_tag_or_id_nl:
  |SECTION_SPACES_TAG_OR_ID_NL                    { (tag_or_id_of_string $1):tu_tag_or_id }
;

pilcrow_nl:
  |PILCROW_NL                                     { }
;

pilcrow_spaces_tag_or_id_nl:
  |PILCROW_SPACES_TAG_OR_ID_NL                    { (tag_or_id_of_string $1):tu_tag_or_id }
;

pilcrow_spaces_rpt_spaces_id_nl:
  |PILCROW_SPACES_RPT_SPACES_ID_NL                { Cs_par_rpt (id_of_string $1):ts_par_rpt }
;

hdr:
  |txt_units0                                     { (Cs_hdr (Cs_txt_units $1)):ts_hdr }
;

dsp_lbl_tab:
  |dsp_auto_tab                                   { (Cu_lbl_auto $1):tu_lbl }
  |dsp_custom_tab                                 { (Cu_lbl_custom $1):tu_lbl }
;

dsp_auto_tab:
  |DSP_AUTO_TAB                                   { Cs_lbl_auto:ts_lbl_auto }
;

dsp_custom_tab:
  |DSP_CUSTOM_TAB                                 { Cs_lbl_custom $1:ts_lbl_custom }
;

itm_lbl_tab:
  |itm_auto_tab                                   { (Cu_lbl_auto $1):tu_lbl }
  |itm_custom_tab                                 { (Cu_lbl_custom $1):tu_lbl }
;

itm_lbl_tab_id:
  |itm_auto_tab_id                                { (Cu_lbl_auto (first $1), second $1): tu_lbl * tr_id }
  |itm_custom_tab_id                              { (Cu_lbl_custom (first $1), second $1): tu_lbl * tr_id }
;

itm_auto_tab:
  |ITM_AUTO_TAB                                   { Cs_lbl_auto:ts_lbl_auto }
;

itm_custom_tab:
  |ITM_CUSTOM_TAB                                 { (Cs_lbl_custom $1):ts_lbl_custom }
;

itm_auto_tab_id:
  |ITM_AUTO_TAB_ID                                { (Cs_lbl_auto, id_of_string (get_id_string $1)): ts_lbl_auto * tr_id }
;

itm_custom_tab_id:
  |ITM_CUSTOM_TAB_ID                              { (Cs_lbl_custom (get_custom_string $1), id_of_string (get_id_string $1)): ts_lbl_custom * tr_id }
;

dash_tab:
  |DASH_TAB                                       { }
;

star_tab_id:
  |STAR_TAB_ID                                    { id_of_string (get_id_string $1) : tr_id }
;

tabs:
  |TAB                                            { }
  |tabs TAB                                       { }
;

nls:
  |NL                                             { }
  |NL nls                                         { }
;

