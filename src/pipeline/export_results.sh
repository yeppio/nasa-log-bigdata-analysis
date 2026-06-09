#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
LOCAL_RESULTS="$BASE_DIR/results"

mkdir -p "$LOCAL_RESULTS"

echo "[1/4] Export hourly_requests"
hdfs dfs -getmerge /user/maria_dev/nasa/results/hourly_requests "$LOCAL_RESULTS/hourly_requests.csv"

echo "[2/4] Export top_urls"
hdfs dfs -getmerge /user/maria_dev/nasa/results/top_urls "$LOCAL_RESULTS/top_urls.csv"

echo "[3/4] Export status_codes"
hdfs dfs -getmerge /user/maria_dev/nasa/results/status_codes "$LOCAL_RESULTS/status_codes.csv"

echo "[4/4] Export heavy_resources"
hdfs dfs -getmerge /user/maria_dev/nasa/results/heavy_resources "$LOCAL_RESULTS/heavy_resources.csv"

echo "Done."
ls -lh "$LOCAL_RESULTS"
