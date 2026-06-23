---
description: "Capture an external signal into the vault library. Takes a URL, a YouTube link, or pasted text; writes the raw content to library/<slug>.md, adds the synthesis entry to library/wiki.md, and adds the pointer to library/index.md — keeping index and wiki in sync. Config-driven: reads companies from hq.config.yml."
---

Add a new item to the vault **library** — the module that captures external
signals (articles, reports, talks, transcripts, conversations) the company
consumes. The user may provide a URL, a YouTube link, or paste raw text as an
argument.

This command is config-driven: it reads the `companies` list from
`hq.config.yml` — nothing here is hardcoded to a particular company.

## Step 0: Resolve the vault root and load config

Find the vault root by walking up from the working directory until you reach a
directory that contains `hq.config.yml` (the way `git` finds `.git`). Work
relative to that directory. If no `hq.config.yml` is found, stop and report:
`No hq.config.yml found above the working directory; cannot locate the vault
root.`

Read `hq.config.yml` and extract `companies` — the allowed values for the
`company` frontmatter field. The first entry is the default.

If the vault has no `library/` folder yet, create it with an empty-but-valid
`index.md` and `wiki.md` before proceeding (see the Library module in
`docs/vault-design.md` for the two-file pattern). Both files use a category
heading structure; an item is added under a category in each.

## Step 1: Determine source type and fetch raw content

- **Web URL**: Fetch the readable content with whatever web-fetch tool the
  operator has available in this environment — typically an MCP fetcher (e.g. a
  crawl4ai / readability MCP server). The OS does **not** bundle a fetch client;
  this path depends on the operator having one configured. Extract the article
  text (most such tools return a `markdown` field, sometimes wrapped in a JSON
  envelope or written to a temp file when large — read it in chunks if so). If
  the fetch fails (429, 403, timeout, empty result) or no fetch tool is
  available, STOP and tell the user — do not guess the content.
- **YouTube URL** (contains `youtube.com` or `youtu.be`): Extract the video ID
  and fetch the transcript with whatever transcript tool the operator has (e.g.
  the `youtube-transcript-api` Python library:
  `YouTubeTranscriptApi().fetch(video_id, languages=['en', 'pl'])`, then join the
  snippet texts into the full transcript). This path depends on the operator
  having such a tool; the OS does not bundle one. If unavailable, STOP and ask the
  user to paste the transcript.
- **Pasted text**: Use as-is. This is the **always-available path** — no external
  dependency. When in doubt, ask the user to paste the source.

If no argument is provided, ask the user for the source.

## Step 2: Create the library file

**Define the slug once.** The `<slug>` is the lowercase-kebab-case of the item's
title (e.g. "The Real ROI of Warehouse Automation" → `real-roi-of-warehouse-automation`).
This one slug is the file basename **and** the wikilink target used in both
pointers (Step 3), so the file, the index entry, and the wiki entry always match
(Test 7 checks this).

Filename: `library/<slug>.md`.

Frontmatter:

```yaml
---
tags:
  - library
title: "<descriptive title>"
url: "<source URL, or empty string for pasted text>"
company: <from config — see below>
topics: []
created: <today YYYY-MM-DD>
---
```

- **`company`**: use the `companies` from `hq.config.yml`. If the vault has one
  company, use it. If it has several, default to all of them (a list), or ask the
  operator which apply — never invent a value outside the config list.
- **`topics`**: ask the operator, or infer obvious tags from the content; an empty
  list `[]` is valid.

Under `## Raw Content`, paste the FULL fetched or provided text VERBATIM.

**NEVER summarize, edit, condense, or rewrite the raw content. Paste every word.**
If the output is long, that is correct. Raw means raw. (Synthesis goes in the
wiki, never in this file body.)

## Step 3: Update library/wiki.md and library/index.md (keep them in sync)

**`library/wiki.md`** is the synthesis layer. Read the current `wiki.md`. Add a
synthesis entry under the appropriate category heading (create a new category if
none fits):

- A multi-sentence summary of the item and why it matters. Title the entry so it
  resolves to this item's own `[[<slug>]]` (the same slug defined in Step 2), so
  the wiki and index point at the identical file basename.
- Cross-references to related library entries by their slugs (`[[other-slug]]`).
- Connections to the company's strategy and other vault files where relevant
  (e.g. a `knowledge/` item or an initiative).

Synthesis and analysis belong ONLY in `library/wiki.md` — never in the library
file body.

**`library/index.md`** is the thin pointer list. Add a one-line entry under the
**same category**, using the same `<slug>` from Step 2:

```
- [[<slug>]] — one-sentence hook
```

Keep both files in sync — every item in the wiki must have a matching pointer in
the index, and vice versa, both pointing at the `<slug>` that is the item's file
basename. (`validate-vault` Test 7 enforces this.)

## Step 4: Validate and commit

Run `validate-vault` (or at least its library checks) and confirm PASS — the new
item must appear in both `index.md` and `wiki.md`, and its frontmatter must match
the schema. Fix any FAIL before finishing.

Then commit the new library file plus the updated `index.md` and `wiki.md`
together, with a message naming the item added. (Push only if the operator's vault
tracks a remote and they want it pushed — the OS does not assume one.)
