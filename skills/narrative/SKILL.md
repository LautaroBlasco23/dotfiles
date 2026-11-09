---
name: narrative
description: Write technical documentation as a story — Context, Problem, Investigation, Decision, Implementation, Outcome. Use when writing PR descriptions, Confluence pages, postmortems, ADRs, or explaining a change to a user. NOT for code comments or inline docs.
---

# Narrative documentation

Turn technical work into documentation a reader can follow: what was
happening, what broke, what you found, what you chose, what changed,
and what it means. The reader was not there. Give them the story, not
the changelog.

## The narrative arc

Six questions, asked in order. A "section" is a heading only when the
medium calls for headings; otherwise it is a paragraph, a sentence, or
dropped entirely.

1. **Context** — What is the reader standing in? What was the system or
   team doing before this change? Include only what is needed to
   understand the rest.
2. **Problem** — What wasn't working, and why it mattered: load,
   latency, cost, risk, confusion. The reader should feel the problem.
3. **Investigation** — What you discovered: measurements, failed
   attempts, constraints found. Skip if nothing was investigated.
4. **Decision** — The approach chosen and why, including alternatives
   rejected. Skip if there was no real choice.
5. **Implementation** — What changed technically: components,
   interfaces, files, migrations, flags.
6. **Outcome** — What improved (measured, where possible), plus
   trade-offs, limitations, and follow-ups.

## Rules

- **Drop empty sections.** Never write "N/A" or pad a section that has
  nothing to say.
- **Trade-offs are not optional.** Every change makes something worse
  or leaves something unmeasured. If you can't name a trade-off, you
  haven't looked hard enough — say what you didn't measure.
- **Facts, not adjectives.** "Reduces p99 from 820ms to 140ms", not
  "massively improves performance". Numbers, names, paths.
- **Write for the reader who wasn't there.** They lack your context,
  not your vocabulary. Plain words, defined terms, linked references.
- **Past tense for what changed, present tense for what is.**
- **One idea per section.** If a section has two points, it is two
  sections.

## Profiles per medium

### PR description (condensed)

Context → Problem → Solution → Impact → Trade-offs

Solution merges Decision and Implementation. Keep the whole thing
under ~15 lines; reviewers skim. Don't repeat implementation details
the diff already shows.

### Confluence page / postmortem / ADR (full)

All six sections as headings. Expand freely: diagrams, links, tables.
This is the durable record — future readers arrive via search with
zero context, so the Context section carries more weight here.

### Talking with a user (conversational)

No headings, no visible scaffolding. Three moves in prose:

1. What's going on (Context + Problem)
2. What I found (Investigation)
3. What I'd do and what it costs them (Decision + Outcome)

Match the user's level. Stop after the recommendation unless they ask
for depth.

## Examples

### Example: PR description (caching)

Before:

> Added Redis caching to the customer service to improve performance.

After:

> **Context:** The customer service re-queries the database for
> customer info even when the data hasn't changed.
>
> **Problem:** This creates unnecessary DB load and raises response
> latency during peak traffic.
>
> **Solution:** Redis cache with a 15-minute TTL. Invalidation fires
> on customer-info updates. Alternatives considered: in-process cache
> (rejected — multiple service replicas) and query-level caching
> (rejected — the table is joined with volatile data).
>
> **Impact:** Eliminates repeated queries for hot customers; cached
> lookups drop from ~40ms to ~2ms.
>
> **Trade-offs:** Data can be stale up to 15 minutes if an update
> bypasses the invalidation path (e.g. manual DB edits). Cache hit
> rate is not yet instrumented.

### Example: Bug fix PR (short form)

> **Context:** Checkout intermittently fails with a 500 for users
> with saved addresses.
> **Problem:** A null `address.line2` crashes the formatter; ~0.3% of
> orders, concentrated in mobile web.
> **Solution:** Treat `line2` as optional end-to-end; added a
> regression test with a null `line2` fixture.
> **Impact:** 500s on checkout eliminated for this case.
> **Trade-offs:** Root cause is the mobile app sending `null` instead
> of omitting the field — proper fix belongs there (ticketed).

### Example: Talking with a user

> The build has been slow because every CI run reinstalls ~400 npm
> packages from scratch — the cache was disabled three weeks ago while
> debugging a flaky test and never re-enabled. I measured it: installs
> are eating 4 of the 6 minutes. I'd re-enable the cache and keep the
> flaky-test fix, which shaves the build to about 2 minutes. The
> trade-off is that a corrupted cache would need a manual wipe — rare,
> but it has happened once before.

### Example: Postmortem (full arc, excerpt)

> **Context:** Payments service handles ~2k req/s at peak, backed by a
> primary DB and one read replica...
>
> **Problem:** On Nov 3, 14:02–14:37 UTC, 11% of payment attempts
> failed with connection timeouts.
>
> **Investigation:** The replica hit max_connections during a
> reporting batch. Alerting fired 9 minutes late because the
> threshold was set above the batch baseline.
>
> **Decision:** Move the batch to a dedicated connection pool and
> lower the alert threshold to the service baseline.
>
> **Implementation:** New pool config in `db.yml`; alert threshold
> changed in the monitoring dashboard.
>
> **Outcome:** Failures eliminated for equivalent load. Remaining
> risk: the single replica is still a SPOF — remediation ticketed.

## Anti-patterns

- **The changelog dump:** a list of commits no one can turn into a
  mental model.
- **The mystery ending:** implementation details with no hint of why.
- **The happy story:** an outcome with no trade-offs reads as
  marketing.
- **The everything-report:** all six sections padded because they
  exist.
