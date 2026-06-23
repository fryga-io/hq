# Vault Design

The single source of design for an hq vault. What each scope is, how it
works, and the schema and conventions that hold it together. If a folder, file
type, or workflow is not described here, it does not belong in the vault until
it is.

This spec covers the **core** vault: `initiatives/`, `tasks/`, `knowledge/`, and
`log/`. Optional modules layer on top, each documented here: the **library**
(external-signal capture) under "Library module", and **CRM**, **distillery**
(content pipeline), **competitive**, **sales**, and **operations** under "Optional
modules". Every module is content-free in the skeleton — an index stub plus the
schema below; a module's folder exists in a vault only once it is used.

## Purpose

A central operational hub for a company. Two consumers share the data:

- **People** read and write through Obsidian (dashboards, search, graph view).
- **Agents** (Claude Code) read raw markdown and frontmatter directly.

Neither interface is the source of truth — the markdown files are.

## Identity lives in config, not in this spec

Everything specific to a particular company — the company list, the team roster,
the canon files — lives in `hq.config.yml` at the vault root, not in this spec.
This document describes the *mechanism*; the config supplies the *identity*.

Tools find the config (and thereby the vault root) by walking up from the working
directory until they reach a directory containing `hq.config.yml`, the way `git`
finds `.git`.

### `hq.config.yml` schema

```yaml
companies:                 # allowed values for the `company:` frontmatter field;
  - acme                   # first entry is the default. A file's company must be
  - acme-labs              # one of these (single value or list).

team:                      # the roster. `handle` is the allowed value for
  - handle: robin          # `owner:`. `initials` sign dated entries in file
    name: Robin Vega       # bodies (e.g. "2026-06-22 (RV): ...").
    initials: RV

vault:
  canon:                   # load-bearing source-of-truth files. validate-vault
    - knowledge/company-canon.md   # confirms each one exists.
  # link_whitelist: []    # optional. Folders whose external/site-relative links
                          # (/blog/…, /careers, /) are intentional published-site
                          # URLs, not broken wikilinks. Consumed by `dream`'s
                          # link-integrity check; absent/empty = nothing
                          # whitelisted (the default).
  # enums: {}             # optional. Extends (never replaces) the OS-default
                          # enum sets. See "Config-extensible enums" below.
  # crm: {}               # optional. Extra tags that mark a CRM Company or
                          # Contact. See "CRM motion typing" below.
```

### Config-extensible enums

The OS ships **default** enum sets for the controlled-vocabulary fields (a task's
`status`, a CRM `pipeline` stage, a content `status`, a log `type`, and so on). A
mature vault often runs a motion with stages the defaults don't name — a CRM that
scores leads before contacting them, a content pipeline that schedules posts ahead
of publish, a log that records retros. Rather than forcing every vault into the
default vocabulary, three of these enums are **config-extensible**: a vault
declares its extra values in `hq.config.yml`, and validate-vault accepts the union
of the OS defaults and the declared extras.

```yaml
vault:
  enums:
    pipeline: [scored, nurturing]                 # extra CRM pipeline stages
    content_status: [scheduled, planned, active]  # extra distillery content statuses
    log_type: [retro]                             # extra log types
```

The mechanism is **additive and per-enum**: the effective allowed set is
`OS_defaults ∪ vault.enums.<name>` (when the key is present). It never replaces or
narrows the defaults — a value is valid if it is an OS default **or** a declared
extra. The three extensible enums and their OS defaults are:

| Enum (config key) | OS default set | Applies to |
|---|---|---|
| `pipeline` | `researched`, `contacts-identified`, `connected`, `messaged`, `meeting`, `opportunity`, `disqualified` | CRM Company / Contact `pipeline` |
| `content_status` | `idea`, `draft`, `review`, `ready`, `published` | Content `status` |
| `log_type` | `decision`, `meeting`, `review`, `observation` | Log `type` |

The other enums (task `status`, initiative `status`, `priority`, CRM `grade`) are
**not** extensible — they are small, universal lifecycles where a vault-specific
value almost always signals a mistake. If a vault genuinely needs to extend one of
those, that is a design conversation, not a config line.

A value that is neither an OS default nor a declared extra is a FAIL. Declaring an
extra you don't use is harmless. Keep the declared sets minimal — the point is to
name the motion's real vocabulary, not to disable validation.

### CRM motion typing

validate-vault decides a file's **type from its `tags`**, not its folder (Design
Principle 4). The two CRM types are recognized by tag:

