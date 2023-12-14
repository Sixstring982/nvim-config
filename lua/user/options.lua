-- Enable relative line numbers
vim.opt.nu = true
vim.opt.rnu = true

-- Set tabs to 2 spaces
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Enable folding via markers
vim.opt.foldmethod = "marker"
vim.opt.foldlevel = 1

-- Visible whitespace
vim.opt.listchars:append({
	trail = "▒",
	tab = ">-",
	nbsp = "␣",
})
vim.opt.list = true
-- Highlight trailing whitespace in red
vim.cmd([[match errorMsg /\s\+$/]])
