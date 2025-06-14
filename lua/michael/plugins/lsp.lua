return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp", -- facilitates communication between lsp and autocompletion
		{ "antosha417/nvim-lsp-file-operations", config = true }, -- modify imports when files have been renamed
		{ "folke/neodev.nvim", opts = {} }, -- add improved lua lsp functionality
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	--[[
    Context: 
    - Mason is reponsible for downloading LSP (as well as linters, formatters, etc.)
    - mason-lspconfig acts as a bridge between mason by:
      1. mapping package names from mason to nvim-lspconfig
      2. can automatically setup installed lsp servers
        - I elect out of this because I wish to extend capabilities with manual config. 
        - Failing to recognize this at first lead to multiple LSP instances running, the active one
          being the one mason-lspconfig automatically setup without custom config (specifying "vim"
          keyword as a globally recognized keyword)
   - nvim-lspconfig is the core plugin that configures and connects LSP servers with Neovim's built-in
     LSP client
  ]]
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"ts_ls",
				"lua_ls",
				"jsonls",
				"html",
				"cssls",
				"marksman",
				"eslint",
			},
			automatic_enable = false, -- elect to setup servers myself to be able to pass cmp (autocomplete) capabilities
		})

		-- autoinstall formatters and linters
		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettierd",
				"stylua",
			},
		})

		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		---------------- setup LSPs with default configs -------------
		local standard_config_servers = {
			"ts_ls",
			"jsonls",
			"html",
			"cssls",
			"marksman",
		}

		for _, server in ipairs(standard_config_servers) do
			lspconfig[server].setup({
				capabilities = capabilities, -- allows autocompletion to source LSP data
			})
		end

		---------------- setup LSPs with custom configs -------------
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" }, -- supposed to add the vim keyword to the globally recognized list. Not working.
					},
				},
			},
		})

		lspconfig.eslint.setup({
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll", -- Optional: run fixers on save
				})
			end,
			settings = {
				format = true,
				codeActionOnSave = {
					enable = true,
					mode = "all",
				},
			},
		})
		----------------------------------------------------------------------------
		vim.diagnostic.config({
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			-- virtual_text = {
			-- 	prefix = "●",
			-- },
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- Change the Diagnostic symbols in the sign column (gutter) - not working on linux
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local bufnr = event.buf
				local client = vim.lsp.get_client_by_id(event.data.client_id) or { name = "" }
				local opts = { buffer = bufnr, silent = true }
				print("LSP attached: " .. client.name)

				opts.desc = "LSP: Show definitions"
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				opts.desc = "LSP: Go to declaration"
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "LSP: Go to declaration"
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "LSP: Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "LSP: Show implementations"
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "LSP: Show type definitions"
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "LSP: See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "LSP: Smart rename"
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "LSP: View line diagnostics"
				vim.keymap.set("n", "vd", vim.diagnostic.open_float, opts) -- view diagnostics for line

				opts.desc = "LSP: View buffer diagnostics"
				vim.keymap.set("n", "<leader>vD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- view  diagnostics for file

				opts.desc = "LSP: Go to previous diagnostic"
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "LSP: Go to next diagnostic"
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "LSP: Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				-- client.server_capabilities.semanticTokensProvider = nil -- prevent LSP highlighting
				-- Optional: per-client logic
				-- if client.name == "ts_ls" then
				--   -- Disable ts_ls formatting if using prettier
				--   client.server_capabilities.documentFormattingProvider = false
				-- end
			end,
		})
	end,
}
