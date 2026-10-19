# Playbook: DEVELOP (features)

## Do
- Read existing code and conventions first; match them.
- Write a failing test first when practical (red), implement the minimum (green), then tidy.
- Keep diffs small and focused: one criterion per iteration.
- Handle errors and edge cases explicitly; no silent catch-all.
- Commit small checkpoints on a feature branch.

## Verify
- New tests fail before the change and pass after.
- Regression ladder green (static -> unit -> integration -> full suite).
- Behavior demonstrated at runtime (run it, show output).
- No unrelated changes in the diff.

## Pitfalls
- Gold plating beyond the goal. Park it in the parking lot.
- Editing tests to match buggy behavior.
- Adding a dependency without asking.
