---
name: working-companies
description: "Use when working with an hq vault's companies registry — adding a node for an organization the vault refers to (a partner, prospect, vendor, or any company a note cites, not only your own portfolio), tying a project or initiative file to its parent company, or curating the company index's groupings. Use whenever you touch companies/ for anything other than a one-line lookup."
---

# Working the companies registry

**`companies/`** is a top-level **entity registry of organizations**: a node for
any company the vault refers to, each a free-prose synthesis file (`tags:
[company]`). This skill carries only what is specific to the *companies registry as
a registry*. Everything else defers:

- **Frontmatter** (`tags: [company]`, `title`, `company`, `topics`, `created`) —
  see `docs/vault-design.md` → *Company*.
- **Current-state-not-audit-trail, editing scope, index hygiene, wikilink
  resolution, the create-a-file steps** — all **per `using-hq`**. Don't restate;
  follow it.

If after those defers you have little to do here, that's expected — this module is
mostly the always-on layer applied to one registry.

## The one thing to internalize: it's a registry, not a portfolio

The registry **logs whoever the vault mentions** — partners, prospects, vendors,
collaborators, the company a strategy note cites — **not only companies you own or
serve.** Curated subsets (your own projects, your active clients) are **headings
inside** `companies/index.md`, not its boundary. When a note needs to refer to
`acme` and no node exists, the answer is *create the node*, not *skip because acme
isn't ours*. (Spec: `docs/vault-design.md` → *`companies/`*.)

A new node is a registry file:

| Field | Value | Source |
|---|---|---|
| filename | `<slug>.md`, lowercase-kebab | spec → *File naming* |
| `company:` | **multi-company vaults only:** which of *your own* companies the node relates to (e.g. `company: [acme]`); usually empty for an external org, and omitted entirely in a single-company vault | `hq.config.yml` companies, per `using-hq` — **not** the company the node is *about* |
| index entry | one line under the right heading in `companies/index.md` | per `using-hq` (create-a-file) |

The `company:` field is the easy trap, and in most vaults it simply isn't there: a
single-company vault has no `company:` at all. In a **multi-company** vault it names
which of *your own* companies the node relates to (`company: [acme]`), never the org
the node is *about* — and it's left empty for an external org none of your companies
owns. Read it off any existing node to confirm the shape.

## Tying a project or initiative to its parent company

This is a **body-prose backlink, not a frontmatter edit.** Obsidian wikilinks are
bidirectional, so one link wires both directions:

1. In the **project/initiative body**, reference the node in prose:
   `See [[acme]] for company details.`
2. On the **company node**, list the project under a body section
   (`## Projects & clients`): `- [[launch-pilot|Launch Pilot]]`.

A project's **`company:` frontmatter, if the vault has one, stays a company handle**
(`company: [acme]`) — it does **not** become a wikilink to the node (and a
single-company vault has no `company:` here at all). Registry cross-references live
in body text, not in frontmatter (spec → *Links*; the exception is the CRM
`company:` field, which is a different schema). Use `[[<slug>|readable label]]`
where the bare slug reads awkwardly.

## Curating the index groupings

The index's headings (your projects, active clients, partner-owned projects, etc.)
are **curated subsets** — re-sort a node under a new heading by moving its **index
line only**; the node file is unchanged. Keep every node enumerated somewhere in
`companies/index.md` (index hygiene per `using-hq`).

## Distinct from a CRM Company

A company you are actively **selling to** is a **CRM Company** (`crm/companies/`,
`tags: [crm, company]`, carrying `grade`/`pipeline`), not a registry node — the
`crm` tag, not the folder, is what marks the sales-pipeline file. The two can
coexist for one organization (a registry node for who they are, a CRM file for the
deal), linked to each other. Advancing the deal is `working-crm`.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Skipping a node because the company "isn't ours" | The registry logs *whoever the vault mentions*; ownership decides the heading, not inclusion. |
| Setting `company:` to the org the node is *about* | When present (multi-company vaults only), `company:` is one of *your own* company handles or empty — never the subject company. |
| Making a project's `company:` a wikilink to the node | Frontmatter `company:` stays the handle; the node↔project tie is **body-prose** wikilinks. |
| Tagging a registry node `[knowledge]` or `[crm, company]` | A registry node is `[company]`; `[crm, company]` is a sales-pipeline file in `crm/`. |
| Stacking dated updates in a node | Registry nodes are current-state — rewrite the body; git carries history (per `using-hq`). |

## Related

- **`using-hq`** — the always-on discipline this skill sits on: current-state,
  editing scope, index hygiene, wikilinks, the create-a-file steps, reading
  `company:` (multi-company vaults only) off `hq.config.yml`.
- **`docs/vault-design.md`** → *`companies/`* (the registry module) and *Company*
  (the frontmatter schema).
- **`working-people`** — the sibling registry for individuals; same
  registry-not-roster shape applied to `people/`.
- **`working-crm`** — when a company is a live deal, not a registry node: CRM is a
  separate module with its own `company: "[[<name>-crm]]"` linking rule.
- **`validate-vault`** — Test 3 (wikilinks resolve) and Test 4 (every node
  enumerated in `companies/index.md`) — the checks this module keeps green.
