# Objetivo: representar el cambio en Shannon a partir de una tabla ya calculada.
# Entrada: cambios_por_persona.csv. Salida: resultados/figuras/cambio_shannon.png.
# Ejemplo de representación, 11/11/2026; no vuelve a calcular ninguna prueba.

library(ggplot2)
cambios <- read.csv("resultados/estadistica/alfa/cambios_por_persona.csv")
cambios$grupo <- factor(cambios$grupo, levels = c("DMed", "DMed+RC", "DMed+TRE"))

figura <- ggplot(cambios, aes(x = grupo, y = delta_shannon)) +
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey60") +
  geom_boxplot(outlier.shape = NA, width = 0.55) +
  geom_point(position = position_jitter(width = 0.06, height = 0, seed = 2026)) +
  labs(x = "Grupo de intervención", y = "Cambio en Shannon: V06 - V00") +
  theme_classic()

dir.create("resultados/figuras", recursive = TRUE, showWarnings = FALSE)
ggsave("resultados/figuras/cambio_shannon.png", figura,
       width = 16, height = 11, units = "cm", dpi = 300)
