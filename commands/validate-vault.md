---
description: "Validate the vault end-to-end. Checks structure, frontmatter enums, wikilinks, indexes, and dashboard guards against hq.config.yml. Reports PASS/FAIL per test with specifics."
---

Run a full validation of the vault and report results as PASS/FAIL with
specifics. It reads the canon files (and, in a multi-company or multi-operator
vault, the company/team lists) from `hq.config.yml` — nothing here is hardcoded to
a particular company.

## Step 0: Resolve the vault root and load config

Find the vault root by walking up from the working directory until you reach a
directory that contains `hq.config.yml` (the way `git` finds `.git`). Run all
checks relative to that directory. If no `hq.config.yml` is found, stop and
report: `FAIL — no hq.config.yml found above the working directory; cannot
locate the vault root.`

Read `hq.config.yml` and extract:

- `companies` (present **only in a multi-company vault**) — the allowed values for
  the `company` frontmatter field. Absent → this is a single-company vault: files
  carry no `company:`, and the company checks below do not apply.
- `team` (present **only in a multi-operator vault**) — the handles allowed as
  `owner`/`author`; each names a `people/` note carrying the person's initials.
  Absent → this is a solo vault: files carry no `owner:`, and the owner checks below
  do not apply.
- `vault.canon` — the list of declared canon files that must exist.
- `vault.enums` (optional) — per-enum lists of **extra** allowed values that extend
  the OS-default enum sets. Keys: `pipeline`, `content_status`, `log_type`. For each
  enum the effective allowed set is `OS_defaults ∪ vault.enums.<name>` (the union,
  never a replacement). Absent or empty = OS defaults only.
- `vault.crm` (optional) — extra tags that mark a CRM type. `company_tags` extends
  the CRM Company marker set; `contact_tags` extends the CRM Contact marker set. The
  effective company-tag set is `{company} ∪ vault.crm.company_tags`; the contact set
  is `{contact} ∪ vault.crm.contact_tags`. Absent = `{company}` / `{contact}` only.

Every check below compares vault contents against these config values, never
against a fixed list. The enum and CRM-tag extensions are documented in
`docs/vault-design.md` ("Config-extensible enums" and "CRM motion typing").

## Test 1: Structure integrity

- Does every expected **core** content directory exist? (`initiatives/`,
  `knowledge/`, `log/`) These are required.
- **Optional modules** (`library/`, `crm/`, `distillery/`, `competitive/`,
  `sales/`, `operations/`) are not required — a vault that does not use a module
  simply omits its folder. Do **not** FAIL on a missing optional module. But if a
  module folder is present, it must carry its `index.md` stub (and for
  `library/`, also `wiki.md`); a present module folder with no `index.md` is a
  FAIL.
- Does `README.md` exist at the vault root and serve as a navigational map
  (links to the index files)?
- Does each declared `vault.canon` file exist? Report any missing canon file as
  a FAIL.

## Test 2: Frontmatter consistency and required body sections

Read every `.md` file in `initiatives/`, `knowledge/`, `log/`, and (if
present) `people/`, `companies/`, `library/`, `crm/`, `distillery/`,
`competitive/`, `sales/`, `operations/`. Scan optional module folders recursively (their content lives in
subfolders — `crm/companies/`, `distillery/content/<channel_id>/`,
`operations/<topic>-reports/`). Skip every folder's `index.md` (Index schema) and
`library/wiki.md` (Wiki schema). Determine each file's **type from its `tags`
frontmatter field**, not from its folder — `competitive/`, `sales/`, and most
`operations/` files carry `tags: [knowledge]` and validate as Knowledge.

