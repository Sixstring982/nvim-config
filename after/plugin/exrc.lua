-- disable built-in local config file support, as this functionality is replaced by exrc.nvim.
vim.o.exrc = false

require("exrc").setup({
  files = {
    ".nvimrc.lua",
    ".nvimrc",
    ".exrc.lua",
    ".exrc",
  },
})
