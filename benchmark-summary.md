| Scenario              | Req/sec | P95 Latency | Failures | Report File               |
|-----------------------|---------|-------------|----------|----------------------------|
| baseline_http:        | 48.356566/s | 513.81ms    | 0        | benchmarkResults/baseline_http.log |
| baseline_messaging:   | 25.95704/s | 1.53s       | 0        | benchmarkResults/baseline_messaging.log |
| highload_http:        | 989.55686/s | 573.38ms    | 25198    | benchmarkResults/highload_http.log |
| highload_messaging:   | 30.562355/s | 6.4s        | 0        | benchmarkResults/highload_messaging.log |
