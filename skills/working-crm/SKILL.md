---
name: working-crm
description: "Use when advancing, logging outreach on, or reconciling an hq vault's CRM — recording that a call, reply, connection, or meeting happened on a prospect; moving a company's pipeline stage; reading or updating crm/index.md; or finding/editing a contact. Use whenever you touch crm/ to move a deal forward rather than create a brand-new company file."
---

# Working the CRM

The **CRM** is the optional hq module that tracks the company's sales pipeline —
one file per prospect company, each carrying its research, grade, and the history
of every touch. This skill is the faculty for *operating* an existing CRM:
advancing a company through the pipeline, logging an interaction in its file, and
keeping the index honest when a stage changes.

It does **not** cover creating a new prospect file or the frontmatter schema (that
is `docs/vault-design.md` → *CRM Company (module)*). This skill is everything
*after* the file exists — when a real-world event needs to land in it.

## The pipeline is a funnel, not a counter — reason backward from the event

The `pipeline` stages are ordered:

| Stage | Means |
|---|---|
| `researched` | company researched and graded |
| `contacts-identified` | named buyer(s) found, no outreach yet |
| `connected` | connection request accepted |
| `messaged` | outreach message sent |
| `meeting` | meeting booked or held |
| `opportunity` | a real project is on the table |
| `disqualified` | not a fit (record the reason) |

These describe an outreach funnel: you connect, then message, then meet. The
stage is **the furthest point the relationship has reached**, not the next slot
after its current value. So when you learn an event happened, set the stage the
event *implies*, not `current + 1`.

This matters most when a file has had little or no outreach logged yet — a
late-funnel event can arrive before any of the intermediate stages was ever
recorded:

> A company at `contacts-identified` (no message ever sent) — you learn **a call
> happened and went well**. A call presupposes you connected, messaged, and
> booked a meeting. Do **not** step to `connected`. The furthest point reached is
> the call, so set `pipeline: meeting` (or `opportunity` if the call surfaced a
> real project). The skipped stages are simply true-in-retrospect; you do not
> walk the file through each one.

When an event implies a stage you can't square with the file (it shows no prior
outreach, or the file warns the contact may be wrong), trust the event for the
stage but **say so in the interaction note** — the gap is signal, not something to
silently paper over.

## Log the interaction in the body — this is the CRM exception

The general OS rule is *rewrite the body, don't stack dated updates* (git holds
the history). **The CRM is the deliberate exception.** A prospect's body carries a
dated `## Interactions` history precisely because the sequence of touches *is* the
asset — when you connected, what you said, how they replied. That log is the point
of the file.

So, on any real touch:

1. Keep the standing sections (`## Company`, `## Why They Fit`, `## Contacts`)
   **rewritten to current truth**, the normal way — these are not a log.
2. Append a dated bullet under `## Interactions` (create the heading if absent —
   a file that has never been advanced won't have one yet):

   ```markdown
   ## Interactions

   - 2026-06-23 — Discovery call. Confirmed the migration pain point; wants a
     proposal for a two-week spike. — AB
   ```

3. **Sign with the operator's initials.** A prospect file is shared and
   multi-operator, so an interaction is attributable like a log entry — use the
   acting person's initials — from their `people/` note (spec → *Signing dated
   entries*). This is the one place a non-log vault file gets signed.
4. Move the `pipeline` value to match the event (see the funnel rule above).

## Find contacts where the vault keeps them — check before you assume

The schema documents a separate CRM Contact type (`tags: [crm, contact]`, its own
`<person>-crm.md` file linking back to the company). But a vault may instead embed
its contacts as a bullet list under a `## Contacts` heading inside the company
file. Which convention a vault uses is its own choice — **check before you assume**
rather than guessing or creating a second, parallel home for the same person:

- Look for `<person>-crm.md` contact files, and read `hq.config.yml` →
  `vault.crm.contact_tags` (a contact tag declared there means the vault uses
  separate contact files; absent means contacts are embedded).

Embedded contacts look like:

```markdown
## Contacts

- **Jane Roe** — VP Engineering — [LinkedIn](https://www.linkedin.com/in/...)
- **John Doe** — CTO — [LinkedIn](https://www.linkedin.com/in/...)
```

To add, correct, or annotate a contact, follow whichever convention the vault
uses — edit the embedded bullet, or the contact file — and keep a single home per
contact.

## Reconcile the index by hand — it does NOT auto-update

`crm/index.md` typically holds **two kinds of content, and they behave
differently**:

| Artifact in `crm/index.md` | Live or hand-maintained |
|---|---|
| The embedded `![[…/pipeline.base]]` dashboard | **Live** — reads frontmatter, recomputes on its own. Never edit it for counts. |
| A "Pipeline Summary" prose block (totals, dates) | **Hand-written** — drifts silently; stale until a human edits it. |
| A hand-curated "hot prospects" or "by-source" wikilink list | **Hand-written** — a curated list, not a query result. |

The `.base` is the source of truth for *who is at what stage*; trust it. The prose
around it is a frozen snapshot from when someone last wrote it — its hardcoded
counts and dates are often **already stale** and are not evidence of anything.

So when you advance a company:
- The `.base` reflects it automatically once you change the frontmatter — nothing
  to do there.
- If that company appears in a **hand-written list** (e.g. a "hot prospects"
  section), update or move that line yourself so the prose doesn't contradict the
  file. The stage moved; the curated narrative didn't.
- Do not trust — or bother re-deriving — the hardcoded summary counts. If they're
  visibly wrong and you're already in the file, fix the line you touched; a full
  recount is a separate, deliberate task, not a side effect of advancing one deal.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Stepping a "good call" to `connected` because the file was at `contacts-identified` | Stage = furthest point reached. A call implies connect+message+meeting; set `meeting`/`opportunity`, not `current + 1`. |
| Rewriting the body and dropping the touch history | CRM is the exception to the rewrite-don't-stack rule — `## Interactions` is an append-only dated log; that history is the asset. |
| Leaving the interaction note unsigned | Prospect files are multi-operator; sign with the acting person's initials, like a log entry. |
| Assuming where contacts live (or creating a second home for one) | A vault either embeds contacts as bullets or uses `<person>-crm.md` files — check the convention; keep one home per contact. |
| Reading the index "Pipeline Summary" prose as current state | Those counts/dates are a hand-written, usually-stale snapshot. The `.base` is the live truth. |
| Recomputing the index `.base` by hand | The Base recomputes itself from frontmatter — only the surrounding prose needs a human. |

## Related

- **`docs/vault-design.md`** → *CRM Company (module)* — the frontmatter schema,
  filename convention, and standing body sections for a prospect file.
- **`hq.config.yml`** → `vault.crm` — pipeline-stage extensions and the
  company/contact marker tags the vault uses. Signing initials come from the
  operator's `people/` note (spec → *Signing dated entries*).
- **`validate-vault`** — the CRM structure/frontmatter checks (required keys,
  `pipeline` and `grade` enums) and the note that CRM files are discovered via the
  embedded Base, not a hand-maintained wikilink list — keep your edits passing
  them.
