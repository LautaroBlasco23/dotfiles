report-output

Draft specification for a lightweight end-of-turn report used by AI coding agents.

Goal

Make each prompting session easier to read later.

The report should answer, in a few lines:

What did the user want?

What did we actually do?

What should the user know next?

The report is a summary, not a second full answer.

Desired output

## Report

### Main Idea
<1–2 sentences describing the user's goal and the approach taken.>

### What We Did
- <important action or result>
- <important action or result>
- <validation/result, when relevant>

### Next
<one short next step, or "None" if complete.>

Rules

Keep the report concise.

Focus on information useful when reviewing the session later.

Do not repeat the full answer.

Do not list every tool call.

Mention important decisions, changes, failures, or alternatives only when they help explain the session.

Never claim an action was completed unless supported by the conversation, tool results, or repository state.

If nothing meaningful was changed, say so rather than inventing progress.

Next is optional in substance, but the heading should remain present.

The report should be generated at the end of each completed agent turn.

Implementation direction

Claude Code

Use a Stop hook as the enforcement/finalization mechanism.

Possible flow:

Agent finishes
    ↓
Stop hook
    ↓
Check whether report exists and is useful
    ↓
If missing/invalid → prevent stop and ask the agent to produce it
    ↓
Otherwise → allow completion

A later version could use a prompt-based Stop hook to evaluate the final response rather than relying only on string/heading checks.

OpenCode

Use a global plugin named report-output.

Possible flow:

Session becomes idle / turn completes
    ↓
report-output plugin
    ↓
generate or validate the report
    ↓
make the report part of the final user-visible response

OpenCode exposes session.idle and other session events to plugins. The current V2 plugin API also exposes session hooks, but it is currently beta, so the implementation should avoid depending on unstable APIs until the desired behavior is proven.

Design principle

Prefer the smallest implementation that reliably improves readability.

Start with:

Fixed report format.

Concise instructions.

End-of-turn enforcement.

No automatic Git/test/session metadata unless it proves useful.

Add richer execution tracking only if the simple report is insufficient.

Future ideas

Optional Git summary.

Optional tests/validation section.

Preserve a compact project state during context compaction.

Detect when the report would be redundant for trivial interactions.

Make the report style configurable.

Share the same specification between Claude Code and OpenCode.

Non-goals

Do not turn every response into a long status report.

Do not expose internal chain-of-thought/reasoning.

Do not record every tool call.

Do not make the report more important than the user's actual answer.
