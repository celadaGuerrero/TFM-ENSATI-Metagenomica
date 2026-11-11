# Objetivo: comparar los cambios en la composición taxonómica y funcional.
# Entrada: metadatos y matrices de especies y rutas MetaCyc.
# Salida: PERMANOVA, dispersión y coordenadas del PCA de los cambios CLR.
# Versión breve: los contrastes por pares y las sensibilidades se conservan aparte.

library(vegan)
library(permute)
source("03_analisis_estadistico/00_funciones.R")

# 1. Formar las parejas y generar las mismas permutaciones para ambos análisis.
metadatos <- leer_metadatos()
parejas <- formar_parejas(metadatos)
permutaciones <- crear_permutaciones(nrow(parejas))
resumen <- list()

for (tipo_datos in c("especies", "rutas")) {
  # 2. Filtrar, reemplazar ceros y calcular CLR(V06) - CLR(V00).
  matriz <- leer_matriz(tipo_datos, metadatos)
  preparado <- preparar_cambios_clr(matriz, metadatos, parejas)
  cambios <- preparado$cambios
  distancia <- dist(cambios, method = "euclidean")

  # 3. PERMANOVA entre los cambios de las personas, con cinco por grupo.
  modelo <- adonis2(distancia ~ grupo, data = parejas,
                    permutations = permutaciones)
  dispersion <- betadisper(distancia, parejas$grupo,
                           type = "median", bias.adjust = FALSE)
  prueba_dispersion <- permutest(dispersion, permutations = permutaciones)
  resumen[[tipo_datos]] <- data.frame(
    tipo_datos, codigos_iniciales = ncol(matriz), codigos_analizados = ncol(cambios),
    pseudo_f = modelo$F[1], r2 = modelo$R2[1], p = modelo$`Pr(>F)`[1],
    f_dispersion = prueba_dispersion$tab[1, "F"],
    p_dispersion = prueba_dispersion$tab[1, "Pr(>F)"],
    delta_reemplazo_ceros = preparado$delta
  )

  # 4. Resumir los cambios con PCA. Sus coordenadas permiten hacer las figuras.
  pca <- prcomp(cambios, center = TRUE, scale. = FALSE)
  varianza <- pca$sdev^2 / sum(pca$sdev^2)
  coordenadas <- data.frame(
    participante = parejas$participante, grupo = parejas$grupo,
    PC1 = pca$x[, 1], PC2 = pca$x[, 2],
    varianza_PC1 = varianza[1], varianza_PC2 = varianza[2]
  )
  tabla_cambios <- data.frame(parejas[, c("participante", "grupo")], cambios,
                              check.names = FALSE)
  destino <- paste0("resultados/estadistica/beta/", tipo_datos, "_")
  guardar_tabla(preparado$filtro, paste0(destino, "filtro.csv"))
  guardar_tabla(tabla_cambios, paste0(destino, "cambios_clr.csv"))
  guardar_tabla(coordenadas, paste0(destino, "pca.csv"))
}
guardar_tabla(do.call(rbind, resumen), "resultados/estadistica/beta/pruebas_globales.csv")
