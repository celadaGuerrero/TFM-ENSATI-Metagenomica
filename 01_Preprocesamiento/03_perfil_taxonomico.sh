#!/usr/bin/env bash

# Obtención del perfil taxonómico con MetaPhlAn
R1=resultados/muestra_sin_humano_1.fastq.gz
R2=resultados/muestra_sin_humano_2.fastq.gz

metaphlan $R1,$R2 --input_type fastq --nproc 8 \
  --bowtie2out resultados/muestra_metaphlan.bz2 \
  --output_file resultados/muestra_perfil_taxonomico.tsv

