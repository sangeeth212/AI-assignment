% Define the state: state(Left, Right, BoatPosition)
% Left: People on the left bank
% Right: People on the right bank
% BoatPosition: Indicates where the boat is (left or right)

% Initial state: everyone on the left bank and boat is on the left side
initial(state([man, woman, child1, child2], [], left)).

% Goal state: everyone is on the right bank
goal(state([], [man, woman, child1, child2], _)).

% Move boat from left to right
move(state(L, R, left), state(L2, R2, right)) :-
    % Two people cross from left to right
    select(P1, L, L1), 
    select(P2, L1, L2),
    weight(P1, W1), 
    weight(P2, W2),
    W is W1 + W2, 
    W =< 100. % Ensure the weight limit is respected
    R2 = [P1, P2 | R].

% Move boat from right to left
move(state(L, R, right), state(L2, R2, left)) :-
    % Two people cross from right to left
    select(P1, R, R1), 
    select(P2, R1, R2),
    weight(P1, W1), 
    weight(P2, W2),
    W is W1 + W2, 
    W =< 100. % Ensure the weight limit is respected
    L2 = [P1, P2 | L].

% Allow a single person to cross (for cases where only one can cross)
move(state(L, R, left), state(L1, [P1 | R], right)) :-
    select(P1, L, L1),
    weight(P1, W1),
    W1 =< 100.

move(state(L, R, right), state([P1 | L], R1, left)) :-
    select(P1, R, R1),
    weight(P1, W1),
    W1 =< 100.

% Define weights of individuals
weight(man, 80).
weight(woman, 80).
weight(child1, 30).
weight(child2, 30).

% Solve the problem by finding a sequence of moves to reach the goal
solve(S, _, [S]) :- goal(S). % Base case: reached the goal state
solve(S, Visited, [S | Path]) :-
    move(S, S2), % Find a valid move
    \+ member(S2, Visited), % Ensure state is not revisited
    solve(S2, [S2 | Visited], Path).

% Print the solution steps with labeling for final solutions
print_solution(Solution, N) :-
    format('Solution ~w:~n', [N]),
    print_solution(Solution),
    writeln('').

% Print each step of the solution
print_solution([]).
print_solution([S | Rest]) :-
    writeln(S),
    print_solution(Rest).

% Main entry point with limited solutions
main :-
    initial(InitialState),
    find_solutions(InitialState, 3, 1). % Find up to 3 solutions

% Helper to find a limited number of solutions
find_solutions(State, MaxSolutions, N) :-
    N =< MaxSolutions,
    solve(State, [State], Solution),
    print_solution(Solution, N),
    fail. % Force backtracking to find the next solution

find_solutions(_, MaxSolutions, N) :-
    N > MaxSolutions, !. % Stop when the max number of solutions is reached

find_solutions(State, MaxSolutions, N) :- % Continue to the next solution
    N1 is N + 1,
    find_solutions(State, MaxSolutions, N1).