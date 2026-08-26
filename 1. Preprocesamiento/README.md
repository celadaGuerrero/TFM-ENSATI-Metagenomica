# 1. Preprocesamiento

Este apartado recoge las etapas utilizadas para transformar las lecturas
metagenómicas pareadas en perfiles taxonómicos y funcionales. Se representan
la unificación de los carriles técnicos, el control de calidad con fastp, la
eliminación de las lecturas alineadas frente al genoma humano y el análisis
posterior con MetaPhlAn y HUMAnN.

Los comandos utilizan nombres y rutas genéricos. No se incluyen secuencias,
identificadores de muestras, bases de datos de referencia ni rutas del entorno
de producción. Su finalidad es describir las decisiones principales del
procesamiento realizado en el TFM.

## 1.1. Control de Calidad

Se unifican los carriles técnicos de cada muestra y se aplica el filtrado de
adaptadores y lecturas de baja calidad. fastp genera además los informes HTML
y JSON utilizados para revisar el rendimiento técnico.

## 1.2. Filtrado frente al Genoma Humano

Las lecturas conservadas se alinean frente al genoma humano de referencia
GRCh38. Los pares no alineados constituyen la entrada de los análisis
metagenómicos posteriores.

## 1.3. Perfil Taxonómico

MetaPhlAn obtiene la composición taxonómica mediante marcadores
clado-específicos y genera una tabla de abundancias relativas por muestra.

## 1.4. Perfil Funcional

HUMAnN caracteriza el potencial funcional de la comunidad microbiana. Sus
salidas principales contienen familias génicas, abundancia de rutas MetaCyc y
cobertura de rutas.
