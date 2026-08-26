#!/usr/bin/env bash

# La muestra se representa mediante un nombre ficticio para preservar la confidencialidad de los datos
MUESTRA="muestra_ejemplo"
LECTURAS="datos"
TRABAJO="resultados/lecturas_unificadas"
SALIDA="resultados/control_calidad"

mkdir -p "$TRABAJO" "$SALIDA"

# Se agrupan los distintos archivos obtenidos para cada muestra, manteniendo separadas las lecturas R1 y R2
cat "${LECTURAS}/${MUESTRA}_L001_R1.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_L002_R1.fastq.gz" \
    > "${TRABAJO}/${MUESTRA}_R1.fastq.gz"

cat "${LECTURAS}/${MUESTRA}_L001_R2.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_L002_R2.fastq.gz" \
    > "${TRABAJO}/${MUESTRA}_R2.fastq.gz"

# fastp elimina los adaptadores y descarta las lecturas que no superan los umbrales de calidad
fastp \
  --in1 "${TRABAJO}/${MUESTRA}_R1.fastq.gz" \
  --in2 "${TRABAJO}/${MUESTRA}_R2.fastq.gz" \
  --out1 "${SALIDA}/${MUESTRA}_R1_filtrada.fastq.gz" \
  --out2 "${SALIDA}/${MUESTRA}_R2_filtrada.fastq.gz" \
  --html "${SALIDA}/${MUESTRA}_fastp.html" \
  --json "${SALIDA}/${MUESTRA}_fastp.json" \
  --thread 16
