#!/usr/bin/env bash

# Control de calidad de las lecturas pareadas con fastp
R1=datos/muestra_R1.fastq.gz
R2=datos/muestra_R2.fastq.gz

fastp --in1 $R1 --in2 $R2 \
  --out1 resultados/muestra_R1_filtrada.fastq.gz \
  --out2 resultados/muestra_R2_filtrada.fastq.gz \
  --html resultados/informe_fastp.html \
  --json resultados/informe_fastp.json --thread 16

