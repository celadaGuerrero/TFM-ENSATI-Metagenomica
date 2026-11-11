# Funciones para resumir las predicciones guardadas por Elastic Net.

leer_predicciones <- function(archivo) {
  datos <- read.delim(archivo, check.names = FALSE, stringsAsFactors = FALSE)
  necesarias <- c("participante", "observado", "probabilidad_respondedor", "prediccion_0_5")
  stopifnot(all(necesarias %in% names(datos)))
  stopifnot(nrow(datos) == 15, !anyNA(datos[necesarias]))
  stopifnot(!anyDuplicated(datos$participante), all(nzchar(datos$participante)))
  stopifnot(all(datos$observado %in% c(0, 1)), sum(datos$observado) == 8)
  stopifnot(all(datos$prediccion_0_5 %in% c(0, 1)))
  stopifnot(all(is.finite(datos$probabilidad_respondedor)))
  stopifnot(all(datos$probabilidad_respondedor >= 0 & datos$probabilidad_respondedor <= 1))
  # Se usa la clasificación guardada: no se reconstruye con probabilidades redondeadas.
  datos
}

exactitud_equilibrada <- function(observado, prediccion) {
  sensibilidad <- mean(prediccion[observado == 1] == 1)
  especificidad <- mean(prediccion[observado == 0] == 0)
  mean(c(sensibilidad, especificidad))
}

area_roc <- function(observado, probabilidad) {
  positivos <- sum(observado == 1)
  negativos <- sum(observado == 0)
  # Los empates reciben el rango medio.
  rangos <- rank(probabilidad, ties.method = "average")
  (sum(rangos[observado == 1]) - positivos * (positivos + 1) / 2) /
    (positivos * negativos)
}

precision_media <- function(observado, probabilidad) {
  # Cada umbral incluye juntas las predicciones con la misma probabilidad.
  umbrales <- sort(unique(probabilidad), decreasing = TRUE)
  aciertos <- vapply(umbrales, function(umbral) {
    sum(observado[probabilidad >= umbral] == 1)
  }, numeric(1))
  seleccionados <- vapply(umbrales, function(umbral) {
    sum(probabilidad >= umbral)
  }, numeric(1))
  sensibilidad <- aciertos / sum(observado == 1)
  precision <- aciertos / seleccionados
  # Average precision: suma por escalones, sin interpolar mediante trapecios.
  sum(diff(c(0, sensibilidad)) * precision)
}

metricas_prediccion <- function(datos) {
  observado <- datos$observado
  prediccion <- datos$prediccion_0_5
  probabilidad <- datos$probabilidad_respondedor
  data.frame(
    metrica = c("balanced_accuracy", "sensitivity", "specificity", "roc_auc",
                "average_precision", "brier_score"),
    valor = c(exactitud_equilibrada(observado, prediccion),
              mean(prediccion[observado == 1] == 1),
              mean(prediccion[observado == 0] == 0),
              area_roc(observado, probabilidad),
              precision_media(observado, probabilidad),
              mean((probabilidad - observado)^2))
  )
}
