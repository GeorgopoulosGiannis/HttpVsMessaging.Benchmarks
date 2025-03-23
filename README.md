# HttpVsMessaging.Benchmarks


| Scenario              | Req/sec | P95 Latency | Failures | Report File               |
|-----------------------|---------|-------------|----------|----------------------------|
| baseline_http:        | 25399.483814/s | 1.68ms      | 0        | benchmarkResults/baseline_http.log |
| baseline_messaging:   | 5568.257095/s | 6.49ms      | 0        | benchmarkResults/baseline_messaging.log |
| highload_http:        | 33433.618402/s | 10.65ms     | 84       | benchmarkResults/highload_http.log |
| highload_messaging:   | 4923.786875/s | 87.4ms      | 58       | benchmarkResults/highload_messaging.log |
| largepayload_http:    | 8965.579062/s | 4.3ms       | 0        | benchmarkResults/largepayload_http.log |
| largepayload_messaging: | 4317.432224/s | 9.07ms      | 0        | benchmarkResults/largepayload_messaging.log |
