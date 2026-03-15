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

Pull latest changes:

```bash
cd ~/dotfiles
git pull
```

Because the configs are symlinked, updates apply automatically.

---

## Custom Commands

Commands added to `~/bin` by the installer:

| Command | Description |
|---|---|
| `update-workflow` | Pull latest dotfiles from git |
| `workflow-status` | Show dotfiles git status |
| `docker-clean` | Prune dangling Docker images (`--all` to remove all unused) |

---

## Links to install the used tools

Claude:

https://code.claude.com/docs/en/quickstart

Neovim:

https://neovim.io/doc/install/
