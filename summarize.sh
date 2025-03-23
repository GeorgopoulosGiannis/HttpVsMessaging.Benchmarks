#!/bin/bash

output="benchmark-summary.md"

{
  echo "| Scenario              | Req/sec | P95 Latency | Failures | Report File               |"
  echo "|-----------------------|---------|-------------|----------|----------------------------|"
} > "$output"

for file in benchmarkResults/*.log; do
  scenario=$(grep -E '^\s+\* ' "$file" | awk '{print $2}')

  req_per_sec=$(grep "http_reqs" "$file" | tail -1 | awk '{print $NF}')

  p95_latency=$(awk '
    /http_req_duration/ {in_block=1; next}
    in_block && /p\(95\)=/ {
      for (i = 1; i <= NF; i++) {
        if ($i ~ /p\(95\)=/) {
          split($i, a, "=")
          print a[2]
          exit
        }
      }
    }
  ' "$file")

  failures=$(grep "http_req_failed" "$file" | awk '{
    for (i=1; i<=NF; i++) {
      if ($i == "✓") {
        print $(i+1)
        exit
      }
    }
  }')

  printf "| %-21s | %-7s | %-11s | %-8s | %-26s |\n" "$scenario" "$req_per_sec" "$p95_latency" "$failures" "$file" >> "$output"
done

echo "Summary written to $output"
