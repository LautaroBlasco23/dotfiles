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
- **coding-principles**: universal code quality principles, language-agnostic. Also loaded by `implementer`.
- **commit**: Conventional Commits format, atomic commits, no AI metadata
- **architecture**: system design, project structure, layer boundaries
- **caveman**: ultra-compressed communication (~75% token reduction). Intensity levels: lite/full/ultra.
- **docs-writer**: `.docs/` output convention for pipeline skills
- **test-analysis**: audits test coverage for a module — gaps, partial coverage, quality issues
- **test-creation**: creates/improves tests; args: `<test-types> for <module>` (e.g., `unit tests for auth module`)

Skills can also be invoked manually with slash commands (e.g., `/commit`, `/test-creation unit tests for payments/`).

### Pipeline skills

Invoke by tagging (e.g., `@researcher "find auth patterns"`):

| Skill                  | Purpose                                                   | Output                                                      |
|------------------------|-----------------------------------------------------------|-------------------------------------------------------------|
| **researcher**         | Finds patterns and conventions in codebase                | `.docs/research.md`                                         |
| **planner**            | Designs self-contained implementation plan                | `.docs/plan.md`                                             |
| **implementer**        | Writes code following `.docs/plan.md`                     | summary in response                                         |
| **implementer-jr**     | Executes mechanical steps (deletes, renames, moves)       | summary in response                                         |
| **preflight-validator**| Validates project toolchain readiness                     | `CLAUDE.md` Preflight + `.docs/preflight-validation.md`     |
| **preflighter**        | Runs build/check/test as local CI gate                    | `.docs/preflight.md` on failure only                        |

Workflow: `@researcher` → `@planner` → `@implementer` (or `@implementer-jr` for mechanical steps).

The planner inlines all research into `.docs/plan.md` — implementer reads ONLY the plan, never `.docs/research.md`.
Run `@preflight-validator` once per project setup; `@preflighter` uses the cached `## Preflight` section on every run.
