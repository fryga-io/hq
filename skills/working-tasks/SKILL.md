---
name: working-tasks
description: "Use when working with an hq vault's tasks module — creating a task file and rolling it up under its initiative, flipping a task's status through its lifecycle, reconciling completed tasks, or maintaining tasks/index.md. Use whenever you touch tasks/ to move work forward."
---

# Working tasks

**Tasks** are the hq vault's discrete, actionable work items — one flat `.md`
file per task in `tasks/`, with status, priority, owner, and parent initiative in
frontmatter. This skill is the faculty for *operating* tasks: standing one up
under its initiative, advancing it through the status lifecycle, and reconciling
it on completion.

Tasks are a **core** faculty, so the cross-module discipline that governs every
edit — current-state-not-audit-trail, editing scope, index hygiene before commit,
wikilink resolution — is always-on **per `using-hq`**, not restated here. The
frontmatter skeleton (keys, enums, required body sections, filename convention) is
the **spec** → *Task*. This skill carries only what is specific to operating the
tasks module on top of those.

## The shape of a task — see the spec, then these house rules

Copy the Task frontmatter block and required body sections (`## Context`,
`## Done When`) from `docs/vault-design.md` → *Task*. Two fields carry
operating nuance worth stating:

| Field | Operating nuance |
|---|---|
| `owner` | **multi-operator vaults only:** one handle (naming a `people/` note) — the **doer**, not the delegator; a solo vault omits it (spec → *Task*). |
| `initiative` | a `[[wikilink]]` to the parent initiative — this backlink *is* the rollup (below). Leave empty for standalone admin tasks. |

## Roll a task up under its initiative — the link does it, not a list

A task joins its initiative through **one move**: the `initiative: "[[<slug>]]"`
wikilink in its frontmatter. That backlink surfaces the task on the initiative
page automatically, and the `dashboards/*.base` files compute the initiative's
open-task view from frontmatter.

**Never** write a task list into the initiative's body to "show" its tasks — the
spec's linking strategy forbids duplicating what Bases compute. The only manual
surface you touch is `tasks/index.md` (next).

## Maintain tasks/index.md — the human rollup

`tasks/index.md` is the human-readable rollup: active tasks grouped under
`## <initiative or theme>` headings, one line each. Update it whenever a task is
added or its status changes (index hygiene, per `using-hq`). The house line
format:

```
- [[<slug>]] — <owner>: <one-line desc>, due <YYYY-MM-DD> `<status>`
```

`owner`, `due`, and the trailing `` `status` `` marker are all optional on the
line — include what the task carries. Group the task under the heading that
matches its `initiative` (or a theme heading for standalone work).

## Advance a task through its lifecycle

Status is the spine. Flip the `status` field and update the index line's marker
to match:

| From → to | What changes |
|---|---|
| `backlog` → `todo` → `doing` | bump `status`; refresh the `` `status` `` marker on the index line |
| any → `blocked` | bump `status`. **Only** `blocked` means blocked — never infer it from prose |
| any → `cancelled` | bump `status`; the file and its index line stay in place |
| any → `done` | see *Reconcile a completed task* below |

## Reconcile a completed task

Completion is **three edits, no move**:

1. Set `status: done`.
2. Fill `completed: <YYYY-MM-DD>` (the spec fills this only when status → done).
3. Update the `tasks/index.md` line's marker to `` `done` ``.

There is **no `tasks/archive/`** and no pruning ritual. The done task **stays in
its file and stays on the index line** with a `done` marker — the dashboards
(`dashboards/*.base`) auto-derive Active vs Completed from `status` via filters,
so you never manually move a finished task anywhere. Capturing the result is
current-state body editing **per `using-hq`** (a brief `## Outcome` note of what
shipped is fine).

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Listing a task inside its initiative's body | Bases compute the task rollup from the `initiative` wikilink — duplicating it desyncs the moment status changes. |
| Setting `owner` to the delegator | Owner is **the doer** — the one handle accountable and executing. |
| Inferring `status: blocked` (or `done`) from body prose | Status is an explicit enum field; only a literal flip means it. Never read it out of `## Context`. |
| Pruning or moving a `done`/`cancelled` task | No archive folder exists — finished tasks stay in place with the status marker; the Base filters the view. |
| Flipping `status` but leaving the `tasks/index.md` marker stale | The index line's marker is the only hand-maintained mirror of `status`; move them together. |
| Stamping `completed` without setting `status: done` (or vice versa) | The two move together; `completed` is filled exactly when status → done. |

## Related

- **`using-hq`** — the always-on discipline (current-state editing, editing
  scope, index hygiene before commit, wikilink resolution) that governs every
  task edit; tasks have no separate always-on rules beyond it.
- **`docs/vault-design.md`** → *Task* (frontmatter, filename convention, required
  body sections), *Linking strategy* (tasks → initiatives), and *Index
  maintenance*.
- **`working-initiatives`** — the parent side: a task's `initiative` wikilink is
  what its rollup reads.
- **`validate-vault`** — Test 4 (frontmatter enums: `status`, `priority`,
  `owner`/`company` against config), Test 3 (wikilinks resolve, incl. the
  `initiative` link), and the index/dashboard-guard checks this skill keeps green.
