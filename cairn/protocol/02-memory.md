# Cairn — Memory Rules

Memory in Cairn is split into two layers with hard rules for each.
See `protocol/00-overview.md` for the mental model behind the split.

## The Always-Read Layer (thin)

**File:** `cairn/memory/INDEX.md`

**Purpose:** The first thing every incoming agent reads. Must be readable in under
300 tokens. Contains only what is true *right now*:

- Current status (what task is active, what just finished)
- The exact next action
- Open blockers
- Hard-won invariants that are easy to forget

**Cap:** Set by `max_file_lines` in `.cairn.toml` (default: 200 lines).
`validate.py` fails if breached.

**Write rule:** Update `INDEX.md` after every handover. Distill — do not blindly
append. If adding a new invariant, remove one that is no longer live.

## The On-Demand Layer (thick)

**Directory:** `cairn/memory/` (all files except `INDEX.md`)

**Purpose:** Long-form rationale. Why decisions were made, dead-ends tried, context
that won't fit in the always-read file.

**Budget:** `validate.py` checks the *total* line count of all `cairn/memory/` files
against `max_memory_lines` (default: 1000 lines). When near the budget: distill.

## Append-First Rule

When adding to any memory file:
1. **Append** the new entry at the bottom.
2. **Do not rewrite** the whole file.
3. If the file would breach its cap: distill — condense earlier entries, discard
   resolved or redundant detail, preserve key facts.

## Supersede, Don't Delete

Never delete a memory entry that was once true. Mark it stale instead:

```
~~Old belief about X.~~ (superseded 2026-07-03: turned out Y)
```

This preserves the trail. A future agent can see what was believed and why it changed.
Deleted history is a liability; superseded history is an asset.

## Staleness Rule

After every handover, update `cairn/memory/INDEX.md`. If you don't, `validate.py`
will flag it as stale — it compares the `mtime` of each memory file against the
`mtime` of the newest file in `cairn/handoffs/`.

## Memory Entry Template

Use `cairn/templates/memory-entry.template.md` for on-demand entries.
