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

## Install

`hq` is distributed through the **fryga** plugin marketplace. From inside Claude
Code:

```
/plugin marketplace add fryga-io/claude-marketplace
/plugin install hq@fryga
```

then restart Claude Code.

(Hacking on the plugin itself? The repo ships a dev marketplace — add your local
checkout with `/plugin marketplace add ./` and install `hq@hq-dev`.)

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
- `templates/` — the canonical frontmatter templates for each file type. They
  live at the plugin root and are read from there; they are **not** copied into
  your vault.
- `skeleton/` — a **content-free** structural skeleton (empty index/wiki stubs
  and dashboards) that `/hq-init` copies to scaffold a new vault.
- `docs/vault-design.md` — the schema spec: structure, frontmatter schemas, and
  conventions. The single source of design for a vault.

A vault is made generic by `hq.config.yml` at its root — the seam that holds the
company list, team roster, and canon files. Nothing else hardcodes identity;
tools find the config (and thereby the vault root) by walking up from the working
directory, the way `git` finds `.git`.

The schema is modular: a **core** of initiatives, tasks, knowledge, and log,
plus optional modules — **library** (external-signal capture), **crm**,
**distillery** (content pipeline), **competitive**, **sales**, and
**operations**. Every module is content-free in the skeleton; a module's folder
earns its place in a vault once it is used.

## License

MIT — see [LICENSE](LICENSE).
