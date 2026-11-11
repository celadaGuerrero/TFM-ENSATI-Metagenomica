#!/usr/bin/env bash
# Objetivo: reunir los archivos de una muestra y limpiar las lecturas con fastp.
# Entrada: FASTQ comprimidos, separados en R1 y R2.
# Salida: lecturas filtradas e informes de calidad HTML y JSON.
set -euo pipefail

MUESTRA="muestra_ejemplo"
LECTURAS="datos"
TRABAJO="resultados/lecturas_unificadas"
SALIDA="resultados/control_calidad"
mkdir -p "$TRABAJO" "$SALIDA"

# Ejemplo con dos carriles. Ajustar esta lista a los archivos de cada muestra.
# Reunir siempre R1 por separado de R2 y en el mismo orden.
cat "${LECTURAS}/${MUESTRA}_L001_R1.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_L002_R1.fastq.gz" \
    > "${TRABAJO}/${MUESTRA}_R1.fastq.gz"
cat "${LECTURAS}/${MUESTRA}_L001_R2.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_L002_R2.fastq.gz" \
    > "${TRABAJO}/${MUESTRA}_R2.fastq.gz"

# Retirar adaptadores y filtrar por calidad, con los valores por defecto de fastp.
fastp \
  --in1 "${TRABAJO}/${MUESTRA}_R1.fastq.gz" \
  --in2 "${TRABAJO}/${MUESTRA}_R2.fastq.gz" \
  --out1 "${SALIDA}/${MUESTRA}_R1_filtrada.fastq.gz" \
  --out2 "${SALIDA}/${MUESTRA}_R2_filtrada.fastq.gz" \
  --html "${SALIDA}/${MUESTRA}_fastp.html" \
  --json "${SALIDA}/${MUESTRA}_fastp.json" \
  --thread 16

