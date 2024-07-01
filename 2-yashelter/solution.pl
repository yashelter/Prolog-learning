% solved with ♥ by yashelter

% Виновен 1 из 5 людишек
humans(Humans) :- Humans = ["Andrey", "Vitya", "Dima", "Yuri", "Tolya"].

% Андрей : Это или Витя, или Толя
statement("Andrey", Target):- Target = "Vitya"; Target = "Tolya".


% Витя: Это сделал не я и не Юра
statement("Vitya", Target):- Target \= "Vitya", Target \= "Yuri".


% Дима : Нет, один из них сказал правду, а другой неправду
statement("Dima", Target):-         
    (statement("Andrey", Target), not(statement("Vitya",Target)));
    (statement("Vitya", Target),  not(statement("Andrey", Target))).


% Юра : Нет, Дима ты не прав
statement("Yuri", Target):- not(statement("Dima", Target)).


% Проверяем виновен ли подозреваемый
check([], _).
check([Head | Tail], Target):- statement(Head, Target), check(Tail, Target).


% Так как (по словам отца) минимум трое говорят правду, 
% а два утверждения взаимоисключающие можно оптимизировать поиск,
% сказав что число говорящих правду = 3, и можно просто выкинуть 1 утверждение из поиска

solve(Target):-
    humans(All),
    delete(All, "Tolya", Speaked), % он ничего не говорил

    member(Target, All), % выбор того кто виновен
    member(Liar, Speaked), % выбор того кто солгал

    delete(Speaked, Liar, Correct), % не берём утверждение солгавшего на проверку
    
    check(Correct, Target). % проверяем все утверждения, для текущего подозреваемого

get_answer(R) :- solve(R), write('Window was broken by : '), write(R). % Толя

% solved with ♥ by yashelter