# 1. Procesamiento de las lecturas

Los cuatro scripts se leen en el orden indicado. Para ejecutarlos se utiliza
Bash desde la carpeta principal del repositorio. Los nombres de muestra y
las rutas son ejemplos. Los datos y las bases de referencia no se incluyen.

| Script | Qué hace | Qué guarda |
|---|---|---|
| [01. Control de calidad](01_control_calidad.sh) | Reúne los archivos de cada muestra y los procesa con fastp | Lecturas filtradas e informes de calidad |
| [02. Filtrado humano](02_filtrado_humano.sh) | Compara las lecturas con la referencia humana mediante Bowtie2 | Pares conservados y resumen del alineamiento |
| [03. Taxonomía](03_perfiles_taxonomicos.sh) | Estima las abundancias de los microorganismos con MetaPhlAn | Perfil taxonómico de cada muestra |
| [04. Funciones](04_perfiles_funcionales.sh) | Busca genes y rutas metabólicas con HUMAnN | Tablas de familias génicas y rutas MetaCyc |

## Lecturas y calidad

R1 y R2 son lecturas de los dos extremos de un fragmento de ADN. Si hay varios
archivos de una muestra, se reúnen los de R1 por un lado y los de R2 por otro.
El primer script muestra un ejemplo con dos carriles de secuenciación. La lista
debe ajustarse a los archivos disponibles.

fastp retira adaptadores y filtra por calidad. Sus informes muestran cuántas
lecturas se conservan y cómo es la calidad antes y después del filtrado.

## Filtrado humano

Bowtie2 compara las lecturas con GRCh38. La opción `--un-conc-gz` conserva
los pares que no encajan juntos en la referencia con la orientación y la
separación esperadas. Una lectura del par puede coincidir por separado con
la referencia humana.

## Microorganismos y funciones

MetaPhlAn estima las abundancias a partir de genes marcadores. Su tabla contiene
varios niveles de clasificación, como género y especie. Las abundancias de
niveles distintos no se suman. En el paso siguiente se separan las especies
y los SGB, que son grupos de genomas a nivel de especie.

HUMAnN usa el perfil de MetaPhlAn como apoyo. Primero busca en los pangenomas
de ChocoPhlAn, es decir, en genes reunidos de distintos genomas de una especie. Después compara
las lecturas restantes con las proteínas de UniRef90. Genera tres tablas:

| Archivo | Contenido |
|---|---|
| `*_genefamilies.tsv` | Abundancia de familias génicas, en lecturas por kilobase (RPK) |
| `*_pathabundance.tsv` | Abundancia de rutas MetaCyc, calculada a partir de las abundancias génicas |
| `*_pathcoverage.tsv` | Cobertura estimada de las rutas, entre 0 y 1 |

Para el análisis funcional del TFM se utilizan las abundancias de las rutas.
La [preparación de datos](../02_preparacion_datos/README.md) explica cómo se
reúnen las tablas de las distintas muestras.

## Programas y bases

Las versiones utilizadas están en [Métodos y versiones](../documentacion/metodos_y_versiones.md).
La base de MetaPhlAn del TFM es vJun23. Las bases de ChocoPhlAn y UniRef90 deben
estar configuradas en HUMAnN, y GRCh38 debe estar preparada como índice de Bowtie2.

Estos comandos usan los parámetros del ejemplo publicado. Se han aclarado sus
nombres y rutas. `--output-basename` fija el nombre de los archivos de HUMAnN.
No se ha vuelto a procesar ninguna muestra durante esta revisión.
