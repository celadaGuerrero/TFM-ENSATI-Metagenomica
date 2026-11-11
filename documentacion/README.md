# Documentación del análisis

La pregunta principal es si el cambio entre V00 y V06 difiere entre los tres
grupos. Por eso, cada persona aporta un cambio a la comparación. Sus dos
muestras no se tratan como observaciones independientes.

- [Métodos, versiones y parámetros](metodos_y_versiones.md).
- [Cambios en esta revisión](cambios_20261111.md).

## Alcance del código

Los scripts incluyen el procesamiento de lecturas, la preparación de
matrices, las pruebas globales de diversidad y las comparaciones por especie,
SGB y ruta. Las figuras leen las tablas producidas por el análisis.

El análisis exploratorio conserva en Python la predicción de una pérdida de
peso de al menos el 5 % y la agrupación por medoides. Su
[explicación](../03_analisis_estadistico/exploratorio_python/README.md) se lee
después del análisis principal.

El TFM también incluyó intervalos por bootstrap, comparaciones posteriores y
análisis de sensibilidad. Esas partes se conservan en el código de trabajo y
en sus resultados originales. No están desarrolladas en los scripts breves
de R de este repositorio. Por eso, se necesita el
código original para reproducir todas las tablas y anexos del TFM.

## Código original y adaptación

El 11/11/2026 se reorganizó el código público y se revisaron sus explicaciones.
Se compararon los pasos y parámetros con los scripts originales y se comprobó
la sintaxis. No se ejecutó el procesamiento ni el análisis de los datos.

Las versiones simplificadas de R se han preparado para facilitar la lectura.
No se han ejecutado para comprobar si reproducen los mismos valores. Los
resultados del TFM siguen siendo los obtenidos con los scripts originales.

Los archivos y comentarios utilizan nombres y rutas de ejemplo. Las bases
de referencia y los datos restringidos se necesitan para ejecutar los
programas. Los archivos anteriores siguen accesibles en el historial de Git.

