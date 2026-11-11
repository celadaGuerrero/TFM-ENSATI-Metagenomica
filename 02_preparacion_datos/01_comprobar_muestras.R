# Objetivo: comprobar las parejas V00-V06 y el grupo de cada participante.
# Entrada: datos/muestras.csv. Salida: resultados/preparacion/muestras.csv.
# Adaptación de lectura a R, 11/11/2026. No ejecutada sobre los datos del TFM.

muestras <- read.csv("datos/muestras.csv", stringsAsFactors = FALSE,
                     check.names = FALSE, colClasses = "character")
columnas <- c("muestra", "participante", "visita", "grupo")
if (!all(columnas %in% names(muestras))) stop("Faltan columnas en muestras.csv.")
muestras <- muestras[, columnas]
if (anyNA(muestras) || any(as.matrix(muestras) == "")) stop("Hay campos vacíos.")
if (anyDuplicated(muestras$muestra)) stop("Hay nombres de muestra repetidos.")
if (anyDuplicated(muestras[, c("participante", "visita")])) {
  stop("Hay más de una muestra por participante y visita.")
}
if (!all(muestras$visita %in% c("V00", "V06"))) stop("Revisar las visitas.")

# Aceptar los códigos de ENSATI o los nombres utilizados en el análisis.
grupos <- c("1" = "DMed+RC", "2" = "DMed+TRE", "3" = "DMed",
            "DMed+RC" = "DMed+RC", "DMed+TRE" = "DMed+TRE", "DMed" = "DMed")
if (!all(muestras$grupo %in% names(grupos))) stop("Revisar los códigos de grupo.")
muestras$grupo <- unname(grupos[muestras$grupo])

for (id in unique(muestras$participante)) {
  pareja <- muestras[muestras$participante == id, ]
  if (nrow(pareja) != 2 || !setequal(pareja$visita, c("V00", "V06"))) {
    stop("Cada participante debe tener V00 y V06: ", id)
  }
  if (length(unique(pareja$grupo)) != 1) stop("El grupo cambia entre visitas: ", id)
}

# Este recorrido corresponde a las 30 muestras del TFM, con cinco personas por grupo.
basal <- muestras[muestras$visita == "V00", ]
if (nrow(muestras) != 30 || nrow(basal) != 15 ||
    length(unique(basal$grupo)) != 3 || any(table(basal$grupo) != 5)) {
  stop("La selección no coincide con los 15 participantes con dos visitas del TFM.")
}
muestras <- muestras[order(muestras$participante, muestras$visita, method = "radix"), ]
dir.create("resultados/preparacion", recursive = TRUE, showWarnings = FALSE)
write.csv(muestras, "resultados/preparacion/muestras.csv", row.names = FALSE)
