"""Transformación de los perfiles taxonómicos en una matriz de abundancias relativas."""

from pathlib import Path

import pandas as pd

metadatos = pd.read_csv("datos/muestras.csv")
perfiles = pd.read_csv(
    "datos/perfiles_taxonomicos.tsv",
    sep="\t",
    index_col="caracteristica",
)

# Los perfiles se reorganizan para colocar las muestras en filas y los taxones en columnas
matriz = perfiles.transpose()
matriz.index.name = "muestra"

# Se verifica que no falten ni sobren muestras al comparar los perfiles con los metadatos
muestras_esperadas = set(metadatos["muestra"])
muestras_disponibles = set(matriz.index)

if muestras_esperadas != muestras_disponibles:
    faltantes = muestras_esperadas - muestras_disponibles
    adicionales = muestras_disponibles - muestras_esperadas
    raise ValueError(
        f"No coinciden las muestras. Faltantes: {faltantes}; "
        f"adicionales: {adicionales}"
    )

# Las abundancias de cada muestra se normalizan para que su suma sea igual a uno
if (matriz < 0).any().any():
    raise ValueError("La matriz contiene abundancias negativas")

sumas = matriz.sum(axis=1)

if (sumas == 0).any():
    raise ValueError("Alguna muestra no contiene abundancias positivas")

matriz_relativa = matriz.div(sumas, axis=0)

# Las muestras se ordenan siguiendo el mismo orden de la tabla de metadatos
orden_muestras = metadatos["muestra"].tolist()
matriz_relativa = matriz_relativa.loc[orden_muestras]

Path("resultados").mkdir(exist_ok=True)
matriz_relativa.to_csv("resultados/matriz_taxonomica.csv")

print("Matriz taxonómica preparada")
print(f"Dimensiones: {matriz_relativa.shape}")
