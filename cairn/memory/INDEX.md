---
type: always-read
updated: 2026-07-03
---

# Cairn Memory — Always-Read

## Current Status

Fresh install. No active task.

## Next Action

Point an agent at a task file in `cairn/tasks/` to begin work.

## Open Blockers

None.

## Key Invariants

- Every `.md` file in `cairn/` must stay ≤ 200 lines.
- Run `python cairn/tools/validate.py` before stopping work.
- Write a handover to `cairn/handoffs/` before ending any session.
- Never delete memory entries — supersede them with strikethrough + explanation.
