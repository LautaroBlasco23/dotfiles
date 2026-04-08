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

- **agent-injection**: MANDATORY rules for spawning agents — context injection, specificity, task partitioning, token budget. Fires on every agent invocation.
- **coding-principles**: universal code quality principles — applied to any implementation
- **coding-golang**: idiomatic Go standards (Fiber, sqlx/pgx, slog, table-driven tests)
- **coding-typescript**: TypeScript standards (strict mode, Vite, Vitest)
- **coding-react**: React standards (functional components, hooks, Vite + React)
- **commit-messages**: Conventional Commits format, atomic commits, no AI metadata
- **architecture**: system design, project structure, layer boundaries
- **docs-writer**: shared .docs/ output convention (not auto-triggered, loaded by agents)

Language-specific `coding-*` skills auto-trigger based on file types and project context. They build on top of `coding-principles`.

Skills can also be invoked manually with slash commands (e.g., `/commit-messages`).

## Agents

Custom agents for structured development. Each writes artifacts to `.docs/` (gitignored per-project).

| Agent                  | Model  | Purpose                                             | Output                         |
|------------------------|--------|-----------------------------------------------------|--------------------------------|
| **researcher**         | haiku  | Finds patterns and conventions in codebase           | `.docs/research.md`           |
| **planner**            | sonnet | Designs implementation plan with execution strategy  | `.docs/plan.md`               |
| **implementer**        | sonnet | Writes code following plan + research                | `.docs/implementation-log.md` |
| **implementer-jr**     | haiku  | Executes mechanical plan steps (deletes, renames, moves) | `.docs/implementation-log.md` |
| **preflight-validator**| haiku  | Validates project readiness for preflight checks     | `CLAUDE.md` + `.docs/preflight-validation.md` |
| **preflighter**        | haiku  | Runs build, check, and tests as local CI gate        | `.docs/preflight.md` (on failure only) |

The **preflight-validator** inspects the project environment (toolchain, tools, dependencies) and writes a `## Preflight` section to the project's `CLAUDE.md`. The **preflighter** reads this section to skip detection and run commands directly. Run the validator once per project setup; the preflighter uses the cached info on every run.

Use individually by tagging (e.g., `@planner "add auth"`).
