# cairn/tools

Two validators ship with Cairn. `validate.sh` is the canonical tool — it requires no runtime beyond `/bin/sh`. `validate.py` is an optional alternative for Python users.

## validate.sh (canonical)

```bash
# Auto-detect cairn root (looks for START-HERE.md in CWD or parent):
sh cairn/tools/validate.sh

# Or pass the cairn root explicitly:
sh cairn/tools/validate.sh /path/to/cairn
```

## validate.py (optional alternative)

```bash
python cairn/tools/validate.py
python cairn/tools/validate.py /path/to/cairn
```

## cairn.sh — CLI

```bash
# Scaffold cairn/ in a new or existing repo:
sh cairn/tools/cairn.sh init [target-dir]

# Show current task, memory budget, staleness:
sh cairn/tools/cairn.sh status
```

## Exit Codes (both validators)

| Code | Meaning | Output prefix |
|------|---------|---------------|
| `0` | Healthy | `OK: cairn/ is healthy.` |
| `1` | Size violation — file over cap, or memory/ over budget | `SIZE VIOLATION:` |
| `2` | Structure error — handoff missing a required section | `STRUCTURE ERROR:` |
| `3` | Staleness — memory file not updated since last handover | `STALENESS:` |
| `4` | Config error — bad `.cairn.toml` or cairn root not found | `ERROR:` |

When multiple violations exist, exit code is the highest applicable.

## Configuration

Create `.cairn.toml` at the cairn root to override defaults:

```toml
max_file_lines = 200       # per-file line cap (default: 200)
max_memory_lines = 1000    # total memory/ budget in lines (default: 1000)
git_behavior = off         # off | on | strict (default: off)
```
