:- module nmm.parser.operators.star.

% INTERFACE

:- interface.


%% MODULE IMPORTS

:- use_module io.

:- import_module list.


%% GENERALIZED KLEENE STAR

%%% DOCUMENTATION

% - Suppose we have DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   Then the rule
%     r' --> *([r₁,…,rₙ])
%   has the expected behaviour.
%
% - Suppose we have a DCG rule
%     r(T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out).
%   Then the rule
%     r'(TS) --> *([r₁,…,rₙ],r,TS,[rₙ₊₁,…,rₙ₊ₘ])
%   tries
%     r₁,…,rₙ, r(–), rₙ₊₁,…,rₙ₊ₘ
%   repeatedly until failure. The rule r' succeeds no matter what. If
%     r₁,…,rₙ, r(T₁), rₙ₊₁,…,rₙ₊ₘ
%                ⋮
%     r₁,…,rₙ, r(Tₙ), rₙ₊₁,…,rₙ₊ₘ
%   are the successes before failure, then
%     TS = [T₁,T₂,...,Tₙ].
%
% - Suppose we have a DCG rule
%     r(T1::in,T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out).
%   Then the rule
%     r'(TS) --> *([r₁,…,rₙ],r,t1,TS,[rₙ₊₁,…,rₙ₊ₘ])
%   tries
%     r₁,…,rₙ, r(t1,–), rₙ₊₁,…,rₙ₊ₘ
%   repeatedly until failure. The rule r' succeeds no matter what. If
%     r₁,…,rₙ, r(t1,T₁), rₙ₊₁,…,rₙ₊ₘ
%                ⋮
%     r₁,…,rₙ, r(t1,Tₙ), rₙ₊₁,…,rₙ₊ₘ
%   are the successes before failure, then
%     TS = [T₁,T₂,...,Tₙ].
%
% - Suppose we have a DCG rule
%     r(T1::in,T2::in,T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out).
%   Then the rule
%     r'(TS) --> *([r₁,…,rₙ],r,t1,t2,TS,[rₙ₊₁,…,rₙ₊ₘ])
%   tries
%     r₁,…,rₙ, r(t1,t2,–), rₙ₊₁,…,rₙ₊ₘ
%   repeatedly until failure. The rule r' succeeds no matter what. If
%     r₁,…,rₙ, r(t1,t2,T₁), rₙ₊₁,…,rₙ₊ₘ
%                ⋮
%     r₁,…,rₙ, r(t1,t2,Tₙ), rₙ₊₁,…,rₙ₊ₘ
%   are the successes before failure, then
%     TS = [T₁,T₂,...,Tₙ].
%
% - Suppose we have a DCG rule
%     r(T1::in,T2::in,T3::in,T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out).
%   Then the rule
%     r'(TS) --> *([r₁,…,rₙ],r,t1,t2,t3,TS,[rₙ₊₁,…,rₙ₊ₘ])
%   tries
%     r₁,…,rₙ, r(t1,t2,t3,–), rₙ₊₁,…,rₙ₊ₘ
%   repeatedly until failure. The rule r' succeeds no matter what. If
%     r₁,…,rₙ, r(t1,t2,t3,T₁), rₙ₊₁,…,rₙ₊ₘ
%                ⋮
%     r₁,…,rₙ, r(t1,t2,t3,Tₙ), rₙ₊₁,…,rₙ₊ₘ
%   are the successes before failure, then
%     TS = [T₁,T₂,...,Tₙ].
%
% - For rules with more than 3 inputs one may resort to currying (or one may
%   extend the predicate list below). For example, given a DCG rule
%     r(T1::in,T2::in,T3::in,T4::in,T::out,TKNS::in,TKNS::out)
%   and DCG rules
%     r₁(TKNS::in,TKNS::out), ..., rₙ(TKNS::in,TKNS::out)
%   and
%     rₙ₊₁(TKNS::in,TKNS::out), ..., rₙ₊ₘ(TKNS::in,TKNS::out),
%   then the rule
%     r'(TS) --> {R = r(t1,t2,t3,t4)}, *([r₁,…,rₙ],R,TS,[rₙ₊₁,…,rₙ₊ₘ])
%   tries
%     r₁,…,rₙ, r(t1,t2,t3,t4,–), rₙ₊₁,…,rₙ₊ₘ
%   repeatedly until failure. The rule r' succeeds no matter what. If
%     r₁,…,rₙ, r(t1,t2,t3,t4,T₁), rₙ₊₁,…,rₙ₊ₘ
%                ⋮
%     r₁,…,rₙ, r(t1,t2,t3,t4,Tₙ), rₙ₊₁,…,rₙ₊ₘ
%   are the successes before failure, then
%     TS = [T₁,T₂,...,Tₙ].

