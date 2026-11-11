# 3. Análisis estadístico

Cada participante aporta un cambio: el valor de V06 menos el de V00. Los
scripts comparan ese cambio entre los tres grupos de intervención.

## Archivos necesarios

Se leen `muestras.csv`, `matriz_especies.csv`, `matriz_sgb.csv` y
`matriz_rutas.csv` desde `resultados/preparacion/`. Los scripts se ejecutan
desde la carpeta principal del repositorio.

| Script | Qué compara |
|---|---|
| [01. Diversidad alfa](01_diversidad_alfa.R) | El cambio en los índices de diversidad de cada participante |
| [02. Diversidad beta](02_diversidad_beta.R) | Los cambios en la composición de microorganismos y rutas metabólicas |
| [03. Especies, SGB y rutas](03_especies_sgb_rutas.R) | El cambio de cada especie, SGB o ruta por separado |

[00_funciones.R](00_funciones.R) contiene las operaciones comunes: leer las
matrices, unir las visitas, filtrar, aplicar CLR y preparar las permutaciones.

## Qué mide cada análisis

La diversidad alfa resume cada muestra. Shannon combina el número de taxones
y el reparto de sus abundancias. Gini-Simpson da más peso a los taxones
abundantes. La riqueza cuenta las especies con una abundancia relativa de
al menos el 0,01 %.

La diversidad beta compara la composición. Primero se aplica CLR, una
transformación que expresa las abundancias en relación con las demás.
Después se resta V00 a V06 para cada participante. La PERMANOVA compara
esos cambios entre grupos. La prueba de dispersión examina cuánto varían
los cambios dentro de cada grupo.

El tercer script hace una prueba para cada especie, SGB o ruta. Como se hacen
muchas pruebas, se ajustan los p-valores mediante Benjamini-Hochberg. El valor
ajustado se llama `q_BH`. El ajuste se hace por separado para especies, SGB y rutas.

Las [decisiones del análisis](../documentacion/metodos_y_versiones.md) recogen
los filtros, el tratamiento de ceros y las 99.999 permutaciones.

## Tablas que se guardan

Todas se guardan dentro de `resultados/estadistica/`:

| Carpeta | Tablas |
|---|---|
| alfa | Índices por muestra, cambios por participante y pruebas globales |
| beta | Filtros, cambios CLR, coordenadas del PCA y pruebas de especies y rutas |
| especies, sgb, rutas | Filtro aplicado y pruebas de cada código |

El TFM también incluye intervalos por bootstrap, comparaciones posteriores y
análisis de sensibilidad. Esas partes se conservan en los scripts originales.
Esta versión simplificada no las incluye y no se ha ejecutado de nuevo.

## Análisis exploratorio

El [apartado en Python](exploratorio_python/README.md) estudia si se puede
predecir una pérdida de peso de al menos el 5 %. También agrupa los perfiles
de la visita basal según su parecido. Se explica después del análisis principal.
