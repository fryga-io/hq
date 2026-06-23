---
description: "Interactive onboarding for a fresh hq vault. Interviews the operator for identity (companies, team roster, a one-line description), copies the content-free seed skeleton into the current directory (its empty index.md/wiki.md stubs and dashboards), and writes a personalized hq.config.yml, CLAUDE.md, and README.md. Produces a clean, empty, personalized vault that passes /validate-vault with zero errors. No example content, no vault-local templates (those live at the plugin root)."
---

Onboard a new hq vault in the **current working directory**. This is an
interactive command: it interviews the operator for the vault's *identity*
(companies, team, a one-line description), then scaffolds a clean, **empty,
personalized** vault by copying the content-free skeleton at
`${CLAUDE_PLUGIN_ROOT}/skeleton/` and writing the three identity files
(`hq.config.yml`, `CLAUDE.md`, `README.md`) from the answers.

This is the **structure stage**: it produces identity + structure only. It does
**not** draft any real content (first initiatives, knowledge, library items) —
that is a separate, later guided step. Leave the vault empty but valid.

## Step 1: Refuse if already initialized

Walk up from the current working directory through every ancestor directory
(the same search `validate-vault` uses to find the vault root). If **any**
directory in that chain — including the CWD itself — contains `hq.config.yml`,
**stop** and report, naming the exact directory where it was found:

```
Already inside a vault (hq.config.yml found in <ancestor-path>). hq-init
refuses to nest or overwrite an initialized vault. Run /validate-vault to check
its health, or delete hq.config.yml first if you intend to re-scaffold.
```

Do nothing else. This guard makes the command idempotent and prevents a nested
second vault from corrupting `validate-vault`'s root discovery.

## Step 2: Interview the operator

Interview the operator for the **identity** the config seam needs. This is the
only place the new vault gets personalized — capture identity, not content. Do
**not** ask about initiatives, knowledge, or library items; guided content
drafting is a separate later step.

Ask in one conversational pass (accept sensible defaults, and let the operator
add more entries where the field is a list):

1. **Companies** — one or more. For each: the **display name**
   (e.g. "Northwind Logistics") and a **lowercase-kebab slug**
   (e.g. `northwind`) used in `company:` frontmatter. Offer a slug derived from
   each name; let the operator override. The first company entered is the
   default. Most vaults start with one; allow several.
2. **Team members** — one or more. For each: **name** (e.g. "Sam Diaz"),
   **handle** (lowercase, used in `owner:` frontmatter, e.g. `sam`; offer one
   derived from the name), and **initials** (used to sign dated log entries,
   e.g. `SD`).
3. **One-line description** — a single sentence describing what the company
   does (e.g. "Freight brokerage for regional carriers"). This is light brand
   identity, used in the README's intro line. Keep it to one line; do not probe
   for strategy, positioning, or any content.

Confirm the collected values back to the operator before scaffolding.

## Step 3: Scaffold the structure from the seed skeleton

The skeleton at `${CLAUDE_PLUGIN_ROOT}/skeleton/` is the canonical structure.
It is already **content-free** — every `index.md` is an empty-but-valid stub,
`library/wiki.md` is an empty-but-valid stub, and there are no example entry
files. So this step is a straight **copy**: you do not strip anything.

Copy the skeleton's structure into the working directory:

- Every child directory of the seed and its files — the index-bearing content
  folders (currently `initiatives/ tasks/ knowledge/ log/ library/ crm/
  distillery/ competitive/ sales/ operations/`, each with its empty `index.md`;
  `library/` also carries the empty `library/wiki.md`) and the non-index utility
  folders (currently `dashboards/` with its `.base` views). Copy these
  directories and all their files verbatim.

Derive the folder set from what the seed actually contains rather than
hardcoding a list — that way folders added to the skeleton later are picked up
automatically.

**Exclude the skeleton's own instance files.** Do **not** copy
`${CLAUDE_PLUGIN_ROOT}/skeleton/hq.config.yml`, `skeleton/CLAUDE.md`, or
`skeleton/README.md`. You regenerate those three from the interview answers in
the next steps.

