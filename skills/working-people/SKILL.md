---
name: working-people
description: "Use when working with an hq vault's people registry — adding a person node for a collaborator, partner, or prospect; updating a person's affiliation after they change companies; or deciding whether someone is a person-registry node or a live CRM contact. Use whenever you touch people/ to record or revise a person."
---

# Working the people registry

`people/` is a top-level **person registry** — a node for *anyone* the vault
refers to, not only your own team. Collaborators, partners, advisors, prospects,
the founder a strategy note name-drops: the registry logs whoever gets mentioned.
Curated subsets (your own team, your orbit) are *groupings inside* its `index.md`,
not its boundary.

A person file is **free prose** under the Person schema — `tags: [person]`, a
`title`, `topics`, `created`, then a body that does the work. A **team member's**
node also carries `handle` and `initials` (the identity behind an `owner:` value)
and, in a multi-company vault, an optional `company`. There are **no mandated
profile sections**: write the synthesis the person
warrants, and close with an `## In HQ` list of wikilinks to the company /
initiative / library nodes they touch. The schema is in `docs/vault-design.md` →
*Person*; the registry rule is the *`people/`* section. This skill is only the
moves the spec and `using-hq` don't make obvious — everything else is **per
`using-hq`** (creating a file, rewrite-don't-append, wikilink resolution, index
hygiene).

## `company:` is a company handle, not a node link — and usually absent

This is the trap. In most vaults a person node has **no `company:` at all** — the
field exists only in a **multi-company** vault, where it names which of *your own*
companies the person is on (a handle from `hq.config.yml`, list-capable), and even
there it is routinely **empty**. It is *not* a `[[wikilink]]` to a `companies/`
node, and a person who isn't on one of your own companies simply has no value.

Where the org actually lives is **the body**: name it in prose, and `[[link]]` it
to its `companies/` node *if that company has one* (create the node if the org
warrants a registry entry — see `working-companies`). An org with no node is just
plain prose; that is fine, not a broken link.

| | Person node (`people/`) | CRM contact (`crm/contacts/`) |
|---|---|---|
| `company:` field | **multi-company vaults only:** a handle for one of *your own* companies, often empty; absent otherwise | a **`[[wikilink]]`** to the company's CRM file (`[[<co>-crm]]`) |
| org relationships | in the **body**, linked to `companies/` nodes where they exist | the linked CRM company file |

The wikilink-in-`company:` rule belongs to the CRM Contact schema — don't carry it
across to a person node.

## The one decision: person node vs CRM contact

Before creating or editing, route the person to the right folder. Same human, two
different homes depending on **why** the vault holds them:

| If they are… | They live in… | Schema |
|---|---|---|
| A reference node — collaborator, partner, advisor, anyone a note cites | `people/<first-last>.md` | Person — `tags: [person]` |
| A live prospect being worked through a pipeline | `crm/contacts/<first-companyshort>.md` | CRM Contact — `tags: [crm, contact]`, `pipeline:` |

The boundary is **pipeline membership**, not importance. A person you are actively
selling to is a CRM Contact (it carries `pipeline:` and a dated `## Interactions`
history); everyone else is a person node. The full CRM Contact schema is
`docs/vault-design.md` → *CRM Contact*; advancing a contact is `working-crm`, not
this skill. A person can legitimately have **both** files — a person node for who
they are, a CRM contact for the deal in flight — linked to each other.

## Add a person node

1. Create `people/<first-last>.md` with the *Person* frontmatter copied from the
   spec (per `using-hq` → *Creating a file*). In a multi-company vault, set
   `company:` **only if** the person is on one of your own companies; otherwise
   leave it empty. In a single-company vault there is no `company:` field. Give a
   **team member** their `handle` and `initials`.
2. Write a short prose synthesis — who they are, how they relate to the company —
   then an `## In HQ` wikilink list to the nodes they touch.
3. **Put the org in the body.** Name their organization in prose; `[[link]]` it to
   its `companies/` node if one exists (create that node, via `working-companies`,
   if the org warrants a registry entry). An org without a node stays plain prose —
   that is not a broken link.
4. Add a one-line pointer to `people/index.md` under the right grouping (orbit,
   team, prospects — whichever the index uses), per `using-hq`'s index hygiene.

## Update a person who changed companies

This is the rewrite-don't-append rule (**per `using-hq`**) applied to an
affiliation change — git is the audit trail, so there is **no** dated "moved
companies" note.

1. **Rewrite the body** to the new affiliation as present truth: re-point the org
   prose and its `[[companies/...]]` node link (creating the new company node if it
   warrants one), and remove the old framing.
2. **Touch `company:` only if** the vault has it and it held one of your own company
   handles that changed — otherwise it stays as is (often empty or absent). Never
   put a node wikilink in it.
3. **Run `obsidian backlinks file="<first-last>"`** to find every other file that
   referenced the old affiliation through this person, and mend each so no stale
   claim survives elsewhere.
4. **Update the index hook** if its one-liner names the old company.

If the person is actually a `crm/contacts/` Contact, the affiliation lives in
`company: "[[<co>-crm]]"` (the CRM schema's wikilink) — re-point that, but **leave
the `## Interactions` history intact** (point-in-time records, per the log
exception in `using-hq`).

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| Putting a `[[companies/...]]` wikilink in a person node's `company:` field | When present (multi-company vaults only), that field is a handle for one of your own companies, routinely empty; the org link lives in the body. The wikilink form is the CRM Contact schema's, not this one's. |
| Forcing a `company:` value for someone not on one of your own companies | Leave it empty (or absent); name the org in the body, and link its node there if one exists. |
| Filing a live prospect under `people/` | A person in a pipeline is a CRM Contact (`tags: [crm, contact]`, `pipeline:`); the boundary is pipeline membership, not importance. |
| Tagging a person node `[knowledge]` | A person registry node is `[person]`. |
| Appending a dated "now at NewCo" note on an affiliation change | Person files are current-state-with-rationale; rewrite the body — git carries history (per `using-hq`). |
| Rewriting the body but skipping `obsidian backlinks` | Other files referencing the old affiliation go stale; backlinks are how you catch them. |

## Related

- **`using-hq`** — the always-on discipline this skill sits on: creating a file,
  current-state-not-audit-trail, editing scope, wikilink resolution, index hygiene.
- **`docs/vault-design.md`** → *Person* (the node frontmatter, incl. `handle` /
  `initials` and the multi-company `company` field), *`people/`* (the registry
  module), *CRM Contact* (the
  contact schema, its `company:` wikilink and `## Interactions` history).
- **`working-companies`** — the org half of the same registry; a person node names
  its company in the body and links that company's node.
- **`working-crm`** — for a person who is a live prospect: advance their pipeline
  stage, log a touch.
- **`validate-vault`** — Test 3 (all wikilinks resolve) and Test 4 (every node
  enumerated in `people/index.md`) — the checks this skill's moves keep green.
