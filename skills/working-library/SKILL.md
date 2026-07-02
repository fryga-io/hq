---
name: working-library
description: "Use when working with an hq vault's library beyond initial capture — researching what the library already covers, citing or cross-referencing library items from elsewhere in the vault, or removing, recategorizing, or restructuring existing items. Use whenever you touch library/ for anything other than running the add-to-library capture command."
---

# Working the library

The **library** is the optional hq module that stores external signals the
company consumes — articles, talks, reports, transcripts — each as its own file
holding the **raw source verbatim**. This skill is the faculty for *operating* an
existing library: finding what it already covers, citing it from the rest of the
vault, and keeping it consistent when you remove, recategorize, or restructure
items.

It does **not** cover initial capture (that is the `add-to-library` command) or
the frontmatter schema (that is `docs/vault-design.md` → *Library item*). Reach
for those when you need them; this skill is everything *after* an item exists.

## The one invariant: three surfaces, one slug

Every **flat** library item lives as three coupled surfaces that share a single
`<slug>`:

| Surface | Where | Holds |
|---|---|---|
| Item | `library/<slug>.md` | the **raw source**, verbatim, under `## Raw Content` (or `## Raw Transcript`) — never synthesis |
| Pointer | one line in `library/index.md` | `[[<slug>]] — one-sentence hook` — a thin table of contents, nothing more |
| Synthesis | one entry in `library/wiki.md` | multi-sentence analysis + cross-references — **all** analysis lives here |

The slug *is* the identity: the file basename, the index wikilink, and the wiki
wikilink are the **same string**. Every operation below preserves this three-way
identity, so `validate-vault` Test 7 (index ↔ wiki sync) stays green.

## Research what the library covers — read the WIKI

When checking whether the library already covers a topic — before writing a
`knowledge/` note, drafting content, or answering "what do we know about X" —
read **`library/wiki.md`**. The wiki is the synthesis layer: it holds the
analysis and the item-to-item cross-references, grouped by category, so it is the
real entry point into the library's thinking.

`library/index.md` is only a one-line table of contents. Do not judge relevance
from its hooks alone, and do not grep raw item bodies first — the wiki is where
the thinking is, and it is what tells you which items connect to which.

## Cite a library item from elsewhere in the vault

Reference an item the same way as any internal link: a **bare-slug wikilink**,
`[[<slug>]]`. Obsidian resolves wikilinks by basename regardless of folder, so a
`library/` item is linked exactly like anything else. Use `[[<slug>|readable
label]]` where the bare slug reads awkwardly in prose.

- The citation target is the **item file** (`[[<slug>]]`). Point at the wiki only
  when you specifically mean "our synthesis of this," via
  `[[library/wiki|Library Wiki]]`.
- Do **not** invent header-anchor links into individual wiki entries. Wiki items
  are bullets, not headings, so `[[library/wiki#some-item]]` does not resolve —
  link the item's own file instead.

## Remove an item

Removal touches all three surfaces **plus any inbound references** across the
vault:

1. Delete `library/<slug>.md`.
2. Remove its pointer line from `library/index.md`.
3. Remove its synthesis entry from `library/wiki.md`.
4. **Grep the whole vault for `<slug>`.** Other wiki entries, knowledge files, or
   initiatives may cross-reference it. Repair each hit: drop the dead
   `[[<slug>]]` and mend the surrounding sentence so no claim is left dangling.
5. Verify: no unresolved wikilinks remain (Test 3) and index ↔ wiki still match
   (Test 7).

Step 4 is the step that gets skipped — a removed item leaves dangling
`[[<slug>]]` links scattered wherever it was cited. Grep before you call it done.

## Recategorize an item

Move the **index pointer and the wiki entry together** under the new category
heading, so the two files stay parallel. The slug, the file, and its body are
unchanged. Moving only one of the two leaves the categories out of step even
though Test 7 still passes — keep the headings mirrored in both files.

## Restructure a cluster into a subfolder capture

When a coherent cluster grows large — every talk from one conference, a whole
report series — it earns its **own subfolder** `library/<capture>/` with its
**own `index.md`** that serves as both the local index *and* the local synthesis
(so a subfolder gets no `wiki.md` of its own). Then:

- The top-level `library/index.md` carries a **single** pointer to the sub-index
  (`[[library/<capture>/index|...]]`), not the individual items.
- The top-level `library/wiki.md` no longer synthesizes the sub-items; that
  synthesis moves into the sub-index.
- The sub-items become **exempt** from the top-level index ↔ wiki sync — Test 7
  checks them against their own sub-index instead.

The full subfolder rule — including index-*less* subfolders, which fold their
items back up into the top-level sync — is in `docs/vault-design.md` → *Library
subfolders*. Restructuring is a larger move; confirm with the operator before
splitting a cluster out.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Treating `index.md` as the research entry point | The **wiki** holds the synthesis and cross-references; the index is a bare TOC. |
| Inventing `[[library/wiki#item]]` anchor links | Wiki items are bullets, not headings — anchors do not resolve. Link the item file. |
| Removing an item but leaving its wiki entry (or vice versa) | Index ↔ wiki desync → Test 7 FAIL. |
| Removing an item without grepping for inbound `[[<slug>]]` refs | Dangling wikilinks elsewhere → Test 3 FAIL. |
| Writing synthesis or commentary into the item body | Raw stays raw; all analysis lives in `wiki.md`. |
| Condensing the source when capturing | The item body must hold the **full** source verbatim, never a summary. |

## Related

- **`add-to-library`** command — initial capture (URL / YouTube / pasted text) of
  a new item, keeping index and wiki in sync from the start.
- **`docs/vault-design.md`** → *Library item* (frontmatter) and *Library module*
  (the two-file pattern, subfolders, self-containment).
- **`validate-vault`** Test 7 — the index ↔ wiki sync check this skill keeps green.
