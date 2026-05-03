---
name: docs-writer
slug: docs-writer
description: >-
  Convention for writing pipeline artifacts to .docs/ directory.
  TRIGGER when: writing researcher, planner, preflighter, or preflight-validator output.
---

## Convention

All pipeline skill outputs write to `.docs/` in the project root.

## Setup check

Before writing, verify `.docs/` is listed in the project's `.gitignore`.
If not: warn the user and ask them to add it.

## File format

Every `.docs/` file uses markdown with YAML frontmatter:

```markdown
---
date: YYYY-MM-DD
agent: <skill-name>
task: <one-line description>
---

<content>
```

## Overwrite semantics

Each run overwrites the previous file. No versioning — git history preserves code changes.

## Output files

| Skill               | File                            | Notes                                        |
|---------------------|---------------------------------|----------------------------------------------|
| researcher          | `.docs/research.md`             |                                              |
| planner             | `.docs/plan.md`                 |                                              |
| preflight-validator | `.docs/preflight-validation.md` | Also writes `## Preflight` to `CLAUDE.md`    |
| preflighter         | `.docs/preflight.md`            | Only written on failure                      |
