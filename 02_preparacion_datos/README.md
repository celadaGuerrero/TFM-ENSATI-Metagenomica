# 2. Preparación de los datos

El objetivo es reunir las salidas del procesamiento y comprobar que cada
participante tiene sus dos visitas. Las abundancias y los metadatos deben
seguir el mismo orden.

## Entradas

`datos/muestras.csv` debe tener estas columnas:

| Columna | Contenido |
|---|---|
| muestra | Código único de la muestra; coincide con el nombre de sus archivos |
| participante | Código que une las dos visitas de una persona |
| visita | V00 o V06 |
| grupo | 1 = DMed+RC; 2 = DMed+TRE; 3 = DMed. También se aceptan estos nombres |

Los códigos numéricos son categorías, no cantidades. DMed es dieta
mediterránea; RC añade restricción calórica y TRE añade restricción horaria.

Por cada muestra se necesitan los archivos generados en el paso 1:

- `resultados/metaphlan/<muestra>_perfil.tsv`.
- `resultados/humann/<muestra>/<muestra>_pathabundance.tsv`.

## Scripts

1. [Comprobar muestras](01_comprobar_muestras.R): comprueba códigos únicos,
   visitas, grupo constante y los 15 participantes con dos visitas del TFM. Ordena por participante
   y visita y guarda `resultados/preparacion/muestras.csv`.
2. [Preparar matrices](02_preparar_matrices.R): reúne los perfiles individuales
   y guarda tres matrices en `resultados/preparacion/`.

| Archivo | Columnas de abundancia | Unidad antes del análisis |
|---|---|---|
| matriz_especies.csv | Filas de MetaPhlAn cuyo último nivel es `s__` | Porcentaje original dividido por 100 |
| matriz_sgb.csv | Filas cuyo último nivel es `t__` (SGB) | Porcentaje original dividido por 100 |
| matriz_rutas.csv | Rutas MetaCyc de la comunidad completa | Abundancia de rutas de HUMAnN |

En las tres matrices, la primera columna es `muestra`. Cada fila representa
una muestra. Los códigos completos se conservan como nombres de columna.
Un SGB es un grupo de genomas que representa una unidad a nivel de especie.
Las matrices de especies y SGB se analizan por separado: no se suman entre sí.

Para taxonomía se seleccionan Bacteria y Archaea. Para funciones se toman las
rutas totales, sin las contribuciones separadas por microorganismo, y se
retiran `UNMAPPED` y `UNINTEGRATED`. La cobertura de rutas y las familias
génicas no se utilizan como abundancias de rutas.

Un código que no aparece en un perfil recibe cero. En este paso no se aplica
el filtro de prevalencia ni se sustituyen los ceros. Cada análisis ajusta las
sumas y selecciona las columnas que necesita.

La preparación original se hizo en Python. Estos dos scripts son una
adaptación a R para facilitar la lectura, fechada el 11/11/2026. No se han
utilizado para recalcular las matrices o los resultados del TFM.

El flujo original también contrastó los códigos de abundancia y cobertura de
rutas. Ese control se conserva en el proyecto; este lector breve reúne las
abundancias y no repite toda la validación de las salidas de HUMAnN.
