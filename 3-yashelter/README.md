## Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний


## Введение
Как ни странно решение логических головоломок, задач логического программирования и подобных, довольно удобно для описания на Прологе. Также задачи, где состояния можно представить графом будут удобны для решения на Прологе. Даже возможно некоторые задачи информационной безопасности могут удобно и просто решаться на Prologe (Но тут признаюсь не пробовал).

А удобно решать их, потому что, пролог основан на фактах и правилах. Что в отличии императивных языков, делает Prolog, более удобным инструменом для их быстрого решения. 


## Задание

Три миссионера и три каннибала хотят переправиться с левого берега реки на правый. Как это сделать за минимальное число шагов, если в их распоряжении имеется трехместная лодка и ни при каких обстоятельствах (в лодке или на берегу) миссионеры не должны оставаться в меньшинстве.

## Принцип решения

Задача будет решаться тремя способами: в глубину (dfs), в ширину (bfs), и с итерационным заглублением. Для начала опишем общие и вспомогательные предикаты, а затем решение для каждого из типа поиска.

### Предикаты для движения лодки
```prolog
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

``` 

### Проверка на корректность следующего шага

```prolog
% проверяет состояние после переправы лодки

check_for_can([M_left, C_left, _]) :-
	(M_left >= C_left ; M_left = 0),
	M_right is 3 - M_left, C_right is 3 - C_left,
	(M_right >= C_right ; M_right = 0).


% Создаёт все возможные следующие пути, из последнего состояния и сохраняет в путь
prolong([X|T], [Y, X|T]) :-
	move(X, Y),
	check_for_can(Y),
	not(member(Y, [X|T])).

```

### Функция вывода результата
```prolog
% восстанавливаем порядок
print_path(List) :-
	reverse(List, Res), cout(Res).

cout([_]). % один элемент не выводим

cout([Head, Next | Tail]) :-
	write(Head), write(' ---> '), write(Next), nl,
	cout([Next | Tail]).
```

#### Поиск в глубину
Идея в том, чтобы строить дерево вниз, исключая циклы `not(member())`. Однако не гарантируется, что первый найденный путь будет кратчайшим.

```prolog
% Поиск в глубину, DFS
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

```

#### Поиск в ширину
Идея в том, чтобы собирать очередь путей, где за шаг будем продлять каждый. Данная стратегия, в отличии от DFS, первым найдёт кратчайший путь, что может быть полезно при решении задач. 

Реализация:
```prolog
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

```
#### Поиск с итерационным заглублением
Это гибрид BFS и DFS, который не хранит весь путь и также находит сначала кратчайший. Это достигается добавлением ограничения глубины в поиск. Те сначала ищется какой-либо путь длины 1, затем 2 и так далее.
```prolog
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

```

## Результаты

Наиболее эффективным как ни странно оказался поиск с <i>итерационным заглублением</i>, и по скорости рядом с ним стоит <i>поиск в глубину</i>. А поиск в ширину занял гораздо больше времени, а также исходя из алгоритма и памяти.


| Алгоритм поиска |  Длина найденного первым пути  |  Время работы (s)  |
|-----------------|---------------------------------|---------------|
| В глубину       |                 9               | 0.00064      |
| В ширину        |                 5               | 0.00494        |
| Итер. загл.     |                 5               | 0.00061        |

<details>
  <summary>Характеристики системы</summary> 
	Так как характеристики компьютера влияют на конечный резульатат, было бы правильно приложить их.
	<ul>
		<li> Ryzen 7 5700X</li>
		<li> 32Gb Ram 3.7Hz</li>
		<li> Nvidia RTX 4070</li>
	</ul>
</details>


#### Полученные решения (первые)

BFS:

```prolog
[3,3,left] ---> [3,1,right]
[3,1,right] ---> [3,2,left]
[3,2,left] ---> [0,2,right]
[0,2,right] ---> [0,3,left]
[0,3,left] ---> [0,0,right]
```


DFS:
```prolog
[3,3,left] ---> [3,1,right]
[3,1,right] ---> [3,2,left]
[3,2,left] ---> [0,2,right]
[0,2,right] ---> [2,2,left]
[2,2,left] ---> [1,1,right]
[1,1,right] ---> [3,1,left]
[3,1,left] ---> [0,1,right]
[0,1,right] ---> [1,1,left]
[1,1,left] ---> [0,0,right]
```

Итерационным заглублением:

```prolog
[3,3,left] ---> [3,1,right]
[3,1,right] ---> [3,2,left]
[3,2,left] ---> [0,2,right]
[0,2,right] ---> [0,3,left]
[0,3,left] ---> [0,0,right]
```


## Выводы

Благодаря данной работе, я решал задачу с помощью трёх различных методов поиска. И так так, BFS и DFS я реализовывал на других императивных языках, я могу сказать, что не смотря на одну концепцию, выглядят и понимаются они по разному. Если DFS выглядит для Prolog'a естественно и понятно, без дополнительных разбирательств, то с BFS было намного сложнее, с точки зрения понимания кода, что наталкивает на мысль, что одно и тоже, даже при одном алгоритме, на императивных языках и декларативном Prolog'е может быть не с ходу узнаваемо и понятно.

Мне кажется что удобнее в рамках Prolog'а, когда не требуется кратчайший путб использовать DFS, так как он максимально понятен и прост, и не требует очереди как в BFS. Но если важен наикратчайший путь (решение), то я бы стал использовать поиск с итерационным заглублением, так как он не требует очереди, в отличии от BFS, но правда и чуть медленнее BFS (в перспективе, а не на первом решении).

Мне больше всего понравился поиск с итерационным заглублением, так как:
- [x] Я первый раз о нём услышал `uwu`
- [x] Сочетает в себе основные плюсы BFS и DFS
- [x] Имеет интересную конструкцию сам по себе


Эта работа особенно заставила меня задуматься о том, как можно `Prolog` Использовать в прикладных задачах, и в целом к новому подходу в алгоритмах, и у меня даже возникли некоторые идеи для pet-проектов. Надеюсь дальньнейший путь в Prolog'e будет так же интересен, и увлекателен.
