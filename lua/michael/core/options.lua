vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.startofline = true

-- prevent keymapping timeout
-- opt.timeout = false

-- or simply increase timeout
opt.timeout = true
-- opt.timeoutlen = 300

-- tabs & indentation
opt.tabstop = 2 -- two spaces for tabs
opt.shiftwidth = 2 -- two spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- turn on termguicolors for tokyonight colorscheme to work
-- need to have a true color terminal
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system register as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- Remove auto comment continuation on newline
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "*",
--   callback = function()
--     vim.opt.formatoptions:remove({ "c", "r", "o" })
--   end,
-- })

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 200,
    }
  end,
})
