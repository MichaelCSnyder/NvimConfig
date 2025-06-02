return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp", -- facilitates communication between lsp and autocompletion
		{ "antosha417/nvim-lsp-file-operations", config = true }, -- modify imports when files have been renamed
		{ "folke/neodev.nvim", opts = {} }, -- add improved lua lsp functionality
	},
	event = { "BufReadPre", "BufNewFile" },
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
			},
			automatic_enable = false, -- elect to setup servers myself to be able to pass cmp (autocomplete) capabilities
		})

		local lspconfig = require("lspconfig")

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local standard_config_servers = {
			"ts_ls",
			"jsonls",
			"html",
			"cssls",
			"marksman",
		}

		-- setup LSPs with default configs
		for _, server in ipairs(standard_config_servers) do
			lspconfig[server].setup({
				capabilities = capabilities, -- allows autocompletion to source LSP data
			})
		end

		-- setup LSPs with custom configs
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

		-- testing diagnistics display. Adds in-line display.
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●", -- or another Nerd Font icon
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- not working
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

				client.server_capabilities.semanticTokensProvider = nil
				-- Optional: per-client logic
				-- if client.name == "ts_ls" then
				--   -- Disable ts_ls formatting if using prettier
				--   client.server_capabilities.documentFormattingProvider = false
				-- end
			end,
		})
	end,
}
