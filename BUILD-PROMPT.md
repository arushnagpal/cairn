# Build Prompt — Cairn

> Hand the section below (everything under the horizontal rule) directly to the next agent.
> It is self-contained and encodes every decision made during design.
> Name is finalized: **Cairn**. Confirm the GitHub repo slug is free *in your own account*
> before starting (repo names only need to be unique per-account; global uniqueness is not required).

---

# Build: **Cairn** — the enforced agent-to-agent handoff protocol

You are a principal engineer building **Cairn**, a small, durable, **agent-agnostic protocol**
that lets one AI agent hand an in-progress software task to another without losing context —
even when the first agent dies mid-step. Cairn's name is the metaphor: trail-markers each
traveler stacks for the ones who follow.

This repo is a flagship personal-branding project destined for GitHub. Treat it that way:
**act like an owner, not a renter.** The bar is "people star this and copy it into their own
repos," not "it compiles." Documentation and prompt quality *are* the product here.

**Before building anything: read this whole prompt, then confirm your task decomposition and
any structural decisions with the human. Ask before any major change. Do not silently expand
scope.**

---

## 1. Mental model — what Cairn is

A **protocol + a copyable folder**, not a framework. The shipped artifact is one self-contained
folder a user drops into any repo, usable by **any** coding agent (Claude Code, Cursor, Codex,
etc.) because it is plain markdown conventions plus **one zero-dependency validator script**.

Convention over code. Every line of code must justify why it is not a convention instead.

---

## 2. The core insight to build around — the two-layer read-budget

Split memory into two layers. This is Cairn's intellectual contribution — name it, document it,
enforce it:

- **Always-read (thin):** current state, the exact next action, open blockers, invariants.
  Small, hard-bounded, read by every incoming agent. This is the token *budget* that must never
  blow up.
- **On-demand (thick):** why decisions were made, dead-ends already tried, detailed rationale.
  Written by every agent, read only when relevant.

The one-line rule: **"Write everything you did and why; nobody re-reads everything."**

---

## 3. Positioning & prior art — do NOT reinvent the crowded part

This space is crowded but immature. Study these before writing, and deliberately differentiate:

- **`Lutren/agent-handoff-protocol`** — the closest competitor. A copyable `AGENTS.md` +
  handoff/commit/release templates + safety rules. It is *intentionally small and advisory only*.
  Do not rebuild this; assume the minimal template is table stakes.
- **`codes1gn/agent-handoff`**, **`junkyard22/AHP`** — other lightweight markdown/packet handoff
  formats.
- **`rohitg00/agentmemory`, `akitaonrails/ai-memory`, agent-memory.dev** — the opposite camp:
  heavy memory *engines* (servers, SQLite/FTS, vector+graph retrieval, auto-capture hooks). Not
  our lane. Reference them only to contrast "zero-dependency, no server, no daemon."

**Cairn's wedge — make these the headline, not footnotes:**
1. **Enforcement.** Every lightweight competitor is advisory; none actually *block* a bloated or
   stale memory file. Cairn's `validate.py` **fails the check** on oversized/malformed/stale
   memory. This is the primary differentiator — treat `validate.py` as a headline v1 feature,
   not a side utility.
2. **The named, enforced two-layer read-budget** (section 2). Others persist "decisions + next
   steps"; nobody formalizes the always-read vs. on-demand token economics.
3. **Culture-in-the-prompt + dependency-ordered tasks + handoff, unified in one protocol.**
4. **Recursive dogfooding as proof** (section 8) — a repo built by its own protocol.

**Positioning line:** Cairn is not "a handoff protocol" (occupied). Cairn is **"the *enforced*
handoff protocol — the only one that fails your check when memory rots."**

---

## 4. Non-negotiable requirements

1. **Agent-agnostic.** Plain markdown any agent can follow. No tool lock-in in the core.
2. **Size-bounded memory.** Hard caps (per-file line/byte limits + a total-memory budget). The
   validator enforces them. When a file would breach its cap, the rule is to *distill/summarize*,
   not append blindly.
3. **Surgical, append-first edits.** Agents append or make minimal targeted edits; they never
   rewrite whole memory files. Never delete history — *supersede* it (mark stale, keep the trail).
4. **A single human entry point.** One file the human points an agent to (`START-HERE.md`) that
   indexes everything: current state, where memory lives, how to read a handover, how to resume.
   If execution broke mid-step, a fresh agent reading this file alone can continue.
5. **Handover doc + procedure.** A template *and* a written procedure for how to *write* a handover
   (what I did, why, what's next, what's risky, what NOT to re-read) and how to *read* one
   efficiently within the budget.
