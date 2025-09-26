:- module nmm.parser.operators.

:- interface.

:- include_module
  operators.plus,
  operators.q_mark,
  operators.star,
  operators.test.

:- type ta_rule(TKNS) ==  pred(TKNS, TKNS).
:- inst ta_rule       == (pred(in,   out) is semidet).

:- pred apply_rules(list(ta_rule(TKNS)), TKNS, TKNS).
:- mode apply_rules(in(list(ta_rule)),   in,   out) is semidet.

:- implementation.

apply_rules([])     --> {true}.
apply_rules([R|RS]) --> R, apply_rules(RS).
