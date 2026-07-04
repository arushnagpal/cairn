---
id: T2
title: validate.py + cairn/tools/README.md
depends_on: [T1]
status: pending
---

## Context
Builds the headline feature: the zero-dependency validator that enforces the Cairn
protocol. Built early so all subsequent tasks can run it as a sanity check.

## Inputs
- BUILD-PROMPT.md §4–5 (safeguards spec)
- docs/superpowers/specs/2026-07-03-cairn-design.md (T2 section)
- docs/superpowers/plans/2026-07-03-cairn.md (Task 2 steps)

## Outputs
- cairn/tools/validate.py
- cairn/tools/README.md
- tests/test_validate.py

## Acceptance Criteria
- [ ] Exit 0 on a healthy cairn/ with message "OK: cairn/ is healthy."
- [ ] Exit 1 on any file > 200 lines with "SIZE VIOLATION" + "Distill" in message
- [ ] Exit 1 on memory/ total > 1000 lines with "SIZE VIOLATION" + "Distill" in message
- [ ] Exit 2 on handoff missing a required heading with "STRUCTURE ERROR" in message
- [ ] Exit 3 on memory file older than newest handoff with "STALENESS" in message
- [ ] Exit 4 on malformed .cairn.toml
- [ ] stdlib-only — no pip installs, no imports outside Python stdlib
- [ ] python -m pytest tests/test_validate.py -v passes
