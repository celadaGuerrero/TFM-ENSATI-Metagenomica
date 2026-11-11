#!/usr/bin/env bash
# Objetivo: comparar las lecturas con la referencia humana GRCh38.
# Entrada: lecturas R1 y R2 conservadas por fastp e índice de Bowtie2.
# Salida: pares conservados tras el filtrado y resumen del alineamiento.
set -euo pipefail

MUESTRA="muestra_ejemplo"
INDICE="referencias/GRCh38/GRCh38"
ENTRADA="resultados/control_calidad"
SALIDA="resultados/filtrado_humano"
mkdir -p "$SALIDA"

# --un-conc-gz conserva los pares que no encajan conjuntamente en la referencia
# con la orientación y la separación esperadas. Una lectura aislada sí puede encajar.
bowtie2 \
  --very-sensitive \
  -x "$INDICE" \
  -1 "${ENTRADA}/${MUESTRA}_R1_filtrada.fastq.gz" \
  -2 "${ENTRADA}/${MUESTRA}_R2_filtrada.fastq.gz" \
  --un-conc-gz "${SALIDA}/${MUESTRA}_R%.fastq.gz" \
  --threads 16 \
  -S /dev/null \
  2> "${SALIDA}/${MUESTRA}_bowtie2.log"

