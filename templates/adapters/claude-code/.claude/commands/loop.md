---
description: Start a LoopKit loop (Intake -> Goal -> Action -> Observe -> Adjust)
argument-hint: <task description>
---
Follow `.loop/LOOP.md` strictly.

Task: $ARGUMENTS

Begin with PHASE 0 (Intake):
1. Read the spine files in `.loop/` (intent, goal, state, lessons, decisions) and the last 5 entries of `log.md`.
2. Classify the task type and load only the matching playbook(s) from `.loop/playbooks/`.
3. Show me: restated intent, measurable goal checklist with Verify commands, scope/non-goals,
   constraints, risks, loop budget, and autonomy level (default: supervised).
4. Ask at most 3 clarifying questions, only for what you cannot discover from the repo.
5. WAIT for my "go" before entering the loop.

After "go": iterate. Persist to the spine every iteration. Never claim a check passed without running it.
