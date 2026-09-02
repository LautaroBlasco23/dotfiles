return {
  -- Completion engine (modern, faster alternative to nvim-cmp)
  -- Deferred to InsertEnter; lsp.lua provides equivalent completion
  -- capabilities manually since blink isn't loaded during LSP setup.
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      snippets = {
        -- .jsx/.tsx reuse the JS/TS snippets (nvim/snippets/)
        extended_filetypes = {
          javascriptreact = { "javascript" },
          typescriptreact = { "typescript" },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },
      },
    },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    -- Load when a file opens so async format-on-save works from the first save
    event = { "BufReadPost", "BufNewFile" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    -- Async format on save: never blocks the write; conform re-saves the
    -- file after formatting completes.
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        markdown = { "prettier" },
        go = { "goimports", "gofmt" },
        python = { "isort", "black" },
        sh = { "shfmt" },
      },
      format_after_save = { lsp_fallback = true },
    },
  },

  -- Treesitter - better syntax highlighting (main branch rewrite)
  -- Requires tree-sitter-cli >= 0.26 and a C compiler in PATH.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- the rewrite does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "bash", "regex", "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "tsx", "json",
        "yaml", "html", "css", "python", "go", "gomod",
        "markdown", "markdown_inline",
      })

      -- In the rewrite, highlighting and indentation are opt-in per filetype
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("myconfig_treesitter", { clear = true }),
        callback = function(args)
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  -- Comments
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
