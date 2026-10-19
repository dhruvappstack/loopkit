# Playbook: DEBUG

## Do
1. Reproduce reliably. If you cannot reproduce, gather logs/metrics/inputs first.
2. Minimize: smallest input or code path that still fails.
3. Hypothesize: list 2-3 candidate causes, ranked by likelihood.
4. Test ONE hypothesis at a time (log, breakpoint, bisect with `git bisect`).
5. Fix the root cause, not the symptom.
6. Add a regression test that fails on the old code.
7. Write the root cause in `log.md` and any reusable gotcha in `lessons.md`.

## Verify
- Repro fails before the fix and passes after.
- No new failures in the full suite.
- Root cause explained in plain language (could a teammate repeat the diagnosis?).

## Pitfalls
- Shotgun changes: changing several things at once so you don't know what fixed it.
- Declaring victory because the symptom disappeared (could be timing, caching, flakiness).