- a file is a **CRM Company** if its tags include any of
  `{company} ∪ vault.crm.company_tags`;
- a file is a **CRM Contact** if its tags include any of
  `{contact} ∪ vault.crm.contact_tags`.

A vault that runs several distinct motions often tags companies by motion rather
than with the generic `company` tag — e.g. an outbound-sales motion tags its
prospects `[crm, outbound-lead]` so a per-motion dashboard can filter them. Those
files are still CRM Companies; they validate against the CRM Company schema. Declare
the extra marker tags so validate-vault types them correctly:

```yaml
vault:
  crm:
    company_tags: [company, outbound-lead]  # tags (besides `company`) that mark a CRM Company
    contact_tags: [contact]                  # tags (besides `contact`) that mark a CRM Contact
```

The effective company-tag set is `{company} ∪ vault.crm.company_tags`; the contact
set is `{contact} ∪ vault.crm.contact_tags`. A motion may also carry
**motion-specific extra fields** on top of the common `grade`/`pipeline` spine
(e.g. `fit-score`, `account-tier`, `size-category`, `tier`). Extra frontmatter fields
are always allowed — the schema lists the *required* fields and a few common
optionals; any additional field is fine and is never flagged.

**Handles** go in frontmatter (`owner: robin`). **Initials** sign dated updates
in file bodies. Git is the source of truth for authorship; initials make
attribution visible inside Obsidian.

"The agent" in this doc means whichever team member's agent is editing — the
role, not a single instance.

## Design principles

1. **If it's not in the vault, it doesn't exist.** All operational knowledge,
   tasks, decisions, and strategic context live here.
2. **README is the map.** Short, navigational, points to indexes. The agent
   reads it first every session.
3. **Progressive disclosure.** README → index files → individual files. Three
   layers, never more.
4. **Tags for type, properties for attributes, folders for scope.** Don't mix
   these. A file's tag stays with its type even when the file moves into a
   sub-scope folder.
5. **The agent maintains indexes.** Every create/update operation includes an
   index update. Indexes don't rot.
6. **Two interfaces, same data.** People see dashboards via Obsidian Bases; the
   agent greps frontmatter. Same files underneath.
7. **Files describe current state with rationale; history lives in git.** When
   something changes, rewrite the body so it reflects the new truth and the
   reasoning that supports it. Do not append "Updates" / "Changelog" sections
   that preserve prior framings — that produces incoherent documents. The
   exception is `log/` (point-in-time records), which is inherently dated.
8. **The vault is the truth; everything else takes from it.** External repos (a
   site, a blog, a tool) implement what the vault states. Artifacts are authored
   and decided in the vault first and flow outward; when an external artifact
   diverges from its vault file, the artifact is wrong — fix it outward, never
   rewrite the vault to match. No vault file declares an external repo as its
   source of truth.

## Vault structure

```
<vault>/
  hq.config.yml                # identity: companies, team, canon
  README.md                    # map + conventions + "what's active now"
  CLAUDE.md                    # minimal: identity + company specifics (rules load from the plugin via the using-hq skill)

  # NOTE: templates/ lives at the plugin root (${CLAUDE_PLUGIN_ROOT}/templates/),
  # not inside the vault. Onboarded vaults carry no vault-local templates/ folder.
  # A vault may optionally mirror them locally, but it is not required or created by /hq-init.

  initiatives/
    index.md                   # all initiatives with status and company
    (flat .md files, one per initiative)

  tasks/
    index.md                   # active tasks rolled up by initiative
    (flat .md files, one per task)

  knowledge/
    index.md                   # knowledge articles by topic
    (flat .md files, organic growth)

  log/
    index.md                   # decisions, meeting notes, observations
    (flat .md files, YYYY-MM-DD-slug.md)
    weekly/                    # output-only: /weekly rollup reports
      YYYY-Wnn.md              # one report per ISO week

  library/                     # optional module: captured external signals
    index.md                   # thin one-line pointer per item
    wiki.md                    # synthesis layer over the items
    (flat .md files, one per captured source)

  dashboards/
    *.base                     # Obsidian Bases views over the vault

  dream/                       # output-only: /dream maintenance-cycle reports
    YYYY-MM-DD.md              # one report per cycle run
    salience.md                # "what's hot" ranking, regenerated each run
```

**Nesting rule:** keep folders shallow. Core content folders are flat — one file
per entry, no per-status or per-owner subfolders. Folders carry scope;
properties carry filtering attributes. A module folder may have **one level of
subfolders** when a module's volume or motion demands it (see "Subfolders" below);
deeper nesting is not a convention.

