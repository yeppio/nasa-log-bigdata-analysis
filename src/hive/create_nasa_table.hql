CREATE DATABASE IF NOT EXISTS nasa_logs;
USE nasa_logs;

DROP TABLE IF EXISTS nasa_raw;
DROP TABLE IF EXISTS nasa_parsed;

CREATE EXTERNAL TABLE nasa_raw (
    line STRING
)
STORED AS TEXTFILE
LOCATION '/user/maria_dev/nasa/raw';

CREATE TABLE nasa_parsed (
    host STRING,
    time STRING,
    method STRING,
    url STRING,
    protocol STRING,
    status INT,
    bytes BIGINT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

INSERT OVERWRITE TABLE nasa_parsed
SELECT
    regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 1) AS host,
    regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 2) AS time,
    regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 3) AS method,
    regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 4) AS url,
    regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 5) AS protocol,
    CAST(regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 6) AS INT) AS status,
    CAST(
        CASE
            WHEN regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 7) = '-' THEN '0'
            ELSE regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 7)
        END AS BIGINT
    ) AS bytes
FROM nasa_raw
WHERE regexp_extract(line, '^(\\S+) \\S+ \\S+ \\[([^\\]]+)\\] "(\\S+) ([^"]+) (\\S+)" (\\d{3}) (\\S+)', 1) != '';

SELECT * FROM nasa_parsed LIMIT 10;
