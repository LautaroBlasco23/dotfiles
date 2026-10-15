---
name: status-report
slug: status-report
description: >-
  Produce a concise status report of a topic: what was done, what's the plan,
  and the current state of each item. TRIGGER when the user asks for a
  "status report", "status of this conversation/PR/task", "what have we done so
  far", "where do we stand on X", or "did we complete Y". DO NOT TRIGGER for
  general questions, implementation requests, or when the user only asks to
  continue working.
---

# Status Report

Give the user context about what was done and what's the plan, with the status
of each item. The goal is clarity and orientation, not completeness.

## Rules

- Answer the user's specific question first, directly. If they ask "did we
  create the e2e I required?", the first line of the report answers yes/no
  (and where it is, if it exists).
- Be simple and short. No long technical explanations, no code excerpts, no
  internal reasoning — unless the user explicitly asks for detail or the detail
  is strictly needed to understand the status.
- Base every claim on evidence: the conversation, the repository, or the PR.
  If something is uncertain or wasn't found, say "not found" or "unclear"
  instead of guessing.
- A status report is a snapshot. Do not start implementing, fixing, or
  planning new work as a side effect. If follow-up work is needed, list it as
  a next step.

## Structure

### Answer

1–3 lines answering the user's question directly, if they asked one.

### Overall status

One line summarizing the state of the topic, e.g.
"In progress — 2 of 4 tasks done, 1 blocked".

### Done

Bullets of completed work. One line each, concrete and verifiable.
Reference what was asked vs. what was delivered when they differ.

### Plan and status

Bullets of remaining work, each tagged with a status:
`[done]`, `[in progress]`, `[pending]`, `[blocked]`, `[dropped]`.
One line each. Include what each item needs to move forward only if blocked.

### Notes

Optional, only when strictly needed: a blocker, a decision pending, a
deviation from the original request. Otherwise omit this section entirely.

## Principles

- Progressive disclosure: summary first, scannable bullets next, technical
  detail last (and only if needed).
- Prefer "done / not done / unknown" over vague qualifiers like "mostly done".
- If the original request and the current state have drifted apart, surface
  the drift — that is usually the most valuable thing in the report.
- Omit empty sections rather than writing "Nothing to report".
- Never pad the report. Short is correct.
