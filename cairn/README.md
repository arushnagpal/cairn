# Cairn

> Cairn is the enforced agent-to-agent handoff protocol — trail-markers each traveler stacks for the ones who follow.

## The Problem

AI agents lose context mid-task: sessions end, context windows fill, and the next agent picks up cold. Without a protocol, it either re-derives everything — wasted tokens — or misses critical decisions and produces broken output. Most handoff solutions are advisory: they suggest what to do but never enforce it. Memory rots, and nobody catches it.

## How It Works

```
┌─────────────────────────────────────────────────────────┐
│  Agent A (finishing)            Agent B (picking up)     │
│                                                         │
│  ┌─── Always-read (thin) ──────────────────────────┐   │
│  │ current status · next action · blockers          │   │
│  │ invariants     (≤ 200 lines, enforced)           │   │
│  └──────────────────────────────────────────────────┘   │
│              ↑ read first, every time                   │
│                                                         │
│  ┌─── On-demand (thick) ───────────────────────────┐   │
│  │ why decisions were made · dead-ends tried        │   │
│  │ detailed rationale · append-only                 │   │
│  └──────────────────────────────────────────────────┘   │
│              ↑ read only when needed                    │
│                                                         │
│  ┌─── Handover ────────────────────────────────────┐   │
│  │ What I Did · Key Decisions · What's Next        │   │
│  │ What's Risky · Do Not Re-Read                   │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

Agent A writes the handover, commits it to `cairn/handoffs/`, and updates `cairn/memory/INDEX.md`. Agent B reads `START-HERE.md`, reads the always-read INDEX, reads the handover, and acts — all within a fixed token budget. `validate.sh` fails loudly if any file exceeds its cap or goes stale.

## Why Choose Cairn

**Enforcement is the wedge.** Every lightweight competitor is advisory — they tell agents what to do, but none actually block a bloated or stale memory file. Cairn's `validate.sh` fails your check when memory rots:

- File over 200 lines? Exit 1: "SIZE VIOLATION: Distill this file before adding more."
- Memory file older than the newest handover? Exit 3: "STALENESS: Review and supersede."
- Handoff missing a required section? Exit 2: "STRUCTURE ERROR: missing '## What's Next'."

**The named read-budget.** Cairn is the only protocol that names and enforces the always-read vs. on-demand split. The always-read layer is a *promise* — a hard-bounded file the next agent reads in full, every time. The on-demand layer is append-only history nobody re-reads wholesale.

**Zero dependency.** Copy the folder in. Run `sh cairn/tools/validate.sh`. That is it — no server, no daemon, no runtime install.

**Cross-platform.** `validate.sh` runs on macOS, Linux, and any CI runner that has `/bin/sh` — that is every major platform. No Python, no Node, no Go. A Ruby project, a Rust project, a Go project — all use the same `sh cairn/tools/validate.sh` command.

**Dogfooded.** This repository was built by the very protocol it defines. The `.meta/` directory holds the task files, handovers, and memory that agents used to construct `cairn/`. `sh cairn/tools/validate.sh cairn/` exits 0.

## Comparison

| Feature | Cairn | Lutren/agent-handoff-protocol | agentmemory |
|---------|:-----:|:-----------------------------:|:-----------:|
| Enforced size caps | ✅ | ❌ advisory | ❌ |
| Zero-dependency | ✅ POSIX sh | ✅ markdown only | ❌ server required |
| Agent-agnostic | ✅ | ✅ | ✅ |
| Named read-budget | ✅ | ❌ | ❌ |
| Handoff templates | ✅ | ✅ | ❌ |
| Server/daemon required | ❌ | ❌ | ✅ |
| Dogfooded | ✅ | ❌ | ❌ |

*Lutren/agent-handoff-protocol is intentionally minimal and advisory — a valid design for teams who want maximum flexibility. agentmemory targets heavy retrieval use cases (vector + graph search) — a different lane entirely. Cairn wins on enforcement, zero-dependency, and the named read-budget.*

## Quickstart

**First use — starting a new task:**

```bash
# 1. Copy the protocol into your repo
cp -r cairn/ your-repo/cairn/

# 2. Create your first task file
cp your-repo/cairn/templates/task.template.md your-repo/cairn/tasks/T1-your-task.md
# Edit T1-your-task.md: fill in title, context, inputs, outputs, acceptance criteria

# 3. Update the entry point to reference your task
# Edit your-repo/cairn/START-HERE.md:
#   - Active Task: tasks/T1-your-task.md
#   - Current Status: "Starting T1: <short description>"

# 4. Point your agent at the entry point
# Tell your agent: "Read cairn/START-HERE.md and follow the Cairn protocol."

# 5. Verify
sh your-repo/cairn/tools/validate.sh
# Expected: OK: cairn/ is healthy.
# (Alternative: python your-repo/cairn/tools/validate.py)
```

**Resuming work** (subsequent sessions): START-HERE.md already points to the active task
and last handover. Just tell your agent: "Read cairn/START-HERE.md and continue."

## The Handover Lifecycle

1. **Agent A** finishes work. Writes a handover to `cairn/handoffs/YYYY-MM-DD-task.md` with five sections: What I Did, Key Decisions, What's Next, What's Risky, Do Not Re-Read.
2. **Agent A** updates `cairn/memory/INDEX.md` (the always-read layer) to reflect current state.
3. **Agent A** runs `sh cairn/tools/validate.sh` — must exit 0 before stopping.
4. **Agent B** reads `cairn/START-HERE.md` → reads `cairn/memory/INDEX.md` → reads the latest handover → acts on "What's Next."
5. Repeat. The trail grows. Context never dies.

## Dogfooding

This repository was built by the very protocol it defines. The `.meta/` directory contains the task files and handovers that agents used to construct `cairn/`. Every design decision, dead-end, and key choice is preserved there. Running `sh cairn/tools/validate.sh cairn/` on this repository exits 0 — proof the protocol holds under real use.
