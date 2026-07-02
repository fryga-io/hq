---
name: working-distillery
description: "Use when operating an hq vault's distillery beyond a single first draft — drafting or shaping a content piece for a channel, running the review panel (\"the ring\"), banking a draft into a channel's buffer, citing library/knowledge as sources in a piece, checking what a channel already covers, or adding/wiring a new channel. Use whenever you touch distillery/ for anything past writing one paragraph."
---

# Working the distillery

The **distillery** is the optional hq module that compiles what the company
already knows — `knowledge/` (context) and `library/` (raw external signals) —
into publishable content across **channels**. It has no intake of its own: both
inputs already live elsewhere in the vault. This skill is the faculty for
*operating* an existing pipeline — shaping a draft, running it through the review
panel, banking it, and keeping a channel real — not for inventing the module or
its schema.

It does **not** cover the frontmatter schema (that is `docs/vault-design.md` →
*Channel* and *Content*) or library capture (that is the `add-to-library`
command). This skill is everything between "the inputs exist" and "the piece is
published."

## The flow: raw → draft → review → bank → publish

A content piece moves through fixed stages. Skipping a stage produces content
that *looks* finished but never passed the gate that makes it shippable.

| Stage | What happens | Where it lives |
|---|---|---|
| Raw | Source material already captured | `library/<slug>.md`, `knowledge/` |
| Draft | Bot shapes the piece in the channel's voice | `distillery/content/<channel_id>/YYYY-MM-DD-<slug>.md`, `status: draft` |
| Review | The ring grades and iterates until it passes (below) | a `## Ring Review` block in the body |
| Bank | A passed-but-unscheduled draft sits in the channel's buffer | `status: ready` (or a vault's `planned`/`scheduled` extra) |
| Publish | The operator publishes manually; metrics ingest later | `status: published`, `published_date` set |

Bot is the compiler, not the publisher. It reads context, follows the channel
file, drafts, and runs the ring. The operator approves and publishes by hand. A
draft Bot has finished is **banked**, not "the next post" — see *Buffer
semantics* below.

## Read the channel file first — it is the spec for the piece

Before writing a single line for a channel, read its definition in
`distillery/channels/<channel_id>.md`. The channel file carries everything that
makes a draft fit: **voice and format**, **audience**, **tactical rules**,
**anti-patterns**, the channel's **review panel**, and any **analytics ingest**
process. These are channel-specific and vault-specific — they are *not* in this
skill or the spec, by design. Two channels in the same vault routinely have
different voices, different anti-patterns, and different reviewer sets.

Anchor the voice to the **author profile** the channel points at (typically a
`knowledge/` file). Match that person's cadence, lexicon, and brand anchors —
draft in *their* voice, not a generic content-marketing register.

## Drafting model: where the idea originates

A channel declares **who originates the idea** and **how finished a draft is**.
Get this from the channel file; do not assume. The two failure modes:

- **Originator.** Some channels carry the company's published thinking (a blog,
  a brand page) — Bot may compile those from `knowledge`/`library`. Others carry
  **one person's own ideas only** — a personal feed where Bot *shapes a spark the
  person supplied*, never invents their opinions wholesale. On an
  originate-from-the-person channel, if you have no spark, ask for one (or use the
  channel's dry-buffer protocol); do not manufacture the founder's take.
- **Finishedness.** A draft is a *shaped draft destined for the buffer*, not a
  publishable final. The gate between them is the ring plus the operator's
  approval. Treating round one as final skips the load-bearing step.

## "Nothing repurposed" — check before you retell

A channel often forbids **repurposing**: the personal feed carries original
ideas, the brand page echoes the blog, and the same thesis must not be retold
across feeds it does not belong to. Before drafting, **grep existing content for
the thesis** — the same argument may already have shipped on another channel
under a different title. Cross-posting is explicit (the schema has
`cross_posted_from`); accidental retelling is a defect. When in doubt about
whether an angle is "already ours," check `distillery/content/` and `library/wiki.md`.

## The ring: the review gate, not a flourish

The ring is the distillery's quality gate. It is **not** a one-shot panel you
simulate once and move on — it is **iterative rounds**:

1. Run the draft past **every reviewer in the channel's panel**. Each grades the
   draft **0–10** with specific notes (strongest/weakest lines, where they drop
   off, what rings false for their persona).
2. Revise against the notes. Re-run. The combined average should climb.
3. **Gate:** stop only when the combined score is **8+** *and* the operator
   approves. Both conditions — a high score the operator rejects is not a pass.
4. Record the outcome as a `## Ring Review` block in the piece body, with the
   **score progression** across rounds, e.g.:

   ```
   ## Ring Review

   5 rounds: 6.67 → 7.5 → 7.83 → 8.17 → 8.25. Approved at 8.25/10.
   ```

The reviewers are **fresh-perspective personas defined per channel** — a
copywriter, a skeptic, representative members of the target audience. Each
channel's roster matches *its* audience; do not reuse one channel's panel on
another. If you draft and stop, or run a single pretend round, you have skipped
the faculty that the whole module exists to provide.

## Output conventions: one file, three blocks

Each piece is **one file** at
`distillery/content/<channel_id>/YYYY-MM-DD-<slug>.md`. Filenames are unique
across the vault — prefix the slug with a channel shorthand when the same topic
ships to several channels. The body carries the **full post text**, then two
trailing blocks:

- **`## Sources`** — where the piece came from, grouped:
  - **Library:** `[[<slug>]] — what it contributed` for each library item used.
  - **Knowledge / Channel:** `[[<file>]]` for context and the channel file.
  - **External:** bare URLs for anything cited that is not in the vault.

  Sources make the piece auditable and let you check coverage later. Cite library
  items as bare-slug wikilinks (`[[<slug>]]`) — Obsidian resolves by basename.
- **`## Ring Review`** — the score progression, as above. Present on any piece
  that has cleared the ring.

Metadata and analytics live in **frontmatter** (`status`, `pillar`, `author`,
`published_date`, `url`, `impressions`, …), never inline.

## Buffer semantics: a banked draft is not "the next post"

A draft that has passed the ring but has no `published_date` is a **banked buffer
item** — protection against a bad week, not a scheduled post. Channels often
require a **minimum buffer** (e.g. "≥ 2 ringed drafts at all times"). Treat the
buffer as a pool the operator draws from, not a queue with assigned dates.

- A **missed slot is a skip, not a debt** — there is no catching up. The next
  draft waits on the next slot. Do not double-publish to "make up" a gap.
- When the buffer thins, follow the channel's **dry-buffer protocol** (often:
  hand the operator a few specific questions pulled from their week; one answer
  seeds a draft) rather than padding with repurposed material.

