# Análisis de la diversidad beta mediante transformación CLR y distancia de Aitchison
library(vegan)

matriz <- read.csv("datos/matriz_taxonomica.csv", row.names = 1)
metadatos <- read.csv("datos/muestras.csv")

# Los metadatos se ordenan para que coincidan con las muestras de la matriz
metadatos <- metadatos[match(rownames(matriz), metadatos$muestra), ]

# Antes de aplicar la transformación CLR, los ceros se sustituyen por valores pequeños y las demás abundancias se ajustan para mantener la suma de la composición
D <- ncol(matriz)
delta <- 1 / D^2

reemplazar_ceros <- function(fila) {
  if (sum(fila) <= 0) {
    stop("La muestra no contiene abundancias positivas")
  }

  fila <- fila / sum(fila)
  posiciones_cero <- fila == 0

  if (!any(posiciones_cero)) {
    return(fila)
  }

  masa_reemplazada <- sum(posiciones_cero) * delta

  if (masa_reemplazada >= 1) {
    stop("El valor de reemplazo no es válido para esta composición")
  }

  fila[!posiciones_cero] <- fila[!posiciones_cero] * (1 - masa_reemplazada)
  fila[posiciones_cero] <- delta
  fila
}

matriz <- t(apply(matriz, 1, reemplazar_ceros))

matriz_clr <- log(matriz) - rowMeans(log(matriz))

# Para cada participante, el cambio se obtiene como la diferencia CLR entre V06 y V00
participantes <- unique(metadatos$participante)
delta_clr <- matrix(
  nrow = length(participantes),
  ncol = ncol(matriz_clr),
  dimnames = list(participantes, colnames(matriz_clr))
)

grupos <- character(length(participantes))

for (i in seq_along(participantes)) {
  participante <- participantes[i]
  filas <- metadatos$participante == participante
  datos_participante <- metadatos[filas, ]
  clr_participante <- matriz_clr[filas, , drop = FALSE]

  posicion_v00 <- which(datos_participante$visita == "V00")
  posicion_v06 <- which(datos_participante$visita == "V06")

  delta_clr[i, ] <- (
    clr_participante[posicion_v06, ] - clr_participante[posicion_v00, ]
  )
  grupos[i] <- datos_participante$grupo[1]
}

# Se calcula la distancia euclídea sobre los cambios CLR para obtener la matriz de distancias de Aitchison
distancias_aitchison <- dist(delta_clr, method = "euclidean")

set.seed(2026)
permanova <- adonis2(distancias_aitchison ~ grupos, permutations = 9999)
dispersion <- betadisper(distancias_aitchison, as.factor(grupos))
prueba_dispersion <- permutest(dispersion, permutations = 9999)
pca <- prcomp(delta_clr, center = TRUE, scale. = FALSE)

dir.create("resultados", showWarnings = FALSE)
write.csv(delta_clr, "resultados/cambio_clr.csv")
write.csv(as.data.frame(pca$x), "resultados/pca_cambio_clr.csv")
write.csv(as.data.frame(permanova), "resultados/permanova_aitchison.csv")
write.csv(
  as.data.frame(prueba_dispersion$tab),
  "resultados/dispersion_aitchison.csv"
)
