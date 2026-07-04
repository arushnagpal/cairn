---
type: always-read
updated: 2026-07-03
---

# Cairn Build — Always-Read

## Current Status
v1 complete and pushed to GitHub (https://github.com/arushnagpal/cairn.git).
v2 scoped: POSIX shell CLI (validate.sh + cairn.sh init + cairn.sh status).

## Active Task
T9 — v2 CLI shell rewrite. See .meta/tasks/T9-v2-cli-shell.md.

## Key Invariants
- cairn/ is the product (copyable). .meta/ is build scaffolding only.
- v2 language = POSIX sh (not bash). Use `find -newer` not `stat` for mtime.
- validate.py stays as optional alternative; validate.sh becomes canonical.
- Every cairn/ file must stay ≤ 200 lines.
- Run shellcheck -s sh on all shell scripts.

## Do Not Re-Read
BUILD-PROMPT.md, docs/superpowers/ — v1 design, done.
.meta/handoffs/T1–T7 — v1 build history, settled.
Read T8-handover.md for the full v2 context and open questions.
