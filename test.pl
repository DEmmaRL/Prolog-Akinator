% test.pl - Simulación automática del juego para todos los personajes.
% Usa construir_pregunta/3 igual que el sistema real.
% Lo único que no testea es read/1 (código de SWI-Prolog, no nuestro).
:- consult('main.pl').

% Simula el juego para un personaje objetivo.
% Devuelve el personaje encontrado y la lista de preguntas construidas.
test_jugar(Objetivo, Encontrado, Preguntas) :-
    todos_los_personajes(Ps),
    test_preguntar(Objetivo, Ps, [], Encontrado, Preguntas).

% Caso base: queda un solo candidato
test_preguntar(_Objetivo, [Unico], Qs, Unico, Qs).

% Caso base: sin candidatos
test_preguntar(_Objetivo, [], Qs, no_encontrado, Qs).

% Caso recursivo: misma lógica que preguntar/1 pero sin read
test_preguntar(Objetivo, Candidatos, QsAcc, Encontrado, Qs) :-
    Candidatos = [_,_|_],
    mejor_atributo(Candidatos, Attr),
    valor_mas_frecuente(Attr, Candidatos, Val),
    construir_pregunta(Attr, Val, Pregunta),          % igual que el sistema real
    (atributo(Objetivo, Attr, Val) -> Resp = si ; Resp = no),
    (   Resp == si
    ->  filtrar(Attr, Val, Candidatos, Restantes)
    ;   exclude(tiene(Attr, Val), Candidatos, Restantes)
    ),
    test_preguntar(Objetivo, Restantes,
                   [pregunta(Pregunta, Resp)|QsAcc],
                   Encontrado, Qs).

% Corre el test para todos los personajes e imprime reporte
test_todos :-
    todos_los_personajes(Ps),
    length(Ps, Total),
    maplist(test_uno, Ps, Resultados),
    include(correcto, Resultados, Correctos),
    length(Correctos, NCorrectos),
    Fallidos is Total - NCorrectos,
    maplist(n_preguntas, Correctos, Ns),
    sum_list(Ns, Suma),
    (NCorrectos > 0 -> Promedio is Suma / NCorrectos ; Promedio = 0),
    max_list(Ns, Max),
    min_list(Ns, Min),
    nl,
    format("~`=t~60|~n"),
    format("RESULTADO: ~w/~w encontrados correctamente~n", [NCorrectos, Total]),
    format("Preguntas - promedio: ~1f  max: ~w  min: ~w~n", [Promedio, Max, Min]),
    format("~`=t~60|~n"),
    (Fallidos > 0 ->
        format("~nFALLIDOS (~w):~n", [Fallidos]),
        include(fallido, Resultados, Rs),
        maplist(imprimir_fallido, Rs)
    ; true),
    nl,
    format("~w~30|~w~38|~w~n", ["Personaje", "OK", "Preguntas"]),
    format("~`-t~60|~n"),
    maplist(imprimir_resultado, Resultados).

% Muestra el detalle de preguntas para un personaje específico
test_detalle(Objetivo) :-
    test_jugar(Objetivo, Encontrado, Preguntas),
    nl,
    format("Personaje: ~w~n", [Objetivo]),
    (Objetivo == Encontrado ->
        format("Resultado: ✓ encontrado~n")
    ;
        format("Resultado: ✗ encontró ~w~n", [Encontrado])
    ),
    length(Preguntas, N),
    format("Preguntas (~w):~n", [N]),
    reverse(Preguntas, PsOrden),
    forall(member(pregunta(Q, R), PsOrden),
           format("  [~w] ~w~n", [R, Q])).

% Helpers
test_uno(P, resultado(P, Encontrado, NPreguntas)) :-
    test_jugar(P, Encontrado, Qs),
    length(Qs, NPreguntas).

correcto(resultado(P, P, _)).
fallido(resultado(P, E, _)) :- P \= E.
n_preguntas(resultado(_, _, N), N).

imprimir_fallido(resultado(P, Encontrado, N)) :-
    format("  ~w → encontró ~w (~w preguntas)~n", [P, Encontrado, N]).

imprimir_resultado(resultado(P, Encontrado, N)) :-
    (P == Encontrado -> OK = "✓" ; OK = "✗"),
    format("~w~30|~w~38|~w~n", [P, OK, N]).
