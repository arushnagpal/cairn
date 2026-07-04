---
id: T9
title: v2 CLI — cairn.sh (init + status) + validate.sh
depends_on: [T1, T2, T3, T4, T5, T6, T7, T8]
status: pending
---

## Context

v2 of Cairn. The core insight driving this task: `validate.py` technically breaks
the language-agnostic promise — a Ruby, Rust, or Go project shouldn't need Python
to use Cairn. The fix is to rewrite the tooling in POSIX shell, which ships on
every macOS, Linux, and CI runner with no install required.

Two deliverables:
1. `cairn/tools/validate.sh` — replaces `validate.py` as the canonical validator
2. `cairn/tools/cairn.sh` — new CLI with `init` and `status` subcommands

Keep `validate.py` as an optional alternative for Python users (add a note in
cairn/tools/README.md), but make the shell scripts the headline tools.

## What was decided in brainstorming (2026-07-03)

- **Language:** POSIX sh (`#!/bin/sh`) — not bash, to maximize portability
- **Both commands in scope:** `cairn init` AND `cairn status`
- **validate.py stays** but becomes secondary; validate.sh is canonical
- **Zero pip installs, zero runtime dependencies** — shell only

### cairn.sh subcommands

**`cairn.sh init [target-dir]`**
Scaffolds a new cairn/ directory in target-dir (defaults to current directory).
- Creates all directories: cairn/protocol/, cairn/templates/, cairn/tools/,
  cairn/memory/, cairn/handoffs/, cairn/tasks/
- Copies all files from the cairn/ product folder into target-dir/cairn/
- Creates an initial cairn/START-HERE.md with today's date
- Creates cairn/memory/INDEX.md pre-seeded
- Prints: "Cairn initialized at <target-dir>/cairn/ — point your agent at START-HERE.md"

Key UX decision still open: does `cairn init` copy from the installed cairn/ dir,
or does it embed templates as heredocs in the script? Heredocs are self-contained
(no source dir needed) but harder to maintain. Recommend: copy from source dir
(script lives in cairn/tools/, so templates are at ../templates/).

**`cairn.sh status`**
Reads the current cairn/ and prints a summary:
- Current status (from START-HERE.md)
- Active task (from START-HERE.md)
- Memory budget: X/1000 lines used (count lines in cairn/memory/*.md)
- Staleness: flag any memory files older than newest handoff
- Last handover: filename + date
- Validator: "Run ./cairn/tools/validate.sh to check"

Output is plain text, human-readable, no color (POSIX sh color adds complexity).

### validate.sh

Same logic as validate.py, rewritten in POSIX sh:
- Line count check per .md file (wc -l)
- Memory budget check (sum of wc -l across cairn/memory/*.md)
- Heading check in cairn/handoffs/*.md (grep for required headings)
- Staleness check (compare file mtimes — use find -newer for portability)
- Config parse: read .cairn.toml (key=value, no sections, skip # lines)
- Exit codes: 0=healthy, 1=size, 2=structure, 3=staleness, 4=config error
- macOS/Linux portability: avoid bash-isms, avoid GNU-only stat flags

## Inputs

- cairn/tools/validate.py (reference implementation — port logic to shell)
- cairn/protocol/05-safeguards.md (the rules being enforced)
- cairn/templates/ (all template files, used by cairn init)
- docs/superpowers/plans/2026-07-03-cairn.md (v1 plan for context)
- This task file

## Outputs

- cairn/tools/validate.sh (executable, chmod +x)
- cairn/tools/cairn.sh (executable, chmod +x)
- Updated cairn/tools/README.md (document both .sh and .py tools, exit codes)
- Updated cairn/README.md Quickstart (replace `python cairn/tools/validate.py`
  with `sh cairn/tools/validate.sh` as primary; keep python as alternative)
- Updated ROADMAP.md (mark "Richer CLI" as complete in v2)
- tests/test_validate_sh.sh (POSIX sh test script, or Python subprocess tests)

## Acceptance Criteria

- [ ] `sh cairn/tools/validate.sh cairn/` exits 0 on a healthy cairn/
- [ ] `sh cairn/tools/validate.sh` exits 1 on a file > 200 lines with "SIZE VIOLATION"
- [ ] `sh cairn/tools/validate.sh` exits 2 on handoff missing required heading
- [ ] `sh cairn/tools/validate.sh` exits 3 on stale memory file
- [ ] `sh cairn/tools/validate.sh` exits 4 on bad .cairn.toml
- [ ] `sh cairn/tools/cairn.sh init /tmp/test-repo` creates full cairn/ structure
- [ ] `sh cairn/tools/cairn.sh status` prints current task + memory budget from this repo
- [ ] Both scripts run correctly on macOS (zsh/sh) and Linux (bash/sh/dash)
- [ ] No bashisms — `shellcheck -s sh` passes on both scripts
- [ ] cairn/tools/README.md documents both sh and py tools
- [ ] python cairn/tools/validate.py still passes (regression check)

## Notes

- POSIX sh mtime comparison: use `find . -newer <reference-file>` not `stat`
  (stat flags differ between macOS and GNU/Linux)
- For cairn init: the script is at cairn/tools/cairn.sh, so templates are at
  $(dirname $0)/../templates/ — use this relative path, don't hardcode
- shellcheck is the linter; if not installed, note it as a recommendation
- The fresh agent should read cairn/START-HERE.md first, then this task file