## Indexing modes

Every content folder is **discoverable** — you can reach every file in it from an
index, so nothing rots silently. There are two valid ways a folder makes its files
discoverable, and validate-vault (Test 4) accepts either:

**1. Wikilink-enumeration (the default, for small folders).** The folder's
`index.md` names every non-index file by wikilink, with a one-line description. The
index *is* the enumeration. This is how the core folders (`initiatives/`, `tasks/`,
`knowledge/`, `log/`) and small modules work. Test 4 requires every file to appear
in the index by wikilink.

**2. Bases-indexed (for large folders).** When a folder holds dozens or hundreds of
files, hand-maintaining a wikilink list is busywork that rots. Instead the folder
delegates enumeration to an Obsidian **Base**: the folder's `index.md` embeds or
links a `.base` dashboard (`![[x.base]]` or `[[x.base]]`), or the folder ships a
`.base` that enumerates it. The Base queries frontmatter and renders the full set as
a live table — always current, never hand-maintained. In this mode Test 4 does
**not** require every file to be wikilinked from `index.md`; it instead verifies the
referenced `.base` exists, parses as valid YAML, and carries the `file.ext == "md"`
guard. Items the index *does* wikilink explicitly must still resolve (Test 3).

A folder is treated as Bases-indexed when its `index.md` references a `.base` (by
embed or link) **or** the folder ships a `.base` that enumerates it. This is how a
CRM with hundreds of company files (`crm/index.md` embeds `pipeline.base`) and a
content pipeline with dozens of posts per channel (`distillery/index.md` references
`content-calendar.base`) stay discoverable without a thousand-line index. Large
folders index via Bases; small folders index via wikilinks. Pick per folder by
which one a human would actually keep current.

### Subfolders

A content folder may carry **one level of subfolders** — scope inside scope (a CRM
split by motion, a knowledge base split by audience, a conference's talks grouped
under one library subfolder). Two cases, both checked by Test 4:

- **Subfolder with its own `index.md`** → it is self-contained. Its items are
  checked against *its* index (in either indexing mode — wikilink-enumeration or
  Bases-indexed). The parent index need only point at the sub-index; it does not
  re-list the sub-items. Example: `knowledge/people/` and `knowledge/portfolio/`
  each carry their own `index.md`; `library/<conference>/` carries its own index
  that enumerates and synthesizes that conference's talks.
- **Subfolder without its own index** → its items fold up into the parent. They are
  expected in the **parent** folder's `index.md` (or surfaced via the parent's
  Bases mode). Example: `crm/companies/` and `crm/contacts/` carry no local index;
  every file in them is discoverable through `crm/index.md` (which is Bases-indexed).

The convention applies to any content module — most visibly `knowledge/` and
`library/` (subfolders with their own indexes), `crm/` (motion subfolders, no local
index, surfaced through the Bases-indexed `crm/index.md`), and `distillery/content/`
(per-channel subfolders, no local index, surfaced through the Bases-indexed
`distillery/index.md`).

## Folder reference

### `initiatives/`

Strategic efforts spanning weeks to months. One file per initiative. Each owns a
`## Goal`, `## Context`, and `## Key Results`. Tasks link to their parent
initiative via the `initiative` property — backlinks surface automatically on the
initiative page. Initiatives never store task lists in their body; Bases compute
that from frontmatter.

### `tasks/`

Discrete, actionable work items. Flat folder, one file per task, action-first
kebab-case filenames (`draft-pilot-agreement.md`). Status, priority, and owner
live in frontmatter. `tasks/index.md` is rolled up by initiative for human
reading; the `dashboards/*.base` files are how the agent and the team query
day-to-day.

### `knowledge/`

Company-owned thinking: strategy, domain knowledge, references, synthesis. The
test for what belongs here: a file is knowledge if it changes because we
**learned** something. If it changes because we **did** something — a report, a
runbook, a process checklist — it belongs in a function directory, not here.
This directory is for the thinking, not the doing.

Files describe current state with rationale; when something changes, rewrite the
body and let git carry the history.

Knowledge starts flat and may grow **one level of subfolders** when a coherent
sub-scope earns its own grouping (e.g. `knowledge/people/`, `knowledge/portfolio/`).
A knowledge subfolder carries its own `index.md` and is checked against it (see
"Indexing modes" → "Subfolders"); the top-level `knowledge/index.md` points at the
sub-index rather than re-listing its files.

### `log/`

