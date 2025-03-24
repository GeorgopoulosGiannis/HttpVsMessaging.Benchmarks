#!/bin/bash

echo "Clean up previous results..."

rm -rf benchmarkResults
rm -rf logs

mkdir -p benchmarkResults
mkdir -p logs

echo "Run docker compose.."

docker compose build
docker compose up -d


SCENARIOS=(
  baseline_http
  baseline_messaging
  highload_http
  highload_messaging
)

for SCENARIO in "${SCENARIOS[@]}"
do
  echo "Running scenario: $SCENARIO..."
  k6 run --env SCENARIO=$SCENARIO benchmark.js | tee tmp-colored.log
  sed 's/\x1b\[[0-9;]*m//g' tmp-colored.log > "benchmarkResults/${SCENARIO}.log"
done

rm tmp-colored.log
echo "All benchmarks complete."

echo "Stopping services..."

docker compose down

echo "Summarizing"

output="benchmark-summary.md"

{
  echo "| Scenario              | Req/sec | P95 Latency | Failures | Report File               |"
  echo "|-----------------------|---------|-------------|----------|----------------------------|"
} > "$output"

for file in benchmarkResults/*.log; do
  scenario=$(grep -E '^\s+\* ' "$file" | awk '{print $2}')

  # Extract Requests/sec
  req_per_sec=$(awk '/http_reqs/ && /\/s/ {
    for(i=1;i<=NF;i++) {
      if ($i ~ /\/s$/) {
        gsub("/s", "", $i);
        print $i;
        break;
      }
    }
  }' "$file")

  # Extract P95 latency from http_req_duration
  p95_latency=$(awk '
    /http_req_duration/ {in_block=1; next}
    in_block && /p\(95\)/ {
      for (i=1; i<=NF; i++) {
        if ($i ~ /p\(95\)=/) {
          split($i, a, "=");
          print a[2];
          exit;
        }
      }
    }
  ' "$file")

  # Extract failure count (not percentage)
  failures=$(awk '
    /http_req_failed/ {
      for (i = 1; i <= NF; i++) {
        if ($i == "✓") {
          print $(i + 1)
          exit
        }
      }
    }
  ' "$file")

  printf "| %-21s | %-7s | %-11s | %-8s | %-26s |\n" \
    "$scenario" "$req_per_sec" "$p95_latency" "$failures" "$file" >> "$output"
done

echo "Done."
