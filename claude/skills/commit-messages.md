---
name: commit-messages
slug: commit-messages
description: Guidelines for writing commit messages
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
