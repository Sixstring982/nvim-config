local tmux = require("user.lib.tmux")
local git = require("user.lib.git")
local nnoremap = require("user.keymap_utils").nnoremap
local strings = require("user.lib.strings")
local quickfix = require("user.quickfix")

-- Set ruler
vim.opt.colorcolumn = "100"

-- Enable spell checking
vim.opt.spell = true

-- Kebindings
--
-- [O]pen things
--
-- [O]pen corresponding ml/ml[i]
nnoremap("<Space>oi", function()
	local current_file = vim.fn.expand("%")

	local matching_file =
    strings.ends_with(current_file, "mli")
    and current_file:sub(-1, #current_file - 1)
		or current_file .. "i"

	vim.cmd("e " .. matching_file)
end)
-- [O]pen [d]une file in this directory
nnoremap("<Space>od", function()
	vim.cmd("e " .. vim.fn.expand("%:.:h") .. "/dune")
end)
