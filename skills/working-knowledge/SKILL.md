---
name: working-knowledge
description: "Use when working with an hq vault's knowledge/ module — deciding whether a file belongs in knowledge/ versus a function directory, promoting an insight into a canon (single-source-of-truth) file, merging or splitting overlapping notes, or deciding when a scope earns its own knowledge/<scope>/ subfolder. Use whenever you touch knowledge/ for anything beyond reading one note."
---

# Working knowledge

The **knowledge** module is the core hq faculty for the company's own
**thinking** — strategy, domain understanding, references, synthesis. Each file
is a **single surface**: the file *is* both the source and the synthesis. There
is no raw/pointer/wiki split here (that is `library/`), so a knowledge file
holds the company's current understanding directly, in prose.

This skill is the faculty for *operating* `knowledge/` past reading a note:
placing a file correctly, promoting an insight into canon, merging or splitting
notes, and growing a subfolder. The frontmatter schema (`tags: [knowledge]`,
`topics`, `company`, `source`) is **the spec** → *Knowledge*; read it before
editing frontmatter. Everything always-on — current-state-not-audit-trail,
editing scope, index hygiene, wikilink resolution — is **per using-hq** and
already loaded this session. This skill carries only what is specific to
knowledge.

## The boundary test: does this belong in knowledge?

The one decision unique to this module. Apply it before creating or moving a
file:

> A file is **knowledge** if it changes because we **learned** something. If it
> changes because we **did** something — a report, a runbook, a process
> checklist, a sourcing list, a measurement — it belongs in a **function
> directory**, not here.

Knowledge is the *thinking*, not the *doing*. When a note drifts into procedure
or output, it has left the module; move it to `operations/`, `sales/`,
`distillery/`, or wherever the *doing* lives, and repoint its inbound links (per
using-hq).

## Canon files: single source of truth

A vault may declare **canon** files in `hq.config.yml` — load-bearing
source-of-truth nodes (e.g. `knowledge/<company>-canon.md`) that the rest of the
vault cites instead of restating. `validate-vault` confirms each declared canon
file exists. When a note and the canon disagree, **the canon wins**: the note
defers to it.

**Promoting an insight into canon is governed judgment, not a mechanical
procedure** — it overwrites established source-of-truth prose:

1. Weave the insight into the correct canon section as **current-state prose**
   (per using-hq — no dated appendix).
2. Canon prose you weren't told to touch is load-bearing. **Pause and show the
   diff** before editing adjacent claims, and get the operator's go-ahead before
   you overwrite an existing canon claim (per using-hq → *Editing scope*).
3. **De-duplicate the source note**: make it *cite* the canon (`[[<company>-canon]]`)
   rather than restate it (per using-hq — no duplication).
4. Update the `knowledge/index.md` hook if the canon's one-line summary changed
   (per using-hq → *Index maintenance*).

Note `/dream`'s `consolidate` phase is deliberately **additive-only** — it will
not overwrite or reconcile an existing canon claim, it routes that to the
operator. Overwriting canon is your judgment under the editing-scope gate, never
an automated rewrite.

## Merge two overlapping notes

When two notes cover the same scope, fold them into one survivor without losing
signal or breaking inbound links:

1. Fold the absorbed note's **unique signal** into the survivor as current-state
   prose (per using-hq — no dated "merged from" appendix).
2. **Repoint every inbound wikilink** from the deleted note to the survivor.
   Run `obsidian backlinks file="<absorbed-slug>"` to enumerate the inbound set;
   add an alias on the survivor if the old name still reads naturally in prose.
3. Delete the absorbed file and remove its `knowledge/index.md` entry; keep the
   survivor's (per using-hq → *Index maintenance*).
4. `/validate-vault` to confirm no dangling links (Test 3) and no orphans
   (Test 4).

## Split a scope into a subfolder

Knowledge starts **flat** and earns **one level of subfolders** only when a
coherent sub-scope grows large enough to group (e.g. a domain or audience cluster
that has outgrown the flat list). A subfolder carries **its own `index.md`** and is
checked against it; the top-level `knowledge/index.md` then **points at the
sub-index** rather than re-listing the sub-items (the spec → *Subfolders*).
Splitting a scope out is a larger move — confirm with the operator before doing it.

The two entity registries that recur across vaults, **`people/` and
`companies/`**, are *not* knowledge subfolders — they are their own top-level
modules (`working-people`, `working-companies`).

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Filing a report, runbook, checklist, or sourcing list under `knowledge/` | Those change because we *did* something — they belong in a function directory. Knowledge is the *thinking*. |
| Restating canon content in a note instead of citing it | Two sources of truth drift apart — the exact intra-knowledge drift `/dream` is built to detect. Cite `[[<company>-canon]]`. |
| Overwriting a canon claim without showing the diff / asking | Canon is load-bearing source-of-truth prose; silent edits are silent claim changes (per using-hq → *Editing scope*). |
| Merging notes but leaving inbound `[[<absorbed-slug>]]` links dangling | `obsidian backlinks` enumerates them — repoint each before deleting → else Test 3 FAIL. |
| Stacking a dated "Updated / merged-from" section into a knowledge file | Knowledge is current-state-with-rationale; git carries history (per using-hq). |
| Re-listing a subfolder's files in the top-level index | A subfolder with its own index is self-contained; the parent points at the sub-index only. |

## Related

- **`using-hq`** — the always-on discipline this skill builds on: current-state
  rewriting, editing scope (the canon-overwrite gate), index maintenance,
  wikilink resolution, before-every-commit checklist.
- **The spec** (`docs/vault-design.md`) → *Knowledge* (frontmatter schema and the
  belongs-here test) and *Subfolders* (the one-level subfolder rule).
- **`validate-vault`** — Test 4 (every knowledge file indexed, no orphans) and
  Test 3 (all wikilinks resolve), which merges and splits keep green.
- **`working-people`, `working-companies`** — the top-level entity registries of
  the individuals and organizations the vault refers to (peers of `knowledge/`,
  not subfolders).
