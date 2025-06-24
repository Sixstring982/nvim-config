local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    go = { "gofmt" },
    haskell = { "ormolu" },
    rust = { "rustfmt" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
  }
})
