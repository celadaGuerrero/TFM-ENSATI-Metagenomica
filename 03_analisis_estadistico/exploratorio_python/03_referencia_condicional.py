#!/usr/bin/env python3
"""Compara las asignaciones posibles de respuesta manteniendo fijas las predicciones."""

from __future__ import annotations

import itertools
import json
from pathlib import Path

import numpy as np
import pandas as pd
from sklearn.metrics import balanced_accuracy_score, roc_auc_score


BASE = Path(__file__).resolve().parents[2]
OUTPUT = BASE / "resultados/exploratorio"
PRED = OUTPUT / "predicciones_elasticnet.tsv"
SUMMARY = OUTPUT / "resumen_elasticnet.json"
OUT = OUTPUT / "referencia_condicional.json"


def main() -> int:
    frame = pd.read_csv(PRED, sep="\t")
    summary = json.loads(SUMMARY.read_text(encoding="utf-8"))
    y = frame["observado"].to_numpy(dtype=int)
    pred = frame["prediccion_0_5"].to_numpy(dtype=int)
    prob = frame["probabilidad_respondedor"].to_numpy(dtype=float)
    observed_ba = float(balanced_accuracy_score(y, pred))
    observed_auc = float(roc_auc_score(y, prob))

    ba_null: list[float] = []
    auc_null: list[float] = []
    for positive_indices in itertools.combinations(range(len(y)), int(y.sum())):
        permuted = np.zeros(len(y), dtype=int)
        permuted[list(positive_indices)] = 1
        ba_null.append(float(balanced_accuracy_score(permuted, pred)))
        auc_null.append(float(roc_auc_score(permuted, prob)))

    checks = {
        "15_predictions": len(frame) == 15,
        "8_responders": int(y.sum()) == 8,
        "balanced_accuracy_reproduced": np.isclose(
            observed_ba, summary["metrics"]["balanced_accuracy"]
        ),
        "roc_auc_reproduced": np.isclose(observed_auc, summary["metrics"]["roc_auc"]),
        "6435_exact_assignments": len(ba_null) == 6435,
        "no_missing_probabilities": np.isfinite(prob).all(),
    }
    checks = {name: bool(value) for name, value in checks.items()}
    payload = {
        "status": "PASS" if all(checks.values()) else "FAIL",
        "checks": checks,
        "observed": {"balanced_accuracy": observed_ba, "roc_auc": observed_auc},
        "conditional_exact_reference": {
            "assignments": len(ba_null),
            "class_count_fixed": "8/15",
            "balanced_accuracy_mean": float(np.mean(ba_null)),
            "roc_auc_mean": float(np.mean(auc_null)),
            "p_upper_balanced_accuracy": float(np.mean(np.array(ba_null) >= observed_ba)),
            "p_upper_roc_auc": float(np.mean(np.array(auc_null) >= observed_auc)),
        },
        "interpretation": (
            "Referencia descriptiva condicionada a las predicciones OOF ya "
            "obtenidas. No equivale a permutar etiquetas y reentrenar todo el "
            "pipeline; no se presenta como prueba inferencial formal."
        ),
        "full_pipeline_permutation_executed": False,
    }
    OUT.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(payload, indent=2, ensure_ascii=False))
    return 0 if payload["status"] == "PASS" else 1


if __name__ == "__main__":
    raise SystemExit(main())

