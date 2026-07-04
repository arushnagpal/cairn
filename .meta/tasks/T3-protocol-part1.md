---
id: T3
title: Protocol Docs Part 1 (00-overview, 01-handover, 02-memory)
depends_on: [T2]
status: pending
---

## Context
Writes the three foundational protocol docs: the mental model, handover procedure,
and memory rules. Core mechanics of Cairn.

## Inputs
- BUILD-PROMPT.md §1–3
- cairn/tools/validate.py (run after each file)
- docs/superpowers/plans/2026-07-03-cairn.md (Task 3 steps)

## Outputs
- cairn/protocol/00-overview.md
- cairn/protocol/01-handover.md
- cairn/protocol/02-memory.md

## Acceptance Criteria
- [ ] Cold agent reading only these three docs can write a correct handover and memory entry
- [ ] python cairn/tools/validate.py passes (exit 0)
- [ ] Each file ≤ 200 lines