**Do not create a vault-local `templates/` folder.** Templates are canonical at
the plugin root; the vault reads them from `${CLAUDE_PLUGIN_ROOT}/templates/`
when adding real entries. The skeleton ships no `templates/` folder, and neither
should the scaffolded vault. (`validate-vault`'s Test 6 resolves templates from
the plugin root.)

After this step the working directory holds the empty content folders, the
dashboards, and nothing else yet — no instance files.

## Step 4: Write hq.config.yml

Write `hq.config.yml` at the vault root, populated from the interview answers.
Model it on `${CLAUDE_PLUGIN_ROOT}/skeleton/hq.config.yml` (keep the
explanatory comments — they teach the adopter how the seam works), but drop the
PLACEHOLDER-STARTER comment block since this vault is now personalized. List
every company under `companies:` and every team member under `team:`:

```yaml
# hq.config.yml — the seam that makes this vault generic.
#
# Every command reads this file. Tools find it by walking up from the working
# directory until they hit a directory containing hq.config.yml (the way `git`
# finds `.git`). That directory is the vault root.

# Companies this vault operates for. `company:` frontmatter must be one of these
# handles (or a list of them). The first entry is the default.
companies:
  - <slug>            # <Company Name>
  # ...one line per company

# Team roster. Frontmatter `owner:` must be one of these handles.
# `initials` sign dated entries in file bodies (e.g. "2026-06-22 (SD): ...").
team:
  - handle: <handle>
    name: <Member Name>
    initials: <INITIALS>
  # ...one block per team member

vault:
  # Canon files: load-bearing source-of-truth documents this vault treats as
  # authoritative. validate-vault confirms each declared canon file exists.
  # Empty to start — add files here as the vault grows its source-of-truth set.
  canon: []
  # link_whitelist: []   # optional: folders whose external/site-relative links
                         # are intentional published-site URLs (e.g. a verbatim
                         # copy of the live site). dream's link-integrity check
                         # skips these folders entirely. Default: absent/empty.

  # enums:               # optional: EXTEND (never replace) the OS-default enum sets.
  #   pipeline: []       #   extra CRM pipeline stages (e.g. [scored, nurturing])
  #   content_status: [] #   extra distillery content statuses (e.g. [scheduled, planned])
  #   log_type: []       #   extra log types (e.g. [retro])
                         # validate-vault accepts OS_defaults ∪ your list per enum.

  # crm:                 # optional: extra tags that mark a CRM file's type, so a
  #   company_tags: []   #   per-motion vault can tag companies by motion
  #   contact_tags: []   #   (e.g. company_tags: [company, outbound-lead]).
                         # Effective set is {company}/{contact} ∪ your list.
```

Leave `vault.canon` as an empty list (`[]`). A fresh vault has no canon files
yet, and `validate-vault` checks that every declared canon file exists — so an
empty list is the only value that passes on day one. The operator adds canon
entries (e.g. `knowledge/company-canon.md`) once those files exist. Keep
`link_whitelist` commented out (absent) — a fresh vault has no published-site
copy to whitelist.

## Step 5: Write the vault README.md

Write `README.md` at the vault root — the navigational map. Model it on
`${CLAUDE_PLUGIN_ROOT}/skeleton/README.md` but with the operator's identity:
the primary company name in the title, the one-line description in the intro,
and an **empty** "What's Active Right Now" section (no initiatives exist yet).
It must link to each core folder's `index.md` so every folder is reachable from
the README (progressive disclosure / README-accuracy check):

```markdown
# <Company Name> HQ

<One-line description>. The markdown files are the source of truth; Obsidian and
the agent are two interfaces over them.

Identity (company list, team roster, canon files) lives in `hq.config.yml`.

## Navigation

<one bullet per folder you actually scaffolded in Step 3 — see "Derive the
Navigation list" below; do not hardcode this list>

## Conventions

- lowercase-kebab-case filenames; action-first for tasks.
- Every file has YAML frontmatter with `tags` and `title`. See the schemas in
  the OS spec (the hq plugin's `docs/vault-design.md`).
- Status enums, never free text. Tasks: `backlog | todo | doing | blocked | done
  | cancelled`. Initiatives: `active | paused | completed | abandoned`.
- `[[wikilinks]]` for internal links; markdown links for external URLs.

## What's Active Right Now

_No active initiatives yet. Add one with the hq initiative template, then
list it here._

## Maintenance

Run `/validate-vault` to check vault health (indexes, wikilinks, frontmatter
enums, dashboard guards).
```

