# Cairn — Overview

## What Cairn Is

Cairn is a protocol and a copyable folder — not a framework. Drop the `cairn/`
directory into any repository. Any coding agent (Claude Code, Cursor, Codex, or any
other) can follow it because the entire protocol is plain markdown plus one
zero-dependency validator script.

The name is the metaphor: a cairn is a stack of stones trail-runners leave for the
ones who follow. Each agent adds a stone; the path stays visible.

**Convention over code.** Every line of code in Cairn must justify why it is not a
convention instead.

## The Problem Cairn Solves

AI agents lose context mid-task: the session ends, the context window fills, or a
second agent picks up where the first left off. Without a protocol, the next agent
either re-derives everything (wasted tokens) or misses critical decisions (broken
output).

## The Two-Layer Read-Budget

Cairn splits memory into two layers. This is the core insight — name it, honor it:

**Layer 1 — Always-read (thin)**

- Contains: current status, the exact next action, open blockers, hard-won invariants.
- Read by: every incoming agent, every time, before touching anything.
- Size: hard-bounded. `validate.sh` fails if the cap is breached.

**Layer 2 — On-demand (thick)**

- Contains: why decisions were made, dead-ends tried, detailed rationale.
- Read by: an agent who needs the history for a specific decision.
- Size: grows freely, append-only. Nobody re-reads everything.

**The one-line rule:** "Write everything you did and why; nobody re-reads everything."

The always-read layer is a *promise* to the next agent: you won't need to read more
than N lines to act. `validate.sh` enforces this promise by failing when the budget
is breached.

## What Makes Cairn Different

Most handoff protocols are advisory — they suggest what to do but never enforce it.
Cairn's `validate.sh` *blocks* work when memory rots: oversized files, stale entries,
and missing required sections all produce non-zero exit codes with actionable messages.

**Cairn is the enforced handoff protocol.** It is the only one that fails your check
when memory rots.

## Protocol Files

| File | Purpose |
|------|---------|
| `protocol/01-handover.md` | How to write and read a handover |
| `protocol/02-memory.md` | Memory caps, append-first, supersede-don't-delete |
| `protocol/03-index.md` | The START-HERE / master-index convention |
| `protocol/04-culture.md` | Operating values as concrete agent behaviors |
| `protocol/05-safeguards.md` | Size caps, staleness, commit-don't-delete |
| `protocol/06-tasks.md` | Task-file convention and dependency ordering |
| `tools/validate.sh` | The enforcement script (POSIX sh, canonical) — run before stopping work |
