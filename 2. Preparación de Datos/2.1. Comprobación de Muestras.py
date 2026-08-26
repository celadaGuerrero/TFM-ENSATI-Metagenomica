"""Comprobación de la estructura longitudinal de las muestras."""

import pandas as pd

muestras = pd.read_csv("datos/muestras.csv")

columnas_necesarias = ["muestra", "participante", "visita", "grupo"]

# Se comprueba que estén disponibles todas las variables necesarias
for columna in columnas_necesarias:
    if columna not in muestras.columns:
        raise ValueError(f"Falta la columna: {columna}")

# Cada código de muestra debe aparecer una sola vez
if muestras["muestra"].duplicated().any():
    raise ValueError("Se han encontrado códigos de muestra duplicados")

# Cada participante debe disponer de una muestra V00 y otra V06
visitas = muestras.groupby("participante")["visita"].apply(set)

for participante, visitas_participante in visitas.items():
    if visitas_participante != {"V00", "V06"}:
        raise ValueError(
            f"El participante {participante} no dispone de las dos visitas"
        )

# El grupo de intervención no debe cambiar entre visitas
grupos = muestras.groupby("participante")["grupo"].nunique()

if not grupos.eq(1).all():
    raise ValueError("Algún participante presenta grupos distintos entre visitas")

print("La estructura longitudinal de las muestras es correcta")
print(f"Participantes: {muestras['participante'].nunique()}")
print(f"Muestras: {len(muestras)}")