Point-in-time decision and event record. One file per entry,
`YYYY-MM-DD-slug.md`, frontmatter `type: decision | meeting | review |
observation`. Logs are not rewritten when reality changes — a new entry captures
the new state.

### `library/` (optional module)

Captured external signals. Two maintained files — `index.md` (thin pointers) and
`wiki.md` (synthesis) — plus one flat `.md` file per source holding its full raw
content under `## Raw Content`. Written by `add-to-library`. Detailed in the
"Library module" section below.

### Optional modules (CRM, distillery, competitive, sales, operations)

Five further optional modules layer on the core, each detailed in the "Optional
modules" section below. They are content-free in the skeleton — every one ships
only an `index.md` stub; a module's folder appears in a vault once it is used, the
way `library/` does. Two of them (`competitive/`, `sales/`) reuse the Knowledge
schema — the folder carries the scope, the tag carries the type. The other three
introduce their own schemas (CRM Company/Contact, Channel, Content, Report).

### `dashboards/`

Obsidian Bases queries over the vault — open tasks, initiative overviews. Each
`.base` filters frontmatter, may compute formulas, and renders as a table. Every
`.base` carries `file.ext == "md"` as a minimum guard so non-markdown files
never leak into a view. View-specific `.base` files additionally filter by
content type: a task dashboard also uses `file.hasTag("task")` and
`!file.inFolder("templates")`.

### `templates/` (plugin root, not vault-local)

**Canonical templates live at `${CLAUDE_PLUGIN_ROOT}/templates/`, not inside the
vault.** Commands read templates from the plugin root. A vault onboarded via
`/hq-init` carries no vault-local `templates/` folder — the skeleton ships none,
and the command does not create one. A vault may optionally mirror them locally,
but the canonical set is always the plugin's.

Frontmatter templates for new files, one per type. Schema changes update
templates *after* updating this design doc (see "When changing the schema" in
`skills/using-hq/SKILL.md`).

### `dream/` (output-only)

Where the `/dream` maintenance cycle writes its output: one `YYYY-MM-DD.md`
report per run plus a regenerated `salience.md` "what's hot" ranking. It is
created on the cycle's first run; a vault that never runs `/dream` has no
`dream/` folder.

This folder is **output-only and intentionally not indexed.** Nothing in it is a
content file, so it carries no `index.md`, appears in no other index, and is
**excluded from `validate-vault`** — the index/orphan check (Test 4) skips it and
the README-reachability check (Test 7) does not expect its files to be reachable.
The cycle also never reads `dream/` as input (the self-consumption guard), so its
reports never feed back into a later run. Treat it the way `dashboards/` and
`templates/` are treated: a real folder the validator deliberately ignores.

### `log/weekly/` (output-only)

Where the `/weekly` command writes its output: one `YYYY-Wnn.md` rollup per ISO
week (e.g. `2026-W26.md`). Created on the command's first run; a vault that
never runs `/weekly` has no `log/weekly/` folder.

This subfolder is **output-only and intentionally not indexed.** Weekly rollups
are generated summaries of vault content, not authored log entries — they do not
belong in `log/index.md` alongside decisions and meeting notes. The subfolder
carries no `index.md` of its own, appears in no other index, and is **excluded
from `validate-vault`** — the index/orphan check (Test 4) skips `log/weekly/`
and the README-reachability check (Test 7) does not expect its files to be
reachable from the README.

## Frontmatter schemas

Every schema has at least frontmatter; required body sections are noted.

### Index

```yaml
---
tags: [index]
title: "<Folder Name>"
---
```

One per folder. Lists the files in that folder with one-line descriptions, plus
a short "what this folder is" intro. The agent maintains it.

### Initiative

```yaml
---
tags: [initiative]
title: "Launch Pilot Program"
company: acme                  # one of `companies` in hq.config.yml (list if shared)
status: active                 # active | paused | completed | abandoned
owner: robin                   # a team handle from hq.config.yml
started: 2026-06-05
target_date:                   # YYYY-MM-DD, optional soft deadline
---
```

Required body sections: `## Goal`, `## Context`, `## Key Results`.

### Task

```yaml
---
tags: [task]
title: "Draft the 90-day pilot agreement"
status: backlog                # backlog | todo | doing | blocked | done | cancelled
priority: 2                    # 1=high, 2=medium, 3=low
owner: robin                   # a team handle — the doer (accountable + executing)
company: acme                  # one of `companies` (list if shared)
initiative: "[[launch-pilot-program]]"  # wikilink, optional (empty for admin tasks)
due:                           # YYYY-MM-DD, optional
created: 2026-06-10
completed:                     # YYYY-MM-DD, filled when status → done
---
```

