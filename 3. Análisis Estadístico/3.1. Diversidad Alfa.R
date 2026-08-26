# Cálculo de la diversidad alfa mediante el índice de Shannon
library(vegan)

matriz <- read.csv("datos/matriz_taxonomica.csv", row.names = 1)
metadatos <- read.csv("datos/muestras.csv")

# Se ordenan los metadatos como las filas de la matriz
metadatos <- metadatos[match(rownames(matriz), metadatos$muestra), ]

# Shannon se calcula sobre la composición taxonómica no filtrada
metadatos$shannon <- diversity(matriz, index = "shannon")

# Se separan las visitas para calcular el cambio de cada participante
visita_v00 <- metadatos[metadatos$visita == "V00", ]
visita_v06 <- metadatos[metadatos$visita == "V06", ]

cambio <- merge(
  visita_v00[, c("participante", "grupo", "shannon")],
  visita_v06[, c("participante", "shannon")],
  by = "participante",
  suffixes = c("_V00", "_V06")
)

cambio$delta_shannon <- cambio$shannon_V06 - cambio$shannon_V00

# Se compara el cambio entre grupos mediante una prueba por permutaciones
estadistico_observado <- summary(
  aov(delta_shannon ~ grupo, data = cambio)
)[[1]]["grupo", "F value"]

set.seed(2026)
estadisticos_permutados <- replicate(9999, {
  grupo_permutado <- sample(cambio$grupo)
  summary(aov(cambio$delta_shannon ~ grupo_permutado))[[1]][1, "F value"]
})

valor_p <- (
  1 + sum(estadisticos_permutados >= estadistico_observado)
) / (1 + length(estadisticos_permutados))

prueba <- data.frame(
  estadistico_F = estadistico_observado,
  permutaciones = length(estadisticos_permutados),
  valor_p = valor_p
)

# El resumen es descriptivo porque el tamaño muestral es reducido
resumen <- aggregate(
  delta_shannon ~ grupo,
  data = cambio,
  FUN = function(x) c(mediana = median(x), rango_intercuartil = IQR(x))
)

dir.create("resultados", showWarnings = FALSE)
write.csv(cambio, "resultados/cambio_diversidad_alfa.csv", row.names = FALSE)
write.csv(resumen, "resultados/resumen_diversidad_alfa.csv", row.names = FALSE)
write.csv(prueba, "resultados/prueba_diversidad_alfa.csv", row.names = FALSE)
