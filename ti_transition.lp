% rules for defining transition
% inertia axioms
holds(F, I + 1) :-              %(0.35)
    fluent(inertial, F),
    holds(F, I),
    not -holds(F, I + 1),
    I < n.
-holds(F, I + 1) :-
    fluent(inertial, F),
    -holds(F, I),
    not holds(F, I + 1),
    I < n.

% CWA for defined fluents
-holds(F, I) :-                 %(0.36)
    fluent(defined, F),
    not holds(F, I).

% definition of impossible and CWA for actions
-occurs(E, I) :-                %(0.37)
    impossible(E, I).

-occurs(E, I) :-                %(0.38)
    not occurs(E, I).

% (0.39) all statements in program_n each followed by "." and
% a statement: current_step(n).

comp(PAA).                      %(0.40)
comp(M).
equal(M, M1) :-
    goal(M, G),
    goal(M1, G),
    equal_plan(M, M1).
equal_plan(M, M1) :-
    length(M, L),
    length(M1, L),
    not different_component(M, M1).
different_component(M, M1) :-
    component(M, K, C),
    component(M1, K, C1),
    C != C1.
:- equal(M, M1),
   M != M1.

holds(F, 0) :-                  %(0.41)
    observbed(F, true, 0).
-holds(F, 0) :-
    observed(F, false, 0).

:- current_step(I1),            %(0.42)
   I <= I1,
   observbed(F, false, I),
   h(F, I).
:- current_step(I1),
   I <= I1,
   observed(F, true, I),
   -holds(F, I).

occurs(E, I) :-                 %(0.43)
    current_step(I1),
    I < I1,
    happend(E, true, I).
-occurs(E, I) :-
    current_step(I1),
    I < I1,
    happend(E, false, I).

occurs(AA, I) :-                %(0.44)
    current_step(I1),
    I < I1,
    attempt(AA, I),
    not impossible(AA, I).
:- current_step(I1),
   I < I1,
   occurs(AA, I),
   not attempt(AA, I).

impossible(select(G), I) :-     %(0.45)
    current_step(I1),
    I < I1,
    occurs(select(G1), I),
    G != G1.
impossible(select(G), I) :-
    current_step(I1),
    I < I1,
    holds(active(M), I).
impossible(select(G), I):-
    current_step(I1),
    I < I1,
    holds(active_goal(G), I).

holds(status(M, -1), 0).        %(0.46)
-holds(active_goal(G), 0).
holds(next_name(ir), 0).

observed_result(AA, I) :-       %(0.47)
    current_step(I1),
    I <= I1,
    happened(AA, B, I).
:- current_step(I1),
   I <= I1,
   attempt(AA, I),
   not observed_result(AA, I).

:- current_step(I1),            %(0.48)
   I < I1,
   occurs(select(G), I),
   not happened(select(G), true, I).
:- current_step(I1),
   I < I1,
   occurs(abandon(G), I),
   not happened(abandon(G), true, I).

need_to_obs_goal(G, I) :-       %(0.49)
    current_step(I1),
    I <= I1,
    -holds(minor(G), I - 1),
    holds(active_goal(G), I -1).
need_to_obs_goal(G1, I) :-
    I <= I1,
    holds(minor(G1), I),
    holds(immediate_child_goal(G1, G), I),
    holds(active_goal(G), I).

observed_goal(G, I) :-          %(0.50) this might be problematic
    current_step(I1),
    I <= I1,
    observed(G, B, I).
:- current_step(I1),
   I <= I1,
   need_to_obs_goal(G, I),
   not observed_goal(G, I).
diag(PEA, I2, I1) : occurs(PEA, I2) :-
    current_step(I1),
    I2 < I1.

unobserved(PEA, I) :-           %(0.51)
    current_step(I1),
    I < I1,
    occurs(PEA, I),
    not happened(PEA, true, I).

number_unoberserved(N, I) :-    %(0.52) this might be problematic
    current_step(I),
    N = #count{unobserved(EX, IX)}.

:- current_step(I),             %(0.53)
   number_unobserved(N, I),
   interpretation(X, I),
   N != X.

active_goal_or_activity(I) :-   %(0.54)
    current_step(I),
    interpretation(N, I),
    holds(active_goal(G), I).
active_goal_or_activity(I) :-
    current_step(I),
    interpretation(N, I),
    holds(active(M), I).

category_1_history(I) :-        %(0.55)
    current_step(I),
    interpretation(N, I),
    not active_goal_or_activity(I).

category_2_history(M, I) :-     %(0.56)
    current_step(I),
    interpretation(N, I),
    -holds(minor(M), I),
    holds(active(M), I),
    goal(M, G),
    -active_goal(G).

category_3_history(M, I) :-     %(0.57)
    current_step(I),
    interpretation(N, I),
    -holds(minor(M), I),
    holds(in_progress(M), I).

