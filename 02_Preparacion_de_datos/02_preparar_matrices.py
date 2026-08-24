"""Preparación básica de una matriz de abundancias relativas."""

import pandas as pd

perfiles = pd.read_csv("datos/perfiles_taxonomicos.tsv", sep="\t", index_col=0)
matriz = perfiles.T
matriz = matriz.div(matriz.sum(axis=1), axis=0)

matriz.to_csv("resultados/matriz_especies.csv")
print("Matriz de especies preparada")

