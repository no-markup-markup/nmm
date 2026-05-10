:- module nmm.parser.operators.q_mark.

% INTERFACE

:- interface.


%% MODULE IMPORTS

:- use_module io.

:- import_module list.


%% GENERALIZED DCG ? OPERATOR

%%% DOCUMENTATION

% - Suppose we have DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   Then the rule
%     r' --> ?([r₁,…,rₙ])
%   has the expected behaviour.
%
% - Suppose we have a DCG rule
%     r(T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out).
%   Then the rule
%     r'(MAYBE_T) --> ?([r₁,…,rₙ],r,MAYBE_T,[rₙ₊₁,…,rₙ₊ₘ])
%   (always succeeds and) tries
%     r₁,…,rₙ, r(T), rₙ₊₁,…,rₙ₊ₘ.
%   If this succeeds then
%     MAYBE_T = maybe.yes(T);
%   otherwise
%     MAYBE_T = maybe.no.
%
% - Suppose we have a DCG rule
%     r(T1::in,T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out).
%   Then the rule
%     r'(MAYBE_T) --> ?([r₁,…,rₙ],r,t1,MAYBE_T,[rₙ₊₁,…,rₙ₊ₘ])
%   (always succeeds and) tries
%     r₁,…,rₙ, r(t1,T), rₙ₊₁,…,rₙ₊ₘ.
%   If this succeeds then
%     MAYBE_T = maybe.yes(T);
%   otherwise
%     MAYBE_T = maybe.no.
%
% - Suppose we have a DCG rule
%     r(T1::in,T2::in,T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out).
%   Then the rule
%     r'(MAYBE_T) --> ?([r₁,…,rₙ],r,t1,t2,MAYBE_T,[rₙ₊₁,…,rₙ₊ₘ])
%   (always succeeds and) tries
%     r₁,…,rₙ, r(t1,t2,T), rₙ₊₁,…,rₙ₊ₘ.
%   If this succeeds then
%     MAYBE_T = maybe.yes(T);
%   otherwise
%     MAYBE_T = maybe.no.
%
% - Suppose we have a DCG rule
%     r(T1::in,T2::in,T3::in,T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out).
%   Then the rule
%     r'(MAYBE_T) --> ?([r₁,…,rₙ],r,t1,t2,t3,MAYBE_T,[rₙ₊₁,…,rₙ₊ₘ])
%   (always succeeds and) tries
%     r₁,…,rₙ, r(t1,t2,t3,T), rₙ₊₁,…,rₙ₊ₘ.
%   If this succeeds then
%     MAYBE_T = maybe.yes(T);
%   otherwise
%     MAYBE_T = maybe.no.
%
% - For rules with more than 3 inputs one may resort to currying (or one may
%   extend the predicate list below). For example, given a DCG rule
%     r(T1::in,T2::in,T3::in,T4::in,T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out),
%   then the rule
%     r'(MAYBE_T) --> {R = r(t1,t2,t3,t4)}, ?([r₁,…,rₙ],R,MAYBE_T,[rₙ₊₁,…,rₙ₊ₘ])
%   (always succeeds and) tries
%     r₁,…,rₙ, r(t1,t2,t3,t4,T), rₙ₊₁,…,rₙ₊ₘ.
%   If this succeeds then
%     MAYBE_T = maybe.yes(T);
%   otherwise
%     MAYBE_T = maybe.no.

%%% ?/3

:- pred ?(list(ta_rule(TKNS)), TKNS, TKNS).
:- mode ?(in(list(ta_rule)),   in,   out) is semidet.

%%% ?/9

:- pred ?(
  list(ta_rule(TKNS)),
  pred(T1,T2,T3,T,TKNS,TKNS),
  T1,
  T2,
  T3,
  maybe(T),
  list(ta_rule(TKNS)),
  TKNS,
  TKNS
).
:- mode ?(
  in(list(ta_rule)),
  pred(in,in,in,out,in,out) is semidet,
  in,  % T1
  in,  % T2
  in,  % T3
  out, % maybe T
  in(list(ta_rule)),
  in,
  out
) is semidet.

%%% ?/8

:- pred ?(
  list(ta_rule(TKNS)),
  pred(T1,T2,T,TKNS,TKNS),
  T1,
  T2,
  maybe(T),
  list(ta_rule(TKNS)),
  TKNS,
  TKNS
).
:- mode ?(
  in(list(ta_rule)),
  pred(in,in,out,in,out) is semidet,
  in,  % T1
  in,  % T2
  out, % maybe T
  in(list(ta_rule)),
  in,
  out
) is semidet.

%%% ?/7

:- pred ?(
  list(ta_rule(TKNS)),
  pred(T1,T,TKNS,TKNS),
  T1,
  maybe(T),
  list(ta_rule(TKNS)),
  TKNS,
  TKNS
).
:- mode ?(
  in(list(ta_rule)),
  pred(in,out,in,out) is semidet,
  in,   % T1
  out,  % maybe T
  in(list(ta_rule)),
  in,
  out
) is semidet.

