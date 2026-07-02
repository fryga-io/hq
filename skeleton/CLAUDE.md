# <Company Name> HQ — Agent Rules

This is **<Company Name> HQ**, an hq vault. It runs on the **hq** plugin, which
supplies its operating rules, schema, and conventions each session via the
`using-hq` skill (injected by hq's SessionStart hook). If they did not load (for
example the plugin is not installed), invoke the `using-hq` skill manually.

`hq.config.yml` at the vault root is the marker; it holds canon and any enum/CRM
extensions. Identity — your companies, the team — is carried by the vault's own
`companies/`/`people/` registries and how notes link, not declared there.

## Company-specific instructions

(None yet — add policy here that is specific to this company and is not part of
hq itself. The generic rules stay in the plugin so they update centrally and
never go stale.)
