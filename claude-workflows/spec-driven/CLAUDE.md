# Claude Workspace Rules — Spec-Driven

Spec-driven workflow: write a formal spec first, then plan, implement, guard, and review.

## Languages

Prefer:

- Go
- TypeScript (frontend)

If suggesting another language, explain why it is a better fit.

## Architecture

Prefer backend-first architectures.

Recommended structure:

- layered architecture
- DDD-inspired design

Typical layers:

core/
application/
infrastructure/
api/

See `context/architecture.md` for import rules and file placement.

## Development practices

- write specs before implementation
- prioritize simple solutions
- suggest tests when relevant
- avoid unnecessary abstractions

## Workflow

The spec-driven pipeline runs in this order:

```
spec → plan → implement → architecture-guardian → review
```

Run the full pipeline with `/spec-pipeline <requirement>`, or each step individually.

## Skills

| Skill                    | When to use                                          |
|--------------------------|------------------------------------------------------|
| `/spec-writer`           | Convert a requirement into a formal spec             |
| `/create-plan`           | Generate ordered task list from the spec             |
| `/implement-feature`     | Write code following plan + spec                     |
| `/architecture-guardian` | Scan implementation for architecture violations      |
| `/review-code`           | Validate implementation against spec requirements    |
| `/spec-pipeline`         | Run the full workflow end-to-end                     |
| `/commit-messages`       | Commit with Conventional Commits                     |
| `/debugging`             | Investigate bugs and errors                          |

## Agents

| Agent                    | Model  | Purpose                                       | Output                          |
|--------------------------|--------|-----------------------------------------------|---------------------------------|
| **spec-writer**          | opus   | Writes formal spec from requirement           | `.docs/spec.md`                 |
| **planner**              | opus   | Produces ordered task list from spec          | `.docs/plan.md`                 |
| **implementer**          | sonnet | Writes code following plan + spec             | `.docs/implementation-log.md`   |
| **architecture-guardian**| sonnet | Scans code for architecture violations        | `.docs/guardian-report.md`      |
| **validator**            | sonnet | Validates implementation matches spec         | `.docs/validation.md`           |

## Gates

- Do not proceed past `architecture-guardian` if it reports VIOLATIONS FOUND
- Do not proceed past `validator` if it reports VIOLATIONS FOUND
- Both must return APPROVED before a feature is considered complete

## Project Setup

Copy template files into your project's `context/` directory:

```
cp templates/architecture.md context/architecture.md
cp templates/coding-standards.md context/coding-standards.md
```

Edit them to match your project's actual rules.
