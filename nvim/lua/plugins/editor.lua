return {
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch buffer" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (root dir)" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find files (hidden)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find git files" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer fuzzy find" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key maps" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to mark" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>sS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word under cursor" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<esc>"] = "close",
          },
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      pcall(require("telescope").load_extension, "fzf")
    end,
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer (root dir)" },
      { "<leader>E", "<cmd>Neotree dir=%:p:h toggle<cr>", desc = "Explorer (current file dir)" },
      { "<leader>ge", "<cmd>Neotree source=git_status toggle<cr>", desc = "Git explorer" },
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "Copy path to clipboard",
          },
        },
      },
      default_component_configs = {
        indent = { with_expanders = true, expander_collapsed = "", expander_expanded = "", expander_highlight = "NeoTreeExpander" },
        git_status = {
          symbols = {
            unstaged = "󰄱", staged = "󰱒",
          },
        },
      },
    },
  },

  -- Git signs in gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" }, change = { text = "▎" }, delete = { text = "" },
        topdelete = { text = "" }, changedelete = { text = "▎" }, untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[h", function() gs.nav_hunk("prev") end, "Prev hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First hunk")
        map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk")
      end,
    },
  },

  -- Flash - fast navigation with labels
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Diagnostics list
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then require("trouble").prev({ skip_groups = true, jump = true })
          else vim.cmd.cprev() end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then require("trouble").next({ skip_groups = true, jump = true })
          else vim.cmd.cnext() end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },

  -- Mini plugins (surround, ai text objects, pairs)
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = { n_lines = 500 },
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", delete = "gsd", find = "gsf", find_left = "gsF",
        highlight = "gsh", replace = "gsr", update_n_lines = "gsn",
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
    },
  },

  -- Icons (used by many plugins)
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
}
