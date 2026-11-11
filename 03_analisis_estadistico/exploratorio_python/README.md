# Análisis exploratorios en Python

Estos scripts conservan el análisis exploratorio del TFM en Python. Pasarlo
a R requeriría comprobar de nuevo sus resultados.

## Archivos necesarios

Los dos archivos se guardan en `datos/exploratorio/`, dentro de la carpeta principal del repositorio.
Son tablas TSV, separadas por tabulaciones, y no se incluyen en GitHub.

| Archivo | Contenido |
|---|---|
| `matriz_basal.tsv` | Una fila por participante en V00 y una columna por especie. Primera columna: `participante`. Abundancias relativas antes del filtro de prevalencia y antes de CLR. |
| `respuesta_peso.tsv` | Una fila por participante. Columnas `participante`, `respondedor_5pct` y `perdida_peso_pct`. |

La pérdida de peso se expresa como `100 × (peso V00 − peso V06) / peso V00`.
`respondedor_5pct` vale 1 cuando la pérdida es al menos del 5 %, y 0 en el resto.
Se emplean los valores ya preparados y revisados para el TFM. Se conservan todos
los decimales; no se vuelve a clasificar a partir de porcentajes redondeados.
El modelo predice si la pérdida de peso alcanza el 5 %.

La matriz utilizada en el TFM contiene 15 filas y 1.095 especies. Se mantiene su orden de
participantes y columnas. Ese orden también afecta a las particiones aleatorias.
`entradas.py` comprueba la correspondencia y las ocho respuestas positivas y
siete negativas del TFM. Los identificadores deben ser los mismos en ambas tablas.

## Orden de lectura

1. [Elastic Net](01_elasticnet.py). Se deja fuera a una persona y se entrena
   con las otras 14. Dentro de ese entrenamiento se comparan las opciones del
   modelo mediante tres particiones estratificadas. Se repite hasta obtener una
   predicción para cada persona.
2. [Grupos de perfiles basales](02_grupos_medoides.py). Se buscan agrupaciones
   con dos, tres o cuatro grupos. Se elige la mayor silueta media. En caso de
   empate, se usa la estabilidad al retirar una persona y después el menor
   número de grupos. La respuesta de peso no interviene en esa elección.
3. [Referencia condicional](03_referencia_condicional.py). Se mantienen fijas
   las predicciones de Elastic Net y se comparan las 6.435 asignaciones posibles
   de ocho respuestas positivas entre 15 personas. Es una referencia descriptiva;
   no vuelve a entrenar el modelo con cada asignación.

Las funciones compartidas están en [model_utils.py](model_utils.py).
Se conservan los cálculos del archivo original y se han aclarado sus comentarios.

## Decisiones del modelo

Dentro de cada partición de entrenamiento se conservan las especies presentes
en al menos el 20 % de las personas, redondeando el mínimo hacia arriba.
Después se ajusta la suma de cada muestra a uno, se sustituyen los ceros con
`delta = 1 / D²` y se aplica CLR. `D` es el número de especies conservadas.
La media y la desviación usadas para estandarizar se calculan solo con las
personas del entrenamiento. Los datos de la persona evaluada no se utilizan para decidir el filtro ni
para calcular esas medias y desviaciones. Esto también se respeta al comparar
las opciones del modelo dentro del entrenamiento.

Elastic Net usa `C = 0.01, 0.1, 1, 10, 100` y
`l1_ratio = 0, 0.25, 0.5, 0.75, 1`. La elección se basa en la exactitud equilibrada.
En los empates se prefiere menor `C` y mayor `l1_ratio`.
Se mantienen `saga`, pesos de clase equilibrados, 5.000 iteraciones máximas,
tolerancia de 0,001 y semilla base 20260730.

El agrupamiento usa un filtro descriptivo distinto: presencia en al menos tres
participantes basales. Se calcula la distancia euclídea entre perfiles CLR.
El código evalúa todas las combinaciones de medoides para elegir el número
de grupos. Un medoide es el perfil de un participante que se toma como
representante de su grupo.
La estabilidad al retirar una persona se calcula sobre las distancias ya
obtenidas, sin repetir el filtrado. Estos grupos no se presentan como enterotipos.

## Salidas

Los resultados se escriben en `resultados/exploratorio/`:

| Paso | Archivos |
|---|---|
| Elastic Net | `predicciones_elasticnet.tsv`, `coeficientes_elasticnet.tsv`, `resumen_elasticnet.json` |
| Agrupamiento | `grupos_medoides.tsv`, `comparacion_k.tsv`, `resumen_medoides.json` |
| Referencia | `referencia_condicional.json` |

La métrica `average_precision` corresponde a `average_precision_score`.
En la salida histórica se llamó `pr_auc`; aquí se aclara el nombre sin cambiar
su cálculo. No equivale al área calculada por trapecios bajo la curva de precisión y sensibilidad.

## Sobre esta versión

Versión preparada el 11/11/2026 a partir de los scripts originales
`06_ejecutar_elasticnet_anidado.py`, `08_ejecutar_PAM_basal.py` y
`07_validar_y_referencia_condicional.py`. Se cambian rutas, nombres de archivos,
algunos comentarios y la lectura de las tablas. Se añade una comprobación de
las entradas. Las comprobaciones originales con datos simulados se conservan en los
archivos de trabajo y no se incluyen aquí.

Se ha revisado el código y comprobado su sintaxis sin ejecutar los modelos.
No se han vuelto a calcular ni comparar los resultados.
Las versiones de [requirements.txt](../../requirements.txt) corresponden al entorno
conservado consultado el 11/11/2026; no son una nueva ejecución del análisis.