%%% */3

:- pred *(list(ta_rule(TKNS)), TKNS, TKNS).
:- mode *(in(list(ta_rule)),   in,   out) is semidet.

%%% */9

:- pred *(
  list(ta_rule(TKNS)),
  pred(T1,T2,T3,T,TKNS,TKNS),
  T1,
  T2,
  T3,
  list(T),
  list(ta_rule(TKNS)),
  TKNS,
  TKNS
).
:- mode *(
  in(list(ta_rule)),
  pred(in,in,in,out,in,out) is semidet,
  in,  % T1
  in,  % T2
  in,  % T3
  out, % TS
  in(list(ta_rule)),
  in,
  out
) is semidet.

%%% */8

:- pred *(
  list(ta_rule(TKNS)),
  pred(T1,T2,T,TKNS,TKNS),
  T1,
  T2,
  list(T),
  list(ta_rule(TKNS)),
  TKNS,
  TKNS
).
:- mode *(
  in(list(ta_rule)),
  pred(in,in,out,in,out) is semidet,
  in,  % T1
  in,  % T2
  out, % TS
  in(list(ta_rule)),
  in,
  out
) is semidet.

%%% */7

:- pred *(
  list(ta_rule(TKNS)),
  pred(T1,T,TKNS,TKNS),
  T1,
  list(T),
  list(ta_rule(TKNS)),
  TKNS,
  TKNS
).
:- mode *(
  in(list(ta_rule)),
  pred(in,out,in,out) is semidet,
  in,   % T1
  out,  % TS
  in(list(ta_rule)),
  in,
  out
) is semidet.

