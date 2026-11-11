# Métodos y versiones

## Procesamiento

| Etapa | Programa o referencia | Uso |
|---|---|---|
| Calidad de las lecturas | fastp 0.22.0 | Retirar adaptadores y filtrar por calidad |
| Filtrado humano | Bowtie2 2.5.4; GRCh38.p14, GCF_000001405.40 | Comparar las lecturas con la referencia humana |
| Taxonomía | MetaPhlAn 4.2.4 | Estimar abundancias mediante genes marcadores |
| Base de MetaPhlAn | `mpa_vJun23_CHOCOPhlAnSGB_202307` | Base vJun23 utilizada en el TFM |
| Funciones | HUMAnN 3.9 | Obtener familias génicas y rutas metabólicas |
| Base de nucleótidos de HUMAnN | ChocoPhlAn `full_chocophlan.v201901_v31` | Primera búsqueda de genes |
| Base de proteínas de HUMAnN | UniRef90 `uniref90_201901b_full` | Búsqueda con DIAMOND 2.0.15 |

El TFM usa la base taxonómica vJun23. La base Jan25 se utilizó después, para
el conjunto completo de muestras. La base de MetaPhlAn y ChocoPhlAn de HUMAnN
son distintas, aunque sus nombres se parezcan.

Los comandos muestran las etapas con rutas de ejemplo. No reproducen todos
los registros de ejecución. No se recuperó una misma línea de comando de
fastp para todas las ejecuciones originales. Los controles y las salidas
por muestra se conservan en el proyecto.

## Decisiones del análisis

| Aspecto | Procedimiento del TFM |
|---|---|
| Participantes y visitas | 15 participantes, cinco por grupo; 30 muestras, de V00 y V06 |
| Taxonomía | Bacterias y arqueas; especies y SGB en matrices separadas |
| Funciones | Rutas de la comunidad completa, sin aportaciones por microorganismo ni filas `UNMAPPED` o `UNINTEGRATED` |
| Diversidad alfa | Especies sin filtro de presencia; abundancias ajustadas para que cada muestra sume uno |
| Índice principal | Shannon, con logaritmo natural |
| Índices secundarios | Gini-Simpson y riqueza con abundancia relativa de al menos 0,0001 (0,01 %) |
| Filtro previo a CLR | Presencia en al menos seis muestras y tres participantes |
| Tratamiento de ceros | Sustitución multiplicativa con δ = 1/D²; D es el número de columnas conservadas |
| Cambio de cada participante | V06 menos V00 |
| Comparación de diversidad | F por permutaciones para alfa; PERMANOVA y dispersión para los cambios CLR |
| Permutaciones | 99.999; semilla principal 20260720 |
| Ajuste entre índices | Shannon como índice principal; Holm entre Simpson y riqueza |
| Pruebas por especie, SGB o ruta | F por permutaciones; ajuste Benjamini-Hochberg por separado para cada tipo de datos |

La prevalencia indica en cuántas muestras o participantes aparece un código.
El filtro retiene los que cumplen ambos mínimos de presencia.

CLR es el logaritmo del cociente entre cada abundancia y la media geométrica
de las abundancias de la muestra. Antes se sustituyen los ceros. CLR compara
abundancias relativas; no permite conocer cantidades absolutas. Para comparar
los cambios entre grupos se usan las distancias euclídeas entre los cambios CLR.

Las permutaciones reorganizan los cambios o las etiquetas de grupo entre
participantes, manteniendo cinco participantes por grupo. Se compara el
resultado observado con los obtenidos de esa forma. En alfa se permutan los
cambios; en las pruebas por especie, SGB o ruta se permutan las etiquetas.
Se usa el mismo conjunto de permutaciones para todas las columnas de cada matriz.

Los scripts originales también incluyen 10.000 remuestreos para los intervalos
por bootstrap, comparaciones posteriores con Holm y análisis de sensibilidad.
Estas partes no se incluyen en los scripts simplificados.

## R y Python

El entorno conservado registra R 4.6.1, vegan 2.7-5 y permute 0.9-10.
Para las figuras se utiliza ggplot2. El análisis exploratorio se mantiene en
Python. Sus dependencias están en [requirements.txt](../requirements.txt) y
se explican en su [guía](../03_analisis_estadistico/exploratorio_python/README.md).
Estas versiones se consultaron sin volver a ejecutar los análisis.
