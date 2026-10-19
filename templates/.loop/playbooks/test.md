# Playbook: TEST (apply every layer relevant to the change)

## Layers
| Layer | Do | Verify |
|---|---|---|
| Unit | Isolated logic, edge cases, error paths | Tests fail when code is deliberately broken |
| Integration | Real collaborators (DB, queue, HTTP) via containers or fakes | Runs in CI, deterministic, cleans up state |
| Contract | Consumer/provider API compatibility (for example Pact, OpenAPI diff) | Breaking change is detected |
| E2E / UI | Critical user journeys only; stable selectors; explicit waits, no sleeps | No flakes across 3 consecutive runs |
| Regression | One test for every fixed bug | Test fails on the old code |
| Performance / load | Baseline first, then compare; target percentiles (p95/p99) | Before/after numbers recorded |
| Security | Dependency audit, SAST, secrets scan, authN/authZ abuse cases, input validation | Findings triaged; no new high severity |
| Accessibility | Automated a11y checks plus keyboard/screen-reader notes | Zero new violations; manual notes handed off |
| Resilience / chaos | Timeouts, retries with backoff, partial failure, idempotency | Fault injection leaves system consistent |
| Data / migration | Forward and backward on realistic data | Counts/checksums match; rollback works |
| Compatibility | Supported versions / browsers / OS matrix | Matrix green |
| Exploratory | Write charters for the human to run | HUMAN-VERIFY list handed off |

## Do
- Test behavior, not implementation details.
- One reason to fail per test; descriptive names; arrange-act-assert.
- Keep tests fast, isolated, and order-independent.

## Verify the tests themselves
- Coverage of CHANGED lines, with meaningful assertions (coverage % alone is not evidence).
- Re-run suspicious tests (flake check). Quarantine with an issue link, never silently skip.
- Mutation check: break the code on purpose; the tests must fail.

## Pitfalls
- Asserting on mocks instead of outcomes.
- Sleeps, shared mutable state, time/random dependence without seeding or fakes.