Required body sections: `## Context`, `## Done When`. **Owner = the doer** — one
person, accountable and executing collapsed. If the title says "Robin: design
drafts", `owner: robin`, not whoever delegated.

### Knowledge

```yaml
---
tags: [knowledge]
title: "Warehouse Robotics Market"
company: acme                  # one of `companies` (list if shared)
topics: []                     # required key, list type; may be empty ([])
source: ""                     # URL, optional
created: 2026-06-03
---
```

Minimal schema — the body does the work. When new findings arrive, rewrite the
body to reflect the new truth; do not stack dated updates inside the file. Git
captures the history.

### Log Entry

```yaml
---
tags: [log]
title: "Decision: paid pilot over free trial"
date: 2026-06-05
type: decision                 # decision | meeting | review | observation
---
```

Required body sections: `## Summary`, `## Details`, `## Outcome`. Filename
`YYYY-MM-DD-slug.md`.

### Weekly output file

```yaml
---
tags:
  - log
  - weekly
title: "Weekly — Week {{week_number}} ({{date_range}})"
week: {{iso_week}}         # e.g. "2026-W26"
date_start: {{monday}}    # YYYY-MM-DD
date_end: {{sunday}}      # YYYY-MM-DD
---
```

Files in `log/weekly/` are **output artifacts** generated by the `/weekly`
command, not authored content. They are exempt from the content-schema checks
(Tests 2–4) that apply to authored types (tasks, initiatives, knowledge, log
entries). However, `templates/weekly.md` is a template covered by Test 6: the
template must carry exactly the fields listed above (`tags`, `title`, `week`,
`date_start`, `date_end`).

### Library item

```yaml
---
tags: [library]
title: "The Real ROI of Warehouse Automation"
url: "https://example.com/article"  # source URL, empty ("") for pasted text
company: acme                  # one of `companies` (list if shared)
topics: []                     # required key, list type; may be empty ([])
created: 2026-06-12
---
```

Required body section: `## Raw Content`. The body holds the **full raw content
verbatim** — the fetched or pasted source text, never summarized or condensed.
This makes the vault self-contained: an agent reads what a source said without
re-fetching it. All synthesis, analysis, and cross-references go in
`library/wiki.md`, never in the item body. See the Library module below.

### CRM Company (module)

```yaml
---
tags: [crm, company]
title: "Northwind Logistics"
country:                       # optional
website: ""                    # optional
headcount:                     # optional
grade:                         # A | B | C | D — fit grade (optional until graded)
pipeline: researched           # researched | contacts-identified | connected | messaged | meeting | opportunity | disqualified
source: ""                     # where the lead came from
created: 2026-06-12
---
```

Filename `<name>-crm.md` in `crm/companies/`. Body grows organically — typically
`## Research`, `## Grade Rationale`, then a dated `## Interactions` history. A
vault may add its own pipeline-specific fields (e.g. a domain grade, a segment
tag); `grade` and `pipeline` are the common spine. The `-crm.md` suffix
disambiguates a prospect file from any later non-CRM file about the same company.

### CRM Contact (module)

```yaml
---
tags: [crm, contact]
title: "Sam Diaz (Northwind)"
company: "[[northwind-crm]]"   # wikilink to the CRM company file
role:                          # optional
linkedin: ""                   # optional
email: ""                      # optional
pipeline: connected            # same enum as CRM Company
source: ""
created: 2026-06-12
---
```

Filename `<firstname-companyshort>.md` (or full name) in `crm/contacts/`. Body:
`## Context`, then a dated `## Interactions` history. Links back to its company
via the `company` wikilink — the contact surfaces as a backlink on the company
page.

### Channel (module — distillery)

```yaml
---
tags: [channel]
title: "Company Blog"
channel_id: company-blog       # matches the `channel` value on content files
company: acme                  # one of `companies` (list if shared)
cadence: "2/week"
created: 2026-06-12
---
```

Lives in `distillery/channels/`. The body holds the channel's instructions:
voice, format, audience, tactical rules, the review panel, and any analytics
ingest process. `channel_id` is the key that content files reference.

### Content (module — distillery)

