# Cairn — The Master Index (START-HERE.md)

`START-HERE.md` is the single entry point a human uses to orient any agent.
It is not documentation — it is a live dispatch file.

## What START-HERE.md Must Contain

1. **Current Status** — one sentence. What just finished; what is now active.
2. **Active Task** — link to the task file (or "none" if between tasks).
3. **Memory Pointer** — link to `cairn/memory/INDEX.md`.
4. **Handover Pointer** — link to the most recent handover in `cairn/handoffs/`.
5. **Protocol Pointer** — link to `cairn/protocol/00-overview.md`.
6. **Validator** — how to run `python cairn/tools/validate.py`.

## What START-HERE.md Must NOT Contain

- Rationale, history, or decisions. Those live in `cairn/memory/`.
- Full task descriptions. Those live in `cairn/tasks/`.
- Handover content. That lives in `cairn/handoffs/`.

START-HERE.md is a map, not a book.

## How to Update START-HERE.md

- **Before starting a task:** Update "Active Task" to the new task file link.
- **After finishing a task:** Update "Current Status" and "Handover Pointer."

Keep it under 50 lines. If it grows past 50, content belongs in memory or a task file.

## The Resumability Test

After updating START-HERE.md, ask: "If a cold agent read only this file, could it
continue work correctly?" If no, update the file until the answer is yes.
