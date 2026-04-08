# Dotfiles

Personal development environment configuration.

Includes:

- Claude configuration (~/.claude)
- Neovim configuration (~/.config/nvim)
- Opencode configuration (~/.config/opencode)
- Custom terminal commands (see below)

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
| `docs-writer` | Shared `.docs/` output convention (loaded by agents, not auto-triggered). |

## Opencode

Uses the **OpenCode Zen (free)** provider with Go provider support.

| Model | ID |
|---|---|
| MiniMax M2.5 Free | `opencode/minimax-m2.5-free` |
| Qwen3.6 Plus Free | `opencode/qwen3-6-plus-free` |

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

~/.claude        -> ~/dotfiles/claude
~/.config/nvim   -> ~/dotfiles/nvim
~/.config/opencode -> ~/dotfiles/opencode

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
