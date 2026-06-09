#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
RAW_DIR="$BASE_DIR/data/raw"
HDFS_RAW="/user/maria_dev/nasa/raw"

echo "[1/3] Create HDFS raw directory"
hdfs dfs -mkdir -p "$HDFS_RAW"

echo "[2/3] Upload raw NASA logs to HDFS"
hdfs dfs -put -f "$RAW_DIR/NASA_access_log_Jul95" "$HDFS_RAW/"
hdfs dfs -put -f "$RAW_DIR/NASA_access_log_Aug95" "$HDFS_RAW/"

echo "[3/3] Check uploaded files"
hdfs dfs -ls "$HDFS_RAW"
hdfs dfs -du -h "$HDFS_RAW"

echo "Done: raw logs uploaded to HDFS."
