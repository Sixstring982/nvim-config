local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    path_display = "tail"
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

