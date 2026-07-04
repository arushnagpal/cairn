# Cairn — Task-File Convention

Tasks are the unit of work. Each task file describes what a single agent should do,
starting cold, to advance the project one meaningful step.

## Task File Format

```markdown
---
id: T3
title: Short title (≤ 60 chars)
depends_on: [T1, T2]
status: pending
---

## Context
One paragraph. Why this task exists; what it is part of.

## Inputs
What to read before starting. Specific: filenames, section names, handover IDs.

## Outputs
What this task produces. Specific file paths and what each contains.

## Acceptance Criteria
- [ ] Verifiable condition — a command to run or a behavior to observe
- [ ] python cairn/tools/validate.py passes (exit 0)

## Notes (optional)
Risks, gotchas, known edge cases.
```

## Naming Convention

```
cairn/tasks/T<N>-<short-slug>.md
```

Example: `cairn/tasks/T3-protocol-part1.md`

## Dependency Ordering

A task must not start until all `depends_on` tasks show `status: completed`.
Update `status` in the frontmatter as work progresses.

## Task Sizing

A task should fit in ~50,000 tokens of agent context:
- Enough to read inputs, do the work, write outputs, and write a handover.
- If a task feels too large: split it. If two feel too small to bother handing off: merge them.

## What Is NOT in v1

A dependency-graph *engine* that automatically tracks status, visualizes the graph, or
blocks execution on unresolved dependencies is designed but not built. See `ROADMAP.md`.
In v1, dependency ordering is a human/agent convention, not an enforcement mechanism.
