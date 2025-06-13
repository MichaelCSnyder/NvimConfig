-- set leader key to space
vim.g.mapleader = " "

vim.opt.startofline = true

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<leader>p", '"0p')

-- clear search highlights
vim.keymap.set("n", "<leader><leader>", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- tab management
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
-- keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
vim.keymap.set("n", "<C-k>", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
vim.keymap.set("n", "<C-j>", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
vim.keymap.set("n", "<A-k>", "<cmd>+tabm<CR>", { desc = "Move tab to the right" }) --  go to previous tab
vim.keymap.set("n", "<A-j>", "<cmd>-tabm<CR>", { desc = "Move tab to the left" }) --  go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>s", function()
	local word = vim.fn.expand("<cword>")
	return string.format(":%s/%s/%s/gI", "%s", "\\<" .. word .. "\\>", word)
end, { expr = true })

-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})
