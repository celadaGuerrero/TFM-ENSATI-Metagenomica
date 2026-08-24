# Cálculo de la diversidad alfa mediante el índice de Shannon
library(vegan)

matriz <- read.csv("datos/matriz_especies.csv", row.names = 1)
shannon <- diversity(matriz, index = "shannon")

write.csv(shannon, "resultados/diversidad_alfa.csv")

