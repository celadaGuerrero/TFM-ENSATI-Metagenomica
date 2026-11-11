"""Lectura y comprobación de las dos tablas privadas del bloque exploratorio."""

from pathlib import Path

import numpy as np
import pandas as pd


def leer_entradas(matriz: Path, respuesta: Path) -> tuple[pd.DataFrame, pd.DataFrame]:
    datos = pd.read_csv(matriz, sep="\t", index_col="participante")
    peso = pd.read_csv(respuesta, sep="\t").set_index("participante")
    if len(datos) != 15 or datos.index.has_duplicates or peso.index.has_duplicates:
        raise ValueError("Se esperan 15 participantes, con una fila por persona")
    if set(datos.index) != set(peso.index) or datos.index.isna().any():
        raise ValueError("Las tablas deben contener los mismos participantes")
    if datos.columns.has_duplicates or not len(datos.columns):
        raise ValueError("Cada especie debe tener un identificador único")
    valores = datos.to_numpy(dtype=float)
    if not np.isfinite(valores).all() or (valores < 0).any():
        raise ValueError("Las abundancias deben ser finitas y no negativas")
    if (valores.sum(axis=1) <= 0).any():
        raise ValueError("Una muestra no contiene abundancias positivas")
    peso = peso.loc[datos.index]
    respuesta_binaria = peso["respondedor_5pct"]
    perdida = peso["perdida_peso_pct"].to_numpy(dtype=float)
    if not respuesta_binaria.isin([0, 1]).all() or respuesta_binaria.sum() != 8:
        raise ValueError("El análisis del TFM tiene ocho respuestas positivas y siete negativas")
    if not np.isfinite(perdida).all():
        raise ValueError("Falta el porcentaje de pérdida de peso")
    if not np.array_equal(respuesta_binaria.to_numpy(), (perdida >= 5).astype(int)):
        raise ValueError("La respuesta debe corresponder a una pérdida de peso de al menos el 5 %")
    return datos, peso

