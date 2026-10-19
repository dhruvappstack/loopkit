#!/usr/bin/env bash
# Installer + linter test suite. Run: bash tests/test_install.sh
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pass=0; fail=0
ok()   { echo "  PASS $1"; pass=$((pass + 1)); }
bad()  { echo "  FAIL $1"; fail=$((fail + 1)); }
assert() { if eval "$2"; then ok "$1"; else bad "$1"; fi; }

T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT

echo "# fresh install (all adapters)"
"$ROOT/install.sh" --target "$T" >/dev/null
for f in .loop/LOOP.md .loop/intent.md .loop/goal.md .loop/state.md .loop/log.md .loop/lessons.md \
         .loop/decisions.md .loop/playbooks/test.md .loop/.loopkit-version \
         .claude/commands/loop.md .github/prompts/loop.prompt.md .cursor/rules/loop.mdc \
         CLAUDE.md AGENTS.md .github/copilot-instructions.md; do
  assert "created $f" "[[ -f '$T/$f' ]]"
done
assert "no stray LOOP.md at project root" "[[ ! -e '$T/LOOP.md' ]]"

echo "# idempotency"
"$ROOT/install.sh" --target "$T" >/dev/null
assert "CLAUDE.md has exactly one block" "[[ \$(grep -c 'loopkit:start' '$T/CLAUDE.md') -eq 1 ]]"
assert "AGENTS.md has exactly one block" "[[ \$(grep -c 'loopkit:start' '$T/AGENTS.md') -eq 1 ]]"

echo "# snippet appends to existing file without clobbering"
T2="$(mktemp -d)"; printf '# My rules\nuse tabs\n' > "$T2/CLAUDE.md"
"$ROOT/install.sh" --target "$T2" --agent claude >/dev/null
assert "existing CLAUDE.md content kept" "grep -q 'use tabs' '$T2/CLAUDE.md'"
assert "loop block appended" "grep -q 'loopkit:start' '$T2/CLAUDE.md'"
rm -rf "$T2"

echo "# user state is protected on re-install and --upgrade"
echo "MY GOAL" > "$T/.loop/goal.md"
echo "stale protocol" > "$T/.loop/LOOP.md"
"$ROOT/install.sh" --target "$T" >/dev/null
assert "default run keeps edited goal.md" "grep -q 'MY GOAL' '$T/.loop/goal.md'"
assert "default run keeps edited LOOP.md" "grep -q 'stale protocol' '$T/.loop/LOOP.md'"
"$ROOT/install.sh" --target "$T" --upgrade >/dev/null
assert "--upgrade refreshes LOOP.md" "grep -q 'LOOP PROTOCOL' '$T/.loop/LOOP.md'"
assert "--upgrade keeps goal.md" "grep -q 'MY GOAL' '$T/.loop/goal.md'"
"$ROOT/install.sh" --target "$T" --force >/dev/null
assert "--force restores goal.md" "grep -q 'Goal: <name>' '$T/.loop/goal.md'"

echo "# adapter selection"
T3="$(mktemp -d)"
"$ROOT/install.sh" --target "$T3" --agent copilot >/dev/null
assert "copilot only: prompt exists" "[[ -f '$T3/.github/prompts/loop.prompt.md' ]]"
assert "copilot only: no .claude dir" "[[ ! -d '$T3/.claude' ]]"
rm -rf "$T3"
assert "invalid agent rejected" "! '$ROOT/install.sh' --target '$T' --agent nope >/dev/null 2>&1"

echo "# linter"
"$ROOT/install.sh" --target "$T" --force >/dev/null
assert "fresh template passes lint" "'$ROOT/scripts/loop-lint.sh' '$T' >/dev/null 2>&1"
sed -i.bak 's/^Status: DRAFT/Status: ACTIVE/' "$T/.loop/goal.md"
assert "ACTIVE goal with placeholders fails lint" "! '$ROOT/scripts/loop-lint.sh' '$T' >/dev/null 2>&1"
rm -f "$T/.loop/goal.md.bak"
cat > "$T/.loop/goal.md" <<'G'
# Goal: demo
Status: ACTIVE
## Criteria
- [ ] C1: all auth tests pass
  - Verify: `pytest -k auth`
  - Evidence:
G
assert "well-formed ACTIVE goal passes lint" "'$ROOT/scripts/loop-lint.sh' '$T' >/dev/null 2>&1"
sed -i.bak 's/^Status: ACTIVE/Status: DONE/' "$T/.loop/goal.md"; rm -f "$T/.loop/goal.md.bak"
assert "DONE goal without evidence fails lint" "! '$ROOT/scripts/loop-lint.sh' '$T' >/dev/null 2>&1"
rm "$T/.loop/playbooks/debug.md"
assert "missing referenced playbook fails lint" "! '$ROOT/scripts/loop-lint.sh' '$T' >/dev/null 2>&1"

echo
echo "Result: $pass passed, $fail failed"
[[ $fail -eq 0 ]]
