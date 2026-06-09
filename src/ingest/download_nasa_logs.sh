#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
RAW_DIR="$BASE_DIR/data/raw"

mkdir -p "$RAW_DIR"
cd "$RAW_DIR"

echo "[1/4] Download NASA HTTP log files"
wget -c https://ita.ee.lbl.gov/traces/NASA_access_log_Jul95.gz
wget -c https://ita.ee.lbl.gov/traces/NASA_access_log_Aug95.gz

echo "[2/4] Decompress files"
gzip -dc NASA_access_log_Jul95.gz > NASA_access_log_Jul95
gzip -dc NASA_access_log_Aug95.gz > NASA_access_log_Aug95

echo "[3/4] Check total data size"
du -sh NASA_access_log_Jul95 NASA_access_log_Aug95
du -sh .

echo "[4/4] Create GitHub sample file"
head -n 1000 NASA_access_log_Jul95 > "$BASE_DIR/data/sample_nasa_log.txt"

echo "Done."
