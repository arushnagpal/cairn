# Cairn

> Enforced agent-to-agent handoff protocol — trail-markers each traveler stacks for the ones who follow.

AI sessions end. Context windows fill. When a new agent picks up mid-task, it either re-derives everything (wasted tokens) or misses decisions already made (broken output). Most handoff solutions are advisory — they suggest what to do but never enforce it. Memory rots. Nobody catches it.

**Cairn is the enforced solution.** Drop `cairn/` into any repo, point your agent at `START-HERE.md`, and the protocol forces every handoff to document what was done, what's next, and what not to re-read — all within hard-enforced size and staleness caps.

```bash
# Install — copy the protocol into your repo
cp -r cairn/ your-repo/cairn/

# Verify — zero runtime required
sh your-repo/cairn/tools/validate.sh
# → OK: cairn/ is healthy.
```

→ **[Full docs, quickstart, comparison table, and protocol explanation](cairn/README.md)**

---

## Why Cairn

**Enforcement is the wedge.** Other protocols tell agents what to do. Cairn's `validate.sh` fails your check when the protocol is violated:

- File over 200 lines? → `SIZE VIOLATION: Distill this file before adding more.`
- Memory file older than newest handover? → `STALENESS: Review and supersede.`
- Handoff missing a required section? → `STRUCTURE ERROR: missing '## What's Next'.`

**Zero dependency, cross-platform.** `validate.sh` is pure POSIX shell — no Python, no Node, no Go. It runs on macOS, Linux, and every CI runner with no install step. A Ruby project, a Rust project, a Go project — same command, everywhere.

**The named read-budget.** Cairn is the only protocol that names and enforces the always-read vs. on-demand split. The always-read layer is a hard-bounded file the next agent reads in full, every time. The on-demand layer is append-only history — nobody re-reads it wholesale.

**Dogfooded.** This repository was built by the very protocol it defines. The `.meta/` directory contains the task files, handovers, and memory that agents used to construct `cairn/`. Running `sh cairn/tools/validate.sh cairn/` exits 0.

---

## What's in this repo

| Path | What it is |
|------|-----------|
| `cairn/` | The protocol — copy this folder into your repo |
| `cairn/tools/validate.sh` | Canonical POSIX sh validator (zero runtime) |
| `cairn/tools/cairn.sh` | CLI: `cairn init` + `cairn status` |
| `cairn/tools/validate.py` | Optional Python wrapper (delegates to validate.sh) |
| `.meta/` | How this repo was built — live dogfooding proof |
| `ROADMAP.md` | Planned features |

---

## Quick install

```bash
# 1. Copy the protocol
cp -r cairn/ your-repo/cairn/

# 2. Create your first task
cp your-repo/cairn/templates/task.template.md your-repo/cairn/tasks/T1-my-task.md
# Edit: fill in title, context, inputs, outputs, acceptance criteria

# 3. Tell your agent
# "Read cairn/START-HERE.md and follow the Cairn protocol."

# 4. Verify before every session ends
sh your-repo/cairn/tools/validate.sh
```

Or use the CLI to scaffold a new repo in one command:

```bash
sh cairn/tools/cairn.sh init /path/to/your-repo
```
