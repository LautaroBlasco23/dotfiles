---
name: narrative
description: Write technical documentation as a story — Context, Problem, Investigation, Decision, Implementation, Outcome. Use when writing PR descriptions, Confluence pages, postmortems, ADRs, or explaining a change to a user. NOT for code comments or inline docs.
---

# Narrative documentation

Turn technical work into a story a reader can follow. The reader was
not there. Give them the narrative, not the changelog.

## Output format (always)

Every response is a sequence of labeled sections, in this order:

**Context:** What the reader is standing in. Only what is needed to
understand the rest.

**Problem:** What wasn't working, and why it mattered. The reader
should feel the problem.

**Investigation:** What was discovered — measurements, failed
attempts, constraints found.

**Decision:** The approach chosen and why, including alternatives
rejected.

**Implementation:** What changed technically — components,
interfaces, files, migrations, flags.

**Outcome:** What improved (measured where possible), plus
trade-offs, limitations, and follow-ups.

Rules of the format:

- Each section is its own paragraph: bold label, colon, then text.
- Drop sections with nothing to say. Never write "N/A", never pad.
- This format is the same everywhere — PR descriptions, chat
  replies, Confluence pages, postmortems.
- In standalone documents (ADR, postmortem page), promote each
  label to a `##` heading and expand freely.

## Writing rules

- **Trade-offs are not optional.** If you can't name one, say what
  you didn't measure.
- **Facts, not adjectives.** "Reduces p99 from 820ms to 140ms", not
  "massively improves performance".
- **Write for the reader who wasn't there.** Plain words, defined
  terms.
- **Past tense for what changed, present tense for what is.**
- **One idea per section.** Two points means two sections.

## Example

**Context:** The build has been slow because every CI run
reinstalls ~400 npm packages from scratch — the cache was disabled
three weeks ago while debugging a flaky test and never re-enabled.

**Problem:** Installs eat 4 of the 6 minutes of every CI run.

**Investigation:** Timed the pipeline stages; install dominates.
The flaky-test fix that motivated disabling the cache is still in
place and passing.

**Decision:** Re-enable the cache and keep the flaky-test fix.
Alternative — rebuild the CI image with deps baked in — rejected
for now; image rebuilds take longer than the time saved today.

**Implementation:** Set `cache: npm` in `.github/workflows/ci.yml`.

**Outcome:** Build drops to ~2 minutes. Trade-off: a corrupted
cache needs a manual wipe — rare, but it has happened once before.

## Anti-patterns

- **The changelog dump:** a list of commits with no mental model.
- **The mystery ending:** implementation with no hint of why.
- **The happy story:** an outcome with no trade-offs reads as
  marketing.
- **The everything-report:** all six sections padded because they
  exist.
