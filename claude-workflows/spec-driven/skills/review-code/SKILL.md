---
name: review-code
slug: review-code
description: >-
  Validates that the implementation satisfies every requirement in .docs/spec.md.
  TRIGGER when: user asks to review code, validate the implementation, or runs /review-code.
---

# Review Code

Invoke the `validator` agent to check spec compliance.

Usage:
```
/review-code
```

Requires `.docs/spec.md` and `.docs/implementation-log.md`.
Should only run after `/architecture-guardian` returns APPROVED.

## What happens

The `@validator` agent will:
1. Extract every business rule, API contract, and domain model requirement from `.docs/spec.md`
2. Read each implementation file
3. Verify each requirement is satisfied with a file and line reference
4. Flag any missing enforcement

## Output

`.docs/validation.md` with APPROVED or VIOLATIONS FOUND.

## If violations are found

Fix the issues in the implementation, then re-run `/review-code`.
