# Métodos y versiones

## Procesamiento

| Etapa | Programa o referencia | Uso |
|---|---|---|
| Limpieza de lecturas | fastp 0.22.0 | Calidad, adaptadores y filtrado de lecturas |
| Filtrado frente al genoma humano | Bowtie2 2.5.4; GRCh38.p14, GCF_000001405.40 | Comparación de los pares con la referencia humana |
| Perfil taxonómico | MetaPhlAn 4.2.4 | Estimación de abundancias mediante genes marcadores |
| Base de MetaPhlAn | `mpa_vJun23_CHOCOPhlAnSGB_202307` | Rama vJun23 utilizada en el TFM |
| Perfil funcional | HUMAnN 3.9 | Familias génicas, abundancia y cobertura de rutas |
| Base de nucleótidos de HUMAnN | ChocoPhlAn `full_chocophlan.v201901_v31` | Primera búsqueda de HUMAnN |
| Base de proteínas de HUMAnN | UniRef90 `uniref90_201901b_full` | Búsqueda de proteínas con DIAMOND 2.0.15 |

La base taxonómica vJun23 del TFM es distinta de la rama Jan25 utilizada
después para la entrega del conjunto completo. Tampoco es la misma base
ChocoPhlAn que utiliza HUMAnN para buscar secuencias de genes.

Los comandos muestran las etapas principales con rutas de ejemplo. No son
una transcripción de todos los registros de ejecución. En particular, no se
recuperó una línea de comando idéntica de fastp para todas las ejecuciones
originales. Los controles y las salidas por muestra se conservan en el proyecto.

## Preparación y comparación

| Decisión | Procedimiento del TFM |
|---|---|
| Diseño | 30 muestras, 15 personas, cinco por grupo, V00 y V06 |
| Taxonomía | Bacteria y Archaea; especies y SGB en matrices separadas |
| Funciones | Rutas MetaCyc totales; sin filas por microorganismo ni `UNMAPPED`/`UNINTEGRATED` |
| Diversidad alfa | Especies sin filtro de prevalencia; abundancias ajustadas a suma uno |
| Índice principal | Shannon, con logaritmo natural |
| Índices secundarios | Gini-Simpson y riqueza con abundancia relativa ≥0,0001 (0,01 %) |
| Filtro para CLR | Presencia en al menos seis muestras y tres participantes |
| Ceros y CLR | Ajuste multiplicativo con δ = 1/D², siendo D el número de columnas conservadas |
| Cambio individual | V06 menos V00, tanto para índices como para valores CLR |
| Pruebas globales | F por permutaciones para alfa; PERMANOVA y dispersión para cambios CLR |
| Número de permutaciones | 99.999; semilla principal 20260720 |
| Ajuste entre índices | Shannon principal; Holm entre Simpson y riqueza |
| Pruebas por especie, SGB o ruta | F por permutaciones; Benjamini-Hochberg por separado para cada tipo de datos |

CLR es el logaritmo del cociente entre cada abundancia y la media geométrica
de las abundancias de la muestra, tras tratar los ceros. Permite comparar
relaciones entre componentes; no convierte las proporciones en cantidades
absolutas. La diversidad beta compara las distancias euclídeas entre los
cambios CLR de los participantes.

Las permutaciones principales mantienen los tamaños de los tres grupos y
operan sobre participantes. En alfa se permutan los cambios; en las pruebas
por taxón o ruta se permutan las etiquetas de grupo. El código original usó
el mismo conjunto de permutaciones para todas las columnas de cada matriz.

Los análisis complementarios del TFM incluyeron 10.000 remuestreos para los
intervalos por bootstrap, contrastes posteriores con Holm y comprobaciones
de sensibilidad. Estas partes no se incluyen en los scripts simplificados.

## Entorno de R y Python

El entorno conservado del proyecto registra R 4.6.1, vegan 2.7-5 y permute
0.9-10. Los scripts de figuras utilizan ggplot2. No necesitan glmnet ni
cluster: el módulo exploratorio conserva los cálculos originales en Python.

Las dependencias de ese módulo figuran en [requirements.txt](../requirements.txt)
y se explican en su [README](../03_analisis_estadistico/exploratorio_python/README.md).
Estas versiones se consultaron en el entorno conservado. No se volvieron
a ejecutar los análisis durante la revisión.
