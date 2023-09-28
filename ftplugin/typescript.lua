local nnoremap = require("user.keymap_utils").nnoremap
local tmux = require("user.lib.tmux")
local git = require("user.lib.git")
local quickfix = require("user.quickfix")

-- Set ruler
vim.opt.colorcolumn = "80"

-- Enable spell checking
vim.opt.spell = true

local function frontend_path()
	return git.path_relative_to_repo_root("/frontend")
end

--
-- Kebindings
--

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

-- [R]un [T]ypeScript: [d]ev
nnoremap("<Space>rd", function()
	tmux.run("cd " .. git.frontend_path() .. " && yarn dev")
end)
-- [R]un [T]ypeScript: [f]ormat
nnoremap("<Space>rf", function()
	tmux.run(
		"cd "
			.. git.frontend_path()
			.. " && yarn prettier $(git diff --relative --name-only HEAD) --write"
	)
end)
-- [R]un [T]ypeScript: [l]int
nnoremap("<Space>rl", function()
	tmux.run(
		"cd "
			.. git.frontend_path()
			.. " && "
			.. "yarn lint $(git diff --relative --name-only HEAD) --fix"
	)
end)
-- [R]un [T]ypeScript: [t]est
nnoremap("<Space>rt", function()
	tmux.run("cd " .. git.frontend_path() .. " && yarn test:unit " .. vim.fn.expand("%:p") .. " --watchAll")
end)
-- [R]un [T]ypeScript: type check
nnoremap("<Space>rx", function()
	tmux.run("cd " .. git.frontend_path() .. " && bun typecheck --watch")
end)
-- [R]un [T]ypeScript: [g]enerate protos
nnoremap("<Space>rg", function()
	tmux.run("cd " .. git.frontend_path() .. " && yarn protogen")
end)

-- [O]pen [t]est: Toggle between test file and implementation
nnoremap("<Space>ot", function()
  local current_filename = vim.fn.expand("%")

  local target_filename = ''
  if string.match(current_filename, ".*.test..*") then
    target_filename = string.gsub(current_filename, ".test.", ".")
  else
    target_filename = string.gsub(current_filename, ".ts", ".test.ts")
  end

  vim.cmd("e " .. target_filename)
end)
