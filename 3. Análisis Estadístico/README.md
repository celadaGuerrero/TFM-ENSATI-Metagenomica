# 3. Análisis Estadístico

El análisis mantiene el diseño longitudinal del estudio: cada participante
aporta una muestra basal (V00) y otra a los seis meses (V06). La unidad de
análisis es el participante, y las dos visitas no se consideran observaciones
independientes.

Se representan el cálculo de la diversidad de Shannon, el cambio
intraindividual, la transformación CLR, la distancia de Aitchison, el filtrado
por prevalencia y el ajuste de los valores p mediante Benjamini–Hochberg. Los
análisis tienen carácter exploratorio y no deben interpretarse como una
estimación causal del efecto de las intervenciones.

## 3.1. Diversidad Alfa

El índice de Shannon se calcula sobre la composición taxonómica no filtrada.
Después se obtiene para cada participante el cambio entre V00 y V06.

## 3.2. Diversidad Beta

Los ceros se sustituyen antes de aplicar la transformación CLR. El cambio
intraindividual se expresa como `CLR_V06 - CLR_V00`, y la distancia euclídea
sobre estos vectores corresponde a la distancia de Aitchison.

## 3.3. Especies, SGB y Rutas MetaCyc

Las características se filtran por prevalencia y se comparan a partir del
cambio intraindividual. Los valores p se ajustan por separado dentro de cada
familia mediante el método de Benjamini–Hochberg.

## 3.4. Análisis Exploratorios

Elastic Net representa el análisis predictivo con validación por participante.
PAM se utiliza de forma complementaria para explorar posibles agrupaciones en
los perfiles taxonómicos basales.
