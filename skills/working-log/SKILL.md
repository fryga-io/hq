---
name: working-log
description: "Use when capturing something into an hq vault's log/ — recording a decision, meeting, review, or observation as a dated entry; choosing whether an event belongs in the log versus a knowledge/initiative rewrite; or signing and indexing an existing log entry. Use whenever you touch log/ to capture a point-in-time record."
---

# Working the log

The **log** is the core hq module that holds **point-in-time records** — decisions, meetings, reviews, and observations, one file per entry at `log/YYYY-MM-DD-<slug>.md`. It is the vault's event stream: what was decided or observed *on a given day*, kept exactly as recorded. This skill is the faculty for *operating* the log — picking what gets logged, shaping an entry by its type, and keeping entries immutable as reality moves on.

It does **not** restate the always-on vault discipline (index hygiene, editing-scope, wikilink resolution — all **per using-hq**) or the frontmatter schema (**see the spec** → *Log Entry*). Copy the per-type frontmatter block from the spec; everything below is the log-specific operating layer on top.

## The defining invariant: a log entry is immutable

Every other vault file describes what is true *now* and is rewritten in place when reality changes (**per using-hq** → *Current state with rationale*). The log is the **exception**: an entry records a moment, and that moment does not change. When reality moves on, you **write a new entry** — you never rewrite an old one.

A superseded decision stays in the log, unedited, with a forward note like `(superseded YYYY-MM-DD by [[new-entry]])` added to its index line. The old entry keeps saying what was true that day; the new entry says what is true now.

## What belongs in the log vs. a rewrite

This is the discrimination the log faculty exists to make. The two are **not exclusive — a single change often does both**:

- **An event** — a choice made, a meeting held, a thing observed on a date → a **new log entry** (this module).
- **A shift in current truth** — the canon's standing answer changed → **rewrite** the knowledge/initiative file in place, **per using-hq**.

A pricing change is the canonical both-case: capture the *decision event* as a new `type: decision` log entry **and** rewrite the knowledge/initiative canon (and any outward artifact) to the new standing truth. The log records *that you decided*; the canon records *what is now true*. Never let a dated log entry become the only home for a standing fact, and never stack the dated decision into the canon as an "Updates" section.

## Pick the type, then shape the body to it

Frontmatter `type` is one of `decision | meeting | review | observation` (**see the spec**). The body has **no required sections** — its shape follows the type:

- **`decision`** — one section per decision: the **Chosen** call, the **Why** (rationale), any **Guardrail / Casualty** (what the choice rules out). Decisions earn their keep through reasoning, not just the verdict.
- **`meeting`** — who, the substance discussed, what was validated or learned, and any next step.
- **`review`** — what was assessed and the findings or verdict.
- **`observation`** — the signal noticed and why it matters (the read), kept short.

A decision entry that records only the verdict and not the *why* is half an entry — the reasoning is the part future-you cannot reconstruct from git.

## Sign dated lines with operator initials

Because log entries are inherently dated records, any dated line inside one carries the operator's initials: `2026-06-05 (RV): decided X`. Initials come from the operator's `people/` note (**see the spec** → *Signing dated entries*). Git is the source of truth for authorship; the initials add Obsidian-readable attribution. Knowledge and initiative files do **not** use dated, signed lines.

## Indexing

A new entry must appear in `log/index.md` (**per using-hq** → *Creating a file* and *Before every commit*). The index groups by kind — Decisions, Meeting Notes, Reviews, Observations, Session Summaries — so file the pointer under the section matching the entry's `type`, newest first, with a one-line hook.

`log/weekly/` is **output-only and not indexed** — `/weekly` writes rollups there; they are generated summaries, not authored entries, so they never go in `log/index.md` (**see the spec** → `log/weekly/`).

## Common mistakes

- **Rewriting an old log entry when the situation changed** — the log is immutable; write a **new** entry, and let the old one record its own day.
- **Logging a decision but not rewriting the canon it changed** — the log records the *event*; the standing truth must also be updated in place (**per using-hq**).
- **Stacking a dated decision into a knowledge/initiative file** — standing files carry no dated "Updates" sections; that belongs in the log (**per using-hq**).
- **A `decision` entry with the verdict but no rationale** — the *why* is the irreplaceable part; record it.
- **Dated lines with no `(initials)`** — inherently-dated records are signed (**see the spec**).
- **Adding a `/weekly` rollup to `log/index.md`** — `log/weekly/` is output-only and unindexed.

## Related

- **`using-hq`** — the always-on discipline this skill sits on: current-state vs. log exception, index hygiene, editing-scope, wikilink resolution.
- **`docs/vault-design.md`** → *Log Entry* (frontmatter + naming), *Signing dated entries*, *Current state with rationale*, and `log/weekly/` (output-only).
- **`/dream`** consolidate phase — the one operation that promotes durable log signal *up* into knowledge; its rules live in that command, not here.
- **`validate-vault`** — the structural check (indexes current, wikilinks resolve) this skill keeps green.
