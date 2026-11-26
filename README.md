# Dotfiles

This repository contains the files I use daily to work with my AI Agents (currently using Opencode and Claude Code).

I'm using opencode the most of the time (personal subscription) to work and to develop personal projects, so ./opencode/ configuration is better defined because of that.

Also, I'm currently using Neovim because I think it's faster and easier to use when working with Claude Code / Opencode in the terminal. So I have my own "minimalistic" configuration for it.

---

### Most important command from the repo:

```bash
alias oc='opencode --auto'
```

to avoid allowing Opencode to work after each single step.

---

# How to use it

Clone the repository:

```bash
git clone git@github.com:lautaroblasco23/dotfiles.git ~/dotfiles
```

Run the sync (copies configs to `~/.config` and `~/.claude`):

```bash
cd ~/dotfiles && ./sync.sh
```

Install the system tools the configs need (ripgrep, fd, fzf, lazygit, build tools):

```bash
cd ~/dotfiles && ./install.sh
```

Or ask sync to run it automatically (`--install-deps`). Sync also warns when a
required tool is missing on a real run. lazygit comes from its GitHub releases
(`~/.local/bin/lazygit`) since Fedora doesn't package it; `install.sh` adds
`~/.local/bin` to PATH in your shell rc if necessary.

## Font (NerdFont)

My Neovim configuration uses NerdFont icons/glyphs. If you haven't set one up yet, download it from:

[nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)

---

## Neovim

Minimal config in `nvim/` → `~/.config/nvim`. Leader is `<Space>`, colorscheme tokyonight-moon, plugin manager lazy.nvim. The full keymap reference lives inside Neovim: press `<leader>?` for buffer-local keys or `<leader>sk` to search all keymaps.

Most-used keys:

- `<leader>ff` / `<leader>fr` — find / recent files
- `<leader>/` — live grep
- `<leader>e` — file explorer
- `<leader>gg` — lazygit
- `<leader>bd` — delete buffer; `<S-h>` / `<S-l>` — prev / next buffer
- `gd` / `gr` / `K` — definition / references / hover (LSP)
- `<leader>cr` / `<leader>ca` — rename / code action
- `<leader>cf` — format buffer (format-on-save enabled)
- `<C-/>` — toggle terminal
- `s` — Flash jump

Workflow notes:

- System clipboard is the default for `y` / `p`.
- Smart-case search and relative line numbers.
- Surround prefix is `gs` (e.g. `gsaiw)`), not the mini.surround default.
- Debugging is attach-based — start Go under delve or Node with `--inspect`, then `<leader>da`.

---

## Opencode Agents

- **plan** — architecture and execution planning. Discuss the work and get a plan; after explicit approval it delegates implementation to a build subagent and validates the result.
- **build** — the implementer. Primary coding agent, and the subagent used by plan and orchestrate.
- **orchestrate** — delegate-first execution. Decomposes the objective into tasks, delegates every implementation to build subagents, validates results, and loops until done.

---

## Structure

| Repo Path   | Synced To                                |
| ----------- | ---------------------------------------- |
| `opencode/` | `~/.config/opencode`                     |
| `claude/`   | `~/.claude`                              |
| `AGENTS.md` | `~/.config/opencode/AGENTS.md`, `~/.claude/CLAUDE.md` |
| `nvim/`     | `~/.config/nvim`                         |
| `skills/`   | `~/.claude/skills`, `~/.config/opencode/skills` |

Notes:

- All repo files are synced, tracked or not; gitignored files and machine-local files (`claude/settings.local.json`) are excluded.
- Root `AGENTS.md` is the single source of shared agent instructions; Sync installs it under each tool's instruction filename.
- Sync is one-way (repo → home). Local edits to the copied configs are overwritten on the next run.
- Sync wipes and re-copies: `~/.config/nvim` and the skills directories are removed entirely on each run; `~/.config/opencode` and `~/.claude` only have the repo-managed entries replaced, so machine-local files are never touched.

