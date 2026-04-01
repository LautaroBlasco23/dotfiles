# Claude Workspace Rules

General development preferences.

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

## Development practices

- prioritize simple solutions
- suggest tests when relevant
- avoid unnecessary abstractions

## Skills

Available skills are auto-triggered based on task context:

- **commit-messages**: use when committing code (enforces Conventional Commits, forbids AI metadata)
- **debugging**: use when investigating bugs or errors
- **architecture**: use when designing systems or choosing patterns
- **coding-agent**: use when implementing features from scratch
- **skill-selection**: use when task scope is unclear or multi-domain
- **dev-pipeline**: orchestrates researcher -> planner -> implementer(s) -> preflighter pipeline
- **docs-writer**: shared .docs/ output convention (not auto-triggered, loaded by agents)

Skills can also be invoked manually with slash commands (e.g., `/commit-messages`).

## Agents

Custom agents for structured development. Each writes artifacts to `.docs/` (gitignored per-project).

| Agent         | Model  | Purpose                                      | Output                         |
|---------------|--------|----------------------------------------------|--------------------------------|
| **researcher**  | haiku  | Finds patterns and conventions in codebase      | `.docs/research.md`           |
| **planner**     | opus   | Designs implementation plan with execution strategy | `.docs/plan.md`           |
| **implementer** | sonnet | Writes code following plan + research           | `.docs/implementation-log.md` |
| **preflighter** | haiku  | Runs build, check, and tests as local CI gate   | `.docs/preflight.md`          |

Use individually (`@planner "add auth"`) or as a full pipeline (`/dev-pipeline`).
