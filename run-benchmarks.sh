#!/bin/bash

echo " Building projects..."
dotnet build DirectHttp/DirectHttp.Client/DirectHttp.Client.csproj -c Release
dotnet build DirectHttp/DirectHttp.Service/DirectHttp.Service.csproj -c Release
dotnet build Messaging/Messaging.Client/Messaging.Client.csproj -c Release
dotnet build Messaging/Messaging.Worker/Messaging.Worker.csproj -c Release

echo "Launching projects..."

rm -rf benchmarkResults
rm -rf logs

mkdir -p benchmarkResults
mkdir -p logs


dotnet run --project DirectHttp/DirectHttp.Client/DirectHttp.Client.csproj --urls=http://localhost:5179 > logs/direct.client.log 2>&1 &
DIRECT_CLIENT_PID=$!
dotnet run --project DirectHttp/DirectHttp.Service/DirectHttp.Service.csproj --urls=http://localhost:5175 > logs/direct.service.log 2>&1 &
DIRECT_SERVICE_PID=$!
dotnet run --project Messaging/Messaging.Client/Messaging.Client.csproj --urls=http://localhost:5026 > logs/messaging.client.log 2>&1 &
MESSAGING_CLIENT_PID=$!
dotnet run --project Messaging/Messaging.Worker/Messaging.Worker.csproj > logs/messaging.worker.log 2>&1 &
MESSAGING_WORKER_PID=$!

echo "Wait 5 seconds for services to start..."
sleep 5

echo "Launch script finished"

SCENARIOS=(
  baseline_http
  baseline_messaging
  highload_http
  highload_messaging
  largepayload_http
  largepayload_messaging
)

for SCENARIO in "${SCENARIOS[@]}"
do
  echo "Running scenario: $SCENARIO..."
  k6 run --env SCENARIO=$SCENARIO benchmark.js | tee tmp-colored.log
  sed 's/\x1b\[[0-9;]*m//g' tmp-colored.log > "benchmarkResults/${SCENARIO}.log"
done

rm tmp-colored.log
echo "All benchmarks complete."

echo "Stopping all services..."

[ -n "$DIRECT_CLIENT_PID" ] && kill $DIRECT_CLIENT_PID
[ -n "$DIRECT_SERVICE_PID" ] && kill $DIRECT_SERVICE_PID
[ -n "$MESSAGING_CLIENT_PID" ] && kill $MESSAGING_CLIENT_PID
[ -n "$MESSAGING_WORKER_PID" ] && kill $MESSAGING_WORKER_PID

echo "Summarizing"

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

echo "Done."
