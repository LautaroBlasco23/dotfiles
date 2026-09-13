---
name: e2e-review
slug: e2e-review
description: >-
  Audit an existing end-to-end test: does it test what it claims, does it use
  the right components/selectors, are waits conditional and minimal, and what
  else should be considered. Report-only; scores against the e2e-standard
  rubric.
  TRIGGER when: user asks to review/audit an e2e test file, or invokes
  /e2e-review <file>.
  DO NOT TRIGGER for writing new e2e tests (use e2e-create), coverage gap
  analysis (use e2e-coverage), or running suites (use e2e-run).
---

# E2E Review

Audit an existing e2e test against the shared rubric. Read
`skills/e2e-standard/SKILL.md` first and apply its framework detection,
quality dimensions, forbidden patterns, and severity vocabulary exactly —
do not restate or redefine them here.

## Workflow

1. **Load the standard**: read `skills/e2e-standard/SKILL.md`. Detect the
   framework per its section 0.

2. **Read the target test(s)** given as the invocation argument. If no
   argument, ask which file, or use the file the user referenced.

3. **Read the code under test**: for every selector, page object, fixture,
   and helper the test touches, open the corresponding app code. A selector
   that "looks right" but doesn't match the real component is a `blocker`.
   Never judge selectors from the test file alone.

4. **Score each dimension** (standard §1): intent, correctness, waiting,
   isolation, assertions, data. Verdict per dimension: pass / warning /
   fail, with the specific line(s) that justify it.

5. **Scan for forbidden patterns** (standard §2): arbitrary sleeps,
   order dependence, internal-state assertions, inflated timeouts, etc.

6. **Suggest additional considerations** when applicable — only if relevant
   to the journey under test, not boilerplate:
   - untested error/negative path of the same journey (refer the gap to
     `e2e-coverage` rather than expanding this review)
   - missing cleanup that could pollute other tests
   - accessibility-relevant assertions (role/label visible) if the journey
     touches interactive controls
   - visual/layout regressions the functional assertions would miss

## Report format

```
## e2e-review: <file>
Verdict: PASS | PASS WITH WARNINGS | FAIL   (standard §4)

| Dimension   | Verdict | Evidence (file:line) |
|---|---|---|
| Intent      | pass    | — |
| Correctness | warning | line 14: CSS chain `.modal > div:nth(2)` |
| ...         |         | |

### Findings (blocker → warning → nit)
- [blocker] line 22: asserts store state, not user-visible outcome.
  Fix: assert the confirmation banner text instead.
- [warning] line 9: `waitForTimeout(3000)`. Fix: wait for the row selector.

### Additional considerations
- ...
```

## Rules

- **Report-only by default.** Never modify the test unless explicitly
  asked; then make only the changes the findings justify.
- Every finding cites `file:line` and includes a concrete fix.
- Use only the severity levels defined in the standard §3.
- If the test's intent is ambiguous (name says X, body does Y), flag it as
  a `blocker` under Intent and ask the user which was meant — do not guess.
- Reviewing multiple files: one report block per file, then a one-line
  summary (X pass, Y with warnings, Z fail).
