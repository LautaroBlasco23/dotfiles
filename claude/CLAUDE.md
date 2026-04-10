# Claude Workspace Rules

> ⚠️ **NEVER read `.env`, `.env.*`, or any environment variable files.** These contain sensitive secrets.

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
- **caveman**: ultra-compressed communication (~75% token reduction). Intensity levels: lite/full/ultra. Loaded by agents with per-agent intensity.
- **docs-writer**: shared .docs/ output convention (not auto-triggered, loaded by agents)

Language-specific `coding-*` skills auto-trigger based on file types and project context. They build on top of `coding-principles`.

Skills can also be invoked manually with slash commands (e.g., `/commit-messages`).

## Agents

Custom agents for structured development. Artifact-producing agents write to `.docs/` (gitignored per-project); implementers return results directly in their final message.

| Agent                  | Model  | Caveman | Purpose                                             | Output                         |
|------------------------|--------|---------|-----------------------------------------------------|--------------------------------|
| **researcher**         | haiku  | ultra   | Finds patterns and conventions in codebase           | `.docs/research.md`           |
| **planner**            | sonnet | full    | Designs self-contained implementation plan          | `.docs/plan.md`               |
| **implementer**        | sonnet | full    | Writes code following the plan                      | summary in final message       |
| **implementer-jr**     | haiku  | ultra   | Executes mechanical plan steps (deletes, renames, moves) | summary in final message       |
| **preflight-validator**| haiku  | ultra   | Validates project readiness for preflight checks     | `CLAUDE.md` + `.docs/preflight-validation.md` |
| **preflighter**        | haiku  | ultra   | Runs build, check, and tests as local CI gate        | `.docs/preflight.md` (on failure only) |

The planner inlines all research context into `.docs/plan.md` so the implementer only needs to read the plan — it does NOT read `.docs/research.md`.

The **preflight-validator** inspects the project environment (toolchain, tools, dependencies) and writes a `## Preflight` section to the project's `CLAUDE.md`. The **preflighter** reads this section to skip detection and run commands directly. Run the validator once per project setup; the preflighter uses the cached info on every run.

Use individually by tagging (e.g., `@planner "add auth"`).
