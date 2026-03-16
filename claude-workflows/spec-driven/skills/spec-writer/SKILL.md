---
name: spec-writer
slug: spec-writer
description: >-
  Writes a structured spec from a requirement before implementation begins.
  TRIGGER when: user asks to spec out a feature, write a spec, or define requirements.
---

# Spec Writer

Invoke the `spec-writer` agent to produce `.docs/spec.md` from the user's requirement.

Usage:
```
/spec-writer <requirement>
```

Example:
```
/spec-writer "create an order endpoint"
```

## What happens

The `@spec-writer` agent will:
1. Explore the codebase for existing domain context
2. Read `context/coding-standards.md` if present
3. Ask clarifying questions only if a business rule is truly ambiguous
4. Write a formal spec to `.docs/spec.md`

## Next step

After the spec is written, run `/create-plan` to generate the implementation task list.
