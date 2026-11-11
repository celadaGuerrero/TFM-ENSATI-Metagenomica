# Análisis exploratorios en Python

Estos scripts conservan el análisis exploratorio del TFM en Python. El modelo
predice si un participante pierde al menos el 5 % de su peso. También se buscan
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
casos. Se utilizan los valores revisados para el TFM, con todos sus decimales.
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
compartidas están en [model_utils.py](model_utils.py), que conserva los
cálculos originales con comentarios revisados.

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

## Referencia condicional

[03_referencia_condicional.py](03_referencia_condicional.py) mantiene fijas las
predicciones de Elastic Net y compara las 6.435 formas posibles de asignar
ocho respuestas positivas entre 15 participantes.

Es una referencia descriptiva de esas predicciones. No se vuelve a entrenar
el modelo con cada asignación, por lo que no constituye una prueba estadística
del procedimiento completo de predicción.

## Salidas

Los resultados se escriben en `resultados/exploratorio/`:

| Paso | Archivos |
|---|---|
| Elastic Net | `predicciones_elasticnet.tsv`, `coeficientes_elasticnet.tsv`, `resumen_elasticnet.json` |
| Agrupamiento | `grupos_medoides.tsv`, `comparacion_k.tsv`, `resumen_medoides.json` |
| Referencia | `referencia_condicional.json` |

La métrica `average_precision` se calcula con `average_precision_score`.
En la salida original se llamó `pr_auc`; aquí cambia el nombre, pero no el
cálculo. No equivale al área calculada por trapecios bajo la curva de precisión
y sensibilidad.

## Sobre esta versión

Versión preparada el 11/11/2026 a partir de los scripts originales
`06_ejecutar_elasticnet_anidado.py`, `08_ejecutar_PAM_basal.py` y
`07_validar_y_referencia_condicional.py`. Se han cambiado las rutas, los nombres
de archivo, algunos comentarios y la lectura de las tablas. Se han añadido
comprobaciones de las entradas. Las comprobaciones originales con datos
simulados se conservan en los archivos de trabajo y no se incluyen aquí.

Se ha revisado el código y comprobado su sintaxis sin ejecutar los modelos.
No se han vuelto a calcular ni comparar los resultados. Las versiones de
[requirements.txt](../../requirements.txt) corresponden al entorno conservado,
consultado el 11/11/2026; no proceden de una nueva ejecución.
