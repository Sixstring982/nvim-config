local commands = require("user.commands")

-- Set leader key
vim.g.mapleader = ","

-- Find files in this directory
vim.keymap.set("n", "<C-x><C-f>", ":Ex<CR>")

-- Save the current file
vim.keymap.set("n", "<C-x><C-s>", ":w<CR>")

-- Open/close windows
vim.keymap.set("n", "<C-x>3", "<C-w><C-v><CR>")
vim.keymap.set("n", "<C-x>2", "<C-w><C-s><CR>")
vim.keymap.set("n", "<C-x>0", ":q<CR>")

-- Open the previous buffer
vim.keymap.set("n", "<Space><Tab>", ":b#<CR>")

-- Navigate between windows
vim.keymap.set("n", "<C-x>o", "<C-w>l")
vim.keymap.set("n", "<Space>1", "<cmd>:1wincmd w<CR>")
vim.keymap.set("n", "<Space>2", "<cmd>:2wincmd w<CR>")
vim.keymap.set("n", "<Space>3", "<cmd>:3wincmd w<CR>")
vim.keymap.set("n", "<Space>4", "<cmd>:4wincmd w<CR>")
vim.keymap.set("n", "<Space>5", "<cmd>:5wincmd w<CR>")
vim.keymap.set("n", "<Space>6", "<cmd>:6wincmd w<CR>")
vim.keymap.set("n", "<Space>7", "<cmd>:7wincmd w<CR>")
vim.keymap.set("n", "<Space>8", "<cmd>:8wincmd w<CR>")
vim.keymap.set("n", "<Space>9", "<cmd>:9wincmd w<CR>")

-- Open a terminal
vim.keymap.set("n", "<leader>ot", "<cmd>:e term://bash<CR>")

-- Page-up/down also centers screen
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- LSP keybindings
vim.keymap.set("n", "<Space>en", vim.diagnostic.goto_next)
vim.keymap.set("n", "<Space>ep", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<Space>gg", vim.lsp.buf.definition)
vim.keymap.set("n", "<Space>hh", vim.lsp.buf.hover)
vim.keymap.set("n", "<Space>rr", vim.lsp.buf.rename)

-- Send commands to the terminal
vim.keymap.set("n", "<Space>cC", function()
  local command = vim.fn.input("Command: ")
  commands.runInTmux(command)
end)
vim.keymap.set("n", "<Space>cr", function()
  commands.reRunInTmux()
end)
vim.keymap.set("n", "<Space>ck", function()
  commands.tmuxCtrlC()
end)
