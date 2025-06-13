return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			direction = "float",
			float_opts = {
				border = "rounded",
			},
		})

		-- Make <Esc> leave terminal mode
		vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
		vim.keymap.set({ "n", "t" }, "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "toggle terminal" })
	end,
}
