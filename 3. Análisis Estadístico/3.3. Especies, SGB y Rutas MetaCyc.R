# El análisis compara los cambios en especies, SGB y rutas MetaCyc entre los grupos de intervención

# El análisis se repite de forma independiente para las especies, los SGB y las rutas MetaCyc
FAMILIA <- "especies"

# En este ejemplo se limita el número de permutaciones, aunque puede aumentarse en el análisis definitivo
NUM_PERMUTACIONES <- 999

matriz <- read.csv(
  paste0("datos/matriz_", FAMILIA, ".csv"),
  row.names = 1
)
metadatos <- read.csv("datos/muestras.csv")
metadatos <- metadatos[match(rownames(matriz), metadatos$muestra), ]

# El filtro de prevalencia exige que cada característica aparezca en un mínimo de seis muestras y tres participantes
presencia_muestras <- colSums(matriz > 0)
presencia_participantes <- sapply(colnames(matriz), function(caracteristica) {
  participantes_positivos <- metadatos$participante[matriz[, caracteristica] > 0]
  length(unique(participantes_positivos))
})

caracteristicas_validas <- (
  presencia_muestras >= 6 & presencia_participantes >= 3
)
matriz <- matriz[, caracteristicas_validas, drop = FALSE]

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

# Para cada especie, SGB o ruta MetaCyc, el estadístico observado se contrasta permutando las etiquetas de grupo entre participantes
set.seed(2026)
resultados <- data.frame()

for (caracteristica in colnames(delta_clr)) {
  valores <- delta_clr[, caracteristica]
  estadistico_observado <- summary(aov(valores ~ grupos))[[1]][1, "F value"]

  estadisticos_permutados <- replicate(NUM_PERMUTACIONES, {
    grupos_permutados <- sample(grupos)
    summary(aov(valores ~ grupos_permutados))[[1]][1, "F value"]
  })

  valor_p <- (
    1 + sum(estadisticos_permutados >= estadistico_observado)
  ) / (1 + NUM_PERMUTACIONES)

  resultados <- rbind(
    resultados,
    data.frame(
      familia = FAMILIA,
      caracteristica = caracteristica,
      estadistico_F = estadistico_observado,
      valor_p = valor_p
    )
  )
}

# El ajuste mediante Benjamini-Hochberg se realiza por separado para las especies, los SGB y las rutas MetaCyc
resultados$valor_q <- p.adjust(resultados$valor_p, method = "BH")
resultados <- resultados[order(resultados$valor_q), ]

dir.create("resultados", showWarnings = FALSE)
write.csv(
  resultados,
  paste0("resultados/resultados_", FAMILIA, ".csv"),
  row.names = FALSE
)
