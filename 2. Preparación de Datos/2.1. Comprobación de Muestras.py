"""Revisión de las muestras y de su organización por participante y visita."""

import pandas as pd

muestras = pd.read_csv("datos/muestras.csv")

columnas_necesarias = ["muestra", "participante", "visita", "grupo"]

# Se verifica que la tabla incluya las columnas de muestra, participante, visita y grupo
for columna in columnas_necesarias:
    if columna not in muestras.columns:
        raise ValueError(f"Falta la columna: {columna}")

# Cada muestra debe estar representada por un único registro
if muestras["muestra"].duplicated().any():
    raise ValueError("Se han encontrado códigos de muestra duplicados")

# Para mantener el diseño longitudinal, cada participante debe incluir las visitas V00 y V06
visitas = muestras.groupby("participante")["visita"].apply(set)

for participante, visitas_participante in visitas.items():
    if visitas_participante != {"V00", "V06"}:
        raise ValueError(
            f"El participante {participante} no dispone de las dos visitas"
        )

# Se comprueba que cada participante mantenga el mismo grupo de intervención en V00 y V06
grupos = muestras.groupby("participante")["grupo"].nunique()

if not grupos.eq(1).all():
    raise ValueError("Algún participante presenta grupos distintos entre visitas")

print("La estructura longitudinal de las muestras es correcta")
print(f"Participantes: {muestras['participante'].nunique()}")
print(f"Muestras: {len(muestras)}")
