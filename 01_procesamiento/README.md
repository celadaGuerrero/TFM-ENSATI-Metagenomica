# 1. Procesamiento de las lecturas

Estos cuatro scripts muestran las etapas del procesamiento del TFM. Se leen en
orden. Para ejecutarlos se utiliza Bash desde la carpeta principal del repositorio.
Usan una muestra ficticia y rutas de ejemplo. Los archivos y las bases de datos
originales no se incluyen.

| Paso | Qué hace | Qué produce |
|---|---|---|
| [01. Control de calidad](01_control_calidad.sh) | Reúne los archivos de cada muestra y aplica fastp. | Lecturas filtradas e informes HTML y JSON. |
| [02. Filtrado humano](02_filtrado_humano.sh) | Compara las lecturas con GRCh38 mediante Bowtie2. | Pares conservados y resumen del alineamiento. |
| [03. Perfiles taxonómicos](03_perfiles_taxonomicos.sh) | Estima la composición microbiana con MetaPhlAn. | Abundancias relativas por muestra. |
| [04. Perfiles funcionales](04_perfiles_funcionales.sh) | Estima las familias génicas y las rutas MetaCyc con HUMAnN. | Tres tablas por muestra. |

## Lecturas y control de calidad

R1 y R2 proceden de los dos extremos de cada fragmento de ADN. Si una muestra
se secuenció en varios carriles, primero se reúnen sus archivos, manteniendo R1
y R2 separados. El primer script muestra un ejemplo con dos carriles. La lista debe ajustarse
a los archivos de cada muestra.

fastp retira adaptadores y filtra las lecturas por calidad. Los informes permiten
consultar las lecturas conservadas y la calidad antes y después del filtrado.

## Filtrado frente a la referencia humana

Se utilizó Bowtie2 con `--very-sensitive` y `--un-conc-gz`. Esta última opción
conserva los pares que no encajan como pareja en la referencia humana con la
orientación y la separación esperadas. Puede quedar alguna lectura que, por separado, sí coincida con la referencia.

## Taxonomía y función

MetaPhlAn utiliza genes marcadores de grupos microbianos concretos. Su tabla
incluye distintos niveles de clasificación y abundancias relativas en porcentaje.
Las filas de distintos niveles no se suman entre sí. La preparación posterior
separa las especies y los SGB, que son grupos de genomas a nivel de especie.

HUMAnN utiliza el perfil taxonómico como apoyo. Primero busca en los pangenomas
de ChocoPhlAn y después compara las lecturas restantes con las proteínas de
UniRef90. Las tres salidas principales son:

| Archivo | Contenido |
|---|---|
| `*_genefamilies.tsv` | Abundancia de familias génicas, en lecturas por kilobase (RPK). |
| `*_pathabundance.tsv` | Abundancia de rutas MetaCyc, calculada a partir de las abundancias génicas. |
| `*_pathcoverage.tsv` | Cobertura estimada de las rutas, en una escala de 0 a 1. |

Estas salidas no son todavía las matrices relativas utilizadas en la estadística.
La diferencia entre las rutas totales y las aportaciones de cada microorganismo
se explica en la
[preparación de datos](../02_preparacion_datos/README.md).

## Programas y bases utilizados

| Programa o referencia | Versión del TFM |
|---|---|
| fastp | 0.22.0 |
| Bowtie2 | 2.5.4 |
| Referencia humana | GRCh38.p14, GCF_000001405.40 |
| MetaPhlAn | 4.2.4 |
| Base de MetaPhlAn | `mpa_vJun23_CHOCOPhlAnSGB_202307` |
| HUMAnN | 3.9 |
| ChocoPhlAn para HUMAnN | `full_chocophlan.v201901_v31` |
| UniRef90 para HUMAnN | `uniref90_201901b_full` |
| DIAMOND | 2.0.15 |

Las bases de ChocoPhlAn y UniRef90 deben estar configuradas en el entorno de
HUMAnN antes de ejecutar el cuarto script. El índice de GRCh38 debe estar
construido para Bowtie2. La base vJun23 corresponde al TFM; los análisis
posteriores del conjunto completo de ENSATI son otro trabajo.

La revisión del 11/11/2026 cambia nombres, rutas y comentarios. Se conservan
los parámetros del ejemplo anterior. La opción `--output-basename` fija los
nombres de los archivos de HUMAnN. No se ha vuelto a procesar ninguna muestra.
