USE nasa_logs;

SELECT status, COUNT(*) AS request_count
FROM nasa_parsed
GROUP BY status
ORDER BY status;

SELECT url, COUNT(*) AS request_count
FROM nasa_parsed
GROUP BY url
ORDER BY request_count DESC
LIMIT 20;

SELECT url, COUNT(*) AS request_count, SUM(bytes) AS total_bytes, AVG(bytes) AS avg_bytes
FROM nasa_parsed
GROUP BY url
ORDER BY total_bytes DESC
LIMIT 20;
