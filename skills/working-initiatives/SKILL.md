---
name: working-initiatives
description: "Use when operating an hq vault's initiatives — working an initiative's to-dos (add, check off, annotate items with owner/due/notes), curating its Docs shelf, changing its status (active → paused / completed / abandoned), reconciling initiatives/index.md and the README's What's Active list after a status change, archiving a concluded initiative, or splitting one into two. Use whenever you touch initiatives/ for a to-do or lifecycle move rather than authoring a brand-new initiative's Goal."
---

# Working initiatives

**Initiatives** are the hq vault's one unit of work — a **Basecamp-style project**,
one file per effort, and each initiative **owns its work in its own body**. There is
no separate task file: to see what's left on an initiative, you read the initiative.
Its standard tools are `## To-dos` (the work) and `## Docs` (the reference shelf), on
top of the strategic framing (`## Goal`, optional `## Context` / `## Key Results`).
Two flavors share the schema — **strategic** initiatives (a multi-week effort) and
**standing buckets** (always-on lanes like Admin & Ops, Sales, or SEO — a one-line
`## Goal` plus `## To-dos`). This skill is the faculty for *operating* an existing
initiative: working its to-dos, curating its docs, moving its status, keeping its
index surfaces honest, archiving it when it concludes, and splitting it when it
outgrows one goal.

Most initiative discipline is **not here** — it is the cross-module governance in
`using-hq` and the schema in the spec. This skill carries the thin operating layer
on top. It does **not** cover authoring a new initiative's body or frontmatter
(that is the spec → *Initiative*), nor the create-a-file / before-commit checklists
(those are `using-hq`).

## Working the to-dos — the everyday move

`## To-dos` are plain markdown in the initiative body; operating them is plain
markdown editing under current-state-with-rationale (`using-hq`):

- **Add work** as a `- [ ]` item under the right `### list` (or directly under
  `## To-dos` when there is a single list). Open a new `### named list` when a
  distinct strand of work appears.
- **Advance an item** by flipping `- [ ]` → `- [x]`. That is the whole lifecycle —
  an item has no status enum, no backlog/doing/blocked. If a granular state matters,
  say it in the item's own words (`- [ ] Smoke-test — blocked on the CC restart`).
- **Annotate inline, as prose:** `— @handle` names the doer (a `people/` note,
  multi-operator vaults only) and `due YYYY-MM-DD` a soft deadline. Both optional,
  human-read, never validated.
- **Give an item a notes block** when a one-liner isn't enough — indented lines
  (prose or sub-bullets) directly beneath it, for the description, sub-steps, or
  links. That is Basecamp's to-do description, in markdown.
- **The body is current state, not an audit trail.** Keep recently-completed items
  as `- [x]` while they still give useful momentum or context; prune stale done
  items when they stop earning their space, and remove a finished list once its
  outcome is captured in the Goal / Key Results or a log entry. Git holds the
  history.

Do **not** reach for a `tasks/` folder, an `initiative:` backlink, or a Bases
rollup — none exist. The work is in the file.

## Curate the Docs shelf

`## Docs` (optional) is the initiative's reference shelf — a curated list of
`[[wikilinks]]` to the `knowledge/`, `library/`, and `brand/` docs the effort leans
on, plus external links, each with a one-line note on why it's relevant. Add to it
as the initiative accumulates reference, so "everything for this project" sits in
one place. The documents themselves live in their home module (knowledge is shared,
not siloed per initiative) — this section **gathers** the relevant ones, it does not
copy them.

## The surfaces a status change touches

An initiative's status (per the spec's status enum) appears in places that must
agree. The body and frontmatter are one file; the other two are independent
surfaces you maintain by hand:

| Surface | Where | What a status change requires |
|---|---|---|
| Frontmatter | `status:` in `initiatives/<slug>.md` | set the new enum value |
| Index row | the file's row in `initiatives/index.md` | update its Status column |
| README list | `README.md` → "What's Active Right Now" | present iff `status: active` |

The README list is **active-only**. Flipping an initiative to `paused`,
`completed`, or `abandoned` means *removing* its README line; flipping back to
`active` means *adding* it. `validate-vault` Test 6 fails on any stale README
entry, Test 4 on any index row that contradicts the file.

**Standing buckets stay `active`** as long as their lane is live — Admin & Ops or
Sales rarely "completes." They sit in the index and README's What's Active like any
other active initiative; group them separately there if the vault's `CLAUDE.md`
calls for it.

## Move a status