category_4_history(G, I) :-     %(0.58)
    current_step(I),
    interpretation(N, I),
    -holds(minor(G), I),
    holds(active_goal(G), I),
    -holds(in_progress(G), I).

intended_action(wait, I) :-     %(0.59)
    current_step(I),
    interpretation(N, I),
    category_1_history(I).

intended_action(stop(M), I) :-  %(0.60)
    current_step(I),
    interpretation(N, I),
    category_2_history(M, I).

occurs(AA, I1) :-               %(0.61)
    current_step(I),
    category_3_history(M, I),
    interpretation(N, I),
    I <= I1,
    -holds(minor(M), I1),
    holds(in_progress(M), I1),
    holds(next_action(M, AA), I1),
    not impossible(AA, I1).

projected_success(M, I) :-      %(0.62)
    current_step(I),
    inbterpretation(N, I),
    -holds(minor(M), I),
    I < I1,
    holds(active(M), I1),
    goal(M, G),
    holds(G, I1).

intended action(AA, I) :−       %(0.63)
    current_step(I),
    interpretation(N, I),
    category_3_history(M, I),
    holds(next_action(M, AA), I),
    projected_success(M, I).

:− current_step(I),             %(0.64)
   interpretation(N, I),
   category_3_history(M, I),
   −projected_success(M, I),
   not futile(M,I).

futile_activity(M, I) : futile(M, I) :- %(0.65) this might be problematic
    current_step(I),
    interpretation(N, I),
    category_3_history(M, I),
    −projected_success(M, I).

intended_action(stop(M), I) :-  %(0.66)
    current_step(I),
    interpretation(N, I),
    category_3_history(M, I),
    futile(M,I).

existing_candidate(M, I) :-     %(0.67)
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    holds(next_name(M1),I),
    M < M1,
    goal(M, G).
new_candidate(M, I) :-
    current step(I),
    interpretation(N, I),
    category_4_history(G, I),
    holds(next_name(M),I).
candidate(M, I) :- new_candidate(M, I).
candidate(M, I) :- existing_candidate(M, I).

occurs(start(M), I) :-          %(0.68)
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    candidate(M, I),
    goal(M, G),
    not impossible(start(M), I).

impossible(start(M), I) :-      %(0.69)
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    goal(M1, G),
    occurs(start(M1), I),
    M != M1.

:- current_step(I),             %(0.70)
   interpretation(N, I),
   category_4_history(G, I),
   goal(M1, G),
   occurs(start(M1), I),
   M != M1.

futile_goal(G, I) : futile(G, I) :- %(0.71) this might be problematic
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    occurs(start(M), I),
    -projected_success(M, I).

intended_action(wait, I) :-     %(0.72)
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    futile(G, I).

some_action_occurred(I1) :-     %(0.73)
    current_step(I),
    interpretation(N, I),
    I <= I1,
    occurs(E, I1).

goal(M, G) :-                   %(0.74)
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    new_candidate(M, I).

plan_new(PAA, I1) : occurs(PAA, I1) :-  %(0.75) this might be problematic
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    new_candidate(M, I),
    occurs(start(M), I),
    I < I1,
    some_action_occurred(I1 - 1).

component(M, I1 - I, PAA) :-    %(0.76) this might be problematic
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    new_candidate(M, I),
    occurs(start(M), I),
    occurs(PAA, I1).

:- current_step(I),             %(0.77)
   interpretation(N, I),
   category_4_history(G, I),
   new_candidate(M, I),
   component(M, K, C),
   component(M, K, C1),
   C1 != C.

has_comp(M, K) :-               %(0.78)
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    new_candidate(M, I),
    occurs(start(M), I),
    component(M, K, C).
length(M, K) :-
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    new_candidate(M, I),
    occurs(start(M), I),
    has_comp(M, K),
    not has_comp(M, K + 1).

plan_existing(PAA, I1) : occurs(PAA, I1) :- %(0.79) problematic
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    existing_candidate(M, I),
    occurs(start(M), I),
    I < I1,
    holds(next_action(M, PAA), I1),
    some_action_occurred(I1 - 1).

occurs(MAA, I1) :-              %(0.80)
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    existing_candidate(M, I),
    occurs(start(M), I),
    I < I1,
    holds(in_progress(M), I1),
    holds(next_action(M, MAA), I1).

intended_action(start(M), I) :- %(0.81)
    current_step(I),
    interpretation(N, I),
    category_4_history(G, I),
    candidate(M, I),
    occurs(start(M), I),
    projected_success(M, I).

prefer(plan_new(PAA, I1), futile_goal(G, I)).       %(0.82)

prefer(plan_existing(PAA, I1), futile_goal(G, I)).  %(0.83)
