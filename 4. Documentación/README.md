# 4. Documentación

Este repositorio acompaña al TFM y presenta una versión didáctica del flujo de
procesamiento y análisis. Los scripts conservan las decisiones metodológicas
principales, pero no sustituyen el entorno de producción ni permiten reproducir
los resultados sin los datos restringidos y las bases de datos de referencia.

## 4.1. Organización de los Archivos

Los apartados siguen el orden del trabajo: preprocesamiento, preparación de
datos y análisis estadístico. Cada script utiliza rutas relativas y nombres
genéricos para facilitar su lectura sin exponer la infraestructura del estudio.

## 4.2. Dependencias Principales

- fastp para el control de calidad de las lecturas.
- Bowtie2 para el filtrado frente al genoma humano GRCh38.
- MetaPhlAn 4 para la obtención de perfiles taxonómicos.
- HUMAnN 3 para la caracterización funcional y las rutas MetaCyc.
- Python 3 con pandas para la comprobación y preparación de las matrices.
- R con vegan, glmnet y cluster para los análisis estadísticos exploratorios.

Las versiones concretas, las bases de datos y los parámetros completos se
describen en la memoria del TFM.

## 4.3. Entradas y Salidas

Los ejemplos esperan lecturas pareadas, una tabla de metadatos con las columnas
`muestra`, `participante`, `visita` y `grupo`, y matrices de abundancia con las
muestras en filas. Las salidas se guardan en el directorio local `resultados/`,
que está excluido del control de versiones.

## 4.4. Privacidad y Disponibilidad

No deben incorporarse al repositorio datos clínicos, secuencias, perfiles por
muestra, identificadores seudonimizados, correspondencias entre códigos,
registros de ejecución, credenciales o rutas del servidor. El acceso a los
datos originales requiere las autorizaciones correspondientes de ENSATI.
