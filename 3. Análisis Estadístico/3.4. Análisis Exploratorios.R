# Análisis exploratorios mediante Elastic Net y PAM
library(glmnet)
library(cluster)

matriz <- read.csv("datos/matriz_clr_especies_basales.csv", row.names = 1)
metadatos <- read.csv("datos/participantes.csv")
metadatos <- metadatos[match(rownames(matriz), metadatos$participante), ]

# Elastic Net utiliza los perfiles basales para explorar una clasificación
X <- as.matrix(matriz)
y <- as.factor(metadatos$respuesta)

set.seed(2026)
probabilidades <- numeric(nrow(X))

# En cada repetición se reserva un participante para la validación
for (i in seq_len(nrow(X))) {
  entrenamiento <- seq_len(nrow(X)) != i

  seleccion_lambda <- cv.glmnet(
    X[entrenamiento, ],
    y[entrenamiento],
    family = "binomial",
    alpha = 0.5,
    nfolds = 5
  )

  modelo_elastic_net <- glmnet(
    X[entrenamiento, ],
    y[entrenamiento],
    family = "binomial",
    alpha = 0.5,
    lambda = seleccion_lambda$lambda.min
  )

  probabilidades[i] <- predict(
    modelo_elastic_net,
    newx = X[i, , drop = FALSE],
    type = "response"
  )
}

# PAM explora agrupaciones sin utilizar la variable de respuesta
distancias <- dist(X, method = "euclidean")
modelo_pam <- pam(distancias, k = 3, diss = TRUE)

resultados <- data.frame(
  participante = metadatos$participante,
  probabilidad_elastic_net = probabilidades,
  grupo_pam = modelo_pam$clustering
)

dir.create("resultados", showWarnings = FALSE)
write.csv(resultados, "resultados/analisis_exploratorios.csv", row.names = FALSE)
