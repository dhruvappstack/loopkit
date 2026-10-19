# Contributing to LoopKit

Thanks for helping! LoopKit is mostly markdown prompts plus small shell scripts, so most contributions are easy to make.

## Good first contributions
- A **stack playbook** (`dotnet`, `node`, `python`, `java`, `go`, `k8s`, `terraform`, ...)
- An **adapter** for another agent (Gemini CLI, Windsurf, Aider, ...)
- Improving a generic playbook with sharper `Verify` steps
- Real-world examples under `docs/examples/`
- Bug reports from using the kit on real work, especially *where the agent went off the rails*

## Repository layout
| Path | What |
|---|---|
| `templates/.loop/` | Files installed into a user's `.loop/` (protocol, playbooks, spine templates) |
| `templates/adapters/<agent>/` | Agent-specific files. `*.snippet` files are injected into an existing file between markers |
| `install.sh`, `install.ps1` | Installers (keep behavior in sync) |
| `scripts/loop-lint.sh` | Spine validator |
| `tests/test_install.sh` | Test suite |
| `docs/` | Concepts, customization, examples |

## Development
```bash
bash tests/test_install.sh        # must pass
shellcheck install.sh scripts/*.sh tests/*.sh   # if installed; CI runs it
```
Requirements: bash, `awk`, `sed`, `find`, `cmp`. The tests run on Linux and macOS in CI.

## Writing guidelines for prompts and playbooks
1. **Verifiable over vague.** Every playbook needs a `Verify` section with concrete commands or checks.
2. **Generic first.** Core files must not assume a language, framework, or vendor.
3. **Small context.** Prefer a new playbook over growing `LOOP.md`. Every token in `LOOP.md` is paid every task.
4. **Imperative and testable.** "Run the regression ladder" beats "make sure things work".
5. **Preserve the safety rules**: evidence over confidence, no weakening tests, production commands need approval,
   untrusted-content handling. PRs that remove these need a strong written justification.
6. **ASCII punctuation** in prompt files (plain `->`, straight quotes) for maximum agent compatibility.

## Adding a playbook
1. Copy the template from `docs/customizing.md` to `templates/.loop/playbooks/<name>.md`.
2. Add a row to the table in section 4 of `templates/.loop/LOOP.md`.
3. Run `bash tests/test_install.sh` (the linter checks that referenced playbooks exist).
4. Add a line to `CHANGELOG.md` under `[Unreleased]`.

## Adding an adapter
1. Create `templates/adapters/<agent>/` mirroring the target project's paths.
2. Use a `*.snippet` file (wrapped in `<!-- loopkit:start -->` / `<!-- loopkit:end -->`) for shared instruction files.
3. Register the adapter name in `install.sh` and `install.ps1`, and add a test case.

## Pull requests
- One logical change per PR; fill in the PR template.
- Update docs and `CHANGELOG.md` when behavior changes.
- If you changed a prompt, describe **what you ran it on** and what improved. Evidence over confidence applies to us too.

## Commit messages
Use Conventional Commits where practical: `feat:`, `fix:`, `docs:`, `test:`, `chore:`.

## Code of Conduct
By participating you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).
