---
name: testing-e2e
slug: testing-e2e
description: >-
  Standards for end-to-end tests — full user journeys against a running stack
  (frontend + backend + DB). Browser-driven for UI, full HTTP for API-only.
  MANUAL INVOCATION ONLY via the `/testing-e2e` slash command, or when the user
  explicitly asks for "e2e" / "end-to-end" tests. DO NOT auto-trigger — the default
  `testing` skill handles unit tests and `/testing-integration` handles service-level
  wiring; this skill must be opted into.
---

# Testing — End-to-End

Verifies **complete user journeys** against a **fully running stack**. Slow, expensive, highest-value when scoped to critical paths only. Pairs with the `testing` skill (unit) and `testing-integration` — the comment protocol, naming, and user-facing output rules all carry over.

## When this skill applies

A test belongs here when all of the following are true:

- It exercises a full journey a real user (or API consumer) would perform
- The stack is running as it runs in production: real frontend, real backend, real DB, real network
- The assertion is on **user-visible outcome** (rendered UI, HTTP response, side effect in a database)

If the test only validates backend wiring, it belongs in `/testing-integration`. If it validates a single function, it belongs in `testing` (unit).

## Core philosophy

- **Fewest tests that give the most confidence.** E2E is the top of the pyramid — keep it small.
- **Critical paths only.** Signup, login, checkout, the one flow that loses money if broken. Not every button.
- **Test like the user.** Locate elements by role, label, or visible text — not CSS classes or DOM structure.
- **Isolation is non-negotiable.** Every run gets its own data, its own user, its own tenant.

## Tooling

- **Browser-driven UI:** Playwright preferred (traces, auto-waiting, parallel workers built in). Cypress acceptable for existing projects.
- **API-only E2E:** any HTTP client — the target is the deployed stack, not a mock
- **Never use Selenium for new suites** — Playwright covers the same ground with better ergonomics

## Environment

- Runs against a **seeded, staging-like environment** — never production
- Environment URL is config, not hardcoded
- Credentials and tokens come from env vars / secret store, never checked in
- Prefer ephemeral envs per PR when infrastructure allows it

## Test data — isolated per run

- Create a fresh user/tenant at the start of each test (or per worker, if reused safely)
- Delete or mark-as-test at the end — don't pollute the shared env
- Never assume pre-existing data "will be there"
- Use a recognizable prefix (`e2e-test-...`) so leaks are identifiable

## Selectors — in order of preference

1. Accessible role + name: `getByRole('button', { name: /sign in/i })`
2. Label text: `getByLabel('Email')`
3. Visible text: `getByText(...)`
4. `data-testid` as an explicit last resort — but add one rather than coupling to CSS
5. **Never** CSS classes, nth-child selectors, or XPath — they rot on every UI change

## Waiting — auto, never sleep

- Playwright/Cypress auto-wait for the element to be ready. Use it.
- Assert on the state you need (`expect(locator).toBeVisible()`) — the wait is part of the assertion
- `sleep`, `setTimeout`, arbitrary delays → **banned**. Flakiness factory.
- If you genuinely need to wait for a backend job, poll the API or subscribe to an event — don't guess a duration

## Flakiness policy

- A flaky test is a broken test. Never retry-to-green.
- Quarantine (disable + ticket) > leave flaky
- Capture traces/videos/screenshots on every failure — enable by default
- Run the suite twice in CI on every merge candidate; if either run fails, the merge is blocked

## What to test here

- Critical user journeys from landing to goal completion (signup → first meaningful action)
- Cross-surface flows that depend on auth, state, and navigation working together
- Payment, billing, data export — anything where silent breakage is catastrophic
- Accessibility smoke: role-based selectors double as a weak accessibility check

## What NOT to test here

- Every field validation — that's unit/integration
- Every branch of business logic — unit tests are cheaper and more precise
- Visual pixel regressions — use a dedicated visual-regression tool, not E2E
- Performance — use a dedicated load tool

## Comment protocol — same as unit/integration, plus env notes

Reuse the file header and per-test comment rules from `testing`. In addition, the file header must include:

- **Target environment** — which env this suite runs against (and how to override)
- **Auth strategy** — how the user is created and signed in (API bootstrap vs UI flow)
- **Data cleanup** — what this suite creates and how it's removed

Example header (Playwright + TypeScript):

```ts
/**
 * Subject: Checkout journey — cart → payment → confirmation
 * Scope:   the happy path + "card declined" branch from a signed-in user's POV
 * Out of scope:
 *   - cart item-level rules       → unit tests in cart/
 *   - payment provider contract   → integration tests in payments/
 * Target env: $E2E_BASE_URL (defaults to staging)
 * Auth: user is created via API bootstrap at test start (skips signup UI)
 * Cleanup: test user and their orders are deleted in afterEach
 */
```

Per-test comments still answer: why the journey exists, what user-visible outcome it asserts, edge cases, and cross-refs.

## Naming

- File suffix makes the category obvious: `*.e2e.test.ts`, `*_e2e_test.go`
- Test names describe the journey in user terms: `signs up with email and sees the onboarding screen`, not `testSignupHandler`

## Assertions

- Assert on what the **user perceives**: visible text, URL, visible button state, a confirmation email arriving in an inbox the test controls
- For backend-only E2E: assert on the public HTTP contract (status, body shape, headers) — not on internal DB rows the user couldn't see

## Agent output protocol

Same as unit/integration: keep the chat response short, put the explanation in the file.

> Added/updated E2E tests at `path/to/checkout.e2e.test.ts`. Target env, auth strategy, and per-test notes are in the file header and per-test comments.

If the target environment is unreachable or credentials are missing, say so in the chat message and point to what needs to be configured — don't silently skip or invent mocks.

## Minimum quality gate

Before reporting done:

1. File header states target env, auth strategy, and cleanup
2. Per-test comments present and informative
3. Selectors are role/label/text-based — no CSS-class coupling
4. No `sleep` / arbitrary delays anywhere
5. Each test creates and cleans up its own data
6. Suite passes twice in a row against the target env (flake check)
7. On-failure artifacts (trace/video/screenshot) are enabled

## Out of scope

- **Unit logic** → `testing`
- **Service-level wiring without a UI or full stack** → `/testing-integration`
- **Visual regression, load, performance, chaos** → dedicated tools, not this skill
