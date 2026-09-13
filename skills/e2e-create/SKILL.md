---
name: e2e-create
slug: e2e-create
description: >-
  Design and create a solid end-to-end test for a given scenario: clarify
  the journey, check it isn't already covered, present a design, then write
  the test to the e2e-standard rubric and self-review it.
  TRIGGER when: user asks to write/create an e2e test for a scenario, or
  invokes /e2e-create <scenario>.
  DO NOT TRIGGER for auditing existing tests (use e2e-review), coverage gap
  analysis (use e2e-coverage), or running suites (use e2e-run).
---

# E2E Create

Design and write a new e2e test that would pass an `e2e-review` audit.
Read `skills/e2e-standard/SKILL.md` first — the rubric there is the
acceptance bar for everything this skill produces.

## Workflow

1. **Load the standard**: read `skills/e2e-standard/SKILL.md`; detect the
   framework and test directory from the repo config.

2. **Clarify the scenario**: what user journey, starting state, and success
   criterion? If the request is vague ("test the checkout"), ask what
   specific path and outcome matter before designing anything.

3. **Dedupe check**: apply the `e2e-coverage` workflow (steps 3–5 of that
   skill) to the feature. If an existing test already covers the path,
   stop and report it — do not create a duplicate. If the existing test is
   low quality, say so and ask whether to fix it (`e2e-review` findings)
   or write a new one.

4. **Learn the conventions**: read 2–3 existing tests in the target
   directory plus any page objects/fixtures/helpers they use. Match the
   project's structure, naming, and helper usage — do not import a foreign
   style.

5. **Present the design before writing** (planner phase):
   - test name (states the journey and outcome)
   - steps (user actions in order)
   - assertions (user-visible outcomes per standard §1.5)
   - fixtures/data needed and how state is set up and cleaned up
   Get user confirmation when the scenario was ambiguous or the design
   makes a notable tradeoff (e.g., API-based setup vs. UI-driven).

6. **Write the test**:
   - one journey per test (standard §1.1)
   - selectors verified against actual app code, never invented (§1.2)
   - conditional, bounded waits only (§1.3)
   - independent setup/teardown (§1.4)
   - outcome assertions that would fail if the feature broke (§1.5)
   - realistic deterministic data (§1.6)
   - zero forbidden patterns (§2)

7. **Self-review**: apply the `e2e-review` workflow to the produced test —
   read the code under test, score all six dimensions, scan for forbidden
   patterns. Fix every `blocker` and `warning` before presenting. Include
   the self-review verdict in the final report.

8. **Run if possible**: if the repo has a fast way to run just this test,
   run it once and report the result. If it fails, debug the test (not the
   app) unless evidence shows a real bug — then report the bug, don't hide
   it.

## Rules

- Never invent selectors, routes, or API shapes — read the app code.
- Never make a failing run pass by loosening assertions or adding sleeps.
- If the scenario turns out to be already covered or better suited to a
  unit/integration test, say so and stop instead of writing an e2e anyway.
- Final report: design summary, files created/modified, self-review
  verdict, run result (or why it wasn't run).
