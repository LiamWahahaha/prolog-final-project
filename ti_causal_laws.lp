% mental and physical agent actions
holds(status(M, 0), I + 1) :-     % (0.1)
    occurs(start(M), I).

holds(status(M, -1), I + 1) :-    % (0.2)
    occurs(stop(M), I).

holds(status(M, K + 1), I + 1) :- % (0.3)
    occurs(physical_agent_action(PAA), I),
    holds(next_action(M, physical_agent_action(PAA), I),
    holds(status(M, K), I),
    component(M, K + 1, physical_agent_action(PAA)).

holds(status(M, K + 1), I + 2) :- % (0.4)
    occurs(stop(M1), I),
    holds(status(M, K), I),
    component(M, K + 1, M1),
    holds(next_action(M, stop(M1)), I).

holds(status(M1, -1), I + 1) :-   % (0.5)
    occurs(stop(M), I),
    holds(descendant(M1, M), I).

holds(next_name(M + 1), I) :-     % (0.6)
    occurs(stop(M), I),
    holds(next_name(M), I),
    -holds(minor(M), I).
