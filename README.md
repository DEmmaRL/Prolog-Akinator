# Akinator Disney - Prolog

Sistema experto que adivina personajes Disney haciendo preguntas de sí/no.
Implementado en SWI-Prolog con base de conocimiento generada desde CSV.

---

## Estructura del proyecto

```
.
├── personajes.csv       # ★ Fuente de verdad. Ingresar datos de personajes aquí, nunca en .pl
├── generate.py          # Valida el CSV y genera personajes.pl
├── personajes.pl        # AUTO-GENERADO. NO EDITAR MANUALMENTE.
├── categorias.pl        # Valores válidos por atributo (ENUMS).
├── motor.pl             # Lógica de preguntas y adivinación
├── main.pl              # Terminal de acceso
└── test.pl              # Suite de pruebas automáticas
```

---

## Flujo de trabajo

```
Editar personajes.csv
        ↓
python generate.py        ← valida campos, tipos, duplicados
        ↓
  personajes.pl           ← generado automáticamente
        ↓
swipl test.pl             ← correr pruebas
        ↓
swipl main.pl             ← jugar / probar manualmente
        ↓
git commit                ← historial = bitácora
```

---

## Cómo añadir un personaje

1. Abrir `personajes.csv`
2. Agregar una fila con **todos los campos** llenos
3. Correr `python generate.py`
4. Si hay errores, el script los imprime y **no genera el archivo**
5. Correr `swipl -g "test_todos, halt" test.pl` para verificar que no hay regresiones
6. Probar manualmente con `swipl main.pl`
7. Hacer commit

---

## Cómo añadir un atributo nuevo

*ANTES VALIDAR con el resto del equipo que se va a agregar el atributo.*

1. Agregar la columna en `personajes.csv` (usar `null` si el atributo no aplica para algunos personajes — ver Convenciones)
2. Agregar los valores válidos en `categorias.pl` (valores, `atributo/1`, `plantilla_pregunta/2`)
3. Agregar la validación en `VALID` dentro de `generate.py`
4. Correr `python generate.py`
5. Correr `swipl -g "test_todos, halt" test.pl`

---

## Atributos actuales

| Atributo         | Valores posibles                                                                    |
|------------------|-------------------------------------------------------------------------------------|
| especie          | humano, animal, objeto, insecto, ser_magico, juguete, sirena, monstruo              |
| es_villano       | si, no                                                                              |
| es_protagonista  | si, no                                                                              |
| color_pelo       | negro, rubio, rojo, cafe, blanco, morado, naranja, gris, azul, ninguno              |
| pelo             | largo, corto, sin_pelo                                                              |
| es_magico        | si, no                                                                              |
| color_vestimenta | rojo, azul, verde, amarillo, negro, blanco, morado, naranja, rosa, cafe, gris, na   |
| vive_en          | castillo, bosque, selva, mar, ciudad, desierto, pantano, oceano, pueblo, otro, otro_mundo |
| genero           | masculino, femenino, na                                                             |
| habla            | si, no                                                                              |
| edad             | adulto, nino, bebe, adolescente, anciano                                            |
| color_cuerpo     | rojo, azul, verde, amarillo, negro, blanco, morado, naranja, rosa, cafe, gris, na, null |

`na` = no aplica (ej. un animal no tiene vestimenta)
`null` = atributo opcional no definido para este personaje (el motor lo ignora al preguntar)

---

## Requisitos

- Python 3.x
- SWI-Prolog

---

## Correr el juego

```bash
python generate.py       # solo si editaste el CSV
swipl main.pl
?- jugar.
```

---

## Testing

`test.pl` simula el juego automáticamente para cada personaje usando el mismo motor de producción (`mejor_atributo`, `valor_mas_frecuente`, `construir_pregunta`, `filtrar`). La única diferencia con el juego real es que las respuestas se generan consultando los atributos del personaje en vez de leerlas del usuario.

**Correr todos los tests:**
```bash
swipl -g "test_todos, halt" test.pl
```

**Ver detalle de un personaje específico:**
```bash
swipl -g "test_detalle(mickey_mouse), halt" test.pl
```

El reporte muestra cuántos personajes fueron encontrados correctamente, promedio/máximo/mínimo de preguntas, y en caso de fallos, qué personaje se encontró en su lugar.

---

## Convenciones

- Nombres de personajes en `snake_case`, sin acentos, sin espacios
- Todos los valores en minúsculas
- Si un atributo no aplica para un personaje → `na`
- Si un atributo es opcional y no tiene valor para un personaje → `null` (el motor lo omite)
- No dejar campos vacíos — el validador los rechaza
