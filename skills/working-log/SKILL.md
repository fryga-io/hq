---
name: working-log
description: "Use when capturing something into an hq vault's log/ — recording why a decision was made and what was rejected, a meeting, review, or observation as a dated entry; filing a transcript someone handed over; answering the operator's \"why is it like this\" or \"did we consider something else\" from the log; or signing and indexing an entry. Use whenever you touch log/."
---

# Working the log

The **log** is the core hq module that holds **history**: point-in-time records of decisions, meetings, reviews, and observations, one file per entry at `log/YYYY-MM-DD-<slug>.md`. It answers two questions the working files cannot: *why is it like this?* and *did we consider something else?* It never answers *what is true now* — that lives in the files agents work from (**per using-hq** → *`log/` is history, not state*).

It does **not** restate the always-on vault discipline (index hygiene, editing-scope, wikilink resolution, when the log may be opened — all **per using-hq**) or the frontmatter schema (**see the spec** → *Log Entry*). Copy the per-type frontmatter block from the spec; everything below is the log-specific operating layer on top.

## Working file first, log second

A decision is done when the file agents work from for that task says it — a command or skill prompt, a `knowledge/` canon, an `operations/` runbook, an initiative. Edit that file first: the rule as a plain sentence, written general, with one clause of reason if the agent needs it to apply the rule. Then write the log entry in the same commit, and name the entry in the commit message so `git log -S` on the rule's line leads to it.

A log entry without the working-file edit is the failure this order exists to prevent: the next agent works from the file, never sees the decision, and the decision is lost or — worse — someone reads the log as the rule.

Not every event is a decision. A meeting, a review, or an observation that changes nothing in a working file is a log entry alone.

## The defining invariant: a log entry is immutable

An entry records a moment, and that moment does not change. When reality moves on, the working file is rewritten and a **new entry** records the change and why. An old entry is never edited and never patched by a later one ("this changes the entry of …" belongs in the new entry's *Replaces* line, not in the old body).

A superseded decision keeps saying what was decided that day. Its index line carries the forward note `(superseded YYYY-MM-DD by [[new-entry]])`.

## What an entry holds — and what it never holds

An entry holds what the working file cannot carry: the reasoning, the alternatives, who decided and when.

An entry **never describes how the system works**: no commands, file paths, flags, step numbers, configuration, no "state as of" sections, no instructions or to-dos. That description goes stale within days, and an agent that opens the entry reads it as a rule. What the system does lives in the working file; what was done in one change lives in the commit message.

Links run one way: an entry links to the working file where its decision lives. Nothing outside `log/` links in (**per using-hq**).

## Pick the type, then shape the body to it

Frontmatter `type` is one of `decision | meeting | review | observation` (**see the spec**).

- **`decision`** — these sections, in order:
  - **Question** — what was being decided.
  - **Chosen** — the call, as decided that day. The operator's own words belong here, quoted verbatim, signed and dated.
  - **Why** — the reasoning. A decision with the verdict but no *why* is half an entry; the reasoning is the part nobody can reconstruct later.
  - **Considered and rejected** — each alternative with the reason it lost. This is what stops the same option being proposed again. Write only alternatives that were actually raised; when none were recorded, say so.
  - **Replaces** — the earlier entry this supersedes, if any.
  - **Lives in** — the working file(s) where the rule now stands.
- **`meeting`** — who, the substance discussed, what was validated or learned, and any next step.
- **`review`** — what was assessed and the findings or verdict.
- **`observation`** — the signal noticed and why it matters (the read), kept short.

## Answering "why" from the log

Open the log only on the operator's request (**per using-hq**). Find the entry through `log/index.md`, through the entries whose *Lives in* names the file in question, or through `git log -S` on the rule's line. Answer as history — the date, the past tense, what was chosen, why, and what was rejected — then state the current rule from its working file. When the entry and the working file differ, the working file holds; say that they differ and leave it.

## A transcript goes in raw, and stays

When the entry comes from a transcript — a meeting recording, a call, an interview — the **full raw transcript goes into the entry verbatim**, under `## Raw Transcript` at the bottom of the body (**see the spec** → *Log Entry*). Summary, action items, and to-dos are written **on top of it**, above it in the same file. Never store only your prose: the summary is your reading of the meeting, the transcript is what was actually said, and only one of those can be re-read later for something you missed the first time.

File it before you answer anything about it, even when the ask is only "pull out the action items" and even when facts are missing: file what was said, then ask. Answering in chat and offering to file it later is the failure: the prose survives, the transcript does not.

Same rule for other pasted raw material an entry is built from (an email thread, a chat export) — it goes in verbatim under `## Raw Content`, mirroring the library's raw-material convention (**per `working-library`**).

## Sign dated lines with operator initials

Because log entries are inherently dated records, any dated line inside one carries the operator's initials: `2026-06-05 (RV): decided X`. Initials come from the operator's `people/` note (**see the spec** → *Signing dated entries*). Git is the source of truth for authorship; the initials add Obsidian-readable attribution. Working files carry no attribution or dates on rules; those live here.

## Indexing

A new entry must appear in `log/index.md` (**per using-hq** → *Creating a file* and *Before every commit*). The index groups by kind — Decisions, Meeting Notes, Reviews, Observations, Session Summaries — so file the pointer under the section matching the entry's `type`, newest first. The hook says what was decided that day, never how the system works now.

`log/weekly/` is **output-only and not indexed** — `/weekly` writes rollups there; they are generated summaries, not authored entries, so they never go in `log/index.md` (**see the spec** → `log/weekly/`).

## Common mistakes

- **Writing the decision only into the log** — the working file comes first; the log records why.
- **Describing how the system works in an entry** — commands, paths, steps and "state as of" sections belong in the working file and the commit message.
- **Linking from a working file into the log** — a link invites reading the entry as the rule; the entry links to the file instead.
- **Citing a log entry as the current rule** — it is history; the working file holds.
- **Rewriting or patching an old entry when the situation changed** — write a **new** entry; the old one records its own day.
- **A `decision` entry with the verdict but no *why* or no rejected alternatives** — those are the parts the log exists for.
- **Summarizing a transcript and dropping the raw text** — the transcript goes in verbatim under `## Raw Transcript`; the summary sits on top of it, never in place of it.
- **Dated lines with no `(initials)`** — inherently-dated records are signed (**see the spec**).
- **Adding a `/weekly` rollup to `log/index.md`** — `log/weekly/` is output-only and unindexed.

## Related

- **`using-hq`** — the always-on discipline this skill sits on: *`log/` is history, not state*, index hygiene, editing-scope, wikilink resolution.
- **`docs/vault-design.md`** → *Log Entry* (frontmatter, decision body, naming), *Signing dated entries*, *Current state with rationale*, and `log/weekly/` (output-only).
- **`/dream`** consolidate phase — checks that every decision entry's rule stands in the working file it names.
- **`validate-vault`** — the structural check (indexes current, wikilinks resolve, nothing links into history) this skill keeps green.
