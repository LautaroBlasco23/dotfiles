# Dotfiles

Personal development environment configuration.

Includes:

- Claude workflow configuration (~/.claude)
- Neovim configuration (~/.config/nvim)

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

## Repository structure

dotfiles/
├── claude/
│   ├── CLAUDE.md
│   ├── agents/
│   ├── skills/
│   └── prompts/
├── nvim/
└── install.sh

---

## Copy existing Neovim config

If you already have a Neovim setup:

```bash
rsync -av ~/.config/nvim/ ~/dotfiles/nvim/
```

---

## Claude Code installation

Install the Claude Code CLI tool:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

---

## One-command install

```bash
git clone git@github.com:lautaroblasco23/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```
