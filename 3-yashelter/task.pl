:- encoding(utf8).

% Возьмём два состояния - два берега для них храним: количества миссионеров (Humans) и каннибалов (ManEaters), тут ли лодка
% это позволит не учитывать саму лодку как обьект, а лишь учитывать изменения на берегах

% переезжают вправо

move([Humans1, ManEaters1, left], [Humans2, ManEaters1, right]) :-
    Humans1 > 0, Humans2 is Humans1 - 1.
move([Humans1, ManEaters1, left], [Humans2, ManEaters1, right]) :-
    Humans1 > 1, Humans2 is Humans1 - 2.
move([Humans1, ManEaters1, left], [Humans2, ManEaters1, right]) :-
    Humans1 = 3, Humans2 is 0.
move([Humans1, ManEaters1, left], [Humans1, ManEaters2, right]) :-
    ManEaters1 > 0, ManEaters2 is ManEaters1 - 1.
move([Humans1, ManEaters1, left], [Humans1, ManEaters2, right]) :-
    ManEaters1 > 1, ManEaters2 is ManEaters1 - 2.
move([Humans1, ManEaters1, left], [Humans1, ManEaters2, right]) :-
    ManEaters1 = 3, ManEaters2 is 0.
move([Humans1, ManEaters1, left], [Humans2, ManEaters2, right]) :-
    Humans1 > 0, ManEaters1 > 0, Humans2 is Humans1 - 1, ManEaters2 is ManEaters1 - 1.
move([Humans1, ManEaters1, left], [Humans2, ManEaters2, right]) :-
    Humans1 > 1, ManEaters1 > 0, Humans2 is Humans1 - 2, ManEaters2 is ManEaters1 - 1.

% переезжают влево
move([Humans1, ManEaters1, right], [Humans2, ManEaters1, left]) :-
    Humans1 < 3, Humans2 is Humans1 + 1.
move([Humans1, ManEaters1, right], [Humans2, ManEaters1, left]) :-
    Humans1 < 2, Humans2 is Humans1 + 2.
move([Humans1, ManEaters1, right], [Humans1, ManEaters2, left]) :-
    ManEaters1 < 3, ManEaters2 is ManEaters1 + 1.
move([Humans1, ManEaters1, right], [Humans1, ManEaters2, left]) :-
    ManEaters1 < 2, ManEaters2 is ManEaters1 + 2.
move([Humans1, ManEaters1, right], [Humans2, ManEaters2, left]) :-
    Humans1 < 3, ManEaters1 < 3, Humans2 is Humans1 + 1, ManEaters2 is ManEaters1 + 1.
move([Humans1, ManEaters1, right], [Humans2, ManEaters2, left]) :-
    Humans1 < 2, ManEaters1 < 3, Humans2 is Humans1 + 2, ManEaters2 is ManEaters1 + 1.
move([Humans1, ManEaters1, right], [Humans2, ManEaters1, left]) :-
    Humans1 = 0, Humans2 is 3.
move([Humans1, ManEaters1, right], [Humans1, ManEaters2, left]) :-
    ManEaters1 = 0, ManEaters2 is 3.


% условие на количество миссионеров (проверяет состояние после переправы лодки).

check_for_can([M_left, C_left, _]) :-
	(M_left >= C_left ; M_left = 0),
	M_right is 3 - M_left, C_right is 3 - C_left,
	(M_right >= C_right ; M_right = 0).


% Создаёт все возможные следующие пути, из последнего состояния и сохраняет в путь
prolong([X|T], [Y, X|T]) :-
	move(X, Y),
	check_for_can(Y),
	not(member(Y, [X|T])).


% Поиск в глубину (DFS)
path_dfs([Y|T], Y, [Y|T]).

path_dfs(PrevPath, Y, R) :-
	prolong(PrevPath, P1),
	path_dfs(P1, Y, R).


solve_dfs() :-
	get_time(T),
	path_dfs([[3, 3, left]], [0, 0, right], Res),
	print_path(Res),
	write("Time waited : "),
	get_time(T1), DT is T1 - T, write(DT), write(" seconds"), nl.


% Поиск в ширину (BFS)
path_bfs([[Target|Tail]|_], Target, [Target|Tail]).

path_bfs([CurrentPath | QueueInput], X, Result) :-
	findall(Elem, prolong(CurrentPath, Elem), List),
	append(QueueInput, List, QueueOutput), !,
	% знак ! стоит именно тут, чтобы отсечь варианты, которые будут только длиннее
	path_bfs(QueueOutput, X, Result). % на самом деле хвостовая рекурсия

path_bfs([_|Tail], Target, R) :- path_bfs(Tail, Target, R).

solve_bfs() :-
	get_time(T),
	path_bfs([ [[3, 3, left]] ], [0, 0, right], Res),
	print_path(Res),
	write("Time waited : "),
	get_time(T1), DT is T1 - T, write(DT), write(" seconds"), nl.


% Вспомогательный предикат для поиска с итер. загл.
int(1).
int(M) :- int(N), M is N + 1.


% Поиск с итерационным заглублением
solve_better_bfsdfs([X|T], X, [X|T], 0).

solve_better_bfsdfs(P, Y, R, N) :- 
	N > 0,
	prolong(P, P1),
	N1 is N - 1,
	solve_better_bfsdfs(P1, Y, R, N1).


solve_iterations() :-
	get_time(T),
	int(MaxDeep),
	solve_better_bfsdfs([[3, 3, left]], [0, 0, right], Res, MaxDeep),
	print_path(Res),
	write("Time waited : "),
	get_time(T1), DT is T1 - T, write(DT), write(" seconds"), nl.



% восстанавливаем порядок
print_path(List) :-
	reverse(List, Res), cout(Res).

cout([_]). % один элемент не выводим

cout([Head, Next | Tail]) :-
	write(Head), write(' ---> '), write(Next), nl,
	cout([Next | Tail]).