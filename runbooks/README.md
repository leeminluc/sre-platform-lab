# Operational Runbooks

## Status: Placeholder (Future Milestone)

This directory will contain step-by-step operational runbooks for common incidents and procedures.

## What Are Runbooks?

Runbooks are documented procedures that enable **any on-call engineer** to respond to an incident, regardless of their familiarity with the system. They are a cornerstone of SRE practice.

> "Hope is not a strategy." — Traditional SRE saying

Without runbooks:
- Incidents take longer to resolve (MTTR increases)
- Only specific individuals can respond (bus factor = 1)
- Mistakes are repeated across incidents
- New team members are helpless during on-call

## Planned Runbooks

| Runbook | Severity | Description |
|---------|----------|-------------|
| `pod-crashloop.md` | Critical | Pod is repeatedly crashing and restarting |
| `high-cpu-throttling.md` | High | Container CPU is being throttled |
| `pod-pending.md` | High | Pod stuck in Pending state (scheduling failure) |
| `disk-pressure.md` | High | Node has disk pressure, pods being evicted |
| `flux-reconciliation-failure.md` | Medium | FluxCD failed to reconcile cluster state |
| `certificate-expiry.md` | Medium | TLS certificate approaching expiration |
| `node-not-ready.md` | Critical | Kubernetes node is NotReady |

## Runbook Template

Each runbook should follow this structure:

```markdown
# [Alert Name]

## Severity: CRITICAL | HIGH | MEDIUM | LOW

## Summary
One-paragraph description of what's happening.

## Impact
What user-facing impact does this have?

## Investigation Steps
1. Check ...
2. Verify ...
3. Look at ...

## Mitigation Steps
1. ...
2. ...

## Resolution Steps
1. ...
2. ...

## Post-Incident
- [ ] Update alert threshold if noisy
- [ ] Create postmortem if user-facing
- [ ] Add monitoring gap if detection was late
```

## Production Relevance

Runbooks in version control (not a wiki) are the production standard because:
1. **Versioned** — You can see who changed what and when
2. **Reviewed** — Changes go through PR review
3. **Accessible** — Available even when your wiki is down
4. **Testable** — Can be validated during game days
