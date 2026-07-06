---
name: using-hq
description: "Use when working in an hq vault — any session whose working directory is under a directory containing hq.config.yml (an AI-operated company hub of markdown initiatives, knowledge, log, CRM, and content). Read at the start of work there, and before reading, creating, or editing any vault file."
---

# Using hq

You are operating an **hq vault** — an AI-operated company hub: a markdown vault
where the files are the source of truth and the agent and Obsidian are two
interfaces over them. These are the generic rules for any hq vault; the vault's
own `CLAUDE.md` adds company-specific policy on top.

**`hq.config.yml`** at the vault root is the marker: you find the vault root by
walking up from the working directory to the directory that contains it. Identity
— which companies are your own, who is on the team — is carried by the vault's own
`companies/` and `people/` registries and how notes link to them, not declared in
config. Config holds only what the vault can't derive or a dashboard validates:
canon pointers, enum/CRM extensions, and — only in a multi-company or
multi-operator vault — a short list naming those. Read it before acting; by default
it is nearly empty.

## The vault is the source of truth

The markdown files are the truth; Obsidian and the agent are interfaces over them,
neither authoritative. External artifacts — a website, blog, tool, another repo —
*implement* what the vault states; the vault is authored first and flows outward.
When an external artifact diverges from its vault file, the artifact is wrong: fix
it outward, never rewrite the vault to match.

## Session startup

Read **every** module's `index.md` silently before responding — the core
(`initiatives/`, `knowledge/`, `log/`) and every optional module the
vault has (`people/`, `companies/`, `library/`, `crm/`, `distillery/`,
`competitive/`, `sales/`, `operations/`). Indexes only — they are the map; load
individual files on demand.

## Response style

Apply the vault's rules silently — don't restate them. Cut ceremony: no "rules
loaded" / "here's what I see", no restating the vault's config, schema, or
identity back to the operator, no "about to read X" previews, no wrap-up recap
of what you just did. Do the work; let the diff and the result speak.

Keep reasoning that is load-bearing: an assumption the operator should get to
veto ("omitting `company:` — single-company vault; say if not"), an ambiguity, a
risk, or the rationale for a consequential edit. Surface it inline where you act,
not as an upfront preamble. Silence the homework, never the judgement.

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
are the canonical skeletons to copy. Status fields use the documented enums, never
free text. `company:` (multi-company vaults only) and `owner:` (multi-operator
vaults only) are omitted by default; where present they name your own companies and
a `people/` note. A vault may *extend* (never replace) the default enum sets via
`vault.enums`.

## Before every commit

1. **Indexes current** — every file in `initiatives/`, `knowledge/`, `log/` (and
   any module folder that enumerates files) appears in its `index.md`.
2. **README "What's Active" current** — every active initiative listed.
3. **Frontmatter matches** `docs/vault-design.md`.
4. **All wikilinks resolve.**
5. **Dashboards consistent** — every `.base` carries the `file.ext == "md"` guard
   minimum; view bases add their content-type filter (e.g. `file.hasTag("initiative")`).

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

- lowercase-kebab-case filenames; initiatives named for their subject (`hq-open-source.md`).
- Dates `YYYY-MM-DD`, via the `created` / `date` property.
- `[[wikilinks]]` for internal links; markdown links for external URLs.
- Relationships are `[[wikilinks]]` in prose; promote one to a frontmatter property only when a Bases dashboard queries it.
- `company:` — multi-company vaults only; list-capable, naming your own companies. A single-company vault omits it.

## Commands

- `/validate-vault` — full structural check (before every commit).
- `/dream` — maintenance: heal hygiene, surface drift, rank what's hot.
- `/add-to-library` — capture an external signal (URL, video, pasted text).
- `/weekly` — structured weekly rollup.
- `/hq-init` — scaffold a fresh vault (once, in an empty directory).

## Capability skills

Every module has a **capability skill** — the per-module operating know-how,
loaded on demand when you work that module (the always-on discipline above still
applies, and the schema still lives in the spec). Reach for the one matching your
work.

**Core:**
- `working-initiatives` — work checklists, status moves, archive, split.
- `working-knowledge` — promote a note to canon, merge/split notes.
- `working-log` — capture a decision; the log-vs-knowledge call.

**Entity registries:**
- `working-people` — add/update a person node; node-vs-CRM-contact routing.
- `working-companies` — add a company node; wire project backlinks.

**Optional modules:**
- `working-library` — research, cite, remove, restructure items (past `/add-to-library`).
- `working-crm` — advance a stage, log a touch, reconcile the index.
- `working-distillery` — draft, run the review panel, bank, wire a channel.
- `working-competitive` — record a move, re-grade threat, positioning.
- `working-sales` — append prospects, reconcile totals, read a playbook.
- `working-operations` — file a report, run a checklist, report-vs-audit.
