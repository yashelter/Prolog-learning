% Первая часть задания - предикаты работы со списками
% N = 9

length_s([],0).
length_s([_ | A], N) :- length_s(A, N1), N is N1+1.

member_s(A, [A|_]).
member_s(A, [_ | B]) :- member_s(A, B).

append_s([], X, X).
append_s([Head | Tail], Elem, [Head | NTail]) :- append_s(Tail, Elem, NTail).


remove_s(X, [X | T], T).
remove_s(X, [Y | T], [Y | T1]) :- remove_s(X, T, T1).

permutation_s([], []).
permutation_s(L, [X | T]) :- remove_s(X, L, R), permutation_s(R, T).

sublist_s(S, L) :- append_s(_, L1, L), append_s(S, _, L1).

% задание 1 (номер 10)
% Вставка элемента Element в список List на указанную позицию Position
% способ 1, без стандартных

% Если позиция равна 1, вставляем элемент в начало списка
insert(Element, List, 1, [Element | List]).

% Если позиция не равна 1, рекурсивно сдвигаемся к началу списка
% и доходим до случая, когда позиция = 1
insert(Element, [Head | Tail], Position, [Head | NewTail]) :-
    Position > 1,
    NewPosition is Position - 1,
    insert(Element, Tail, NewPosition, NewTail).


% способ 2, рекурсия в стандартных
insert2(Element, List, Pos, Result) :-
    Pos > 0, NewPos is Pos - 1,
    append(Prefix, Suffix, List), length(Prefix, NewPos),
    append(Prefix, [Element | Suffix], Result).



% задание 2 (номер 15)
% Вычисление позиции первого отрицательного элемента в списке

% способ 1 без стандартных(своя рекурсия)
search_minus(List, Result) :- search_minus(List, 1, Result).

search_minus([Head | _], Position, Result) :-
    Head < 0,
    Result is Position.

search_minus([Head | Rest], Position, Result) :-
    Head >= 0,
    NewPos is Position + 1,
    search_minus(Rest, NewPos, Result).


% способ 2 с использованием стандарных предикатов
% получаем массив из всех не отрицательных, а затем сравним с исходным
without_minus([], []).

without_minus([Head | Tail], Tail) :- Head < 0.

without_minus([Head | Tail], R) :-
    Head >= 0,
    without_minus(Tail, R_left),
    append([Head], R_left, R). 

search_minus_2(List, R) :-
    without_minus(List, Without_m),
    find_diff(List, Without_m, R, 1).

find_diff([], [], _, _) :- !, fail.

find_diff([_|_], [], Result, Pos) :- Result is Pos, !.

find_diff([Head1 | Tail1], [Head1 | Tail2], Result, Pos) :-
    NewPos is Pos + 1,
    find_diff(Tail1, Tail2, Result, NewPos).

find_diff([Head1 | _], [Head2 | _], Result, Pos) :- Head1 \= Head2, Result is Pos, !.
