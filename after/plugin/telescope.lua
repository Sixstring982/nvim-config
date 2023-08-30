local actions = require("telescope.actions")

require("telescope").setup({
  file_ignore_patterns = {
    "cue.mod",
    "node_modules",
    "yarn.lock",
  },
  pickers = {
    buffers = {
      mappings = {
        n = {
          ["d"] = "delete_buffer"
        }
      }
    }
  }
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

