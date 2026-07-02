---
name: working-competitive
description: "Use when working with an hq vault's competitive module beyond initial research — recording a tracked competitor's new product, AI claim, pricing, or positioning move; re-grading a competitor's threat level; answering 'who are our real competitors' or 'what's our positioning'; or removing, merging, or restructuring existing competitor profiles. Use whenever you touch competitive/ for anything other than standing up a brand-new landscape artifact."
---

# Working the competitive module

The **competitive** module is the optional hq module that holds *intelligence
about others* — market landscapes, per-competitor profiles, deep dives, and
positioning analysis — as distinct from the company's own synthesis in
`knowledge/`. This skill is the faculty for *operating* an existing competitive
module: folding a competitor's latest move into the profiles that already track
them, re-grading threat, and answering positioning questions from the right
surface.

It does **not** cover standing up a brand-new landscape artifact, or the
frontmatter schema (that is `docs/vault-design.md` → *Competitive module*; these
files use the **Knowledge schema**, `tags: [knowledge]`). This skill is everything
*after* the module exists and a competitor is already profiled.

## The core habit: update in place, do not spawn a file

A competitor's new product launch, AI claim, pricing change, or repositioning is
**new information about an existing entity** — not a new research artifact. The
spec's "one flat `.md` per landscape / deep dive / research artifact" governs how
*new* artifacts are filed; it is silent on per-competitor updates because those
are **edits to the profile that already exists**.

So when a tracked competitor ships something:

1. Find the competitor's existing profile(s) — usually in the curated landscape
   and the master list (see below).
2. Update the relevant field **in place** — most often **AI claims**, sometimes
   **Positioning**, **Pricing**, or **Content**.
3. Re-grade threat (next section).

Spawning `acme-launch-2026.md` for a tracked competitor's move scatters the
intelligence and leaves the profile stale. A new flat file is justified only for
a genuinely new artifact — a fresh landscape pass, a deep dive into an
unprofiled cluster — not for an increment on someone already in the module.

## The two-file invariant: curated landscape + master list

Competitor profiles typically live in **two parallel surfaces that are not
auto-synced**:

| Surface | Holds | Tiering |
|---|---|---|
| **Curated landscape** (`competitive/<landscape>.md`) | the **Primary deliverable** — a hand-picked shortlist of profiles (often ~20), with market overview, positioning white-space, and inspiration notes | High / Medium / Inspiration |
| **Master list** (`competitive/<master-list>.md`) | the **full deduplicated roster** (can run to 100+ companies), source-keyed, one profile each | High / Medium / Low Threat |

