# Example: fixing a bug with LoopKit (illustrative)

**Kickoff**
```
/loop Fix: login returns 500 when email contains a plus sign
```

**Intake (agent output, abridged)**
- Intent: users with `+` aliases must be able to log in (support tickets up 30%).
- Task type: DEBUG, DEVELOP, TEST (loads `debug.md`, `develop.md`, `test.md`)
- Goal:
  - [ ] C1: Regression test reproduces the 500 and fails on current code. Verify: `pytest tests/auth/test_login.py::test_plus_alias`
  - [ ] C2: Same test passes after the fix.
  - [ ] C3: Full auth suite green, no new lint errors. Verify: `pytest tests/auth && ruff check .`
- Budget: 8 iterations, autonomy supervised. Waiting for "go".

**Log (excerpt)**
```
#1 | reproduce | added failing test | FAIL: ValueError in parse_email (stack attached) | CONTINUE | locate root cause
#2 | root cause | URL-decoding turns '+' into space before validation | confirmed with debug print | REFINE | fix at boundary
#3 | fix | decode only query params, not JSON body | test_plus_alias PASS; auth suite 41/42 | REFINE | check failing test
#4 | fix side effect | legacy test assumed space-trimming | decided: ESCALATE (test change needs intent check)
```

**Escalation (iteration 4)**
Test `test_trim_space_alias` encodes old behavior. Options: (a) keep behavior, special-case plus; (b) update the
test since the old behavior was the bug. Recommendation: (b). Needs your decision.

**Handoff (abridged)**
Scorecard C1-C3 PASS with evidence. Not verified: mobile client behavior (HUMAN-VERIFY).
Verify yourself: log in with `name+test@example.com` on staging; review the changed test.
