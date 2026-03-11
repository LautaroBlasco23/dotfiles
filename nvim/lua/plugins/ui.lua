return {
  -- Buffer tabs at top
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        close_command = function(n) require("snacks").bufdelete(n) end,
        right_mouse_command = function(n) require("snacks").bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics" },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {
          { "diff" },
          { "encoding", cond = function() return vim.bo.fileencoding ~= "utf-8" end },
          "fileformat",
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = { function() return " " .. os.date("%R") end },
      },
      extensions = { "neo-tree", "lazy" },
    },
  },

  -- Modern UI for messages, cmdline, popupmenu
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        { filter = { event = "msg_show", any = { { find = "%d+L, %d+B" }, { find = "; after #%d+" }, { find = "; before #%d+" } } }, view = "mini" },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice last message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice history" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice all" },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
  },

  -- Key binding hints popup
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        {
          mode = { "n", "x" },
          { "<leader>b", group = "buffer" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>sn", group = "noice" },
          { "<leader>u", group = "ui" },
          { "<leader>w", group = "windows", proxy = "<c-w>" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "<leader><tab>", group = "tabs" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
        },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps (which-key)" },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = false },
      exclude = {
        filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "notify" },
      },
    },
  },

  -- Todo comments (TODO, FIX, HACK, etc.)
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },

  -- Snacks - collection of small QoL plugins (dashboard, notifications, terminal, etc.)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss all notifications" },
      { "<leader>bd", function() require("snacks").bufdelete() end, desc = "Delete buffer" },
      { "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
      { "<leader>gb", function() require("snacks").gitbrowse() end, desc = "Git browse" },
      { "<leader>gB", function() require("snacks").git.blame_line() end, desc = "Git blame line" },
      { "<leader>gf", function() require("snacks").lazygit.log_file() end, desc = "Lazygit current file" },
      { "<leader>gl", function() require("snacks").lazygit.log() end, desc = "Lazygit log" },
      { "]]", function() require("snacks").words.jump(vim.v.count1) end, desc = "Next reference" },
      { "[[", function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev reference" },
      { "<leader>.",  function() require("snacks").scratch() end, desc = "Toggle scratch buffer" },
      { "<leader>z",  function() require("snacks").zen() end, desc = "Toggle zen mode" },
      { "<leader>Z",  function() require("snacks").zen.zoom() end, desc = "Toggle zoom" },
      { "<c-/>",      function() require("snacks").terminal() end, desc = "Toggle terminal (root dir)", mode = { "n", "t" } },
      { "<leader>ft", function() require("snacks").terminal() end, desc = "Terminal (root dir)" },
      { "<leader>fT", function() require("snacks").terminal(nil, { cwd = vim.fn.expand("%:p:h") }) end, desc = "Terminal (current file dir)" },
    },
  },
}
