return {
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("myconfig_lsp_attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", require("telescope.builtin").lsp_references, "Go to references")
          map("gI", require("telescope.builtin").lsp_implementations, "Go to implementation")
          map("gy", require("telescope.builtin").lsp_type_definitions, "Go to type definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("gK", vim.lsp.buf.signature_help, "Signature help")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- Enable inlay hints if supported
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>uh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle inlay hints")
          end
        end,
      })

      -- Extend capabilities with blink.cmp if available, else nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      else
        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
          capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
        end
      end

      -- LSP servers to install and configure
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim" } },
            },
          },
        },
        ts_ls = {},
        gopls = {},
        bashls = {},
        jsonls = {},
        yamlls = {},
        html = {},
        cssls = {},
        pyright = {},
      }

      require("mason").setup({ ui = { border = "rounded" } })

      local ensure_installed = vim.tbl_keys(servers)
      -- Formatters and linters managed by mason
      vim.list_extend(ensure_installed, {
        "stylua", "prettier", "eslint_d", "black", "isort",
        "goimports", "shfmt",
      })

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  -- Neovim Lua development
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}