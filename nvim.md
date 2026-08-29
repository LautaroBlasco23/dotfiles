# Neovim Cheat Sheet

> Keymaps below reflect the current configuration in `nvim/`. If something seems missing, press `<leader>?` (buffer-local keys) or `<leader>sk` (search all keymaps) inside Neovim.

- **Leader:** `<Space>`
- **LocalLeader:** `\`
- **Colorscheme:** tokyonight-moon
- **Plugin manager:** lazy.nvim

---

## Files & Search (Telescope / neo-tree)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fF` | Find files (incl. hidden & ignored) |
| `<leader>fC` | Find files in current directory |
| `<leader>fr` | Recent files |
| `<leader>fg` | Git files (tracked only) |
| `<leader><space>` | Switch buffers |
| `<leader>/` or `<leader>sg` | Live grep (project search) |
| `<leader>sG` | Live grep with args (`<C-k>` quote pattern, `<C-g>` quote + `-g ` glob) |
| `<leader>sw` | Search word under cursor |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>ss` / `<leader>sS` | Document / workspace symbols |
| `<leader>sd` / `<leader>sD` | Document / workspace diagnostics |
| `<leader>sc` or `<leader>:` | Command history |
| `<leader>e` | Toggle file explorer (project root) |
| `<leader>E` | File explorer at current file's directory |
| `<leader>ge` | Git status explorer |

**Inside pickers:** `<C-j>/<C-k>` move · `<C-s>/<C-v>/<C-t>` open in split/vsplit/tab · `<C-q>` send all to quickfix · `<M-q>` send selection to quickfix · `<C-u>/<C-d>` scroll preview · `<esc>` close

## Buffers, Tabs & Windows

| Key | Action |
|---|---|
| `[b` / `]b` | Previous / next buffer |
| `<S-h>` / `<S-l>` | Previous / next buffer (bufferline) |
| `<leader>bd` | Delete buffer |
| `<leader>bD` | Delete all buffers |
| `<leader>bo` | Delete all other buffers |
| `<leader>bp` / `<leader>bP` | Pin buffer / delete non-pinned |
| `<leader><tab>n` / `d` / `]` / `[` | New / close / next / previous tab |
| `<C-h/j/k/l>` | Navigate windows |
| `<C-Arrows>` | Resize window |
| `<leader>-` / `<leader>\|` | Split below / split right |
| `<leader>wd` | Close window |
| `<leader>qq` | Quit all |

## LSP & Code

Buffer-local, active after LSP attaches:

| Key | Action |
|---|---|
| `gd` / `gD` | Go to definition / declaration |
| `gr` | References |
| `gI` | Implementations |
| `gy` | Type definition |
| `K` | Hover docs |
| `gK` | Signature help |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>uh` | Toggle inlay hints |
| `<leader>cs` | Symbols outline (Trouble) |
| `<leader>cl` | LSP references panel (Trouble) |

**Completion (blink.cmp):** `<Tab>/<S-Tab>` next/prev item · `<CR>` accept · `<C-space>` toggle docs · `<C-e>` hide

## Formatting

Format-on-save is enabled (async) via conform.nvim.

| Key | Action |
|---|---|
| `<leader>cf` | Format buffer (normal & visual) |

Toolchain: **Lua** stylua · **JS/TS/JSON/YAML/HTML/CSS/MD** prettier · **Go** goimports + gofmt · **Python** isort + black · **Shell** shfmt · **Linting** eslint_d

## Git

| Key | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk |
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame line |
| `<leader>ghu` | Undo stage |
| `<leader>gg` | Lazygit |
| `<leader>gf` | Lazygit log (current file) |
| `<leader>gl` | Lazygit log |
| `<leader>gb` | Open repo in browser |
| `<leader>gB` | Blame line popup |
| `<leader>gc` / `<leader>gs` | Git commits / git status (Telescope) |

## Diagnostics & Todos

| Key | Action |
|---|---|
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `<leader>cd` | Line diagnostics float |
| `<leader>xx` / `<leader>xX` | Workspace / buffer diagnostics (Trouble) |
| `[q` / `]q` | Previous / next quickfix item |
| `]t` / `[t` | Next / previous TODO comment |

## Navigation & Editing

| Key | Action |
|---|---|
| `s` | Flash jump (type chars, pick label) |
| `S` | Flash treesitter jump (select node) |
| `gsa` / `gsd` | Add / delete surrounding (mini.surround) |
| `gsr` | Replace surrounding |
| `ih` | Select git hunk as text object |
| `<A-j>` / `<A-k>` | Move line/block down/up (n/i/v) |
| `v` mode `<` / `>` | Indent keeping selection |
| `x` mode `p` | Paste without overwriting register |
| `//` (visual) | Grep visual selection in Telescope |

## Debugging (DAP)

Go (delve) and Node/TS (js-debug-adapter), attach-based:

| Key | Action |
|---|---|
| `<leader>da` | Run/attach adapter picker |
| `<leader>dc` | Continue |
| `<leader>db` / `<leader>dB` | Breakpoint / conditional breakpoint |
| `<leader>do` / `<leader>di` / `<leader>dO` | Step over / into / out |
| `<leader>dr` | Open REPL |
| `<leader>du` | Toggle DAP UI |
| `<leader>de` | Evaluate word under cursor |

## UI & Misc

| Key | Action |
|---|---|
| `<C-/>` | Toggle terminal (also hides it from terminal mode) |
| `<Esc><Esc>` | Terminal normal mode |
| `<leader>z` / `<leader>Z` | Zen mode / zoom window |
| `<leader>.` | Scratch buffer |
| `<leader>un` | Dismiss notifications |
| `<leader>snl` / `<leader>snh` | Last message / message history (Noice) |
| `<C-s>` | Save (normal, insert & visual modes) |
| `<Esc>` | Clear search highlight |

---

## Workflow Tips

- **System clipboard by default** — `y`/`p` work with your OS clipboard.
- **Smart-case search** — lowercase patterns ignore case; adding a capital makes it case-sensitive.
- **Relative line numbers** — combine with counts: `5j`, `3dd`, etc.
- **Auto-mkdir on save** — saving into a non-existent directory creates it.
- **`q` closes special windows** — help, quickfix, notifications, blame popups, etc.
- **Persistent undo** — undo history survives restarts.
- **Search stays centered & direction-free** — `n`/`N` always move forward/backward regardless of `/` vs `?`.
- **Grep with precision** — in live-grep-args, `<C-k>` wraps the query in quotes; `<C-g>` adds `-g ` for glob filtering (e.g. `-g *.go`).
- **Quickfix workflow** — send Telescope results with `<C-q>`, then jump through with `[q`/`]q`.
- **Surround prefix is `gs`**, not the mini.surround default `s` — e.g. `gsaiw)` surrounds the word with parentheses.
- **Debugging is attach-based** — start your Go binary with delve or Node with `--inspect` (port 9229), then use `<leader>da`.
- **Config editing gets LSP love** — lazydev provides Neovim API completions when editing `lua/` files.
