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

### Movement & Editing

| Key | Mode | What it does |
|-----|------|--------------|
| `j` / `k` | n, x | Move down/up, but respect wrapped lines |
| `n` / `N` | n | Next / previous search result (always goes forward/backward regardless of `/` or `?`) |
| `<Esc>` | n | Clear search highlight |
| `<A-j>` / `<A-k>` | n, i, v | Move current line(s) down / up |
| `<` / `>` | v | Indent selection (keeps selection) |
| `p` | x | Paste without overwriting the default register |
| `<C-s>` | i, x, n, s | Save file |

### Buffers & Tabs

| Key | What it does |
|-----|--------------|
| `<S-h>` / `<S-l>` or `[b` / `]b` | Previous / next buffer |
| `<leader>bd` | Delete current buffer |
| `<leader>bD` | Delete **all** buffers |
| `<leader>bp` | Toggle pin (bufferline) |
| `<leader>bo` | Close all other buffers |
| `<leader>br` / `<leader>bl` | Close buffers to the right / left |
| `<leader><tab>[` / `<leader><tab>]` | Previous / next tab |
| `<leader><tab><tab>` | New tab |
| `<leader><tab>d` | Close tab |

### Windows & Splits

| Key | What it does |
|-----|--------------|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Navigate to left/lower/upper/right window |
| `<C-Up>` / `<C-Down>` / `<C-Left>` / `<C-Right>` | Resize window |
| `<leader>wd` | Close window |
| `<leader>w-` or `<leader>-` | Split horizontally |
| `<leader>w\|` or `<leader>\|` | Split vertically |
| `<leader>ww` | Go to previous window |

### Search (Telescope)

| Key | What it does |
|-----|--------------|
| `<leader><space>` | Switch buffer |
| `<leader>/` or `<leader>sg` | Live grep (root dir) |
| `<leader>sG` | Live grep with args (lets you pass raw `rg` flags) |
| `<leader>ff` | Find files (includes hidden & ignored) |
| `<leader>fF` | Find files (all) |
| `<leader>fr` | Recent files |
| `<leader>fg` | Git files |
| `<leader>fC` | Find files in current file’s directory |
| `<leader>sw` | Grep word under cursor |
| `<leader>sb` | Fuzzy find in current buffer |
| `<leader>sd` / `<leader>sD` | Document / workspace diagnostics |
| `<leader>ss` / `<leader>sS` | Document / workspace symbols |
| `<leader>sh` | Help tags |
| `<leader>sk` | Keymaps |
| `<leader>sm` | Marks |
| `<leader>sr` | Resume last search |
| `<leader>:` | Command history |
| `<leader>st` | Todo comments |

**Inside any Telescope prompt (insert mode):**

| Key | What it does |
|-----|--------------|
| `<C-j>` | Move to next result |
| `<C-p>` | Move to previous result |
| `<CR>` | Open selected file |
| `<C-s>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<C-q>` | Send results to quickfix list |
| `<M-q>` | Send selected to quickfix |
| `<C-u>` / `<C-d>` | Scroll preview up / down |
| `<Esc>` | Close telescope |

**Inside `<leader>sG` specifically** (telescope-live-grep-args):
- `<C-k>` → Quote the prompt
- `<C-g>` → Quote prompt and append ` -g ` (for file globbing)

### LSP

| Key | What it does |
|-----|--------------|
| `gd` | Go to definition (telescope) |
| `gD` | Go to declaration |
| `gr` | Find references (telescope) |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<leader>cr` | Rename |
| `<leader>ca` | Code action |
| `<leader>uh` | Toggle inlay hints |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `<leader>cd` | Show line diagnostic |
| `<leader>cf` | Format buffer / selection |

### Git

| Key | What it does |
|-----|--------------|
| `<leader>gg` | Open lazygit |
| `<leader>gf` | Lazygit log for current file |
| `<leader>gl` | Lazygit log |
| `<leader>gb` | Git browse |
| `<leader>gB` | Git blame line |
| `<leader>gc` | Git commits (telescope) |
| `<leader>gs` | Git status (telescope) |
| `<leader>ge` | Git explorer (neo-tree) |
| `]h` / `[h` | Next / previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame line |
| `<leader>ghd` | Diff this |

### Flash (Fast Jump)

| Key | Mode | What it does |
|-----|------|--------------|
| `s` | n, x, o | Flash jump |
| `S` | n, x, o | Flash treesitter |
| `r` | o | Remote flash |
| `R` | o, x | Treesitter search |

### Mini.Surround

| Key | What it does |
|-----|--------------|
| `gsa` | Add surround |
| `gsd` | Delete surround |
| `gsr` | Replace surround |
| `gsf` / `gsF` | Find surround right / left |
| `gsh` | Highlight surround |

### Other

| Key | What it does |
|-----|--------------|
| `<leader>.` | Toggle scratch buffer |
| `<leader>z` | Zen mode |
| `<leader>Z` | Zoom current window |
| `<C-/>` or `<leader>ft` | Toggle terminal |
| `<leader>fT` | Terminal in current file’s dir |
| `<leader>un` | Dismiss notifications |
| `<leader>?` | Show buffer-local keymaps (which-key) |
| `<leader>qq` | Quit all |

---

## Quickfix List

The **quickfix list** (often shortened to “qflist”) is a built-in Neovim feature that holds a list of locations across files — essentially a scratchpad of "jump points" you can navigate sequentially. It is different from the location list (`:lopen`), which is per-window; the quickfix list is global per tab page.

### What you can use it for

- **Multi-file search results**: Send all matches from Telescope (`<C-q>`) into the quickfix list, then jump through them one by one without reopening the picker.
- **Project-wide diagnostics**: Tools like `trouble.nvim` can render the quickfix list in a nice panel, or you can use `:copen` to see raw diagnostics.
- **Build / lint errors**: Compilers, LSP, linters, and grep tools can populate the quickfix list with `file:line:column:message` entries.
- **Refactoring workflows**: Search for a pattern, send results to quickfix, then use `:cdo` or `:cfdo` to run a command on every match.

### How to use it

| Command / Keymap | Action |
|------------------|--------|
| `:copen` | Open the quickfix window |
| `:cclose` | Close the quickfix window |
| `:cnext` or `]q` | Jump to the next item |
| `:cprev` or `[q` | Jump to the previous item |
| `:cfirst` | Jump to the first item |
| `:clast` | Jump to the last item |
| `:cdo <cmd>` | Execute `<cmd>` on **each line** in the quickfix list |
| `:cfdo <cmd>` | Execute `<cmd>` on **each file** in the quickfix list |

**In your config**, `]q` and `[q` are smart: if Trouble is open, they jump inside Trouble; otherwise they fall back to standard `:cnext` / `:cprev`.

**Telescope integration**: Press `<C-q>` inside any Telescope picker to dump all visible results into the quickfix list. Press `<M-q>` to send only the currently selected items.
