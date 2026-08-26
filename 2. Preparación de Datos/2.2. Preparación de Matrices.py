"""Preparación de una matriz de abundancias relativas."""

from pathlib import Path

import pandas as pd

metadatos = pd.read_csv("datos/muestras.csv")
perfiles = pd.read_csv(
    "datos/perfiles_taxonomicos.tsv",
    sep="\t",
    index_col="caracteristica",
)

# La tabla original contiene las características en filas
matriz = perfiles.transpose()
matriz.index.name = "muestra"

# Se conserva únicamente la intersección entre perfiles y metadatos
muestras_esperadas = set(metadatos["muestra"])
muestras_disponibles = set(matriz.index)

if muestras_esperadas != muestras_disponibles:
    faltantes = muestras_esperadas - muestras_disponibles
    adicionales = muestras_disponibles - muestras_esperadas
    raise ValueError(
        f"No coinciden las muestras. Faltantes: {faltantes}; "
        f"adicionales: {adicionales}"
    )

# El cierre transforma cada fila en una composición de suma uno
if (matriz < 0).any().any():
    raise ValueError("La matriz contiene abundancias negativas")

sumas = matriz.sum(axis=1)

if (sumas == 0).any():
    raise ValueError("Alguna muestra no contiene abundancias positivas")

matriz_relativa = matriz.div(sumas, axis=0)

# Se mantiene el mismo orden que en los metadatos
orden_muestras = metadatos["muestra"].tolist()
matriz_relativa = matriz_relativa.loc[orden_muestras]

Path("resultados").mkdir(exist_ok=True)
matriz_relativa.to_csv("resultados/matriz_taxonomica.csv")

print("Matriz taxonómica preparada")
print(f"Dimensiones: {matriz_relativa.shape}")
