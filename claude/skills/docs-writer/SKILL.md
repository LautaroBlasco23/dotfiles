---
name: docs-writer
slug: docs-writer
description: >-
  Shared convention for writing artifacts to .docs/ directory.
  NOT auto-triggered. Loaded via agent skills field only.
---

# Docs Writer Convention

All pipeline agents write their output to a `.docs/` directory in the project root.

## Directory

- Location: `<project-root>/.docs/`
- Create it if it doesn't exist

## Gitignore check

Before writing, verify `.docs/` is listed in the project's `.gitignore`.
If it is NOT, warn the user and ask them to add it before proceeding.

## File format

Every `.docs/` file uses markdown with YAML frontmatter:

```markdown
---
date: YYYY-MM-DD
agent: <agent-name>
task: <one-line description of the user's request>
---

<content>
```

## Overwrite semantics

Each run overwrites the previous file. No versioning -- keep it simple.
The project's git history preserves code changes independently.

## Output files

| Agent               | File                              | Notes                        |
|---------------------|-----------------------------------|------------------------------|
| planner             | `.docs/plan.md`                   |                              |
| researcher          | `.docs/research.md`               |                              |
| implementer         | `.docs/implementation-log.md`     |                              |
| preflight-validator | `.docs/preflight-validation.md`   | Also writes `## Preflight` section to project's `CLAUDE.md` |
| preflighter         | `.docs/preflight.md`              | Only written on failure      |