Where `<Company Name>` is the **primary** (first) company entered. If multiple
companies were entered, the title uses the primary one; the full company list
lives in `hq.config.yml`.

**Derive the Navigation list.** Do **not** hardcode the bullets. Walk the folders
you actually scaffolded in Step 3 and emit **one bullet per folder that has an
`index.md`** (plus a `dashboards/` bullet if that folder was copied). This keeps
the README from ever linking to a folder that isn't there or omitting one that
is — if a module is dropped from the skeleton, its bullet simply isn't emitted.
For each scaffolded folder, use the one-line description from this reference table
(omit the row for any folder you did not copy):

| Folder | Bullet |
|---|---|
| `initiatives/` | `- [[initiatives/index\|Initiatives]] — strategic efforts` |
| `tasks/` | `- [[tasks/index\|Tasks]] — active work items, rolled up by initiative` |
| `knowledge/` | `- [[knowledge/index\|Knowledge]] — company-owned thinking and references` |
| `log/` | `- [[log/index\|Log]] — decisions, meeting notes, observations` |
| `library/` | `- [[library/index\|Library]] — external signals (raw content + synthesis wiki)` |
| `crm/` | `- [[crm/index\|CRM]] — companies, contacts, pipeline data` |
| `distillery/` | `- [[distillery/index\|Distillery]] — the content pipeline (channels + content)` |
| `competitive/` | `- [[competitive/index\|Competitive]] — market and competitor intelligence` |
| `sales/` | `- [[sales/index\|Sales]] — sales playbooks and sourcing lists` |
| `operations/` | `- [[operations/index\|Operations]] — runbooks, checklists, reports, audits` |
| `dashboards/` | `` - `dashboards/` — Obsidian Bases views over the vault `` |

Order the bullets to match the skeleton's order (core folders first, then optional
modules, `dashboards/` last). The core folders (`initiatives/`, `tasks/`,
`knowledge/`, `log/`) are always present.

## Step 6: Write the vault CLAUDE.md

Write a **minimal** `CLAUDE.md` at the vault root by copying
`${CLAUDE_PLUGIN_ROOT}/skeleton/CLAUDE.md` and substituting the **primary**
(first) company name for `<Company Name>` in the title.

Do **not** write the operating rules into it. They are **not** a per-vault copy:
they load every session from the plugin's `using-hq` skill (injected by hq's
SessionStart hook), so they update centrally and never go stale — a per-vault
copy would drift the moment the OS evolves. CLAUDE.md carries only what is
genuinely vault-specific: a human-facing header (for someone reading the repo on
GitHub, who never sees the hook's injected context) and an empty section for
company-specific policy. For reference, the result is:

```markdown
# <Company Name> HQ — Agent Rules

This is **<Company Name> HQ**, an hq vault. It runs on the **hq** plugin, which
supplies its operating rules, schema, and conventions each session via the
`using-hq` skill (injected by hq's SessionStart hook). If they did not load (for
example the plugin is not installed), invoke the `using-hq` skill manually.

Identity — companies, team roster, canon files, enum/CRM extensions — lives in
`hq.config.yml` at the vault root.

## Company-specific instructions

(None yet — add policy here that is specific to this company and is not part of
hq itself. The generic rules stay in the plugin so they update centrally and
never go stale.)
```

## Step 7: Verify and report

Confirm the scaffolded vault is valid. Run the checks from `/validate-vault`
against the new vault (from the vault root — the current directory). All tests
must PASS with zero errors. Report:

- The companies and team members you scaffolded.
- The resulting tree (the empty content folders, the dashboards, and the three
  identity files — and confirm there is **no** vault-local `templates/` folder).
- That every `index.md` (and `library/wiki.md`) is empty-but-valid (frontmatter
  + intro, no dangling wikilinks).
- The `validate-vault` result.

If any check fails, fix the scaffold and re-verify before reporting done.
