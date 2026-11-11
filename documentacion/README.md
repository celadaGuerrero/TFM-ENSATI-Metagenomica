# Documentación del recorrido

La pregunta principal es si el cambio entre V00 y V06 difiere entre los tres
grupos. Por eso, cada persona aporta un cambio a la comparación. Sus dos
muestras no se tratan como observaciones independientes.

- [Métodos, versiones y parámetros](metodos_y_versiones.md).
- [Cambios en esta revisión](cambios_20261111.md).

## Alcance del código

El recorrido breve incluye el procesamiento de lecturas, la preparación de
matrices, las pruebas globales de diversidad y las comparaciones por especie,
SGB y ruta. Las figuras leen las tablas producidas por el análisis.

El módulo exploratorio conserva en Python el procedimiento de predicción de
pérdida de peso y la agrupación por medoides. Su
[explicación](../03_analisis_estadistico/exploratorio_python/README.md) se lee
después del análisis principal.

El TFM también incluyó intervalos por bootstrap, comparaciones posteriores y
análisis de sensibilidad. Esas partes se conservan en el código de trabajo y
en sus resultados históricos. No están desarrolladas en los scripts breves
de R de este repositorio. Por tanto, estos scripts no constituyen por sí solos
una reproducción completa de todas las tablas y anexos del TFM.

## Código original y adaptación

La revisión del 11/11/2026 reorganiza y explica el código público. Se contrastó
con los scripts de trabajo y sus parámetros. Se comprobó la sintaxis sin
ejecutar el procesamiento ni los análisis sobre los datos del estudio.

Las nuevas versiones de R son adaptaciones para la lectura. No se ha
comprobado su equivalencia numérica mediante una nueva ejecución. Los
resultados entregados siguen siendo los obtenidos con el código histórico.

Los archivos y comentarios utilizan nombres y rutas de ejemplo. Las bases
de referencia y los datos restringidos se necesitan para ejecutar el
recorrido. Los archivos anteriores siguen accesibles en el historial de Git.
