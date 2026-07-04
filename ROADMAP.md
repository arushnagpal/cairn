# Cairn Roadmap

Items below are designed and specified but **not built in v1**.
`cairn/protocol/06-tasks.md` describes what IS in v1.

## Dependency-Graph Engine

**What:** Automatically parse `depends_on` frontmatter in task files, build a DAG,
block execution on unresolved dependencies, surface a visual graph of task status.

**Why phased:** The dependency-ordering convention in v1 works for human+agent teams
without an engine. An engine adds complexity before the convention is proven at scale.

**Not in v1.**

---

## Richer CLI (`cairn init`, `cairn status`) ✓ shipped in v2

**What:**
- `cairn init` — scaffold a new `cairn/` directory in any repo
- `cairn status` — show current task, memory budget usage, staleness flags
- `validate.sh` — POSIX sh validator, replaces `validate.py` as canonical tool

**Shipped:** v2 (`cairn/tools/cairn.sh`, `cairn/tools/validate.sh`).

---

## Git Pre-Commit Hook

**What:** Run `validate.py` automatically on every commit, blocking commits that would
leave memory stale or files oversized.

**Why phased:** Requires hook installation per repo, breaking the frictionless copy-in
quickstart. Phase 2 after the protocol is adopted.

**Not in v1.**

---

## GitHub Actions Integration

**What:** Workflow that runs `validate.py` on every PR and posts a summary comment;
optional auto-labeling for stale-memory PRs.

**Why phased:** Adds GitHub coupling to a protocol designed to be platform-agnostic.
Introduce after the protocol is stable and the CLI exists.

**Not in v1.**
