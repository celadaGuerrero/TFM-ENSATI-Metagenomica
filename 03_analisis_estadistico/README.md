# 3. Análisis estadístico

Los tres scripts comparan entre grupos el cambio de cada persona entre V00
y V06. Para calcularlo se utilizan sus dos muestras. Los códigos de grupo
se tratan como categorías.

## Entradas

Se utilizan `muestras.csv`, `matriz_especies.csv`, `matriz_sgb.csv` y
`matriz_rutas.csv`, guardados en `resultados/preparacion/` en el paso anterior.
Los scripts se leen o ejecutan desde la carpeta principal del repositorio.

## Orden de lectura

| Script | Pregunta | Pasos principales |
|---|---|---|
| [01. Diversidad alfa](01_diversidad_alfa.R) | ¿Difiere entre grupos el cambio en diversidad? | Índices por muestra, cambio V06 − V00 y prueba F por permutaciones |
| [02. Diversidad beta](02_diversidad_beta.R) | ¿Difieren los cambios en la composición taxonómica o funcional? | Filtro, CLR, cambio individual, PERMANOVA y dispersión |
| [03. Especies, SGB y rutas](03_especies_sgb_rutas.R) | ¿En qué especies, SGB o rutas difiere el cambio entre grupos? | Cambio CLR por código, prueba F y ajuste por comparaciones múltiples |

[00_funciones.R](00_funciones.R) reúne las operaciones que comparten los tres
scripts: lectura de las matrices, comprobación de visitas, filtro, CLR y
permutaciones. Así se evita repetir estas operaciones en cada script.

## Conceptos necesarios

La diversidad alfa resume cada muestra. Shannon combina el número de taxones
y el reparto de sus abundancias. Gini-Simpson da más peso a los dominantes.
La riqueza cuenta las especies con una abundancia relativa de al menos el 0,01 %.

La diversidad beta compara la composición. Aquí se transforma cada perfil
a CLR y se resta V00 a V06. La PERMANOVA compara esos cambios entre grupos.
La prueba de dispersión examina cuánto varían los cambios dentro de cada grupo.

En las pruebas por especie, SGB o ruta se compara cada columna por separado.
El valor `q_BH` es el p-valor ajustado mediante Benjamini-Hochberg. El ajuste
se hace por separado para especies, SGB y rutas.

Los filtros, el tratamiento de ceros y las 99.999 permutaciones se explican en
[Métodos y versiones](../documentacion/metodos_y_versiones.md).

## Salidas

| Carpeta dentro de `resultados/estadistica/` | Tablas |
|---|---|
| alfa | Índices por muestra, cambios por persona y pruebas globales |
| beta | Filtros, cambios CLR, coordenadas del PCA y pruebas globales para especies y rutas |
| especies, sgb, rutas | Filtro aplicado y pruebas globales por código |

Los intervalos por bootstrap, las comparaciones posteriores y los análisis
de sensibilidad se conservan en los archivos originales del TFM. Esta versión
simplificada del 11/11/2026 no incluye esas partes ni se ha utilizado para
recalcular los resultados entregados.

## Ampliación exploratoria

El [apartado en Python](exploratorio_python/README.md) incluye la predicción
de una pérdida de peso de al menos el 5 % y la agrupación de perfiles basales.
Responde a preguntas distintas y se presenta después del análisis principal.

