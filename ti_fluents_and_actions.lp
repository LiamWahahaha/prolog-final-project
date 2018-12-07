% inertial fluents:
fluent(active_goal(G), inertial) :-
    possible_goal(G).

fluent(status(M, K), inertial) :-
    activity(M),
    index(K).
fluent(next_name(M), inertial) :-
    activity(M).

% defined fluents:
fluent(active(M), defined) :-
    activity(M).

fluent(immediate_child(M1, M), defined) :-
    activity(M1),
    activity(M),
    M1 != M.

fluent(immediate_child_goal(G1, G), defined) :-
    possible_goal(G1),
    possible_goal(G).

fluent(descendant(M1, M), defined) :-
    activity(M1),
    activity(M),
    M1 != M.

fluent(in_progress(G), defined) :-
    possible_goal(G).

fluent(in_progress(M), defined) :-
    activity(M).

fluent(minor(M), defined) :-
    activity(M).

fluent(minor(G), defined) :-
    possible_goal(G).

fleunt(next_action(M, AA), defined) :-
    activity(M),
    agent_action(AA).

% actions:
mental_agent_action(start(M)) :-
    activity(M).

mental_agent_action(stop(M)) :-
    activity(M).

agent_action(wait).

special_exogenous_action(select(G)) :-
    possible(G).

special_exogenous_action(abandon(G)) :-
    possible_goal(G).
