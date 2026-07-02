---
name: working-operations
description: "Use when working in an hq vault's operations module - filing the report a monitoring run produced, executing a runbook or process checklist, deciding whether a new artifact is a report series or a one-off audit, or adding/restructuring a runbook, checklist, or live-asset snapshot. Use whenever you touch operations/ to do or record operational work rather than to record thinking (knowledge/) or a decision (log/)."
---

# Working operations

The **operations** module holds recurring operational work and operational
reference - the *doing*, not the *thinking*. Four file kinds live here: monitoring
**runbooks**, the **reports** those runs produce, recurring process **checklists**,
**live-asset snapshots**, and one-off **audits**. This skill is the faculty for
operating that module: filing a report, executing a runbook or checklist, and
placing a new artifact in the right kind with the right schema.

It does **not** cover frontmatter (see the spec for *Report*, and *Knowledge* for
everything else), the always-on cross-module discipline (per `using-hq`:
current-state-not-audit-trail, editing scope, index hygiene, wikilink resolution),
or the report-generating tool itself (operator-supplied, per the spec). This skill
is only the operations-specific layer on top.

## Two schemas, two index destinations

Every operations file is one of two schemas, and that choice decides where it is
indexed:

| Kind | Schema | Lives | Indexed in |
|---|---|---|---|
| Runbook | Knowledge (`tags: [knowledge]`) | `operations/{slug}.md` | `operations/index.md` |
| Checklist | Knowledge | `operations/{slug}.md` | `operations/index.md` |
| Live-asset snapshot | Knowledge | `operations/{slug}.md` | `operations/index.md` |
| One-off audit | Knowledge | `operations/{slug}.md` | `operations/index.md` |
| Report (one per run) | Report (`tags: [report]`) | `operations/{topic}-reports/YYYY-MM-DD.md` | the subfolder's own `index.md` |

Only **reports** use the Report schema and a per-topic subfolder; everything else
is a flat Knowledge file at `operations/` top level, indexed in
`operations/index.md`. The full per-type frontmatter is in the spec - copy it, do
not transcribe from memory.

## Report vs. one-off audit - the call that gets missed

A recurring measurement and a single audit look alike but file differently:

- **Report series** - produced repeatedly by a tool on a cadence (weekly uptime,
  weekly SEO). Report schema, subfolder `operations/{topic}-reports/`, one
  `YYYY-MM-DD.md` per run, reverse-chronological subfolder `index.md`. The
  frontmatter carries `runbook: "[[runbook-slug]]"` tying each run back to the
  runbook that defines it.
- **One-off audit** - a single deep assessment, not a recurring series. Knowledge
  schema, sits flat at `operations/` top level, indexed in `operations/index.md`
  like any other knowledge file.

If it recurs from a runbook, it is a report. If it is a standalone assessment, it
is an audit. Putting an audit into a `{topic}-reports/` folder, or a report at top
level, is the common miscategorization.

## File a report

A report body is **produced by the operator's tool**, not hand-authored - the OS
ships the schema and folder convention, not the script. To file one:

1. Place it at `operations/{topic}-reports/YYYY-MM-DD.md` (create the subfolder and
   its `index.md` on the first report of a new topic).
2. Frontmatter per the Report schema, including `runbook: "[[runbook-slug]]"`.
3. Add a pointer to the **subfolder's** `index.md`, newest first - not to
   `operations/index.md`.
4. You may append a **dated, initialed** interpretation section after the generated
   body (signing rules per the spec / `using-hq`). The generated content itself
   stays as the tool produced it.

## Execute a runbook or checklist

The **procedure lives in the file (or in the command it names), not in this skill.**

- A **runbook** states what is monitored and how, and often **delegates the steps
  to a command or tool** ("run the command it names; that command is the single
  source of truth for the steps"). Read the runbook, then run what it points at. Do
  not reconstruct steps it deliberately did not duplicate.
- A **checklist** is a literal checkbox list with a stated cadence ("run by the 5th
  of the following month"). Work the boxes in order; the file is self-describing.

When a run surfaces a real decision, observation, or escalation, that is a `log/`
entry, not an edit to the runbook (per `using-hq`: log is point-in-time, knowledge
is current-state). Edit the runbook only when the *operation itself* changes.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Filing a recurring measurement as a top-level audit (or an audit into a reports subfolder) | Report = recurs from a runbook, so Report schema + subfolder; audit = one-off, so Knowledge schema + top level. |
| Pointing a new report at `operations/index.md` | Reports are indexed in their **subfolder's** `index.md`; only runbooks/checklists/snapshots/audits go in `operations/index.md`. |
| Omitting the `runbook:` wikilink from a report's frontmatter | The wikilink ties each run back to its runbook; missing it dangles the link (Test 3). |
| Hand-writing or rewriting a report body | The body is tool-produced; only an appended dated/initialed interpretation is yours. |
| Reconstructing a runbook's steps it delegated to a command | The runbook deliberately did not duplicate them; run the command it names. |
| Editing a runbook to record what a run found | A run's findings/escalations are a `log/` entry; edit the runbook only when the operation itself changes. |

## Related

- **`using-hq`** - the always-on discipline this skill sits on top of: current-state
  vs. audit-trail (and the `log/` exception), editing scope, index hygiene before
  commit, wikilink resolution.
- **`docs/vault-design.md`** - *Report* (the report frontmatter + subfolder
  convention), *Knowledge* (runbook/checklist/snapshot/audit frontmatter), and
  *Operations module* (the doing-not-thinking boundary against `log/` and
  `knowledge/`).
- **`validate-vault`** - Test 4 (every operations file discoverable in the right
  index: top-level files in `operations/index.md`, reports in their subfolder
  index) and Test 3 (the report's `runbook:` wikilink resolves).
