return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				-- Conform will run the first available formatter
				javascript = { "prettierd" },
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 500,
			},
		})
	end,
}
