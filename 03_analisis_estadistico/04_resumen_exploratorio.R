# Leer las tablas de Python y guardar los resúmenes en CSV.
# Ejecutar desde la carpeta principal del repositorio.

source("03_analisis_estadistico/00_metricas_exploratorio.R", encoding = "UTF-8")
carpeta <- "resultados/exploratorio"
predicciones <- leer_predicciones(file.path(carpeta, "predicciones_elasticnet.tsv"))
grupos <- read.delim(file.path(carpeta, "grupos_medoides.tsv"), stringsAsFactors = FALSE)
comparacion <- read.delim(file.path(carpeta, "comparacion_k.tsv"), stringsAsFactors = FALSE)

# Las dos tablas deben describir a los mismos participantes.
columnas <- c("participante", "cluster", "es_medoid", "respondedor_5pct", "perdida_peso_pct")
stopifnot(all(columnas %in% names(grupos)), !anyNA(grupos[columnas]))
stopifnot(!anyDuplicated(grupos$participante))
stopifnot(setequal(predicciones$participante, grupos$participante))
grupos <- grupos[match(predicciones$participante, grupos$participante), ]
stopifnot(all(grupos$respondedor_5pct == predicciones$observado))
stopifnot(all(is.finite(grupos$perdida_peso_pct)))
stopifnot(all(grupos$es_medoid %in% c(0, 1)))

# Resumen de las predicciones. Todas proceden de participantes excluidos del entrenamiento.
resumen <- metricas_prediccion(predicciones)
write.csv(resumen, file.path(carpeta, "resumen_elasticnet.csv"), row.names = FALSE)

confusion <- as.data.frame(table(
  observado = factor(predicciones$observado, levels = 0:1),
  prediccion = factor(predicciones$prediccion_0_5, levels = 0:1)
))
names(confusion)[3] <- "n_participantes"
write.csv(confusion, file.path(carpeta, "confusion_elasticnet.csv"), row.names = FALSE)

# Describir la agrupación ya elegida en Python. El peso no interviene en esa elección.
resumen_grupos <- lapply(split(grupos, grupos$cluster), function(grupo) {
  data.frame(
    agrupacion = grupo$cluster[1],
    n_participantes = nrow(grupo),
    respondedores = sum(grupo$respondedor_5pct),
    respondedores_pct = 100 * mean(grupo$respondedor_5pct),
    mediana_perdida_peso_pct = median(grupo$perdida_peso_pct)
  )
})
resumen_grupos <- do.call(rbind, resumen_grupos)
write.csv(resumen_grupos, file.path(carpeta, "resumen_medoides.csv"), row.names = FALSE)

# Recuperar la solución elegida, sin volver a ordenar las medidas redondeadas del TSV.
k_elegido <- sum(grupos$es_medoid)
stopifnot(k_elegido %in% 2:4, all(grupos$cluster %in% seq_len(k_elegido)))
stopifnot(all(c("k", "silhouette_mean", "ARI_LOO_mean", "n_especies") %in% names(comparacion)))
stopifnot(setequal(comparacion$k, 2:4), !anyDuplicated(comparacion$k))
seleccion <- comparacion[comparacion$k == k_elegido, ]
stopifnot(nrow(seleccion) == 1)
write.csv(seleccion, file.path(carpeta, "seleccion_medoides.csv"), row.names = FALSE)

message("Resúmenes guardados en resultados/exploratorio.")
