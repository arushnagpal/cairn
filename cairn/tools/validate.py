#!/usr/bin/env python3
"""Cairn validator — enforces protocol safeguards.

Exit codes:
  0  healthy
  1  size violation (file over line cap, or memory/ over budget)
  2  structure error (handoff missing required section)
  3  staleness (memory file older than newest handover)
  4  config error (bad .cairn.toml or cairn root not found)

Usage:
  python cairn/tools/validate.py [cairn-root]

Auto-detects cairn root by looking for START-HERE.md in CWD or one level up.
"""

import sys
from pathlib import Path

DEFAULT_MAX_FILE_LINES = 200
DEFAULT_MAX_MEMORY_LINES = 1000

REQUIRED_HANDOFF_HEADINGS = [
    "## What I Did",
    "## Key Decisions",
    "## What's Next",
    "## Do Not Re-Read",
]


def load_config(cairn_root):
    config = {
        "max_file_lines": DEFAULT_MAX_FILE_LINES,
        "max_memory_lines": DEFAULT_MAX_MEMORY_LINES,
        "git_behavior": "off",
    }
    config_path = cairn_root / ".cairn.toml"
    if not config_path.exists():
        return config
    for line in config_path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, val = line.partition("=")
        key = key.strip()
        val = val.strip().strip('"').strip("'")
        if key in ("max_file_lines", "max_memory_lines"):
            try:
                config[key] = int(val)
            except ValueError:
                print(
                    "ERROR: {} must be an integer, got {!r}".format(key, val),
                    file=sys.stderr,
                )
                sys.exit(4)
        elif key == "git_behavior":
            if val not in ("off", "on", "strict"):
                print(
                    "ERROR: git_behavior must be off|on|strict, got {!r}".format(val),
                    file=sys.stderr,
                )
                sys.exit(4)
            config[key] = val
    return config


def check_file_sizes(cairn_root, max_lines):
    violations = []
    for md_file in sorted(cairn_root.rglob("*.md")):
        lines = len(md_file.read_text().splitlines())
        if lines > max_lines:
            rel = md_file.relative_to(cairn_root)
            violations.append(
                "SIZE VIOLATION: {} is {} lines (max {}). "
                "Distill this file before adding more.".format(rel, lines, max_lines)
            )
    return violations


def check_memory_budget(cairn_root, max_lines):
    memory_dir = cairn_root / "memory"
    if not memory_dir.exists():
        return []
    total = sum(
        len(f.read_text().splitlines())
        for f in sorted(memory_dir.rglob("*.md"))
    )
    if total > max_lines:
        return [
            "SIZE VIOLATION: cairn/memory/ totals {} lines (budget {}). "
            "Distill memory before adding more.".format(total, max_lines)
        ]
    return []


def check_structure(cairn_root):
    errors = []
    handoffs_dir = cairn_root / "handoffs"
    if not handoffs_dir.exists():
        return errors
    for md_file in sorted(handoffs_dir.glob("*.md")):
        if md_file.name == ".gitkeep":
            continue
        content = md_file.read_text()
        rel = md_file.relative_to(cairn_root)
        for heading in REQUIRED_HANDOFF_HEADINGS:
            if heading not in content:
                errors.append(
                    "STRUCTURE ERROR: {} is missing required section '{}'.".format(
                        rel, heading
                    )
                )
    return errors


def check_staleness(cairn_root):
    handoffs_dir = cairn_root / "handoffs"
    memory_dir = cairn_root / "memory"
    if not handoffs_dir.exists() or not memory_dir.exists():
        return []
    handoff_files = [f for f in handoffs_dir.glob("*.md") if f.name != ".gitkeep"]
    memory_files = [f for f in memory_dir.rglob("*.md") if f.name != ".gitkeep"]
    if not handoff_files or not memory_files:
        return []
    last_handover = max(f.stat().st_mtime for f in handoff_files)
    stale = []
    for f in sorted(memory_files):
        if f.stat().st_mtime < last_handover:
            rel = f.relative_to(cairn_root)
            stale.append(
                "STALENESS: {} has not been updated since the last handover. "
                "Review and supersede if still accurate.".format(rel)
            )
    return stale


def find_cairn_root(arg):
    if arg is not None:
        p = Path(arg)
        if not p.exists():
            print("ERROR: {} does not exist.".format(arg), file=sys.stderr)
            sys.exit(4)
        return p
    cwd = Path.cwd()
    for candidate in (cwd, cwd.parent):
        if (candidate / "START-HERE.md").exists():
            return candidate
    print(
        "ERROR: Cannot find cairn root. Pass the path as an argument "
        "or run from the cairn/ directory.",
        file=sys.stderr,
    )
    sys.exit(4)


def main():
    arg = sys.argv[1] if len(sys.argv) > 1 else None
    cairn_root = find_cairn_root(arg)
    config = load_config(cairn_root)

    errors = []
    exit_code = 0

    size_errors = check_file_sizes(cairn_root, config["max_file_lines"])
    size_errors += check_memory_budget(cairn_root, config["max_memory_lines"])
    if size_errors:
        errors.extend(size_errors)
        exit_code = max(exit_code, 1)

    structure_errors = check_structure(cairn_root)
    if structure_errors:
        errors.extend(structure_errors)
        exit_code = max(exit_code, 2)

    staleness_errors = check_staleness(cairn_root)
    if staleness_errors:
        errors.extend(staleness_errors)
        exit_code = max(exit_code, 3)

    if errors:
        for e in errors:
            print(e)
        sys.exit(exit_code)

    print("OK: cairn/ is healthy.")


if __name__ == "__main__":
    main()
