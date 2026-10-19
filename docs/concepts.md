# Concepts

LoopKit operationalizes **loop engineering**: instead of crafting one perfect prompt, you design a system in
which an agent works in a continuous, verifiable loop and keeps durable state between iterations.

## The loop

```
        +----------------------------------------------+
        v                                              |
   GOAL (measurable) --> ACTION --> OBSERVE --> ADJUST-+
                                      ^            |
                                      |            +--> EXIT: success / budget / escalate / risk
                       independent reviewer
```

| Stage | LoopKit implementation |
|---|---|
| Goal | `goal.md`: binary criteria, each with a `Verify:` command and `Evidence:` |
| Action | Smallest change that advances one criterion, guided by a work-type playbook |
| Observe | Regression ladder (static, unit, integration, full suite, runtime) plus independent review |
| Adjust | Exactly one of CONTINUE / REFINE / REVERT / ESCALATE, with anti-thrash rules |

## Components

| Component | Where | Purpose |
|---|---|---|
| Triggers | `LOOP.md` section 9 | Manual, hooks (pre-commit, PR), schedules (nightly), CI failure |
| Context engineering | Playbooks loaded on demand; last 5 log entries only | Keep the agent focused on relevant information |
| Spine | `.loop/*.md` | Persistent state so a fresh session can resume (`/loop-resume`) |

## Human responsibilities (the three debts)

| Risk | Mitigation in LoopKit |
|---|---|
| **Comprehension debt**: more AI-written code than you understand | Handoff Report: summary, change map (riskiest first), not-verified list |
| **Intent debt**: technically sound work that misses the business goal | `intent.md`, intent check in the reviewer and the handoff |
| **Cognitive surrender**: trusting output without checking | `HUMAN-VERIFY` criteria, "Verify this yourself" list, evidence-over-confidence rule |

## Autonomy levels

| Level | Behavior |
|---|---|
| supervised | Pauses after every iteration for a human "go". Start here. |
| semi-autonomous | Pauses only at escalation triggers and at exit |
| autonomous | Runs to an exit condition within the budget |

Even at the highest level, production-affecting commands always require explicit approval.

## Design choices
- **Plain markdown, no runtime.** Works in any agent that can read files and run commands.
- **Non-destructive installs.** Your spine state is never overwritten without `--force`.
- **Small master prompt, playbooks on demand.** Less context noise, easier to customize.
