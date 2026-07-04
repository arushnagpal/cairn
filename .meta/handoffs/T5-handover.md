---
task: T5
date: 2026-07-03
agent: build-agent
---

# Handover: Templates + START-HERE + Scaffolding

## What I Did
Wrote 4 templates: HANDOVER.template.md, memory-entry.template.md,
START-HERE.template.md, task.template.md.
Wrote cairn/START-HERE.md (the human entry point, under 50 lines).
Wrote cairn/memory/INDEX.md (pre-seeded always-read for fresh installs).
Wrote cairn/tasks/example-task.md (concrete example of the task format).
validate.py passes.

## Key Decisions
START-HERE.md kept to exactly the required fields — no elaboration. It is a map, not
a book, per 03-index.md. The example task uses a realistic scenario (auth flow) rather
than a toy example so users can calibrate task granularity.

## What's Next
T6: write cairn/README.md (product front door).

## What's Risky
None. validate.py passing.

## Do Not Re-Read
cairn/templates/, cairn/START-HERE.md, cairn/memory/INDEX.md — settled.
