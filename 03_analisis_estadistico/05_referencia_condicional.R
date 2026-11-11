# Comparar todas las asignaciones posibles de respuesta con las predicciones fijas.
# Es una referencia descriptiva: no se vuelve a entrenar el modelo.

source("03_analisis_estadistico/00_metricas_exploratorio.R", encoding = "UTF-8")
carpeta <- "resultados/exploratorio"
datos <- leer_predicciones(file.path(carpeta, "predicciones_elasticnet.tsv"))
observado <- datos$observado
prediccion <- datos$prediccion_0_5
probabilidad <- datos$probabilidad_respondedor

# Cada columna señala qué ocho participantes reciben la etiqueta 1.
asignaciones <- combn(nrow(datos), sum(observado))
stopifnot(ncol(asignaciones) == 6435)
referencia <- matrix(NA_real_, nrow = ncol(asignaciones), ncol = 2)

for (i in seq_len(ncol(asignaciones))) {
  respuesta <- integer(nrow(datos))
  respuesta[asignaciones[, i]] <- 1L
  referencia[i, 1] <- exactitud_equilibrada(respuesta, prediccion)
  referencia[i, 2] <- area_roc(respuesta, probabilidad)
}

valores_observados <- c(exactitud_equilibrada(observado, prediccion),
                        area_roc(observado, probabilidad))
resumen <- data.frame(
  metrica = c("balanced_accuracy", "roc_auc"),
  observado = valores_observados,
  media_referencia = colMeans(referencia),
  proporcion_igual_o_mayor = c(mean(referencia[, 1] >= valores_observados[1]),
                              mean(referencia[, 2] >= valores_observados[2])),
  n_asignaciones = ncol(asignaciones)
)
write.csv(resumen, file.path(carpeta, "referencia_condicional.csv"), row.names = FALSE)
message("Referencia descriptiva guardada. No es una prueba del modelo completo.")
