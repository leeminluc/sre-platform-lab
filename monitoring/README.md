# Monitoring

## Status: Placeholder (Future Milestone)

This directory will contain the full observability stack configuration.

## Planned Stack

| Component       | Tool          | Purpose                              |
|----------------|---------------|--------------------------------------|
| Metrics         | Prometheus    | Time-series metrics collection       |
| Visualization   | Grafana       | Dashboards and alerting UI           |
| Alerting        | Alertmanager  | Alert routing, grouping, silencing   |
| Exporters       | node-exporter, kube-state-metrics | Infrastructure metrics |

## Planned Structure

```
monitoring/
├── namespace.yaml
├── prometheus/
│   ├── values.yaml
│   └── rules/           # Alerting rules
├── grafana/
│   ├── values.yaml
│   └── dashboards/      # JSON dashboard definitions
└── alerts/
    ├── platform.yaml    # Platform-level alerts
    └── apps.yaml        # Application-level alerts
```

## Production Relevance

Monitoring is not optional in production. The SRE principle is:

> "If you can't measure it, you can't improve it." — Google SRE Book

The observability stack enables:
1. **SLI/SLO tracking** — Are we meeting our reliability targets?
2. **Incident detection** — Know about problems before users report them
3. **Capacity planning** — Predict when you'll need more resources
4. **Performance optimization** — Identify bottlenecks with data, not guesses
