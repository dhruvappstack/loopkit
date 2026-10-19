# Playbook: BUILD / CI

## Do
- Reproduce the failure locally or from the CI log before changing anything.
- Fix the root cause, not the symptom (no blind retries, no `|| true`).
- Pin versions (lockfiles, image digests, action SHAs); keep builds hermetic and reproducible.
- Cache deliberately; measure build time before and after.

## Verify
- Clean build from scratch succeeds (no cached state).
- The failing pipeline stage is green; other stages unaffected.
- Two consecutive runs produce equivalent artifacts.
- Build time / artifact size within the stated budget.

## Pitfalls
- "Works on my machine": compare toolchain versions and environment variables.
- Disabling a flaky check instead of fixing or quarantining it with an issue link.
