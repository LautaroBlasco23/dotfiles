# Dotfiles

Personal development environment configuration.

Currently using Opencode for most of my work. The project also contains some claude configurations because I'm also using it in some cases.

---

Uses **symlink-based linking** — configs live in this repo and are linked to their expected locations. This means updates apply instantly after `git pull`.

The `skills/` folder is a centralized directory shared by both Claude and Opencode. It contains all agent skills and is linked into both config trees.

Linked configs:

| Repo Path | Linked To |
|---|---|
| `skills/` | `~/.claude/skills`, `~/.opencode/skills` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/scripts` | `~/.claude/scripts` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `claude/settings.local.json` | `~/.claude/settings.local.json` |
| `.claude/` | MCP credentials/stored in `~/.claude/` |
| `nvim/` | `~/.config/nvim` |
| `opencode/` | `~/.config/opencode` |

Scripts in `scripts/` (except `init.sh`) are linked to `~/bin/` and made available in your `$PATH`.

---

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

### Opencode Models

Currently I'm only using Qwen 3.6 plus for thinking related tasks and DeepSeek V4 Flash for most of the coding/exploring work.

| Model | Provider | ID |
|---|---|---|
| DeepSeek V4 Flash | OpenCode Go | `opencode-go/deepseek-v4-flash` |
| Qwen3.6 Plus | OpenCode Go | `opencode-go/qwen3.6-plus` |

### Agents

I'm just using main agents in Opencode right now.

#### Main Agents

| Agent | Model | Description |
|---|---|---|
| `build` | DeepSeek V4 Pro | **Default build** — runs build operations for the project. |
| `build-kimi` | Kimi K2.6 | Build with long-context strength (previous default). |
| `build-qwen` | Qwen3.6 Plus | Build with strong instruction-following and structure. |
| `plan` | Qwen3.6 Plus | **Default plan** — creates implementation plans for tasks. |
| `plan-deepseek` | DeepSeek V4 Pro | Plan for deep reasoning and complex architecture. |
| `plan-kimi` | Kimi K2.6 | Plan for very large codebases needing huge context. |

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
~/.claude/CLAUDE.md         -> ~/dotfiles/claude/CLAUDE.md
~/.claude/scripts           -> ~/dotfiles/claude/scripts
~/.claude/settings.json     -> ~/dotfiles/claude/settings.json
~/.claude/settings.local.json  -> ~/dotfiles/claude/settings.local.json
~/.claude/skills            -> ~/dotfiles/skills
~/.opencode/skills          -> ~/dotfiles/skills
~/.config/nvim              -> ~/dotfiles/nvim
~/.config/opencode          -> ~/dotfiles/opencode
```

---

## Updating

Pull the latest changes from the repo:

```bash
cd ~/dotfiles && git pull
```

Because the configs are symlinked, updates apply automatically.

---

## Links to install the used tools

Claude:

https://code.claude.com/docs/en/quickstart

Neovim:

https://neovim.io/doc/install/

Opencode:

https://opencode.ai
