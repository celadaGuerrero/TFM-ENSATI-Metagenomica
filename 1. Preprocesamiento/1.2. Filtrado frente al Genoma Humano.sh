#!/usr/bin/env bash

# Las rutas son genéricas y deben definirse en un entorno autorizado
MUESTRA="muestra_ejemplo"
INDICE="referencias/GRCh38/GRCh38"
ENTRADA="resultados/control_calidad"
SALIDA="resultados/lecturas_sin_humano"

mkdir -p "$SALIDA"

# Se conservan únicamente los pares no alineados frente a GRCh38
bowtie2 \
  --very-sensitive \
  -x "$INDICE" \
  -1 "${ENTRADA}/${MUESTRA}_R1_filtrada.fastq.gz" \
  -2 "${ENTRADA}/${MUESTRA}_R2_filtrada.fastq.gz" \
  --un-conc-gz "${SALIDA}/${MUESTRA}_R%.fastq.gz" \
  --threads 16 \
  -S /dev/null \
  2> "${SALIDA}/${MUESTRA}_bowtie2.log"
