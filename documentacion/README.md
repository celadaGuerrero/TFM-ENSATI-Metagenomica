# Documentación del análisis

La pregunta principal es si el cambio entre V00 y V06 difiere entre los tres
grupos. Cada participante aporta un cambio a esa comparación. Sus dos muestras
no se tratan como observaciones independientes.

- [Métodos, versiones y parámetros](metodos_y_versiones.md).
- [Notas sobre la revisión del código](cambios_20261111.md).

## Qué incluye el repositorio

Se muestran el procesamiento de las lecturas, la preparación de matrices y
los análisis principales. Las figuras se hacen a partir de las tablas de
resultados. El [apartado en Python](../03_analisis_estadistico/exploratorio_python/README.md)
incluye la predicción de respuesta de peso y la agrupación de perfiles basales.

Los intervalos por bootstrap, las comparaciones posteriores y los análisis
de sensibilidad se conservan en los archivos originales. No se incluyen en
los scripts simplificados. Para reproducir todas las tablas y anexos del
TFM se necesitan esos archivos originales y los datos restringidos.

## Qué se ha comprobado

Se han comparado los pasos y parámetros con los scripts originales y se ha
revisado la sintaxis. No se ha vuelto a ejecutar el procesamiento ni el análisis.
Por tanto, no se ha comprobado mediante una nueva ejecución si las adaptaciones
reproducen los mismos valores. Los resultados entregados siguen siendo los
obtenidos con los scripts originales.

Las rutas y los nombres de muestra son ejemplos. Las versiones anteriores
del código público siguen disponibles en el historial de Git.
