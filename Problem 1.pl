% Facts
male(john). % Example: John is male
male(david). % David is John's son (the person solving the riddle)
male(that_man). % The man being referred to in the riddle

% Parent relationships
parent(john, david). % John is David's father
parent(david, that_man). % David is the father of "that man" in the riddle

% Rules to find father
father(Father, Child) :- parent(Father, Child), male(Father).

% Solve the riddle with explanation
solve_riddle :-
    % The speaker (David) has no brothers or sisters, so "my father's son" is the speaker (David).
    father(X, that_man), % X is the father of "that man"
    father(Y, X), % Y is the father of X (David's father, John)
    write('Step 1: '), write('My father\'s son is myself, so "my father\'s son" refers to me (David).'), nl,
    write('Step 2: '), write('That man\'s father is me (David), which means that man must be my son.'), nl,
    write('Step 3: '), write('The solution is: That man is my son.'), nl,
    write('That man is: '), write(X), nl.


% ?- solve_riddle.