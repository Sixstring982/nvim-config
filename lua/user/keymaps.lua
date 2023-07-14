local git = require("user.lib.git")
local nnoremap = require("user.keymap_utils").nnoremap
local tmux = require("user.lib.tmux")

vim.g.mapleader = ","

-- Window splitting
nnoremap("<C-x>0", "<C-w>q")
nnoremap("<C-x>2", "<C-w>s")
nnoremap("<C-x>3", "<C-w>v")

-- Jump to windows at specific indices
nnoremap("<Space>1", "<C-w>1w")
nnoremap("<Space>2", "<C-w>2w")
nnoremap("<Space>3", "<C-w>3w")
nnoremap("<Space>4", "<C-w>4w")
nnoremap("<Space>5", "<C-w>5w")
nnoremap("<Space>6", "<C-w>6w")

-- Open alternate buffer
nnoremap("<Space><Tab>", ":b#<CR>")

-- Opening files
nnoremap("<Space>ph", "<cmd>lua require('telescope.builtin').git_files()<CR>")
nnoremap("<Space>pp", "<cmd>lua require('telescope.builtin').find_files()<CR>")
nnoremap("<C-x>b", "<cmd>lua require('telescope.builtin').buffers()<CR>")
-- Fuzzy-find + grep
nnoremap("<Space>ps", "<cmd>lua require('telescope.builtin').grep_string()<CR>")
nnoremap("<Space>pl", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
-- Query LSP errors
nnoremap("<Space>pq", "<cmd>lua require('telescope.builtin').diagnostics()<CR>")

-- Format current buffer
nnoremap("<leader>f", "<cmd> lua vim.lsp.buf.format()<CR>")

-- Save file
nnoremap("<C-x><C-s>", ":w<CR>")

-- Open files
nnoremap("<C-x><C-f>", ":Ex<CR>/")

-- Close buffer
nnoremap("<C-x>k", ":bp<BAR>:bd#<CR>")

-- Go to next error
nnoremap("<Space>en", "<cmd>lua vim.diagnostic.goto_next()<CR>")
nnoremap("<Space>ep", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

-- Redo layout
vim.api.nvim_create_user_command("Relayout", function()
  -- Close all windows
  vim.cmd("only")

  vim.cmd("vsplit")
  vim.cmd("vsplit")
  vim.cmd("windo2")
  require("harpoon.term").gotoTerminal(1)
  vim.api.nvim_win_set_width(0, 99)
  vim.cmd("windo0")
end, { force = true })

-- Fix errors
nnoremap("<Space>aa", "<cmd>lua vim.lsp.buf.code_action()<CR>")
nnoremap("<Space>af", function()
  vim.lsp.buf.code_action({
    filter = function(a)
      return a.isPreferred
    end,
    apply = true
  })
end)


-- Rename
nnoremap("<Space>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")

-- Check definition
nnoremap("<Space>hh", "<cmd>lua vim.lsp.buf.hover()<CR>")

-- Go to definition (and focus in the middle of the screen)
nnoremap("<Space>gg", "<cmd>lua vim.lsp.buf.definition()<CR>zz")
-- See usages
nnoremap("<Space>gu", "<cmd>lua require('telescope.builtin').lsp_references()<CR>")

-- Center screen when using page-up/down
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
-- Center screen when using up/down-paragraph
nnoremap("{", "{zz")
nnoremap("}", "}zz")

-- Tmux window
--
-- Open the terminal
-- Bound to <Space>ot in ../../after/plugin/toggleterm.lua
--
-- Stop anything in the tmux window
nnoremap("<Space>ck", function()
  tmux.ctrl_c()
end)

-- Send anything to the tmux window
nnoremap("<Space>cC", function()
  local command = vim.fn.input("Compile command: ")
  tmux.run(command)
end)
-- Re-send the last verbatim command
nnoremap("<Space>cr", function()
  tmux.re_run()
end)

-- Git commands
--
-- [G]it [s]tatus (open Fugitive)
nnoremap("<Space>gs", "<cmd>Gedit :<CR>")
-- [G]it [d]iff (for fixing merge conflicts)
nnoremap("<Space>gd", function()
  -- Open a new tab focusing the current file...
  vim.cmd("tab split")
  vim.cmd("Gvdiffsplit!")
end)

--
-- Run commands
--

--
-- OCaml
--
-- [R]un [O]Caml: [b]uild
nnoremap("<Space>rod", function()
	tmux.run("cd " .. git.code_path() .. " && dune build -w")
end)
-- [R]un [O]Caml: build [h]ere
nnoremap("<Space>roh", function()
  tmux.run("cd " .. git.code_path() .. " && dune build " .. vim.fn.expand("%:.:h") .. " -w")
end)
-- [R]un [O]Caml: [t]est
nnoremap("<Space>rot", function()
	tmux.run("cd " .. git.code_path() .. " && dune test " .. vim.fn.expand("%:.:h") .. " -w")
end)
-- [R]un [O]Caml: [f]ormat
nnoremap("<Space>rof", function()
	tmux.run("cd " .. git.code_path() .. " && dune build @fmt --auto-promote")
end)

--
-- TypeScript
--
-- [R]un [T]ypeScript: [d]ev
nnoremap("<Space>rtd", function()
	tmux.run("cd " .. git.frontend_path() .. " && yarn dev")
end)
-- [R]un [T]ypeScript: [f]ormat
nnoremap("<Space>rtf", function()
	tmux.run(
		"cd "
			.. git.frontend_path()
			.. " && yarn prettier $(git diff --relative --name-only HEAD) --write"
	)
end)
-- [R]un [T]ypeScript: [l]int
nnoremap("<Space>rtl", function()
	tmux.run(
		"cd "
			.. git.frontend_path()
			.. " && "
			.. "yarn lint $(git diff --relative --name-only HEAD) --fix"
	)
end)
-- [R]un [T]ypeScript: [t]est
nnoremap("<Space>rtt", function()
	tmux.run("cd " .. git.frontend_path() .. " && yarn test:unit " .. vim.fn.expand("%:p") .. " --watchAll")
end)
-- [R]un [T]ypeScript: type check
nnoremap("<Space>rtx", function()
	tmux.run("cd " .. git.frontend_path() .. " && yarn typecheck --watch")
end)
-- [R]un [T]ypeScript: [g]enerate protos
nnoremap("<Space>rtg", function()
	tmux.run("cd " .. git.frontend_path() .. " && yarn protogen")
end)
