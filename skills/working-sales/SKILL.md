---
name: working-sales
description: "Use when working in an hq vault's sales module — appending sourced prospects to a sourcing list, answering what the documented outreach / prospecting / call playbook actually says, reconciling per-tier counts and totals, or deciding whether a prospect belongs in the sales list or a crm/ file. Use whenever you touch sales/ for anything beyond reading a single playbook end to end."
---

# Working the sales module

The **sales** module is the optional hq module that holds the *how* of the sales
motion — the playbooks and frameworks for prospecting, outreach, and
conversations — plus the **raw sourcing lists** that feed it. It pairs with
`crm/` (the *data*: graded companies and contacts) and draws its strategic frame
from a `knowledge/` canon. This skill is the faculty for *operating* an existing
sales module: editing sourcing lists without desyncing them, answering what a
playbook actually documents, and respecting the sales↔CRM boundary.

It does **not** cover the module's schema (that is `docs/vault-design.md` →
*Sales module*; sales files use the **Knowledge schema**, `tags: [knowledge]`)
or grading a prospect into a CRM file (that is the CRM motion). Reach for those
when you need them; this skill is the mechanics of the list and the playbooks.

## Always read the whole file before you edit it

Sourcing lists and playbooks are long, hand-built documents whose structure is
**not uniform** and **not enforced by any validator**. The only way to know a
file's shape is to read it end to end. Two traps recur:

- **One file, several table schemas.** A sourcing list often groups prospects
  into sections (tiers, regions, segments) — and different sections use
  **different columns**. A headline tier might be 5-column (`Company | Size |
  Location | What they do | Was client of`) while the bulk tiers are 4-column
  (`Company | City | Size | Founded`). Each section's header row is the contract
  for that section. Copying one section's shape into another, or appending a row
  with the wrong column count, produces a malformed row that renders broken in
  Obsidian and silently corrupts the table.
- **Derived totals you must hand-maintain.** The same file usually carries a
  **summary table** (per-section counts) and a **grand total** near the bottom.
  Nothing recomputes these. Add three rows and they are wrong until you fix them.

Read first; match the local section; update the derived numbers. There is no
shortcut.

## Append a prospect to a sourcing list

1. **Find the right section** for the prospect (the tier/region/segment it
   belongs to) and read that section's **header row** — that, not a neighbouring
   section, defines the columns.
2. **Append a row that matches that section's columns exactly** — same count,
   same order, same `|` delimiters. If a cell is unknown, use the file's own
   convention for unknowns (e.g. an em-dash `—`), not a blank or a guess.
3. **Update the summary table:** bump the count for the section you added to.
4. **Update the grand total** to match. If counts are approximate (e.g. a `~`
   prefix), keep the same notation.
5. Re-read the section and the summary together and confirm the per-section
   counts still sum to the total.

A worked shape (invented data):

```
## Tier 2 — Northern Europe          ← 4-column section
| Company | City | Size | Founded |
|---|---|---|---|
| Northwind Logistics | Oslo | small | 2018 |
| Acme Billing | Malmö | midsize | 2021 |   ← appended; 4 cells, matches header

## Summary
| Tier | Description       | Count |
|---|---|---|
| 2 | Northern Europe     | 11 |          ← was 10; bump the section you touched
| **Total** | | **~140** |                ← was ~139; bump the grand total too
```

The two edits that get skipped are steps 3 and 4. "Add three rows" reads as one
action, but the file has three coupled surfaces — the section table, the summary
count, and the total — and all three must move together or the file lies about
its own size.

## Answer what a playbook documents — read the stub, don't confabulate

Playbooks are drafted **incrementally**. A mature-looking playbook routinely
contains both **fully-written stages** and **to-be-drafted stubs** for stages
that have not been built yet. A stub is usually a one-line blockquote naming the
*planned shape* — e.g.:

```
## Outreach Templates

> *To be drafted once the persona is populated. Three templates: warm-intro ask,
> cold connection request, cold InMail — each carrying the value-back hook.*
```

