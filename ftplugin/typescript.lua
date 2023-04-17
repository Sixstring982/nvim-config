local nnoremap = require("user.keymap_utils").nnoremap
local tmux = require("user.lib.tmux")
local git = require("user.lib.git")

-- Set ruler
vim.opt.colorcolumn = "80"
--
-- Enable spell checking
vim.opt.spell = true

local function frontend_path()
	return git.path_relative_to_repo_root("/frontend")
end

--
-- Kebindings
--
nnoremap("<Space>rd", function()
	tmux.run("cd " .. frontend_path() .. " && yarn dev")
end)

nnoremap("<Space>rl", function()
	tmux.run(
		"cd "
			.. frontend_path()
			.. " && "
			.. "yarn lint ./api ./components ./library ./models ./pages ./state ./stories/"
	)
end)
nnoremap("<Space>rt", function()
	tmux.run("cd " .. frontend_path() .. " && yarn test:unit " .. vim.fn.expand("%:.:h") .. " --watchAll")
end)
nnoremap("<Space>rx", function()
	tmux.run("cd " .. frontend_path() .. " && yarn typecheck --watch")
end)
