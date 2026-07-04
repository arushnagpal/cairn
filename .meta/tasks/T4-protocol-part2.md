---
id: T4
title: Protocol Docs Part 2 (03-index, 04-culture, 05-safeguards, 06-tasks)
depends_on: [T3]
status: pending
---

## Context
Writes four protocol docs covering conventions, values, safeguards, task format.

## Inputs
- BUILD-PROMPT.md §4–7
- cairn/protocol/00-02 (consistency with part 1)
- cairn/tools/validate.py
- docs/superpowers/plans/2026-07-03-cairn.md (Task 4 steps)

## Outputs
- cairn/protocol/03-index.md
- cairn/protocol/04-culture.md
- cairn/protocol/05-safeguards.md
- cairn/protocol/06-tasks.md

## Acceptance Criteria
- [ ] All four culture values appear as explicit concrete behaviors (not slogans)
- [ ] python cairn/tools/validate.py passes (exit 0)
- [ ] Each file ≤ 200 lines
