# Dotfiles

Personal development environment configuration.

## Workflow

```
explore → what exists
plan → what to do
build → analyze, design, and implement
validator → verify it
```

---

## Structure

Uses **copy-based syncing** — `sync.sh` copies the tracked configs in this repo to their expected locations as real files (no symlinks). Run `./sync.sh` after `git pull` to apply updates.

| Repo Path | Synced To |
|---|---|
| `opencode/` | `~/.config/opencode` |
| `claude/` | `~/.claude` |
| `nvim/` | `~/.config/nvim` |
| `skills/` | `~/.claude/skills`, `~/.opencode/skills` |

Notes:

- Only git-tracked files are copied; machine-local files (`claude/settings.local.json`) are excluded.
- Sync is one-way (repo → home). Local edits to the copied configs are overwritten on the next run.

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

Defined in `opencode/agents/`.

| Model | ID |
|---|---|
| DeepSeek V4 Flash | `opencode-go/deepseek-v4-flash` |
| Qwen 3.7 Plus | `opencode-go/qwen3.7-plus` |

Agents use `deepseek-v4-flash` for exploring and `qwen3.7-plus` for planning, analysis, and implementation.

| Agent | Description |
|---|---|
| `build` | Engineering-oriented agent for analysis, design, and implementation. |
| `plan` | Architecture and execution planning. |
| `explorer` | Repository discovery and contextual code exploration. Read-only. |
| `validator` | Validation and testing analysis. Adversarial reasoning. |

---

## Installation

Clone the repository:

```bash
git clone git@github.com:lautaroblasco23/dotfiles.git ~/dotfiles
```

Run the sync (copies configs to `~/.config` and `~/.claude`):

```bash
cd ~/dotfiles && ./sync.sh
```

Preview first with `./sync.sh --dry-run`. Re-run after `git pull` to apply updates.

## Partial Install

Pull individual configs without cloning the full repo:

**OpenCode:**

```bash
mkdir -p ~/.config/opencode && curl -L https://github.com/lautaroblasco23/dotfiles/archive/refs/heads/main.tar.gz | tar -xz --strip-components=1 -C ~/.config/opencode dotfiles-main/opencode
cd ~/.config/opencode && bun install   # or: npm install
```

**Neovim:**

```bash
mkdir -p ~/.config/nvim && curl -L https://github.com/lautaroblasco23/dotfiles/archive/refs/heads/main.tar.gz | tar -xz --strip-components=1 -C ~/.config/nvim dotfiles-main/nvim
```

Plugins install on first launch via `lazy.nvim`. Re-run the commands to update.
