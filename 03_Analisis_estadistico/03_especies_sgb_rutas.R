# Filtrado por prevalencia y ajuste de los valores p
matriz <- read.csv("datos/matriz_abundancias.csv", row.names = 1)
caracteristicas <- colMeans(matriz > 0) >= 0.20
matriz_filtrada <- matriz[, caracteristicas]

resultados <- read.csv("datos/resultados_permutaciones.csv")
resultados$q <- p.adjust(resultados$p, method = "BH")

write.csv(resultados, "resultados/resultados_ajustados.csv", row.names = FALSE)

