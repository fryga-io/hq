# <Company Name> HQ — Agent Rules

This vault runs on the **hq** Agent OS (a Claude Code plugin). Its operating
rules, schema, and conventions load automatically each session via the plugin's
`using-hq` skill, injected by hq's SessionStart hook. If they did not load (for
example the plugin is not installed), invoke the `using-hq` skill manually.

Identity — companies, team roster, canon files, enum/CRM extensions — lives in
`hq.config.yml` at the vault root.

## Company-specific instructions

(None yet — add policy here that is specific to this company and is not part of
the hq OS. The generic rules stay in the plugin so they update centrally and
never go stale.)
