#!/bin/bash
set -e

echo "===== Step 1. Download NASA logs ====="
bash src/ingest/download_nasa_logs.sh

echo "===== Step 2. Upload logs to HDFS ====="
bash src/pipeline/upload_to_hdfs.sh

echo "===== Step 3. Run Spark analysis ====="
spark-submit src/pipeline/spark_log_analysis.py

echo "===== Step 4. Create Hive table ====="
hive -f src/hive/create_nasa_table.hql

echo "===== Step 5. Run Hive queries ====="
hive -f src/hive/analysis_queries.hql > results/hive_query_output.txt

echo "===== Step 6. Export Spark results ====="
bash src/pipeline/export_results.sh

echo "===== Done ====="
