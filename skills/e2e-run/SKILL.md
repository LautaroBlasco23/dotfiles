---
name: e2e-run
slug: e2e-run
description: >-
  Run the e2e suite, parse failures, and classify each as flaky or a real
  regression, pointing flaky tests at the forbidden patterns that cause
  them. TRIGGER when: user asks to run the e2e suite or investigate e2e
  failures, or invokes /e2e-run.
  DO NOT TRIGGER for reviewing test quality (use e2e-review), coverage
  analysis (use e2e-coverage), or writing tests (use e2e-create).
---

# E2E Run

Run the e2e suite and triage failures into **flaky** vs. **real
regression**. Read `skills/e2e-standard/SKILL.md` first for framework
detection and severity vocabulary.

## Workflow

1. **Load the standard**: read `skills/e2e-standard/SKILL.md`; detect the
   framework.

2. **Discover the run command** from the repo: `package.json` scripts,
   Makefile, CI config, or README. If none is found or the command needs
   environment/services that aren't up, ask the user — never guess
   infrastructure.

3. **Run the suite** with a sensible timeout. Capture full output
   (reporter output, screenshots/trace paths if produced).

4. **Classify each failure**:
   - **Flaky** — passes on retry, timing/environment-dependent, or fails
     on a non-deterministic point (network race, animation, shared state).
     Identify the offending pattern from the standard §2 forbidden list
     and cite it.
   - **Real regression** — deterministic failure; the assertion is
     legitimately false. Summarize the failing assertion, the expected vs.
     actual, and the likely change that broke it (check recent commits
     touching the involved code when possible).
   - **Broken test** — deterministic failure caused by the test itself
     (stale selector after a refactor, missing fixture). Distinguish from
     a real regression; this is an `e2e-review` finding, not an app bug.

   To confirm flakiness, re-run only the failed tests (framework's
   retry/`--last-failed` mechanism) up to 2 times. A test that fails
   consistently is not flaky.

5. **Report**:

```
## e2e-run: <command>
Result: X passed, Y failed (Y1 flaky, Y2 regression, Y3 broken test) in Ts

### Flaky (fix the pattern, not the symptom)
- [warning] checkout.spec.ts:44 — fails on network race; uses
  `waitForTimeout(2000)` (standard §2). Fix: wait for the response.

### Real regressions
- [blocker] login.spec.ts:12 — expected dashboard URL, got /error.
  Likely cause: commit <sha> changed the auth redirect.

### Broken tests
- [warning] profile.spec.ts:30 — selector `#save-btn` no longer exists;
  button now has role=button name="Save". Route to e2e-review.
```

## Rules

- **Never fix failures by loosening assertions, adding sleeps, or bumping
  timeouts.** Report and recommend; change code only if asked.
- Never mark a deterministic failure as flaky to make the report look
  better — when in doubt after 2 retries, classify as regression.
- If the suite cannot run (missing services, credentials), report exactly
  what's missing and stop; do not partially improvise the environment.
- Use only the severity levels from the standard §3.
