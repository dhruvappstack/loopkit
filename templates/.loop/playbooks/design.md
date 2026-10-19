# Playbook: DESIGN (UX, API, data model, system design)

## Do
- Restate requirements as a numbered list; flag ambiguous ones.
- Propose 2-3 options with tradeoffs (complexity, cost, risk, reversibility). Recommend one.
- Define interfaces first: API contracts, schemas, events, error shapes.
- Write a short design note (1 page) in `decisions.md` or `docs/`.

## Verify
- Every requirement maps to a design element (traceability table).
- Sample requests/payloads validate against the schema (for example OpenAPI or JSON Schema lint).
- Edge cases listed: empty, max size, concurrency, partial failure, bad input.
- HUMAN-VERIFY: human approves the chosen option BEFORE implementation starts.

## Pitfalls
- Designing for hypothetical scale. Design for stated constraints.
- Skipping error and failure-state design.
