---
name: e2e-standard
slug: e2e-standard
description: >-
  Shared quality rubric for end-to-end tests: quality dimensions, forbidden
  flaky patterns, severity vocabulary, and framework detection. This is the
  single source of truth referenced by e2e-create, e2e-review, e2e-coverage
  and e2e-run.
  TRIGGER when: another e2e-* skill instructs to load this standard, or the
  user explicitly asks for the e2e quality criteria.
  DO NOT TRIGGER for general coding tasks or non-e2e testing (unit,
  integration, contract).
---

# E2E Quality Standard

This file is the contract between the producer of e2e tests (`e2e-create`)
and their auditors (`e2e-review`, `e2e-coverage`, `e2e-run`). All four
skills score, flag, and report using the definitions below. Do not restate
or copy this rubric into other skills — reference it.

## 0. Framework detection (always first)

Before applying any guidance, detect the framework from the repo:

1. Look for config files: `playwright.config.*`, `cypress.config.*`,
   `cypress.json`, `nightwatch.conf.*`, `wdio.conf.*`, `testcafe.*`,
   `codecept.conf.*`, or `package.json` devDependencies.
2. Map the generic terms in this standard to the framework's idioms:

| Generic term | Playwright | Cypress |
|---|---|---|
| Auto-wait assertion | `expect(locator).toBeVisible()` etc. | `.should('be.visible')` etc. |
| Robust selector | `getByRole`, `getByText`, `getByTestId` | `cy.findByRole` (cypress-testing-library), `data-cy` |
| Arbitrary sleep | `page.waitForTimeout(n)` | `cy.wait(n)` (fixed ms) |
| Network wait | `page.waitForResponse` / route-based | `cy.intercept` + `cy.wait('@alias')` |
| Test isolation | fresh `page`/context per test | `cy.session`, per-test cleanup |

If no framework is found, ask the user. Never guess selectors or APIs.

## 1. Quality dimensions (the rubric)

Every e2e test is scored on six dimensions. Each is either **pass**,
**warning**, or **fail**.

### 1.1 Intent
The test does exactly what its name/description claims — no more, no less.
One user journey per test. A test named "user can checkout" must not also
silently verify registration.

### 1.2 Correctness (selectors & components)
Interacts with the correct components, using robust locators:
- **Prefer**: role, accessible name, text, test-id (`data-testid`, `data-cy`).
- **Avoid**: brittle CSS chains (`.btn.btn-primary > span:nth-child(2)`),
  XPath, positional selectors, generated class names.
- Selectors must be verified against the actual app code, not invented.

### 1.3 Waiting
No arbitrary sleeps. Waits must be:
- **Conditional** — tied to an observable state (element visible, network
  response received, URL changed), never a fixed duration.
- **Bounded** — explicit, reasonable timeout; not the framework default
  blindly inflated "to make it pass".
- **Minimal** — if a test takes noticeably longer than the journey it
  simulates, flag it.

### 1.4 Isolation
Tests are independent and order-agnostic: each sets up the state it needs
and cleans up after itself. No reliance on a previous test's side effects,
no shared mutable fixtures, no hardcoded "run after test X".

### 1.5 Assertions
Assert user-visible outcomes, not implementation details:
- **Good**: URL/route changed, confirmation message shown, row appears in
  a table, balance updated.
- **Bad**: asserting internal state, store contents, DOM structure, or
  network payload shape the user never sees.
Every test has at least one assertion that would fail if the feature broke.

### 1.6 Data
Realistic, deterministic fixtures. No magic values (`test123`,
`asdf@asdf.com` when the value is irrelevant — prefer clearly-fake but
realistic data), no dependence on pre-existing production-like records
unless the suite guarantees them.

## 2. Forbidden patterns (anti-flakiness)

Any occurrence is at least a **warning**; combinations are **fail**:

- Arbitrary sleeps: `waitForTimeout`, `cy.wait(<fixed ms>)`, `sleep()`,
  `Thread.sleep`, `time.sleep`.
- `networkidle`-based waiting as the primary sync mechanism.
- Order-dependent tests or shared mutable state between tests.
- Asserting on implementation internals (see 1.5).
- Conditional logic inside tests (`if (element exists) ... else ...`) that
  masks nondeterminism instead of fixing it.
- Retries used to hide a deterministic failure.
- Timeouts inflated until the test passes.

## 3. Severity vocabulary

All e2e-* skills report with exactly these levels:

| Level | Meaning |
|---|---|
| `blocker` | The test is wrong: it can pass while the feature is broken, tests the wrong thing, or is so flaky its result is meaningless. Must be fixed before merge. |
| `warning` | Works today but fragile or misleading: brittle selectors, arbitrary waits, weak assertions, isolation risks. |
| `nit` | Style, naming, minor readability or structure improvements. |

Reports order findings `blocker → warning → nit` and give a concrete fix
for each finding, not just the complaint.

## 4. Scoring summary

A test's overall verdict is the worst finding present:
- any `blocker` → **FAIL**
- no blocker, any `warning` → **PASS WITH WARNINGS**
- only `nit`s or clean → **PASS**
