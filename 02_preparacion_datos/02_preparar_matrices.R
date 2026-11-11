# Objetivo: reunir los perfiles en tres matrices, con una fila por muestra.
# Entrada: perfiles individuales y muestras.csv comprobado. Salida: tres CSV.
# Adaptación a R del lector original en Python, 11/11/2026; no ejecutada.

muestras <- read.csv("resultados/preparacion/muestras.csv", colClasses = "character")
especies <- list()
sgb <- list()
rutas <- list()

# Cada vector conserva el código completo y su abundancia, sin sumar niveles.
vector_abundancias <- function(codigos, valores) {
  if (!length(codigos) || anyDuplicated(codigos)) stop("Faltan códigos o se repiten.")
  if (any(!is.finite(valores)) || any(valores < 0)) stop("Abundancias no válidas.")
  setNames(valores, codigos)
}

for (muestra in muestras$muestra) {
  archivo <- paste0("resultados/metaphlan/", muestra, "_perfil.tsv")
  perfil <- read.delim(archivo, header = FALSE, comment.char = "#", quote = "",
                       fill = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
  if (ncol(perfil) < 3) stop("Perfil taxonómico incompleto: ", muestra)
  codigos <- perfil[[1]]
  valores <- as.numeric(perfil[[3]]) / 100
  dominio <- grepl("^k__(Bacteria|Archaea)\\|", codigos)
  es_especie <- dominio & grepl("\\|s__[^|]+$", codigos)
  es_sgb <- dominio & grepl("\\|t__[^|]+$", codigos)
  especies[[muestra]] <- vector_abundancias(codigos[es_especie], valores[es_especie])
  sgb[[muestra]] <- vector_abundancias(codigos[es_sgb], valores[es_sgb])

  archivo <- paste0("resultados/humann/", muestra, "/", muestra, "_pathabundance.tsv")
  perfil <- read.delim(archivo, comment.char = "", quote = "", check.names = FALSE,
                       stringsAsFactors = FALSE)
  if (ncol(perfil) != 2) stop("Se espera un archivo de rutas por muestra.")
  codigos <- perfil[[1]]
  # Usar el total de cada ruta; las filas con | son contribuciones por microorganismo.
  conservar <- !grepl("|", codigos, fixed = TRUE) &
               !codigos %in% c("UNMAPPED", "UNINTEGRATED")
  rutas[[muestra]] <- vector_abundancias(codigos[conservar],
                                        as.numeric(perfil[[2]][conservar]))
}

# Un código ausente en un perfil recibe cero. El orden de muestras es el mismo
# en metadatos y matrices; el orden de códigos sigue el del lector original.
guardar_matriz <- function(perfiles, nombre) {
  codigos <- sort(unique(unlist(lapply(perfiles, names))), method = "radix")
  matriz <- matrix(0, nrow = nrow(muestras), ncol = length(codigos),
                   dimnames = list(muestras$muestra, codigos))
  for (muestra in muestras$muestra) {
    valores <- perfiles[[muestra]]
    matriz[muestra, names(valores)] <- valores
  }
  if (any(rowSums(matriz) <= 0)) stop("Hay una muestra sin abundancias: ", nombre)
  salida <- data.frame(muestra = rownames(matriz), matriz, check.names = FALSE)
  write.csv(salida, paste0("resultados/preparacion/matriz_", nombre, ".csv"),
            row.names = FALSE)
}

guardar_matriz(especies, "especies")
guardar_matriz(sgb, "sgb")
guardar_matriz(rutas, "rutas")
# Aquí no se filtra por prevalencia ni se sustituyen ceros. La suma se ajusta
# a uno dentro del análisis que lo necesita, después de seleccionar sus columnas.
