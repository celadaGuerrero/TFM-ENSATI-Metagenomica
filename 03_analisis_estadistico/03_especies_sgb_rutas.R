# Objetivo: comparar entre grupos el cambio CLR de cada especie, SGB o ruta.
# Entrada: metadatos y las tres matrices preparadas.
# Salida: estadístico F, p y q de Benjamini-Hochberg por tipo de datos.
# Las comparaciones posteriores y los intervalos se conservan en los scripts originales.

library(permute)
source("03_analisis_estadistico/00_funciones.R")

# 1. Leer los metadatos y preparar las mismas permutaciones para todos los códigos.
metadatos <- leer_metadatos()
parejas <- formar_parejas(metadatos)
grupo <- parejas$grupo
permutaciones <- crear_permutaciones(nrow(parejas))
tamanos <- as.integer(table(grupo))

# Aquí se permutan las etiquetas de grupo entre los participantes.
asignacion <- lapply(levels(grupo), function(g) {
  matrix(as.numeric(grupo[permutaciones] == g), nrow = nrow(permutaciones))
})

for (tipo_datos in c("especies", "sgb", "rutas")) {
  # 2. Aplicar el filtro de prevalencia y obtener los cambios de cada participante.
  matriz <- leer_matriz(tipo_datos, metadatos)
  preparado <- preparar_cambios_clr(matriz, metadatos, parejas)
  cambios <- preparado$cambios
  pruebas <- list()

  # 3. Comparar cada código usando las mismas 99.999 permutaciones.
  for (j in seq_len(ncol(cambios))) {
    cambio <- cambios[, j]
    medias_observadas <- sapply(levels(grupo), function(g) mean(cambio[grupo == g]))
    f_observado <- f_permutado(matrix(medias_observadas, nrow = 1), cambio, tamanos)
    medias_permutadas <- sapply(seq_along(asignacion), function(g) {
      as.vector(asignacion[[g]] %*% cambio) / tamanos[g]
    })
    f_simulado <- f_permutado(medias_permutadas, cambio, tamanos)
    p <- (sum(f_simulado >= f_observado - 1e-12) + 1) / (nrow(permutaciones) + 1)
    pruebas[[j]] <- data.frame(codigo = colnames(cambios)[j], f_observado, p)
  }
  pruebas <- do.call(rbind, pruebas)

  # 4. Ajustar por separado todas las pruebas de especies, SGB y rutas.
  pruebas$q_BH <- p.adjust(pruebas$p, method = "BH")
  pruebas$respaldo_q_005 <- pruebas$q_BH < 0.05
  pruebas$candidato_q_010 <- pruebas$q_BH >= 0.05 & pruebas$q_BH < 0.10
  destino <- paste0("resultados/estadistica/", tipo_datos, "/")
  guardar_tabla(pruebas, paste0(destino, "pruebas_globales.csv"))
  guardar_tabla(preparado$filtro, paste0(destino, "filtro.csv"))
}
