#!/usr/bin/env bash

MUESTRA="muestra_ejemplo"
ENTRADA="resultados/lecturas_sin_humano"
SALIDA="resultados/perfiles_taxonomicos"
BASE_DATOS="referencias/metaphlan"
INDICE="mpa_vJun23_CHOCOPhlAnSGB_202307"

mkdir -p "$SALIDA"

# MetaPhlAn estima la abundancia relativa mediante marcadores específicos
metaphlan \
  "${ENTRADA}/${MUESTRA}_R1.fastq.gz,${ENTRADA}/${MUESTRA}_R2.fastq.gz" \
  --input_type fastq \
  --nproc 8 \
  --db_dir "$BASE_DATOS" \
  --index "$INDICE" \
  --bowtie2out "${SALIDA}/${MUESTRA}_alineamiento.bz2" \
  --output_file "${SALIDA}/${MUESTRA}_perfil_taxonomico.tsv"
