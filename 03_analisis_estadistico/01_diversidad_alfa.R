# Objetivo: comparar el cambio en diversidad entre los tres grupos.
# Entrada: metadatos y matriz de especies, sin filtro de prevalencia.
# Salida: índices por muestra, cambios por participante y pruebas globales.
# Los intervalos bootstrap y las comparaciones posteriores están en los scripts originales.

library(vegan)
library(permute)
source("03_analisis_estadistico/00_funciones.R")

# 1. Leer las entradas y comprobar las parejas V00-V06.
metadatos <- leer_metadatos()
parejas <- formar_parejas(metadatos)
matriz <- leer_matriz("especies", metadatos)
proporciones <- matriz / rowSums(matriz)

# 2. Calcular los índices sobre abundancias que suman uno por muestra.
indices <- data.frame(
  muestra = metadatos$muestra,
  shannon = diversity(proporciones, index = "shannon"),
  simpson = diversity(proporciones, index = "simpson"),
  riqueza = rowSums(proporciones >= 0.0001)
)
fila_v00 <- match(parejas$muestra_v00, indices$muestra)
fila_v06 <- match(parejas$muestra_v06, indices$muestra)
cambios <- parejas[, c("participante", "grupo")]
for (indice in c("shannon", "simpson", "riqueza")) {
  cambios[[paste0("delta_", indice)]] <- indices[[indice]][fila_v06] -
    indices[[indice]][fila_v00]
}

# 3. Comparar los cambios. El grupo es un factor, no una variable numérica.
permutaciones <- crear_permutaciones(nrow(parejas))
grupo <- parejas$grupo
tamanos <- as.integer(table(grupo))
pruebas <- list()
for (indice in c("shannon", "simpson", "riqueza")) {
  cambio <- cambios[[paste0("delta_", indice)]]
  modelo <- aov(cambio ~ grupo)
  tabla_modelo <- summary(modelo)[[1]]
  f_observado <- tabla_modelo["grupo", "F value"]
  if (all(cambio == cambio[1])) f_observado <- 0

  # Mantener los grupos y permutar los valores de cambio entre los participantes.
  valores <- matrix(cambio[permutaciones], nrow = nrow(permutaciones))
  medias <- sapply(levels(grupo), function(g) rowMeans(valores[, grupo == g]))
  f_simulado <- f_permutado(medias, cambio, tamanos)
  p <- (sum(f_simulado >= f_observado - 1e-12) + 1) / (nrow(permutaciones) + 1)
  pruebas[[indice]] <- data.frame(indice, f_observado, p)
}
pruebas <- do.call(rbind, pruebas)

# Shannon fue el índice principal. Holm se aplicó a los dos índices secundarios.
pruebas$p_ajustado <- NA_real_
secundarios <- pruebas$indice != "shannon"
pruebas$p_ajustado[secundarios] <- p.adjust(pruebas$p[secundarios], method = "holm")
pruebas$p_para_interpretar <- ifelse(secundarios, pruebas$p_ajustado, pruebas$p)

# 4. Guardar las tablas. Las figuras se preparan en otro script.
guardar_tabla(indices, "resultados/estadistica/alfa/indices_por_muestra.csv")
guardar_tabla(cambios, "resultados/estadistica/alfa/cambios_por_participante.csv")
guardar_tabla(pruebas, "resultados/estadistica/alfa/pruebas_globales.csv")
