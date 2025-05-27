return {
  "f-person/git-blame.nvim",
  -- load the plugin at startup
  event = "VeryLazy",
  config = function()
    vim.g.gitblame_enabled = false -- start disabled
    vim.g.gitblame_date_format = "%r" -- start disabled

    vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>")
  end

}
