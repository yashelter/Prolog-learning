% Task 2: Relational Data
:- encoding(utf8).
% The line below imports the data
:- ['two.pl'].



% task 1


% список предметов
get_subj_list(R) :- findall(Subj, grade(_, _, Subj, _), Subjs), sort(Subjs, R).

% сумма списка
sum_list_s([], 0).
sum_list_s([Head|Tail], Sum) :- sum_list(Tail, TailSum), Sum is Head + TailSum.

% ср. оценка на предмет
get_averenge_mark(Subj, Result) :- 
    findall(Mark, grade(_, _, Subj, Mark), Marks),
    sum_list_s(Marks, Sum),
    length(Marks, Num),
    Result is Sum / Num.

% вспомогательная функиция
get_averenge_marks() :-
    get_subj_list(R),
    get_averenge_marks(R).

get_average_marks([]).

% рекурсивно идём по всем предметам 
get_averenge_marks([Head | Tail]) :-
    get_averenge_mark(Head, Mark),
    write("Averange for "), write(Head), write(" is : "), write(Mark), nl,
    get_averenge_marks(Tail).

% get_averenge_marks(). - получает все средние оценки по каждому предмету



% task2

% Получаем список всех групп
get_group_list(R) :- findall(Group, grade(Group, _, _, _), Groups), sort(Groups, R).

% сколько 2ек людей в группе
get_bad_for_group(Group, Result) :- 
    findall(X, grade(Group, X, _, 2), People), sort(People, PeopleList),
    length(PeopleList, Num),
    Result is Num.

% вспомогательная
get_bad_for_groups() :-
    get_group_list(Groups),
    get_bad_for_groups(Groups).

get_bad_for_groups([]).

% идём рекурсивно по всем группам
get_bad_for_groups([Head | Tail]) :-
    get_bad_for_group(Head, Mark),
    write("Count bad for group "), write(Head), write(" is : "), write(Mark), nl,
    get_bad_for_groups(Tail).

% get_bad_for_groups. - получает кол-во человек с 2 в группе



% task 3

% все с двойкой по этому предмету
get_bad_for_subj(Subj, Result) :- 
    findall(X, grade(_, X, Subj, 2), People), sort(People, PeopleList),
    length(PeopleList, Num),
    Result is Num.

% вспомогательная
get_bad_for_subj :-
    get_subj_list(Subjects),
    get_bad_for_subj(Subjects).

get_bad_for_subj([]).

% идём рекурсивно по предметам
get_bad_for_subj([Head | Tail]) :-
    get_bad_for_subj(Head, Cnt),
    write("Count bad for subject "), write(Head), write(" is : "), write(Cnt), nl,
    get_bad_for_subj(Tail).
