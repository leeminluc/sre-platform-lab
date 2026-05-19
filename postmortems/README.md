# Postmortems

## Status: Placeholder (Future Milestone)

This directory will contain blameless postmortem documents for incidents.

## What Are Postmortems?

A postmortem is a written record of an incident: what happened, why it happened, how it was resolved, and what actions will prevent recurrence. Postmortems are a **blameless** learning tool.

> "Blameless postmortems are the cornerstone of a healthy incident response culture." — Google SRE Book

## Blameless Culture Principles

1. **No punishment** — The goal is learning, not finding a scapegoat
2. **System focus** — "How did the system allow this to happen?" not "Who made the mistake?"
3. **Action items** — Every postmortem must produce concrete improvements
4. **Transparency** — Postmortems are shared widely, not hidden

## Postmortem Template

```markdown
# [Incident Title]

**Date:** YYYY-MM-DD
**Duration:** X hours Y minutes
**Severity:** CRITICAL | HIGH | MEDIUM
**Impacted Service:** service name
**Author:** name

## Timeline
All times in UTC

- HH:MM - Alert triggered
- HH:MM - On-call engaged
- HH:MM - Root cause identified
- HH:MM - Mitigation applied
- HH:MM - Full resolution confirmed

## Impact
- X users affected
- Y% error rate increase
- Z minutes of downtime

## Root Cause
Detailed technical explanation of what went wrong.

## Trigger
What caused the root cause to manifest at this particular time?

## Resolution
Steps taken to resolve the incident.

## Action Items
| Action | Owner | Priority | Issue |
|--------|-------|----------|-------|
| Fix X  | @name | P1       | #123  |

## Lessons Learned
1. What went well
2. What went wrong
3. Where we got lucky

## Monitoring Gaps
What monitoring would have caught this earlier?
```

## Production Relevance

Postmortems in version control (not a wiki) because:
1. **Immutable audit trail** — Changes are tracked
2. **PR review** — Action items are reviewed and agreed upon
3. **Searchable** — Git history is searchable
4. **Accessible** — Available even when internal tools are down
