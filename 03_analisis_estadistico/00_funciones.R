# Funciones comunes para leer matrices, unir visitas y calcular cambios.
# Los scripts 01, 02 y 03 usan estas funciones desde la raíz del repositorio.

leer_metadatos <- function() {
  datos <- read.csv("resultados/preparacion/muestras.csv", stringsAsFactors = FALSE)
  columnas <- c("muestra", "participante", "visita", "grupo")
  stopifnot(all(columnas %in% names(datos)), !anyNA(datos[, columnas]))
  stopifnot(nrow(datos) == 30, !anyDuplicated(datos$muestra))
  datos$grupo <- factor(datos$grupo, levels = c("DMed", "DMed+RC", "DMed+TRE"))
  stopifnot(!anyNA(datos$grupo))
  datos
}

formar_parejas <- function(metadatos) {
  participantes <- sort(unique(metadatos$participante), method = "radix")
  parejas <- list()
  for (id in participantes) {
    filas <- metadatos[metadatos$participante == id, ]
    stopifnot(identical(sort(filas$visita), c("V00", "V06")))
    stopifnot(length(unique(filas$grupo)) == 1)
    parejas[[id]] <- data.frame(
      participante = id, grupo = filas$grupo[1],
      muestra_v00 = filas$muestra[filas$visita == "V00"],
      muestra_v06 = filas$muestra[filas$visita == "V06"]
    )
  }
  parejas <- do.call(rbind, parejas)
  rownames(parejas) <- NULL
  stopifnot(nrow(parejas) == 15, all(table(parejas$grupo) == 5))
  parejas
}

leer_matriz <- function(tipo_datos, metadatos) {
  archivo <- paste0("resultados/preparacion/matriz_", tipo_datos, ".csv")
  datos <- read.csv(archivo, row.names = 1, check.names = FALSE)
  stopifnot(!anyDuplicated(names(datos)))
  stopifnot(setequal(rownames(datos), metadatos$muestra))
  matriz <- as.matrix(datos[metadatos$muestra, , drop = FALSE])
  stopifnot(is.numeric(matriz), all(is.finite(matriz)), all(matriz >= 0))
  stopifnot(ncol(matriz) > 0, all(rowSums(matriz) > 0))
  matriz
}

preparar_cambios_clr <- function(matriz, metadatos, parejas) {
  # Conservar los códigos presentes en al menos seis muestras y tres personas.
  n_muestras <- colSums(matriz > 0)
  n_personas <- integer(ncol(matriz))
  for (id in parejas$participante) {
    filas <- metadatos$participante == id
    n_personas <- n_personas + (colSums(matriz[filas, , drop = FALSE] > 0) > 0)
  }
  conservar <- n_muestras >= 6 & n_personas >= 3
  filtro <- data.frame(codigo = colnames(matriz), n_muestras, n_personas, conservar)
  matriz <- matriz[, conservar, drop = FALSE]
  stopifnot(ncol(matriz) >= 2, all(rowSums(matriz) > 0))

  # Ajustar cada suma a uno y reemplazar los ceros de forma multiplicativa.
  proporciones <- matriz / rowSums(matriz)
  delta <- 1 / ncol(matriz)^2
  clr <- proporciones
  for (i in seq_len(nrow(proporciones))) {
    valores <- proporciones[i, ]
    ceros <- valores == 0
    masa_ceros <- sum(ceros) * delta
    stopifnot(masa_ceros < 1)
    valores[!ceros] <- valores[!ceros] * (1 - masa_ceros)
    valores[ceros] <- delta
    clr[i, ] <- log(valores) - mean(log(valores))
  }

  # Una fila por participante: V06 menos V00 en cada código.
  cambios <- clr[parejas$muestra_v06, , drop = FALSE] -
    clr[parejas$muestra_v00, , drop = FALSE]
  rownames(cambios) <- parejas$participante
  list(cambios = cambios, filtro = filtro, delta = delta)
}

crear_permutaciones <- function(n) {
  set.seed(20260720)
  permutaciones <- permute::shuffleSet(n, nset = 99999,
                                     control = permute::how(nperm = 99999))
  stopifnot(nrow(permutaciones) == 99999)
  permutaciones
}

# F compara las diferencias entre las medias con la variación dentro de los grupos.
# Cada fila de 'medias' corresponde a una permutación; las columnas son los grupos.
f_permutado <- function(medias, valores, tamanos) {
  entre <- rowSums(sweep((medias - mean(valores))^2, 2, tamanos, "*"))
  total <- sum((valores - mean(valores))^2)
  dentro <- pmax(total - entre, 0)
  f <- (entre / (length(tamanos) - 1)) / (dentro / (length(valores) - length(tamanos)))
  f[dentro <= .Machine$double.eps & entre > .Machine$double.eps] <- Inf
  f[dentro <= .Machine$double.eps & entre <= .Machine$double.eps] <- 0
  f
}

guardar_tabla <- function(tabla, archivo) {
  dir.create(dirname(archivo), recursive = TRUE, showWarnings = FALSE)
  write.csv(tabla, archivo, row.names = FALSE, fileEncoding = "UTF-8")
}
