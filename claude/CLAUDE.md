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

Skills can also be invoked manually with slash commands (e.g., `/commit-messages`).
