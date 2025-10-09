%{
open Doc_types

exception ERROR of string

let tag_or_id_of_string (s:string):Doc_types.te_tag_or_id=
        match String.split_on_char ':' s with
        |[tag;name]-> Ce_tag_or_id_id { fld_id_tag = Cs_tag tag; fld_id_name = Cs_name name }
        |[tag]-> Ce_tag_or_id_tag (Cs_tag tag)
        |_ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

let id_of_string (s:string):Doc_types.tr_id =
       match String.split_on_char ':' s with
       | [tag;name] -> { fld_id_tag = Cs_tag tag; fld_id_name = Cs_name name }
       | _ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

let c_ref_of_string (s:string):Doc_types.ts_c_ref=
        let t:string=String.sub s 1 ((String.length s)-2) in
        match String.split_on_char ':' t with
        |[tag;name] -> Cs_c_ref { fld_id_tag=Cs_tag tag;fld_id_name=Cs_name name }
        | _ -> raise (ERROR (String.concat "" ["unexpected string:";" ";"\"";s;"\""]))

%}

%token                          STAR LBR RBR COLON PILCROW SECTION EOF
%token                          NL TAB NL_TAB NL_TAB_TAB NL_TAB_TAB_TAB
%token                          DASH_TAB ITM_AUTO_TAB DSP_AUTO_TAB PILCROW_NL SECTION_NL
%token <string>                 TITLE AUTHOR PREAMBLE
%token <string>                 TXT C_REF
%token <string>                 ITM_ID DSP_ID
%token <string>                 SECTION_SPACES_TAG_OR_ID_NL PILCROW_SPACES_TAG_OR_ID_NL
%token <string>                 ITM_CUSTOM_TAB DSP_CUSTOM_TAB  

%type <Doc_types.tr_doc>                  main doc
%type <Doc_types.ts_preamble>             doc_preamble
%type <Doc_types.ts_title>                doc_title
%type <Doc_types.ts_author>               doc_author
%type <string>                            lines
%type <Doc_types.te_doc_main>             doc_main
%type <Doc_types.tr_sec>                  sec
%type <Doc_types.te_pars_or_blks>         sec_main
%type <Doc_types.tr_sec list>             secs
%type <Doc_types.tr_par>                  par
%type <Doc_types.ts_blks>                 par_main
%type <Doc_types.tr_par list>             pars
%type <Doc_types.te_blk>                  blk0 blk1 blk2 blk3
%type <Doc_types.ts_blk_blt>              blk_blt0 blk_blt1 blk_blt2
%type <Doc_types.ts_blk_dsp>              blk_dsp0 blk_dsp1 blk_dsp2 special_blk_dsp0 special_blk_dsp1 special_blk_dsp2
%type <Doc_types.tr_blk_itm>              blk_itm0 blk_itm1 blk_itm2
%type <Doc_types.ts_blk_txt>              blk_txt0 blk_txt1 blk_txt2 blk_txt3
%type <Doc_types.te_blk list>             blks0 blks1 blks2 blks3 special_blks0 special_blks1 special_blks2
%type <Doc_types.ts_c_ref>                c_ref
%type <Doc_types.tr_dsp_line>             dsp_line special_dsp_line
%type <Doc_types.tr_dsp_line list>        dsp_lines0 dsp_lines1 dsp_lines2  special_dsp_lines0 special_dsp_lines1 special_dsp_lines2
%type <Doc_types.te_tag_or_id>            pilcrow_spaces_tag_or_id_nl section_spaces_tag_or_id_nl
%type <Doc_types.tr_id>                   itm_id dsp_id
%type <Doc_types.ts_hdr>                  hdr
%type <Doc_types.te_lbl>                  itm_lbl_tab dsp_lbl_tab
%type <Doc_types.te_txt_unit>             txt_unit0 txt_unit1 txt_unit2 txt_unit3 dsp_unit
%type <Doc_types.te_txt_unit list>        txt_units0 txt_units1 txt_units2 txt_units3 dsp_units
%type <Doc_types.ts_lbl_custom>           dsp_custom_tab itm_custom_tab
%type <Doc_types.ts_lbl_auto>             dsp_auto_tab itm_auto_tab
%type <string>                            norm_txt_unit emph_txt_unit emph_txt_units emph_txt_units0 emph_txt_units1 emph_txt_units2 emph_txt_units3
%type <unit>                              dash_tab lb0 lb1 lb2 lb3 pilcrow_nl section_nl tabs

