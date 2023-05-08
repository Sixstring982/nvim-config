local tmux = require("user.lib.tmux")
local git = require("user.lib.git")
local nnoremap = require("user.keymap_utils").nnoremap
local strings = require("user.lib.strings")
local quickfix = require("user.quickfix")

-- Set ruler
vim.opt.colorcolumn = "100"

-- Enable spell checking
vim.opt.spell = true

local function code_path()
	return git.path_relative_to_repo_root("")
end

-- Kebindings
--
-- [O]pen things
--
-- [O]pen corresponding ml/ml[i]
nnoremap("<Space>oi", function()
	local current_file = vim.fn.expand("%")
	local matching_file = strings.ends_with(current_file, "mli") and current_file:sub(-1, #current_file - 1)
		or current_file .. "i"

	vim.cmd("e " .. matching_file)
end)
-- [O]pen [d]une file in this directory
nnoremap("<Space>od", function()
	vim.cmd("e " .. vim.fn.expand("%:.:h") .. "/dune")
end)

--
-- [R]un things
--
-- [R]un [d]une build
nnoremap("<Space>rd", function()
	tmux.run("cd " .. code_path() .. " && dune build -w")
end)
-- [R]un dune build [h]ere
nnoremap("<Space>rh", function()
  tmux.run("cd " .. code_path() .. " && dune build " .. vim.fn.expand("%:.:h") .. " -w")
end)
-- [R]un dune [t]est
nnoremap("<Space>rt", function()
	tmux.run("cd " .. code_path() .. " && dune test " .. vim.fn.expand("%:.:h") .. " -w")
end)
-- [R]un dune @[f]mt
nnoremap("<Space>rf", function()
	tmux.run("cd " .. code_path() .. " && dune build @fmt --auto-promote")
end)
-- [R]un dune, populating errors for [q]uickfix
nnoremap("<Space>rq", function()
  print("Populating quickfix...")
  quickfix.populate_quickfix_with_command("cd " .. code_path() .. " && dune build", function(line)
    return line:match('File "(.+)", line (%d+), characters (%d+)-%d+:')
  end)
  print("Done.")
end)