```yaml
---
tags: [content]
title: "Post title"
channel: company-blog          # a channel_id from distillery/channels/
pillar:                        # a content pillar declared for this vault
status: draft                  # idea | draft | review | ready | published
author: robin                  # a team handle from hq.config.yml
created: 2026-06-12
published_date:                # YYYY-MM-DD, filled on publish
url: ""                        # published URL, optional
cross_posted_from: ""          # wikilink to source content file, optional
impressions:                   # from analytics ingest, optional
engagements:
metrics_updated:               # YYYY-MM-DD when metrics last refreshed
---
```

Lives in `distillery/content/<channel_id>/`. Body is the full post text.
Filenames are `YYYY-MM-DD-slug.md` and must be unique across the vault — prefix
with a channel shorthand when the same topic ships to several channels. Pillars
are a small per-vault set declared in `plan.md` and the channel files; the OS
does not fix the pillar list.

### Report (module — operations)

```yaml
---
tags: [report]
title: "Uptime weekly — 2026-06-12"
company: example-co            # one of `companies` (list if shared)
runbook: "[[uptime-monitoring]]"  # wikilink to the runbook that produced it
created: 2026-06-12
---
```

Lives in `operations/<topic>-reports/`, filename `YYYY-MM-DD.md`. The body is
**produced by a user-supplied tool** — a script you point at the runbook's data
source. The OS ships the schema and the folder convention, not the tool. An agent
may append a dated, initialed interpretation section after the generated content.

## Conventions

### File naming

- **lowercase-kebab-case** always.
- **Tasks:** action-first (`draft-pilot-agreement.md`).
- **Log entries:** `YYYY-MM-DD-slug.md`.
- **No status in filenames.** Status lives in frontmatter.
- **No empty placeholder notes.** If there isn't enough context for a sentence,
  the file shouldn't exist.

### Dates

YYYY-MM-DD always. Use the explicit `created` / `date` property — never rely on
file ctime.

### Links

- **`[[wikilinks]]`** for internal vault connections. Display an alias when the
  basename is ugly (`[[launch-pilot-program|the pilot]]`).
- **Standard markdown links** for external URLs.
- **Property links** in frontmatter use the same syntax:
  `initiative: "[[launch-pilot-program]]"`.

### Status enums

Small, documented sets. Never free text. See the per-schema definitions above.

### Priority

Numbers (1/2/3), not text. Bases formulas render labels.

### Companies

Always a list-capable field: `company: acme` or `company: [acme, acme-labs]`.
The allowed values are the `companies` declared in `hq.config.yml`.

### Owners

Team handles only — the `handle` values from `hq.config.yml`. Never full names.
**Owner is the doer** — accountable and executing collapsed; one person per task.

### Signing dated entries

Inherently-dated records (log entries) include the operator's initials in their
dated lines: `2026-06-05 (RV): decided X`. The `initials` come from
`hq.config.yml`. Git is the source of truth for authorship; initials add
Obsidian-readable attribution. Knowledge and initiative files do not use dated
entries (see "Current state with rationale" below).

### Current state with rationale (not audit trail)

Knowledge and initiative files describe what is true now and the reasoning that
supports it. When something changes, rewrite the body — do not stack dated
"Updates" or "Changelog" sections inside the file. Git diff, log, and blame
carry the history; commit messages name what changed and why. This rule does not
apply to `log/` (a new log captures a new state).

## Library module

An optional module for capturing **external signals** — articles, reports, talks,
transcripts, conversations the company consumes. It is the one place the vault
stores someone else's words rather than its own. Knowledge files hold the
company's *thinking*; library files hold the *raw source* that thinking draws on.

The `add-to-library` command writes these files; if the module is unused, the
folder simply does not exist (the core vault is complete without it).

### The two-file pattern: index ↔ wiki

The module separates raw capture from synthesis across two maintained files:

- **`library/index.md`** — the thin pointer list. One line per item under a
  category heading: `[[slug]] — one-sentence hook`. It is a table of contents,
  nothing more.
- **`library/wiki.md`** — the synthesis layer. One multi-sentence entry per item
  under a category heading: what the item says, why it matters, cross-references
  to related library items and to the rest of the vault. All analysis lives here.
  Its frontmatter uses the Wiki schema: `tags: [wiki]` and `title`. Like an
  index, it is a maintained module file, not a content item.

**Every library item appears in BOTH files, and vice versa.** The index pointer
and the wiki entry are added together when an item is captured; an item in one
file but not the other is a desync (and a `validate-vault` FAIL). The individual
item file holds only raw content under `## Raw Content` — never synthesis.

### Library subfolders (a self-contained capture)

