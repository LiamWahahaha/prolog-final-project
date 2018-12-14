% mental and physical agent actions
holds(status(M, 0), I + 1) :-               % (0.1)
    occurs(start(M), I).

holds(status(M, -1), I + 1) :-              % (0.2)
    occurs(stop(M), I).

holds(status(M, K + 1), I + 1) :-           % (0.3)
    occurs(physical_agent_action(PAA), I),
    holds(next_action(M, physical_agent_action(PAA), I),
    holds(status(M, K), I),
    component(M, K + 1, physical_agent_action(PAA)).

holds(status(M, K + 1), I + 2) :-           % (0.4)
    occurs(stop(M1), I),
    holds(status(M, K), I),
    component(M, K + 1, M1),
    holds(next_action(M, stop(M1)), I).

holds(status(M1, -1), I + 1) :-             % (0.5)
    occurs(stop(M), I),
    holds(descendant(M1, M), I).

holds(next_name(M + 1), I) :-               % (0.6)
    occurs(stop(M), I),
    holds(next_name(M), I),
    -holds(minor(M), I).

% special exogenous actions
holds(active_goal(G), I + 1) :-             % (0.7)
    occurs(select(G), I).

-holds(active_goal(G), I + 1) :-            % (0.8)
    occurs(abandon(G), I).

% executability conditions
% agent actions
impossible(start(M), I) :-                  % (0.9)
    holds(active(M), I).

impossible(stop(M), I) :-                   %(0.10)
    holds(active(M), I).

impossible(PAA, I) :-                       %(0.11)
    occurs(MAA, I).
impossible(MAA, I) :-
    occurs(PAA, I).
impossible(MAA1, I) :-
    occurs(MAA2, I),
    MAA1 != MAA2.
impossible(MAA2, I) :-
    occurs(MAA1, I),
    MAA2 != MAA1.

impossible(PAA, I) :-                       %(0.12)
    occurs(wait, I).
impossible(wait, I) :-
    occurs(PAA, I).
impossible(MAA, I) :-
    occurs(wait, I).
impossible(wait, I) :-
    occurs(MAA, I).

% special exogenous action
impossible(select(G), I) :-                 %(0.13)
    holds(active_goal(G), I).

impossible(abandon(G), I) :-                %(0.14)
    holds(active_goal(G), I).
impossible(abandon(G), I) :-
    holds(minor(G), I).

% special exogenous, physical agent and mental agent actions
impossible(PEA, I) :-                       %(0.15)
    occurs(SEA, I).
impossible(MAA, I) :-
    occurs(SEA, I).
impossible(PAA, I) :-
    occurs(SEA, I).
impossible(SEA, I) :-
    occurs(PEA, I);
    occurs(MAA, I);
    occurs(PAA, I).

% state constraints
% inertial fluents
-holds(status(M, K1), I) :-                 %(0.16)
    holds(status(M, K2), I),
    K1 != K2.

-holds(next_name(M), I) :-                  %(0.17)
    holds(next_name(M1), I),
    M != M1.

-holds(active_goal(G), I) :-                %(0.18)
    -holds(minor(G), I),
    holds(G, I).

holds(active_goal(G1), I) :-                %(0.19)
    holds(immediate_child_goal(G1, G), I),
    holds(active_goal(G), I),
    goal(M, G),
    goal(M1, G1),
    -holds(G1, I),
    holds(status(M1, -1), I).

-holds(active_goal(G1), I) :-               %(0.20)
    holds(minor(G1), I),
    holds(immediate_child_goal(G1, G), I),
    -holds(active_goal(G), I).

-holds(active_goal(G1), I) :-               %(0.21)
    holds(minor(G1), I),
    holds(G1, I),
    holds(immediate_child_goal(G1, G), I),
    holds(active_goal(G), I).

-holds(active_goal(G1), I) :-               %(0.22)
    holds(minor(G1), I),
    goal(M1, G1),
    holds(status(M1, K1), I),
    length(M1, K1),
    -holds(G1, I),
    holds(immediate_child_goal(G1, G), I),
    holds(active_goal(G), I).

% defined fluents
holds(active(M), I) :-                      %(0.23)
    -holds(status(M, -1), I).

holds(immediate_child(M1, M), I) :-         %(0.24)
    component(M, K + 1, M1),
    holds(status(M, K), I).

holds(descendant(M1, M), I) :-              %(0.25)
    holds(immediate_child(M1, M), I).
holds(descendant(M2, M), I) :-
    holds(immediate_child(M1, M), I),
    holds(immediate_child(M2, M1), I).

holds(immediate_child_goal(G1, G), I) :-    %(0.26)
    holds(immediate_child(M1, M), I),
    goal(M, G),
    goal(M1, G1).

holds(minor(M1), I) :-                      %(0.27)
    holds(immediate_child(M1, M), I).

holds(minor(G1), I) :-                      %(0.28)
    holds(immediate_child_goal(G1, G), I).

holds(in_progress(M), I) :-                 %(0.29)
    holds(active(M), I),
    holds(active_goal(G), I),
    goal(M, G).

holds(in_progress(G), I) :-                 %(0.30)
    holds(active(M), I),
    holds(active_goal(G), I),
    goal(M, G).

holds(next_action(M, PAA), I) :-            %(0.31)
    holds(status(M, K), I),
    component(M, K + 1, PAA),
    holds(in_progress(M), I).

holds(next_action(M, start(M1)), I) :-      %(0.32)
    holds(status(M, K), I),
    component(M, K + 1, M1),
    holds(in_progress(M), I),
    -holds(active(M1), I).

holds(next_action(M, AA), I) :-             %(0.33)
    holds(status(M, K), I),
    component(M, K + 1, M1),
    holds(in_progress(M), I),
    holds(in_progress(M1), I),
    holds(next_action(M1, AA), I).

holds(next_action(M, stop(M1)), I) :-       %(0.34)
    holds(status(M, K), I),
    component(M, K + 1, M1),
    holds(in_progress(M), I),
    holds(active(M1), I),
    goal(M1, G1),
    -holds(active_goal(G1), I).
