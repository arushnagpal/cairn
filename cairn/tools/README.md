# cairn/tools

## validate.py

The Cairn validator. Enforces all protocol safeguards.

### Usage

```bash
# Auto-detect cairn root (looks for START-HERE.md):
python cairn/tools/validate.py

# Or pass the cairn root explicitly:
python cairn/tools/validate.py /path/to/cairn
```

### Exit Codes

| Code | Meaning | Output prefix |
|------|---------|---------------|
| `0` | Healthy | `OK: cairn/ is healthy.` |
| `1` | Size violation — file over cap, or memory/ over budget | `SIZE VIOLATION:` |
| `2` | Structure error — handoff missing a required section | `STRUCTURE ERROR:` |
| `3` | Staleness — memory file not updated since last handover | `STALENESS:` |
| `4` | Config error — bad `.cairn.toml` or cairn root not found | `ERROR:` |

When multiple violations exist, exit code is the highest applicable.

### Configuration

Create `.cairn.toml` at the cairn root to override defaults:

```toml
max_file_lines = 200       # per-file line cap (default: 200)
max_memory_lines = 1000    # total memory/ budget in lines (default: 1000)
git_behavior = off         # off | on | strict (default: off)
```

`git_behavior = strict` fails if a product file was hard-deleted instead of superseded.
