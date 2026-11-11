# Predicción y agrupación de perfiles basales

Python entrena el modelo y agrupa los perfiles. R prepara las tablas de resumen
y la comparación descriptiva de las predicciones. El modelo predice si un participante pierde al menos el 5 % de su peso. También se buscan
grupos de participantes con una composición microbiana similar en la visita basal.

## Archivos necesarios

Los dos archivos se guardan en `datos/exploratorio/`, dentro de la carpeta
principal del repositorio. Son tablas TSV, separadas por tabulaciones, y no
se incluyen en GitHub.

| Archivo | Contenido |
|---|---|
| `matriz_basal.tsv` | Una fila por participante en V00 y una columna por especie. Primera columna: `participante`. Abundancias relativas antes del filtro de prevalencia y de la transformación CLR. |
| `respuesta_peso.tsv` | Una fila por participante. Columnas `participante`, `respondedor_5pct` y `perdida_peso_pct`. |

La pérdida de peso se calcula como `100 × (peso V00 − peso V06) / peso V00`.
`respondedor_5pct` vale 1 si la pérdida es de al menos el 5 %, y 0 en los demás
casos. Se utilizan los valores del TFM, con todos sus decimales.
La clasificación no se vuelve a calcular a partir de porcentajes redondeados.

La matriz del TFM contiene 15 participantes y 1.095 especies. Se conserva el
orden de sus filas y columnas, porque influye en el reparto aleatorio de los
datos. Los identificadores de participante deben coincidir en ambas tablas.
`entradas.py` comprueba esa correspondencia, las ocho respuestas positivas y
las siete negativas.

## Predicción con Elastic Net

[01_elasticnet.py](01_elasticnet.py) usa validación cruzada: evalúa el modelo
con participantes cuyos datos no se han utilizado para entrenarlo. Se deja
fuera a un participante, se entrena con los otros 14 y se predice la respuesta
del participante excluido. Se repite hasta obtener una predicción para cada
uno de los 15 participantes.

Para elegir las opciones del modelo, los 14 participantes del entrenamiento
se reparten en tres partes, llamadas particiones. Se procura mantener en cada
una la proporción de respuestas positivas y negativas. Se entrena con dos
partes y se evalúa con la tercera, alternándolas hasta evaluar las tres.

En cada entrenamiento se conservan las especies presentes en al menos el
20 % de los participantes, redondeando el mínimo hacia arriba. Después se
ajusta la suma de abundancias de cada muestra a uno. Los ceros se sustituyen
mediante un ajuste multiplicativo con `delta = 1 / D²`, donde `D` es el número
de especies conservadas, y se aplica la transformación CLR.

La media y la desviación para estandarizar los datos se calculan solo con los
participantes del entrenamiento. Los datos del participante evaluado no
intervienen en el filtro ni en esos cálculos. Esta separación se mantiene
también en las tres particiones internas.

Se comparan `C = 0.01, 0.1, 1, 10, 100` y
`l1_ratio = 0, 0.25, 0.5, 0.75, 1`. Se elige la combinación con mayor exactitud
equilibrada: la media del porcentaje de aciertos en cada tipo de respuesta.
En caso de empate, se prefiere menor `C` y mayor `l1_ratio`.

El modelo utiliza `saga`, pesos de clase equilibrados, un máximo de 5.000
iteraciones, tolerancia de 0,001 y semilla base 20260730. Las funciones
compartidas están en [model_utils.py](model_utils.py), donde se definen el
filtro, las transformaciones y la elección de los parámetros.

## Grupos de perfiles basales

[02_grupos_medoides.py](02_grupos_medoides.py) conserva las especies presentes
en al menos tres participantes en V00. Calcula las distancias euclídeas entre
sus perfiles CLR y compara agrupaciones de dos, tres y cuatro grupos.

Cada grupo tiene un medoide: el perfil de un participante que se toma como
representante. Para cada número de grupos se examinan todas las combinaciones
posibles de medoides y se conserva la que minimiza la suma de las distancias
de cada perfil a su medoide más cercano. Entre las tres soluciones se elige
la de mayor silueta media, una medida de la semejanza dentro de los grupos y de su separación entre sí.

En caso de empate, se prefiere la agrupación que cambia menos al retirar un
participante y, después, la que tiene menos grupos. Esa estabilidad se calcula
con las distancias ya obtenidas, sin repetir el filtro. La respuesta de peso
no interviene en la elección. Estos grupos no se presentan como enterotipos.

## Resúmenes en R

Después de los dos scripts de Python, se ejecuta
[04_resumen_exploratorio.R](../04_resumen_exploratorio.R) desde la carpeta
principal del repositorio. Lee las predicciones y las agrupaciones guardadas.
No entrena el modelo ni elige otra agrupación.

El resumen de predicción incluye la exactitud equilibrada, la sensibilidad,
la especificidad, el área bajo la curva ROC, la precisión media
(`average_precision`) y el error de Brier. También guarda una tabla con los
aciertos y los errores de clasificación. La precisión media se calcula por
escalones; no es el área por trapecios bajo la curva de precisión y sensibilidad.

El resumen de cada agrupación recoge cuántos participantes contiene, cuántos
pierden al menos el 5 % del peso y la mediana de la pérdida de peso.
La agrupación ya está decidida antes de consultar esos datos de peso.

Las funciones están en [00_metricas_exploratorio.R](../00_metricas_exploratorio.R).
Los resúmenes usan los valores guardados en las tablas. Estas contienen
12 cifras significativas, por lo que las últimas cifras pueden diferir de un
cálculo realizado con toda la precisión interna del modelo. Se conserva la
clasificación guardada por Python.

## Comparación descriptiva de las predicciones

[05_comparacion_predicciones.R](../05_comparacion_predicciones.R) mantiene fijas
las predicciones y compara las 6.435 formas de asignar ocho respuestas positivas
entre 15 participantes. Guarda la media de cada medida y la proporción de
asignaciones que igualan o superan el valor observado.

Esta comparación es descriptiva. Como no se vuelve a entrenar el modelo con
cada asignación, no es una prueba estadística del procedimiento completo.

## Archivos que se guardan

Todas las tablas se guardan en `resultados/exploratorio/`.

| Paso | Archivos |
|---|---|
| 01. Elastic Net, en Python | `predicciones_elasticnet.tsv`, `coeficientes_elasticnet.tsv` |
| 02. Agrupamiento, en Python | `grupos_medoides.tsv`, `comparacion_k.tsv` |
| 04. Resúmenes, en R | `resumen_elasticnet.csv`, `confusion_elasticnet.csv`, `resumen_medoides.csv`, `seleccion_medoides.csv` |
| 05. Comparación descriptiva, en R | `comparacion_predicciones.csv` |

`comparacion_k.tsv` recoge la silueta, la estabilidad y el número de especies
para cada solución. `seleccion_medoides.csv` muestra la solución elegida.

Las dependencias de Python están en [requirements.txt](../../requirements.txt).
Los resúmenes utilizan R base.
