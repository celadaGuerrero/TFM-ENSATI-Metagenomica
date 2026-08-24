# TFM ENSATI: análisis metagenómico de la microbiota intestinal

Repositorio asociado al Trabajo Fin de Máster de José A. Celada Guerrero.

## Descripción

Se realizó un análisis longitudinal de una submuestra de 15 participantes del
ensayo ENSATI, con cinco participantes por grupo de intervención. Se
analizaron 30 muestras de heces recogidas antes de la intervención (V00) y a
los seis meses (V06).

El análisis tuvo carácter exploratorio y se centró en los cambios taxonómicos
y funcionales observados en cada participante entre ambas visitas.

## Metodología

El procesamiento y el análisis siguieron las siguientes etapas:

1. Control de calidad de las lecturas con fastp.
2. Filtrado frente al genoma humano de referencia con Bowtie2.
3. Obtención de perfiles taxonómicos con MetaPhlAn.
4. Obtención de perfiles funcionales y rutas MetaCyc con HUMAnN.
5. Preparación de las matrices y análisis de la diversidad alfa y beta.
6. Análisis de especies, grupos genómicos a nivel de especie (SGB) y rutas MetaCyc.

También se realizaron análisis de sensibilidad y una ampliación exploratoria
mediante Elastic Net y PAM.

## Contenido

1. **Preprocesamiento: control de calidad y procesamiento metagenómico.**
2. **Preparación de los datos: comprobación de las muestras y creación de las matrices.**
3. **Análisis estadístico: evaluación de la diversidad y de los cambios taxonómicos y funcionales.**
4. **Documentación: descripción del procedimiento y de los archivos.**

## Disponibilidad de los datos

Este repositorio no contiene datos clínicos, secuencias metagenómicas ni
identificadores de participantes o muestras. El acceso a los datos originales
está restringido y requiere las autorizaciones correspondientes de ENSATI.

