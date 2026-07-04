# Cairn — Build Design Spec

**Date:** 2026-07-03
**Status:** Approved

---

## What We're Building

Cairn is a protocol + copyable folder (not a framework) that lets one AI agent hand an
in-progress software task to another without losing context — even when the first agent dies
mid-step. Shipped artifact: one self-contained `cairn/` folder dropped into any repo, usable
by any coding agent via plain markdown + one zero-dependency validator script.

**Positioning:** Cairn is the *enforced* handoff protocol — the only one that fails your check
when memory rots. Every lightweight competitor (Lutren/agent-handoff-protocol, etc.) is
advisory only. Cairn's `validate.py` actually blocks a bloated or stale memory file.

---

## Core Insight: Two-Layer Read-Budget

- **Always-read (thin):** current state, exact next action, open blockers, invariants.
  Hard-bounded. Read by every incoming agent.
- **On-demand (thick):** why decisions were made, dead-ends tried, detailed rationale.
  Written by every agent, read only when relevant.

One-line rule: "Write everything you did and why; nobody re-reads everything."

---

## Architecture

### Product (`cairn/`)

Self-contained, portable. This is what users copy into their repos.

```
cairn/
  README.md                   # pitch, diagram, comparison table, quickstart
  START-HERE.md               # human entry point; indexes everything
  protocol/
    00-overview.md            # mental model + two-layer read-budget
    01-handover.md            # how to write AND read a handover
    02-memory.md              # caps, append-first, supersede-don't-delete
    03-index.md               # START-HERE / master-index convention
    04-culture.md             # 4 values as concrete agent behaviors
    05-safeguards.md          # size caps, staleness, commit-don't-delete
    06-tasks.md               # task-file convention + dependency notes
  templates/
    HANDOVER.template.md
    memory-entry.template.md
    START-HERE.template.md
    task.template.md
  tools/
    validate.py               # stdlib-only enforcement (HEADLINE FEATURE)
    README.md                 # how to run + exit codes
  memory/
    INDEX.md                  # pre-seeded always-read
    .gitkeep
  handoffs/ .gitkeep
  tasks/
    example-task.md           # one concrete example
    .gitkeep
```

### Build Scaffolding (`.meta/`)

Not part of the product. Holds the live proof that Cairn builds itself.

```
.meta/
  tasks/       T1–T8 task files (written in T1, dogfooding from day 1)
  handoffs/    retroactive handover docs for T1–T7 (written in T8)
  memory/
    INDEX.md   build-time always-read
```

### Repo Root

```
README.md      repo-level: product summary + dogfooding story
ROADMAP.md     phased features — spec'd but NOT built in v1
```

---

## Task Decomposition (8 tasks)

### T1 — Repo Scaffolding + .meta/tasks/

**Outputs:** All directories, `.gitkeep` files, `.meta/tasks/T1–T8.md`, `.meta/memory/INDEX.md`

**Acceptance:** Directory tree matches spec. Each `.meta/tasks/*.md` is self-contained enough
for a cold agent to pick up. No validate.py yet — no green-run required.

---

### T2 — validate.py + cairn/tools/README.md

**Outputs:** `cairn/tools/validate.py`, `cairn/tools/README.md`

**Checks to implement:**
- Per-file line cap (configurable; default 200 lines)
- Total memory budget (sum of all files in `cairn/memory/`)
- YAML frontmatter structure validation
- Heading structure validation (required headings per file type)
- Staleness flag (docs not updated since last handover)
- Git-behavior config toggle (off / on / strict)

**Exit codes:**
- `0` — healthy
- `1` — size violation
- `2` — structure error (missing headings/frontmatter)
- `3` — staleness violation
- `4` — config error

**Constraints:** stdlib-only Python. Zero pip installs. Synthetic test fixtures in the task
file to verify pass/fail behavior.

**Acceptance:** Passes on a healthy dummy `cairn/`; fails loudly with a clear "distill this"
message on each violation class.

---

### T3 — Protocol Docs Part 1

**Files:** `00-overview.md`, `01-handover.md`, `02-memory.md`

