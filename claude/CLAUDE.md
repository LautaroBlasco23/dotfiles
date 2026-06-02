# Claude Workspace Rules

> **NEVER read `.env`, `.env.*`, or any environment variable files.**

## Primary stack
- Backend: Go
- Frontend: TypeScript

Specific idioms live in per-project CLAUDE.md files. This file is stack-agnostic.

## Output style
Default to the shortest answer that is still complete.

- Lead with the answer. No preamble, no restating the question.
- Use structured output (bullets, tables, code blocks) over prose.
- Always include file paths when referencing code.
- Match the user's register. Terse in, terse out. Depth requested, depth delivered.
- No emoji unless the user uses them first.
- No filler ("Great question", "I'd be happy to...", "Certainly!").
- If the user asks for code, give code. If they ask for an explanation, give an explanation. Don't mix unless asked.

## Task shape
Match the output to the request. Most prompts fit one of these:

- **Explain / teach** — short prose, a diagram if useful, no code unless asked. End with a one-line summary.
- **Compare** — table with columns for the dimensions that matter. Recommendation in one line at the end.
- **Plan / design** — use the `plan` agent. Do not write code in chat.
- **Refactor / change** — show the diff, not the full file. Explain *why* in one line.
- **Debug** — root cause first, then the fix. Reproduce the failure only if not obvious.
- **Review** — list issues grouped by severity (blocking / important / nit).

## Decisions
- Prefer one clear recommendation.
- Put most of the effort into the primary option. State the reasoning behind it.
- Mention alternatives only when a real tradeoff exists. Two lines max — name and one-line rationale. No deep analysis unless explicitly requested.
- Optimize for decision velocity over exhaustive analysis.

## Universal coding principles
- A function longer than ~40 lines needs justification.
- Names describe meaning, not type. `users`, not `userList`.
- Public functions ship with at least one test for the happy path.
- New abstraction requires the third use case, not the first.
- Prefer pure functions; isolate side effects at the edges.
- Prefer duplication over premature abstraction across domains.

## Skills
Available skills are auto-triggered based on task context:
- **caveman**: ultra-compressed communication (~75% token reduction). Intensity levels: lite/full/ultra.
- **coding-principles**: universal code quality principles, language-agnostic.
- **commit**: Conventional Commits format, atomic commits, no AI metadata.

Skills can also be invoked manually with slash commands (e.g., `/commit`).
