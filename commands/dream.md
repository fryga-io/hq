---
description: "Run a maintenance cycle over the vault — surface where the brain has drifted out of sync, heal mechanical hygiene, and rank what's hot. Four phases: lint (auto-fix mechanical hygiene), contradict (detect-only drift/contradiction detection), consolidate (promote durable log signal), salience (rank what's hot). Config-driven: discovers canon from hq.config.yml plus each file's self-declaration; Obsidian CLI optional. Cuts a dream/YYYY-MM-DD branch, never writes to main."
---

Run a maintenance cycle over the vault — surface where the brain has drifted out
of sync, heal mechanical hygiene, and rank what's hot.

This command is config-driven: it reads the canon list from `hq.config.yml` and
discovers each file's self-declared canon — nothing here is hardcoded to a
particular company or filename. Every check is decidable from plain markdown; an
Obsidian CLI, if present, is an enhancement, never a requirement.

**Mental model.** The vault's knowledge is not derived from logs. Knowledge files
(`knowledge/`, `initiatives/`) are edited directly, often automatically, during
conversations. Those edits are partial: a conversation rewrites the canon and
leaves the satellites that restate it lagging behind. So the dominant failure is
**intra-knowledge drift** — a satellite file still says "three pillars" while the
canon now says "three bets". The cycle's main job is to *detect* that drift and
hand the operator ready-to-apply fixes — not to silently rewrite load-bearing
prose. Promoting log signal into knowledge is a secondary safety net. Runs on
demand; never unattended (v1).

## Step 0: Resolve the vault root and load config

Find the vault root by walking up from the working directory until you reach a
directory that contains `hq.config.yml` (the way `git` finds `.git`). Run all
checks relative to that directory. If no `hq.config.yml` is found, stop and
report: `No hq.config.yml found above the working directory; cannot locate the
vault root.`

Read `hq.config.yml` and extract:

- `vault.canon` — the list of **declared canon files** (load-bearing
  source-of-truth documents). These are authoritative by declaration.
- `companies` and `team` — only needed if a phase normalizes a `company` or
  `owner` enum (lint).
- `vault.link_whitelist` (optional, may be absent) — a list of folders whose
  external / site-relative links (`/blog/…`, `/careers`, `/`) are intentional
  published-site URLs, not vault wikilinks. Links inside these folders are never
  treated as unresolved, never repaired, never reported. If the key is absent,
  the whitelist is empty (the default — the core OS ships no such folders).

## Invocation

`/dream [phase] [--dry-run] [--interactive]`

- `/dream` — run all four phases in order
- `/dream <phase>` — one phase only. Phases: `lint`, `contradict`, `consolidate`, `salience`
- `/dream --dry-run` — report what each phase *would* do; touch nothing, commit nothing
- `/dream --interactive` — checkpoint with the operator after each phase's findings, before that phase commits. Decisions get applied in-run (including judgment items contradict would otherwise only report), each recorded in the report's *Needs your call* section as resolved. Authority rules below still bind the non-interactive default.

## Harness — do this first, every run

1. **Cut a branch from `main`** (`git checkout -b dream/YYYY-MM-DD main` — works even when `main` is checked out in another worktree; pull first if the checkout is clean and a remote exists). If the branch exists, append `-2`, `-3`. When testing the command from a feature branch that already contains `main`, branching from the current HEAD is acceptable — note it in the report. **Never write to `main`.** On long runs (especially `--interactive`), re-check `main` before the final commit — the operator may have pushed mid-cycle; merge and reconcile before handing back. The cycle's writes (lint fixes, the report, the salience dashboard) land on this branch; the operator reviews via `git diff main...dream/YYYY-MM-DD` and merges when satisfied.
2. **Find the watermark.** The most recent dated file in `dream/` is the watermark. `consolidate` only considers `log/` entries dated *after* it. **If `dream/` is empty (first run), scan the entire `log/` history** — a bounded first run would strand older un-promoted entries forever (the watermark only moves forward).
3. **Run phases in order**, committing after each: `lint`, `contradict`, `consolidate`, `salience`. Commit-per-phase preserves partial progress and keeps each diff reviewable alone.
4. **Write the report** to `dream/YYYY-MM-DD.md` (see format) and commit it.
5. **Hand back**: one-paragraph summary + counts + "review branch `dream/YYYY-MM-DD`, merge when happy." Do not merge yourself.

Under `--dry-run`, do none of the writes above: cut no branch, commit nothing, edit no file. Report what each phase *would* do — the lint fixes it would apply, the paste-ready fixes contradict found, the promotions consolidate would make, the salience ranking — and leave `git status` clean.

## Discovering canon — config plus self-declaration

Canon is **discovered, never assumed.** Two sources, unioned:

1. **Declared in config** — every file listed under `vault.canon` in
   `hq.config.yml`.