A large, coherent capture — every talk from one conference, a whole report series —
may live in its **own library subfolder** rather than scattered across the flat
library. A library subfolder carries its **own `index.md`** that both enumerates and
synthesizes its items: the sub-index doubles as the local index *and* the local
wiki for that capture, so a subfolder does not need (and does not get) its own
`wiki.md`. The top-level `library/index.md` points at the sub-index
(`[[library/<capture>/index|...]]`); it does not re-list the sub-items, and the
top-level `library/wiki.md` does not synthesize them — that synthesis lives in the
sub-index.

Validation (Test 8) follows the subfolder convention: a subfolder **with its own
index** is self-contained — its items are checked for discoverability against that
sub-index (Test 4), and are **exempt** from the top-level index↔wiki sync. The
top-level sync covers only the **flat** library items (those directly in
`library/`). A subfolder **without** its own index folds its items up into the
top-level `index.md`/`wiki.md` sets, where the normal sync applies (matched by
basename). A subfolder's own maintained files (a `playlist.md` watchlist, for
example) are module files like `wiki.md` — neither a synced item nor an unindexed
file.

### Self-contained: the body holds the full raw content

A library item's body is the **full source text, verbatim** — never summarized,
condensed, or rewritten. This is deliberate: the vault is self-contained, so an
agent can read exactly what a source said without re-fetching a URL (which may
have changed or gone dead). "Raw means raw." Synthesis of that content belongs in
`wiki.md`; the body stays untouched source.

See the **Library item** frontmatter schema above
(`tags: [library]`, `title`, `url`, `company`, `topics`, `created`).

## Optional modules

Five further optional modules layer on the core. Each is **content-free in the
skeleton** — it ships an `index.md` stub and nothing else; its folder appears in a
vault only once the module is used, exactly like `library/`. The agent maintains
each module's `index.md` the same way it maintains the core indexes. Two modules
(`competitive/`, `sales/`) reuse the Knowledge schema; the other three introduce
their own types (schemas above). Onboarding (`/hq-init`) copies whatever module
folders the skeleton carries, so adopters get them automatically.

### CRM module (`crm/`)

Pipeline data: the companies and people a sales motion tracks, with grades and a
dated interaction history. This is the *data* layer; the *how* of the motion lives
in `sales/`, and the strategic *frame* lives in knowledge.

- **`crm/companies/`** — one file per company, `tags: [crm, company]`, filename
  `<name>-crm.md`. Grade and pipeline stage live in frontmatter; the body holds
  research, grade rationale, and a dated `## Interactions` history.
- **`crm/contacts/`** — one file per person, `tags: [crm, contact]`, linked to a
  company via `company: "[[<name>-crm]]"`. The contact surfaces as a backlink on
  the company page.

A vault running several distinct motions may split companies into per-motion
subfolders (e.g. `crm/<motion>/`); the schema is the same and a motion may add its
own pipeline-specific fields on top of the common `grade`/`pipeline` spine
(extra fields are always allowed). A motion may also tag its companies by motion
rather than with the generic `company` tag (e.g. `[crm, outbound-lead]`) so a
per-motion dashboard can filter them; declare the extra marker tags under
`vault.crm.company_tags` so they type as CRM Companies (see "CRM motion typing").
A motion may extend the `pipeline` enum with its own stages via
`vault.enums.pipeline` (e.g. `scored` for a score-before-contact motion).

