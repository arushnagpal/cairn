# START HERE

> This file is the entry point. A cold agent reads this file first — nothing else.
> Keep it under 50 lines.

## Current Status

<!-- One sentence. What just finished; what is now active. -->
Task T<N> complete. Now starting T<N+1>: <short description>.

## Active Task

[T<N+1> — <title>](tasks/T<N+1>-<slug>.md)

## Memory

[Always-read](memory/INDEX.md) — read this before reading anything else.

## Last Handover

[T<N> handover](handoffs/YYYY-MM-DD-<slug>.md)

## Protocol

[How Cairn works](protocol/00-overview.md) — read this if you are new to this repo.

## Validator

```bash
sh cairn/tools/validate.sh
```
Run this before stopping work.
