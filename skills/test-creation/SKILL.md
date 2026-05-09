---
name: test-creation
slug: test-creation
description: >-
  Creates or improves tests for a module based on user-specified test types and target.
  TRIGGER when: user asks to create, add, or improve tests.
  Args: "<test-types> for <module-or-file>" — e.g., "unit tests for auth module",
        "integration and unit tests for user service", "add edge cases to payments/handler.go"
---

## IO

**Inputs**
- Args (required): test types + target module/file
  - Test types: `unit` | `integration` | `e2e` | `edge cases` | combination
  - Target: module path, file, or directory
- Source files for the target (read from codebase)
- Existing test files for the target (read if present)

**Outputs**
- Test files created or updated
- Summary in response: what was created/updated and where

## Constraints

- If args are missing or ambiguous: stop, ask "what test types and which module?"
- Only create tests for behaviors that exist in the source — no invented scenarios
- Do NOT modify source files
- Apply `coding-principles` to test code
- Do NOT commit

## Process

1. Parse args: extract test types and target. If either is missing: ask before proceeding.
2. Read target source files — identify all public behaviors to test.
3. Read existing test files (if any) — identify already-covered behaviors to avoid duplication.
4. For each requested test type, apply the corresponding approach:

### Unit
- Test each public function/method in isolation
- One test per behavior, one assertion per outcome
- Use real dependencies unless slow/non-deterministic — then use minimal fakes
- Name tests: `<subject>_<condition>_<expectedOutcome>` or describe/it equivalent
- Freeze time, seed randomness, stub IDs where needed

### Integration
- Test multiple units wired together against real infrastructure
- Use containers (Testcontainers or equivalent) — never rely on dev machine state
- One data strategy per suite: truncate-after-each | transaction-rollback | namespace-per-test
- Seed only what the test needs

### E2E
- Test full user journeys against a running stack
- Locate elements by role/label/text — never CSS classes or nth-child
- No hardcoded sleep — use auto-wait or poll the API
- Isolate data per test: create fresh user/tenant, clean up after

### Edge cases
- Empty input, nil/zero values, boundary values (0, 1, max, max+1)
- Unicode/whitespace/casing for textual inputs
- Every returned error exercised at least once
- Idempotency where documented

5. Write test files co-located with source (or in the project's test directory if that's the convention).
6. Add file header comment: subject, scope, out-of-scope, setup notes.
7. Add per-test comment for each test: why it exists, what it covers, edge-case notes.

## Output format (response summary)

```
## Created / updated
<test file path> — <brief description of what was added>

## Test types added
<type>: <count> tests covering <behaviors>

## Not covered
<behaviors skipped and why — omit if none>
```

## Rules

- File header + per-test comments required — tests are documentation
- Test names read like sentences describing behavior, not function names
- Never test private helpers — covered transitively by public-API tests
- No network/filesystem in unit tests — use tmp dirs if filesystem is needed
- Tests must be deterministic: pass in any order, in parallel, 100× without flaking
- If a test type requires infrastructure not present (Docker for integration, browser for e2e): report it, do not silently fall back to mocks
