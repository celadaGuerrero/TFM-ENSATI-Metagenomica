# TFM ENSATI: microbioma intestinal

Este repositorio acompaña al TFM de José Antonio Celada Guerrero.

Se analizaron 30 muestras de heces de 15 participantes del estudio ENSATI,
cinco por grupo de intervención. Cada persona aportó una muestra al inicio
(V00) y otra a los seis meses (V06). La comparación entre grupos se hizo a
partir del cambio de cada participante.

El trabajo es exploratorio. La selección de participantes y el tamaño de
la muestra limitan la interpretación de los resultados.

## Orden de lectura

| Paso | Qué se hace | Código y explicación |
|---|---|---|
| 1 | Revisar las lecturas, filtrar frente al genoma humano y obtener los perfiles | [Procesamiento](01_procesamiento/README.md) |
| 2 | Comprobar las parejas y preparar las matrices de especies, SGB y rutas | [Preparación de datos](02_preparacion_datos/README.md) |
| 3 | Comparar la diversidad y los cambios entre grupos | [Análisis estadístico](03_analisis_estadistico/README.md) |
| 4 | Representar las tablas de resultados | [Figuras](04_figuras/README.md) |

## Cómo está organizado

Los scripts presentan un recorrido breve del procedimiento. La preparación
de tablas y las comparaciones principales se muestran en R. Los programas de
procesamiento se utilizan desde Bash. El análisis exploratorio conserva el
algoritmo original en Python.

Esta revisión, del 11 de noviembre de 2026, aclara el código público. Los
scripts adaptados no se han ejecutado sobre los datos del TFM y no sustituyen
los resultados ya conservados. La [documentación](documentacion/README.md)
explica qué incluye el recorrido y qué análisis complementarios quedan fuera.

| Etapa | Programas |
|---|---|
| Control de calidad y filtrado | fastp 0.22.0; Bowtie2 2.5.4 |
| Taxonomía y funciones | MetaPhlAn 4.2.4, base vJun23; HUMAnN 3.9 |
| Estadística | R, vegan y permute |
| Predicción exploratoria | Python y scikit-learn |

Las bases de datos, versiones y parámetros se detallan en
[Métodos y versiones](documentacion/metodos_y_versiones.md).

## Datos y uso

Las rutas son relativas a la raíz del repositorio. Los ejemplos esperan los
archivos de entrada en `datos/` y guardan sus salidas en `resultados/`.
Cada carpeta indica las columnas necesarias y el orden de los scripts.

Los datos clínicos y metagenómicos originales tienen acceso restringido.
Su uso requiere la autorización de los responsables del estudio. Este
repositorio contiene código y documentación, sin datos individuales.
