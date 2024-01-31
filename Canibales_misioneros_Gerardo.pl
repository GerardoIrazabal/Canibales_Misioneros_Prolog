% Problema de Misioneros y Caníbales

% Estado inicial y final
estado_inicial(estado(3, 3, izq)).
estado_final(estado(0, 0, der)).

% Condición de peligro
en_peligro(estado(M, C, _)) :- M < C, M > 0.
en_peligro(estado(M, C, _)) :- M > C, C > 0, M < 3.

% Acciones posibles
% Mover un misionero
accion(estado(M, C, izq), estado(NM, C, der), 'Misionero cruza a derecha') :- 
    NM is M - 1, \+ en_peligro(estado(NM, C, der)), NM >= 0.
accion(estado(M, C, der), estado(NM, C, izq), 'Misionero regresa a izquierda') :-
    NM is M + 1, \+ en_peligro(estado(NM, C, izq)), NM =< 3.

% Mover un caníbal
accion(estado(M, C, izq), estado(M, NC, der), 'Caníbal cruza a derecha') :-
    NC is C - 1, \+ en_peligro(estado(M, NC, der)), NC >= 0.
accion(estado(M, C, der), estado(M, NC, izq), 'Caníbal regresa a izquierda') :-
    NC is C + 1, \+ en_peligro(estado(M, NC, izq)), NC =< 3.

% Mover un misionero y un caníbal
accion(estado(M, C, izq), estado(NM, NC, der), 'Misionero y Caníbal cruzan a derecha') :-
    NM is M - 1, NC is C - 1, \+ en_peligro(estado(NM, NC, der)), NM >= 0, NC >= 0.
accion(estado(M, C, der), estado(NM, NC, izq), 'Misionero y Caníbal regresan a izquierda') :-
    NM is M + 1, NC is C + 1, \+ en_peligro(estado(NM, NC, izq)), NM =< 3, NC =< 3.

% Mover dos misioneros o dos caníbales
accion(estado(M, C, izq), estado(NM, C, der), 'Dos Misioneros cruzan a derecha') :-
    NM is M - 2, \+ en_peligro(estado(NM, C, der)), NM >= 0.
accion(estado(M, C, izq), estado(M, NC, der), 'Dos Caníbales cruzan a derecha') :-
    NC is C - 2, \+ en_peligro(estado(M, NC, der)), NC >= 0.

% Buscar solución
buscar_solucion(Estado, Estado, _, []).
buscar_solucion(EstadoActual, EstadoFinal, Visitados, [Movimiento|RestoMovimientos]) :-
    accion(EstadoActual, EstadoSiguiente, Movimiento),
    \+ member(EstadoSiguiente, Visitados),
    buscar_solucion(EstadoSiguiente, EstadoFinal, [EstadoSiguiente|Visitados], RestoMovimientos).

% Iniciar búsqueda
iniciar :-
    estado_inicial(EstadoIni),
    estado_final(EstadoFin),
    buscar_solucion(EstadoIni, EstadoFin, [EstadoIni], Movimientos),
    mostrar_solucion(Movimientos).

% Mostrar solución
mostrar_solucion([]) :- writeln('Todos han cruzado el río con éxito.').
mostrar_solucion([M|Ms]) :-
    writeln(M),
    mostrar_solucion(Ms).

% Para ejecutar: ?- iniciar.
