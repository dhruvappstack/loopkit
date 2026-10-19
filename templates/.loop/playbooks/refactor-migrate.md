# Playbook: REFACTOR / MIGRATE

## Do
- Lock current behavior with characterization tests BEFORE changing structure.
- Change structure in tiny steps; run tests after each step; behavior must not change.
- For migrations use expand -> migrate -> contract (or strangler pattern); never big-bang.
- Keep a rollback path at every step (feature flag, dual-write, reversible migration).
- Separate refactor commits from behavior-change commits.

## Verify
- Same tests green after every step; no test edited to fit new structure without justification.
- No behavior diff (snapshot/golden tests, API response diffs, query result comparisons).
- Data migrations: row counts, checksums, forward AND backward run on realistic data.
- Rollback rehearsed.

## Pitfalls
- Mixing refactor with feature work.
- Migrating without a way to compare old vs new output.
