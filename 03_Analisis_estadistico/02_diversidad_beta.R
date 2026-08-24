# Preparación de los datos para el análisis de diversidad beta
matriz <- read.csv("datos/matriz_especies.csv", row.names = 1)
D <- ncol(matriz)

matriz[matriz == 0] <- 1 / D^2
matriz <- matriz / rowSums(matriz)
matriz_clr <- log(matriz) - rowMeans(log(matriz))

write.csv(as.matrix(dist(matriz_clr)), "resultados/distancias_aitchison.csv")

