#!/usr/bin/env python3
"""Agrupa los perfiles basales en dos, tres o cuatro grupos mediante medoides."""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path

import numpy as np
import pandas as pd
from scipy.spatial.distance import cdist
from sklearn.metrics import adjusted_rand_score, silhouette_score

from model_utils import _replace_and_clr


BASE = Path(__file__).resolve().parents[2]
MATRIX = BASE / "datos/exploratorio/matriz_basal.tsv"
OUTCOME = BASE / "datos/exploratorio/respuesta_peso.tsv"
OUTPUT = BASE / "resultados/exploratorio"
ASSIGN = OUTPUT / "grupos_medoides.tsv"
EVAL = OUTPUT / "comparacion_k.tsv"
SUMMARY = OUTPUT / "resumen_medoides.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def exact_kmedoids(distance: np.ndarray, k: int) -> tuple[np.ndarray, tuple[int, ...], float]:
    best: tuple[float, tuple[int, ...], np.ndarray] | None = None
    for medoids in itertools.combinations(range(len(distance)), k):
        distances = distance[:, medoids]
        labels = np.argmin(distances, axis=1)
        cost = float(np.min(distances, axis=1).sum())
        candidate = (cost, medoids, labels)
        if best is None or (cost, medoids) < (best[0], best[1]):
            best = candidate
    assert best is not None
    return best[2], best[1], best[0]


def main() -> int:
    from entradas import leer_entradas

    raw, outcome = leer_entradas(MATRIX, OUTCOME)
    OUTPUT.mkdir(parents=True, exist_ok=True)
    # Aquí el filtro es descriptivo: presencia en al menos tres participantes.
    retained = raw.columns[(raw > 0).sum(axis=0) >= 3]
    values = raw[retained].to_numpy(dtype=float)
    clr = _replace_and_clr(values, 1.0 / len(retained) ** 2)
    distance = cdist(clr, clr, metric="euclidean")

    evaluation_rows: list[dict[str, object]] = []
    solutions: dict[int, tuple[np.ndarray, tuple[int, ...], float]] = {}
    for k in (2, 3, 4):
        labels, medoids, cost = exact_kmedoids(distance, k)
        solutions[k] = (labels, medoids, cost)
        silhouette = float(silhouette_score(distance, labels, metric="precomputed"))
        loo_ari: list[float] = []
        for held_out in range(len(raw)):
            keep = np.array([i for i in range(len(raw)) if i != held_out])
            loo_labels, _, _ = exact_kmedoids(distance[np.ix_(keep, keep)], k)
            loo_ari.append(float(adjusted_rand_score(labels[keep], loo_labels)))
        evaluation_rows.append(
            {
                "k": k,
                "silhouette_mean": silhouette,
                "ARI_LOO_mean": float(np.mean(loo_ari)),
                "ARI_LOO_min": float(np.min(loo_ari)),
                "total_dissimilarity": cost,
                "medoid_subjects": ";".join(str(raw.index[i]) for i in medoids),
            }
        )

    evaluation = pd.DataFrame(evaluation_rows).sort_values(
        ["silhouette_mean", "ARI_LOO_mean", "k"],
        ascending=[False, False, True],
    )
    selected_k = int(evaluation.iloc[0]["k"])
    labels, medoids, _ = solutions[selected_k]

    # La respuesta de peso se usa para describir los grupos después de elegir cuántos hay.
    assignments = pd.DataFrame(
        {
            "participante": raw.index,
            "cluster": labels + 1,
            "es_medoid": [int(i in medoids) for i in range(len(raw))],
            "respondedor_5pct": outcome["respondedor_5pct"].to_numpy(dtype=int),
            "perdida_peso_pct": outcome["perdida_peso_pct"].to_numpy(dtype=float),
        }
    )
    assignments.to_csv(ASSIGN, sep="\t", index=False, float_format="%.12g")
    evaluation.sort_values("k").to_csv(EVAL, sep="\t", index=False, float_format="%.12g")

    cluster_summary = {}
    for cluster, group in assignments.groupby("cluster"):
        cluster_summary[str(cluster)] = {
            "n": int(len(group)),
            "responders": int(group["respondedor_5pct"].sum()),
            "responder_percent": float(100 * group["respondedor_5pct"].mean()),
            "median_weight_loss_percent": float(group["perdida_peso_pct"].median()),
        }
    payload = {
        "status": "PAM_COMPLETE",
        "features": int(len(retained)),
        "selected_k": selected_k,
        "selection_used_outcome": False,
        "selected_silhouette": float(
            evaluation.loc[evaluation["k"] == selected_k, "silhouette_mean"].iloc[0]
        ),
        "selected_ARI_LOO_mean": float(
            evaluation.loc[evaluation["k"] == selected_k, "ARI_LOO_mean"].iloc[0]
        ),
        "clusters": cluster_summary,
        "interpretation": "Exploratorio descriptivo; no denominar enterotipos.",
        "output_hashes": {ASSIGN.name: sha256(ASSIGN), EVAL.name: sha256(EVAL)},
    }
    SUMMARY.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(payload, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