A competitor profiled in both has **two profiles**, and editing one does **not**
touch the other. The cross-link is usually **one-directional** — the curated
landscape points into the master list (e.g. "Also referenced as a counter-example
in …"), but the master list does not point back. So an agent that updates only
the file it happened to open silently leaves the other stale.

When you update a tracked competitor, **check both surfaces.** If the competitor
appears in the curated shortlist and the master roster, fold the move into both,
and keep the cross-link line intact (or add it if the update raises the
competitor into the curated shortlist for the first time).

## Re-grade threat — do not just record the fact

Every profile carries a **Threat level** (High / Medium / Low) and **Threat
reasoning**. A new product, a new AI claim, or a pricing move can change where a
competitor belongs — a "records AI as a feature" shop that ships a named agentic
product may jump from Low/Medium to High.

After updating the fact, **reconsider the grade:**

- Re-read **Threat reasoning** against the new fact. Does the stored rationale
  still hold?
- If the grade changes, move the profile under the new tier heading **in every
  file it appears in**, and rewrite the reasoning to say why.
- If the grade holds, leave a one-line note in the reasoning so the next reader
  knows the move was considered, not missed.

Recording the fact while leaving the competitor under its old tier is the most
common silent error — the module looks updated but the threat map is wrong.

## The scope rule is a judgment call, not a formality

The master list usually states an **explicit scope rule** — for example, "product
companies and individual freelancers have been excluded; only consultancies/
agencies that compete on positioning are tracked." A **product launch** is exactly
the case that tests this rule:

- If the launcher is an **already-tracked consultancy** shipping a product →
  update its existing profile's **AI claims** (the normal in-place path).
- If the launcher is a **pure product company** with no profile → the existing
  files give it **no home**. Do not blindly append it to a roster whose scope
  rule excludes it. **Decide:** is this a positioning threat worth a tracked
  profile (which may mean amending the scope rule), or a market signal that
  belongs in `knowledge/` or the library instead? Surface the call to the
  operator rather than forcing it into the wrong file.

## Answer positioning questions from the right surface

"Who are our real competitors?" and "what is our positioning?" have a **curated**
answer that does not live in the rosters:

- The **rosters answer the wrong question.** A 100-row master list or a 20-profile
  landscape tells you *who exists*, not *who actually threatens us*. Reading "main
  competitors" off the roster over-counts.
- The **real-threats shortlist is asserted in `knowledge/`** — the strategy canon
  names the few genuine threats and why the rest are noise. That is the
  positioning answer.
- The **module entry point is `competitive/index.md`**, which flags the curated
  landscape as the **Primary deliverable**. Start there to find the right file;
  but for "who really threatens us," cite the canon, not the roster.

These are two different "canonical" surfaces — `index.md` is canonical for *which
file*, the strategy canon is canonical for *the answer*. Conflating them yields a
list of 100 "competitors" when the honest answer is three.

## Remove or merge a profile

Removing a competitor (acquired, defunct, out of scope) or merging a duplicate
touches **every surface the profile appears on, plus inbound references:**

1. Remove the profile from the curated landscape **and** the master list (and any
   deep dive that profiles it).
2. Update each file's profile **count** if its header states one (e.g. "N
   companies", "20 profiles").
3. **Grep the whole module — and the vault — for the competitor's name and slug.**
   The strategy canon, positioning notes, or other profiles' counter-positioning
   lines may cite it. Repair each hit so no claim dangles.
4. Verify: every flat file is still enumerated in `competitive/index.md` (Test 4)
   and no wikilink dangles (Test 3).

Step 3 is the step that gets skipped — a competitor named in the canon's
"real threats" line or in a rival's counter-positioning note outlives its profile.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Creating a new file for a tracked competitor's launch | A competitor's move is an **edit to its existing profile** (usually **AI claims**), not a new research artifact. New files are for new *artifacts*. |
| Updating one file, leaving the other stale | Profiles live in **two unsynced surfaces** (curated landscape + master list). The cross-link is one-directional, so editing one silently strands the other. |
| Recording the new fact but not re-grading | A new AI product can move a competitor between High / Medium / Low. Update **Threat level + Threat reasoning**, not just the fact. |
| Blindly appending a product company to the master list | The roster's **scope rule** excludes pure product companies. A product launch is the judgment call — decide (and surface it), don't force-fit. |
| Answering "main competitors" from the roster | The roster lists *who exists*. The **real-threats shortlist lives in the strategy canon**; cite that, not the 100-row list. |
| Treating `index.md` as the positioning answer | `index.md` is canonical for *which file is the deliverable*; the **canon** is canonical for *the answer*. Two different surfaces. |
| Removing a profile without grepping for inbound refs | The canon's threat line or a rival's counter-positioning note may name it → dangling reference, stale claim. |

## Related

- **No dedicated command.** The competitive module has no capture command; profiles
  are edited in place per this skill. Initial landscape research is freeform.
- **`docs/vault-design.md`** → *Competitive module* — the folder's scope, the
  Knowledge-schema rule, and the one-flat-file-per-artifact convention.
- **`validate-vault`** Test 4 (every flat file enumerated in `competitive/index.md`)
  and Test 3 (wikilinks resolve) — the checks this skill keeps green.