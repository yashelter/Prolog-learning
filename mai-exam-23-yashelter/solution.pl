% Губарев Михаил Сергеевич, М80-211Б-22
% Задача № 0
% Вариант № 1


% Часть 1:

/* 
ShapeType - тип лица (квадрат, круг, треугольник)
LookingTo - направление носа (лица) (лево, право, прямо)
EyesType - тип глаз (линии, квадрат, круг)
*/

% mask(ShapeType, LookingTo, EyesType).

% слева направо, сверху вниз
mask(square, left, lines).
mask(circle, right, circle).
mask(triangle, straight, square).

mask(circle, straight, square).
mask(triangle, left, lines).
mask(square, right, circle).

mask(triangle, right, circle).
mask(square, straight, square).

% Часть 2:
% для корректности кодировки во всех предикатах порядок одинаков
gettypes(N) :- N = [square, circle, triangle].
geteyes(N):- N = [lines, square, circle].
getlook(N):- N = [left, right, straight].

% находит все решения
buildnew(mask(NewShape, NewLookingTo, NewEyesType)) :-
    gettypes(Shapes),
    member(NewShape, Shapes),
    geteyes(Eyes),
    member(NewLookingTo, Eyes),
    getlook(Looking),
    member(NewEyesType, Looking),
    not(mask(NewShape, NewLookingTo, NewEyesType)).
    

% Часть 3:
/* Не хвостовая чтобы и наоборот находить*/
find(_, [], _) :- fail.

find(Elem, [Elem | _], 1).

find(Elem, [_ | Rest], Position) :-
    find(Elem, Rest, NewPos),
    Position is NewPos + 1.
    
% кодировка по позициям
getcode(mask(ShapeType, LookingTo, EyesType), R) :-
    gettypes(Shapes),
    geteyes(Eyes),
    getlook(Looking),
    find(ShapeType, Shapes, Pos1),
    find(LookingTo, Looking, Pos2),
    find(EyesType, Eyes, Pos3),
    R is (100 * Pos1 + 10 * Pos2 + Pos3), !.
% getcode(mask(square, left, lines), R)

% декодировка
getfromcode(Code, mask(ShapeType, LookingTo, EyesType)) :-
    Pos3 is Code mod 10,
    Pos2 is Code div 10 mod 10,
    Pos1 is Code div 100,
    gettypes(Shapes),
    geteyes(Eyes),
    getlook(Looking),
    find(ShapeType, Shapes, Pos1),
    find(LookingTo, Looking, Pos2),
    find(EyesType, Eyes, Pos3), !.

