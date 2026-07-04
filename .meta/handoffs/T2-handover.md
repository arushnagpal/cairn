---
task: T2
date: 2026-07-03
agent: build-agent
---

# Handover: validate.py + cairn/tools/README.md

## What I Did
Wrote cairn/tools/validate.py (stdlib-only, Python 3.8+).
Wrote tests/test_validate.py with 5 tests covering all exit codes (0–4).
All 5 tests pass. Wrote cairn/tools/README.md documenting exit codes and config.

## Key Decisions
Used file mtime comparison for staleness (not git timestamps) — simpler, zero-dep.
Used `max()` across exit codes so multiple violations report the highest severity.
Auto-detection of cairn root checks CWD then parent for START-HERE.md.

## What's Next
T3: write protocol docs part 1 (00-overview, 01-handover, 02-memory).
Run validate.py after each file.

## What's Risky
Staleness check uses filesystem mtime, which can be unreliable if files are copied
rather than edited. Acceptable for v1; noted in case it causes false positives.

## Do Not Re-Read
tests/test_validate.py — tests are passing; no open issues.