%start main

%%
main:
  | doc EOF                                       { $1 }
;

doc:
  | doc_main                                      {
                                                    {
                                                      fld_doc_preamble = None;
                                                      fld_doc_title = None;
                                                      fld_doc_author = None;
                                                      fld_doc_abstract = None;
                                                      fld_doc_main = $1;
                                                      fld_doc_refs = None;
                                                     } : tr_doc 
                                                   }
  | doc_preamble nls doc                           { 
                                                     { 
                                                       fld_doc_preamble = Some $1;
                                                       fld_doc_title = $3.fld_doc_title;
                                                       fld_doc_author = $3.fld_doc_author;
                                                       fld_doc_abstract = $3.fld_doc_abstract;
                                                       fld_doc_main = $3.fld_doc_main;
                                                       fld_doc_refs = $3.fld_doc_refs; 
                                                      } : tr_doc 
                                                  }
  | doc_title nls doc                             { 
                                                    {
                                                      fld_doc_preamble = $3.fld_doc_preamble;
                                                      fld_doc_title = Some $1;
                                                      fld_doc_author = $3.fld_doc_author;
                                                      fld_doc_abstract = $3.fld_doc_abstract;
                                                      fld_doc_main = $3.fld_doc_main;
                                                      fld_doc_refs = $3.fld_doc_refs;
                                                     } : tr_doc 
                                                   }
  | doc_author nls doc                             {
                                                    {
                                                      fld_doc_preamble = $3.fld_doc_preamble;
                                                      fld_doc_title = $3.fld_doc_title;
                                                      fld_doc_author = Some $1;
                                                      fld_doc_abstract = $3.fld_doc_abstract;
                                                      fld_doc_main = $3.fld_doc_main;
                                                      fld_doc_refs = $3.fld_doc_refs;
                                                     } : tr_doc 
                                                   }
;

nls:
  | NL                                             { }
  | NL nls                                         { }
;

doc_preamble:
  | PREAMBLE TAB lines                             { (Cs_preamble $3) : ts_preamble }
  | PREAMBLE NL_TAB lines                          { (Cs_preamble $3) : ts_preamble }
;

doc_title:
  | TITLE TAB lines                                { (Cs_title $3) : ts_title }
  | TITLE NL_TAB lines                             { (Cs_title $3) : ts_title }
;

doc_author:
  | AUTHOR TAB lines                               { (Cs_author $3) : ts_author }
  | AUTHOR NL_TAB lines                            { (Cs_author $3) : ts_author }
;

lines:
  | TXT                                            { $1 : string }
  | TXT NL_TAB lines                               { ($1 ^ " " ^ $3) : string }
;

doc_main:
  |secs                                           { (Ce_doc_main_secs (Cs_secs $1)):te_doc_main }
  |pars                                           { (Ce_doc_main_pars (Cs_pars $1)):te_doc_main }
  |blks0                                          { (Ce_doc_main_blks (Cs_blks $1)):te_doc_main }
(*|doc_main NL                                    { $1:te_doc_main }
*)
;

secs:
  |sec                                            { ($1::[]):tr_sec list }
  |sec secs                                       { ($1::$2):tr_sec list }
;

