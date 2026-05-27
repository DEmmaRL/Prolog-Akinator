# Presentación de Predicados

Documentación Técnica del Sistema Experto Akinator Disney

---

## Índice

1. [Predicados Principales](#predicados-principales)
2. [Predicados de Inferencia](#predicados-de-inferencia)
3. [Predicados de Filtrado](#predicados-de-filtrado)
4. [Predicados de Construcción de Preguntas](#predicados-de-construcción-de-preguntas)
5. [Predicados de Testing](#predicados-de-testing)
6. [Base de Conocimiento](#base-de-conocimiento)

---

## Predicados Principales

### `jugar/0`

Inicia el juego interactivo.

**Signatura:**
```prolog
jugar.
```

**Descripción:**

Obtiene todos los personajes disponibles y comienza el proceso de inferencia mediante preguntas al usuario.

**Implementación:**
```prolog
jugar :-
    todos_los_personajes(Ps),
    write("Piensa en un personaje Disney..."), nl,
    preguntar(Ps).
```

**Uso:**
```prolog
?- jugar.
```

---

### `preguntar/1`

Motor principal de inferencia. Hace preguntas hasta identificar un personaje.

**Signatura:**
```prolog
preguntar(+Candidatos).
```

**Parámetros:**
- `Candidatos`: Lista de personajes candidatos

**Casos:**

**Caso 1: Un solo candidato (éxito)**
```prolog
preguntar([Unico]) :-
    nl, write("¡Es "), write(Unico), write("!"), nl.
```

**Caso 2: Sin candidatos (fallo)**
```prolog
preguntar([]) :-
    write("No encontré ningún personaje con esas características."), nl.
```

**Caso 3: Múltiples candidatos (recursión)**
```prolog
preguntar(Candidatos) :-
    Candidatos = [_,_|_],
    mejor_atributo(Candidatos, Attr),
    valor_mas_frecuente(Attr, Candidatos, Val),
    construir_pregunta(Attr, Val, Pregunta),
    write(Pregunta), write(""),
    read(Resp),
    (   Resp == si
    ->  filtrar(Attr, Val, Candidatos, Restantes)
    ;   exclude(tiene(Attr, Val), Candidatos, Restantes)
    ),
    preguntar(Restantes).
```

---

## Predicados de Inferencia

### `mejor_atributo/2`

Selecciona el atributo más discriminante entre los candidatos actuales.

**Signatura:**
```prolog
mejor_atributo(+Candidatos, -Mejor).
```

**Parámetros:**
- `Candidatos`: Lista de personajes candidatos
- `Mejor`: Atributo con mayor score (salida)

**Estrategia:**

Calcula el score de cada atributo (número de valores distintos) y selecciona el máximo. Ignora atributos donde algún candidato tiene valor `null`.

**Implementación:**
```prolog
mejor_atributo(Candidatos, Mejor) :-
    findall(
        Score-Attr,
        (
            atributo(Attr),
            \+ (member(P, Candidatos), atributo(P, Attr, null)),
            score(Attr, Candidatos, Score)
        ),
        Pares
    ),
    max_member(_-Mejor, Pares).
```

**Ejemplo:**
```prolog
?- mejor_atributo([mickey_mouse, minnie_mouse, donald_duck], Attr).
Attr = vive_en.
```

---

### `score/3`

Calcula cuántos valores distintos tiene un atributo entre los candidatos.

**Signatura:**
```prolog
score(+Attr, +Candidatos, -Score).
```

**Parámetros:**
- `Attr`: Atributo a evaluar
- `Candidatos`: Lista de personajes
- `Score`: Número de valores únicos (salida)

**Implementación:**
```prolog
score(Attr, Candidatos, Score) :-
    findall(V, (member(P, Candidatos), atributo(P, Attr, V)), Vals),
    sort(Vals, Unicos),
    length(Unicos, Score).
```

**Ejemplo:**
```prolog
?- score(especie, [mickey_mouse, aladdin, pinocchio], S).
S = 3.  % humano, animal, objeto
```

---

### `valor_mas_frecuente/3`

Encuentra el valor más común de un atributo entre los candidatos.

**Signatura:**
```prolog
valor_mas_frecuente(+Attr, +Candidatos, -ValFrec).
```

**Parámetros:**
- `Attr`: Atributo a evaluar
- `Candidatos`: Lista de personajes
- `ValFrec`: Valor más frecuente (salida)

**Implementación:**
```prolog
valor_mas_frecuente(Attr, Candidatos, ValFrec) :-
    findall(V, (member(P, Candidatos), atributo(P, Attr, V)), Vals),
    msort(Vals, Sorted),
    max_by_count(Sorted, ValFrec).
```

**Ejemplo:**
```prolog
?- valor_mas_frecuente(vive_en, [elsa, belle, aurora], V).
V = castillo.  % 3 de 3 viven en castillo
```

---

## Predicados de Filtrado

### `filtrar/4`

Filtra personajes que tienen un atributo con valor específico.

**Signatura:**
```prolog
filtrar(+Attr, +Val, +Candidatos, -Restantes).
```

**Parámetros:**
- `Attr`: Atributo a filtrar
- `Val`: Valor requerido
- `Candidatos`: Lista original
- `Restantes`: Lista filtrada (salida)

**Implementación:**
```prolog
filtrar(Attr, Val, Candidatos, Restantes) :-
    include(tiene(Attr, Val), Candidatos, Restantes).
```

**Ejemplo:**
```prolog
?- filtrar(especie, humano, [mickey_mouse, aladdin, belle], R).
R = [aladdin, belle].
```

---

### `tiene/3`

Verifica si un personaje tiene un atributo con valor específico.

**Signatura:**
```prolog
tiene(+Attr, +Val, +Personaje).
```

**Parámetros:**
- `Attr`: Atributo a verificar
- `Val`: Valor esperado
- `Personaje`: Personaje a verificar

**Implementación:**
```prolog
tiene(Attr, Val, P) :-
    atributo(P, Attr, Val).
```

**Ejemplo:**
```prolog
?- tiene(especie, humano, aladdin).
true.

?- tiene(especie, animal, aladdin).
false.
```

---

### `todos_los_personajes/1`

Obtiene la lista de todos los personajes en la base de datos.

**Signatura:**
```prolog
todos_los_personajes(-Personajes).
```

**Parámetros:**
- `Personajes`: Lista de todos los personajes (salida)

**Implementación:**
```prolog
todos_los_personajes(Ps) :-
    findall(P, atributo(P, especie, _), Ps).
```

**Ejemplo:**
```prolog
?- todos_los_personajes(Ps), length(Ps, N).
N = 120.
```

---

## Predicados de Construcción de Preguntas

### `construir_pregunta/3`

Genera el texto de una pregunta a partir de un atributo y valor.

**Signatura:**
```prolog
construir_pregunta(+Attr, +Val, -Pregunta).
```

**Parámetros:**
- `Attr`: Atributo sobre el que preguntar
- `Val`: Valor a preguntar
- `Pregunta`: Texto de la pregunta (salida)

**Casos:**

**Caso 1: Valor `na` (no aplica)**
```prolog
construir_pregunta(Attr, Val, Pregunta) :-
    Val == na,
    plantilla_na(Attr, Pregunta).
```

**Caso 2: Plantilla con interpolación**
```prolog
construir_pregunta(Attr, Val, Pregunta) :-
    plantilla_pregunta(Attr, Plantilla),
    sub_string(Plantilla, _, _, _, "{valor}"),
    atom_string(Val, ValStr),
    atomic_list_concat(Partes, '{valor}', Plantilla),
    atomic_list_concat(Partes, ValStr, Pregunta).
```

**Caso 3: Plantilla sin interpolación**
```prolog
construir_pregunta(Attr, _, Pregunta) :-
    plantilla_pregunta(Attr, Pregunta),
    \+ sub_string(Pregunta, _, _, _, "{valor}").
```

**Ejemplos:**
```prolog
?- construir_pregunta(vive_en, bosque, P).
P = "¿Tu personaje vive en bosque?".

?- construir_pregunta(color_vestimenta, na, P).
P = "¿Tu personaje no usa ropa?".

?- construir_pregunta(habla, si, P).
P = "¿Tu personaje habla?".
```

---

## Predicados de Testing

### `test_todos/0`

Ejecuta tests automáticos para todos los personajes.

**Signatura:**
```prolog
test_todos.
```

**Descripción:**

Simula el juego para cada personaje y reporta:
- Número de personajes encontrados correctamente
- Promedio, máximo y mínimo de preguntas
- Lista de fallos (si existen)

**Uso:**
```bash
swipl -g "test_todos, halt" test.pl
```

---

### `test_detalle/1`

Muestra el trace completo de preguntas para un personaje específico.

**Signatura:**
```prolog
test_detalle(+Personaje).
```

**Parámetros:**
- `Personaje`: Nombre del personaje a testear

**Uso:**
```bash
swipl -g "test_detalle(mickey_mouse), halt" test.pl
```

**Salida:**
```
Personaje: mickey_mouse
Resultado: ✓ encontrado
Preguntas (6):
  [si] ¿Tu personaje vive en ciudad?
  [no] ¿Tu personaje no usa ropa?
  [si] ¿Tu personaje viste de rojo?
  ...
```

---

### `test_jugar/3`

Simula el juego para un personaje objetivo.

**Signatura:**
```prolog
test_jugar(+Objetivo, -Encontrado, -Preguntas).
```

**Parámetros:**
- `Objetivo`: Personaje a buscar
- `Encontrado`: Personaje encontrado por el sistema (salida)
- `Preguntas`: Lista de preguntas hechas (salida)

**Implementación:**
```prolog
test_jugar(Objetivo, Encontrado, Preguntas) :-
    todos_los_personajes(Ps),
    test_preguntar(Objetivo, Ps, [], Encontrado, Preguntas).
```

---

## Base de Conocimiento

### `atributo/3`

Hecho que define los atributos de cada personaje.

**Signatura:**
```prolog
atributo(+Personaje, +Atributo, +Valor).
```

**Parámetros:**
- `Personaje`: Nombre del personaje
- `Atributo`: Nombre del atributo
- `Valor`: Valor del atributo

**Ejemplos:**
```prolog
atributo(mickey_mouse, especie, animal).
atributo(mickey_mouse, color_pelo, negro).
atributo(mickey_mouse, vive_en, ciudad).
```

**Consultas:**
```prolog
% ¿Cuál es la especie de Mickey?
?- atributo(mickey_mouse, especie, X).
X = animal.

% ¿Qué personajes viven en castillo?
?- atributo(P, vive_en, castillo).
P = elsa ;
P = belle ;
P = aurora ;
...

% ¿Qué atributos tiene Aladdin?
?- atributo(aladdin, A, V).
A = especie, V = humano ;
A = es_villano, V = no ;
A = es_protagonista, V = si ;
...
```

---

### `atributo/1`

Define los atributos válidos del sistema.

**Signatura:**
```prolog
atributo(?Atributo).
```

**Definición:**
```prolog
atributo(especie).
atributo(es_villano).
atributo(es_protagonista).
atributo(color_pelo).
atributo(pelo).
atributo(es_magico).
atributo(color_vestimenta).
atributo(vive_en).
atributo(genero).
atributo(habla).
atributo(edad).
atributo(color_cuerpo).
```

**Uso:**
```prolog
?- atributo(X).
X = especie ;
X = es_villano ;
...
```

---

### `valor_valido/2`

Define los valores válidos para cada atributo.

**Signatura:**
```prolog
valor_valido(+Atributo, ?Valor).
```

**Ejemplos:**
```prolog
valor_valido(especie, humano).
valor_valido(especie, animal).
valor_valido(vive_en, castillo).
valor_valido(vive_en, bosque).
```

**Uso:**
```prolog
% ¿Qué valores puede tener especie?
?- valor_valido(especie, X).
X = humano ;
X = animal ;
X = objeto ;
...
```

---

### `plantilla_pregunta/2`

Define las plantillas de preguntas para cada atributo.

**Signatura:**
```prolog
plantilla_pregunta(+Atributo, -Plantilla).
```

**Ejemplos:**
```prolog
plantilla_pregunta(vive_en, "¿Tu personaje vive en {valor}?").
plantilla_pregunta(habla, "¿Tu personaje habla?").
plantilla_pregunta(especie, "¿Tu personaje es {valor}?").
```

---

### `plantilla_na/2`

Define plantillas especiales para valores `na` (no aplica).

**Signatura:**
```prolog
plantilla_na(+Atributo, -Plantilla).
```

**Ejemplos:**
```prolog
plantilla_na(color_vestimenta, "¿Tu personaje no usa ropa?").
plantilla_na(genero, "¿Tu personaje no tiene género definido?").
```

---

## Complejidad Computacional

### Tiempo de Ejecución

- **Mejor caso:** O(log₂ n) - cuando cada pregunta divide candidatos en mitades iguales
- **Caso promedio:** O(log₂ n) - aproximadamente 7.7 preguntas para 120 personajes
- **Peor caso:** O(n) - cuando los atributos discriminan poco

### Espacio

- **Base de conocimiento:** O(n × m) donde n = personajes, m = atributos
- **Candidatos en memoria:** O(n) en el peor caso

---

## Notas de Implementación

### Estrategia de Búsqueda

El sistema usa una estrategia greedy basada en entropía de información. En cada paso:

1. Calcula el score de cada atributo (valores distintos)
2. Selecciona el atributo con mayor score
3. Pregunta por el valor más frecuente de ese atributo
4. Filtra candidatos según la respuesta

Esta estrategia no garantiza el mínimo de preguntas, pero es eficiente en la práctica.

### Manejo de Atributos Opcionales

Los atributos con valor `null` se ignoran automáticamente mediante:

```prolog
\+ (member(P, Candidatos), atributo(P, Attr, null))
```

Esto permite tener atributos opcionales sin afectar la lógica de inferencia.

---

## Referencias

- **Repositorio:** [github.com/DEmmaRL/Prolog-Akinator](https://github.com/DEmmaRL/Prolog-Akinator)
- **SWI-Prolog:** [swi-prolog.org](https://www.swi-prolog.org/)
- **Documentación adicional:** Ver `README.md`, `manual-usuario.md`, `tabla-caracteristicas.md`
