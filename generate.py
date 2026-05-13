import csv
import sys
from itertools import combinations

VALID = {
    "especie": {
        "humano", 
        "animal", 
        "objeto",
        "insecto",
        "ser_magico"
        },

    "es_villano": {
        "si", 
        "no"
        },

    "es_protagonista": {
        "si", 
        "no"
        },

    "color_pelo": {
        "negro", 
        "rubio", 
        "rojo", 
        "cafe", 
        "morado",
        "naranja",
        "blanco",
        "gris",
        "azul",
        "ninguno"
        },
    "pelo": {
        "largo",
        "corto",
        "sin_pelo"
        },

    "es_magico": {
        "si", 
        "no"
        },

    "color_vestimenta": {
        "rojo", "azul", "verde", "amarillo", "negro", "blanco",
        "morado", "naranja", "rosa", "cafe", "gris", "na",
        },

    "vive_en": {
        "castillo", 
        "bosque",
        "selva",
        "mar", 
        "ciudad", 
        "desierto", 
        "pantano",
        "oceano",
        "otro"
        },

    "genero":{
        "masculino", 
        "femenino", 
        "na"
        },

    "habla": {"si", "no"},

    "edad": {"adulto", "nino"},
}

COLUMNAS = {"nombre"} | VALID.keys()

def cargar_csv(path):
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))

def validar_columnas(rows, errors):
    actual  = set(rows[0].keys())
    faltantes = COLUMNAS - actual
    extras    = actual - COLUMNAS
    if faltantes:
        errors.append(f"Faltan: {faltantes}")
    if extras:
        errors.append(f"No encontradas: {extras}")

def validar_filas(rows, errors):
    vistos = {}
    for i, row in enumerate(rows, start=2):
        nombre = row.get("nombre", "").strip()

        if not nombre:
            errors.append(f"Fila {i}: campo 'nombre' empty")
            continue

        if nombre in vistos:
            errors.append(
                f"Fila {i}: nombre duplicado '{nombre}' (ya existe en fila {vistos[nombre]})")
        else:
            vistos[nombre] = i

        for attr, validos in VALID.items():
            val = row.get(attr, "").strip()
            if not val:
                errors.append(f"{nombre}: campo '{attr}' vacío")
            elif val not in validos:
                errors.append(f"{nombre}: '{attr}={val}' no es válido  →  {sorted(validos)}")

def detectar_colisiones(rows, warnings):
    for (_, a), (_, b) in combinations(enumerate(rows), 2):
        attrs = lambda r: {k: v.strip() for k, v in r.items() if k != "nombre"}
        if attrs(a) == attrs(b):
            warnings.append(
                f"Colisión: '{a['nombre']}' y '{b['nombre']}' tienen atributos idénticos")

def validar(rows):
    errors, warnings = [], []
    if rows:
        validar_columnas(rows, errors)
    validar_filas(rows, errors)
    detectar_colisiones(rows, warnings)
    return errors, warnings

def generar_pl(rows, out_path):
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("% personajes.pl - AUTO-GENERADO por generate.py. NO EDITAR.\n\n")
        for row in rows:
            nombre = row["nombre"].strip()
            for attr in VALID:
                val = row[attr].strip()
                f.write(f"atributo({nombre}, {attr}, {val}).\n")
            f.write("\n")

def main():
    rows = cargar_csv("personajes.csv")
    errors, warnings = validar(rows)

    for w in warnings:
        print(f"[WARN]  {w}")
    for e in errors:
        print(f"[ERROR] {e}")

    if errors:
        print(f"\n✗ {len(errors)} error(s). personajes.pl no fue generado.")
        sys.exit(1)

    generar_pl(rows, "personajes.pl")
    print(f"✓ personajes.pl generado con {len(rows)} personaje(s).")
    if warnings:
        print(f"  {len(warnings)} advertencia(s) - revisar colisiones.")

if __name__ == "__main__":
    main()
