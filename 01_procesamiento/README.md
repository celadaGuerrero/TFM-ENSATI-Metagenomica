# 1. Procesamiento de las lecturas

Los cuatro scripts se ejecutan en el orden indicado, desde la carpeta principal
del repositorio y con Bash. Las rutas y los nombres de muestra son ejemplos.
Los datos y las bases de referencia no se incluyen.

| Script | Qué hace | Qué guarda |
|---|---|---|
| [01. Control de calidad](01_control_calidad.sh) | Reúne los archivos de cada muestra y los procesa con fastp | Lecturas filtradas e informes de calidad |
| [02. Filtrado humano](02_filtrado_humano.sh) | Compara las lecturas con la referencia humana mediante Bowtie2 | Pares conservados y resumen del alineamiento |
| [03. Taxonomía](03_perfiles_taxonomicos.sh) | Estima las abundancias de los microorganismos con MetaPhlAn | Perfil taxonómico de cada muestra |
| [04. Funciones](04_perfiles_funcionales.sh) | Busca genes y rutas metabólicas con HUMAnN | Tablas de familias génicas y rutas MetaCyc |

## Lecturas y calidad

R1 y R2 contienen las lecturas de los dos extremos de cada fragmento de ADN.
Si una muestra tiene varios archivos, se reúnen los de R1 por un lado y los
de R2 por otro, en el mismo orden. El primer script incluye un ejemplo con dos
carriles de secuenciación. La lista debe ajustarse a los archivos disponibles.

fastp retira adaptadores y filtra por calidad. Sus informes muestran cuántas
lecturas se conservan y la calidad antes y después del filtrado.

## Filtrado humano

Bowtie2 compara las lecturas con la referencia humana GRCh38. La opción
`--un-conc-gz` conserva los pares que no encajan juntos en esa referencia con
la orientación y la separación esperadas. Una lectura del par puede coincidir
por separado con la referencia humana.

## Microorganismos y funciones

MetaPhlAn estima abundancias relativas a partir de genes marcadores. Su tabla
contiene varios niveles de clasificación, como género y especie. Las
abundancias de niveles distintos no se suman. En la preparación de datos se
separan las especies y los SGB, que agrupan genomas a nivel de especie.

HUMAnN utiliza el perfil de MetaPhlAn para orientar la búsqueda. Primero busca
en los pangenomas de ChocoPhlAn: conjuntos de genes reunidos de distintos
genomas de una especie. Después compara las lecturas restantes con las
proteínas de UniRef90. Genera tres tablas por muestra:

| Archivo | Contenido |
|---|---|
| `*_genefamilies.tsv` | Abundancia de familias génicas, en lecturas por kilobase (RPK) |
| `*_pathabundance.tsv` | Abundancia de rutas MetaCyc, calculada a partir de las abundancias génicas |
| `*_pathcoverage.tsv` | Cobertura estimada de las rutas, entre 0 y 1 |

El análisis funcional del TFM utiliza las abundancias de las rutas. La
[preparación de datos](../02_preparacion_datos/README.md) explica cómo se reúnen
las tablas de todas las muestras.

## Programas y bases

Las versiones están en [Métodos y versiones](../documentacion/metodos_y_versiones.md).
La base de MetaPhlAn del TFM es vJun23. ChocoPhlAn y UniRef90 deben estar
configuradas en HUMAnN. GRCh38 debe estar preparada como índice de Bowtie2.

La opción `--output-basename` de HUMAnN fija el nombre de sus archivos de salida.
