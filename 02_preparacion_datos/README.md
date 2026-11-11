# 2. Preparación de los datos

Se reúnen los perfiles de cada muestra y se comprueba que cada participante
tenga V00 y V06. Las matrices de abundancia y los metadatos deben seguir
el mismo orden de muestras.

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

1. [Comprobar muestras](01_comprobar_muestras.R): revisa que los códigos no se
   repitan y que las 15 personas tengan ambas visitas y el mismo grupo en las
   dos. Ordena las filas por participante y visita y guarda
   `resultados/preparacion/muestras.csv`.
2. [Preparar matrices](02_preparar_matrices.R): reúne los perfiles individuales
   y guarda tres matrices en `resultados/preparacion/`.

| Archivo | Columnas de abundancia | Unidad antes del análisis |
|---|---|---|
| matriz_especies.csv | Filas de MetaPhlAn cuyo último nivel es `s__` | Porcentaje original dividido por 100 |
| matriz_sgb.csv | Filas cuyo último nivel es `t__` (SGB) | Porcentaje original dividido por 100 |
| matriz_rutas.csv | Rutas MetaCyc de la comunidad completa | Abundancia de rutas de HUMAnN |

En las tres matrices, la primera columna es `muestra`. Cada fila representa
una muestra. Los códigos completos se conservan como nombres de columna.
Un SGB reúne genomas similares y se utiliza como unidad a nivel de especie.
Las matrices de especies y SGB se analizan por separado: no se suman entre sí.

En taxonomía se seleccionan bacterias y arqueas. En el análisis funcional se
utilizan las rutas de la comunidad completa. Se omiten las filas que separan
la contribución de cada microorganismo y se
retiran `UNMAPPED` y `UNINTEGRATED`. La cobertura de rutas y las familias
génicas no se utilizan como abundancias de rutas.

Un código que no aparece en un perfil recibe cero. En este paso no se aplica
el filtro de prevalencia ni se sustituyen los ceros. Cada análisis ajusta las
sumas y selecciona las columnas que necesita.

La preparación original se hizo en Python. El 11/11/2026 se escribió esta
versión en R para facilitar su lectura. No se ha utilizado para recalcular
las matrices ni los resultados del TFM.

El programa original también comprobó que coincidieran los códigos de las
tablas de abundancia y cobertura de rutas. Ese control se conserva en los
archivos de trabajo. Este script reúne las abundancias, pero no repite todas
las comprobaciones de las salidas de HUMAnN.
