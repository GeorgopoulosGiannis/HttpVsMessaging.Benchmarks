# Messaging vs HTTP: A Benchmark in .NET Microservices

This project benchmarks and compares **direct HTTP request/response** with **message-based communication using MassTransit and RabbitMQ** in a microservices environment using .NET 8.

While messaging is typically recommended for commands and state-changing operations, this benchmark focuses on a common but overlooked case: **read-only queries**, such as `GET /orders`. The goal is to evaluate performance trade-offs and challenge the assumption that messaging is always "too heavy" for simple scenarios.

## What's Included

- Two communication approaches:
  - `DirectHttp`: Uses `HttpClient` between services
  - `Messaging`: Uses `MassTransit` over RabbitMQ for request/response
- Six benchmark scenarios:
  - `baseline_http`, `baseline_messaging`
  - `highload_http`, `highload_messaging`
  - `largepayload_http`, `largepayload_messaging`
- Benchmarks executed using [Grafana k6](https://k6.io/)
- Automated benchmarking scripts with output in Markdown and HTML reports

## Benchmark Summary

You can view the full Markdown summary here:  
📄 [benchmark-summary.md](./benchmark-summary.md)

## HTML Reports

| Scenario              | Report |
|----------------------|--------|
| Baseline HTTP         | [View](https://georgopoulosgiannis.github.io/HttpVsMessaging.Benchmarks/baseline_http-report.html) |
| Baseline Messaging    | [View](https://georgopoulosgiannis.github.io/HttpVsMessaging.Benchmarks/baseline_messaging-report.html) |
| High Load HTTP        | [View](https://georgopoulosgiannis.github.io/HttpVsMessaging.Benchmarks/highload_http-report.html) |
| High Load Messaging   | [View](https://georgopoulosgiannis.github.io/HttpVsMessaging.Benchmarks/highload_messaging-report.html) |
| Large Payload HTTP    | [View](https://georgopoulosgiannis.github.io/HttpVsMessaging.Benchmarks/largepayload_http-report.html) |
| Large Payload Messaging | [View](https://georgopoulosgiannis.github.io/HttpVsMessaging.Benchmarks/largepayload_messaging-report.html) |

## Benchmark Environment

All benchmarks were executed on a **MacBook Pro M1 Pro (2021)**

## How to Run Locally

```bash
./run-benchmarks.sh # Runs k6 benchmarks and generates summary
```

## Prerequisites 

* RabbitMQ running locally. Follow instructions [here](https://masstransit.io/quick-starts/rabbitmq#run-rabbitmq)
* [K6](https://k6.io/)
* [.NET 9](https://dotnet.microsoft.com/en-us/download/dotnet/9.0)
