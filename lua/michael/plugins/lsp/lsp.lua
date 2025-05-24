return {
  {
    -- Core LSP plugin for Neovim
    "neovim/nvim-lspconfig",

    dependencies = {
      -- Installs and manages external tools like LSPs
      "williamboman/mason.nvim",

      -- Bridges mason.nvim with lspconfig for easier setup
      "williamboman/mason-lspconfig.nvim",

      -- Optional: improves LSP autocompletion with nvim-cmp
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      -- Safely import required plugins
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      -- Setup completion capabilities if cmp is installed
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_status then
        capabilities = cmp_nvim_lsp.default_capabilities()
      end

      -- Configure mason
      mason.setup()

      -- Configure mason-lspconfig
      mason_lspconfig.setup({
        ensure_installed = {
          "ts_ls", -- JavaScript/TypeScript
          "lua_ls",   -- Lua
          "jsonls",   -- JSON
          "html",     -- HTML
          "cssls",    -- CSS
        },
        -- Replace setup_handlers with `handlers` (new syntax in v2+)
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
              on_attach = function(_, bufnr)
                -- LSP key mappings
                local nmap = function(keys, func, desc)
                  vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                end

                nmap("gd", vim.lsp.buf.definition, "Go to Definition")
                nmap("gr", vim.lsp.buf.references, "Go to References")
                nmap("K", vim.lsp.buf.hover, "Hover Info")
                nmap("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
                nmap("<leader>ca", vim.lsp.buf.code_action, "Code Action")
              end,
            })
          end,
        },
      })
    end,
  },
}
