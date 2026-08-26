#!/usr/bin/env bash

MUESTRA="muestra_ejemplo"
LECTURAS="resultados/lecturas_sin_humano"
TAXONOMIA="resultados/perfiles_taxonomicos"
ENTRADA="resultados/lecturas_combinadas"
SALIDA="resultados/perfiles_funcionales"

mkdir -p "$ENTRADA" "$SALIDA"

# Antes del análisis funcional, se combinan las lecturas R1 y R2 que no se alinearon con GRCh38
cat "${LECTURAS}/${MUESTRA}_R1.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_R2.fastq.gz" \
    > "${ENTRADA}/${MUESTRA}_combinada.fastq.gz"

# HUMAnN identifica y cuantifica las familias génicas y las rutas MetaCyc representadas en la muestra
humann \
  --input "${ENTRADA}/${MUESTRA}_combinada.fastq.gz" \
  --taxonomic-profile "${TAXONOMIA}/${MUESTRA}_perfil_taxonomico.tsv" \
  --output "${SALIDA}/${MUESTRA}" \
  --threads 8
