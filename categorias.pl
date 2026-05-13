% categorias.pl - Valores válidos por atributo (ENUMs)
% SST

valor_valido(especie,humano).
valor_valido(especie,animal).
valor_valido(especie,objeto).
valor_valido(especie,insecto).
valor_valido(especie,ser_magico).

valor_valido(es_villano,si).
valor_valido(es_villano,no).

valor_valido(es_protagonista, si).
valor_valido(es_protagonista, no).

valor_valido(color_pelo,negro).
valor_valido(color_pelo,rubio).
valor_valido(color_pelo,rojo).
valor_valido(color_pelo,morado).
valor_valido(color_pelo,naranja).
valor_valido(color_pelo,cafe).
valor_valido(color_pelo,blanco).
valor_valido(color_pelo,gris).
valor_valido(color_pelo,azul).
valor_valido(color_pelo,ninguno).

valor_valido(pelo,largo).
valor_valido(pelo,corto).
valor_valido(pelo,sin_pelo).

valor_valido(es_magico, si).
valor_valido(es_magico, no).

valor_valido(color_vestimenta, rojo).
valor_valido(color_vestimenta, azul).
valor_valido(color_vestimenta, verde).
valor_valido(color_vestimenta, amarillo).
valor_valido(color_vestimenta, negro).
valor_valido(color_vestimenta, blanco).
valor_valido(color_vestimenta, morado).
valor_valido(color_vestimenta, naranja).
valor_valido(color_vestimenta, rosa).
valor_valido(color_vestimenta, cafe).
valor_valido(color_vestimenta, gris).
valor_valido(color_vestimenta, na).

valor_valido(vive_en,castillo).
valor_valido(vive_en,bosque).
valor_valido(vive_en,selva).
valor_valido(vive_en,mar).
valor_valido(vive_en,ciudad).
valor_valido(vive_en,desierto).
valor_valido(vive_en,pantano).
valor_valido(vive_en,oceano).
valor_valido(vive_en,otro).

valor_valido(genero,masculino).
valor_valido(genero,femenino).
valor_valido(genero,na).

valor_valido(habla,si).
valor_valido(habla,no).

valor_valido(edad, adulto).
valor_valido(edad, nino).

% Lista de atributos en orden de pregunta
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

% Plantillas de preguntas (el {valor} se reemplaza dinámicamente)
plantilla_pregunta(especie, "¿Tu personaje es {valor}?").
plantilla_pregunta(es_villano, "¿Tu personaje es villano?").
plantilla_pregunta(es_protagonista, "¿Tu personaje es protagonista?").
plantilla_pregunta(color_pelo, "¿Tu personaje tiene el pelo {valor}?").
plantilla_pregunta(pelo, "¿Tu personaje tiene el pelo {valor}?").
plantilla_pregunta(es_magico, "¿Tu personaje es mágico?").
plantilla_pregunta(color_vestimenta, "¿Tu personaje viste de {valor}?").
plantilla_pregunta(vive_en, "¿Tu personaje vive en {valor}?").
plantilla_pregunta(genero, "¿Tu personaje es {valor}?").
plantilla_pregunta(habla, "¿Tu personaje habla?").
plantilla_pregunta(edad, "¿Tu personaje es un adulto?").

% Plantillas para cuando el valor es 'na' (no aplica)
plantilla_na(color_vestimenta, "¿Tu personaje no usa ropa?").
plantilla_na(genero, "¿Tu personaje no tiene género definido?").
plantilla_na(color_pelo, "¿Tu personaje no tiene pelo?").
