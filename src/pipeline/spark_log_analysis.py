from __future__ import print_function

from pyspark.sql import SparkSession
from pyspark.sql.functions import regexp_extract
from pyspark.sql.functions import col
from pyspark.sql.functions import when
from pyspark.sql.functions import unix_timestamp
from pyspark.sql.functions import from_unixtime
from pyspark.sql.functions import to_date
from pyspark.sql.functions import hour
from pyspark.sql.functions import count
from pyspark.sql.functions import sum
from pyspark.sql.functions import avg

if __name__ == "__main__":
    spark = SparkSession.builder.appName("NASA Log Analysis").getOrCreate()

    # file read from HDFS
    df = spark.read.text("hdfs:///user/maria_dev/nasa/raw/NASA_access_log_*")

    # NASA access log parsing
    # example:
    # host - - [01/Jul/1995:00:00:01 -0400] "GET /path HTTP/1.0" 200 1234
    log_pattern = r'^(\S+) \S+ \S+ \[([^\]]+)\] "(\S+) ([^"]+) (\S+)" (\d{3}) (\S+)'

    parsed = df.select(
        regexp_extract("value", log_pattern, 1).alias("host"),
        regexp_extract("value", log_pattern, 2).alias("time"),
        regexp_extract("value", log_pattern, 3).alias("method"),
        regexp_extract("value", log_pattern, 4).alias("url"),
        regexp_extract("value", log_pattern, 5).alias("protocol"),
        regexp_extract("value", log_pattern, 6).alias("status"),
        regexp_extract("value", log_pattern, 7).alias("bytes")
    )

    parsed = parsed.filter(col("host") != "")

    parsed = parsed.withColumn("status", col("status").cast("int"))
    parsed = parsed.withColumn("bytes", when(col("bytes") == "-", 0).otherwise(col("bytes").cast("long")))
    parsed = parsed.withColumn("datetime", from_unixtime(unix_timestamp(col("time"), "dd/MMM/yyyy:HH:mm:ss Z")))
    parsed = parsed.withColumn("date", to_date(col("datetime")))
    parsed = parsed.withColumn("hour", hour(col("datetime")))

    print("===== Parsed Data Sample =====")
    parsed.show(10, False)

    print("===== Total Count =====")
    print(parsed.count())

    # save parsed data for Hive
    parsed.select("host", "time", "date", "hour", "method", "url", "protocol", "status", "bytes") \
        .write.mode("overwrite") \
        .option("sep", "\t") \
        .csv("hdfs:///user/maria_dev/nasa/processed/logs_tsv")

    # Analysis 1: hourly request count
    hourly = parsed.groupBy("hour").count().orderBy("hour")
    print("===== Analysis 1: Hourly Request Count =====")
    hourly.show(24, False)
    hourly.write.mode("overwrite").option("header", "true").csv("hdfs:///user/maria_dev/nasa/results/hourly_requests")

    # Analysis 2: top requested URLs
    top_url = parsed.groupBy("url").count().orderBy(col("count").desc())
    print("===== Analysis 2: Top Requested URLs =====")
    top_url.show(20, False)
    top_url.limit(20).write.mode("overwrite").option("header", "true").csv("hdfs:///user/maria_dev/nasa/results/top_urls")

    # Analysis 3: status code distribution
    status_count = parsed.groupBy("status").count().orderBy("status")
    print("===== Analysis 3: HTTP Status Code Distribution =====")
    status_count.show(20, False)
    status_count.write.mode("overwrite").option("header", "true").csv("hdfs:///user/maria_dev/nasa/results/status_codes")

    # Analysis 4: total bytes by URL
    bytes_url = parsed.groupBy("url").agg(
        count("*").alias("request_count"),
        sum("bytes").alias("total_bytes"),
        avg("bytes").alias("avg_bytes")
    ).orderBy(col("total_bytes").desc())

    print("===== Analysis 4: High Traffic Resources =====")
    bytes_url.show(20, False)
    bytes_url.limit(20).write.mode("overwrite").option("header", "true").csv("hdfs:///user/maria_dev/nasa/results/heavy_resources")

    spark.stop()
