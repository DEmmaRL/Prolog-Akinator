# Tabla de Características

Sistema Experto Akinator Disney - Atributos y Valores Válidos

---

## Atributos del Sistema

El sistema utiliza 13 atributos para discriminar entre 120 personajes Disney.

### 1. Especie

Tipo de ser del personaje.

| Valor | Descripción |
|-------|-------------|
| humano | Personaje humano |
| animal | Animal antropomórfico o realista |
| objeto | Objeto animado o juguete |
| insecto | Insecto antropomórfico |
| ser_magico | Hada, genio, criatura mágica |
| juguete | Juguete específicamente |
| sirena | Criatura marina mitológica |
| monstruo | Monstruo o criatura fantástica |

### 2. Es Villano

Indica si el personaje es antagonista.

| Valor | Descripción |
|-------|-------------|
| si | El personaje es villano o antagonista |
| no | El personaje no es villano |

### 3. Es Protagonista

Indica si el personaje es protagonista de su historia.

| Valor | Descripción |
|-------|-------------|
| si | Personaje principal de la película |
| no | Personaje secundario o de reparto |

### 4. Color de Pelo

Color predominante del cabello.

| Valor | Descripción |
|-------|-------------|
| negro | Cabello negro |
| rubio | Cabello rubio o amarillo |
| rojo | Cabello rojo o pelirrojo |
| cafe | Cabello café o castaño |
| blanco | Cabello blanco o canoso |
| morado | Cabello morado o púrpura |
| naranja | Cabello naranja |
| gris | Cabello gris |
| azul | Cabello azul |
| ninguno | Sin cabello visible |

### 5. Pelo

Longitud del cabello.

| Valor | Descripción |
|-------|-------------|
| largo | Cabello largo |
| corto | Cabello corto |
| sin_pelo | Sin cabello |

### 6. Es Mágico

Indica si el personaje posee o usa magia.

| Valor | Descripción |
|-------|-------------|
| si | Tiene poderes mágicos o es mágico por naturaleza |
| no | No posee magia |

### 7. Color de Vestimenta

Color predominante de la ropa.

| Valor | Descripción |
|-------|-------------|
| rojo | Vestimenta roja |
| azul | Vestimenta azul |
| verde | Vestimenta verde |
| amarillo | Vestimenta amarilla |
| negro | Vestimenta negra |
| blanco | Vestimenta blanca |
| morado | Vestimenta morada |
| naranja | Vestimenta naranja |
| rosa | Vestimenta rosa |
| cafe | Vestimenta café |
| gris | Vestimenta gris |
| na | No usa ropa |

### 8. Vive En

Hábitat o lugar donde vive el personaje.

| Valor | Descripción |
|-------|-------------|
| castillo | Vive en un castillo |
| bosque | Vive en el bosque |
| selva | Vive en la selva |
| mar | Vive en el mar |
| ciudad | Vive en una ciudad |
| desierto | Vive en el desierto |
| pantano | Vive en un pantano |
| oceano | Vive en el océano |
| pueblo | Vive en un pueblo |
| sabana | Vive en la sabana |
| otro | Otro lugar no especificado |
| otro_mundo | Vive en un mundo fantástico |
| juego | Vive dentro de un videojuego |

### 9. Género

Género del personaje.

| Valor | Descripción |
|-------|-------------|
| masculino | Personaje masculino |
| femenino | Personaje femenino |
| na | No aplica o no definido |

### 10. Habla

Indica si el personaje puede hablar.

| Valor | Descripción |
|-------|-------------|
| si | El personaje habla |
| no | El personaje no habla |

### 11. Edad

Grupo etario del personaje.

| Valor | Descripción |
|-------|-------------|
| adulto | Personaje adulto |
| nino | Personaje niño |
| bebe | Personaje bebé |
| adolescente | Personaje adolescente |
| anciano | Personaje anciano |

### 12. Color de Cuerpo

Color predominante del cuerpo (para personajes sin ropa).

| Valor | Descripción |
|-------|-------------|
| rojo | Cuerpo rojo |
| azul | Cuerpo azul |
| verde | Cuerpo verde |
| amarillo | Cuerpo amarillo |
| negro | Cuerpo negro |
| blanco | Cuerpo blanco |
| morado | Cuerpo morado |
| naranja | Cuerpo naranja |
| rosa | Cuerpo rosa |
| cafe | Cuerpo café |
| gris | Cuerpo gris |
| na | No aplica |
| null | No definido para este personaje |

---

## Convenciones

### Valor `na` (No Aplica)

Se usa cuando el atributo no tiene sentido para el personaje.

**Ejemplos:**
- Un pez no usa ropa → `color_vestimenta = na`
- Un objeto no tiene género biológico → `genero = na`

### Valor `null` (No Definido)

Se usa cuando el atributo es opcional y no se ha definido para el personaje. El motor ignora estos atributos al hacer preguntas.

**Ejemplos:**
- Mickey tiene ropa, no necesitamos su color de cuerpo → `color_cuerpo = null`
- Un personaje con pelo definido → `color_cuerpo = null`

---

## Estadísticas

- **Total de atributos:** 13
- **Total de personajes:** 120
- **Valores únicos totales:** 87
- **Promedio de preguntas:** 7.7
- **Precisión:** 100%
