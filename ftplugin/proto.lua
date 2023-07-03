local git = require("user.lib.git")
local nnoremap = require("user.keymap_utils").nnoremap
local tmux = require("user.lib.tmux")

-- Set ruler
vim.opt.colorcolumn = "80"
--
-- Enable spell checking
vim.opt.spell = true

local function code_path()
	return git.path_relative_to_repo_root("")
end

-- [R]un buf [f]romat
nnoremap("<Space>rf", function()
	tmux.run("cd " .. code_path() .. " && buf format --path skproto -w")
end)
