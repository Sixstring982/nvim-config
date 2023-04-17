local actions = require("telescope.actions")

require("telescope").setup({
  file_ignore_patterns = {
    "cue.mod",
    "node_modules",
    "yarn.lock",
  }
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

