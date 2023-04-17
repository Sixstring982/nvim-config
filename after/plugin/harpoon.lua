-- Harpoon: Mark files you'd like to visit regularly in an editing session.

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- <Space>m: Managed marked files
-- <Space>mm: Toggle file as marked
vim.keymap.set('n', '<Space>mm', function()
  mark.toggle_file(vim.fn.expand("%"))
end)

vim.keymap.set('n', '<Space>mz', function()
  mark.clear_all()
  print("Marks cleared")
end)

-- Browse marked files
require("telescope").load_extension("harpoon")
vim.keymap.set('n', '<Space>pm', "<cmd>Telescope harpoon marks<CR>")

-- Go to marked file by number
local harpoon_nav = function(n)
  return function()
  ui.nav_file(n)
  print("Opening harpoon file #" .. n)
  end
end

vim.keymap.set('n', '<leader>1', harpoon_nav(1))
vim.keymap.set('n', '<leader>2', harpoon_nav(2))
vim.keymap.set('n', '<leader>3', harpoon_nav(3))
vim.keymap.set('n', '<leader>4', harpoon_nav(4))
vim.keymap.set('n', '<leader>5', harpoon_nav(5))
vim.keymap.set('n', '<leader>6', harpoon_nav(6))
vim.keymap.set('n', '<leader>7', harpoon_nav(7))
vim.keymap.set('n', '<leader>8', harpoon_nav(8))
vim.keymap.set('n', '<leader>9', harpoon_nav(9))
vim.keymap.set('n', '<leader>0', harpoon_nav(10))