%%% ?/6

:- pred ?(
  list(ta_rule(TKNS)),
  pred(T,TKNS,TKNS),
  maybe(T),
  list(ta_rule(TKNS)),
  TKNS,
  TKNS
).
:- mode ?(
  in(list(ta_rule)),
  pred(out,in,out) is semidet,
  out,
  in(list(ta_rule)),
  in,
  out
) is semidet.


%% TEST

:- pred test(io.io::di, io.io::uo) is det.



% IMPLEMENTATION

:- implementation.

%% PRAGMAS TO DISABLE DETERMINISM WARNINGS

:- pragma no_determinism_warning('?'/3).
:- pragma no_determinism_warning('?'/6).
:- pragma no_determinism_warning('?'/7).
:- pragma no_determinism_warning('?'/8).
:- pragma no_determinism_warning('?'/9).


%% GENERALIZED DCG ? OPERATOR

?(RS) --> (
  apply_rules(RS) -> {true};
                     {true}
).
?(RS_1,R,X1,X2,X3,X,RS_2) --> (
  apply_rules(RS_1), R(X1,X2,X3,X_), apply_rules(RS_2) -> {X = maybe.yes(X_)};
                                                          {X = maybe.no}
).
?(RS_1,R,X1,X2,   X,RS_2) --> (
  apply_rules(RS_1), R(X1,X2,   X_), apply_rules(RS_2) -> {X = maybe.yes(X_)};
                                                          {X = maybe.no}
).
?(RS_1,R,X1,      X,RS_2) --> (
  apply_rules(RS_1), R(X1,      X_), apply_rules(RS_2) -> {X = maybe.yes(X_)};
                                                          {X = maybe.no}
).
?(RS_1,R,         X,RS_2) --> (
  apply_rules(RS_1), R(         X_), apply_rules(RS_2) -> {X = maybe.yes(X_)};
                                                          {X = maybe.no}
).

%% TEST PREDICATES

%%% DCG RULES R_A AND R_B

:- pred r_a(chrs::in,chrs::out) is semidet.
r_a --> ['a'].

:- pred r_b(chrs::in,chrs::out) is semidet.
r_b --> ['b'].

%%% DCG RULES R_CHR_EXCEPT_FOR
:- pred r_chr_except_for(chr,chr,chr, chr, chrs, chrs).
:- mode r_chr_except_for(in, in, in,  out, in,   out) is semidet.
:- pred r_chr_except_for(chr,chr,     chr, chrs, chrs).
:- mode r_chr_except_for(in, in,      out, in,   out) is semidet.
:- pred r_chr_except_for(chr,         chr, chrs, chrs).
:- mode r_chr_except_for(in,          out, in,   out) is semidet.

r_chr_except_for(        C1, C2, C3,  C_OUT) --> (
  [C_OUT],
  {not C_OUT = C1, not C_OUT = C2, not C_OUT = C3}
).
r_chr_except_for(        C1, C2,      C_OUT) --> (
  [C_OUT],
  {not C_OUT = C1, not C_OUT = C2}
).
r_chr_except_for(        C1,          C_OUT) --> (
  [C_OUT],
  {not C_OUT = C1}
).

%%% TESTS FOR ?/3

:- pred p_test_3a is semidet.
p_test_3a :-
  ?([r_a], str2chrs("abc"), str2chrs("bc")).

:- pred p_test_3b is semidet.
p_test_3b :-
  ?([r_a,r_b], str2chrs("abc"), str2chrs("c")).

:- pred p_test_3c is semidet.
p_test_3c :-
  ?([r_a,r_b], str2chrs("acb"), str2chrs("acb")).

%%% TESTS FOR ?/6 WITH CURRYING

:- pred p_test_currying_1 is semidet.
p_test_currying_1 :- (
  R = r_chr_except_for('c','d','e'),
  ?([],R,maybe.yes('a'),[],str2chrs("abcabc"),str2chrs("bcabc"))
).

:- pred p_test_currying_2 is semidet.
p_test_currying_2 :- (
  R = r_chr_except_for('a','d','e'),
  ?([r_a,r_b],R,maybe.yes('c'),[r_a,r_b],str2chrs("abcabc"),str2chrs("c"))
).

:- pred p_test_currying_3 is semidet.
p_test_currying_3 :- (
  R = r_chr_except_for('b','d','e'),
  ?([],R,maybe.yes('a'),[r_a,r_b],str2chrs("aab"),[])
).

:- pred p_test_currying_4 is semidet.
p_test_currying_4 :- (
  R = r_chr_except_for('b','d','e'),
  ?([r_a],R,maybe.no,[],str2chrs("bc"),str2chrs("bc"))
).

