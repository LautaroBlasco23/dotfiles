---
name: testing-integration
slug: testing-integration
description: >-
  Standards for integration tests — multiple units wired together against real
  infrastructure (DB, HTTP server, message broker).
  MANUAL INVOCATION ONLY via the `/testing-integration` slash command, or when the
  user explicitly asks for "integration tests". DO NOT auto-trigger — the default
  `testing` skill handles unit tests; this skill must be opted into.
---

# Testing — Integration

Verifies that **collaborations between units** work against **real infrastructure**. Pairs with the `testing` skill (unit) — the comment protocol, naming, and user-facing output rules all carry over.

## When this skill applies

A test belongs here when it exercises **at least two** of:

- Real database (Postgres, Redis, etc.) in a container
- Real HTTP server started in-process or as a child process
- Real message broker / queue / cache
- Multiple modules wired through their real dependency injection graph

If the test can pass with an in-memory fake and no I/O, it belongs in `testing` (unit), not here.

## Core philosophy

- **Integration = truth at the seams.** Exercise the wiring that unit tests intentionally skip.
- **Real, disposable, deterministic.** Real infra, spun up per test run, reset between tests.
- **Fewer, richer tests.** Integration tests are slower — cover the seams, not every branch.
- **No shared mutable state across tests.** Either reset state, or give each test its own namespace/schema/container.

## Infrastructure — disposable by default

- **Prefer Testcontainers** (or equivalent) over long-running local services
- `docker-compose` is acceptable when containers are heavy and shared across a suite
- Services are started before the suite, torn down after — never rely on the developer's machine state
- Network ports are dynamic; never hardcode

## Test data lifecycle

Pick one strategy and stick to it per suite:

1. **Truncate-after-each** — simple, safe, slow. Good default.
2. **Transaction-per-test with rollback** — fast, but only works if the code under test doesn't commit its own transactions.
3. **Unique-namespace-per-test** — fresh schema / prefixed keys / unique tenant ID. Enables parallelism.

Seed only what the test needs. Global seed fixtures become landmines.

## Determinism rules

- Freeze time at the boundary (inject clock, or use a library-level time freezer)
- Seed randomness; stub IDs where they would leak into assertions
- No outbound network beyond the containerized services (block it if possible)
- Tests must pass in any order and in parallel where the data strategy allows

## What to test here

- Repository queries against the real SQL dialect (constraint violations, indexes, casting)
- HTTP handlers through the real router + middleware stack
- Transaction boundaries and rollback on error
- Schema migrations applying cleanly from a blank DB
- Serialization contracts between services (envelope format, timestamps, enums)

## What NOT to test here

- Pure logic already covered by unit tests — redundant and slow
- Full user journeys across a UI — that's E2E (`/testing-e2e`)
- Third-party library internals
- Performance or load characteristics

## Parallelism

- Safe when each test owns its data (unique schema, unique tenant, unique prefix)
- Unsafe with a shared database and truncate-between — either serialize the suite or partition the data

## Comment protocol — same as unit, plus infra notes

Reuse the unit-testing file header and per-test comment rules (see `testing` skill). In addition, the file header must include:

- **Infrastructure** — what containers/services this suite needs
- **Data strategy** — truncate / rollback / namespace
- **Parallel-safe?** — yes/no and why

Example header (Go):

```go
// user_repository_integration_test.go
//
// Subject: internal/user.Repository against real Postgres 16.
// Scope:   SQL correctness — constraint violations, index behavior, upserts.
// Out of scope:
//   - service-layer rules          → user_service_test.go       (unit)
//   - HTTP contract                → user_handler_integration_test.go
// Infrastructure: Testcontainers postgres:16-alpine, migrations applied on startup.
// Data strategy: transaction-per-test with rollback.
// Parallel-safe: yes — each test runs in its own tx.
```

Per-test comments still answer: why this test exists, what it covers, edge cases, cross-refs to sibling tests (unit or integration).

## Assertions

- Assert on observable state through the public API you're integrating (HTTP response, rows returned by a read), not by poking internal tables the production code wouldn't touch
- Verify both the **happy path** and at least one **error path per integration seam** (e.g., unique-constraint violation, timeout, connection reset)

## Naming

- File suffix makes the category obvious: `*_integration_test.go`, `*.integration.test.ts`
- Test names follow the unit convention: `<subject>_<condition>_<expectedOutcome>`

## Agent output protocol

Same as the unit skill: keep the chat response short, put the explanation in the file.

> Added/updated integration tests at `path/to/foo_integration_test.go`. Infra requirements, data strategy, and per-test notes are in the file header and per-test comments.

If the user's machine is missing required infrastructure (Docker, a container runtime), say so in the chat message and point to what needs to be installed — don't silently fall back to mocks.

## Minimum quality gate

Before reporting done:

1. File header states infrastructure, data strategy, and parallel-safety
2. Per-test comments present and informative
3. Suite starts from a clean slate — no reliance on prior test runs
4. Tests pass twice in a row locally (catches setup-bleed bugs)
5. At least one error-path test per integration seam
6. No hardcoded ports, no hardcoded host-machine paths

## Out of scope

- **Unit-level logic** → use the `testing` skill
- **Full user journeys through a UI** → use `/testing-e2e`
- **Load / performance / soak tests** → separate concern; not covered by any current skill
