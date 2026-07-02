# hq — Plugin Contributor Rules

This repo is the **hq** Claude Code plugin: the OS that operates an hq vault. It
is *not itself a vault* — it has no `hq.config.yml`, so the SessionStart hook does
not fire here. These rules govern agents working **on the plugin**, not inside a
vault.

The operating rules an adopter's vault runs on are **not** in this file — they
live in `skills/using-hq/SKILL.md` (the SessionStart hook injects them into every
vault session) and the schema lives in `docs/vault-design.md`. Treat each as the
single source of truth and never re-state it elsewhere; duplication is exactly
what makes rules go stale.

## Where each thing lives

- **How a vault is governed** → `skills/using-hq/SKILL.md`. Change vault rules
  here and nowhere else.
- **A module's operating faculty** (beyond creating items) → its capability skill
  `skills/working-<module>/SKILL.md`, **one per module**, loaded on demand;
  `using-hq` holds a resolver listing them all. `using-hq` keeps the cross-module
  always-on discipline; the schema stays in `docs/vault-design.md`. A capability
  skill **defers, never restates** — it points to `using-hq` for shared discipline
  and to the spec for schema, carrying only the module-specific operating layer.
  Adding a module means adding its `working-<module>` skill and a resolver line in
  `using-hq`.
- **The schema** (frontmatter, folders, enums) → `docs/vault-design.md`. Its
  per-type frontmatter blocks are the canonical skeletons agents copy. Change it
  first, then anything downstream (commands, skeleton).
- **A command** → the file in `commands/`. Keep identity and enums config-driven
  (read from the vault's `hq.config.yml`), never hardcoded.
- **The vault skeleton** `/hq-init` scaffolds → `skeleton/` (content-free).
- **Session-start injection / self-scoping** → `hooks/`.

## Repo layout

- `commands/` — slash commands: `/validate-vault`, `/dream`, `/add-to-library`,
  `/weekly`, `/hq-init`.
- `skills/` — `using-hq/` (vault operating rules, injected each vault session) plus
  one `working-<module>/` capability skill per module (loaded on demand).
- `hooks/` — `hooks.json` + the `session-start` script that injects `using-hq`
  only inside an hq vault (detected by walking up for `hq.config.yml`).
- `skeleton/` — the content-free vault skeleton `/hq-init` copies.
- `docs/vault-design.md` — the schema spec.

## Before committing

- `claude plugin validate .` must pass.
- Command and skill `description:` frontmatter values containing a colon **must be
  quoted** — an unquoted colon silently drops the description.
- Hook scripts (`hooks/session-start`, `hooks/run-hook.cmd`) must stay executable
  (`chmod +x`).
- No Fryga-specific or other private vocabulary in any file — examples must be
  invented (e.g. `example-co`), never lifted from a real vault.

See `CONTRIBUTING.md` for the full contribution workflow.
