return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" }, -- only need treesitter when opening a new or existing buffer
  build = ":TSUpdate", -- updates all language parsers update when this plugin is updated
  dependencies = {
    "windwp/nvim-ts-autotag", -- provides auto-closing functionality for tags
  },
  config = function()
    -- import nvim-treesitter plugin
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (w/ nvim-ts-autotag plugin)
      autotag = {
        enable = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
        "javascript",
        "html",
        "css",
        "sql",
        "typescript",
        "json",
        "jsdoc",
        "gitignore",
        "xml",
        "vim",
        "lua",
        "markdown",
        "markdown_inline",
        "tsx",
        "yaml",
        "prisma",
        "svelte",
        "graphql",
        "bash",
        "dockerfile",
        "query",
        "vimdoc",
        "c",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
