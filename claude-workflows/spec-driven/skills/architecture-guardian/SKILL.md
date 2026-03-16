---
name: architecture-guardian
slug: architecture-guardian
description: >-
  Scans new and modified files for architecture violations after implementation.
  TRIGGER when: user asks to check architecture, runs /architecture-guardian, or after /implement-feature.
---

# Architecture Guardian

Invoke the `architecture-guardian` agent to scan the implementation for violations.

Usage:
```
/architecture-guardian
```

Requires `.docs/implementation-log.md` and `context/architecture.md`.

## What happens

The `@architecture-guardian` agent will:
1. Read `context/architecture.md` for layer rules
2. Read `.docs/implementation-log.md` for the list of modified files
3. Scan each file for layer violations, circular dependencies, misplaced files, and domain leaks
4. Return APPROVED or a VIOLATIONS list with file and line references

## Output

`.docs/guardian-report.md`

## If violations are found

Fix the violations in the affected files, then re-run `/architecture-guardian`.

Do NOT proceed to `/review-code` if the guardian reports violations.

## Next step

After APPROVED, run `/review-code` for spec compliance validation.
