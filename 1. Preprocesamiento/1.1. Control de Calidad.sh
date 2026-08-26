#!/usr/bin/env bash

# Identificador genérico que no corresponde a una muestra real
MUESTRA="muestra_ejemplo"
LECTURAS="datos"
TRABAJO="resultados/lecturas_unificadas"
SALIDA="resultados/control_calidad"

mkdir -p "$TRABAJO" "$SALIDA"

# Se unifican los carriles técnicos para conservar la profundidad completa
cat "${LECTURAS}/${MUESTRA}_L001_R1.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_L002_R1.fastq.gz" \
    > "${TRABAJO}/${MUESTRA}_R1.fastq.gz"

cat "${LECTURAS}/${MUESTRA}_L001_R2.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_L002_R2.fastq.gz" \
    > "${TRABAJO}/${MUESTRA}_R2.fastq.gz"

# Se filtran adaptadores y lecturas de baja calidad
fastp \
  --in1 "${TRABAJO}/${MUESTRA}_R1.fastq.gz" \
  --in2 "${TRABAJO}/${MUESTRA}_R2.fastq.gz" \
  --out1 "${SALIDA}/${MUESTRA}_R1_filtrada.fastq.gz" \
  --out2 "${SALIDA}/${MUESTRA}_R2_filtrada.fastq.gz" \
  --html "${SALIDA}/${MUESTRA}_fastp.html" \
  --json "${SALIDA}/${MUESTRA}_fastp.json" \
  --thread 16
