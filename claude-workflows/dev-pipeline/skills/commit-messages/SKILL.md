---
name: commit-messages
slug: commit-messages
description: >-
  Guidelines for writing commit messages.
  TRIGGER when: user asks to commit, create a commit, write a commit message, or uses /commit.
  DO NOT TRIGGER for general coding tasks.
---

# Commit Message Rules

Use Conventional Commits.

Types:

feat: new feature
fix: bug fix
refactor: code improvement
docs: documentation changes
chore: maintenance

Example:

feat(auth): add JWT login

## Rules

- keep commit messages concise
- describe the change clearly
- scope commits when relevant (feat(auth), fix(api), etc.)
- avoid unnecessary metadata

## AI-specific rule

Do NOT include AI-related metadata in commit messages.

Avoid things like:

- "generated with Claude"
- "done with Claude"
- "AI-assisted commit"
- "co-authored-by Claude"
- any reference to AI tools

## Atomic Commits

Do NOT create a single large commit for multiple unrelated changes.

Before committing:
1. Run `git diff` and `git status` to review all changes.
2. Identify distinct logical units (feature, fix, refactor, docs, chore).
3. Stage and commit each unit separately.

Rules:
- One commit = one logical change
- Use `git add -p` or selective file staging to isolate hunks when needed
- If two changes are tightly coupled, use the dominant type and mention the secondary concern in the commit body
- State the split you made (e.g., "splitting into 2 commits: feat + fix") before committing
