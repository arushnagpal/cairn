---
id: T7
title: Root README.md + ROADMAP.md
depends_on: [T6]
status: pending
---

## Context
Writes the repo-level README (distinct from cairn/README.md) and ROADMAP.md
documenting designed-but-not-built features.

## Inputs
- cairn/README.md (T6)
- BUILD-PROMPT.md §7 (scope v1 vs later)
- docs/superpowers/plans/2026-07-03-cairn.md (Task 7 steps)

## Outputs
- README.md (repo root)
- ROADMAP.md

## Acceptance Criteria
- [ ] ROADMAP clearly separates v1 (done) from later (not built)
- [ ] Root README explains both cairn/ and .meta/ without duplicating cairn/README.md
