#!/usr/bin/env bash

# Retirada de lecturas alineadas frente al genoma humano GRCh38
INDICE=referencias/GRCh38
R1=resultados/muestra_R1_filtrada.fastq.gz
R2=resultados/muestra_R2_filtrada.fastq.gz

bowtie2 --very-sensitive -x $INDICE -1 $R1 -2 $R2 \
  --un-conc-gz resultados/muestra_sin_humano_%.fastq.gz \
  --threads 16 -S /dev/null

