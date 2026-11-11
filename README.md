# TFM ENSATI: microbioma intestinal

Este repositorio contiene los scripts que acompañan al TFM de José Antonio
Celada Guerrero sobre el microbioma intestinal en el estudio ENSATI.

Se analizaron 30 muestras de heces de 15 participantes, cinco por grupo de
intervención. Cada participante aportó una muestra en la visita basal (V00)
y otra a los seis meses (V06). Se comparó el cambio entre ambas visitas
entre los tres grupos.

El análisis es exploratorio. La selección de los participantes y el tamaño
de la muestra limitan las conclusiones.

## Por dónde empezar

| Paso | Qué se hace | Archivos |
|---|---|---|
| 1 | Revisar las lecturas y obtener las abundancias de microorganismos y rutas metabólicas | [Procesamiento](01_procesamiento/README.md) |
| 2 | Comprobar las visitas y reunir las abundancias en tablas | [Preparación de datos](02_preparacion_datos/README.md) |
| 3 | Comparar los cambios entre los grupos de intervención | [Análisis estadístico](03_analisis_estadistico/README.md) |
| 4 | Hacer gráficos a partir de las tablas de resultados | [Figuras](04_figuras/README.md) |

La preparación de datos y los análisis principales se muestran en R.
Los programas de procesamiento se ejecutan desde Bash. El análisis
exploratorio mantiene su código en Python.

## Sobre estos archivos

El código se ha resumido para facilitar su lectura. Las adaptaciones no se
han ejecutado de nuevo con los datos del TFM. Los resultados entregados
proceden de los scripts originales. La [documentación](documentacion/README.md)
explica qué partes se incluyen y cuáles se conservan en los archivos de trabajo.

Cada carpeta indica las entradas y las salidas. Las rutas parten de la carpeta
principal del repositorio. Los datos se leen desde `datos/` y las salidas se
guardan en `resultados/`.

Los datos clínicos y metagenómicos originales tienen acceso restringido.
Su uso requiere la autorización de los responsables del estudio. Este
repositorio contiene código y documentación, sin datos individuales.
