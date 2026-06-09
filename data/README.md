# Dataset

## Source
This project uses the NASA Kennedy Space Center web server HTTP access logs from the Internet Traffic Archive.

## Files
- NASA_access_log_Jul95
- NASA_access_log_Aug95

## Data Scale
The two raw log files contain two months of HTTP request logs. After decompression, the cumulative data size is over 100MB.

## Parsed Schema
| Column | Description |
|---|---|
| host | Client host or IP |
| timestamp_str | Original timestamp string |
| date | Parsed request date |
| hour | Parsed request hour |
| method | HTTP method |
| path | Requested URL path |
| protocol | HTTP protocol |
| status | HTTP status code |
| bytes | Response size in bytes |

## Note
Large raw data files are excluded from GitHub using `.gitignore`. A 1000-line sample file is included as `sample_nasa_log.txt`.
