---
name: test-analysis
slug: test-analysis
description: >-
  Analyzes existing tests for a module or file: coverage gaps, missing behaviors, quality issues.
  TRIGGER when: user asks to analyze tests, audit test coverage, or find what's missing in tests.
  Args: optional "<module-or-file>" to scope the analysis.
---

## IO

**Inputs**
- Target (from args or prompt): module path, file, or directory to analyze
- Existing source files for the target
- Existing test files for the target

**Outputs**
- Analysis report in response (structured, no file written)

## Constraints

- Read-only: no source or test file changes
- No assumptions — if target is unspecified, ask before proceeding
- Only reference files confirmed to exist

## Process

1. Parse target from args/prompt. If missing: ask "which module or file to analyze?"
2. Find source files for the target
3. Find existing test files for the target (co-located or in test dirs)
4. For each public behavior in the source: determine if it is tested, partially tested, or untested
5. Identify quality issues in existing tests (no assertions, non-deterministic, testing internals)
6. Report findings

## Output format

```
## Target
<module or file analyzed>

## Existing test files
<list: path — omit if none>

## Coverage gaps
<bullets: behavior + file:line in source that has no test>

## Partial coverage
<bullets: behavior + what's missing>

## Quality issues
<bullets: issue + test file:line>

## Covered behaviors
<bullets: behavior + test file:line>

## Recommendation
<1–3 sentences on highest-priority gaps to address>
```

Omit empty sections entirely.

## Rules

- Public behaviors only — do not flag untested private helpers
- Bullets over prose, always
- Every finding cites `file:line`
- If no test files exist: output Coverage gaps for all public behaviors, skip other sections