## Adding a new channel

A channel is more than a file. Creating the file is the easy half; **wiring it
into the operating surfaces** is what makes the channel real. Five steps:

1. **Definition.** Create `distillery/channels/<channel_id>.md`, `tags:
   [channel]`, with the schema's required fields, then a body covering voice,
   format, audience, tactical rules, anti-patterns, and any ingest process.
2. **Content folder.** Create `distillery/content/<channel_id>/` for its pieces.
   (No local index — the module is Bases-indexed; see below.)
3. **Register it in the index.** Add a row to the **Channels table** in
   `distillery/index.md`. The index is the human-facing roster; a channel that
   exists only as a file is invisible.
4. **Define its ring panel.** A new channel needs its **own reviewer set** in its
   channel file — pick personas that match *its* audience. Channels do not share
   panels.
5. **Wire the dashboards and the plan.** The content dashboard and calendar
   `.base` files filter by `channel`; per-channel cadence views must be added (or
   the existing filters confirmed to pick the new `channel_id` up). Add the
   channel's **cadence and pillar coverage** to `distillery/plan.md`.

Skip steps 3–5 and the channel works for a single draft but is invisible to the
roster, has no review gate, and never appears on the calendar. Confirm a new
channel's cadence and panel with the operator before wiring — these are editorial
decisions.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Drafting and stopping (or faking one pretend ring round) | The ring is iterative rounds gated on combined 8+ **and** operator approval — that gate is the module's whole point. |
| Inventing the founder's opinions on an originate-from-the-person channel | Those channels shape a spark the person supplied; Bot does not manufacture their take. |
| Treating round one as publishable | A draft is a *shaped draft destined for the buffer*; the ring + approval is the gate to "ready." |
| Retelling a thesis that already shipped elsewhere | "Nothing repurposed" — grep existing content first; cross-posting is explicit via `cross_posted_from`. |
| Calling a banked draft "the next scheduled post" | An unscheduled passed draft is a buffer item, not a queued post; missed slots are skips, not debts. |
| Reusing one channel's voice/anti-patterns/ring on another | All three are per-channel and per-vault; read the target channel file every time. |
| Omitting the `## Sources` or `## Ring Review` block | Sources make the piece auditable; the Ring Review block records the gate was cleared. |
| Adding a channel file but not registering/wiring it | Unregistered → invisible to the roster; unwired → no review panel, absent from dashboards and plan. |

## Related

- **`add-to-library`** command — captures a raw external signal into `library/`,
  the upstream input this pipeline draws from. (There is no distillery-specific
  capture command; pieces are drafted by following the channel file.)
- **`docs/vault-design.md`** → *Channel* and *Content* (frontmatter), *Distillery
  module* (the channels/content/plan layout, Bases indexing, the ring and pillars
  as generic mechanisms).
- **`validate-vault`** — Test 1 (every `content/<channel_id>/` piece is
  discoverable), Test 2 (Channel/Content required frontmatter; content `status`
  enum; `author`, in a multi-operator vault, is a team handle), Test 3 (the `[[…]]` Sources links resolve).