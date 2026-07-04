#!/bin/sh
# Cairn validator — enforces protocol safeguards.
#
# Usage: sh cairn/tools/validate.sh [cairn-root]
# Exit codes: 0=healthy 1=size 2=structure 3=staleness 4=config

DEFAULT_MAX_FILE_LINES=200
DEFAULT_MAX_MEMORY_LINES=1000

max_file_lines=$DEFAULT_MAX_FILE_LINES
max_memory_lines=$DEFAULT_MAX_MEMORY_LINES
exit_code=0

emit() { printf '%s\n' "$1"; }

raise() { if [ "$1" -gt "$exit_code" ]; then exit_code="$1"; fi; }

load_config() {
    config_file="${1}/.cairn.toml"
    [ ! -f "$config_file" ] && return
    while IFS= read -r line; do
        stripped=$(printf '%s' "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        case "$stripped" in ''|\#*) continue ;; esac
        key=$(printf '%s' "$stripped" | cut -d= -f1 | sed 's/[[:space:]]*$//')
        val=$(printf '%s' "$stripped" | cut -d= -f2- | sed 's/^[[:space:]]*//' | sed 's/"//g' | sed "s/'//g")
        case "$key" in
            max_file_lines)
                case "$val" in
                    ''|*[!0-9]*)
                        printf 'ERROR: max_file_lines must be an integer, got: %s\n' "$val" >&2
                        exit 4 ;;
                    *) max_file_lines="$val" ;;
                esac ;;
            max_memory_lines)
                case "$val" in
                    ''|*[!0-9]*)
                        printf 'ERROR: max_memory_lines must be an integer, got: %s\n' "$val" >&2
                        exit 4 ;;
                    *) max_memory_lines="$val" ;;
                esac ;;
            git_behavior)
                case "$val" in
                    off|on|strict) ;;
                    *)
                        printf 'ERROR: git_behavior must be off|on|strict, got: %s\n' "$val" >&2
                        exit 4 ;;
                esac ;;
        esac
    done < "$config_file"
}

check_file_sizes() {
    cairn_root="$1"
    tmpf=$(mktemp)
    find "$cairn_root" -name "*.md" | sort > "$tmpf"
    while IFS= read -r f; do
        lc=$(awk 'END{print NR}' "$f")
        if [ "$lc" -gt "$max_file_lines" ]; then
            rel="${f#"${cairn_root}"/}"
            emit "SIZE VIOLATION: $rel is $lc lines (max $max_file_lines). Distill this file before adding more."
            raise 1
        fi
    done < "$tmpf"
    rm -f "$tmpf"
}

check_memory_budget() {
    cairn_root="$1"
    mem_dir="${cairn_root}/memory"
    [ ! -d "$mem_dir" ] && return
    total=0
    tmpf=$(mktemp)
    find "$mem_dir" -name "*.md" | sort > "$tmpf"
    while IFS= read -r f; do
        lc=$(awk 'END{print NR}' "$f")
        total=$((total + lc))
    done < "$tmpf"
    rm -f "$tmpf"
    if [ "$total" -gt "$max_memory_lines" ]; then
        emit "SIZE VIOLATION: cairn/memory/ totals $total lines (budget $max_memory_lines). Distill memory before adding more."
        raise 1
    fi
}

check_structure() {
    cairn_root="$1"
    hdoffs="${cairn_root}/handoffs"
    [ ! -d "$hdoffs" ] && return
    tmpf=$(mktemp)
    find "$hdoffs" -name "*.md" | sort > "$tmpf"
    while IFS= read -r f; do
        [ "$(basename "$f")" = ".gitkeep" ] && continue
        rel="${f#"${cairn_root}"/}"
        for heading in "## What I Did" "## Key Decisions" "## What's Next" "## Do Not Re-Read"; do
            if ! grep -qF "$heading" "$f"; then
                emit "STRUCTURE ERROR: $rel is missing required section '$heading'."
                raise 2
            fi
        done
    done < "$tmpf"
    rm -f "$tmpf"
}

check_staleness() {
    cairn_root="$1"
    hdoffs="${cairn_root}/handoffs"
    mem_dir="${cairn_root}/memory"
    [ ! -d "$hdoffs" ] || [ ! -d "$mem_dir" ] && return
    tmpf=$(mktemp)
    find "$hdoffs" -name "*.md" ! -name ".gitkeep" > "$tmpf"
    if [ ! -s "$tmpf" ]; then rm -f "$tmpf"; return; fi
    rm -f "$tmpf"
    tmpm=$(mktemp)
    find "$mem_dir" -name "*.md" ! -name ".gitkeep" | sort > "$tmpm"
    if [ ! -s "$tmpm" ]; then rm -f "$tmpm"; return; fi
    while IFS= read -r memfile; do
        newer=$(find "$hdoffs" -name "*.md" ! -name ".gitkeep" -newer "$memfile" | head -1)
        if [ -n "$newer" ]; then
            rel="${memfile#"${cairn_root}"/}"
            emit "STALENESS: $rel has not been updated since the last handover. Review and supersede if still accurate."
            raise 3
        fi
    done < "$tmpm"
    rm -f "$tmpm"
}

find_cairn_root() {
    if [ -n "$1" ]; then
        if [ ! -d "$1" ]; then
            printf 'ERROR: %s does not exist.\n' "$1" >&2
            exit 4
        fi
        printf '%s' "$1"
        return
    fi
    cwd="$(pwd)"
    if [ -f "${cwd}/START-HERE.md" ]; then printf '%s' "$cwd"; return; fi
    parent="$(dirname "$cwd")"
    if [ -f "${parent}/START-HERE.md" ]; then printf '%s' "$parent"; return; fi
    printf 'ERROR: Cannot find cairn root. Pass the path as an argument or run from the cairn/ directory.\n' >&2
    exit 4
}

cairn_root=$(find_cairn_root "${1:-}")
load_config "$cairn_root"
check_file_sizes "$cairn_root"
check_memory_budget "$cairn_root"
check_structure "$cairn_root"
check_staleness "$cairn_root"

if [ "$exit_code" -eq 0 ]; then printf 'OK: cairn/ is healthy.\n'; fi
exit "$exit_code"
