% Load Librerías
:- use_module(library(lists)).
:- discontiguous preguntar/1.

todos_los_personajes( Ps ) :-
    findall( P, atributo( P, especie, _ ), Ps ).

% Filtra personajes que tienen Attr = Val
filtrar( Attr, Val, Candidatos, Restantes ) :-
    include( tiene( Attr, Val ) , Candidatos, Restantes ).

tiene( Attr, Val, P ) :-
    atributo( P, Attr, Val ).

% Cuántos valores distintos tiene Attr entre los personajes actuales
score( Attr, Candidatos, Score ) :-
    findall( V, ( member( P, Candidatos ), atributo( P, Attr, V ) ), Vals ),
    sort( Vals, Unicos ),
    length( Unicos, Score ).

% Elige el atributo con mayor score
mejor_atributo( Candidatos, Mejor ) :-
        findall(                                                                                           
        Score-Attr,                                                   
        (                                                                                              
            atributo( Attr ),
            \+ (member(P, Candidatos), atributo(P, Attr, null)),
            score( Attr, Candidatos, Score ) % calcula el score de cada atributo                              
        ),                                                                                             
        Pares                
    ),                                                                                                   
    max_member( _-Mejor, Pares ).

% Si queda uno, lo imprimimos
preguntar( [Unico] ) :-
    nl, write( "¡Es " ), write( Unico ), write( "!" ), nl.

% No existe el personaje
preguntar( [] ) :-
    write( "No encontré ningún personaje con esas características." ), nl.

% Construye la pregunta interpolando {valor} en la plantilla
construir_pregunta(Attr, Val, Pregunta) :-
    (   Val == na, plantilla_na(Attr, Pregunta)
    ->  true
    ;   plantilla_pregunta(Attr, Plantilla),
        (   sub_string(Plantilla, _, _, _, "{valor}")
        ->  atom_string(Val, ValStr),
            atomic_list_concat(Partes, '{valor}', Plantilla),
            atomic_list_concat(Partes, ValStr, Pregunta)
        ;   Pregunta = Plantilla
        )
    ->  true
    ;   atomic_list_concat(['¿Tu personaje tiene ', Attr, ' = ', Val, '?'], Pregunta)
    ).

valor_mas_frecuente(Attr, Candidatos, ValFrec) :-
    findall(V, (member(P, Candidatos), atributo(P, Attr, V)), Vals),
    msort(Vals, Sorted),
    max_by_count(Sorted, ValFrec).

max_by_count([V|Vs], Max) :- max_by_count(Vs, V, 1, V, 1, Max).
max_by_count([], _, _, Best, _, Best).
max_by_count([V|Vs], Cur, N, Best, BestN, Max) :-
    (   V == Cur
    ->  N1 is N + 1,
        ( N1 > BestN -> max_by_count(Vs, Cur, N1, Cur, N1, Max)
                      ; max_by_count(Vs, Cur, N1, Best, BestN, Max) )
    ;   max_by_count(Vs, V, 1, Best, BestN, Max)
    ).

% Base case, no hay un solo personaje, seguir iterando
preguntar( Candidatos ) :-
    Candidatos = [_,_|_],
    mejor_atributo( Candidatos, Attr ),
    valor_mas_frecuente( Attr, Candidatos, Val ),
    construir_pregunta( Attr, Val, Pregunta ),
    write( Pregunta ), write( "" ),
    read( Resp ),
    (   Resp == si
    ->  filtrar( Attr, Val, Candidatos, Restantes )
    ;   exclude( tiene( Attr, Val ), Candidatos, Restantes )
    ),
    preguntar( Restantes ).

jugar :-
    todos_los_personajes( Ps ),
    write( "Piensa en un personaje Disney..." ), nl,
    preguntar( Ps ).