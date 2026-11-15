---
name: pr
description: >-
  Write or update a PR description with a fixed format (Simplified + expandable
  Detailed, Implementation details, Tests Evidence, Checklist sections).
  TRIGGER when the user says "create a pr", "make a pr", "open a pr",
  "write the pr description", "update this pr description", or asks to change
  the PR body. DO NOT TRIGGER for general coding tasks, commits, or branch work.
---

# PR description format

Every PR description uses this fixed structure. Only **Simplified** is always
visible; every other section is wrapped in a collapsible `<details>` block.

Gather the material first (diff, test runs, related issues), then write the
description in this order:

```markdown
## Simplified
<plain-language summary of what the PR introduces>

<details>
<summary>Detailed</summary>

<narrative story of the change>

</details>

<details>
<summary>Implementation details</summary>

<technical facts for AI agents>

</details>

<details>
<summary>Tests Evidence</summary>

<what was verified and how>

</details>

<details>
<summary>Checklist</summary>

<self-review items — only for non-trivial PRs>

</details>
```

Rules:

- `## Simplified` stays at the top, always expanded.
- Every other section is a `<details>` block. Keep blank lines before and
  after the inner content — GitHub only renders markdown inside `<details>`
  when it is separated from the tags.
- Drop the Checklist block entirely for trivial PRs. Never include a checklist
  nobody needs to confirm.
- Do not add extra sections, reorder, or rename headings.

## Section: Simplified

Follow the `simple` skill: plain words, lead with the result, no filler.

- 1–4 sentences describing what the PR introduces and why it matters.
- Written for anyone scanning the PR list: no jargon the reader can't infer,
  no section walkthrough, no "this PR contains:" lists.
- If the PR fixes an issue, link or reference it here.

## Section: Detailed

Follow the `narrative` skill: tell the story a reader who wasn't there can
follow. Use its labeled sections as sub-headings, in order:

- **Context** — what the reader is standing in.
- **Problem** — what wasn't working and why it mattered.
- **Investigation** — what was discovered, what failed, constraints found.
- **Decision** — the approach chosen and why, alternatives rejected.
- **Implementation** — what changed at a story level.
- **Outcome** — what improved, trade-offs, follow-ups.

Rules inherited from `narrative`: drop sections with nothing to say (never
write "N/A" or pad), facts over adjectives ("reduces p99 from 820ms to 140ms"),
past tense for what changed, present tense for what is, one idea per section.

## Section: Implementation details

Technical facts oriented to AI agents and reviewers who will touch the code.

- Files and components touched (paths, modules, interfaces).
- Key changes per file: functions added/removed/renamed, signatures changed,
  migrations, config or flags introduced.
- Commands relevant to the change (build, run, rollback).
- Bullets, not prose. No justification here — that belongs in Detailed.

## Section: Tests Evidence

- Exact commands run (with flags) and a short output snippet or pass/fail
  summary for each.
- Manual verification steps if no automated tests cover the change.
- If nothing was tested, say so explicitly in one line — never fabricate
  evidence and never leave the section empty.

## Section: Checklist

Only for non-trivial PRs. Written for the human author to confirm, phrased as
statements to tick:

- [ ] I have self-reviewed the full diff.
- [ ] Tests pass locally / CI is green.
- [ ] No secrets, credentials, or debug leftovers in the diff.
- [ ] Related TODOs and follow-ups are tracked (issue/TODO noted).

Adjust items to the PR; omit ones that don't apply instead of leaving them
unchecked. Skip the whole section for trivial changes.
