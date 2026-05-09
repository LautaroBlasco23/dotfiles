---
name: commit
slug: commit
description: >-
  Guidelines for writing commits. Conventional Commits format, atomic commits, no AI metadata.
  TRIGGER when: user asks to commit, create a commit, write a commit message, or uses /commit.
  DO NOT TRIGGER for general coding tasks.
---

## Format

Conventional Commits: `<type>(<scope>): <description>`

Types: `feat` | `fix` | `refactor` | `docs` | `chore`

Examples:
- `feat(auth): add JWT login`
- `fix(api): handle null response from payment provider`

## Rules

- Concise description — what changed, not how
- Scope when relevant: `feat(auth)`, `fix(api)`
- No AI metadata: no "generated with Claude", "co-authored-by Claude", or any AI reference

## Atomic commits

One commit = one logical change.

Process:
1. Run `git diff` and `git status`
2. Identify distinct logical units (feature, fix, refactor, docs, chore)
3. Stage and commit each separately — use `git add -p` to isolate hunks if needed
4. If two changes are tightly coupled: use dominant type, mention secondary in commit body
