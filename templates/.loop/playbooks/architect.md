# Playbook: ARCHITECT

## Do
- List quality attributes with numbers: scale, latency, availability, cost, security, operability.
- Draw boundaries: components, data ownership, sync vs async, trust zones.
- Identify the riskiest assumption and run a time-boxed **spike** first; measure, don't guess.
- Record each significant choice as an ADR in `decisions.md`.
- Define failure modes, observability (logs/metrics/traces), and rollback.

## Verify
- Walk three scenarios through the design: normal, peak, failure. Write the result.
- Check every constraint in `intent.md` is satisfied or explicitly traded off.
- Spike produced real numbers (benchmark output, not estimates).
- HUMAN-VERIFY: architecture review sign-off on irreversible choices (datastore, protocol, vendor).

## Pitfalls
- Resume-driven architecture (new tech without a requirement).
- No exit path: every major dependency needs a "how do we leave it" note.
