---
id: T5
title: Templates + START-HERE.md + Scaffolding
depends_on: [T4]
status: pending
---

## Context
Creates templates formalizing what protocol docs describe, plus the human entry
point (START-HERE.md) and one concrete example task.

## Inputs
- cairn/protocol/00-06 (all protocol docs)
- cairn/tools/validate.py
- docs/superpowers/plans/2026-07-03-cairn.md (Task 5 steps)

## Outputs
- cairn/templates/HANDOVER.template.md
- cairn/templates/memory-entry.template.md
- cairn/templates/START-HERE.template.md
- cairn/templates/task.template.md
- cairn/START-HERE.md
- cairn/memory/INDEX.md
- cairn/tasks/example-task.md

## Acceptance Criteria
- [ ] Cold agent given only cairn/START-HERE.md knows where everything lives
- [ ] python cairn/tools/validate.py passes (exit 0)
