# Manual de Usuario

Sistema Experto Akinator Disney

---

## Introducción

Akinator Disney es un sistema experto que adivina personajes Disney mediante preguntas de sí/no. El sistema utiliza inferencia lógica para reducir progresivamente el conjunto de candidatos hasta identificar el personaje correcto.

---

## Requisitos del Sistema

### Software Necesario

- **SWI-Prolog** 8.0 o superior
- **Python** 3.x (solo para modificar la base de datos)

### Instalación de SWI-Prolog

**macOS:**
```bash
brew install swi-prolog
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install swi-prolog
```

**Windows:**
Descargar desde [swi-prolog.org](https://www.swi-prolog.org/download/stable)

---

## Inicio Rápido

### 1. Clonar el Repositorio

```bash
git clone https://github.com/DEmmaRL/Prolog-Akinator.git
cd Prolog-Akinator
```

### 2. Iniciar el Juego

```bash
swipl main.pl
```

### 3. Comenzar a Jugar

En el prompt de Prolog, ejecutar:

```prolog
?- jugar.
```

---

## Cómo Jugar

### Paso 1: Pensar en un Personaje

Piensa en cualquier personaje Disney de los 120 disponibles en el sistema.

### Paso 2: Responder Preguntas

El sistema hará preguntas de sí/no. Responde con:

- `si.` (con punto al final)
- `no.` (con punto al final)

**Importante:** No olvides el punto al final de cada respuesta.

### Ejemplo de Sesión

```prolog
?- jugar.
Piensa en un personaje Disney...
¿Tu personaje vive en ciudad?
|: si.
¿Tu personaje no usa ropa?
|: no.
¿Tu personaje viste de rojo?
|: si.
¿Tu personaje es humano?
|: no.
¿Tu personaje tiene el pelo negro?
|: si.
¡Es mickey_mouse!
```

### Paso 3: Resultado

El sistema anunciará el personaje adivinado. En promedio, necesita 7-8 preguntas.

---

## Comandos Disponibles

### Jugar

Inicia una nueva partida.

```prolog
?- jugar.
```

### Salir

Para salir del sistema:

```prolog
?- halt.
```

O presiona `Ctrl+D` (Linux/macOS) o `Ctrl+Z` (Windows).

---

## Preguntas Frecuentes

### ¿Cuántos personajes conoce el sistema?

El sistema conoce 120 personajes Disney, desde clásicos hasta contemporáneos.

### ¿Cuántas preguntas hace normalmente?

En promedio, el sistema necesita 7-8 preguntas. El mínimo es 5 y el máximo 12.

### ¿Qué pasa si respondo mal?

Si respondes incorrectamente, el sistema puede no encontrar tu personaje o adivinar uno incorrecto. Asegúrate de responder con precisión.

### ¿Puedo agregar más personajes?

Sí. Consulta la sección "Modificar la Base de Datos" más abajo.

### ¿El sistema siempre acierta?

Si respondes correctamente a todas las preguntas, el sistema tiene 100% de precisión con los 120 personajes en su base de datos.

---

## Modificar la Base de Datos

### Agregar un Personaje

1. Abrir `personajes.csv`
2. Agregar una nueva fila con todos los atributos
3. Ejecutar el validador:

```bash
python3 generate.py
```

4. Si no hay errores, el archivo `personajes.pl` se regenera automáticamente
5. Probar el nuevo personaje:

```bash
swipl main.pl
?- jugar.
```

### Formato del CSV

Cada personaje debe tener exactamente 13 atributos:

```
nombre,especie,es_villano,es_protagonista,color_pelo,pelo,es_magico,color_vestimenta,vive_en,genero,habla,edad,color_cuerpo
```

**Ejemplo:**

```
elsa,humano,no,si,rubio,largo,si,azul,castillo,femenino,si,adulto,null
```

### Valores Válidos

Consulta `tabla-caracteristicas.md` para ver todos los valores permitidos por atributo.

---

## Solución de Problemas

### Error: "No encontré ningún personaje"

**Causa:** Las respuestas no coinciden con ningún personaje en la base de datos.

**Solución:** 
- Verifica que el personaje esté en la base de datos
- Asegúrate de responder correctamente
- Reinicia el juego con `jugar.`

### Error: "Syntax error"

**Causa:** Respuesta sin punto final o formato incorrecto.

**Solución:** Responde exactamente `si.` o `no.` (con punto).

### El sistema no inicia

**Causa:** SWI-Prolog no instalado o archivos faltantes.

**Solución:**
- Verifica que SWI-Prolog esté instalado: `swipl --version`
- Asegúrate de estar en el directorio correcto
- Verifica que existan `main.pl`, `motor.pl`, `personajes.pl` y `categorias.pl`

### Error al ejecutar generate.py

**Causa:** CSV con formato incorrecto o valores inválidos.

**Solución:**
- Lee el mensaje de error
- Corrige el CSV según el error indicado
- Vuelve a ejecutar `python3 generate.py`

---

## Testing

### Verificar el Sistema

Para probar que todos los personajes son encontrados correctamente:

```bash
swipl -g "test_todos, halt" test.pl
```

### Ver Detalle de un Personaje

Para ver el trace de preguntas de un personaje específico:

```bash
swipl -g "test_detalle(mickey_mouse), halt" test.pl
```

---

## Soporte

Para reportar problemas o sugerencias:

- **Repositorio:** [github.com/DEmmaRL/Prolog-Akinator](https://github.com/DEmmaRL/Prolog-Akinator)
- **Issues:** Crear un issue en GitHub
- **Documentación:** Consultar `README.md`

---

## Créditos

**Equipo de Desarrollo:**
- Dante Cortés Torres
- Angel Karim Barajas Castillo
- Alicia Lizbeth Pérez Gómez
- Diego Emmanuel Rivera López

**Tecnologías:**
- SWI-Prolog
- Python 3
- CSV para base de datos
