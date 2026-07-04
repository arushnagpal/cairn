---
type: always-read
updated: 2026-07-03
---

# Cairn Build — Always-Read

## Current Status
T1 complete. Building cairn/ per the Cairn protocol.

## Active Task
T2 — validate.py + cairn/tools/README.md

## Key Invariants
- cairn/ is the product (copyable). .meta/ is build scaffolding only.
- validate.py is the headline feature — it must fail loudly, not silently.
- Every cairn/ file ≤ 200 lines.
- stdlib-only Python in validate.py (zero pip installs).

## Do Not Re-Read
BUILD-PROMPT.md (design is finalized; see docs/superpowers/specs/2026-07-03-cairn-design.md)