**The module is Bases-indexed.** With hundreds of company files, `crm/index.md` does
not hand-list them — it embeds a `pipeline.base` (at the module root, and/or one per
motion subfolder) that queries frontmatter and renders the full set as a live
stage/grade table. The motion subfolders carry no local index; every company and
contact is discoverable through the Bases-indexed `crm/index.md` (see "Indexing
modes"). A small CRM may instead wikilink-enumerate its items in `crm/index.md` —
either mode is valid.

### Distillery module (`distillery/`)

The content pipeline. Compiles company `knowledge/` (context) and `library/`
signals (raw material) into publishable content across channels. It is an output
layer with no intake of its own — both inputs already live elsewhere in the vault.

- **`distillery/channels/`** — one file per channel, `tags: [channel]`, declaring
  voice, format, audience, tactical rules, the review panel, and any analytics
  ingest. Each declares a `channel_id`.
- **`distillery/content/<channel_id>/`** — one file per draft or published piece,
  `tags: [content]`, filename `YYYY-MM-DD-slug.md`. Metadata and analytics in
  frontmatter; full post text in the body. Content folders are grouped by channel
  — a three-level exception to the shallow-folder rule, justified because channels
  are a fixed small set and content volume per channel is high.
- **`distillery/plan.md`** — singleton, `tags: [plan]`. Tracks cadence per channel
  and pillar coverage.

**The module is Bases-indexed.** `distillery/index.md` references a content
dashboard `.base` (e.g. `content-calendar.base` / `content-dashboard.base`) that
queries `tags: [content]` and renders the calendar and pipeline live, so the
per-channel content subfolders carry no local index and the index need not hand-list
every post (see "Indexing modes"). Channel files and the singleton `plan.md` are
maintained module files surfaced from `distillery/index.md` (and `plan.md` tracks
cadence). A content `status` may use the OS defaults or a vault's declared extras
(e.g. `scheduled`, `planned` via `vault.enums.content_status`). **The review panel**
("the ring") is a set of fresh-perspective reviewers defined per channel — each
grades a draft and iterates until the operator approves; different channels carry
different panels to match their audience. **Pillars** are a small per-vault set
declared in `plan.md` and the channel files; the OS does not fix the list.

### Competitive module (`competitive/`)

Market research, competitor profiles, and positioning intelligence — *intelligence
about others*, as distinct from the company's own synthesis in `knowledge/`. Feeds
strategy and differentiation work. Files use the **Knowledge schema**
(`tags: [knowledge]`): the folder carries the scope, the tag carries the type
(Design Principle 4). One flat `.md` file per landscape, deep dive, or research
artifact, all indexed in `competitive/index.md`.

### Sales module (`sales/`)

Playbooks and frameworks for the sales motion — how prospecting, outreach, and
conversations are run. The *how*; pairs with `crm/` (the *data*). Files use the
**Knowledge schema** (`tags: [knowledge]`). Raw sourcing lists (e.g. a prospect
list) also live here as prospecting input — they feed `crm/` once a prospect is
graded into a per-company file. Raw research material may live in a `raw/`
subfolder with its own index, created when first used. Playbooks and lists are
indexed in `sales/index.md`.

### Operations module (`operations/`)

Recurring operational work and operational reference: monitoring runbooks and the
reports they produce, recurring process checklists, snapshots of live assets, and
one-off audits. The *doing*, not the *thinking*. Distinct from `log/` (operations
and measurements, not human decisions) and from `knowledge/` (these change when
the *operation* changes, not when our *understanding* does).

Most files use the **Knowledge schema** (`tags: [knowledge]`) — runbooks,
checklists, snapshots, audits. **Reports** use the **Report schema**
(`tags: [report]`) and live in a per-topic subfolder `<topic>-reports/`, one file
per run (filename `YYYY-MM-DD.md`) with its own reverse-chronological `index.md`.

**Reports are produced by a user-supplied tool.** A runbook describes what is
monitored and how; a script the operator provides (pointed at the runbook's data
source) generates the report body. The OS ships the report *schema* and the folder
*convention* — it does not ship the monitoring tool itself. Runbooks, checklists,
and audits are indexed in `operations/index.md`; reports are indexed in their
subfolder's `index.md`.

## Linking strategy

1. **Tasks → initiatives** via the `initiative` property using a wikilink.
   Creates automatic backlinks on the initiative page.
2. **Knowledge cross-references** go in body text, not frontmatter.
3. **Never duplicate what Bases can compute.** Don't maintain task lists inside
   initiative notes.

## Workflows

### Knowledge updates (rewrite the body)

When a decision is made, a direction changes, or something is learned, rewrite
the relevant knowledge or initiative file so the body reflects the new truth and
the reasoning that supports it. Capture the WHY in the body prose, not in a dated
appendix. Commit messages explain what changed.

### Validation

Run `validate-vault` to check vault health: structure, frontmatter enums,
wikilinks, indexes, dashboard guards, schema/template alignment, README accuracy,
and — when the library module is present — library frontmatter and index↔wiki
sync. It resolves the vault root by walking up to `hq.config.yml` and validates
`company`/`owner` values against the config. Returns a PASS/FAIL table plus a fix
list. Run it before any non-trivial commit.

## Index maintenance

The agent maintains every `index.md` as part of create/update operations:

- `initiatives/index.md` — when initiatives are added or status changes.
- `tasks/index.md` — when tasks are added or status changes.
- `knowledge/index.md` — when the scope gains or loses files.
- `log/index.md` — when log entries are added.
- `library/index.md` **and** `library/wiki.md` — when a library item is added or
  removed (both files, kept in sync). Only present if the library module is used.
- `README.md` "What's Active Right Now" — when an initiative becomes active or
  stops being active.
