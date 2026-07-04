---
id: T1
title: Repo Scaffolding + .meta/tasks/
depends_on: []
status: completed
---

## Context
First task. Sets up the directory structure and writes all .meta/tasks/ files using
Cairn's own protocol — proving dogfooding from day 1.

## Inputs
- BUILD-PROMPT.md
- docs/superpowers/specs/2026-07-03-cairn-design.md

## Outputs
- All directories and .gitkeep files
- .meta/tasks/T1–T8.md
- .meta/memory/INDEX.md

## Acceptance Criteria
- [ ] Directory tree matches the design spec
- [ ] Each .meta/tasks/*.md is self-contained (cold agent can pick it up)
- [ ] git init complete
