---
name: implement-feature
slug: implement-feature
description: >-
  Implements code following .docs/plan.md and .docs/spec.md.
  TRIGGER when: user asks to implement a feature or runs /implement-feature.
---

# Implement Feature

Invoke the `implementer` agent to write code following the plan and spec.

Usage:
```
/implement-feature
```

Requires both `.docs/spec.md` and `.docs/plan.md`. Run `/spec-writer` and `/create-plan` first.

## What happens

The `@implementer` agent will:
1. Read `.docs/spec.md` and `.docs/plan.md`
2. Read `context/architecture.md` and `context/coding-standards.md`
3. Explore existing code to match established patterns
4. Implement each task in order, logging progress to `.docs/implementation-log.md`

## Output

- All implementation files in their correct layer directories
- `.docs/implementation-log.md` — progress log per task

## Next step

After implementation, run `/architecture-guardian` to check for violations before review.
