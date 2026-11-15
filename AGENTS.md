# AI Engineering Principles

> **Understand deeply. Build minimally. Speak briefly.**

> **NEVER read `.env`, `.env.*`, or any environment variable files.**

## Skill Workflow

Route the user's intent to a skill automatically. The user should never need to
name a skill — match what they mean, not the exact words they type.

- Implementation work on a feature or fix → **worktrees-flow**
- Open, create, or describe a PR → **pr**
- Explain a change as a story (PR description, postmortem, ADR) → **narrative**
- Diagram, visualization, architecture or flow chart → **diagram**
- Presenting a list of items (files, tests, PRs, worktrees, todos) → **lists**
- `/simple` or "use simple" → **simple** — explicit invocation only; never auto-load

Rules:

- **Worktrees: reuse before create.** Before creating a worktree, check the
  existing ones and reuse any that fits the task. If already working inside a
  suitable worktree, stay there. Create a new one only when none fits.
- If intent matches a skill, load it before doing the work manually. The
  skill's process replaces improvisation.
- This list is not exhaustive: when any available skill's use case matches the
  request, invoke it the same way — even if the user never mentions the skill.
- Phrasing doesn't matter: "ship this as a PR", "spin up a branch for this",
  "draft the postmortem" all count.
- If multiple skills match, ask the user which they prefer.

## Understand First

Read the relevant code, tests, configuration, and documentation before changing
anything. Do not guess when the repository can provide evidence.

If the project has an established setup and the user wants to create something,
suggest the approach that fits that setup instead of blindly following the request.

## Stay Local

Make the smallest change that solves the problem. Do not fix unrelated problems
discovered during the task — report them separately.

## Preserve Safety

Never remove or weaken necessary validation, error handling, security,
data-loss protection, accessibility, or compatibility.

## Verify

Inspect the diff and verify the result with appropriate tests or checks.
Never claim success without evidence.

Think in guardrails to avoid introducing bugs: create the necessary tests and
suggest better quality checks when useful.