sec:
  |section_nl lb0 sec_main                        { {fld_sec_tag_or_id=None;fld_sec_hdr=None;fld_sec_main=$3}:tr_sec }
  |section_spaces_tag_or_id_nl lb0 sec_main       { {fld_sec_tag_or_id=Some $1;fld_sec_hdr=None;fld_sec_main=$3}:tr_sec }
  |section_nl hdr lb0 sec_main                    { {fld_sec_tag_or_id=None;fld_sec_hdr=Some $2;fld_sec_main=$4}:tr_sec }
  |section_spaces_tag_or_id_nl hdr lb0 sec_main   { {fld_sec_tag_or_id=Some $1;fld_sec_hdr=Some $2;fld_sec_main=$4}:tr_sec }
;

sec_main:
  |pars                                           { (Ce_pars_or_blks_pars (Cs_pars $1)):te_pars_or_blks }
  |blks0                                          { (Ce_pars_or_blks_blks (Cs_blks $1)):te_pars_or_blks }
;

pars:
  |par                                            { ($1::[]):tr_par list }
  |par pars                                       { ($1::$2):tr_par list }
;

par:
  |pilcrow_nl lb0 par_main                        { {fld_par_tag_or_id=None;fld_par_hdr=None;fld_par_main=$3}:tr_par }
  |pilcrow_spaces_tag_or_id_nl lb0 par_main       { {fld_par_tag_or_id=Some $1;fld_par_hdr=None;fld_par_main=$3}:tr_par }
  |pilcrow_nl hdr lb0 par_main                    { {fld_par_tag_or_id=None;fld_par_hdr=Some $2;fld_par_main=$4}:tr_par }
  |pilcrow_spaces_tag_or_id_nl hdr lb0 par_main   { {fld_par_tag_or_id=Some $1;fld_par_hdr=Some $2;fld_par_main=$4}:tr_par }
;

par_main:
  |blks0                                          { (Cs_blks $1):ts_blks }
;

(* Level 0: *)

blks0:
  |blk0 lb0                                       { ($1::[]):te_blk list }
  |blk0 lb0 blks0                                 { ($1::$3):te_blk list }
  |special_blks0                                  { $1:te_blk list }
;

special_blks0:
  |blk_txt0 lb1 special_blk_dsp0  lb0             { [Ce_blk_txt $1;Ce_blk_dsp $3]:te_blk list }
  |blk_txt0 lb1 special_blk_dsp0  lb0 blks0       { ((Ce_blk_txt $1)::((Ce_blk_dsp $3)::$5)):te_blk list }
;

blk0:
  |blk_txt0                                       { (Ce_blk_txt $1):te_blk }
  |blk_blt0                                       { (Ce_blk_blt $1):te_blk }
  |blk_itm0                                       { (Ce_blk_itm $1):te_blk }
  |blk_dsp0                                       { (Ce_blk_dsp $1):te_blk }
  |blk0 NL                                        { $1:te_blk }
;

