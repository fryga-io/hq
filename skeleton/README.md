# HQ

Operational hub for your company. The markdown files are the source of truth;
Obsidian and the agent are two interfaces over them.

Identity is carried by the vault itself; `hq.config.yml` holds only canon and any enum/CRM extensions.

## Navigation

- [[initiatives/index|Initiatives]] — strategic efforts
- [[tasks/index|Tasks]] — active work items, rolled up by initiative
- [[knowledge/index|Knowledge]] — company-owned thinking and references
- [[people/index|People]] — registry of people the vault refers to
- [[companies/index|Companies]] — registry of organizations the vault refers to
- [[log/index|Log]] — decisions, meeting notes, observations
- [[library/index|Library]] — external signals (raw content + synthesis wiki)
- [[crm/index|CRM]] — companies, contacts, pipeline data
- [[distillery/index|Distillery]] — the content pipeline (channels + content)
- [[competitive/index|Competitive]] — market and competitor intelligence
- [[sales/index|Sales]] — sales playbooks and sourcing lists
- [[operations/index|Operations]] — runbooks, checklists, reports, audits
- `dashboards/` — Obsidian Bases views over the vault

## Conventions

- lowercase-kebab-case filenames; action-first for tasks.
- Every file has YAML frontmatter with `tags` and `title`. See the schemas in
  the OS spec (the hq plugin's `docs/vault-design.md`).
- Status enums, never free text. Tasks: `backlog | todo | doing | blocked | done
  | cancelled`. Initiatives: `active | paused | completed | abandoned`.
- `[[wikilinks]]` for internal links; markdown links for external URLs.

## What's Active Right Now

_No active initiatives yet._

## Maintenance

Run `/validate-vault` to check vault health (indexes, wikilinks, frontmatter
enums, dashboard guards).
