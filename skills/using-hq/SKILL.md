---
name: using-hq
description: "Use when working in an hq vault — any session whose working directory is under a directory containing hq.config.yml (an AI-operated company hub of markdown initiatives, knowledge, log, CRM, and content). Read at the start of work there, and before reading, creating, or editing any vault file."
---

# Using hq

You are operating an **hq vault**: a markdown vault where the files are the source
of truth and the agent and Obsidian are two interfaces over them. These are the
generic rules for any hq vault; the vault's own `CLAUDE.md` adds company-specific
policy. The schema (frontmatter, folders, enums) lives in `docs/vault-design.md`;
the session-start hook gives its path. External artifacts (a site, a repo)
implement what the vault states; when one diverges, fix it outward.

## Flow

The operator drives. Follow their head and keep the work moving.

- **Their word wins.** In a live session, what the operator says wins over what
  the vault says, the canon included. Use their word; don't argue, don't cite the
  vault against them, don't ask which version holds.
- **Ask only when nothing can move without them**: a business decision only they
  can make, or what they meant by their own words. Ask it once, one question per
  message, and keep working on whatever does not depend on the answer.
- **Don't stop to ask** about file names, tags, frontmatter, indexes, where a file
  goes, tooling or build choices, whether to proceed when the direction is clear,
  or a fact you can look up in the vault, the mail or the drive. Decide, say in
  one clause what you chose, and go on.
- **Park everything else for the end of work**: a contradiction with the vault,
  prose elsewhere that no longer fits, a finding outside the ask, an assumption,
  an offer of extra work. Don't raise it mid-work.
- No ceremony: no "rules loaded", no previews, no recap. Report runs, reviews and
  audits in chat in plain language; don't send the operator to a report file.
- Independent tasks that touch different files run in parallel, each agent in its
  own git worktree.

## Reading

Start from `README.md` (the map), then the `index.md` of the modules the task
touches, then the files themselves. Cite a file only after opening it in this
session; an index line is a pointer, not a source. What no opened file says, don't
claim.

## `log/` is history, not state

`log/` records what was decided, why, and what was rejected; it never says what
is true now. The same holds for every folder listed under `vault.history`.

- Neither `log/` nor `log/index.md` is read at startup. The log is read only when
  looking for why something is so. Answer as dated history, then state the current
  rule from its working file.
- Nothing outside `log/` links into it; the README map's link to `log/index` is
  the one exception.
- A transcript or other raw material handed over goes into `log/` at once, before
  you answer anything about it → `working-log`.

## Editing

- **Stay inside the ask.** Change what the operator asked for, and a new state the
  operator stated in the file that holds that fact. Don't touch other prose; park
  it.
- **An artifact carries exactly what was asked for.** A finding outside that scope
  goes to the parked list, never into the file as a section, heading, or aside.
- **Current state with rationale.** Rewrite the body to the new truth and why; no
  "Update" / "Changelog" / dated sections. Git is the history. `log/` entries are
  the exception: never rewritten, a new entry records the change.
- **Writing a rule.** Files agents read as instructions state the rule generally,
  as a plain sentence, with one clause on where it comes from: no ticket numbers,
  counterparties, tallies, attribution or dates. Who said it, when, and why goes
  into the log entry.
- Every file the agent names, vault notes and exports alike, is
  lowercase-kebab-case with dates as `YYYY-MM-DD`.
- Read your diff before saying done.

## End of work

Decisions and state changes stay in the chat until a checkpoint: the work is
finished, the context is about to be compacted, or the session is handed over.
At a checkpoint:

1. Write the final state only, into the file that holds each fact, without
   asking. The back-and-forth inside the session is never written down.
2. A decision goes first into the file agents work from for that task (a command
   or skill prompt, `knowledge/`, `operations/`, an initiative); the log entry
   recording why follows in the same commit → `working-log`.
3. New files get frontmatter copied from the spec's per-type block and a line in
   their `index.md`; an active initiative is listed in README *What's Active*.
4. One commit. `/validate-vault` runs only when the operator asks for it.
5. Hand back the parked list in one short message, most useful first. Other
   places in the vault that disagree with the new state are left for `/dream`.

## Rules live in the vault

How to work in a vault (the operator's corrections, preferences, conventions) is
written in the vault: its `CLAUDE.md`, `knowledge/`, `operations/`. A rule for
every vault goes into this plugin. Never into the agent's private memory, which
nobody else can see. Schema changes go upstream into this plugin, never forked
per vault.

## Capability skills

One per module, loaded when you work that module:

- `working-initiatives` — to-dos, docs shelf, status moves, archive, split.
- `working-knowledge` — promote to canon, merge/split notes.
- `working-log` — record a decision, meeting, or transcript; answer "why" from the log.
- `working-people` — add/update a person; node vs CRM contact.
- `working-companies` — add a company node; wire project backlinks.
- `working-library` — research, cite, remove, restructure items.
- `working-crm` — advance a stage, log a touch, reconcile the index.
- `working-distillery` — draft, run the review panel, bank, wire a channel.
- `working-competitive` — record a move, re-grade threat, positioning.
- `working-sales` — append prospects, reconcile totals, read a playbook.
- `working-operations` — file a report, run a checklist, report vs audit.
