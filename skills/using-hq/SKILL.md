---
name: using-hq
description: "Use when working in an hq vault — any session whose working directory is under a directory containing hq.config.yml (an AI-operated company brain of markdown initiatives, tasks, knowledge, log, CRM, and content). Read at the start of work there, and before reading, creating, or editing any vault file."
---

# Using hq

You are operating an **hq vault** — an AI-operated company brain: a markdown vault
where the files are the source of truth and the agent and Obsidian are two
interfaces over them. These are the generic rules for any hq vault; the vault's
own `CLAUDE.md` adds company-specific policy on top.

**Identity lives in `hq.config.yml`** at the vault root — company list, team roster
(handles, initials), canon files, enum/CRM extensions. Read it before acting. You
find the vault root by walking up from the working directory to the directory that
contains `hq.config.yml`.

## The vault is the source of truth

The markdown files are the truth; Obsidian and the agent are interfaces over them,
neither authoritative. External artifacts — a website, blog, tool, another repo —
*implement* what the vault states; the vault is authored first and flows outward.
When an external artifact diverges from its vault file, the artifact is wrong: fix
it outward, never rewrite the vault to match.

## Session startup

Read the index files silently before responding: `initiatives/index.md`,
`knowledge/index.md`, `tasks/index.md`, `log/index.md`. Read other indexes on
demand when the task touches them.

## Progressive disclosure

Three layers, never more: `README.md` (the map) → `index.md` files (folder
contents) → individual files (content). Load deeper only when the task needs it.

## Current state with rationale; history lives in git

Files describe what is true *now* and the reasoning for it. When new information
arrives, rewrite the relevant body to reflect the new truth and why — do **not**
append "Updates" / "Changelog" / dated correction sections that preserve old
framings beside the new one. Old framings, even wrong ones, are removed during the
rewrite; git diff/log/blame are the audit trail, and commit messages name what
changed and why.

**Exception: `log/` entries** are point-in-time records (decisions, meetings,
observations). They are never rewritten when reality changes — a new log entry
captures the new state. Knowledge and initiative files are rewritten.

## Editing scope: stay inside the explicit ask

Every claim is load-bearing; a "minor" adjacent word swap is a silent claim change.
**For any edit to existing prose you weren't explicitly told to touch, show the
diff and ask first.**

- **Authorized edits go through** — when the operator named the change ("rewrite
  the Goal", "fix the headings"), make it.
- **Adjacent edits pause** — prose next to your edit, prose now inconsistent with
  it, or a claim you think is stale: stop at "I noticed X in [location] — propose Y,
  or leave?" and wait.

Guards against: reconciling adjacent text to your new claim (coherence bias);
synthesizing a "missing" bullet the operator should infer (helpfulness reflex);
reporting done without reading your own diff. Always read your diff before claiming
done.

## The schema

Frontmatter schemas, folders, enums, and conventions live in `docs/vault-design.md`
(in the hq plugin; the SessionStart hook gives its absolute path). Read it before
creating or editing any frontmatter — the per-type frontmatter blocks in that spec
are the canonical skeletons to copy. Status fields use the documented enums, never free text; `company:` /
`owner:` values come from `hq.config.yml`, and a vault may *extend* (never replace)
the default enum sets via `vault.enums`.

## Before every commit

1. **Indexes current** — every file in `initiatives/`, `tasks/`, `knowledge/`,
   `log/` (and any module folder that enumerates files) appears in its `index.md`.
2. **README "What's Active" current** — every active initiative listed.
3. **Frontmatter matches** `docs/vault-design.md`.
4. **All wikilinks resolve.**
5. **Dashboards consistent** — every `.base` carries the `file.ext == "md"` guard
   minimum; view bases add their content-type filter (e.g. `file.hasTag("task")`).

Run `/validate-vault` to check all of this.

## Creating a file

1. Frontmatter matching the type's schema in `docs/vault-design.md` — copy the
   per-type frontmatter block from there (the hook surfaces the spec's absolute path).
2. Update the relevant `index.md`.
3. If it's an initiative, add it to README "What's Active" when active.

## Changing the schema

Schema is OS-level — it lives in the plugin, not one vault, so propose changes
upstream rather than forking per vault. In the plugin: update `docs/vault-design.md`
first, then the README, then existing files.

## Conventions

- lowercase-kebab-case filenames; tasks action-first (`draft-pilot-agreement.md`).
- Dates `YYYY-MM-DD`, via the `created` / `date` property.
- `[[wikilinks]]` for internal links; markdown links for external URLs.
- `company:` is list-capable, drawn from `hq.config.yml`.

## Commands

- `/validate-vault` — full structural check (before every commit).
- `/dream` — maintenance: heal hygiene, surface drift, rank what's hot.
- `/add-to-library` — capture an external signal (URL, video, pasted text).
- `/weekly` — structured weekly rollup.
- `/hq-init` — scaffold a fresh vault (once, in an empty directory).
