vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "javascript", "typescriptreact" },
  callback = function()
    -- Set ruler
    vim.opt.colorcolumn = "80"

    -- Enable spell checking
    vim.opt.spell = true
  end
})
