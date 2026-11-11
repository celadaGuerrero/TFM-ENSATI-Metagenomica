# 3. Análisis estadístico

Los tres scripts principales comparan el cambio entre V00 y V06 de cada
persona. El grupo se define como una categoría. Las dos muestras de una
persona se usan juntas para calcular su cambio.

## Entradas

Se utilizan `muestras.csv`, `matriz_especies.csv`, `matriz_sgb.csv` y
`matriz_rutas.csv`, guardados en `resultados/preparacion/` en el paso anterior.
Los scripts se leen o ejecutan desde la raíz del repositorio.

## Orden de lectura

| Script | Pregunta | Pasos principales |
|---|---|---|
| [01. Diversidad alfa](01_diversidad_alfa.R) | ¿Difiere entre grupos el cambio en diversidad? | Índices por muestra, cambio V06 − V00 y prueba F por permutaciones |
| [02. Diversidad beta](02_diversidad_beta.R) | ¿Difieren los cambios en la composición taxonómica o funcional? | Filtro, CLR, cambio individual, PERMANOVA y dispersión |
| [03. Especies, SGB y rutas](03_especies_sgb_rutas.R) | ¿Qué códigos cambian de forma distinta entre grupos? | Cambio CLR por código, prueba F y ajuste por comparaciones múltiples |

[00_funciones.R](00_funciones.R) reúne las operaciones que comparten los tres
scripts: lectura de las matrices, comprobación de parejas, filtro, CLR y
permutaciones. Cada función resuelve una tarea y evita repetir el mismo código.

## Conceptos necesarios

La diversidad alfa resume cada muestra. Shannon combina el número de taxones
y el reparto de sus abundancias. Gini-Simpson da más peso a los dominantes.
La riqueza cuenta las especies que superan el umbral indicado.

La diversidad beta compara la composición. Aquí se transforma cada perfil
a CLR y se resta V00 a V06. La PERMANOVA compara esos cambios entre grupos.
La prueba de dispersión examina cuánto varían los cambios dentro de cada grupo.

En las pruebas por especie, SGB o ruta se compara cada columna por separado.
El valor `q_BH` ajusta el p-valor por el número de pruebas del mismo tipo de
datos. Los códigos de especie, SGB y ruta no se juntan en un único ajuste.

Los filtros, el tratamiento de ceros y las 99.999 permutaciones se explican en
[Métodos y versiones](../documentacion/metodos_y_versiones.md).

## Salidas

| Carpeta dentro de `resultados/estadistica/` | Tablas |
|---|---|
| alfa | Índices por muestra, cambios por persona y pruebas globales |
| beta | Filtros, cambios CLR, coordenadas del PCA y pruebas globales para especies y rutas |
| especies, sgb, rutas | Filtro aplicado y pruebas globales por código |

Los intervalos por bootstrap, las comparaciones posteriores y las sensibilidades
del TFM quedan fuera de estos scripts breves. Sus cálculos y resultados se
conservan en el proyecto original. Esta adaptación de lectura del 11/11/2026
no se ha ejecutado para recalcular los resultados entregados.

## Ampliación exploratoria

El [módulo en Python](exploratorio_python/README.md) conserva el procedimiento
de predicción de pérdida de peso y la agrupación de perfiles basales. Se
presenta por separado porque responde a preguntas distintas del análisis principal.
