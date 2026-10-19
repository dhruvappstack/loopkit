# Playbook: DEPLOY / RELEASE / INFRA

## Hard rule
NEVER run production-affecting commands (apply, deploy, migrate, delete, scale, rotate) without
explicit human approval in this session. Default to read-only and dry-run.

## Do
- Dry-run first: `plan`, `diff`, `--dry-run`, `helm template`, `kubectl diff`.
- Deploy to a non-production environment first.
- Use progressive delivery: feature flag, canary, or blue/green.
- Define the rollback procedure BEFORE rollout, and the signal that triggers it.
- Never print or commit secrets; reference them via the secret manager.

## Verify
- Plan/diff reviewed: no unexpected destroy/replace.
- Health checks and smoke tests pass post-deploy.
- Logs, error rate, latency, saturation normal for an agreed observation window.
- Rollback tested at least once in non-prod.

## Pitfalls
- Config drift between environments.
- Schema changes shipped together with code that requires them (use expand/contract).
