index(-1..100).

activity(X) :-
    activity_name(X).

fluent(X) :-
    fluent(X, inertial).

fluent(X) :-
    fluent(X, defined).

agent_action(X) :-
    physical_agent_action(X).

agent_action(X) :-
    mental_agent_action(X).

exogenous_action(X) :-
    physical_exogenous_action(X).


exogenous_action(X) :-
    special_exogenous_action(X).

action(X) :-
    agent_action(X).

action(X) :-
    exogenous_action(X).
