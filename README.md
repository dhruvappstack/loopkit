# LoopKit

AI coding agents can write code quickly. Getting them to stay on task, verify their work, and leave a clear handoff is harder.

**LoopKit gives your agent a repeatable engineering workflow**: define a goal, make a small change, verify the result, and adjust until the work is done. It works with Claude Code, GitHub Copilot, Cursor, and other tools that read `AGENTS.md`.

Instead of relying on a perfect one-shot prompt, LoopKit helps keep work measurable, resumable, and reviewable—with you in control of intent and acceptance.

## What you get
- **One master protocol** (`.loop/LOOP.md`) for design, architecture, development, build, deploy, and every layer of testing
- **Measurable goals**: every criterion has a `Verify:` command and recorded `Evidence:`
- **The spine**: `intent`, `goal`, `state`, `log`, `lessons`, `decisions` so any session can resume
- **10 on-demand playbooks** (context engineering: only what the task needs is loaded)
- **Independent review** step and anti-thrash rules (no weakening tests to go green)
- **Handoff Report** that fights comprehension debt, intent debt, and cognitive surrender
- **Safety defaults**: budgets, escalation triggers, production commands need explicit approval
- **Non-destructive installer** plus a spine linter for CI

## Quick start

Install LoopKit into an existing project:

```bash
git clone https://github.com/dhruvappstack/loopkit.git
cd loopkit
./install.sh --target /path/to/your/project
```

Replace `/path/to/your/project` with your project's path. By default, the installer adds all adapters. To install only one, use `--agent claude`, `--agent copilot`, `--agent cursor`, or `--agent generic`.

On Windows, run `./install.ps1 -Target C:\path\to\project` instead.

Then fill in `.loop/intent.md`, start a task with your coding agent, and review its proposed goal and verification plan before it begins. When the task is done, check the Handoff Report and verify the results yourself.

For example, in Claude Code you can start with `/loop Fix the flaky checkout test and add a regression test`. In GitHub Copilot, run the `loop` prompt from `.github/prompts/`.

## What gets installed

```
your-project/
├── .loop/
│   ├── LOOP.md            protocol (managed; refreshed by --upgrade)
│   ├── playbooks/*.md     design, architect, develop, refactor-migrate, build-ci,
│   │                      deploy, test, debug, security-perf, docs
│   ├── intent.md          WHY (you own this)
│   ├── goal.md            WHAT, with Verify commands and Evidence
│   ├── state.md           NOW: iteration, blockers, next action
│   ├── log.md             HISTORY, append-only
│   ├── lessons.md         MEMORY: what works in this codebase
│   └── decisions.md       ADR-lite
├── .claude/commands/      /loop, /loop-resume, /loop-review
├── .github/prompts/       loop.prompt.md, loop-review.prompt.md
├── .cursor/rules/loop.mdc
└── CLAUDE.md, AGENTS.md, .github/copilot-instructions.md   (a marked LoopKit block is added)
```

## Installer options

| Flag | Effect |
|---|---|
| `-t, --target DIR` | Project to install into (default `.`) |
| `-a, --agent NAME` | `claude`, `copilot`, `cursor`, `generic`, `all`, `none` |
| `-u, --upgrade` | Refresh `LOOP.md` and playbooks only. Your spine files are untouched |
| `-f, --force` | Overwrite everything LoopKit manages |

Existing files are never overwritten by default. Instruction files such as `CLAUDE.md` get an idempotent
`<!-- loopkit:start -->` block appended; your content stays.

## Validate in CI

```bash
./scripts/loop-lint.sh .
```
Checks the spine exists, referenced playbooks exist, ACTIVE/DONE goals have `Verify:` lines (and evidence when DONE),
and the iteration counter is within budget.

## The loop at a glance

```
GOAL --> ACTION --> OBSERVE --> ADJUST --> (repeat) --> EXIT --> HANDOFF REPORT
 ^          |           |           |
 |          |           |           +-- continue / refine / revert / escalate
 |          |           +-- regression ladder + independent review
 |          +-- smallest change, playbook-guided
 +-- measurable criteria with Verify commands
```

See [docs/concepts.md](docs/concepts.md), [docs/customizing.md](docs/customizing.md), and the
[bugfix walkthrough](docs/examples/bugfix-walkthrough.md).

## Philosophy
1. Evidence over confidence.
2. Small, reversible steps.
3. The spine is the memory; assume every iteration starts fresh.
4. Humans own intent and acceptance.

## Roadmap
- [ ] Stack playbooks (dotnet, node, python, java, go, k8s, terraform)
- [ ] Headless runner examples for scheduled loops (GitHub Actions)
- [ ] Hook recipes (pre-commit, pre-push) for Claude Code and git
- [ ] Gemini CLI / Windsurf / Aider adapters
- [ ] Loop metrics: iterations to done, escalation rate, revert rate
- [ ] Localized prompts

Ideas and PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License
[MIT](LICENSE)
