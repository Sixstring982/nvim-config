local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Space>pp', builtin.find_files, {})
vim.keymap.set('n', '<Space>ph', builtin.git_files, {})
vim.keymap.set('n', '<Space>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<C-x>b', builtin.buffers, {})
