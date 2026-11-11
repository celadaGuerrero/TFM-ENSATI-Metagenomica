# 4. Figuras a partir de las tablas

Los scripts leen las tablas de resultados y guardan los gráficos en
`resultados/figuras/`. Los cálculos estadísticos se hacen por separado.

| Script | Tabla de entrada | Qué muestra |
|---|---|---|
| [Cambio en Shannon](01_cambio_diversidad_alfa.R) | `resultados/estadistica/alfa/cambios_por_persona.csv` | Cambio de cada participante, agrupado por intervención |
| [Cambios en composición](02_cambios_composicion.R) | `resultados/estadistica/beta/especies_pca.csv` y `rutas_pca.csv` | Resumen en dos ejes de los cambios CLR |

En el PCA, cada punto representa el cambio de una persona entre visitas.
Los ejes resumen parte de la variación de esos cambios. Las diferencias
estadísticas se valoran con las pruebas del análisis, no solo con la figura.

Los nombres de columna coinciden con las salidas de los scripts breves. Para
representar una tabla del análisis original, se necesita una copia con esos nombres
y unidades, conservando sus valores. Los originales se mantienen aparte.

Son ejemplos nuevos que muestran cómo dibujar las tablas de resultados.
No se han ejecutado ni sustituyen las figuras de la memoria entregada.