**Content scope:**
- `00`: Mental model, two-layer read-budget named and explained
- `01`: Full write procedure + read procedure (including what NOT to re-read)
- `02`: Memory caps, append-first rule, surgical edits, supersede-don't-delete

**Acceptance:** A cold agent reading only these three files can correctly write a handover and
a memory entry. validate.py passes after this task.

---

### T4 — Protocol Docs Part 2

**Files:** `03-index.md`, `04-culture.md`, `05-safeguards.md`, `06-tasks.md`

**Content scope:**
- `03`: START-HERE / master-index convention
- `04`: Four culture values as concrete agent behaviors (fanatical user focus, challenging
  status quo, ownership mindset, smart efficiency)
- `05`: Safeguard rules (size caps, staleness, commit-don't-delete detail)
- `06`: Task-file convention, dependency ordering, dependency-graph engine = phased/not-v1

**Acceptance:** All four culture values appear as explicit behaviors (not slogans). validate.py
passes.

---

### T5 — Templates + START-HERE + Scaffolding

**Outputs:**
- `cairn/templates/HANDOVER.template.md`
- `cairn/templates/memory-entry.template.md`
- `cairn/templates/START-HERE.template.md`
- `cairn/templates/task.template.md`
- `cairn/START-HERE.md`
- `cairn/memory/INDEX.md`
- `cairn/tasks/example-task.md`

**Acceptance:** A cold agent given only `cairn/START-HERE.md` knows where everything lives and
can pick up any task without reading anything else first.

---

### T6 — cairn/README.md (Product Front Door)

**Required sections (per BUILD-PROMPT §6):**
1. One-line pitch + trail-marker metaphor
2. Problem (2–3 sentences: context death, lossy handoff)
3. Diagram — ASCII two-layer memory + handoff flow
4. Why choose Cairn — the enforcement wedge
5. Comparison table: Cairn vs. Lutren/agent-handoff-protocol vs. agentmemory
   Columns: Enforced size caps · Zero-dependency · Agent-agnostic · Named read-budget ·
   Handoff templates · Server/daemon required · Dogfooded
6. Quickstart: copy `cairn/`, point agent at `START-HERE.md`, run `validate.py`
7. How it works — handover lifecycle + thin/thick split
8. Dogfooding story

**Tone:** Honest comparison table. Credit what competitors do well. Win on enforcement +
zero-dependency + clarity, not by dunking.

**Acceptance:** A non-technical reader can understand the pitch and quickstart without touching
any other file.

---

### T7 — Root README.md + ROADMAP.md

**Root README:** Distinct from `cairn/README.md`. Covers: what the repo is, what `cairn/` is,
what `.meta/` is, the dogfooding story, pointer to `cairn/README.md` for full product docs.

**ROADMAP.md:** Spec the phased features explicitly — dependency-graph engine, richer CLI
(`init`/`status`), git pre-commit hooks, GitHub automation. Each entry must be clearly marked
"designed but not built in v1."

**Acceptance:** ROADMAP clearly separates v1 (done) from later (not done). Root README explains
both the product and the meta folder without duplicating cairn/README.md.

---

### T8 — .meta/ Handovers + Memory Capstone + Green Run

**Outputs:**
- `.meta/handoffs/T1-handover.md` through `T7-handover.md`
- Updated `.meta/memory/INDEX.md`
- `python cairn/tools/validate.py` exits 0

**Handover contents:** What each task did, why key decisions were made, what's next, what's
risky, what NOT to re-read. Retroactive but honest.

**Acceptance:** validate.py green on the completed `cairn/`. `.meta/` tells the coherent story
of how `cairn/` was built by its own protocol.

---

## Key Constraints (non-negotiable)

- Every file in `cairn/` ≤ 200 lines
- validate.py: stdlib-only, zero dependencies
- Agent-agnostic: plain markdown, no tool lock-in in the core
- Surgical edits: never delete history, supersede it
- `.meta/` never leaks into `cairn/`
- All four culture values appear as concrete behaviors in agent-facing prompts

---

## What Is NOT in v1

These are designed but explicitly not built — ROADMAP.md only:

- Dependency-graph engine for tasks
- Richer CLI (`cairn init`, `cairn status`)
- Git pre-commit hooks
- GitHub automation
