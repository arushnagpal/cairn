---
task: T8 + v1 complete + v2 scoped
date: 2026-07-03
agent: claude-sonnet-4-6
---

# Handover: v1 Complete + v2 Scoped

## What I Did

Built all 8 v1 tasks via subagent-driven development (T1–T8). Each task had an
implementer subagent, a reviewer subagent, and fix subagents for any findings.
Committed 10 commits total (T2 had one fix commit for unused import os).

Applied one post-T8 fix: clarified cairn/README.md Quickstart with explicit
first-task creation steps (copy template, edit, update START-HERE.md, then point
agent). This was a UX gap the human identified.

Pushed v1 to GitHub: https://github.com/arushnagpal/cairn.git (master branch).

Scoped v2: POSIX shell rewrite of tooling (validate.sh + cairn.sh with init and
status subcommands). Task file written at .meta/tasks/T9-v2-cli-shell.md.

## Key Decisions

**v2 language = POSIX sh, not Python.** validate.py technically breaks the
language-agnostic promise — a Ruby or Go project shouldn't need Python to use
Cairn. POSIX sh ships on every macOS, Linux, and CI runner with no install.
validate.py stays as an optional alternative but validate.sh becomes canonical.

**cairn.sh has two subcommands: init and status.** init scaffolds a new cairn/
directory from the templates. status reads START-HERE.md and memory/ to print
a human-readable summary (current task, budget usage, staleness flags).

**docs/superpowers/ should be gitignored** — internal planning artifacts, noise
for public repo users. .meta/ stays (it's the dogfooding proof the README references).

## What's Next

The fresh agent should:
1. Read cairn/START-HERE.md
2. Read .meta/tasks/T9-v2-cli-shell.md (the full v2 spec)
3. Run brainstorming/writing-plans if they want to decompose T9 further,
   OR if the task file is detailed enough, implement directly.
4. Key open question in the task: does cairn init copy from ../templates/
   (relative path from cairn/tools/) or embed templates as heredocs?
   Recommend: copy from ../templates/ — simpler, templates stay editable.

## What's Risky

- POSIX sh mtime comparison: `stat` flags differ between macOS and Linux.
  Use `find . -newer <reference>` instead. Tested on macOS only so far.
- shellcheck compatibility: some constructs that work in bash fail in strict sh.
  Run `shellcheck -s sh` on both scripts.
- cairn.sh init path resolution: the script is at cairn/tools/cairn.sh.
  Use `$(dirname "$0")/../templates/` for the template source. Do not hardcode.

## Do Not Re-Read

- All of .meta/handoffs/T1–T7 (v1 build history, settled)
- docs/superpowers/plans/2026-07-03-cairn.md (v1 plan, done)
- BUILD-PROMPT.md (v1 design, finalized and shipped)
