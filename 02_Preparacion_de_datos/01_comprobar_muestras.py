"""Comprobación básica del listado de muestras incluidas."""

import pandas as pd

muestras = pd.read_csv("datos/muestras.csv")
columnas = {"participante", "visita", "grupo"}

assert columnas.issubset(muestras.columns)
assert set(muestras["visita"]) == {"V00", "V06"}
assert muestras.groupby("participante").size().eq(2).all()

print("Listado de muestras comprobado")

