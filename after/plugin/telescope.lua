local actions = require("telescope.actions")

require("telescope").setup({
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

