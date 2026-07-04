---
type: always-read
updated: 2026-07-03
---

# Cairn Build — Always-Read

## Current Status
Build complete. All 8 tasks finished. cairn/ validated (exit 0).

## Active Task
None. Cairn v1 is done.

## Key Invariants
- cairn/ is the product (copyable). .meta/ is build scaffolding only.
- validate.py passed on the completed cairn/ (exit 0).
- Every cairn/ file is ≤ 200 lines.

## Do Not Re-Read
BUILD-PROMPT.md, docs/superpowers/specs/ — design is implemented and done.
All .meta/handoffs/ unless auditing the build trail.