6. **Culture baked into the agent-facing prompts.** Every agent-facing instruction reflects four
   operating values as concrete behaviors, not slogans: **fanatical user focus, challenging the
   status quo, an ownership mindset, and a commitment to smart efficiency.** (e.g. "smart
   efficiency" → don't re-read what the handover marks settled.)
7. **Files stay 100–200 lines max.** Applies to protocol docs and code. If a doc grows past that,
   split it.
8. **The README is for humans** (see section 6 for exact required contents).

---

## 5. Safeguards the validator must enforce (`validate.py`)

- Per-file and total memory size caps; fail loudly on breach with a clear "distill this" message.
- Handover and memory files must match the required structure (validate headings/frontmatter).
- Staleness check: flag docs/index entries not updated since the last handover.
- **Commit, don't delete.** Configurable GitHub behavior: agents commit and supersede; they must
  not hard-delete product files. Make git behavior a config toggle (off / on / strict).
- **Stdlib-only.** Python standard library or POSIX shell. Zero pip installs, zero dependencies.
- Clear, documented exit codes (0 = healthy, non-zero = specific failure classes).

---

## 6. The generated README — required contents

The repo README is the front door and must, in human-readable form, include:

1. **One-line pitch** + the trail-marker metaphor.
2. **The problem** in 2–3 sentences (context death, lossy handoff mid-task).
3. **A diagram** of the two-layer memory + handoff flow.
4. **"Why choose Cairn"** — the wedge from section 3, in plain language.
5. **A comparison table** — honest, naming real alternatives. Suggested columns:
   *Enforced size caps · Zero-dependency · Agent-agnostic · Named read-budget · Handoff templates
   · Server/daemon required · Dogfooded.* Rows should include Cairn, a lightweight competitor
   (Lutren/agent-handoff-protocol), and a heavy memory engine (agentmemory / ai-memory). Be fair —
   credit what they do well; win on enforcement + zero-dependency + clarity, not by dunking.
6. **Quickstart** — copy the `cairn/` folder in, point your agent at `START-HERE.md`, run
   `python cairn/tools/validate.py`.
7. **How it works** — the handover lifecycle and the thin/thick split, briefly.
8. **The dogfooding story** — "this repo was built by the very protocol it defines."

---

## 7. Scope — v1 vs. later

- **v1 (build now):** handover doc + procedure; two-layer memory system with caps + append/surgical
  rules; `START-HERE.md` master index; the zero-dep `validate.py` (headline feature); culture
  values woven into prompts; the human-readable README with comparison table; and a **task-file
  convention with a template** plus one example task.
- **Designed-but-phased (spec it in `ROADMAP.md`, do NOT build the engine):** a full task
  *dependency-graph engine*, a richer CLI (`init`/`status`), git pre-commit hooks, and heavier
  GitHub automation.

---

## 8. Dogfood it — but keep the product clean

Build this repo **using Cairn's own protocol**, with a crisp separation:

- **The product** = one copyable top-level folder `cairn/` containing only what a downstream user
  needs: protocol docs, templates, `validate.py`, and empty `memory/`, `handoffs/`, `tasks/`
  scaffolds with `.gitkeep`. Nothing build-specific leaks in here.
- **The build scaffolding (meta)** = a clearly separate folder `.meta/` holding the actual tasks
  that build *this* repo, plus build-time handovers and memory. This is the live proof the protocol
  works, and must never be inherited by someone copying `cairn/`.
- The root README explains both: "here's the product; here's the repo dogfooding it."

---

## 9. Decompose the build into tasks (this is step one of the work)

Before implementing, write the task set inside `.meta/tasks/`, where **each task fits comfortably
in ~50k tokens of context for a single agent** — precise, self-contained, with explicit inputs,
outputs, acceptance criteria, and dependencies.

**Do not target a fixed count. Split until each task is genuinely single-agent-sized** (expect
roughly 6–12). Each task must be resumable: an agent picking it up cold reads only `START-HERE.md`
+ the task file + the relevant handover. Order tasks by dependency. If you conclude it needs more
or fewer tasks than first estimated, say so and ask before proceeding.

---

## 10. Suggested product structure (adapt with judgment; confirm major deviations)

```
cairn/                        # the copyable product — self-contained, portable
  README.md                   # human front door: pitch + comparison table + diagram (section 6)
  START-HERE.md               # the file a human points an agent to; indexes everything
  protocol/                   # each file 100–200 lines max
    00-overview.md            # mental model + the two-layer read-budget
    01-handover.md            # how to write AND read a handover
    02-memory.md              # caps, append-first, surgical edits, supersede-don't-delete
    03-index.md               # the START-HERE / master-index convention
    04-culture.md             # the 4 values as concrete agent behaviors
    05-safeguards.md          # size caps, commit-don't-delete, staleness
    06-tasks.md               # task-file convention + dependency notes (engine = phased)
  templates/
    HANDOVER.template.md
    memory-entry.template.md
    START-HERE.template.md
    task.template.md
  tools/
    validate.py               # stdlib-only enforcement of all safeguards (HEADLINE FEATURE)
    README.md                 # how to run it + exit codes
  memory/   INDEX.md + .gitkeep
  handoffs/ .gitkeep
  tasks/    .gitkeep + one example task
ROADMAP.md                    # the phased / designed-but-not-built features
README.md                     # repo-level: product + the dogfooding story
.meta/                        # build scaffolding, NOT part of the product
  tasks/  handoffs/  memory/
```

---

## 11. Definition of done

- A brand-new agent, given only `cairn/START-HERE.md`, can resume a half-finished task correctly.
- `python cairn/tools/validate.py` passes on a healthy repo and **fails clearly** on an
  oversized / malformed / stale one, with documented exit codes.
- Copying `cairn/` into a fresh empty repo yields a working, dependency-free setup.
- The README contains the honest comparison table and the "why choose Cairn" wedge.
- Every file ≤ ~200 lines. README is genuinely human-readable. All four culture values appear in
  the agent-facing prompts as concrete behaviors.
- `.meta/` demonstrably built this repo and is cleanly separable from `cairn/`.

---

## 12. How to work

Prompts and docs are the product — write them with the same care as code: precise, unambiguous,
no filler. Prefer the smallest thing that works. Lead with the enforcement wedge; do not
accidentally rebuild the minimal template that already exists.

When you hit a real fork (a structural change, a scope question, "should this be more/fewer
tasks"), **stop and ask the human.** Start by proposing the task decomposition for approval before
writing any implementation.
