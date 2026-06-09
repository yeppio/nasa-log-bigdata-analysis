# NASA Web Server Log Analysis Using Hadoop-Based Big Data Pipeline

## 1. Project Overview

This project analyzes NASA Kennedy Space Center web server logs to understand how web traffic changes over time and which resources are requested most often. Web server logs contain useful information about user access patterns, requested resources, response status codes, and transferred data size. By processing these logs with Hadoop-based big data tools, this project will identify traffic patterns and meaningful characteristics of web service usage.

The main goal of this project is to build a big data processing pipeline that collects NASA HTTP log data, stores it in HDFS, preprocesses it using Spark, analyzes it using Spark SQL and Hive, and visualizes the final results.

## 2. Problem Definition

Web server logs are generated continuously and can become very large over time. However, raw log files are difficult to analyze directly because each record is stored as semi-structured text. Therefore, log data needs to be collected, parsed, cleaned, and transformed into a structured format before analysis.

This project focuses on the following questions:

1. How does the number of web requests change by day?
2. Which time periods show the highest web traffic?
3. Which URLs or resources are requested most frequently?
4. What is the distribution of HTTP status codes?
5. Which requests generate the largest amount of response traffic?

To answer these questions, this project will use the NASA HTTP web server log dataset. The dataset contains HTTP request logs from the NASA Kennedy Space Center web server. The total data size is sufficient for building and testing a Hadoop-based big data processing pipeline.

## 3. Reason for Dataset Selection

## 3. Reason for Dataset Selection

I selected the NASA HTTP log dataset because it is large enough for a big data project and has a clear log format that can be parsed with Spark. Each record contains useful fields such as timestamp, requested resource, HTTP status code, and response byte size.

This makes the dataset suitable for practicing the full pipeline covered in class, including data collection, HDFS storage, Spark preprocessing, Hive/Spark SQL analysis, and visualization. Since the data can be downloaded from a public archive, the collection process can also be written as a reusable script.

## 4. Data Collection Plan

The data will be collected from the public NASA HTTP log archive. The collection process will be scripted using Bash or Python so that the raw log files can be downloaded again if needed.

The raw data includes the following fields:

- Host
- Timestamp
- HTTP request
- HTTP status code
- Reply bytes

The collected files will be stored as raw text files and then uploaded to HDFS. After that, Spark will be used to parse the raw log format and convert it into a structured dataset.

## 5. Technology Stack

| Stage | Tool / Technology | Purpose |
|---|---|---|
| Data Collection | Bash or Python | Download NASA HTTP log files |
| Storage | HDFS | Store raw and processed log data |
| Preprocessing | PySpark | Parse logs, handle missing values, extract date/time fields |
| Analysis | Spark SQL, HiveQL | Perform aggregation and traffic pattern analysis |
| Visualization | Python Matplotlib | Create charts for final results |
| Environment | GCP VM, HDP Sandbox | Run Hadoop-based tools in the lecture environment |
| Version Control | GitHub | Manage README, scripts, and project files |

## 6. Implementation Plan

The project will be implemented through the following pipeline:

1. Data Collection  
   - Download NASA HTTP log files using a Bash or Python script.
   - Save the downloaded files in a local raw data directory.
   - Make the collection process reusable.

2. HDFS Storage  
   - Create HDFS directories for raw and processed data.
   - Upload the raw log files to HDFS.

3. Data Preprocessing  
   - Load raw log files with PySpark.
   - Parse each log line into structured columns.
   - Extract date, hour, request URL, status code, and byte size.
   - Remove invalid or incomplete records.
   - Save the cleaned data as CSV or Parquet.

4. Data Analysis  
   - Use Spark SQL and HiveQL to answer the analysis questions.
   - Calculate daily request counts.
   - Analyze hourly traffic patterns.
   - Find the most frequently requested URLs.
   - Analyze HTTP status code distribution.
   - Calculate total response bytes by URL or time period.

5. Visualization and Result Summary  
   - Export aggregated results as CSV files.
   - Create charts using Python Matplotlib.
   - Summarize the main findings in the final report and presentation.

## 7. Expected Output

By the end of the project, I expect to produce:

- A script for downloading NASA log files
- Raw log files uploaded to HDFS
- A cleaned and structured log dataset
- Spark or Hive scripts for analysis
- CSV result files for each analysis question
- Simple charts showing traffic patterns
- A final report and presentation slides

## 8. Repository Structure

```text
nasa-log-bigdata-analysis/
├── README.md
├── data/
│   └── README.md
├── src/
│   ├── ingest/
│   ├── pipeline/
│   └── analyze/
├── results/
└── docs/
```

## 9. References

- Big Data Programming lecture materials
- NASA HTTP Web Server Log Dataset
- Apache Hadoop HDFS documentation
- Apache Spark documentation
- Apache Hive documentation


## 10. Implemented Results

The pipeline was implemented and executed in the HDP Sandbox environment. NASA HTTP log files were downloaded, decompressed, uploaded to HDFS, parsed with Spark, analyzed with Spark DataFrame operations, and exported as CSV result files.

Generated result files:
- results/hourly_requests.csv
- results/top_urls.csv
- results/status_codes.csv
- results/heavy_resources.csv

Generated visualization files:
- results/figures/hourly_requests.png
- results/figures/top_urls.png
- results/figures/status_codes.png
- results/figures/heavy_resources.png

## 11. Main Findings

1. Hourly traffic analysis showed differences in request volume by hour.
2. The most requested URLs were mainly static image resources such as NASA logo GIF files.
3. HTTP 200 responses accounted for most requests, while 404 errors also appeared.
4. Large shuttle mission video files generated the highest total byte traffic.

## 12. AI Tool Usage

ChatGPT was used for debugging command errors, organizing the README wording, and checking whether the project requirements were covered.

## 10. Implemented Results

The pipeline was implemented and executed in the HDP Sandbox environment. NASA HTTP log files were downloaded, decompressed, uploaded to HDFS, parsed with Spark, analyzed with Spark DataFrame operations, and exported as CSV result files.

Generated result files:
- results/hourly_requests.csv
- results/top_urls.csv
- results/status_codes.csv
- results/heavy_resources.csv

Generated visualization files:
- results/figures/hourly_requests.png
- results/figures/top_urls.png
- results/figures/status_codes.png
- results/figures/heavy_resources.png

## 11. Main Findings

1. Hourly traffic analysis showed differences in request volume by hour.
2. The most requested URLs were mainly static image resources such as NASA logo GIF files.
3. HTTP 200 responses accounted for most requests, while 404 errors also appeared.
4. Large shuttle mission video files generated the highest total byte traffic.

## 12. AI Tool Usage

ChatGPT was used for debugging command errors, organizing README wording, and checking project requirement coverage.
