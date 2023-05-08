local nnoremap = require("user.keymap_utils").nnoremap
local tmux = require("user.lib.tmux")
local git = require("user.lib.git")
local quickfix = require("user.quickfix")

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
-- [R]un yarn [d]ev
nnoremap("<Space>rd", function()
	tmux.run("cd " .. frontend_path() .. " && yarn dev")
end)
-- [R]un [f]ormatter (prettier)
nnoremap("<Space>rf", function()
	tmux.run(
		"cd "
			.. frontend_path()
			.. " && yarn prettier  ./api ./components ./library ./models ./pages ./state ./stories/ --write"
	)
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
-- [R]un tsc, populating errors for [q]uickfix
nnoremap("<Space>rq", function()
	print("Populating quickfix...")
	quickfix.populate_quickfix_with_command("cd " .. frontend_path() .. " && yarn typecheck", function(line)
		local filename, line, column, message = line:match("^(.+)%((%d+),(%d+)%)%s*:%s*(.+)$")
		if filename ~= nil then
			local new_filename = frontend_path() .. "/" .. filename
			return new_filename, line, column, message
		end
		return nil
	end)
	print("Done.")
end)
