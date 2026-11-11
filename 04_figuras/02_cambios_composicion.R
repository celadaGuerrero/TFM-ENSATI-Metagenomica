# Objetivo: representar el PCA de los cambios taxonómicos y funcionales.
# Entrada: especies_pca.csv y rutas_pca.csv. Salida: dos imágenes PNG.
# Ejemplo de representación, 11/11/2026; lee coordenadas ya calculadas.

library(ggplot2)
dir.create("resultados/figuras", recursive = TRUE, showWarnings = FALSE)

for (tipo_datos in c("especies", "rutas")) {
  archivo <- paste0("resultados/estadistica/beta/", tipo_datos, "_pca.csv")
  coordenadas <- read.csv(archivo)
  coordenadas$grupo <- factor(coordenadas$grupo,
                              levels = c("DMed", "DMed+RC", "DMed+TRE"))
  eje_x <- paste0("PC1 (", round(100 * coordenadas$varianza_PC1[1], 1), " %)")
  eje_y <- paste0("PC2 (", round(100 * coordenadas$varianza_PC2[1], 1), " %)")

  figura <- ggplot(coordenadas, aes(x = PC1, y = PC2, colour = grupo)) +
    geom_point(size = 2.5) +
    labs(x = eje_x, y = eje_y, colour = "Grupo") +
    coord_equal() +
    theme_classic()

  ggsave(paste0("resultados/figuras/cambios_", tipo_datos, ".png"), figura,
         width = 16, height = 11, units = "cm", dpi = 300)
}

