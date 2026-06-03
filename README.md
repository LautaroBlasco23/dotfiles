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
| `nvim/` | `~/.config/nvim` |
| `opencode/` | `~/.config/opencode` |

Scripts in `scripts/` (except `init.sh`) are linked to `~/bin/` and made available in your `$PATH`.

---

## Skills

Context-injected rules shared by Claude and Opencode. They auto-trigger based on task type, or can be invoked manually with slash commands (e.g. `/caveman`, `/commit`).

| Skill | Description |
|---|---|
| `caveman` | Ultra-compressed communication (~75% token reduction). Intensity levels: lite/full/ultra. |
| `coding-principles` | Universal code quality principles, language-agnostic. |
| `commit` | Conventional Commits format, atomic commits, no AI metadata. |

---

## OpenCode

### Providers

| Provider | Name | Base URL |
|---|---|---|
| `opencode-go` | OpenCode Go | `https://opencode.ai/zen/go/v1` |
| `opencode` | OpenCode Zen (free) | `https://opencode.ai/zen/v1` |

### Opencode Models

Models configured in `opencode/opencode.json`. Agents below use `deepseek-v4-flash` for coding/exploring and `qwen3.6-plus` for planning/teaching.

| Model | Provider | ID |
|---|---|---|
| DeepSeek V4 Flash | OpenCode Go | `opencode-go/deepseek-v4-flash` |
| Qwen 3.6 Plus | OpenCode Go | `opencode-go/qwen3.6-plus` |
| MiniMax M2.5 Free | OpenCode Zen (free) | `opencode/minimax-m2.5-free` |

### Honorable Mentions

Currently testing **Mimo V2.5** and **MiniMax M3** for some tasks. They are doing a great job at the moment — strong contenders to become part of the default roster once they stabilize.

### Agents

Defined in `opencode/agents/`.

| Agent | Model | Description |
|---|---|---|
| `build` | DeepSeek V4 Flash | **Default build** — runs implementation work per a plan. |
| `plan` | Qwen 3.6 Plus | **Default plan** — architecture and execution planning. |
| `explorer` | DeepSeek V4 Flash | Repository discovery and contextual code exploration. Read-only. |
| `teacher` | Qwen 3.6 Plus | Conceptual understanding and technical education. No code changes. |
| `tester` | DeepSeek V4 Flash | Validation and testing analysis. Adversarial reasoning. |

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