- Does every file have valid YAML frontmatter?
- Required fields by type (see `docs/vault-design.md` for the schemas):
  - **Initiative:** `tags`, `title`, `status`, `started` — plus `owner`
    (multi-operator) and `company` (multi-company).
  - **Knowledge:** `tags`, `title`, `topics`, `created` — plus `company`
    (multi-company). (`topics` is a required key of list type; an empty list `[]` is valid.)
  - **Person** (`tags` contains `person`): `tags`, `title`, `topics`, `created`.
    (`handle`, `initials`, `company` are optional — set only for a team member or in
    a multi-company vault.)
  - **Company** (`tags` contains `company` but **not** `crm`): `tags`, `title`,
    `topics`, `created`. (`company` is optional; set only in a multi-company vault.)
  - **Log:** `tags`, `title`, `date`, `type`.
  - **Library:** `tags`, `title`, `url`, `topics`, `created` — plus `company`
    (multi-company). (`topics` is a required key of list type; an empty list `[]` is
    valid. `url` is required but may be an empty string `""` for pasted-text sources.)
  - **CRM Company** (`tags` contains `crm` **and any** of `{company} ∪
    vault.crm.company_tags`): `tags`, `title`, `pipeline`, `created`. (`grade`,
    `country`, `website`, `headcount`, `source` are optional — a vault may add any
    motion-specific fields; extra frontmatter fields are always allowed and never
    flagged.)
  - **CRM Contact** (`tags` contains `crm` **and any** of `{contact} ∪
    vault.crm.contact_tags`): `tags`, `title`, `company`, `pipeline`, `created`.
    (`company` is a wikilink to the company file; `role`, `linkedin`, `email`,
    `source` are optional.)
  - **Channel** (`tags` contains `channel`): `tags`, `title`, `channel_id`,
    `created`.
  - **Content** (`tags` contains `content`): `tags`, `title`, `channel`,
    `status`, `created` — plus `author` (multi-operator). (`pillar`,
    `published_date`, `url`, `cross_posted_from`, and the analytics fields are optional.)
  - **Report** (`tags` contains `report`): `tags`, `title`, `created`.
    (`company`, `runbook` are optional; report bodies are tool-generated.)
  - **Plan** (`tags` contains `plan`): `tags`, `title`. The distillery singleton
    (`distillery/plan.md`) that tracks cadence and pillar coverage; all other
    fields and the body are free-form.
- Enum validation. Three enums are **config-extensible** — the effective allowed
  set is the OS default below **∪** the matching `vault.enums.<name>` list (if
  present); flag a value only if it is in neither. The rest are fixed.
  - Initiative `status` ∈ `active | paused | completed | abandoned` (fixed).
  - Log `type` ∈ `decision | meeting | review | observation` **∪
    `vault.enums.log_type`** (extensible).
  - CRM `pipeline` (Company or Contact) ∈ `researched | contacts-identified |
    connected | messaged | meeting | opportunity | disqualified` **∪
    `vault.enums.pipeline`** (extensible) — e.g. a score-before-contact motion
    declares `scored`.
  - CRM Company `grade`, when present, ∈ `A | B | C | D` (fixed).
  - Content `status` ∈ `idea | draft | review | ready | published` **∪
    `vault.enums.content_status`** (extensible) — e.g. a scheduling pipeline
    declares `scheduled`, `planned`.
- Config-driven validation (applies only where the vault declares the list):
  - **If `companies` is declared** (multi-company vault): every **present**
    `company` value (single or list) is one of them. An absent or empty `company:`
    is valid — Person and Company nodes routinely leave it empty — so skip it; only
    validate present values. (CRM Contact's `company` is a **wikilink** to another
    vault file, not a company handle — exempt it from this check; it is validated as
    a wikilink in Test 3.) If `companies` is **not** declared (single-company vault),
    a `company:` field is not expected; do not check it.
  - **If `team` is declared** (multi-operator vault): every `owner` value is one of
    the team handles, and Content's `author` likewise. If `team` is **not** declared
    (solo vault), `owner`/`author` are not expected; do not check them.
- Required body sections by type (check for `##` headings in the file body):
  - **Initiative:** `## Goal` is required. `## To-dos`, `## Docs`, `## Context`,
    and `## Key Results` are optional — `## To-dos` is the conventional home for an
    active initiative's open work, but it is not hard-required (some initiatives
    track their work as `## Key Results`). A standing bucket carries just `## Goal`
    + `## To-dos`.
  - **Library:** the item must capture its source. Either a raw-material section
    (`## Raw Content` **or** `## Raw Transcript` — the full text or transcript
    verbatim, never a summary) **or**, for a book/binary source, a sibling source
    file stored alongside it (`library/<slug>.pdf` / `.epub` / `.mobi` / …) that the
    body references. Flag only an item that has neither.
  - **Knowledge / Person / Company / Log:** no required body sections. Knowledge,
    person, and company bodies are free-form; a log entry's sections fit its `type`
    — a decision, meeting, handoff, or observation each shape their own, so no
    fixed set is required.
  - **CRM Company / CRM Contact / Channel / Content / Report / Plan:** no required
    body sections (bodies grow organically or are tool-generated).
  Report any missing required heading as a FAIL, naming the exact file and
  missing section. Determine type from the file's `tags` frontmatter field.
  This check is decidable from plain markdown — no Obsidian CLI required.

