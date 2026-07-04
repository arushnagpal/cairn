---
task: T9 — v2 CLI shell rewrite
date: 2026-07-04
agent: claude-sonnet-4-6
---

# Handover: v2 Complete

## What I Did

Implemented the full v2 CLI in POSIX sh via subagent-driven development (3 tasks, 5 implementer
agents, 4 reviewer agents, 1 fix agent, 1 final whole-branch reviewer).

**Deliverables shipped (6 commits, pushed to GitHub):**

- `cairn/tools/validate.sh` — POSIX sh validator, canonical replacement for validate.py.
  Uses `awk 'END{print NR}'` for line counting (wc -l undercounts files without trailing
  newline), `find -newer` for mtime, temp-file loops to avoid subshell traps.
  shellcheck -s sh: zero warnings.

- `cairn/tools/validate.py` — converted from 190-line implementation to 13-line thin
  subprocess wrapper that delegates to validate.sh. All original tests still pass.

- `cairn/tools/cairn.sh` — CLI with two subcommands:
  - `init [target-dir]`: scaffolds full cairn/ structure from source templates;
    copies .cairn.toml, makes .sh files executable, generates START-HERE.md and memory/INDEX.md
  - `status`: reads START-HERE.md (grep -A2 to skip blank lines after headings),
    counts memory lines, checks staleness with find -newer, reads max_memory_lines from .cairn.toml

- `cairn/.cairn.toml` — default config file with all keys commented out; ships with the
  protocol so it's discoverable on first copy-in; cairn init copies it automatically.

- `tests/test_validate_sh.py` — 13 tests: all 5 exit codes + config overrides + cairn init
  structure + cairn status output (including staleness warning path).

- `.gitignore` — added (Python pycache, pytest cache, .DS_Store).

- Documentation updated throughout: cairn/README.md, cairn/START-HERE.md,
  cairn/tools/README.md, all 6 cairn/protocol/*.md files, ROADMAP.md.
  validate.sh is primary everywhere; validate.py appears only as "optional alternative".

- Root README.md — rewritten as a proper GitHub landing page with hook, zero-dependency
  callout, cross-platform angle, and quick install.

## Key Decisions

**awk not wc -l for line counting.** wc -l counts newline characters; a file with 201 items
joined by newlines (no trailing newline) returns 200. Python's splitlines() returns 201.
awk 'END{print NR}' returns 201. Used awk throughout for consistency with validate.py behavior.

**grep -A2 not grep -A1 in cairn status.** START-HERE.md uses a blank line between each
## heading and its content (standard Markdown). grep -A1 captures heading+blank; tail -1
returns the blank. Fixed to -A2 before push.

**cairn status reads max_memory_lines from .cairn.toml.** Initial implementation hardcoded
/1000 in the printf. Fixed so the display matches what validate.sh actually enforces.

**Protocol docs are the canonical spec agents read.** The final whole-branch review caught
that cairn/protocol/*.md still referenced validate.py in 6 files. Fixed before push —
protocol docs are what agents read when following the protocol, so they must be correct.

## What's Next

v2 is shipped. The remaining ROADMAP items are:
- Git pre-commit hook (`sh cairn/tools/validate.sh` on every commit)
- GitHub Actions integration (validate on PR + comment)
- Dependency-graph engine (parse depends_on frontmatter, block on unresolved deps)

Marketing / growth actions (discussed but not started):
- HN Show HN post
- Medium blog series (dogfooding story + "how we built Cairn using Cairn")
- Twitter/X thread
- GitHub topics: ai-agents, llm, agent-handoff, context-management, shell, posix,
  zero-dependency, developer-tools, claude, openai, markdown, workflow, memory-management

## What's Risky

- `cairn status` uses `find | sort` → alphabetical filename order for last-handoff detection.
  Works correctly for date-prefixed filenames (the expected convention). Silently picks the
  wrong file if non-prefixed names are used.
- Dead `.gitkeep` guards in validate.sh (check_structure and check_staleness filter
  `! -name ".gitkeep"` but the preceding `find -name "*.md"` can never match .gitkeep).
  Harmless but slightly misleading.
- cairn init copies `tools/*.sh` which includes cairn.sh itself. This is intentional
  (users should have cairn.sh in their repo), but means a user running
  `sh /their-repo/cairn/tools/cairn.sh init /another-repo` will resolve templates relative
  to their copy, not the original. This is correct behavior — the copy IS the source.

## Do Not Re-Read

- All prior handoffs (T1–T8) — v1 build history, settled.
- docs/superpowers/ — internal planning, done.
- BUILD-PROMPT.md — v1 design, shipped.
