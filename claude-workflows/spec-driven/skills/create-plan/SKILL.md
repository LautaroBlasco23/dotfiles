---
name: create-plan
slug: create-plan
description: >-
  Generates an ordered implementation task list from .docs/spec.md.
  TRIGGER when: user asks to plan a feature, create a task list, or runs /create-plan.
---

# Create Plan

Invoke the `planner` agent to produce `.docs/plan.md` from the spec.

Usage:
```
/create-plan
```

Requires `.docs/spec.md` to exist. Run `/spec-writer` first if it doesn't.

## What happens

The `@planner` agent will:
1. Read `.docs/spec.md`
2. Read `context/architecture.md` for layer rules
3. Explore existing code to identify what already exists
4. Produce an ordered task list with file paths, layer assignments, and dependency notes

## Output

`.docs/plan.md` — ordered task list ready for the implementer.

## Next step

After the plan is ready, run `/implement-feature` to write the code.
