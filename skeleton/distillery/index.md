---
tags:
  - index
title: Distillery
---

# Distillery

The content pipeline. Compiles company `knowledge/` (context) and `library/`
signals (raw material) into publishable content across channels. It is an
output layer — it has no intake of its own; both inputs already live elsewhere
in the vault.

```
knowledge/  (company context) ─┐
                               ├─▶ distillery/  ──▶ review ──▶ publish
library/    (raw signals) ─────┘    channels/  (voice, format, ring per channel)
                                    content/   (drafts → published, per channel)
                                    plan.md    (cadence tracking)
```

- `channels/` — one file per channel (`tags: [channel]`), defining voice, format,
  audience, tactical rules, and the review panel. Each declares a `channel_id`.
- `content/<channel_id>/` — one file per draft or published piece
  (`tags: [content]`), filename `YYYY-MM-DD-slug.md`. Metadata and analytics in
  frontmatter; full post text in the body.
- `plan.md` — singleton, tracks cadence per channel and pillar coverage.

This module is Bases-indexed: the `content-calendar.base` embedded below renders
a live calendar over every `content`-tagged piece, so the per-channel content
subfolders stay discoverable without a hand-maintained index. See the Channel and
Content schemas in the OS spec (the hq plugin's `docs/vault-design.md`).

![[content-calendar.base]]
