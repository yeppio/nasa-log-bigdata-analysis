from __future__ import print_function

import csv
import os
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

base = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
res = os.path.join(base, "results")
fig = os.path.join(res, "figures")

if not os.path.exists(fig):
    os.makedirs(fig)

def read_csv(name):
    path = os.path.join(res, name)
    with open(path, "r") as f:
        return list(csv.DictReader(f))

# 1. Hourly request count
hourly = read_csv("hourly_requests.csv")
hourly = [r for r in hourly if r.get("hour") not in [None, ""]]

hours = [int(r["hour"]) for r in hourly]
counts = [int(r["count"]) for r in hourly]

plt.figure(figsize=(10, 5))
plt.plot(hours, counts, marker="o")
plt.xlabel("Hour")
plt.ylabel("Request Count")
plt.title("Hourly Request Count")
plt.xticks(range(0, 24))
plt.tight_layout()
plt.savefig(os.path.join(fig, "hourly_requests.png"))
plt.close()

# 2. Status code distribution
status = read_csv("status_codes.csv")
status = [r for r in status if r.get("status") not in [None, ""]]

codes = [r["status"] for r in status]
status_counts = [int(r["count"]) for r in status]

plt.figure(figsize=(8, 5))
plt.bar(codes, status_counts)
plt.xlabel("HTTP Status Code")
plt.ylabel("Request Count")
plt.title("HTTP Status Code Distribution")
plt.tight_layout()
plt.savefig(os.path.join(fig, "status_codes.png"))
plt.close()

# 3. Top 10 requested URLs
top_urls = read_csv("top_urls.csv")[:10]
urls = [r["url"][:45] for r in top_urls]
url_counts = [int(r["count"]) for r in top_urls]

plt.figure(figsize=(12, 6))
plt.barh(urls[::-1], url_counts[::-1])
plt.xlabel("Request Count")
plt.ylabel("URL")
plt.title("Top 10 Requested URLs")
plt.tight_layout()
plt.savefig(os.path.join(fig, "top_urls.png"))
plt.close()

# 4. Heavy resources
heavy = read_csv("heavy_resources.csv")[:10]
heavy_urls = [r["url"][:45] for r in heavy]
bytes_values = [int(r["total_bytes"]) for r in heavy]

plt.figure(figsize=(12, 6))
plt.barh(heavy_urls[::-1], bytes_values[::-1])
plt.xlabel("Total Bytes")
plt.ylabel("URL")
plt.title("Top 10 Resources by Total Bytes")
plt.tight_layout()
plt.savefig(os.path.join(fig, "heavy_resources.png"))
plt.close()

print("Figures saved to results/figures")