%%% */6
:- pred *(
  list(ta_rule(TKNS)),
  pred(T,TKNS,TKNS),
  list(T),
  list(ta_rule(TKNS)),
  TKNS,
  TKNS
).
:- mode *(
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

:- pragma no_determinism_warning('*'/3).
:- pragma no_determinism_warning('*'/6).
:- pragma no_determinism_warning('*'/7).
:- pragma no_determinism_warning('*'/8).
:- pragma no_determinism_warning('*'/9).


%% GENERALIZED DCG KLEENE STAR

*(RS) --> (
  apply_rules(RS), *(RS) -> {true};
                            {true}
).
*(RS1,R,X1,X2,X3,XS,RS2) --> (
  apply_rules(RS1), R(X1,X2,X3,X), apply_rules(RS2), *(RS1,R,X1,X2,X3,XS_,RS2)
    -> {XS = [X]++XS_};
  {XS = []}
).
*(RS1,R,X1,X2,   XS,RS2) --> (
  apply_rules(RS1), R(X1,X2,   X), apply_rules(RS2), *(RS1,R,X1,X2,   XS_,RS2)
    -> {XS = [X]++XS_};
  {XS = []}
).
*(RS1,R,X1,      XS,RS2) --> (
  apply_rules(RS1), R(X1,      X), apply_rules(RS2), *(RS1,R,X1,      XS_,RS2)
    -> {XS = [X]++XS_};
  {XS = []}
).
*(RS1,R,         XS,RS2) --> (
  apply_rules(RS1), R(         X), apply_rules(RS2), *(RS1,R,         XS_,RS2)
    -> {XS = [X]++XS_};
  {XS = []}
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

%%% TESTS FOR */3

:- pred p_test_3a is semidet.
p_test_3a :-
  *([r_a], str2chrs("abc"), str2chrs("bc")).

:- pred p_test_3b is semidet.
p_test_3b :-
  *([r_a,r_b], str2chrs("ababc"), str2chrs("c")).

:- pred p_test_3c is semidet.
p_test_3c :-
  *([r_a,r_b], str2chrs("bac"), str2chrs("bac")).

%%% TESTS FOR */7

:- pred p_test_7a is semidet.
p_test_7a :-
  *([],r_chr_except_for,'b',['a'],[],str2chrs("abc"),str2chrs("bc")).

:- pred p_test_7b is semidet.
p_test_7b :-
  *([],r_chr_except_for,'b',['a','a'],[],str2chrs("aabc"),str2chrs("bc")).

:- pred p_test_7c is semidet.
p_test_7c :-
  *([],r_chr_except_for,'a',[],[],str2chrs("aabc"),str2chrs("aabc")).

:- pred p_test_7d is semidet.
p_test_7d :-
  *([r_a,r_b],r_chr_except_for,'b',['c'],[],str2chrs("abc"),[]).

:- pred p_test_7e is semidet.
p_test_7e :-
  *([r_a],r_chr_except_for,'b',['a'],[r_b],str2chrs("aabc"),['c']).

:- pred p_test_7f is semidet.
p_test_7f :-
  *([r_b],r_chr_except_for,'a',[],[],str2chrs("aabc"),str2chrs("aabc")).

:- pred p_test_7g is semidet.
p_test_7g :-
  *([r_a],r_chr_except_for,'a',[],[],str2chrs("aabc"),str2chrs("aabc")).

:- pred p_test_7h is semidet.
p_test_7h :-
  *([r_a],r_chr_except_for,'b',[],[r_b,r_b],str2chrs("aabc"),str2chrs("aabc")).

%%% TESTS FOR */8

:- pred p_test_8a is semidet.
p_test_8a :-
  *([],r_chr_except_for,'b','c',['a'],[],str2chrs("abc"),str2chrs("bc")).

:- pred p_test_8b is semidet.
p_test_8b :-
  *([],r_chr_except_for,'b','c',['a','a'],[],str2chrs("aabc"),str2chrs("bc")).

:- pred p_test_8c is semidet.
p_test_8c :-
  *([],r_chr_except_for,'a','c',[],[],str2chrs("aabc"),str2chrs("aabc")).

:- pred p_test_8d is semidet.
p_test_8d :-
  *([r_a,r_b],r_chr_except_for,'b','a',['c'],[],str2chrs("abc"),[]).

:- pred p_test_8e is semidet.
p_test_8e :-
  *([r_a],r_chr_except_for,'b','c',['a'],[r_b],str2chrs("aabc"),['c']).

:- pred p_test_8f is semidet.
p_test_8f :-
  *([r_b],r_chr_except_for,'a','b',[],[],str2chrs("aabc"),str2chrs("aabc")).

:- pred p_test_8g is semidet.
p_test_8g :-
  *([r_a],r_chr_except_for,'a','b',[],[],str2chrs("aabc"),str2chrs("aabc")).

:- pred p_test_8h is semidet.
p_test_8h :- *(
  [r_a],
  r_chr_except_for,'b','b',
  [],
  [r_b,r_b],
  str2chrs("aabc"),
  str2chrs("aabc")
).

%%% TESTS FOR */9

:- pred p_test_9a is semidet.
p_test_9a :-
  *([],r_chr_except_for,'b','c','b',['a'],[],str2chrs("abc"),str2chrs("bc")).

:- pred p_test_9b is semidet.
p_test_9b :-
  *([],r_chr_except_for,'b','c','b',['a','a'],[],str2chrs("aabc"),str2chrs("bc")).

:- pred p_test_9c is semidet.
p_test_9c :-
  *([],r_chr_except_for,'a','c','c',[],[],str2chrs("aabc"),str2chrs("aabc")).

:- pred p_test_9d is semidet.
p_test_9d :-
  *([r_a,r_b],r_chr_except_for,'b','a','b',['c'],[],str2chrs("abc"),[]).

:- pred p_test_9e is semidet.
p_test_9e :-
  *([r_a],r_chr_except_for,'b','c','c',['a'],[r_b],str2chrs("aabc"),['c']).

:- pred p_test_9f is semidet.
p_test_9f :-
  *([r_b],r_chr_except_for,'a','b','a',[],[],str2chrs("aabc"),str2chrs("aabc")).

:- pred p_test_9g is semidet.
p_test_9g :- *(
  [r_a],
  r_chr_except_for,'a','b','c',
  [],
  [],
  str2chrs("aabc"),
  str2chrs("aabc")
).

:- pred p_test_9h is semidet.
p_test_9h :- *(
  [r_a],
  r_chr_except_for,'b','b','c',
  [],
  [r_b,r_b],
  str2chrs("aabc"),
  str2chrs("aabc")
).

%%% TESTS FOR */6 WITH CURRYING

:- pred p_test_currying_1 is semidet.
p_test_currying_1 :- (
  R = r_chr_except_for('c','d','e'),
  *([],R,['a','b'],[],str2chrs("abcabc"),str2chrs("cabc"))
).

:- pred p_test_currying_2 is semidet.
p_test_currying_2 :- (
  R = r_chr_except_for('a','d','e'),
  *([r_a,r_b],R,['c'],[r_a,r_b],str2chrs("abcabc"),str2chrs("c"))
).

:- pred p_test_currying_3 is semidet.
p_test_currying_3 :- (
  R = r_chr_except_for('b','d','e'),
  *([],R,['a'],[r_a,r_b],str2chrs("aab"),[])
).

:- pred p_test_currying_4 is semidet.
p_test_currying_4 :- (
  R = r_chr_except_for('b','d','e'),
  *([r_a],R,[],[],str2chrs("bc"),str2chrs("bc"))
).

:- pred p_test_currying_5 is semidet.
p_test_currying_5 :- (
  R = r_chr_except_for('b','d','e'),
  *([r_a],R,[],[],str2chrs("ab"),str2chrs("ab"))
).

:- pred p_test_currying_6 is semidet.
p_test_currying_6 :- (
  R = r_chr_except_for('b','d','e'),
  *([r_a],R,[],[r_a,r_a],str2chrs("aaab"),str2chrs("aaab"))
).


%% MAIN

test(!IO) :- (
  (
    not p_test_3a -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_3a for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_3b -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_3b for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_3c -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_3c for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7a -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7a for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7b -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7b for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7c -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7c for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7d -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7d for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7e -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7e for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7f -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7f for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7g -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7g for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_7h -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_7h for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8a -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8a for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8b -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8b for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8c -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8c for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8d -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8d for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8e -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8e for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8f -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8f for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8g -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8g for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_8h -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_8h for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9a -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9a for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9b -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9b for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9c -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9c for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9d -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9d for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9e -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9e for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9f -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9f for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9g -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9g for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_9h -> (
      io.set_exit_status(1,!IO),
      io.write_string(io.stderr_stream,"p_test_9h for * operator failed\n",!IO)
    );
    true
  ),
  (
    not p_test_currying_1 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_1 for * operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_2 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_2 for * operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_3 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_3 for * operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_4 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_4 for * operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_5 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_5 for * operator failed\n",!IO
      )
    );
    true
  ),
  (
    not p_test_currying_6 -> (
      io.set_exit_status(1,!IO),
      io.write_string(
        io.stderr_stream,"p_test_currying_6 for * operator failed\n",!IO
      )
    );
    true
  )
).
