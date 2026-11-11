#!/usr/bin/env bash
# Objetivo: estimar la composición microbiana mediante genes marcadores.
# Entrada: lecturas tras el filtrado humano y base de MetaPhlAn vJun23.
# Salida: perfil de abundancias relativas y archivo del alineamiento.
set -euo pipefail

MUESTRA="muestra_ejemplo"
ENTRADA="resultados/filtrado_humano"
SALIDA="resultados/metaphlan"
BASE_DATOS="referencias/metaphlan"
INDICE="mpa_vJun23_CHOCOPhlAnSGB_202307"
mkdir -p "$SALIDA"

# La base vJun23 es la utilizada en este TFM y compatible con HUMAnN 3.9.
metaphlan \
  "${ENTRADA}/${MUESTRA}_R1.fastq.gz,${ENTRADA}/${MUESTRA}_R2.fastq.gz" \
  --input_type fastq \
  --nproc 8 \
  --db_dir "$BASE_DATOS" \
  --index "$INDICE" \
  --bowtie2out "${SALIDA}/${MUESTRA}_alineamiento.bz2" \
  --output_file "${SALIDA}/${MUESTRA}_perfil.tsv"