:- pred p_test_currying_5 is semidet.
p_test_currying_5 :- (
  R = r_chr_except_for('b','d','e'),
  ?([r_a],R,maybe.no,[],str2chrs("ab"),str2chrs("ab"))
).

:- pred p_test_currying_6 is semidet.
p_test_currying_6 :- (
  R = r_chr_except_for('b','d','e'),
  ?([r_a],R,maybe.no,[r_a,r_a],str2chrs("aaab"),str2chrs("aaab"))
).

%%% TESTS FOR ?/7

:- pred p_test_7a is semidet.
p_test_7a :-
  ?([],r_chr_except_for,'c',maybe.yes('a'),[],str2chrs("abc"),str2chrs("bc")).

:- pred p_test_7b is semidet.
p_test_7b :-
  ?([],r_chr_except_for,'a',maybe.no,[],str2chrs("abc"),str2chrs("abc")).

:- pred p_test_7c is semidet.
p_test_7c :- ?(
  [r_a,r_b],
  r_chr_except_for,'d',
  maybe.yes('c'),
  [r_a,r_b],
  str2chrs("abcabc"),
  str2chrs("c")
).

:- pred p_test_7d is semidet.
p_test_7d :- ?(
  [r_b],
  r_chr_except_for,'d',
  maybe.no,
  [r_a,r_b],
  str2chrs("abcabc"),
  str2chrs("abcabc")
).

:- pred p_test_7e is semidet.
p_test_7e :- ?(
  [r_a,r_b],
  r_chr_except_for,'d',
  maybe.no,
  [r_a,r_b,r_b],
  str2chrs("abcabc"),
  str2chrs("abcabc")
).

%%% TESTS FOR ?/8

:- pred p_test_8a is semidet.
p_test_8a :- ?(
  [],
  r_chr_except_for,'c','d',
  maybe.yes('a'),
  [],
  str2chrs("abc"),
  str2chrs("bc")
).

:- pred p_test_8b is semidet.
p_test_8b :-
  ?([],r_chr_except_for,'b','a',maybe.no,[],str2chrs("abc"),str2chrs("abc")).

:- pred p_test_8c is semidet.
p_test_8c :- ?(
  [r_a,r_b],
  r_chr_except_for,'d','f',
  maybe.yes('c'),
  [r_a,r_b],
  str2chrs("abcabc"),
  str2chrs("c")
).

:- pred p_test_8d is semidet.
p_test_8d :- ?(
  [r_b],
  r_chr_except_for,'d','f',
  maybe.no,
  [r_a,r_b],
  str2chrs("abcabc"),
  str2chrs("abcabc")
).

:- pred p_test_8e is semidet.
p_test_8e :- ?(
  [r_a,r_b],
  r_chr_except_for,'d','f',
  maybe.no,
  [r_a,r_b,r_b],
  str2chrs("abcabc"),
  str2chrs("abcabc")
).

%%% TESTS FOR ?/9

:- pred p_test_9a is semidet.
p_test_9a :- ?(
  [],
  r_chr_except_for,'c','d','e',
  maybe.yes('a'),
  [],
  str2chrs("abc"),
  str2chrs("bc")
).

:- pred p_test_9b is semidet.
p_test_9b :- ?(
  [],
  r_chr_except_for,'b','a','e',
  maybe.no,
  [],
  str2chrs("abc"),
  str2chrs("abc")
).

:- pred p_test_9c is semidet.
p_test_9c :- ?(
  [r_a,r_b],
  r_chr_except_for,'d','f','e',
  maybe.yes('c'),
  [r_a,r_b],
  str2chrs("abcabc"),
  str2chrs("c")
).

:- pred p_test_9d is semidet.
p_test_9d :- ?(
  [r_b],
  r_chr_except_for,'d','f','e',
  maybe.no,
  [r_a,r_b],
  str2chrs("abcabc"),
  str2chrs("abcabc")
).

:- pred p_test_9e is semidet.
p_test_9e :- ?(
  [r_a,r_b],
  r_chr_except_for,'d','f','e',
  maybe.no,
  [r_a,r_b,r_b],
  str2chrs("abcabc"),
  str2chrs("abcabc")
).


%% TEST

test(!IO) :- (
  (
    not p_test_3a -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_3a for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_3b -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_3b for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_3c -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_3c for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7a -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7a for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7b -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7b for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7c -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7c for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7d -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7d for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7e -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7e for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8a -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8a for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8b -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8b for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8c -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8c for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8d -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8d for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8e -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8e for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9a -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9a for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9b -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9b for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9c -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9c for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9d -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9d for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9e -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9e for ? operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_currying_1 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_1 for ? operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_2 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_2 for ? operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_3 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_3 for ? operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_4 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_4 for ? operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_5 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_5 for ? operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_6 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_6 for ? operator failed\n",!IO
      )
    );
    true
  )
).
