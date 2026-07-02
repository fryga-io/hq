---
name: working-initiatives
description: "Use when operating an hq vault's initiatives beyond creating one — changing an initiative's status (active → paused / completed / abandoned), reconciling initiatives/index.md and the README's What's Active list after a status change, archiving a concluded initiative, or splitting one initiative into two. Use whenever you touch initiatives/ for a lifecycle move rather than authoring a brand-new initiative's Goal/Context/Key Results."
---

# Working initiatives

**Initiatives** are the hq vault's core unit of strategic work — one file per
multi-week effort, each owning a `## Goal`, `## Context`, and `## Key Results`.
This skill is the faculty for the *lifecycle* of an existing initiative: moving
its status, keeping its index surfaces honest after the move, archiving it when it
concludes, and splitting it when it outgrows one goal.

Initiatives is a heavily always-on faculty, so most of its discipline is **not
here** — it is the cross-module governance in `using-hq` and the schema in the
spec. This skill carries only the thin lifecycle layer on top. It does **not**
cover authoring a new initiative's body or its frontmatter (that is the spec →
*Initiative*), and it does **not** restate the create-a-file or before-commit
checklists (those are `using-hq`).

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
entry, Test 4 on any index row that contradicts the file. Tasks need no touch —
they link up via the `initiative` property and Bases recompute (per spec →
*Linking strategy*).

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

1. **Create the second initiative** (spec → *Initiative*) — its own `## Goal` /
   `## Context` / `## Key Results`, carved from the original, with a fresh slug.
2. **Divide the body and Key Results** between the two and rewrite each to stand
   alone. The original keeps its slug, so its inbound `[[<slug>]]` links still
   resolve.
3. **Re-point tasks.** Move each task's `initiative:` wikilink to whichever
   initiative now owns it — that backlink is the only rollup surface (no body
   lists).
4. **Reconcile both index surfaces:** add the new initiative's row to
   `initiatives/index.md`, and add it to README "What's Active" if it is `active`.
5. If the split leaves the original's remaining scope finished, run the status
   move + archive above on it.

Merging two into one is the same in reverse: fold one body into the other,
re-point its tasks, remove the absorbed initiative's index row and README line,
and archive or delete the emptied file.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Leaving a completed/paused/abandoned initiative in README "What's Active" | The list is active-only → Test 6 FAIL. Removing it is part of the status move, not a later cleanup. |
| Updating frontmatter `status:` but not the index Status column (or vice versa) | The two surfaces disagree → Test 4 FAIL. Move both in the same edit. |
| Grepping the vault to "fix" inbound links after an archive move | Bare `[[<slug>]]` still resolves on basename (Test 3). There is nothing to repair — a move is not a rename. |
| Appending a dated "Completed:" / "Update:" section instead of rewriting the body | Current-state-with-rationale, per `using-hq`; git holds the history. |
| Labelling a dropped effort `completed` to look tidy | `completed` = goal reached, `abandoned` = effort dropped. Record the real outcome. |
| Leaving a split initiative's tasks pointed at the old slug | Tasks roll up by their `initiative` wikilink; re-point each to its new owner or the rollup is wrong. |

## Related

- **`using-hq`** — the always-on discipline this skill sits on: current-state-with-
  rationale rewrites, index maintenance, the before-commit checklist, wikilink
  resolution. Don't re-derive any of it here.
- **`docs/vault-design.md`** → *Initiative* (frontmatter + the status enum and
  required `## Goal` / `## Context` / `## Key Results` sections) and *Linking
  strategy* (tasks → initiatives via the `initiative` property).
- **`working-tasks`** — re-pointing a task's `initiative` wikilink during a split
  or merge.
- **`validate-vault`** Tests 4 (index accuracy) and 6 (README "What's Active"
  accuracy) — the two checks a status move keeps green; Test 3 (link integrity) is
  what makes archive moves safe.
