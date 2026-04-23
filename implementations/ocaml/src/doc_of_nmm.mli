(** For mapping nmm source-code to objects of type {!type:Doc_types.tr_doc}. *)

exception Error of string

val doc_of_nmm_file : bool -> string -> Doc_types.tr_doc
(** 
[doc_of_nmm_file true "path/to/file"] reads from path/to/file (if such a file exists), prints read tokens to [stderr], and returns (if succesful) an object of type [Doc_types.tr_doc]. Raises [Error "cannot read from path/to/file: No such file"] if no file exists, and [Error "parsing failed"] on parsing failure. 

[doc_of_nmm_file false "path/to/file"] reads from path/to/file (if such a file exists), and returns (if succesful) an object of type [Doc_types.tr_doc]. Raises [Error "cannot read from path/to/file: No such file"] if no file exists, and evaluates to [doc_of_nmm_file true "path/to/file"] on parsing failure.
*)


val doc_of_nmm_string : bool -> string -> Doc_types.tr_doc
(**
Same as [doc_of_nmm_file], except that it reads from the provided string.
*)

val doc_of_nmm_stdin : bool -> Doc_types.tr_doc
(**
Same as [doc_of_nmm_file], except that it reads from standard input.
*)

(* with tagger *)

val doc_of_nmm_file_with_tagger : (Doc_types.tr_blk_itm -> Doc_types.tr_blk_itm) -> string -> Doc_types.tr_doc

val doc_of_nmm_stdin_with_tagger : (Doc_types.tr_blk_itm -> Doc_types.tr_blk_itm) -> Doc_types.tr_doc

val doc_of_nmm_string_with_tagger : (Doc_types.tr_blk_itm -> Doc_types.tr_blk_itm) -> string -> Doc_types.tr_doc

