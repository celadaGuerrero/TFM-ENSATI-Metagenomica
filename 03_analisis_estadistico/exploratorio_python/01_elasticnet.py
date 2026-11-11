#!/usr/bin/env python3
"""Predice la respuesta de peso dejando fuera a un participante en cada evaluación."""

from __future__ import annotations

from pathlib import Path

import numpy as np
import pandas as pd

from model_utils import apply_transformer, fit_transformer, make_model, select_hyperparameters


# Rutas relativas al repositorio; las entradas son privadas.
BASE = Path(__file__).resolve().parents[2]
MATRIX = BASE / "datos/exploratorio/matriz_basal.tsv"
OUTCOME = BASE / "datos/exploratorio/respuesta_peso.tsv"
OUTPUT = BASE / "resultados/exploratorio"
PREDICTIONS = OUTPUT / "predicciones_elasticnet.tsv"
COEFFICIENTS = OUTPUT / "coeficientes_elasticnet.tsv"

C_GRID = (0.01, 0.1, 1.0, 10.0, 100.0)
L1_GRID = (0.0, 0.25, 0.5, 0.75, 1.0)
SEED = 20260730


def main() -> int:
    # Cada fila es un participante en V00. La matriz no se filtra previamente.
    from entradas import leer_entradas

    matrix, outcome = leer_entradas(MATRIX, OUTCOME)
    y = outcome["respondedor_5pct"].to_numpy(dtype=int)
    OUTPUT.mkdir(parents=True, exist_ok=True)

    prediction_rows: list[dict[str, object]] = []
    coefficient_rows: list[dict[str, object]] = []
    # Se evalúa un participante cada vez y se entrena con los datos de los demás participantes.
    for held_out in range(len(matrix)):
        train_idx = np.array([i for i in range(len(matrix)) if i != held_out])
        test_idx = np.array([held_out])
        train_frame = matrix.iloc[train_idx]
        y_train = y[train_idx]
        c_value, l1_ratio, inner_score = select_hyperparameters(
            train_frame, y_train, C_GRID, L1_GRID, SEED + 1000 * held_out
        )
        transformer, x_train = fit_transformer(train_frame)
        x_test = apply_transformer(transformer, matrix.iloc[test_idx])
        model = make_model(c_value, l1_ratio, SEED + held_out)
        model.fit(x_train, y_train)
        probability = float(model.predict_proba(x_test)[0, 1])
        predicted = int(probability >= 0.5)
        subject = str(matrix.index[held_out])
        prediction_rows.append(
            {
                "participante": subject,
                "observado": int(y[held_out]),
                "probabilidad_respondedor": probability,
                "prediccion_0_5": predicted,
                "correcto": int(predicted == y[held_out]),
                "C_seleccionado": c_value,
                "l1_ratio_seleccionado": l1_ratio,
                "balanced_accuracy_interna": inner_score,
                "features_retenidas": len(transformer.features),
            }
        )
        for feature, coefficient in zip(transformer.features, model.coef_[0], strict=True):
            if coefficient != 0:
                coefficient_rows.append(
                    {
                        "held_out_subject": subject,
                        "feature_id": feature,
                        "coefficient": float(coefficient),
                        "C": c_value,
                        "l1_ratio": l1_ratio,
                    }
                )

    predictions = pd.DataFrame(prediction_rows)
    predictions.to_csv(PREDICTIONS, sep="\t", index=False, float_format="%.12g")
    pd.DataFrame(coefficient_rows).to_csv(
        COEFFICIENTS, sep="\t", index=False, float_format="%.12g"
    )

    print(f"Tablas guardadas: {PREDICTIONS.name} y {COEFFICIENTS.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
