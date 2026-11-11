# 2. Preparación de los datos

Se comprueba que cada participante tenga sus dos visitas y se reúnen las
abundancias de todas las muestras. Las matrices y los metadatos deben seguir
el mismo orden de muestras.

## Archivos necesarios

`datos/muestras.csv` debe contener estas columnas:

| Columna | Contenido |
|---|---|
| muestra | Código único de la muestra, igual al que aparece en sus archivos |
| participante | Código que une las dos visitas del participante |
| visita | V00, visita basal; V06, visita a los seis meses |
| grupo | 1 = DMed+RC; 2 = DMed+TRE; 3 = DMed. También se aceptan estos nombres |

El protocolo define DMed como dieta mediterránea, RC como restricción calórica
y TRE como ingesta restringida en el tiempo. Los scripts mantienen las etiquetas
de grupo utilizadas en el TFM. Los números de grupo son códigos, no cantidades.

Por cada muestra se necesitan dos archivos del paso anterior:

- `resultados/metaphlan/<muestra>_perfil.tsv`.
- `resultados/humann/<muestra>/<muestra>_pathabundance.tsv`.

## Scripts

1. [Comprobar muestras](01_comprobar_muestras.R). Revisa que los códigos no se
   repitan y que los 15 participantes tengan ambas visitas y el mismo grupo
   en las dos. Ordena las filas y guarda `resultados/preparacion/muestras.csv`.
2. [Preparar matrices](02_preparar_matrices.R). Reúne los perfiles y guarda
   tres matrices en `resultados/preparacion/`.

| Archivo | Qué contiene | Unidad |
|---|---|---|
| matriz_especies.csv | Especies de MetaPhlAn, con nivel final `s__` | Porcentaje original dividido por 100 |
| matriz_sgb.csv | SGB de MetaPhlAn, con nivel final `t__` | Porcentaje original dividido por 100 |
| matriz_rutas.csv | Rutas MetaCyc de la comunidad completa | Abundancia de rutas de HUMAnN |

Cada fila representa una muestra. La primera columna es `muestra` y las demás
contienen las abundancias. Se conservan los códigos completos.

En taxonomía se seleccionan bacterias y arqueas. Un SGB reúne genomas similares
y se utiliza como unidad a nivel de especie. Las matrices de especies y SGB
se analizan por separado.

En funciones se utilizan las rutas de la comunidad completa. Se omiten las
filas con la aportación de cada microorganismo y las filas `UNMAPPED` y
`UNINTEGRATED`. La cobertura y las familias génicas son medidas distintas;
no se usan como abundancias de rutas.

Si un código no aparece en un perfil, se escribe cero. El filtro de presencia
y el tratamiento de los ceros se aplican después, dentro del análisis.

## Qué se ha adaptado

La preparación original se hizo en Python. Esta versión en R facilita su
lectura, pero no se ha ejecutado para recalcular las matrices del TFM.
El programa original también comprobó que coincidieran los códigos de las
tablas de abundancia y cobertura. Ese control se conserva en los archivos
de trabajo y no se repite en este script.
