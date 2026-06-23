---
tags:
  - index
title: Operations
---

# Operations

Recurring operational work and operational reference: monitoring runbooks and the
reports they produce, recurring process checklists, snapshots of live assets, and
one-off operational audits. The *doing*, not the *thinking* (which lives in
`knowledge/`). Distinct from `log/` because these are operations and
measurements, not human decisions — and from `knowledge/` because they change
when the *operation* changes, not when our *understanding* does.

Most files use the Knowledge schema (`tags: [knowledge]`) — runbooks, checklists,
audits, live-asset snapshots. **Reports** use the Report schema (`tags: [report]`)
and live in a per-topic subfolder, `<topic>-reports/`, one file per run with its
own reverse-chronological index. Reports are produced by a **user-supplied tool**
(a script you point at the runbook's data source); the OS ships the report schema
and folder convention, not the tool.

One flat `.md` file per runbook, checklist, snapshot, or audit; list each here as
it is added.
