# hq

An open-source Claude Code plugin that turns a plain markdown vault into an
**AI-operated company brain** — initiatives, tasks, knowledge, a decision log, a
library of external signals, a CRM, a content pipeline, and more, all maintained
by agent commands. The markdown files are the source of truth; Obsidian and the
agent are two interfaces over them. Your content stays private; only the
*mechanism* (schema, agent rules, commands) is open.

## Plugin vs vault

`hq` is the plugin (the OS) you install; your **vault** is the company brain it
creates and operates — a directory of markdown you might call "Acme HQ". One
plugin, many vaults: install `hq` once, scaffold a vault per company.

## Install in Claude Code

`hq` is distributed through the **fryga** plugin marketplace. From inside Claude
Code:

```
/plugin marketplace add fryga-io/claude-marketplace
/plugin install hq@fryga
```

then restart Claude Code.

(Hacking on the plugin itself? The repo ships a dev marketplace — add your local
checkout with `/plugin marketplace add ./` and install `hq@hq-dev`.)

## Install in Codex

hq also runs under OpenAI **Codex** — any CLI recent enough to have the plugin
marketplace (i.e. the `codex plugin marketplace add` command used below). Codex's
plugin system is Claude-Code-compatible, so the same `using-hq` skill and the
SessionStart hook work there. From a checkout of this repo:

```
codex plugin marketplace add ./
```

Then open the plugin directory in Codex, install **hq**, and **trust its hook**:
run `/hooks` and trust the `SessionStart` hook so the vault rules load. Codex keys
trust to the hook's hash, so a release that changes the hook re-prompts `/hooks`.

With the plugin enabled and the hook trusted, starting Codex inside a vault loads
the `using-hq` rules automatically — the same self-scoped injection as Claude Code
(outside a vault, nothing loads). hq's slash commands are **Claude-only** for now;
in Codex, follow `skills/using-hq/references/codex-tools.md` for the equivalents.
The hook is verified on macOS/Linux; Windows under Codex is untested.

## Quick start

From the directory where you want your vault to live:

1. Run `/hq-init` — interactive onboarding. It interviews you for identity
   (companies, team roster, a one-line description), copies the content-free
   skeleton into the directory, and writes a personalized `hq.config.yml`,
   `CLAUDE.md`, and `README.md`. The result is a clean, empty, personalized
   vault.
2. Run `/validate-vault` — confirms structure, frontmatter enums, wikilinks,
   indexes, and dashboard guards are all green.

Then operate the vault day to day with the agent and these commands:

- `/add-to-library` — capture an external signal (URL, YouTube link, or pasted
  text) into the library, keeping the index and synthesis wiki in sync.
- `/dream` — a maintenance cycle that heals hygiene, flags drift and
  contradictions, promotes durable signal, and ranks what's hot.
- `/weekly` — generate a structured weekly rollup for your team.
- `/validate-vault` — re-run any time before a commit.

## How it's organized

The plugin ships:

- `commands/` — the agent commands above.
- `skills/using-hq/` — the vault operating rules (session startup, schema
  pointers, editing discipline, conventions). The single source of truth for how
  an agent governs a vault.
- `hooks/` — a SessionStart hook that injects `using-hq` into every session **that
  is inside a vault** (it walks up for `hq.config.yml`; outside a vault it stays
  silent). This is what makes the rules reachable in a normal session.
- `skeleton/` — a **content-free** structural skeleton (empty index/wiki stubs
  and dashboards) that `/hq-init` copies to scaffold a new vault.
- `docs/vault-design.md` — the schema spec: structure, frontmatter schemas, and
  conventions. The single source of design for a vault.

A vault is made generic by `hq.config.yml` at its root — the seam that holds the
company list, team roster, and canon files. Nothing else hardcodes identity;
tools find the config (and thereby the vault root) by walking up from the working
directory, the way `git` finds `.git`. That same walk-up is how the SessionStart
hook decides a session is inside a vault and loads the rules — so your vault's
`CLAUDE.md` stays minimal (identity + your own company policy), and the operating
rules live in the plugin, updating centrally instead of going stale in every
vault's copy.

The schema is modular: a **core** of initiatives, tasks, knowledge, and log,
plus optional modules — **library** (external-signal capture), **crm**,
**distillery** (content pipeline), **competitive**, **sales**, and
**operations**. Every module is content-free in the skeleton; a module's folder
earns its place in a vault once it is used.

## License

MIT — see [LICENSE](LICENSE).
