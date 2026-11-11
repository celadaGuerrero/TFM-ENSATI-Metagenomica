# 4. Figuras a partir de las tablas

Estos ejemplos separan la representación de los cálculos estadísticos. Leen
tablas ya preparadas y guardan imágenes en `resultados/figuras/`. No calculan
p-valores ni vuelven a ajustar modelos.

| Script | Tabla de entrada | Qué muestra |
|---|---|---|
| [Cambio en Shannon](01_cambio_diversidad_alfa.R) | `resultados/estadistica/alfa/cambios_por_persona.csv` | Cambio de cada participante, agrupado por intervención |
| [Cambios en composición](02_cambios_composicion.R) | `resultados/estadistica/beta/especies_pca.csv` y `rutas_pca.csv` | Resumen en dos ejes de los cambios CLR |

En el PCA, cada punto representa el cambio de una persona entre visitas.
No representa una muestra individual. Los ejes resumen parte de la variación;
la figura por sí sola no establece diferencias estadísticas entre grupos.

Los nombres de columna coinciden con las salidas de los scripts breves. Para
representar una tabla histórica, se necesita una copia con esos mismos nombres
y unidades, conservando sus valores. Los originales se mantienen aparte.

Son ejemplos nuevos para explicar la separación entre análisis y figuras.
No se han ejecutado ni sustituyen las figuras de la memoria entregada.
