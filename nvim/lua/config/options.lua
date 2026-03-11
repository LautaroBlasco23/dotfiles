vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.cmdheight = 0
opt.showmode = false
opt.termguicolors = true
opt.pumblend = 10
opt.pumheight = 10
opt.winminwidth = 5
opt.wrap = false
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.laststatus = 3

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftround = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Files
opt.autowrite = true
opt.undofile = true
opt.undolevels = 10000
opt.backup = false
opt.swapfile = false
opt.updatetime = 200

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"

-- Folding
opt.foldlevel = 99

-- Misc
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.smoothscroll = true
opt.virtualedit = "block"
opt.inccommand = "nosplit"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.timeoutlen = 300

-- Diagnostics
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.HINT]  = "H",
      [vim.diagnostic.severity.INFO]  = "I",
    },
  },
})
