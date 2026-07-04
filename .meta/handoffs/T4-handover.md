---
task: T4
date: 2026-07-03
agent: build-agent
---

# Handover: Protocol Docs Part 2

## What I Did
Wrote cairn/protocol/03-index.md (START-HERE convention, resumability test).
Wrote cairn/protocol/04-culture.md (4 values as concrete behaviors, not slogans).
Wrote cairn/protocol/05-safeguards.md (caps, staleness, commit-don't-delete, config).
Wrote cairn/protocol/06-tasks.md (format, naming, sizing, dependency ordering, v1 scope).
validate.py passes.

## Key Decisions
Each culture value in 04-culture.md has an explicit "Prohibits:" block — this prevents
agents from reading the values as vague aspirations rather than behavioral rules.
Included the dependency-graph engine clearly as "not in v1" in 06-tasks.md.

## What's Next
T5: write templates and cairn/START-HERE.md.

## What's Risky
None. validate.py passing.

## Do Not Re-Read
cairn/protocol/ — all 7 files settled.