1. Rewrite the body to the new current state with rationale (per `using-hq`) — a
   `completed` initiative reads as done and why; an `abandoned` one as dropped and
   why.
2. Set `status:` in frontmatter to the new enum.
3. Update the Status column in `initiatives/index.md`.
4. Add or remove the README "What's Active" line per the active-only rule above.

`paused` keeps the file in place and stays out of README; `completed` and
`abandoned` usually also earn an **archive move** (below). Distinguish the two:
`completed` = the goal was reached; `abandoned` = the effort was dropped. Use the
real outcome — don't soften an abandoned initiative into "completed".

## Archive a concluded initiative

When a `completed` or `abandoned` initiative is no longer live reference, move its
file into an `archive/` subfolder to keep `initiatives/` scannable:

1. Move `initiatives/<slug>.md` → `initiatives/archive/<slug>.md`. The slug and
   body are unchanged.
2. In `initiatives/index.md`, move its row out of the live table into the
   **Archived** line, noting outcome + date (e.g. `[[archive/<slug>]] — shipped,
   archived <date>`).
3. Confirm it is **not** in README "What's Active" (a concluded initiative already
   left that list when its status changed).

**Inbound `[[<slug>]]` links do not break on this move.** Test 3 resolves
wikilinks on basename — `[[<slug>]]` still finds `archive/<slug>.md` exactly as it
found `initiatives/<slug>.md`. The path-qualified `[[archive/<slug>]]` form (used
in the index's Archived line) is a readability *convention* signalling "this is
archived," not a validity requirement. So there is **no vault-wide grep-and-repair
step** here — archiving is a move, not a rename, and existing citations keep
resolving. (`archive/` is a vault-local extension, not an OS concept; whether to
use it, and its exact index format, is your vault's `CLAUDE.md` call.)

## Split an initiative into two

When one initiative has grown two distinct goals, split it rather than let it
sprawl:

1. **Create the second initiative** (spec → *Initiative*) — its own `## Goal`,
   optional `## Context` / `## Key Results`, `## To-dos`, and `## Docs`, carved from
   the original, with a fresh slug.
2. **Divide the body between the two.** Move each `### to-do list` (and any Key
   Results and Docs) to whichever initiative now owns it, and rewrite each to stand
   alone. The original keeps its slug, so its inbound `[[<slug>]]` links still
   resolve.
3. **Reconcile both index surfaces:** add the new initiative's row to
   `initiatives/index.md`, and add it to README "What's Active" if it is `active`.
4. If the split leaves the original's remaining scope finished, run the status
   move + archive above on it.

Merging two into one is the same in reverse: fold one body (Goal, Key Results,
to-dos, docs) into the other, remove the absorbed initiative's index row and README
line, and archive or delete the emptied file.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Leaving a completed/paused/abandoned initiative in README "What's Active" | The list is active-only → Test 6 FAIL. Removing it is part of the status move, not a later cleanup. |
| Updating frontmatter `status:` but not the index Status column (or vice versa) | The two surfaces disagree → Test 4 FAIL. Move both in the same edit. |
| Grepping the vault to "fix" inbound links after an archive move | Bare `[[<slug>]]` still resolves on basename (Test 3). There is nothing to repair — a move is not a rename. |
| Appending a dated "Completed:" / "Update:" section instead of rewriting the body | Current-state-with-rationale, per `using-hq`; git holds the history. |
| Labelling a dropped effort `completed` to look tidy | `completed` = goal reached, `abandoned` = effort dropped. Record the real outcome. |
| Inventing a status enum for a to-do item (`doing`, `blocked`) | An item is `- [ ]` or `- [x]`; any extra state goes in the item's own prose or notes block. |
| Copying a knowledge/library doc into `## Docs` | Docs is a curated list of `[[wikilinks]]`; the document stays in its home module. |
| Keeping every completed item forever as an audit trail | The body is current state; prune stale done items and finished lists — git holds the history. |

## Related

- **`using-hq`** — the always-on discipline this skill sits on: current-state-with-
  rationale rewrites, index maintenance, the before-commit checklist, wikilink
  resolution. Don't re-derive any of it here.
- **`docs/vault-design.md`** → *Initiative* (frontmatter, the status enum, the
  required `## Goal` plus the standard `## To-dos` / `## Docs` sections, and the
  to-do conventions) and *Linking strategy*.
- **`validate-vault`** Tests 4 (index accuracy) and 6 (README "What's Active"
  accuracy) — the two checks a status move keeps green; Test 3 (link integrity) is
  what makes archive moves safe.
