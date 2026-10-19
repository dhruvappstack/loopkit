# Changelog

All notable changes to LoopKit are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/), versioning follows [SemVer](https://semver.org/).

## [Unreleased]

## [0.1.0] - 2026-10-20

### Added
- Master loop protocol (`LOOP.md`): Intake, Goal, Action, Observe, Adjust, Persist.
- Spine templates: `intent`, `goal`, `state`, `log`, `lessons`, `decisions`.
- Ten work-type playbooks loaded on demand (design, architect, develop, refactor, build-ci, deploy, test, debug, security-perf, docs).
- Adapters for Claude Code, GitHub Copilot, Cursor, and generic `AGENTS.md`.
- `install.sh` / `install.ps1` installers with idempotent, non-destructive behavior and `--upgrade`.
- `loop-lint.sh` spine validator and installer test suite.