## Test 3: Link integrity (wikilinks)

- Collect every `[[wikilink]]` target across all vault `.md` files (strip any
  `|alias` and any `#heading`). Ignore wikilink syntax shown inside inline code
  spans or fenced code blocks — Obsidian does not resolve those as links, so
  prose like "`[[wikilinks]]` for internal links" is not a broken link.
- Confirm each target resolves to a file that exists in the vault (match on
  basename, the way Obsidian resolves short links; allow an explicit path form
  like `[[folder/file]]`).
- Report every unresolved wikilink with the file it appears in. Any unresolved
  link is a FAIL.

## Test 4: Index accuracy

Every content file must be **discoverable** through an index, so nothing rots
silently. A folder makes its files discoverable in one of two valid **indexing
modes** (both documented in `docs/vault-design.md` → "Indexing modes"); detect a
folder's mode, then check it against the matching rule.

**Detecting the mode.** A folder is **Bases-indexed** if its `index.md` references a
`.base` (an embed `![[x.base]]` or a link `[[x.base]]`) **or** the folder ships a
`.base` that enumerates it. Otherwise it is **Wikilink-enumeration** (the default).

**Rule per mode:**

- **Wikilink-enumeration** — the folder's `index.md` must reference every non-index
  `.md` file in that folder by wikilink. Report any file present in the folder but
  missing from its index as a FAIL, naming the exact file and index.
- **Bases-indexed** — do **NOT** require every file to be wikilinked from
  `index.md`; the folder delegates enumeration to its dashboard. Instead verify the
  referenced `.base` (the one the index embeds/links, or the one the folder ships):
  it must exist, parse as valid YAML, and carry the `file.ext == "md"` guard (same
  check as Test 5). Items the index *does* wikilink explicitly must still resolve —
  Test 3 already covers that.

**One level of subfolders.** A content folder may have one level of subfolders.
Check each subfolder by its own structure:

- **Subfolder with its own `index.md`** → self-contained. Check its items against
  *its* index, in whichever mode that sub-index is in (wikilink-enumeration or
  Bases-indexed). Do **not** also require those items in the parent index.
- **Subfolder without its own `index.md`** → its items fold up into the parent. They
  are expected in the **parent** folder's `index.md` (or covered by the parent's
  Bases mode, if the parent is Bases-indexed).

Apply this to `initiatives/`, `knowledge/`, `log/`, and (if present)
`people/`, `companies/`, `library/` and every optional module. Notes and
exemptions:

- **`people/`, `companies/`** — top-level entity-registry modules, each
  wikilink-enumerated against its own `index.md` (every node listed once).
