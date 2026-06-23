---
description: "Generate the weekly rollup — a structured summary of the week's initiatives, tasks, decisions, and log entries, addressed to the team named in hq.config.yml."
---

Generate the weekly rollup for the vault.

## Step 0: Resolve the vault root and load config

Find the vault root by walking up from the working directory until you reach a
directory that contains `hq.config.yml`. If none is found, stop and report:
`FAIL — no hq.config.yml found above the working directory; cannot locate the
vault root.`

Read `hq.config.yml` and extract:

- `companies` — used to scope the rollup and for section headings where
  multiple companies share the vault.
- `team` — each member's `handle`, `name`, and `initials`. The rollup is
  written for this team; address the reader as "the team" unless the config
  specifies otherwise.

Run all subsequent file reads relative to the vault root.

## Step 1: Determine the week

Find the current ISO week number and date range (Monday–Sunday). Format:
`YYYY-Wnn` for the filename, e.g. `2026-W26`.

Check whether `log/weekly/YYYY-Wnn.md` already exists. If it does, **update**
it rather than creating a duplicate — re-gather the data, rewrite the sections,
preserve the frontmatter.

## Step 2: Gather data

Run these in parallel:

- `git log --format="%h %ad %s" --date=short --since=MONDAY --until=NEXT_MONDAY`
  from the vault root directory for commit history. Substitute the actual
  Monday and the following Monday's dates.
- Read all files in `initiatives/` (skip `index.md`). Note each initiative's
  `status`, `owner`, `company`, and any body changes since last week.
- Read all files in `tasks/` (skip `index.md`). Note status (`todo`, `doing`,
  `blocked`, `done`, `cancelled`), `owner`, `due`, and `initiative` linkage.
- Read all files in `log/` (skip `index.md` and the `weekly/` subfolder). Note
  any new entries added since Monday — type, title, date.
- If `knowledge/` has files newer than Monday (check `created` frontmatter or
  git history), note them.
- If the vault has a `library/` folder, check for items added since Monday.

## Step 3: Create the output directory if needed

If `log/weekly/` does not exist, create it. Do **not** create an `index.md`
inside it — `log/weekly/` is an output-only folder, intentionally unindexed
(see `docs/vault-design.md`).

## Step 4: Write the weekly

Create (or update) `log/weekly/YYYY-Wnn.md` using the template in
`${CLAUDE_PLUGIN_ROOT}/templates/weekly.md`. Fill every section from the gathered data. Writing
discipline:

- **Short sentences, active voice, no filler.** Every sentence carries a
  fact — a commit, a status change, a decision logged, a task completed.
- **Facts only, no editorializing.** Report what happened. Do not infer
  problems, blockers, or constraints from observations.
- **Attribute by handle.** Reference team members by their `handle` from
  `hq.config.yml`, not full names, unless a section warrants a full name.
- **No emojis. No jargon without context.**

### Section guidance

- **TL;DR:** 2–3 sentences. The headline — what a reader needs to know if they
  read nothing else. Cover the week's most significant moves across all active
  initiatives.
- **This Week's Theme:** One short paragraph. What tied this week together
  strategically? What shifted or was confirmed? If nothing shifted, say so
  plainly.
- **Weather Report:** Three bulleted lists — going well, going sideways, needs
  attention. Each bullet cites the specific initiative, task, commit, or log
  entry that grounds it. No speculation.
- **By Initiative:** One subsection per initiative (use the initiative `title`
  as the heading). Lead with the initiative's current status. Summarize what
  moved, what didn't, and what tasks are active/done/blocked under it.
  Group by `company` if the vault covers multiple companies.
- **Decisions:** List every new `log/` entry of `type: decision` from this
  week. Wikilink to each entry. If none, write "None this week."
- **Next Week:** Draw from tasks with upcoming `due` dates, initiative plans,
  and any explicitly queued work. List as bullets.
- **Blockers:** List only tasks or initiatives explicitly marked `status:
  blocked`. If nothing is blocked, write "None."

## Step 5: Commit

Stage and commit the new or updated weekly file. Do not stage unrelated files.
Commit message format: `weekly: YYYY-Wnn — <one-sentence summary>`.