When asked "what's the documented approach for X" (first outreach, prospecting
sequencing, pipeline stages):

- **Read the section that actually owns X.** If it is a stub, the honest answer
  is *"X is a to-be-drafted stub; only its planned shape exists"* — then quote
  the planned shape. Do **not** invent templates, sequences, or copy to fill the
  gap.
- **Do not substitute a different, fully-written stage.** A written *Discovery
  Call Structure* (a mid-funnel stage) is not the *first-outreach* playbook even
  though it is the most complete prose nearby. Answer about the stage that was
  asked for, at its real maturity, not the most finished thing on the page.

The failure mode is over-reading: an agent under pressure to be helpful either
fabricates the missing playbook or promotes a neighbouring written stage into the
answer. Both misreport the module's actual state.

## Surface the strategic gate — a quiet motion is a material fact

The sales motion is governed by a `knowledge/` strategy canon, and a sourcing
list or playbook can be **research-stage / paused** even while it looks live and
detailed. The canon is where a motion is declared dormant — e.g. *"goes quiet on
direct outbound"*, or *"N graded prospects … research-stage, not a live outbound
program today."*

When you answer any sales question — counts, contacts, "who should we reach out
to" — and the canon marks the motion paused, **say so**. A mechanically correct
answer that omits "this whole motion is currently dormant per the strategy canon"
is a material omission for an operator who may be about to act on it. Check the
canon's status line before reporting the list as if it were active. The relevant
canon file is named in `sales/index.md` and `hq.config.yml`.

## Respect the sales↔CRM boundary

| Stage | Where it lives |
|---|---|
| Raw sourced prospect (just a name + a few attributes) | a **row in the sourcing list** under `sales/` |
| Graded prospect (a grade, a pipeline stage, research notes) | a **per-company file** `crm/<motion>/<slug>-crm.md` |

New prospects enter as **rows in the sourcing list**. A prospect graduates to its
own `crm/.../<slug>-crm.md` file **only once it is graded** into the pipeline.
Do not create a CRM company file straight from a freshly sourced name — that
skips the list and seeds the CRM with ungraded noise. Append to the list; let the
CRM motion promote it later. (`sales/` is the *how*; `crm/` is the *data*.)

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Appending a row without reading the target section's header | Sections use different column schemas; the wrong column count makes a malformed/inconsistent row. |
| Reusing a headline section's columns in a bulk section (or vice versa) | Each section's header row is its contract; copying another section's shape breaks the table. |
| Adding rows but not bumping the per-section count and grand total | The summary table and total are hand-maintained; the file silently desyncs about its own size. |
| Confabulating templates for a to-be-drafted outreach stub | A stub documents only a *planned shape*; inventing content misreports the module's state. |
| Quoting the written Discovery Call Structure as the "first-outreach playbook" | That is a later funnel stage; answer the stage actually asked for, at its real maturity. |
| Reporting list counts without checking the strategy canon's status | If the canon marks the motion paused/research-stage, omitting that is a material omission. |
| Creating a `crm/<slug>-crm.md` file straight from a sourced name | Raw prospects belong in the sourcing list; only graded ones graduate to CRM files. |

## Related

- **CRM motion** (the *data* side) — grading a prospect into
  `crm/<motion>/<slug>-crm.md`. See `docs/vault-design.md` → *CRM module* and
  *CRM motion typing*.
- **`docs/vault-design.md`** → *Sales module* — the schema (Knowledge schema,
  `raw/` subfolder convention) and how `sales/` pairs with `crm/`.
- **Strategy canon** in `knowledge/` (named in `hq.config.yml`) — the strategic
  frame and the motion's live/paused status; read its status line before
  reporting a list as active.
- **`validate-vault`** Test 1 (structure) and Test 4 (index accuracy) — a new
  sourcing-list file must stay wikilinked from `sales/index.md`. Note: the table
  schemas and summary totals inside a file are **not** validated — keeping them
  consistent is this skill's job, not the linter's.
