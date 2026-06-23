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
| `/validate-vault` | No command exists in Codex. The **"Before every commit"** checklist in `using-hq` is only a quick subset — the full check (`commands/validate-vault.md`, Claude-only) runs 7 tests, including README two-hop reachability and library `index.md` ↔ `wiki.md` sync, which the checklist omits. Verify those by hand too, or run `/validate-vault` from a Claude Code session before publishing. |
| `/dream` | Claude-only in v1 — not available in Codex. |
| `/weekly` | Claude-only in v1 — not available in Codex. |
| `/add-to-library` | Claude-only in v1 — not available in Codex. |
| `/hq-init` | Claude-only in v1 — not available in Codex. |
