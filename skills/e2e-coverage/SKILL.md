---
name: e2e-coverage
slug: e2e-coverage
description: >-
  Analyze which user paths of a feature are covered by e2e tests and flag
  gaps worth testing, ranked by user impact. Produces a coverage matrix.
  TRIGGER when: user asks what e2e coverage exists or is missing for a
  feature, or invokes /e2e-coverage <feature-or-dir>.
  DO NOT TRIGGER for reviewing a single test's quality (use e2e-review),
  writing new tests (use e2e-create), or running suites (use e2e-run).
---

# E2E Coverage

Determine which critical paths of a feature are covered by e2e tests and
which are gaps. Read `skills/e2e-standard/SKILL.md` first for framework
detection and severity vocabulary.

## Workflow

1. **Load the standard**: read `skills/e2e-standard/SKILL.md`; detect the
   framework and locate the e2e test directory from its config.

2. **Identify the target feature** from the invocation argument (a feature
   name, route, component, or directory). If ambiguous, ask.

3. **Map existing e2e coverage**: find the e2e tests exercising the feature
   (grep selectors, routes, page objects, test names). For each test,
   record which path it covers and its quality verdict — a test that would
   fail to catch a break does not count as coverage. If a test looks
   suspect, flag it for `e2e-review` instead of deep-diving here.

4. **Derive the critical paths** by reading the feature's actual code
   (routes, handlers, components, state transitions) — not from
   imagination:
   - happy path (primary user journey)
   - main error paths (validation failures, server errors, empty states)
   - boundary states (limits, first/last item, pagination edges)
   - auth/permission variants (anonymous, regular user, admin — whichever
     the code actually distinguishes)

5. **Build the coverage matrix**: one row per path → covering test(s) or
   **GAP**.

6. **Check lower-level tests before flagging a gap**: search for unit or
   integration tests covering the missing path. Distinguish:
   - **e2e gap, tested below** — lower risk; note it, recommend e2e only if
     the path crosses service/component boundaries.
   - **untested anywhere** — higher risk; rank top.

7. **Rank gaps by user impact** (how many users hit it × severity of
   breaking) and report.

## Report format

```
## e2e-coverage: <feature>
Existing e2e tests: N (M healthy, K flagged for review)

| Path                        | Covered by        | Verdict |
|---|---|---|
| Happy path: checkout        | checkout.spec.ts  | ok      |
| Error: card declined        | —                 | GAP     |
| Boundary: empty cart        | cart.spec.ts:88   | ok      |

### Gaps (ranked by user impact)
1. [warning] Card-declined path — no e2e; has unit tests only. Crosses
   payment-service boundary → recommend e2e.
2. [blocker] Admin-only refund flow — untested anywhere.

### Flagged for e2e-review
- checkout.spec.ts:14 — arbitrary wait, may be masking a real gap.
```

## Rules

- Use only the severity levels from the standard §3. For gaps:
  `blocker` = untested anywhere on a high-impact path; `warning` = e2e gap
  with lower-level coverage, or low-impact untested path; `nit` = cosmetic
  or redundant-path suggestion.
- Never recommend an e2e test for something a unit/integration test covers
  adequately — e2e is for journeys across boundaries, not exhaustive
  branches.
- Derive paths from real code. If the feature's code can't be located, say
  so and ask instead of inventing paths.
- Do not write tests. Hand the ranked gap list to the user or suggest
  `e2e-create` for the top item.
