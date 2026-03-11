# My personal neovim configuration

I've built this config for my own personal usage, based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and inspired by [LazyVim](https://www.lazyvim.org/).

## Requirements

- Neovim (latest stable)
- [ripgrep](https://github.com/BurntSushi/ripgrep) — required for live grep
- [fd](https://github.com/sharkdp/fd) — required for file search
- A [Nerd Font](https://www.nerdfonts.com/) — recommended for icons
- `git`, `make`, `gcc`

## Installation

```bash
# Backup existing config if you have one
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone the repo
git clone https://github.com/LautaroBlasco23/kickstart.nvim.git ~/.config/nvim

# Open neovim — lazy.nvim will install everything automatically
nvim
```

### If you're getting errors installing Python tools (black, isort)

Newer Ubuntu versions (Python ≥3.12) block global `pip` installs.  
If you see an error like `externally-managed-environment`, install the tools using `pipx`.

```bash
# install pipx
sudo apt update
sudo apt install -y pipx
pipx ensurepath

# reload shell
source ~/.bashrc

# install python formatting tools
pipx install black
pipx install isort

# verify installation
black --version
isort --version
```

These tools are used by the formatter integration and may be required by plugins installed through Mason.

---

## File architecture

```
~/.config/nvim/
├── init.lua                  # Entry point — bootstraps lazy.nvim and loads config modules
└── lua/
    ├── config/
    │   ├── options.lua       # Vim options (line numbers, indentation, search, etc.)
    │   ├── keymaps.lua       # Global keybinds not tied to any specific plugin
    │   └── autocmds.lua      # Auto-commands (highlight on yank, restore cursor, etc.)
    └── plugins/
        ├── colorscheme.lua   # Theme (TokyoNight Moon)
        ├── ui.lua            # Visual layer — bufferline, lualine, noice, which-key, snacks, indent guides, todo-comments
        ├── editor.lua        # Editing tools — telescope, neo-tree, gitsigns, flash, trouble, mini plugins
        ├── lsp.lua           # LSP — mason, nvim-lspconfig, mason-lspconfig, lazydev
        └── coding.lua        # Coding — blink.cmp (completion), conform (formatting), treesitter
```

---

## Plugins

### Theme
| Plugin | Description |
|--------|-------------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Color scheme — using the `moon` variant |

### UI
| Plugin | Description |
|--------|-------------|
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer tabs displayed at the top of the screen |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line at the bottom with mode, branch, diagnostics, and clock |
| [noice.nvim](https://github.com/folke/noice.nvim) | Replaces the command line and messages with floating windows |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Shows available keybinds in a popup when you pause after `<leader>` |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Dashboard, notifications, terminal, lazygit integration, zen mode, scratch buffers |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guide lines |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlights `TODO`, `FIX`, `HACK`, `NOTE` tags in comments |

### Editor
| Plugin | Description |
|--------|-------------|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder for files, grep, LSP symbols, and more |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer sidebar |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git change indicators in the gutter, hunk staging and navigation |
| [flash.nvim](https://github.com/folke/flash.nvim) | Fast cursor jumping with character labels |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics and quickfix list panel |
| [mini.ai](https://github.com/echasnovski/mini.ai) | Extended text objects (functions, classes, arguments) |
| [mini.surround](https://github.com/echasnovski/mini.surround) | Add, delete, and replace surrounding characters |
| [mini.pairs](https://github.com/echasnovski/mini.pairs) | Auto-close brackets, quotes, and parentheses |

### LSP & Coding
| Plugin | Description |
|--------|-------------|
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Auto-installs LSP servers, formatters, and linters |
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Autocompletion engine |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatter with format-on-save support |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Lua LSP awareness of the Neovim API |

---

## Keymaps

`<leader>` is mapped to `Space`.

### Files & Search
| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files |
| `<leader>sg` | Live grep (search text across project) |
| `<leader>sw` | Search word under cursor |
| `<leader>fr` | Recent files |
| `<leader>sb` | Fuzzy search in current buffer |
| `<leader>sk` | Search keymaps |
| `<leader>sh` | Search help pages |
| `<leader>e` | Toggle file explorer |
| `<leader>E` | Toggle file explorer (current file dir) |

### Buffers & Windows
| Keymap | Action |
|--------|--------|
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bd` | Delete current buffer |
| `<C-h/j/k/l>` | Navigate between windows |
| `<leader>w-` | Split window below |
| `<leader>w\|` | Split window right |
| `<leader>wd` | Close window |

### LSP
| Keymap | Action |
|--------|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>cd` | Show line diagnostics |

### Git
| Keymap | Action |
|--------|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gb` | Git browse (open in browser) |
| `<leader>gB` | Git blame current line |
| `]h` / `[h` | Next / previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk inline |

### Navigation
| Keymap | Action |
|--------|--------|
| `s` | Flash jump (type chars to jump) |
| `S` | Flash treesitter jump |
| `]]` / `[[` | Next / previous word reference |

### Terminal & Misc
| Keymap | Action |
|--------|--------|
| `<C-/>` | Toggle terminal |
| `<leader>ft` | Open terminal (root dir) |
| `<leader>fT` | Open terminal (current file dir) |
| `<leader>z` | Toggle zen mode |
| `<leader>xx` | Toggle diagnostics panel |
| `<leader>?` | Show buffer keymaps (which-key) |
| `<leader>qq` | Quit all |
| `<C-s>` | Save file |
