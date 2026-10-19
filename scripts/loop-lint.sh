#!/usr/bin/env bash
# loop-lint: validate that a project's .loop/ spine is present and well-formed.
# Usage: scripts/loop-lint.sh [project-dir]   Exit 0 = OK, 1 = problems found.
set -uo pipefail

DIR="${1:-.}"
LOOP="$DIR/.loop"
errors=0; warnings=0

err()  { echo "ERROR: $*" >&2; errors=$((errors + 1)); }
warn() { echo "WARN:  $*" >&2; warnings=$((warnings + 1)); }

[[ -d "$LOOP" ]] || { echo "ERROR: $LOOP not found" >&2; exit 1; }

for f in LOOP.md intent.md goal.md state.md log.md lessons.md decisions.md; do
  [[ -f "$LOOP/$f" ]] || err "missing .loop/$f"
done
[[ $errors -eq 0 ]] || exit 1

# Every playbook referenced in LOOP.md must exist.
while IFS= read -r ref; do
  [[ -f "$DIR/$ref" ]] || err "LOOP.md references missing playbook: $ref"
done < <(grep -oE '\.loop/playbooks/[A-Za-z0-9_.-]+\.md' "$LOOP/LOOP.md" | sort -u)

# goal.md: if status is ACTIVE or DONE, every criterion needs a Verify: line.
status="$(grep -m1 -E '^Status:' "$LOOP/goal.md" | awk '{print $2}')"
criteria="$(grep -cE '^- \[[ xX]\] C[0-9]+:' "$LOOP/goal.md")"
verifies="$(grep -cE '^[[:space:]]+- Verify:' "$LOOP/goal.md")"
if [[ "$status" == "ACTIVE" || "$status" == "DONE" ]]; then
  [[ "$criteria" -gt 0 ]] || err "goal.md is $status but has no criteria (C1, C2, ...)"
  [[ "$verifies" -ge "$criteria" ]] || err "goal.md: $criteria criteria but only $verifies Verify: lines"
  if grep -qE '<[^>]+>' <(grep -E '^[[:space:]]+- Verify:|^- \[[ xX]\] C[0-9]+:' "$LOOP/goal.md"); then
    err "goal.md still contains <placeholder> text in criteria or Verify lines"
  fi
fi
if [[ "$status" == "DONE" ]]; then
  # A DONE goal must have evidence for each checked criterion.
  empty_evidence="$(grep -cE '^[[:space:]]+- Evidence:[[:space:]]*$' "$LOOP/goal.md")"
  [[ "$empty_evidence" -eq 0 ]] || err "goal.md is DONE but $empty_evidence criteria have empty Evidence:"
fi

# state.md sanity.
grep -qE '^Iteration: [0-9]+/[0-9]+' "$LOOP/state.md" || err "state.md: missing 'Iteration: N/M' line"
iter="$(grep -m1 -oE '^Iteration: [0-9]+' "$LOOP/state.md" | grep -oE '[0-9]+')"
max="$(grep -m1 -oE '^Iteration: [0-9]+/[0-9]+' "$LOOP/state.md" | cut -d/ -f2)"
if [[ -n "${iter:-}" && -n "${max:-}" && "$iter" -gt "$max" ]]; then
  err "state.md: iteration $iter exceeds budget $max"
fi

# Soft checks.
grep -qE '^\*\*Problem' "$LOOP/intent.md" && \
  ! grep -qE '^\*\*Problem / user need:\*\*[[:space:]]*[^[:space:]]' "$LOOP/intent.md" && \
  warn "intent.md: 'Problem / user need' is empty"
[[ "$(wc -l < "$LOOP/lessons.md")" -le 150 ]] || warn "lessons.md is over 150 lines; prune it (loaded every task)"

if [[ $errors -gt 0 ]]; then
  echo "loop-lint: FAILED ($errors errors, $warnings warnings)" >&2; exit 1
fi
echo "loop-lint: OK ($warnings warnings)"