blk_txt0:
  |txt_units0                                     { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units0:
  |txt_unit0 lb0                                  { ($1::[]):te_txt_unit list }
  |txt_unit0 txt_units0                           { ($1::$2):te_txt_unit list }
  |txt_unit0 lb0 txt_units0                       { ($1::((Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):te_txt_unit list }
;

txt_unit0:
  |norm_txt_unit                                  { (Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):te_txt_unit }
  |STAR emph_txt_units0 STAR                      { (Ce_txt_unit_emph (Cs_txt_unit_emph $2)):te_txt_unit }   
  |c_ref                                          { (Ce_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):te_txt_unit }
;

emph_txt_units0:
  |emph_txt_units                                 { $1:string }
  |emph_txt_units lb0 emph_txt_units0             { ($1 ^ " " ^ $3):string }
 ;


blk_blt0:
  |dash_tab blks1                                 { (Cs_blk_blt (Cs_blks $2)):ts_blk_blt }
;

blk_itm0:
  |itm_lbl_tab blks1                              { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $2}:tr_blk_itm }
  |itm_lbl_tab lb1 blks1                          { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
  |itm_lbl_tab itm_id lb1 blks1                   { {fld_blk_itm_lbl=$1;fld_blk_itm_id=Some $2;fld_blk_itm_main=Cs_blks $4}:tr_blk_itm }
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

lb0:
  |NL                                             { }
;

(* General recipe for n>0:

blks(n):
  |blk(n)                                                 { ($1::[]):te_blk list }
  |blk(n) lb(n) blks(n)                                   { ($1::$3):te_blk list }
  |special_blks(n)                                        { $1:te_blk list }
;

special_blks(n):
  |blk_txt(n) lb(n+1) special_blk_dsp(n)                  { [Ce_blk_txt $1;Ce_blk_dsp $3]:te_blk list }
  |blk_txt(n) lb(n+1) special_blk_dsp(n)  lb(n) blks(n)   { (Ce_blk_txt $1::((Ce_blk_dsp $3)::$5)):te_blk list }
;

blk(n):
  |blk_txt(n)                                             { (Ce_blk_txt $1):te_blk }
  |blk_blt(n)                                             { (Ce_blk_blt $1):te_blk }
  |blk_itm(n)                                             { (Ce_blk_itm $1):te_blk }
  |blk_dsp(n)                                             { (Ce_blk_dsp $1):te_blk }
;

blk_txt(n):
  |txt_units(n)                                           { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units(n):
  |txt_unit(n) lb0                                        { ($1::[]):te_txt_unit list }
  |txt_unit(n) txt_units(n)                               { ($1::$2):te_txt_unit list }
  |txt_unit(n) lb(n) txt_units(n)                         { ($1::((Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):te_txt_unit list }
;

txt_unit(n):
  |norm_txt_unit                                          { (Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):te_txt_unit }
  |STAR emph_txt_units(n) STAR                            { (Ce_txt_unit_emph (Cs_txt_unit_emph $2)):te_txt_unit }
  |LBR crefs RBR                                          { (Ce_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):te_txt_unit }
;

emph_txt_units(n):
  |emph_txt_units                                         { $1:string }
  |emph_txt_units lb(n) emph_txt_units(n)                 { ($1 ^ " " ^ $3):string }
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

lb(n):
  |lb(n-1)_TAB                                            { }
;
*)

(* Level 1: *)

blks1:
  |blk1                                           { ($1::[]):te_blk list }
  |blk1 lb1 blks1                                 { ($1::$3):te_blk list }
  |special_blks1                                  { $1:te_blk list }
;

special_blks1:
  |blk_txt1 lb2 special_blk_dsp1                  { [Ce_blk_txt $1;Ce_blk_dsp $3]:te_blk list }
  |blk_txt1 lb2 special_blk_dsp1  lb1 blks1       { ((Ce_blk_txt $1)::((Ce_blk_dsp $3)::$5)):te_blk list }
;

blk1:
  |blk_txt1                                       { (Ce_blk_txt $1):te_blk }
  |blk_blt1                                       { (Ce_blk_blt $1):te_blk }
  |blk_itm1                                       { (Ce_blk_itm $1):te_blk }
  |blk_dsp1                                       { (Ce_blk_dsp $1):te_blk }
;

blk_txt1:
  |txt_units1                                     { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units1:
  |txt_unit1 lb0                                  { ($1::[]):te_txt_unit list }
  |txt_unit1 txt_units1                           { ($1::$2):te_txt_unit list }
  |txt_unit1 lb1 txt_units1                       { ($1::((Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):te_txt_unit list }
;

txt_unit1:
  |norm_txt_unit                                  { (Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):te_txt_unit }
  |STAR emph_txt_units1 STAR                      { (Ce_txt_unit_emph (Cs_txt_unit_emph $2)):te_txt_unit }
  |c_ref                                          { (Ce_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):te_txt_unit }
;

emph_txt_units1:
  |emph_txt_units                                 { $1:string }
  |emph_txt_units lb1 emph_txt_units1             { ($1 ^ " " ^ $3):string }
;

blk_blt1:
  |dash_tab blks2                                 { (Cs_blk_blt (Cs_blks $2)):ts_blk_blt }
;

blk_itm1:
  |itm_lbl_tab blks2                              { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $2}:tr_blk_itm }
  |itm_lbl_tab lb2 blks2                          { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
  |itm_lbl_tab itm_id lb2 blks2                   { {fld_blk_itm_lbl=$1;fld_blk_itm_id=Some $2;fld_blk_itm_main=Cs_blks $4}:tr_blk_itm }
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

lb1:
  |NL_TAB                                         { }
;

(* Level 2: *)

blks2:
  |blk2                                           { ($1::[]):te_blk list }
  |blk2 lb2 blks2                                 { ($1::$3):te_blk list }
  |special_blks2                                  { $1:te_blk list }
;

special_blks2:
  |blk_txt2 lb3 special_blk_dsp2                  { [Ce_blk_txt $1;Ce_blk_dsp $3]:te_blk list }
  |blk_txt2 lb3 special_blk_dsp2  lb2 blks2       { ((Ce_blk_txt $1)::((Ce_blk_dsp $3)::$5)):te_blk list }
;

blk2:
  |blk_txt2                                       { (Ce_blk_txt $1):te_blk }
  |blk_blt2                                       { (Ce_blk_blt $1):te_blk }
  |blk_itm2                                       { (Ce_blk_itm $1):te_blk }
  |blk_dsp2                                       { (Ce_blk_dsp $1):te_blk }
;

blk_txt2:
  |txt_units2                                     { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units2:
  |txt_unit2 lb0                                  { ($1::[]):te_txt_unit list }
  |txt_unit2 txt_units2                           { ($1::$2):te_txt_unit list }
  |txt_unit2 lb2 txt_units2                       { ($1::((Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):te_txt_unit list }
;

txt_unit2:
  |norm_txt_unit                                  { (Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):te_txt_unit }
  |STAR emph_txt_units2 STAR                      { (Ce_txt_unit_emph (Cs_txt_unit_emph $2)):te_txt_unit }   
  |c_ref                                          { (Ce_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):te_txt_unit }
;

emph_txt_units2:
  |emph_txt_units                                 { $1:string }
  |emph_txt_units lb2 emph_txt_units2             { ($1 ^ " " ^ $3):string }
;

blk_blt2:
  |dash_tab blks3                                 { (Cs_blk_blt (Cs_blks $2)):ts_blk_blt }
;

blk_itm2:
  |itm_lbl_tab blks3                              { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $2}:tr_blk_itm }
  |itm_lbl_tab lb3 blks3                          { {fld_blk_itm_lbl=$1;fld_blk_itm_id=None;fld_blk_itm_main=Cs_blks $3}:tr_blk_itm }
  |itm_lbl_tab itm_id lb3 blks3                   { {fld_blk_itm_lbl=$1;fld_blk_itm_id=Some $2;fld_blk_itm_main=Cs_blks $4}:tr_blk_itm }
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

lb2:
  |NL_TAB_TAB                                     { }
;

(* Level 3: *)

blks3:
  |blk3                                           { ($1::[]):te_blk list }
  |blk3 lb3 blks3                                 { ($1::$3):te_blk list }
;

blk3:
  |blk_txt3                                       { (Ce_blk_txt $1):te_blk }
  (* et cetera *)
;

blk_txt3:
  |txt_units3                                     { (Cs_blk_txt (Cs_txt_units $1)):ts_blk_txt }
;

txt_units3:
  |txt_unit3 lb0                                  { ($1::[]):te_txt_unit list }
  |txt_unit3 txt_units3                           { ($1::$2):te_txt_unit list }
  |txt_unit3 lb3 txt_units3                       { ($1::((Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg " "))::$3)):te_txt_unit list }
;

txt_unit3:
  |norm_txt_unit                                  { (Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):te_txt_unit }
  |STAR emph_txt_units3 STAR                      { (Ce_txt_unit_emph (Cs_txt_unit_emph $2)):te_txt_unit }   
  |c_ref                                          { (Ce_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):te_txt_unit }
;

emph_txt_units3:
  |emph_txt_units                                 { $1:string }
  |emph_txt_units lb3 emph_txt_units3             { ($1 ^ " " ^ $3):string }
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
  |dsp_unit                                       { ($1::[]):te_txt_unit list }
  |dsp_unit dsp_units                             { ($1::$2):te_txt_unit list }
;

dsp_unit:
  |norm_txt_unit                                  { (Ce_txt_unit_wysiwyg (Cs_txt_unit_wysiwyg $1)):te_txt_unit }
  |STAR emph_txt_units STAR                       { (Ce_txt_unit_emph (Cs_txt_unit_emph $2)):te_txt_unit }   
  |c_ref                                          { (Ce_txt_unit_c_ref (Cs_txt_unit_c_ref $1)):te_txt_unit }
;

norm_txt_unit:
  |TXT                                            { $1:string }
  |COLON                                          { ":":string }
  |LBR                                            { "[":string }
  |RBR                                            { "]":string }
  |PILCROW                                        { "¶":string }
  |SECTION                                        { "§":string }
  |PREAMBLE                                       { $1:string }
  |TITLE                                          { $1:string }
  |AUTHOR                                         { $1:string }
(*|STAR                                           { "*":string } *)
;

emph_txt_units:
  |emph_txt_unit                                  { $1:string }
  |emph_txt_unit emph_txt_units                   { ($1 ^ $2):string }
;

emph_txt_unit:
  |TXT                                            { $1:string }
  |COLON                                          { ":":string }
  |LBR                                            { "[":string }
  |RBR                                            { "]":string }
  |PILCROW                                        { "¶":string }
  |SECTION                                        { "§":string }
  |PREAMBLE                                       { $1:string }
  |TITLE                                          { $1:string }
  |AUTHOR                                         { $1:string }
;

c_ref:
  |C_REF                                          { (c_ref_of_string $1):ts_c_ref }
;

itm_id:
  |ITM_ID                                         { (id_of_string $1):tr_id }
;

dsp_id:
  |DSP_ID                                         { (id_of_string $1):tr_id }
;

section_nl:
  |SECTION_NL                                     { }
;

section_spaces_tag_or_id_nl:
  |SECTION_SPACES_TAG_OR_ID_NL                    { (tag_or_id_of_string $1):te_tag_or_id }
;

pilcrow_nl:
  |PILCROW_NL                                     { }
;

pilcrow_spaces_tag_or_id_nl:
  |PILCROW_SPACES_TAG_OR_ID_NL                    { (tag_or_id_of_string $1):te_tag_or_id }
;

hdr:
  |txt_units0                                     { (Cs_hdr (Cs_txt_units $1)):ts_hdr }
;

dsp_lbl_tab:
  |dsp_auto_tab                                   { (Ce_lbl_auto $1):te_lbl }
  |dsp_custom_tab                                 { (Ce_lbl_custom $1):te_lbl }
;

dsp_auto_tab:
  |DSP_AUTO_TAB                                   { Cs_lbl_auto:ts_lbl_auto }
;

dsp_custom_tab:
  |DSP_CUSTOM_TAB                                 { Cs_lbl_custom $1:ts_lbl_custom }
;

itm_lbl_tab:
  |itm_auto_tab                                   { (Ce_lbl_auto $1):te_lbl }
  |itm_custom_tab                                 { (Ce_lbl_custom $1):te_lbl }
;

itm_auto_tab:
  |ITM_AUTO_TAB                                   { Cs_lbl_auto:ts_lbl_auto }
;

itm_custom_tab:
  |ITM_CUSTOM_TAB                                 { (Cs_lbl_custom $1):ts_lbl_custom }
;

dash_tab:
  |DASH_TAB                                       { }
;

tabs:
  |TAB                                            { }
  |tabs TAB                                       { }
;

