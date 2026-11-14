# TFM ENSATI: microbioma intestinal

Este repositorio reúne el código para explicar el procesamiento y análisis del TFM de José Antonio Celada Guerrero sobre el microbioma
intestinal en ENSATI. Se utilizan datos de metagenómica shotgun de muestras de heces.

Se analizaron 30 muestras de 15 participantes, cinco por grupo de intervención.
Cada participante aportó una muestra en la visita basal (V00) y otra a los seis
meses (V06). La pregunta principal es si el cambio entre visitas difiere entre
los tres grupos.

El análisis es exploratorio. La selección de los participantes y el tamaño
de la muestra limitan las conclusiones.

## Por dónde empezar

| Paso | Qué se hace | Archivos |
|---|---|---|
| 1 | Revisar las lecturas y obtener las abundancias de microorganismos y rutas metabólicas | [Procesamiento](01_procesamiento/README.md) |
| 2 | Comprobar las visitas y reunir las abundancias en tablas | [Preparación de datos](02_preparacion_datos/README.md) |
| 3 | Comparar los cambios entre los grupos de intervención | [Análisis estadístico](03_analisis_estadistico/README.md) |
| 4 | Hacer gráficos a partir de las tablas de resultados | [Figuras](04_figuras/README.md) |

R se utiliza para preparar los datos, hacer los análisis principales y elaborar
resúmenes y figuras. Python se utiliza para entrenar el modelo predictivo y
agrupar los perfiles basales. Los programas de procesamiento se ejecutan desde
Bash.

## Archivos y datos

Cada carpeta explica las entradas y las salidas de sus scripts. Las rutas
parten de la carpeta principal del repositorio. Los datos se leen desde
`datos/` y las salidas se guardan en `resultados/`.

El recorrido incluye los análisis principales. Para reproducir todas las
tablas y anexos del TFM también se necesitan los scripts complementarios y
los datos del proyecto. La [documentación](documentacion/README.md) detalla
este alcance y las versiones de los programas.

Los datos clínicos y metagenómicos tienen acceso restringido. Su uso requiere
la autorización de los responsables del estudio. El repositorio contiene
código y documentación, sin datos individuales.
