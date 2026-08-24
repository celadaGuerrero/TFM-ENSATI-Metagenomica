#!/usr/bin/env bash

# Obtención del perfil funcional y de las rutas MetaCyc con HUMAnN
zcat resultados/muestra_sin_humano_1.fastq.gz \
  resultados/muestra_sin_humano_2.fastq.gz | gzip -c \
  > resultados/muestra_combinada.fastq.gz

humann --input resultados/muestra_combinada.fastq.gz \
  --taxonomic-profile resultados/muestra_perfil_taxonomico.tsv \
  --output resultados/humann --threads 8

