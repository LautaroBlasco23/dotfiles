# Dotfiles

Personal development environment configuration.

Includes:

- Claude workflow configuration (~/.claude)
- Neovim configuration (~/.config/nvim)
- Opencode configuration (~/.config/opencode)
- Custom terminal commands (see below)

---

## Claude Agents

Custom agents for structured development tasks.

| Agent | Model | Description |
|---|---|---|
| `researcher` | Haiku | Explores codebase for patterns and conventions. Produces `.docs/research.md`. |
| `planner` | Sonnet | Designs implementation plan. Produces `.docs/plan.md`. |
| `implementer` | Sonnet | Writes code following plan and research. Produces `.docs/implementation-log.md`. |
| `implementer-jr` | Haiku | Handles mechanical tasks: file deletions, moves, renames, boilerplate. |
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

Pull latest changes via the workflow manager:

```bash
claude-workflow
```

Select **Update dotfiles** from the interactive menu, or run directly:

```bash
claude-workflow  # interactive TUI
```

Because the configs are symlinked, updates apply automatically.

---

## Custom Commands

Commands added to `~/bin` by the installer:

| Command | Description |
|---|---|
| `claude-workflow` | Interactive TUI to manage Claude workflow profiles |
| `docker-clean` | Prune dangling Docker images and build cache (`--all` to remove all unused images, build cache, and volumes) |

### claude-workflow

Manages Claude Code workflow profiles stored in `~/dotfiles/claude-workflows/`.

```bash
claude-workflow                   # interactive menu (j/k to navigate)
claude-workflow list              # list available workflows
claude-workflow status            # show active workflow (agents & skills)
claude-workflow switch <name>     # switch to a workflow
claude-workflow new <name>        # scaffold a new workflow from the active one
```

The interactive menu shows the active workflow, last pull date, and lets you switch workflows or update dotfiles without typing subcommands.

---

## Links to install the used tools

Claude:

https://code.claude.com/docs/en/quickstart

Neovim:

https://neovim.io/doc/install/

Opencode:

https://opencode.ai
