---
name: testing
slug: testing
description: >-
  Standards for writing user-oriented unit tests with self-documenting comments.
  TRIGGER when: user asks to add, write, create, update, edit, or fix tests; when implementing
  a feature that needs test coverage; when modifying existing test files.
  DO NOT TRIGGER for integration, E2E, load, or contract tests — those belong to a dedicated
  advanced-testing skill invoked explicitly via slash command.
---

# Testing (Unit)

Universal unit-testing standards. Language-agnostic — pair with the relevant `coding-*` skill for syntax (table-driven Go, Vitest TS, etc.). Integration and E2E are **out of scope** here; they live in an advanced-testing skill and must be invoked explicitly.

## Comment policy (important — overrides the default)

The global rule "default to writing no comments" **does not apply inside test files**. Tests are documentation for humans. Every test file and every test function gets explanatory comments.

## Philosophy — user-oriented tests

A test is a specification of behavior, read in the voice of the caller.

- Describe **what the code does for its user**, not how it does it
- The user may be an end-user, another function, a HTTP client, or a CLI — identify whose perspective you're testing from and make it explicit in the comment
- If a reader can't tell from the test *what the feature is supposed to do*, the test is failing its real job

## One behavior per test

- Each test verifies one behavior, one outcome
- Multiple related behaviors → multiple tests, not one mega-test with many assertions
- Arrange / Act / Assert — visually separated by blank lines
- Shared setup goes in helpers/fixtures, not in the test body

## Naming — tests read like sentences

Name tests so the name alone states the behavior. Avoid names that restate the function.

- Bad: `TestCreateUser`, `test('createUser')`
- Good: `TestCreateUser_RejectsEmptyEmail`, `it('rejects an email that is already taken')`

Pattern: `<subject>_<condition>_<expectedOutcome>` — or the describe/it equivalent.

## File header comment — required

Every test file starts with a short block comment covering:

1. **Subject** — what unit this file tests (file path or symbol)
2. **Scope** — what behaviors this file is responsible for
3. **Out of scope** — behaviors covered by sibling test files (link by name)
4. **Setup notes** — non-obvious context: fake clock, seeded RNG, in-memory DB, required fixtures

Keep it under ~15 lines. It is a map, not an essay.

Example (Go):

```go
// user_service_test.go
//
// Subject: internal/user.Service
// Scope:   creation, update, and deletion of users from the service layer's POV
//          (the caller is an HTTP handler, so input is already parsed structs).
// Out of scope:
//   - SQL behavior and constraint violations → user_repository_test.go
//   - HTTP parsing and status codes          → user_handler_test.go
// Setup:   uses an in-memory fake repo; clock is frozen at 2026-01-01T00:00:00Z.
```

Example (TypeScript):

```ts
/**
 * Subject: src/auth/login.ts — loginWithPassword
 * Scope:   password validation, rate-limit check, session issuance
 * Out of scope:
 *   - token signing        → tokens.test.ts
 *   - rate-limit internals → rateLimiter.test.ts
 * Setup: MSW intercepts /auth/*; crypto.randomUUID is stubbed to a fixed value.
 */
```

## Per-test comment — required

Every test gets a short comment above it (1–5 lines) answering:

1. **Why this test exists** — the behavior under test, in user-facing terms
2. **What it covers** — the specific branch, edge case, or contract
3. **Edge-case notes** — boundary / nil / empty / concurrency, if relevant
4. **Cross-reference** — if an adjacent behavior is covered by another test function, name it

Write for a teammate reading cold, not for yourself. If the comment only restates the test name, delete it and improve the name instead — redundancy is worse than absence.

Example:

```go
// Rejects emails that pass syntax validation but already belong to another user.
// Covers the "duplicate email" branch; syntax errors are covered by
// TestCreateUser_RejectsMalformedEmail. Edge: comparison is case-insensitive,
// so "Foo@x.com" collides with "foo@x.com".
func TestCreateUser_RejectsDuplicateEmail(t *testing.T) { ... }
```

## Edge-case checklist

For every public behavior, think through and — if meaningful — add tests for:

- Empty input (empty string, empty slice, empty map)
- Nil / undefined / zero value
- Boundary values (0, 1, max, max+1, negative)
- Unicode / whitespace / casing if the input is textual
- Error path — every returned error should be exercised at least once
- Idempotency — calling twice should behave as documented
- Concurrency — only if the unit is explicitly concurrent

Do not invent edge cases the code doesn't actually handle. If a branch doesn't exist, don't test it.

## What to test

- The **public API** of the unit (exported functions, methods, hooks, components)
- Observable behavior — return values, emitted events, state transitions, calls to collaborators
- Error cases with the same seriousness as happy paths

## What NOT to test

- Private helpers — they're covered transitively by public-API tests
- Third-party library internals
- Trivial wrappers that only forward arguments
- Generated code

## Dependencies — real over mocked

- Prefer real dependencies when they are fast and deterministic (pure functions, in-memory stores)
- Use small hand-written fakes when the real thing is slow, networked, or non-deterministic
- Reach for mocks only when you need to assert on *interactions* (e.g., "was `send()` called once with X?")
- Time, randomness, and IDs must be injectable — never call `time.Now()` / `Math.random()` / `uuid()` directly from tested code

## Deterministic by construction

- Freeze time; seed randomness; stub IDs
- No network, no filesystem (unless using a tmp dir cleaned up by the test framework)
- Tests must pass in any order, in parallel, and run 1000× without flaking
- If a test is flaky, it is broken — never retry-to-green

## Assertions

- Assert on the smallest thing that proves the behavior
- Prefer equality on whole output structs over many field-by-field checks
- Error assertions: check the error *type/sentinel*, not the message string
- If an assertion fails, the message should tell the reader what was expected and what happened — not just "false"

## Agent output protocol

When the agent (main conversation or implementer) creates or updates tests, the **user-facing message stays short**:

> Added/updated tests at `path/to/foo_test.go`. Full context and per-test notes are in the file header and per-test comments.

Do **not** restate the testing strategy in the chat response. The test file itself is the documentation — if something important is missing from the chat, it's missing from the file, and the fix is to edit the file.

## Out of scope — when to escalate

If the user asks for:

- **Integration tests** (real DB, real HTTP server, multiple units wired together) → invoke `/testing-integration`
- **E2E tests** (browser, full stack, deployed env) → invoke `/testing-e2e`
- **Contract / snapshot / property-based / mutation / load / performance tests** → not yet covered by any skill; ask the user before improvising

Stop and surface the right skill to the user. Do not improvise these test types under the `testing` skill.

## Minimum quality gate before reporting done

Before declaring a test task complete:

1. File header comment is present and accurate
2. Every test has a per-test comment that adds information beyond the name
3. Happy path + at least one meaningful edge case per public behavior
4. Error paths for every returned/thrown error
5. No flakiness sources (real clock, real randomness, ordering dependencies)
6. Tests pass locally; run the suite, don't assume
