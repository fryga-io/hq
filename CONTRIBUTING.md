# Contributing to hq

`hq` is an open-source Claude Code plugin: an AI-operated company-brain OS. It
ships a content-free vault skeleton plus a schema, and the agent commands that
scaffold and maintain a vault. Contributions are welcome — issues, discussion,
and pull requests. This guide covers the design rules a change must respect and
how to test one.

## Design rules

These are hard constraints. A change that breaks one of them won't merge.

1. **The skeleton stays content-free.** `skeleton/` is structure only — empty
   `index.md` / `wiki.md` stubs and dashboards, no example initiatives, tasks,
   knowledge, library items, or any other sample data. `/hq-init` copies the
   skeleton verbatim, so anything you add to it lands in every new vault.

2. **Templates are canonical at the plugin root.** Frontmatter templates live in
   `templates/` and are read from there. They are **not** copied into vaults —
   an onboarded vault carries no vault-local `templates/` folder. Edit the
   template at the plugin root; never reintroduce a per-vault copy.

3. **Schema changes go spec-first.** Change the schema in this order:
   1. `docs/vault-design.md` — the spec. Always first.
   2. `commands/validate-vault.md` — so validation enforces the new rule.
   3. `templates/` — so new files match.
   4. `skeleton/` — so the scaffold matches (structure only — see rule 1).

   Don't edit a template or the skeleton ahead of the spec; the spec is the
   source of design.

4. **Keep everything config-driven.** No hardcoded company, team, or other
   identity anywhere in the plugin. Identity lives in a vault's `hq.config.yml`;
   the plugin describes the *mechanism*, the config supplies the *identity*. If a
   change needs a new identity input, add it to the config seam — not to a
   command, template, or the skeleton.

## Testing a change

Both checks must pass before you open a PR:

1. **Validate the plugin manifest:**

   ```
   claude plugin validate
   ```

2. **Run `/validate-vault` against the skeleton — it must stay green.** The
   content-free skeleton is a valid vault, so the validator passes on it with
   zero errors. From a checkout, point Claude Code at `skeleton/` (it contains
   the `hq.config.yml` that marks a vault root) and run `/validate-vault`. Any
   FAIL means your change broke the schema, the skeleton, or the validator —
   fix it before sending the PR.

If your change touches onboarding, also run `/hq-init` into an empty directory
and confirm the scaffolded vault passes `/validate-vault` with zero errors.

## Proposing changes

Open a pull request against `main`. Describe the change, and for any schema
change show that you followed the spec-first order above. Keep PRs focused — one
concern per PR. Open an issue first if you want to discuss a larger or
structural change before building it.
