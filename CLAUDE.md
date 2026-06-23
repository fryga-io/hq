# Agent OS — Vault Rules

These are the generic operating rules for an AI-operated vault. They describe
how an agent reads, writes, and governs the vault regardless of which company
owns it. A consuming vault keeps its own `CLAUDE.md` that imports these rules
and adds company-specific instructions on top.

Everything identity-specific — company list, team roster, canon files — lives in
`hq.config.yml` at the vault root, not in these rules. Read that config to learn
who and what this vault is for. Tools find it by walking up from the working
directory until they reach the directory that contains `hq.config.yml`; that
directory is the vault root.

## The vault is the source of truth

The markdown files are the truth. Obsidian and the agent are two interfaces over
the same files; neither is authoritative.

External artifacts — a website, a blog, a tool, another repo — implement what the
vault states. The vault is authored first; decisions and content flow outward.
When an external artifact diverges from its vault file, the artifact is wrong:
fix it outward, never rewrite the vault to match. No vault file declares an
external repo as its source of truth.

## Session startup

At the start of every session, read the index files silently before responding:
`initiatives/index.md`, `knowledge/index.md`, `tasks/index.md`, `log/index.md`.
These give you the active context. Read other indexes on demand when the task
touches them.

## Progressive disclosure

Three layers, never more: `README.md` → `index.md` files → individual files. The
README is the map (navigational, points to indexes). Index files list the
contents of their folder. Individual files hold the content. Load deeper only
when the task needs it.

## Files describe current state with rationale; history lives in git

Files describe what is true *now* and the reasoning that supports it. When new
information arrives, rewrite the relevant body so it reflects the new truth and
the reasoning behind it. Do not append "Updates" / "Changelog" / dated
correction sections that preserve prior framings alongside the new one — that
produces incoherent documents where a future reader sees contradictory text and
must reconcile it.

Capture the WHY in the body prose, not in a dated appendix. Old framings,
including ones that were simply wrong, are removed during the rewrite; they do
not need a tombstone. Git diff, git log, and git blame are the audit trail.
Commit messages name what changed and why.

**The exception: log entries.** Files in `log/` are point-in-time records of
decisions, meetings, and observations. They are inherently dated and describe
the state of thinking at the moment they were written. Logs are not rewritten
when reality changes — a new log entry captures the new state. Knowledge and
initiative files are rewritten.

## Editing scope: stay inside the explicit ask

The vault is the company's source of truth. Every claim is load-bearing. A
"minor" adjacent word swap is a silent claim change.

**Rule.** For any edit to existing prose you weren't explicitly told to touch,
show the diff and ask before shipping.

- **Authorized edits go through.** When the operator named the change directly
  ("rewrite the Goal", "fix the column headings"), make it.
- **Adjacent edits pause.** Prose next to your authorized edit, prose that now
  reads inconsistently with it, prose with a claim you think is incomplete or
  stale — all stop at "I noticed X in [exact location] — propose Y, or leave?"
  Wait for the answer.

Failure modes this guards against: reconciling adjacent text to a new claim
(coherence bias); synthesizing a "missing" bullet the operator should infer
(helpfulness reflex); reporting done without reading your own diff back. Always
read your diff before claiming done; anything that doesn't trace to an explicit
instruction goes back to ask-mode.

## Before every commit, verify

1. **Indexes are current** — every file in `initiatives/`, `tasks/`,
   `knowledge/`, `log/` appears in its `index.md`.
2. **README "What's Active" is current** — every active initiative is listed.
3. **Frontmatter matches the spec** — see schemas in `docs/vault-design.md`.
4. **All wikilinks resolve** — no links to files that don't exist.
5. **Dashboard filters are consistent** — every `.base` file carries the
   `file.ext == "md"` guard as a minimum. View-specific `.base` files
   additionally filter by content type (e.g. a task dashboard also uses
   `file.hasTag("task")` and `!file.inFolder("templates")`).

Run `validate-vault` to check all of the above.

## When creating any file

1. Add frontmatter matching the template in `templates/`.
2. Update the relevant `index.md`.
3. If it's an initiative, add it to README "What's Active" when active.

## When changing the schema

1. Update the spec first (`docs/vault-design.md`).
2. Update the README conventions.
3. Update the templates in `templates/`.
4. Then update existing files.

## Conventions

- File naming: lowercase-kebab-case. Tasks are action-first
  (`draft-pilot-agreement.md`).
- Dates: YYYY-MM-DD always. Use the explicit `created` / `date` property.
- Links: `[[wikilinks]]` for internal connections, markdown links for external
  URLs.
- `company:` is a list-capable field — one handle or a list, all drawn from
  `hq.config.yml`.
- Status fields use small documented enums, never free text (see
  `docs/vault-design.md`).
