# Cairn — Safeguards

All safeguards are enforced by `cairn/tools/validate.py`. This document explains the
rules; the validator enforces them. Run `python cairn/tools/validate.py` before
stopping work.

## File Size Caps

**Default:** 200 lines per `.md` file.
**Config key:** `max_file_lines` in `.cairn.toml`.

Every `.md` file in `cairn/` is checked. When a file exceeds the cap:
1. Do not append more content.
2. Distill: condense earlier content, remove resolved entries, preserve key facts.
3. Run validate.py to confirm the file is within bounds.

The cap exists because unbounded files break the always-read promise.

## Memory Budget

**Default:** 1000 lines total across all files in `cairn/memory/`.
**Config key:** `max_memory_lines` in `.cairn.toml`.

When the budget is near: distill the on-demand layer. Condense related entries,
remove entries for decisions that are no longer live.

## Staleness Rule

`validate.py` compares the `mtime` of every file in `cairn/memory/` against the
`mtime` of the newest file in `cairn/handoffs/`. A memory file older than the newest
handover is flagged as stale.

**Resolution:** Read the stale file. Update it (if still accurate) or supersede entries
that are no longer true.

## Commit-Don't-Delete

Agents must never hard-delete product files. Instead:
- Mark the content as superseded (strikethrough + explanation).
- Commit the supersession.
- Old content remains in git history.

**Config:** `git_behavior` in `.cairn.toml`:
- `off` (default) — validate.py does not check git behavior.
- `on` — validate.py warns on deletion without supersession.
- `strict` — validate.py fails (non-zero exit) on deletion without supersession.

## Configuration File

```toml
# .cairn.toml (place at cairn root, alongside START-HERE.md)
max_file_lines = 200       # per-file cap (lines)
max_memory_lines = 1000    # total memory/ budget (lines)
git_behavior = off         # off | on | strict
```

Absent config → defaults apply. Malformed config → exit code 4.