- **`knowledge/`, `library/`** — may carry subfolders with their own indexes (e.g.
  `library/<conference>/`); each is checked against its own sub-index per the
  subfolder rule above. In `library/`,
  treat `wiki.md` (and a subfolder's `playlist.md`-style watchlist) as maintained
  module files — neither expected in an index nor counted as unindexed. Library item
  ↔ wiki sync is checked separately in Test 7.
- **`crm/`** — typically Bases-indexed: `crm/index.md` embeds a `pipeline.base` and
  the company/contact subfolders carry no local index, so the companies and contacts
  are discoverable via the Base, not a hand-maintained wikilink list. A small CRM
  may instead wikilink-enumerate every `*-crm.md` and contact in `crm/index.md` —
  either mode passes. A per-motion subfolder that ships its own `pipeline.base` is
  Bases-indexed in its own right.
- **`distillery/`** — typically Bases-indexed: `distillery/index.md` references a
  content dashboard `.base`, and the per-channel content subfolders carry no local
  index. Channel files and `plan.md` are maintained module files (like
  `library/wiki.md`) — neither expected in the index nor counted as unindexed.
- **`competitive/`, `sales/`** — usually flat, wikilink-enumerated against the
  folder's `index.md`. A `sales/raw/` subfolder with its own `index.md` is checked
  against `sales/raw/index.md` per the subfolder rule.
- **`operations/`** — runbooks, checklists, snapshots, audits at the `operations/`
  root are indexed in `operations/index.md`. **Reports** live in a per-topic
  subfolder `<topic>-reports/` with its **own** `index.md`; each report is checked
  against that subfolder index per the subfolder rule.

**Output-only folders are never indexed** and must not be scanned or flagged:
`dream/` (the `/dream` cycle's reports and salience dashboard) and
`dashboards`. When scanning `log/`, skip the
`log/weekly/` subfolder entirely — weekly rollups (`log/weekly/YYYY-Wnn.md`) are
output-only generated summaries, not authored entries, and are not expected in
`log/index.md`. These conventions are documented in `docs/vault-design.md`.

## Test 5: Dashboard consistency

If the vault has any `.base` files (e.g. in `dashboards/`):

- Does each `.base` parse as valid YAML?
- Does each `.base` carry the `file.ext == "md"` guard filter? This is the
  minimum required guard; every `.base` must have it regardless of purpose.
- Are the filters logically consistent with the view's stated purpose?

Note: view-specific `.base` files conventionally add further filters on top of
the `file.ext == "md"` guard — for example, an initiatives dashboard typically also
carries `file.hasTag("initiative")`. This additional filter is not enforced by this
test but is expected in practice.

If the vault has no `.base` files, record Test 5 as PASS (nothing to check) — the
OS does not require dashboards.

## Test 6: README accuracy

- Does the README's "What's Active Right Now" list every initiative with
  `status: active`?
- Can every content file be reached within two hops from the README via the
  indexes (progressive disclosure)? Exclude output-only folders that are not
  content and intentionally unindexed: `dream/` (maintenance-cycle output),
  `log/weekly/` (weekly rollup output) and `dashboards`. Their files are not
  expected to be reachable from the README.

## Test 7: Library index ↔ wiki sync

Only if the vault has a `library/` folder (the module is optional — if absent,
record Test 7 as PASS, nothing to check).

The library module keeps two maintained files in lockstep: `library/index.md`
(thin one-line pointers) and `library/wiki.md` (the synthesis layer). Every
library item must appear in BOTH, by wikilink.

**Subfolders.** A library subfolder **with its own `index.md`** is a self-contained
capture: its sub-index doubles as the local index and synthesis (no per-subfolder
`wiki.md`), so its items are checked for discoverability against that sub-index in
Test 4 and are **exempt** from this top-level sync. A library subfolder **without**
its own index folds its items up into the top-level sets below (matched by
basename), where the normal sync applies. This convention is documented in
`docs/vault-design.md` → "Library subfolders".

- Collect the set of library item slugs three ways. The slug set is the **flat**
  library items plus the items of any index-less subfolder (matched by basename);
  items in a subfolder that has its own `index.md` are excluded (checked there
  instead).
  1. **Files** — every non-index `.md` file in `library/` (and in any index-less
     subfolder) except `wiki.md` and a subfolder's maintained module files (e.g. a
     `playlist.md` watchlist); basename without `.md`.
  2. **Index** — every `[[wikilink]]` target in `library/index.md`, excluding: the
     module files (`index`, `wiki`); links to a subfolder's own `index`
     (`[[library/<capture>/index]]`); and links that resolve to an item **inside** a
     self-contained subfolder capture. A self-contained capture is checked against
     its own sub-index (Test 4), so the top index may cross-reference a standout
     capture item without it counting as a top-level sync pointer.
  3. **Wiki** — every `[[wikilink]]` target in `library/wiki.md` that resolves to a
     **top-level** library item (a flat item, or an item in an index-less subfolder).
     Ignore links to module files, to items inside a self-contained subfolder capture
     (cross-references, exempt as above), and to other vault files (e.g. links to
     `knowledge/` items).
- These three sets must match. Report a FAIL for any mismatch, naming the slug
  and where it is missing:
  - An item file with no pointer in `index.md` → FAIL (unindexed library item).
  - An item file with no entry in `wiki.md` → FAIL (item missing its synthesis).
  - A pointer in `index.md` with no matching file → already caught as a broken
    wikilink in Test 3; also report here as an index/wiki desync.
  - A slug in `wiki.md` but not in `index.md` (or vice versa) → FAIL
    (index/wiki desync), naming which file omits it.

This check is decidable from plain markdown — collect basenames and wikilink
targets, compare the sets. No Obsidian CLI required.

## Report

Summarize results as a table: `Test | PASS/FAIL | Issues`. Then list the
specific fixes needed for any FAIL. Quote the exact file and field for each
issue so the fix is unambiguous.

## Optional: Obsidian CLI enhancement

If an `obsidian` CLI is available in this environment, you may use it to
cross-check link integrity (`obsidian unresolved`), orphans, and frontmatter
queries (`obsidian eval`). It is an enhancement, not a requirement — every test
above is decidable from the plain markdown files alone, so the command runs the
same with or without Obsidian installed.
