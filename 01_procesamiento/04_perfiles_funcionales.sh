#!/usr/bin/env bash
# Objetivo: obtener las familias génicas y las rutas MetaCyc de la comunidad.
# Entrada: lecturas tras el filtrado humano y perfil taxonómico vJun23.
# Salida: abundancia de familias génicas, abundancia de rutas y cobertura de rutas.
set -euo pipefail

MUESTRA="muestra_ejemplo"
LECTURAS="resultados/filtrado_humano"
TAXONOMIA="resultados/metaphlan"
ENTRADA="resultados/lecturas_combinadas"
SALIDA="resultados/humann"
mkdir -p "$ENTRADA" "$SALIDA"

# HUMAnN recibe las lecturas de ambos extremos en un único archivo.
cat "${LECTURAS}/${MUESTRA}_R1.fastq.gz" \
    "${LECTURAS}/${MUESTRA}_R2.fastq.gz" \
    > "${ENTRADA}/${MUESTRA}_combinada.fastq.gz"

# El entorno de HUMAnN debe tener configuradas ChocoPhlAn y UniRef90.
# Sus versiones y la función de cada salida se explican en el README.
humann \
  --input "${ENTRADA}/${MUESTRA}_combinada.fastq.gz" \
  --taxonomic-profile "${TAXONOMIA}/${MUESTRA}_perfil.tsv" \
  --output "${SALIDA}/${MUESTRA}" \
  --output-basename "$MUESTRA" \
  --threads 8
