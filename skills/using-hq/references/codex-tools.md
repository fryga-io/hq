# Codex tool & command mapping

The `using-hq` rules are written for Claude Code. When a Codex session loads them
(via the same SessionStart hook that runs in Claude Code), translate as below.

## Tools

| `using-hq` references | Codex equivalent |
|---|---|
| `Skill` tool (invoke a skill) | Skills load natively — just follow the instructions |
| `Task` tool (dispatch a subagent) | `spawn_agent` (with `wait_agent`, `close_agent`) |
| `TodoWrite` (task tracking) | `update_plan` |
| `Read`, `Write`, `Edit` (files) | Native file tools |
| `Bash` (run commands) | Native shell tools |

## Slash commands

hq's slash commands ship only to Claude Code — Codex plugins have no `commands/`
mechanism. When the injected rules tell you to run one, do this instead:

| Command | In Codex |
|---|---|
| `/validate-vault` | No command exists. Run the **"Before every commit"** checklist from `using-hq` by hand: indexes current, README "What's Active" current, frontmatter matches `docs/vault-design.md`, all wikilinks resolve, every `.base` carries its guard. |
| `/dream` | Claude-only in v1 — not available in Codex. |
| `/weekly` | Claude-only in v1 — not available in Codex. |
| `/add-to-library` | Claude-only in v1 — not available in Codex. |
| `/hq-init` | Claude-only in v1 — not available in Codex. |
