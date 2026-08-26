#!/usr/bin/env bash

MUESTRA="muestra_ejemplo"
LECTURAS="resultados/lecturas_sin_humano"
TAXONOMIA="resultados/perfiles_taxonomicos"
ENTRADA="resultados/lecturas_combinadas"
SALIDA="resultados/perfiles_funcionales"

mkdir -p "$ENTRADA" "$SALIDA"

# HUMAnN utiliza un único archivo con las lecturas no humanas de ambos pares
cat "${LECTURAS}/${MUESTRA}_R1.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_R2.fastq.gz" \
    > "${ENTRADA}/${MUESTRA}_combinada.fastq.gz"

# Se obtienen familias génicas y rutas MetaCyc
humann \
  --input "${ENTRADA}/${MUESTRA}_combinada.fastq.gz" \
  --taxonomic-profile "${TAXONOMIA}/${MUESTRA}_perfil_taxonomico.tsv" \
  --output "${SALIDA}/${MUESTRA}" \
  --threads 8
