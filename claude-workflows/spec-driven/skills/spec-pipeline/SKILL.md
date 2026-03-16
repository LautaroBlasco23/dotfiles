---
name: spec-pipeline
slug: spec-pipeline
description: >-
  Runs the full spec-driven pipeline: spec → plan → implement → guardian → review.
  TRIGGER when: user says "run spec pipeline", "full pipeline", or /spec-pipeline.
---

# Spec Pipeline

Runs the complete spec-driven development workflow end-to-end.

Usage:
```
/spec-pipeline <requirement>
```

Example:
```
/spec-pipeline "create an order endpoint"
```

## Pipeline Steps

Run each step sequentially. Do not proceed to the next step if a step fails or produces violations.

```
1. @spec-writer   → .docs/spec.md
2. @planner       → .docs/plan.md
3. @implementer   → code + .docs/implementation-log.md
4. @architecture-guardian → .docs/guardian-report.md
5. @validator     → .docs/validation.md
```

## Step 4 Gate

If the `@architecture-guardian` reports VIOLATIONS FOUND, stop the pipeline.
Fix violations in the implementation, then resume from step 4.

## Step 5 Gate

If the `@validator` reports VIOLATIONS FOUND, stop the pipeline.
Fix violations in the implementation, then resume from step 4.

## Completion

The pipeline is complete when:
- `.docs/guardian-report.md` says APPROVED
- `.docs/validation.md` says APPROVED

At that point, the feature is ready for commit.
