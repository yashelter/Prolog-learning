:- encoding(utf8).

% Пренадлежность
question('Кто', agent).
question('Кому', agent).
question('Чей', agent).
question('Чьё', agent).

% Предмет
question('Что', object).
question('Чего', object).
question('Чему', object).

% Место
question('Где', location).

% Списки состояний
statements('тут', location).
statements('здесь', location).
statements('там', location).

statements('Александр', agent).
statements('Александра', agent).
statements('Алина', agent).
statements('Эрен', agent).
statements('Даша', agent).
statements('Владислав', agent).

statements('шоколад', object).
statements('деньги', object).
statements('пролог', object).
statements('диаграммировать', object).
statements('программировать', object).

% Список форм глаголов
verb('любить', ['любить', 'любит']).
verb('лежать', ['лежать', 'лежат']).
verb('хотеть', ['хочешь', 'хочет']).

% Поиск формы глагола
find_form(Form, Result) :-
    verb(Result, Char),
    member(Form, Char).

% Слияние всё в одну строку
make_one_string(Strings, Resulting) :-
    % maplist применяет фукцию atom_chars для каждого из подсписков Strings, и результат суммирует в Lst
    maplist(atom_chars, Strings, Lst), % разбиваем на символы
    append(Lst, Char), % склеиваем в единый
    atom_chars(Resulting, Char). % собираем всё в строку verb(X, 'Что').

% Формирование строки в нужном формате
printf(Action, Type, Object, Subject, ActionObject, Result) :- 
    make_one_string([Action, '(', Type, '(', Object, '), ', Subject, '(', ActionObject, ')', ')'], Result).

% Обработка глаголов с подлежащим
solve(agent, ObjectType, Object, Action, Result) :- 
    printf(Action, agent, 'Y', ObjectType, Object, Result).

% Обработка глаголов с объектом
solve(object, ObjectType, Object, Action, Result) :- 
    printf(Action, ObjectType, Object, object, 'Y', Result).

% Обработка глаголов с местоположением
solve(location, ObjectType, Object, Action, Result) :- 
    printf(Action, ObjectType, Object, location, 'Y', Result).

% Обработка входных вопросов 
an_q([Question, Action, Object, '?'], Result) :- 
    find_form(Action, InfinitiveAction), % находим инфитив
    question(Question, QuestionType), % получаем типо вопроса
    statements(Object, ObjectType),  % получаем тип искомого объекта
    solve(QuestionType, ObjectType, Object, InfinitiveAction, Result), !. % создаём искомое предложение 
