---
mode: agent
description: Start a LoopKit loop (Intake -> Goal -> Action -> Observe -> Adjust)
---
Follow `.loop/LOOP.md` strictly.

Task: ${input:task:Describe the task in one or two sentences}
Intent (why it matters): ${input:intent:Business or user outcome}
Done looks like: ${input:done:Measurable criteria, or write "propose these for me"}
Out of scope: ${input:scope:What not to touch}
Autonomy: ${input:autonomy:supervised | semi-autonomous | autonomous}

Begin with PHASE 0 (Intake). Read the `.loop/` spine, classify the task, load only the matching
playbook(s) from `.loop/playbooks/`, then show me the restated intent, goal checklist with Verify
commands, risks, and loop budget. Wait for my "go" before entering the loop.
