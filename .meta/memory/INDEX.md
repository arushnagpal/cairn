---
type: always-read
updated: 2026-07-03
---

# Cairn Build — Always-Read

## Current Status
v2 complete and pushed to GitHub (https://github.com/arushnagpal/cairn.git).
validate.sh + cairn.sh (init + status) + .cairn.toml all shipped. 19 tests passing.

## Active Task
None. v2 is done. Next work: marketing / GitHub growth, or v3 features from ROADMAP.md.

## Key Invariants
- cairn/ is the product (copyable). .meta/ is build scaffolding only.
- validate.sh is canonical; validate.py is a thin wrapper delegating to validate.sh.
- Every cairn/ file must stay ≤ 200 lines.
- All shell scripts: #!/bin/sh, shellcheck -s sh clean, awk not wc -l, find -newer not stat.

## Do Not Re-Read
BUILD-PROMPT.md, docs/superpowers/ — v1 design, done.
.meta/handoffs/T1–T8 — build history, settled.
Read T9-handover.md for the full v2 implementation record.
