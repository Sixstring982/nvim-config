local tmux = require("user.lib.tmux")
local git = require("user.lib.git")

-- Set ruler
vim.opt.colorcolumn = "80"
--
-- Enable spell checking
vim.opt.spell = true


local function skolem_dot_com_path()
	return git.path_relative_to_repo_root("/sites/skolem.com")
end


vim.keymap.set('n', '<Space>rd', function()
  tmux.run("cd " .. skolem_dot_com_path() .. " && yarn dev")
end)
