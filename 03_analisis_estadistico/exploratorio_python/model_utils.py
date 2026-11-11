"""Utilidades del modelo predictivo con preparación confinada al entrenamiento."""

from __future__ import annotations

import math
from dataclasses import dataclass

import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import balanced_accuracy_score
from sklearn.model_selection import StratifiedKFold


@dataclass
class FoldTransformer:
    features: list[str]
    delta: float
    mean: np.ndarray
    scale: np.ndarray


def _replace_and_clr(values: np.ndarray, delta: float) -> np.ndarray:
    values = np.asarray(values, dtype=float)
    row_sums = values.sum(axis=1, keepdims=True)
    if (row_sums <= 0).any():
        raise ValueError("Una muestra queda sin masa tras el filtro")
    closed = values / row_sums
    output = closed.copy()
    for i, row in enumerate(closed):
        zeros = row == 0
        n_zeros = int(zeros.sum())
        if n_zeros:
            if delta * n_zeros >= 1:
                raise ValueError("Delta incompatible con el número de ceros")
            output[i, zeros] = delta
            output[i, ~zeros] = row[~zeros] * (1.0 - delta * n_zeros)
    logs = np.log(output)
    return logs - logs.mean(axis=1, keepdims=True)


def fit_transformer(frame: pd.DataFrame, prevalence: float = 0.20) -> tuple[FoldTransformer, np.ndarray]:
    minimum = max(1, math.ceil(prevalence * len(frame)))
    retained = list(frame.columns[(frame > 0).sum(axis=0) >= minimum])
    if not retained:
        raise ValueError("El filtro no retiene características")
    delta = 1.0 / len(retained) ** 2
    clr_train = _replace_and_clr(frame[retained].to_numpy(dtype=float), delta)
    mean = clr_train.mean(axis=0)
    scale = clr_train.std(axis=0, ddof=0)
    scale[scale == 0] = 1.0
    transformer = FoldTransformer(retained, delta, mean, scale)
    return transformer, (clr_train - mean) / scale


def apply_transformer(transformer: FoldTransformer, frame: pd.DataFrame) -> np.ndarray:
    clr_values = _replace_and_clr(
        frame[transformer.features].to_numpy(dtype=float), transformer.delta
    )
    return (clr_values - transformer.mean) / transformer.scale


def make_model(c_value: float, l1_ratio: float, seed: int) -> LogisticRegression:
    return LogisticRegression(
        solver="saga",
        C=c_value,
        l1_ratio=l1_ratio,
        class_weight="balanced",
        max_iter=5000,
        tol=1e-3,
        random_state=seed,
    )


def select_hyperparameters(
    frame: pd.DataFrame,
    labels: np.ndarray,
    c_grid: tuple[float, ...],
    l1_grid: tuple[float, ...],
    seed: int,
) -> tuple[float, float, float]:
    """CV interna estratificada; el score agrega todas las predicciones."""
    candidates: list[tuple[float, float, float]] = []
    n = len(frame)
    for c_value in c_grid:
        for l1_ratio in l1_grid:
            predictions = np.zeros(n, dtype=int)
            splitter = StratifiedKFold(n_splits=3, shuffle=True, random_state=seed)
            converged = True
            for fold, (train_idx, test_idx) in enumerate(splitter.split(frame, labels)):
                transformer, x_train = fit_transformer(frame.iloc[train_idx])
                x_test = apply_transformer(transformer, frame.iloc[test_idx])
                model = make_model(c_value, l1_ratio, seed + fold)
                model.fit(x_train, labels[train_idx])
                if int(model.n_iter_[0]) >= model.max_iter:
                    converged = False
                    break
                predictions[test_idx] = model.predict(x_test).astype(int)
            score = (
                float(balanced_accuracy_score(labels, predictions))
                if converged
                else float("-inf")
            )
            candidates.append((score, c_value, l1_ratio))
    # Mejor score; en empate, menor C (más regularización) y mayor l1_ratio.
    candidates.sort(key=lambda item: (-item[0], item[1], -item[2]))
    score, c_value, l1_ratio = candidates[0]
    if not np.isfinite(score):
        raise RuntimeError("Ninguna configuración interna convergió")
    return c_value, l1_ratio, score
