# Cairn — Handover Protocol

A handover is the document an agent writes before stopping work so the next agent
can continue without losing context. It is mandatory — no agent stops without one.

## When to Write a Handover

Write a handover:
- Before your session ends or your context window fills.
- After completing a task or meaningful sub-task.
- Before handing off to a different agent or tool.

## How to Write a Handover

Use `cairn/templates/HANDOVER.template.md`. Required sections:

### ## What I Did
One or two sentences per meaningful action. Specific: files changed, decisions made,
commands run. Past tense.

### ## Key Decisions
Decisions NOT obvious from reading the code. Explain the *why*, not the *what*.
Include: options considered, why you chose this path, risks accepted.
If a decision is already in a commit message or comment, skip it.

### ## What's Next
The exact next action for the incoming agent. Precise: filename, function, command,
task ID. Include blockers that must be cleared first.

### ## What's Risky
Things that could go wrong. Untested paths, fragile assumptions, known gaps.
Read this before touching anything.

### ## Do Not Re-Read
Explicit list of what to skip: docs, files, or previous handovers that are settled.
This section actively curates the always-read budget for the next agent.

## How to Read a Handover

1. Read **What's Next** first — it tells you exactly what to do.
2. Read **What's Risky** before touching anything.
3. Read **What I Did** for the actions taken.
4. Read **Key Decisions** only if you're about to revisit a decision.
5. **Do not** read anything in **Do Not Re-Read** unless you have a specific reason.

**Token budget:** A handover read should cost fewer than 500 tokens. If a handover
is longer, the writer violated the protocol — skim to the key sections.

## Storing Handovers

Save to `cairn/handoffs/` with a descriptive filename:
```
cairn/handoffs/YYYY-MM-DD-task-description.md
```

Never delete handovers. They are the permanent trail.
