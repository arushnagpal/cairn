---
id: T6
title: cairn/README.md (Product Front Door)
depends_on: [T5]
status: pending
---

## Context
Writes the product README — the front door for users discovering Cairn. Must include
all 8 required sections from BUILD-PROMPT.md §6, including the honest comparison table.

## Inputs
- BUILD-PROMPT.md §6 (exact required sections)
- All cairn/ files built so far (for accurate quickstart)
- docs/superpowers/plans/2026-07-03-cairn.md (Task 6 steps)

## Outputs
- cairn/README.md

## Acceptance Criteria
- [ ] Contains all 8 required sections (pitch, problem, diagram, why-Cairn, table, quickstart, how-it-works, dogfooding)
- [ ] Comparison table names real alternatives: Lutren/agent-handoff-protocol, agentmemory
- [ ] Non-technical reader can understand pitch and quickstart without reading other files
- [ ] python cairn/tools/validate.py passes (exit 0)
