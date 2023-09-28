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

	local matching_file = ''
  if string.match(current_file, ".mli$") then
    matching_file = string.gsub(current_file, ".mli$", ".ml")
  else
    matching_file = string.gsub(current_file, ".ml$", ".mli")
  end

	vim.cmd("e " .. matching_file)
end)
-- [O]pen [d]une file in this directory
nnoremap("<Space>od", function()
	vim.cmd("e " .. vim.fn.expand("%:.:h") .. "/dune")
end)

-- [R]un [O]Caml: [b]uild
nnoremap("<Space>rb", function()
	tmux.run("cd " .. git.code_path() .. " && dune build -w")
end)
-- [R]un [O]Caml: build [h]ere
nnoremap("<Space>rh", function()
  tmux.run("cd " .. git.code_path() .. " && dune build " .. vim.fn.expand("%:.:h") .. " -w")
end)
-- [R]un [O]Caml: [t]est
nnoremap("<Space>rt", function()
	tmux.run("cd " .. git.code_path() .. " && dune test " .. vim.fn.expand("%:.:h") .. " -w")
end)
-- [R]un [O]Caml: [f]ormat
nnoremap("<Space>rf", function()
	tmux.run("cd " .. git.code_path() .. " && dune build @fmt --auto-promote")
end)
