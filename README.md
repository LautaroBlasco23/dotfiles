# Dotfiles

Personal development environment configuration.

Includes:

- Claude workflow configuration (~/.claude)
- Neovim configuration (~/.config/nvim)
- Custom terminal commands (see below)

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
| `docker-clean` | Prune dangling Docker images (`--all` to remove all unused) |

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
