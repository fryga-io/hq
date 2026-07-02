---
tags:
  - index
title: CRM
---

# CRM

Pipeline data: companies, contacts, grades, and interaction history. The *data*
behind the sales motion (the *how* lives in `sales/`, the *frame* in strategy
knowledge).

- `companies/` — one file per company, `tags: [crm, company]`. Grade and pipeline
  stage live in frontmatter; the body grows organically (research, rationale,
  dated interaction history).
- `contacts/` — one file per person, `tags: [crm, contact]`, linked back to a
  company via `company: "[[<name>-crm]]"`.

Company and contact files use the `<name>-crm.md` suffix. This module is
Bases-indexed: the `pipeline.base` embedded below renders a live stage/grade
table over every `crm`-tagged file, so the companies and contacts stay
discoverable without a hand-maintained wikilink list. See the CRM schemas in the
OS spec (the hq plugin's `docs/vault-design.md`).

![[pipeline.base]]
