:- module nmm.parser.xml.

% file created by Claude Opus 5.5 (effort: Extra), then carefully reviewed by
% Anders

% INTERFACE

%% INTERFACE DECLARATION

:- interface.


%% MODULE IMPORTS

:- use_module term_to_xml.


%% F_TO_XML

% Generic XML conversion of parse trees. The term c(A1,...,An) becomes the
% element <c>X1...Xn</c>, where Xi are the children contributed by Ai:
%
%   string        |-> its text
%   list or maybe |-> the children contributed by its elements
%                     (no element of its own)
%   anything else |-> the single element f_to_xml(Ai)
%
% This replaces the hand-written f_*_to_xml functions, which all followed
% this scheme: every element name is the constructor name, and arguments
% appear in order.

:- func (
  f_to_xml(T::in) = (term_to_xml.xml::out(term_to_xml.xml_doc))
) is det.



% IMPLEMENTATION

%% IMPLEMENTATION DECLARATION

:- implementation.


%% MODULE IMPORTS

:- use_module deconstruct.
:- use_module type_desc.
:- use_module univ.


%% F_TO_XML

f_to_xml(TERM) = term_to_xml.elem(FUNCTOR,[],f_args_to_xml(ARGS)) :-
  deconstruct.deconstruct(TERM,deconstruct.do_not_allow,FUNCTOR,_,ARGS).

%%% HELPER F_ARGS_TO_XML

:- func f_args_to_xml(list(univ.univ)) = list(term_to_xml.xml).
f_args_to_xml(ARGS) = list.condense(list.map(f_arg_to_xml,ARGS)).

%%% HELPER F_ARG_TO_XML

:- func f_arg_to_xml(univ.univ) = list(term_to_xml.xml).
f_arg_to_xml(ARG) = XMLS :-
  VALUE = univ.univ_value(ARG),
  (
    if      univ.univ_to_type(ARG,STR)         then
      XMLS = [term_to_xml.data(STR)]
    else if p_transparent(univ.univ_type(ARG)) then
      deconstruct.deconstruct(VALUE,deconstruct.do_not_allow,_,_,ARGS),
      XMLS = f_args_to_xml(ARGS)
    else
      XMLS = [f_to_xml(VALUE)]
  ).

%%% HELPER P_TRANSPARENT

% Types that contribute their contents but no element of their own. For a
% list, deconstruct gives [HEAD,TAIL] (or []), so recursing on the arguments
% flattens the whole list; for a maybe it gives [X] (or []).

:- pred p_transparent(type_desc.type_desc::in) is semidet.
p_transparent(TYPE) :-
  type_desc.type_ctor_name_and_arity(type_desc.type_ctor(TYPE),MOD,NAME,_),
  (
    MOD = "list",  NAME = "list"
    ;
    MOD = "maybe", NAME = "maybe"
  ).
