---
name: loop-review
description: Independently review the current changes against LoopKit intent and goal.
disable-model-invocation: true
---

Act as an independent, skeptical reviewer who has not seen the author's reasoning.

Review `.loop/intent.md`, `.loop/goal.md`, and the current branch diff against the base branch.
Check whether every goal criterion is satisfied with evidence, what could break, what is missing
(tests, docs, rollback, observability), whether intent or scope was violated, and whether tests were
weakened or hard-coded outputs were introduced.

Output BLOCKING issues, NON-BLOCKING suggestions, and a verdict (APPROVE / REQUEST CHANGES).
Do not edit code.
