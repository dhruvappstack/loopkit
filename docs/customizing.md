# Customizing LoopKit

## Add a project-specific playbook
1. Create `.loop/playbooks/<name>.md` using the template below.
2. Name it in your task kickoff ("also load the dotnet playbook") or add a line to your project's agent instructions.
   Project playbooks override generic ones where they conflict.

```markdown
# Playbook: <NAME>
## Do
- ...
## Verify
- <command or check>
## Pitfalls
- ...
```

## Tune the guardrails
Edit the Phase 0 budget in `.loop/LOOP.md` (`max_iterations`, "Stop and ask before ..." list).
Add your team's risk areas (for example "any change under `/billing`").

## Set up triggers
- **Pre-push hook**: run your test command, then ask the agent for `/loop-review`.
- **Nightly schedule**: a cron/CI job that invokes the agent headlessly with
  "Follow .loop/LOOP.md section 9, schedule trigger: run the full suite and audit; report only."
- **CI failure**: pass the failing log to the agent as the first OBSERVE input.

## Keep `lessons.md` healthy
It is loaded every task. Review weekly: merge duplicates, delete stale entries, keep it under about 150 lines.
`scripts/loop-lint.sh` warns when it grows too large.

## Use the linter in CI
```yaml
- run: ./scripts/loop-lint.sh .
```
