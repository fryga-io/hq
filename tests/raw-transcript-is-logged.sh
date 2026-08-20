#!/usr/bin/env bash
# Rule under test: hand the vault a meeting transcript and the RAW transcript
# lands in log/, verbatim — summary on top of it, never instead of it.
#
# This is a BEHAVIOURAL test. Nothing in the plugin forces the behaviour; it is
# produced by what `using-hq` (injected by the SessionStart hook), the log
# capability skill, and the spec tell the model. So the only honest check is to
# run a real headless session against a real throwaway vault and look at the
# file it wrote. No mocks. It costs tokens and it can flake.
#
# A run passes only if BOTH hold: the `working-log` skill was actually invoked,
# and every transcript line survives verbatim in log/. The outcome is what the
# rule is for; the skill call is how the vault's log discipline gets loaded, so
# a run that lands the right file by luck without it is not a pass.
#
#   ./tests/raw-transcript-is-logged.sh          # 2 cases x 3 runs
#   RUNS=1 ./tests/raw-transcript-is-logged.sh   # quick
#   MODEL=sonnet ./tests/raw-transcript-is-logged.sh

set -uo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
RUNS="${RUNS:-3}"
MODEL_ARG=(); [ -n "${MODEL:-}" ] && MODEL_ARG=(--model "$MODEL")

# Deliberately mundane lines: a prose summary reproduces the decision, never the
# small talk. All of them must survive verbatim for the test to pass.
TRANSCRIPT='[00:01] Sam: Thanks for making time. We went through the pilot scope on our side.
[00:04] Riley: Good. The blocker last week was the data export — is that resolved?
[00:06] Sam: Resolved. Their ops lead signed off Tuesday. We can start the pilot the 3rd.
[00:11] Riley: Then I will send the scoping doc Friday and you confirm the two contacts.
[00:14] Sam: One thing — they pushed on price again, wanted a free trial.
[00:16] Riley: We hold at the paid pilot. That is settled.'

# The two shapes a transcript actually arrives in. The second is the regression
# case: asking for a summary must not replace the raw text with the summary.
CASES=(
  "bare-paste|Transcript from this morning's call with Northwind:

${TRANSCRIPT}"
  "asks-for-summary|Here's the transcript from the Northwind call. Can you pull out the action items?

${TRANSCRIPT}"
)

run_case() { # $1 = prompt; echoes "<verbatim-lines-found>/<total> <skill-fired:0|1>"
  local vault out logged found=0 total=0 skill=0
  vault="$(mktemp -d)"
  cp -R "$REPO/skeleton/." "$vault/"

  out="$(cd "$vault" && claude -p "$1" \
    --plugin-dir "$REPO" \
    --output-format stream-json --verbose \
    --allowed-tools Skill Read Glob Grep Write Edit \
    ${MODEL_ARG[@]+"${MODEL_ARG[@]}"} 2>/dev/null)"

  # Parse the stream properly: the JSON is emitted with and without spaces after
  # the colons depending on the event, so grepping a literal shape false-negatives.
  printf '%s' "$out" | python3 -c '
import json, sys
for line in sys.stdin:
    try: d = json.loads(line)
    except ValueError: continue
    for c in (d.get("message") or {}).get("content") or []:
        if isinstance(c, dict) and c.get("type") == "tool_use" and c.get("name") == "Skill":
            if "working-log" in json.dumps(c.get("input") or {}):
                sys.exit(0)
sys.exit(1)
' && skill=1

  # Everything written under log/, minus the pre-existing index stub.
  logged="$(find "$vault/log" -name '*.md' ! -name 'index.md' -exec cat {} + 2>/dev/null)"

  while IFS= read -r line; do
    total=$((total + 1))
    printf '%s' "$logged" | grep -qF -- "$line" && found=$((found + 1))
  done <<< "$TRANSCRIPT"

  rm -rf "$vault"
  printf '%d/%d %d' "$found" "$total" "$skill"
}

fail=0
for case in "${CASES[@]}"; do
  name="${case%%|*}"; prompt="${case#*|}"
  passes=0; skills=0; detail=""
  for i in $(seq 1 "$RUNS"); do
    read -r lines skill <<< "$(run_case "$prompt")"
    detail="$detail $lines"
    skills=$((skills + skill))
    [ "${lines%/*}" = "${lines#*/}" ] && [ "$skill" -eq 1 ] && passes=$((passes + 1))
  done
  if [ "$passes" -eq "$RUNS" ]; then
    printf 'PASS  %-18s %d/%d runs  (working-log fired %d/%d, transcript verbatim%s)\n' \
      "$name" "$passes" "$RUNS" "$skills" "$RUNS" "$detail"
  else
    printf 'FAIL  %-18s %d/%d runs  (working-log fired %d/%d, transcript verbatim%s)\n' \
      "$name" "$passes" "$RUNS" "$skills" "$RUNS" "$detail"
    fail=1
  fi
done

exit "$fail"
