# Dotfiles

Personal development environment configuration.

Currently using Claude Code and Opencode for writing code.

---

Uses **symlink-based linking** — configs live in this repo and are linked to their expected locations. This means updates apply instantly after `git pull`.

Linked configs:

| Repo Path | Linked To |
|---|---|
| `claude/` | `~/.claude` |
| `nvim/` | `~/.config/nvim` |
| `opencode/` | `~/.config/opencode` |

Scripts in `scripts/` (except `init.sh`) are linked to `~/bin/` and made available in your `$PATH`.

---

## Claude Agents

Custom agents for structured development tasks. Invoked manually in the main conversation (e.g., `@planner "add auth"`).

| Agent | Model | Description |
|---|---|---|
| `researcher` | Haiku | Explores codebase for patterns and conventions. Produces `.docs/research.md`. |
| `planner` | Sonnet | Designs self-contained implementation plan (inlines research context). Produces `.docs/plan.md`. |
| `implementer` | Sonnet | Writes code following the plan. Returns summary in final message. |
| `implementer-jr` | Haiku | Handles mechanical tasks: file deletions, moves, renames, boilerplate. Returns summary in final message. |
| `preflight-validator` | Haiku | Inspects toolchain and dependencies. Writes `## Preflight` to project `CLAUDE.md`. |
| `preflighter` | Haiku | Runs build, check, and tests as a local CI gate. Writes `.docs/preflight.md` on failure. |

## Claude Permissions

Pre-approved tool operations that won't prompt for confirmation. Configured in `~/.claude/settings.json`.

| Scope | Tools |
|---|---|
| GitHub MCP (read-only) | `get_*`, `list_*`, `search_*`, `issue_read`, `pull_request_read` |

Write operations (`create_*`, `push_*`, `merge_*`, `delete_*`, comments, etc.) still require confirmation.

## Claude Skills

Context-injected rules that auto-trigger based on task type.

| Skill | Description |
|---|---|
| `agent-injection` | Mandatory rules for spawning agents (context, specificity, token budget). |
| `architecture` | Guidance on system design and layer boundaries. |
| `coding-principles` | Core code quality principles applied to any implementation. |
| `coding-golang` | Idiomatic Go standards (Fiber, sqlx/pgx, slog, table-driven tests). |
| `coding-typescript` | TypeScript standards (strict mode, Vite, Vitest). |
| `coding-react` | React standards (functional components, hooks, Vite + React). |
| `commit-messages` | Conventional Commits format, atomic commits. |
| `caveman` | Ultra-compressed communication (~75% token reduction). Intensity levels: lite/full/ultra. |
| `docs-writer` | Shared `.docs/` output convention (loaded by agents, not auto-triggered). |

---

## OpenCode

### Providers

| Provider | Name | Base URL |
|---|---|---|
| `opencode-go` | OpenCode Go | `https://opencode.ai/zen/go/v1` |
| `opencode` | OpenCode Zen (free) | `https://opencode.ai/zen/v1` |

### Models

| Model | Provider | ID |
|---|---|---|
| Kimi K2.6 | OpenCode Go | `opencode-go/kimi-k2.5` |
| MiniMax M2.5 Free | OpenCode Zen | `opencode/minimax-m2.5-free` |

### Agents

Agents are invoked manually in the main conversation (e.g., `@planner "add auth"`).

| Agent | Model | Description |
|---|---|---|
| `build` | Kimi K2.6 | Runs build operations for the project. |
| `plan` | Kimi K2.6 | Creates implementation plans for tasks. |
| `researcher` | MiniMax M2.5 Free | Explores codebase for patterns and conventions. Produces `.docs/research.md`. |
| `planner` | Kimi K2.6 | Designs self-contained implementation plan. Produces `.docs/plan.md`. |
| `implementer` | Kimi K2.6 | Writes code following the plan. Returns summary in final message. |
| `implementer-jr` | MiniMax M2.5 Free | Handles mechanical tasks: file deletions, moves, renames, boilerplate. |
| `preflight-validator` | MiniMax M2.5 Free | Validates project readiness. Writes Preflight section to CLAUDE.md. |
| `preflighter` | MiniMax M2.5 Free | Runs build, check, and tests as a local CI gate. Writes `.docs/preflight.md` on failure. |

---

## Installation

Clone the repository:

```bash
git clone git@github.com:lautaroblasco23/dotfiles.git ~/dotfiles
```

Run the installer:

```bash
cd ~/dotfiles && ./install.sh
```

The installer will:

- create required directories
- backup existing configs
- create symlinks

Result:

```
~/.claude           -> ~/dotfiles/claude
~/.config/nvim      -> ~/dotfiles/nvim
~/.config/opencode  -> ~/dotfiles/opencode
```

---

## Updating

Pull the latest changes from the repo:

```bash
cd ~/dotfiles && git pull
```

Because the configs are symlinked, updates apply automatically.

---

## Custom Commands

Commands added to `~/bin` by the installer:

| Command | Description |
|---|---|
| `docker-clean` | Prune dangling Docker images and build cache (`--all` to remove all unused images, build cache, and volumes) |

---

## Links to install the used tools

Claude:

https://code.claude.com/docs/en/quickstart

Neovim:

https://neovim.io/doc/install/

Opencode:

https://opencode.ai
