# Cairn

> The enforced agent-to-agent handoff protocol.

Cairn is a copyable `cairn/` folder that lets one AI agent hand an in-progress task to
another without losing context — even when the first agent dies mid-step. Unlike every
other handoff protocol, Cairn actually *enforces* its rules: `validate.py` fails your
check when memory rots.

## What's in this repo

| Path | What it is |
|------|-----------|
| `cairn/` | The protocol — copy this folder into your repo |
| `.meta/` | How *this* repo was built (live dogfooding proof) |
| `ROADMAP.md` | Features designed but not yet built |

## Product docs

See [`cairn/README.md`](cairn/README.md) for the full pitch, comparison table,
quickstart, and protocol explanation.

## The dogfooding story

Cairn was built by Cairn. The `.meta/` directory contains the task files, handovers,
and always-read memory that agents used to construct `cairn/` — the same artifacts the
protocol asks every user to maintain. The `.meta/handoffs/` directory holds a complete
record of every build decision, written by the agents who made them.

## Validate this repo

```bash
python cairn/tools/validate.py cairn/
```

Expected: `OK: cairn/ is healthy.`
