# 4. Figuras

Los scripts leen las tablas de resultados y guardan los gráficos en
`resultados/figuras/`. No repiten las pruebas estadísticas.

| Script | Tabla que lee | Qué muestra |
|---|---|---|
| [Cambio en Shannon](01_cambio_diversidad_alfa.R) | `resultados/estadistica/alfa/cambios_por_participante.csv` | Cambio de cada participante, separado por grupo de intervención |
| [Cambios en composición](02_cambios_composicion.R) | `resultados/estadistica/beta/especies_pca.csv` y `rutas_pca.csv` | Resumen de los cambios CLR en dos ejes |

En el PCA, cada punto representa el cambio de un participante entre visitas.
Los ejes recogen parte de la variación de esos cambios. Las diferencias entre
grupos se valoran con las pruebas estadísticas, no solo mirando la figura.

Las columnas deben tener los nombres indicados en los scripts. Para usar una
tabla del análisis original, se prepara una copia con esos nombres y las
mismas unidades, sin cambiar sus valores.

Estos scripts muestran cómo representar el cambio en Shannon y los cambios
de composición. Las figuras del TFM y sus tablas se conservan en el proyecto.
