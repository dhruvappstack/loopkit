# Playbook: SECURITY / PERFORMANCE

## Security: do
- Threat model first (assets, entry points, trust boundaries, STRIDE or similar).
- Check OWASP Top 10 classes relevant to the change: injection, broken access control, SSRF, etc.
- Run dependency audit, SAST, and secrets scan. Fix highest severity first.
- Validate input at boundaries; encode output; least privilege everywhere.
- Report vulnerabilities privately; do not paste exploit details into public logs.

## Performance: do
- Measure BEFORE changing: baseline with a repeatable benchmark or profile.
- Find the bottleneck (profile, traces, query plans); fix the biggest one first.
- Change one thing at a time; re-measure.

## Verify
- Security: findings closed with evidence; no new high/critical findings; authZ tests exist.
- Performance: before/after numbers on the same workload and hardware; within target percentiles.
- No functional regression (full suite green).

## Pitfalls
- Premature optimization without a profile.
- "Security through obscurity" and hand-rolled crypto.
