#!/bin/sh
# Cairn CLI — init and status subcommands.
#
# Usage:
#   sh cairn/tools/cairn.sh init [target-dir]
#   sh cairn/tools/cairn.sh status

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CAIRN_SRC="$(cd "${SCRIPT_DIR}/.." && pwd)"

usage() {
    printf 'Usage: cairn.sh <command> [args]\n\n'
    printf 'Commands:\n'
    printf '  init [target-dir]   Scaffold cairn/ in target-dir (default: .)\n'
    printf '  status              Show current task, memory budget, staleness\n\n'
    exit 1
}

cmd_init() {
    target_dir="${1:-.}"
    if [ ! -d "$target_dir" ]; then
        printf 'ERROR: %s does not exist.\n' "$target_dir" >&2
        exit 1
    fi
    dest="${target_dir}/cairn"
    if [ -d "$dest" ]; then
        printf 'ERROR: %s already exists. Remove it first or choose a different target.\n' "$dest" >&2
        exit 1
    fi
    mkdir -p "${dest}/protocol" "${dest}/templates" "${dest}/tools" \
             "${dest}/memory" "${dest}/handoffs" "${dest}/tasks"
    cp "${CAIRN_SRC}/protocol/"*.md "${dest}/protocol/" 2>/dev/null || true
    cp "${CAIRN_SRC}/templates/"*.md "${dest}/templates/" 2>/dev/null || true
    cp "${CAIRN_SRC}/tools/"*.py "${dest}/tools/" 2>/dev/null || true
    cp "${CAIRN_SRC}/tools/"*.sh "${dest}/tools/" 2>/dev/null || true
    cp "${CAIRN_SRC}/tools/README.md" "${dest}/tools/README.md" 2>/dev/null || true
    cp "${CAIRN_SRC}/.cairn.toml" "${dest}/.cairn.toml" 2>/dev/null || true
    chmod +x "${dest}/tools/"*.sh 2>/dev/null || true
    today=$(date +%Y-%m-%d)
    cat > "${dest}/START-HERE.md" << STARTHERE
# START HERE

> A cold agent reads this file first — nothing else. Keep it under 50 lines.

## Current Status

\`cairn/\` initialized on ${today}. No tasks are in progress.

## Active Task

None. Add task files to \`cairn/tasks/\` and point your agent at one to begin.

## Memory

[Always-read](memory/INDEX.md) — read before anything else.

## Last Handover

None yet. Handovers appear in \`cairn/handoffs/\` after the first task completes.

## Protocol

[How Cairn works](protocol/00-overview.md) — start here if you are new.

## Validator

\`\`\`bash
sh cairn/tools/validate.sh
\`\`\`

Run this before stopping work. Expected: \`OK: cairn/ is healthy.\`
STARTHERE
    cat > "${dest}/memory/INDEX.md" << MEMINDEX
---
type: always-read
updated: ${today}
---

# Always-Read Memory

## Current Status

Cairn initialized. No tasks have started yet.

## Active Task

None.

## Key Invariants

(Add invariants here as they emerge.)
MEMINDEX
    touch "${dest}/handoffs/.gitkeep"
    touch "${dest}/tasks/.gitkeep"
    printf 'Cairn initialized at %s — point your agent at START-HERE.md\n' "$dest"
}

cmd_status() {
    if [ -f "cairn/START-HERE.md" ]; then
        cairn_root="cairn"
    elif [ -f "START-HERE.md" ]; then
        cairn_root="."
    else
        printf 'ERROR: Cannot find cairn root. Run from the repo root or cairn/ directory.\n' >&2
        exit 4
    fi
    start_here="${cairn_root}/START-HERE.md"
    mem_dir="${cairn_root}/memory"
    hdoffs="${cairn_root}/handoffs"
    printf '=== Cairn Status ===\n\n'
    cur_status=$(grep -A1 "^## Current Status" "$start_here" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
    active_task=$(grep -A1 "^## Active Task" "$start_here" 2>/dev/null | tail -1 | sed 's/^[[:space:]]*//')
    printf 'Current Status:  %s\n' "$cur_status"
    printf 'Active Task:     %s\n' "$active_task"
    total=0
    if [ -d "$mem_dir" ]; then
        tmpf=$(mktemp)
        find "$mem_dir" -name "*.md" > "$tmpf"
        while IFS= read -r f; do
            lc=$(awk 'END{print NR}' "$f")
            total=$((total + lc))
        done < "$tmpf"
        rm -f "$tmpf"
    fi
    printf 'Memory Budget:   %d/1000 lines used\n' "$total"
    last_handoff="None yet"
    if [ -d "$hdoffs" ]; then
        tmpf=$(mktemp)
        find "$hdoffs" -name "*.md" ! -name ".gitkeep" | sort > "$tmpf"
        if [ -s "$tmpf" ]; then
            last_handoff=$(basename "$(tail -1 "$tmpf")")
        fi
        rm -f "$tmpf"
    fi
    printf 'Last Handover:   %s\n' "$last_handoff"
    stale=0
    if [ -d "$hdoffs" ] && [ -d "$mem_dir" ]; then
        tmpf=$(mktemp)
        find "$hdoffs" -name "*.md" ! -name ".gitkeep" > "$tmpf"
        if [ -s "$tmpf" ]; then
            tmpm=$(mktemp)
            find "$mem_dir" -name "*.md" ! -name ".gitkeep" > "$tmpm"
            while IFS= read -r mf; do
                newer=$(find "$hdoffs" -name "*.md" ! -name ".gitkeep" -newer "$mf" | head -1)
                [ -n "$newer" ] && stale=$((stale + 1))
            done < "$tmpm"
            rm -f "$tmpm"
        fi
        rm -f "$tmpf"
    fi
    if [ "$stale" -gt 0 ]; then
        printf 'Staleness:       WARNING — %d memory file(s) may be stale\n' "$stale"
    else
        printf 'Staleness:       OK\n'
    fi
    printf '\nValidator:       Run sh cairn/tools/validate.sh to check\n'
}

case "${1:-}" in
    init)   shift; cmd_init "$@" ;;
    status) cmd_status ;;
    '')     usage ;;
    *)      printf 'Unknown command: %s\n' "$1" >&2; usage ;;
esac