2. **Self-declared** — any file whose body declares itself the canon / source of
   truth for its scope (e.g. an opening line like "This is the declared canon
   file" or "Other files defer to this; when one diverges, this file wins").
   A file can also name *another* file as its canon ("Acme's buyer per
   [[company-canon]]"); that names the authority for the claim, it does not make
   the citing file canon.

Build the canon set from both before contradict runs. Do **not** infer canon
from a filename pattern — there is no fixed `*-canon.md` convention to rely on.
The config list plus self-declaration is the whole source.

## Authority — what writes, what only proposes

The cycle does three different things with three different permission levels. Keep
them straight.

- **lint auto-fixes mechanical hygiene** on the branch — indexes, unambiguous links, frontmatter enums, `.base` guards, determinate dated-appendix folds. Deterministic, low-stakes, reviewable in the diff.
- **consolidate auto-writes only *new, additive* knowledge** that clears both gates — never overwrites or rewrites an existing claim. Rare (see Phase 3).
- **contradict never writes to vault content.** It is detect-only. It emits **copy-paste-ready fixes** for the operator to apply, and routes genuine decisions to *Needs your call*. Reconciling an existing load-bearing claim is the operator's to apply, not the cycle's to guess.

Two hard rules across all phases:

- **Canon is the source of truth *by declaration*** — the discovered canon set (config `vault.canon` plus each file's self-declared canon). Determinate fixes reconcile satellite → canon. **Do NOT use git commit recency to decide which file is authoritative.** Recency measures when text churned, not when a claim was decided — a satellite touched yesterday for a typo is not "fresher truth," and a canon claim untouched for a month is not stale. When the canon's declared authority plus the content itself don't settle which side is right, it is a judgment item, not a determinate fix.
- **Never write dated appendices.** No `## Update`, `## Changelog`, `as of <date>` sections. Weave new truth into current-state prose; git is the history. Fold any *existing* dated appendix you encounter into current-state prose (lint).

## Phase 1 — lint (deterministic, auto-fix)

Run the `validate-vault` checks, then **fix** the mechanical failures:

- Regenerate stale `index.md` entries so every file in `initiatives/`, `tasks/`, `knowledge/`, `log/`, and (if present) `library/` appears in its index. (The `dream/` folder is output-only and intentionally not indexed — never add it to any index.)
- Repair dangling wikilinks where the target is **unambiguous** (2+ candidates → leave it, report it). **Whitelist:** links inside any folder listed in `vault.link_whitelist` (config) are intentional published-site URLs (e.g. site-relative `/blog/…`, `/careers`, `/`) in verbatim repo copies — never "unresolved links," never repair, never report. If the config declares no whitelist, this exception is empty.
- Sync README "What's Active Right Now" to current `status: active` initiatives.
- Normalize frontmatter that drifts from the schema in `docs/vault-design.md` (enum typos, deterministically-fillable required fields). Validate `company`/`owner` values against `companies`/`team` in the config.
- Fold dated appendices into current-state prose. Detect by scanning every `## ` heading for a literal `Update`/`Changelog`/`Progress` word OR a date (`## 2026-05-19 …`, `as of <date>`). Fold only the determinate ones; route judgment-laden ones (load-bearing positioning) to *Needs your call*. (Does not apply to `log/`, which is inherently dated.)
- Verify `.base` guard filters are consistent (`file.ext == "md"`, `_templates`/`templates` excluded).

Report counts fixed per category; ambiguous breakage → *Needs your call*.

## Phase 2 — contradict (detect-only, the main event)

Cross-read `knowledge/` + `initiatives/` for claims that disagree, have drifted from the canon, or gone stale. **Writes nothing to vault content.** Classify every finding into exactly one of three buckets:

- **Paraphrase-drift — determinate fix.** Same idea, stale wording the canon settles (e.g. "three pillars" → "three bets"). Emit a **copy-paste-ready fix** in the report: exact `file:line`, the old text, and the replacement text, so applying it is a paste. You do not apply it.
- **Contradiction — judgment.** A satellite asserts something the canon *refuses* (e.g. a "build-new" claim when canon says "What's out: build-new"), or two files genuinely disagree on a decision. Describe both sides, cite both `file:line`, route to *Needs your call*. Do **not** pick a winner — a contradiction is a decision, not a typo.
- **Staleness.** A `status: active` initiative with no git activity touching it in 3+ weeks. Flag in *Needs your call* (it may be live work happening off-git — the operator's call to pause).
- **External-artifact drift is not a contradiction.** The vault is the truth; external repos implement what the vault states (vault-design principle 8). When an external artifact (site, blog repo) diverges from its vault file, the artifact is wrong: emit a *fix outward* chore (update the repo to match the vault), never rewrite the vault file to match the repo, and never classify the divergence as a vault contradiction.

The drift-vs-contradiction split is the whole discipline: only drift earns a paste-ready fix; contradictions and staleness are always the operator's to decide.

## Phase 3 — consolidate (demoted — additive safety net)

Promote durable signal out of the log before it's lost. **This rarely fires** — logs get folded into knowledge by hand during conversations, so the dominant drift is intra-knowledge (Phase 2), not un-promoted log signal. Consolidate exists for the delivery stretch where the canon goes unmaintained and logs pile up.

**Inputs:** `log/` after the watermark. Never read `dream/` or `.base` dashboards as signal. Apply **both gates**:

- **Age gate** — skip anything younger than **3 days** (let it settle).
- **Evidence gate** — require **≥2 corroborating mentions** across separate sources. One-offs stay in the log.

Signal clearing both gates is woven in as **new, additive** content (a new `knowledge/` file with proper frontmatter + index entry, or a genuinely new section). **Consolidate never overwrites or rewrites an existing claim** — that's reconciliation, which is Phase 2's detect-only territory. Anything that fails a gate stays put; note why in the report.

## Phase 4 — salience (deterministic, no LLM)

Score active content and regenerate the `dream/salience.md` "What's hot" dashboard. Deterministic inputs only:

- **Recency** — most recent git commit touching the file. (Measure against `main`, not the dream branch, so this cycle's own lint edits don't inflate a file's score: `git log -1 --format=%ct main -- <file>`.)
- **Backlink density** — inbound link count. If an `obsidian` CLI is available, `obsidian backlinks file="<name>"` is exact. **Fallback (always works):** grep the vault for `[[<basename>]]` wikilink targets and count the files that reference each candidate file.
- **Status weight** — `active`/`doing` over `paused`/`backlog`; `completed`/`abandoned`/`done`/`cancelled` excluded.

Rank, write the top slice into `dream/salience.md` and the report. No prose edits to vault content.

## Self-consumption guard

The `dream/` folder is **excluded from every phase's inputs.** The cycle never reads its own output (reports, salience) as signal — that creates feedback loops. `dream/` is output only; intentionally not in any `index.md`, and excluded from `validate-vault`'s index/orphan checks.

## Report format — `dream/YYYY-MM-DD.md`

```
# Dream cycle — YYYY-MM-DD

Branch: dream/YYYY-MM-DD · Watermark: <prev report date | "first run, full history">
Phases run: lint, contradict, consolidate, salience

## lint
<counts fixed per category; ambiguous items deferred>

## contradict
### Determinate fixes (paste-ready)
<file:line · replace «old» → «new»>
### Contradictions & staleness → Needs your call
<file:line ↔ file:line, the disagreement / the stale initiative>

## consolidate
<promotions: what → file, age, mentions> · <deferrals + reason>

## salience — what's hot
<ranked top slice>

## Needs your call
<contradictions, staleness, and any judgment-laden item with no determinate fix>
```

## Optional: Obsidian CLI enhancement

If an `obsidian` CLI is available in this environment, you may use it to sharpen
the link-graph data: `obsidian unresolved` for dangling links (lint),
`obsidian backlinks file="<name>"` for exact backlink counts (salience), and
`obsidian eval` for frontmatter queries. It is an enhancement, not a requirement
— every phase above is decidable from the plain markdown files alone (grep
wikilinks for link integrity, count inbound `[[basename]]` references for
backlink density, `git log` for recency), so the command runs the same with or
without Obsidian installed.

If you do use the CLI, strip the stderr noise lines ("Loading updated app
package", "installer is out of date") from its output before processing, and note
that the CLI reads the *registered* vault, not the current worktree or branch —
its link-graph data is only trustworthy when the working branch matches the
registered checkout's content. If the dream branch has diverged, fall back to the
filesystem (grep) for anything the diff touches.

## Red flags — STOP if you catch yourself

- About to commit to `main` → wrong. Cut the dream branch.
- Auto-rewriting an existing knowledge/initiative claim to resolve drift → wrong. contradict is detect-only; emit a paste-ready fix for the operator to apply.
- Picking a winner on a contradiction (a satellite asserting what the canon refuses) → wrong. That's a decision → *Needs your call*.
- Using git commit recency to decide which file is authoritative → wrong. Recency is churn, not authority. Canon is authority by declaration; unclear cases are judgment items.
- Assuming canon from a filename → wrong. Discover it from `vault.canon` plus self-declaration.
- consolidate overwriting an existing claim → wrong. It only adds new, gated, additive knowledge.
- Promoting a single mention or a <3-day-old entry → wrong. Gates: age ≥3d AND ≥2 mentions.
- Writing a `## Update`/changelog/"as of" section → wrong. Weave into current-state prose.
- Reading a prior `dream/` report as input → wrong. Self-consumption guard.
- Adding `dream/` to an index → wrong. It is output-only, intentionally unindexed.
- Bounding the first run to "recent" log → wrong. First run scans all history.
- Skipping the `dream/YYYY-MM-DD.md` report → wrong. The report is the audit trail.
</content>
</invoke>
